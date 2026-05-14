#include <linux/types.h>
#include <asm/cacheflush.h>
#include <linux/slab.h>
#include <linux/aio.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/kthread.h>
#include <linux/version.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 16, 0)
#include <linux/uio.h>
#endif
#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"

#define SGDMA_DIR_WRITE		1
#define SGDMA_DIR_READ		0

static int check_transfer_align(struct edma_engine *engine,
	const char __user *buf, size_t count, loff_t pos, int sync)
{
	if (!engine) {
		pr_err("[ERROR] Invalid DMA engine\n");
		return -EINVAL;
	}

	/* AXI ST or AXI MM non-incremental addressing mode? */
	if (engine->non_incr_addr) {
		int buf_lsb = (int)((uintptr_t)buf) & (engine->addr_align - 1);
		size_t len_lsb = count & ((size_t)engine->len_granularity - 1);
		int pos_lsb = (int)pos & (engine->addr_align - 1);

		pr_info("[DBG] AXI ST or MM non-incremental\n");
		pr_info("[DBG] buf_lsb = %d, pos_lsb = %d, len_lsb = %ld\n", buf_lsb,
			pos_lsb, len_lsb);

		if (buf_lsb != 0) {
			pr_err("[ERROR] non-aligned buffer address %p\n", buf);
			return -EINVAL;
		}

		if ((pos_lsb != 0) && (sync)) {
			pr_err("[ERROR] non-aligned AXI MM FPGA addr 0x%llx\n",
				(unsigned long long)pos);
			return -EINVAL;
		}

		if (len_lsb != 0) {
			pr_err("[ERROR] len %d is not a multiple of %d\n",
				(int)count,
				(int)engine->len_granularity);
			return -EINVAL;
		}
		/* AXI MM incremental addressing mode */
	} else {
		int buf_lsb = (int)((uintptr_t)buf) & (engine->addr_align - 1);
		int pos_lsb = (int)pos & (engine->addr_align - 1);

		if (buf_lsb != pos_lsb) {
			pr_err("[ERROR] Misalignment error\n");
			pr_err("[ERROR] host addr %p, FPGA addr 0x%llx\n", buf, pos);
			return -EINVAL;
		}
	}

	return 0;
}

static void unmap_user_buf(struct edma_io_cb *cb, bool write)
{
	int i;

	sg_free_table(&cb->sgt);
	if (!cb->pages || !cb->pages_nr) return;

	for (i = 0; i < cb->pages_nr; i++) {
		if (cb->pages[i]) {
			if (!write)
				set_page_dirty_lock(cb->pages[i]);
			put_page(cb->pages[i]);
		} else {
			break;
		}
	}

	if (i != cb->pages_nr)
	pr_info("sgl pages %d/%llu.\n", i, cb->pages_nr);

	kfree(cb->pages);
	cb->pages = NULL;
	return;
}

static void char_sgdma_unmap_user_buf(struct edma_io_cb *cb, bool write)
{
	int i;

	sg_free_table(&cb->sgt);

	if (!cb->pages || !cb->pages_nr)
		return;

	for (i = 0; i < cb->pages_nr; i++) {
		if (cb->pages[i]) {
			if (!write)
				set_page_dirty_lock(cb->pages[i]);
			put_page(cb->pages[i]);
		} else
			break;
	}

	if (i != cb->pages_nr)
		pr_info("sgl pages %d/%llu.\n", i, cb->pages_nr);

	kfree(cb->pages);
	cb->pages = NULL;
}

static int map_user_buf_to_sgl(struct edma_io_cb *cb, bool write)
{
	int i;
	int ret;
	void __user *buf = cb->buf;
	struct scatterlist *sg;
	struct sg_table *sgt = &cb->sgt;
	size_t len = cb->len;
	uint64_t pages_nr = (((uint64_t)buf + len + PAGE_SIZE - 1) - ((uint64_t)buf & PAGE_MASK)) >> PAGE_SHIFT;

	if (!pages_nr)
		return -EINVAL;

	if (sg_alloc_table(sgt, pages_nr, GFP_KERNEL)) {
		pr_err("[ERROR] map sgl FAILED, due to Out Of Memory.\n");
		return -ENOMEM;
	}

	cb->pages = kcalloc(pages_nr, sizeof(struct page *), GFP_KERNEL);
	if (!cb->pages) {
		pr_err("[ERROR] kcalloc pages FAILED, due to OOM.\n");
		ret = -ENOMEM;
		goto err_out;
	}

	ret = get_user_pages_fast((uint64_t)buf, pages_nr, SGDMA_DIR_WRITE, cb->pages);
	/* No pages were pinned */
	if (ret < 0) {
		pr_err("[ERROR] unable to pin down %llu user pages, %d.\n", pages_nr, ret);
		goto err_out;
	}
	/* Less pages pinned than wanted */
	if (ret != pages_nr) {
		pr_err("[ERROR] unable to pin down all %llu user pages, %d.\n", pages_nr, ret);
		cb->pages_nr = ret;
		ret = -EFAULT;
		goto err_out;
	}

	for (i = 1; i < pages_nr; i++) {
		if (cb->pages[i - 1] == cb->pages[i]) {
			pr_err("[ERROR] duplicate pages, %d, %d.\n", i - 1, i);
			ret = -EFAULT;
			cb->pages_nr = pages_nr;
			goto err_out;
		}
	}

	sg = sgt->sgl;
	
	for (i = 0; i < pages_nr; i++, sg = sg_next(sg)) {
		uint64_t offset = offset_in_page(buf);
		uint64_t nbytes = min_t(unsigned int, PAGE_SIZE - offset, len);

		flush_dcache_page(cb->pages[i]);
		sg_set_page(sg, cb->pages[i], nbytes, offset);
		buf += nbytes;
		len -= nbytes;
	}

	if (len) {
		pr_err("[ERROR] Invalid user buffer length. Cannot map to sgl\n");
		return -EINVAL;
	}
	cb->pages_nr = pages_nr;

	return 0;
err_out:
	char_sgdma_unmap_user_buf(cb, write);

	return ret;
}


