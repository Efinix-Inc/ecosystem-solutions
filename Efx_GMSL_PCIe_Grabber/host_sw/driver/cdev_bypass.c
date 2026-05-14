#include <linux/types.h>
#include <asm/cacheflush.h>
#include <linux/slab.h>
#include <linux/aio.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/kthread.h>
#include <linux/version.h>

#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"

#define write_register(v, mem, off) iowrite32(v, mem)

static int copy_desc_data(struct edma_transfer *transfer, char __user *buf,
		size_t *buf_offset, size_t buf_size)
{
	int i;
	int copy_err;
	int ret = 0;

	if (!buf) {
		pr_err("[ERROR] Invalid user buffer\n");
		return -EINVAL;
	}

	if (!buf_offset) {
		pr_err("[ERROR] Invalid user buffer offset\n");
		return -EINVAL;
	}

	/* Fill user buffer with descriptor data */
	for (i = 0; i < transfer->desc_num; i++) {
		if (*buf_offset + sizeof(struct edma_desc) <= buf_size) {
			copy_err = copy_to_user(&buf[*buf_offset],
				transfer->desc_virt + i,
				sizeof(struct edma_desc));

			if (copy_err) {
				pr_err("[ERROR] Copy to user buffer failed\n");
				*buf_offset = buf_size;
				ret = -EINVAL;
			} else {
				*buf_offset += sizeof(struct edma_desc);
			}
		} else {
			ret = -ENOMEM;
		}
	}

	return ret;
}

static ssize_t char_bypass_read(struct file *file, char __user *buf,
		size_t count, loff_t *pos)
{
	struct edma_pci_dev *epdev;
	struct edma_engine *engine;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_transfer *transfer;
	struct list_head *idx;
	size_t buf_offset = 0;
	int ret = 0;

	epdev = ecdev->epdev;
	engine = ecdev->engine;

	pr_info("[DBG] In %s()\n", __func__);

	if (count & 3) {
		pr_err("[ERROR] Buffer size must be a multiple of 4 bytes\n");
		return -EINVAL;
	}

	if (!buf) {
		pr_err("[ERROR] Caught NULL pointer\n");
		return -EINVAL;
	}

	if (epdev->bypass_bar_idx < 0) {
		pr_err("[ERROR] Bypass BAR not present - unsupported operation\n");
		return -ENODEV;
	}

	spin_lock(&engine->lock);

	if (!list_empty(&engine->transfer_list)) {
		list_for_each(idx, &engine->transfer_list) {
			transfer = list_entry(idx, struct edma_transfer, entry);

			ret = copy_desc_data(transfer, buf, &buf_offset, count);
		}
	}

	spin_unlock(&engine->lock);

	if (ret < 0)
		return ret;
	else
		return buf_offset;
}

static ssize_t char_bypass_write(struct file *file, const char __user *buf,
		size_t count, loff_t *pos)
{
	struct edma_pci_dev *epdev;
	struct edma_engine *engine;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	uint32_t desc_data;
	void __iomem *bypass_addr;
	size_t buf_offset = 0;
	int ret = 0;
	int copy_err;

	epdev = ecdev->epdev;
	engine = ecdev->engine;

	if (count & 3) {
		pr_err("[ERROR] Buffer size must be a multiple of 4 bytes\n");
		return -EINVAL;
	}

	if (!buf) {
		pr_err("[ERROR] Caught NULL pointer\n");
		return -EINVAL;
	}

	if (epdev->bypass_bar_idx < 0) {
		pr_err("[ERROR] Bypass BAR not present - unsupported operation\n");
		return -ENODEV;
	}

	pr_info("[DBG] In %s()\n", __func__);

	spin_lock(&engine->lock);

	/* Write descriptor data to the bypass BAR */
	bypass_addr = epdev->bar[epdev->bypass_bar_idx];
	bypass_addr = (void __iomem *)(
			(uint32_t __iomem *)bypass_addr + engine->bypass_offset
			);
	while (buf_offset < count) {
		copy_err = copy_from_user(&desc_data, &buf[buf_offset],
			sizeof(uint32_t));
		if (!copy_err) {
			write_register(desc_data, bypass_addr,
					bypass_addr - engine->bypass_offset);
			buf_offset += sizeof(uint32_t);
			ret = buf_offset;
		} else {
			pr_err("[ERROR] Error reading data from userspace buffer\n");
			ret = -EINVAL;
			break;
		}
	}

	spin_unlock(&engine->lock);

	return ret;
}


/*
 * character device file operations for bypass operation
 */

static const struct file_operations bypass_fops = {
	.owner = THIS_MODULE,
	.open = char_open,
	.release = char_close,
	.read = char_bypass_read,
	.write = char_bypass_write,
	.mmap = bridge_mmap,
};

void cdev_bypass_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &bypass_fops);
}