static ssize_t do_char_sgdma(struct file *file, const char __user *buf, size_t count, loff_t *pos, bool write)
{
	int ret;
	ssize_t done_size = 0;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_engine *engine;
	struct edma_io_cb cb;

	engine = ecdev->engine;

	//pr_info("[DBG] file 0x%p, priv 0x%p, buf 0x%p,%llu, pos %llu, W %d, %s.\n", 
	//	file, file->private_data, buf, (uint64_t)count, (uint64_t)*pos, write, engine->name);

	if ((write && engine->dir != DMA_TO_DEVICE) || (!write && engine->dir != DMA_FROM_DEVICE)) {
		pr_err("[ERROR] r/w mismatch. W %d, engine dir %d.\n",	write, engine->dir);
		return -EINVAL;
	}

	ret = check_transfer_align(engine, buf, count, *pos, 1);
	if (ret) {
		pr_info("Invalid transfer alignment detected\n");
		return ret;
	}

	memset(&cb, 0, sizeof(struct edma_io_cb));
	cb.buf = (char __user *)buf;
	cb.len = count;
	cb.ep_addr = (u64)*pos;
	cb.write = write;
	ret = map_user_buf_to_sgl(&cb, write);
	if (ret < 0)
		return ret;
	
	// speed test
	//engine->m_start_time = get_jiffies_64();
	done_size = edma_submit_request(ecdev->engine, *pos, &cb.sgt, 0);	
	//engine->m_end_time = get_jiffies_64();
	//pr_info("[LINC] speed test >>> start=%lld, end=%lld\n", engine->m_start_time, get_jiffies_64());
	//dbg_set_trans_jiffies(done_size, engine->m_end_time - engine->m_start_time);
	unmap_user_buf(&cb, write);
	
	return done_size;
}


static ssize_t char_sgdma_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
{
	return do_char_sgdma(file, buf, count, pos, SGDMA_DIR_WRITE);
}

static ssize_t char_sgdma_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
{
	return do_char_sgdma(file, buf, count, pos, SGDMA_DIR_READ);
}

static int char_sgdma_open(struct inode *inode, struct file *file)
{
	struct edma_cdev *ecdev;
	struct edma_engine *engine;

	char_open(inode, file);

	ecdev = (struct edma_cdev *)file->private_data;
	engine = ecdev->engine;

	if (engine->streaming && engine->dir == DMA_FROM_DEVICE) {
		if (engine->device_open == 1)
			return -EBUSY;
		
		engine->device_open = 1;
		engine->eop_flush = (file->f_flags & O_TRUNC) ? 1 : 0;
	}

	return 0;
}

static int char_sgdma_close(struct inode *inode, struct file *file)
{
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_engine *engine;

	engine = ecdev->engine;

	if (engine->streaming && engine->dir == DMA_FROM_DEVICE)
		engine->device_open = 0;

	return 0;
}

/*
 * character device file operations for SG DMA engine
 */
static loff_t char_sgdma_llseek(struct file *file, loff_t off, int whence)
{
	loff_t newpos = 0;

	switch (whence) {
	case 0: /* SEEK_SET */
		newpos = off;
		break;
	case 1: /* SEEK_CUR */
		newpos = file->f_pos + off;
		break;
	case 2: /* SEEK_END, @TODO should work from end of address space */
		newpos = UINT_MAX + off;
		break;
	default: /* can't happen */
		return -EINVAL;
	}
	if (newpos < 0)
		return -EINVAL;
	file->f_pos = newpos;
	//pr_info("%s: pos=%lld\n", __func__, (signed long long)newpos);

	return newpos;
}

static const struct file_operations sgdma_fops = {
	.owner = THIS_MODULE,
	.open = char_sgdma_open,
	.release = char_sgdma_close,
	.write = char_sgdma_write,
	.read = char_sgdma_read,
	.llseek = char_sgdma_llseek,
};


void cdev_sgdma_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &sgdma_fops);
	return;
}

