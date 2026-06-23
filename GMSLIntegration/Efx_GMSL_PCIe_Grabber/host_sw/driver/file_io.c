#include "dma.h"
#include "common.h"
#include "cdev_ioctl.h"
#include "file_io.h"

static int mmap_bar = -1;
module_param(mmap_bar, int, 0644);
MODULE_PARM_DESC(mmap_bar, "Set index for mmaping resource[0-5]");

static struct class *g_edma_class = NULL;
struct kmem_cache *cdev_cache;

static const char *const devnode_names[] = {
	 EDMA_NODE_NAME "%d_user",
	 EDMA_NODE_NAME "%d_control",
	 EDMA_NODE_NAME "%d_events_%d",
	 EDMA_NODE_NAME "%d_htc_%d",
	 EDMA_NODE_NAME "%d_cth_%d",
	 EDMA_NODE_NAME "%d_bypass_htc_%d",
	 EDMA_NODE_NAME "%d_bypass_cth_%d",
	 EDMA_NODE_NAME "%d_bypass",
};

static inline void set_flag(enum cdev_type fbit, struct efx_pci_dev *epdev)
{
	epdev->flags |= (1 << fbit);
}

static inline void clear_flag(enum cdev_type fbit, struct efx_pci_dev *epdev)
{
	epdev->flags &= ~(1 << fbit);
}

static inline int check_flag(enum cdev_type fbit, struct efx_pci_dev *epdev)
{
	return epdev->flags & (1 << fbit);
}

static int init_kobject(enum cdev_type type, struct edma_cdev *ecdev)
{
	int ret = -EINVAL;
	struct edma_engine *engine = ecdev->engine;

	switch (type)
	{
	case EFX_FILE_HTC:
	case EFX_FILE_CTH:
	case EFX_BYPASS_HTC:
	case EFX_BYPASS_CTH:
		if (!engine)
		{
			pr_err("[ERROR] Invalid DMA engine\n");
			return ret;
		}
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type],
									  ecdev->epdev->idx, engine->channel);
		break;
	case EFX_BYPASS:
	case EFX_FILE_USER:
	case EFX_FILE_CTRL:
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type],
									  ecdev->epdev->idx);
		break;
	case EFX_FILE_EVENTS:
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type],
									  ecdev->epdev->idx, ecdev->bar);
		break;
	default:
		pr_warn("%s: UNKNOWN type 0x%x.\n", __func__, type);
		break;
	}
	if (ret)
		pr_err("%s: type 0x%x, failed %d.\n", __func__, type, ret);
	return ret;
}

static int sys_dev(enum cdev_type type, struct edma_cdev *ecdev)
{
	struct edma_engine *engine = ecdev->engine;
	int last_param;

	if (type == EFX_FILE_EVENTS)
		last_param = ecdev->bar;
	else
		last_param = engine ? engine->channel : 0;

	ecdev->sys_device = device_create(g_edma_class, &ecdev->epdev->pdev->dev,
												 ecdev->cdevno, NULL, devnode_names[type], ecdev->epdev->idx,
												 last_param);

	if (!ecdev->sys_device)
	{
		pr_err("[ERROR] device_create(%s) failed\n", devnode_names[type]);
		return -1;
	}

	return 0;
}

static int des_dev(struct edma_cdev *ecdev)
{
	if (!ecdev)
	{
		pr_warn("[ERROR] cdev NULL.\n");
		return -EINVAL;
	}

	if (!ecdev->epdev)
	{
		pr_err("[ERROR] efx pcie dev NULL\n");
		return -EINVAL;
	}
#if 1
	if (!g_edma_class)
	{
		pr_err("[ERROR] g_edma_class NULL\n");
		return -EINVAL;
	}

	if (!ecdev->sys_device)
	{
		pr_err("[ERROR] cdev sys_device NULL\n");
		return -EINVAL;
	}

	if (ecdev->sys_device)
		device_destroy(g_edma_class, ecdev->cdevno);
#endif
	cdev_del(&ecdev->cdev);

	return 0;
}

static int create_character_device(struct edma_engine *engine, struct efx_pci_dev *epdev,
											  int bar, enum cdev_type type, struct edma_cdev *ecdev)
{
	int ret;
	int minor;
	dev_t dev;

	// Initialize spinlock for thread safety
	spin_lock_init(&ecdev->lock);

	// Check if this is the first instance (major number not yet allocated)
	if (epdev->major == 0)
	{

		ret = alloc_chrdev_region(&dev, EDMA_MINOR_BASE, EDMA_MINOR_COUNT, EDMA_NODE_NAME);
		if (ret)
		{
			pr_err("[ERROR] Failed to allocate character device region %d.\n", ret);
			return ret;
		}
		epdev->major = MAJOR(dev);
	}

	ecdev->magic = MAGIC_CHAR;
	ecdev->cdev.owner = THIS_MODULE;
	ecdev->epdev = epdev;
	ecdev->engine = engine;
	ecdev->bar = bar;

	ret = init_kobject(type, ecdev);
	if (ret < 0)
		return ret;

	switch (type)
	{
	case EFX_FILE_USER:
	case EFX_FILE_CTRL:
		minor = type;
		ctrl_init(ecdev);
		break;
	case EFX_FILE_HTC:
		minor = 32 + engine->channel;
		sgd_init(ecdev);
		break;
	case EFX_FILE_CTH:
		minor = 36 + engine->channel;
		sgd_init(ecdev);
		break;
	case EFX_FILE_EVENTS:
		minor = 10 + bar;
		event_init(ecdev);
		break;
	case EFX_BYPASS_HTC:
		minor = 64 + engine->channel;
		bypass_init(ecdev);
		break;
	case EFX_BYPASS_CTH:
		minor = 68 + engine->channel;
		bypass_init(ecdev);
		break;
	case EFX_BYPASS:
		minor = 100;
		bypass_init(ecdev);
		break;
	default:
		pr_info("type 0x%x NOT supported.\n", type);
		return -EINVAL;
	}
	ecdev->cdevno = MKDEV(epdev->major, minor);

	ret = cdev_add(&ecdev->cdev, ecdev->cdevno, 1);
	if (ret < 0)
	{
		pr_err("[ERROR] cdev_add failed %d, type 0x%x.\n", ret, type);
		goto unregister_region;
	}

	pr_info("[DBG] ecdev 0x%p, %u:%u, %s, type 0x%x.\n", ecdev, epdev->major, minor, ecdev->cdev.kobj.name, type);
	/* create device on our class */
	if (g_edma_class)
	{
		ret = sys_dev(type, ecdev);
		if (ret < 0)
			goto del_cdev;
	}
	return 0;

del_cdev:
	cdev_del(&ecdev->cdev);
unregister_region:
	unregister_chrdev_region(ecdev->cdevno, EDMA_MINOR_COUNT);
	return ret;
}

int init_cdev(void)
{
#if KERNEL_VERSION(6, 4, 0) <= LINUX_VERSION_CODE
	g_edma_class = class_create("edma");
#else
	g_edma_class = class_create(THIS_MODULE, "edma");
#endif
	if (IS_ERR(g_edma_class))
	{
		pr_err("[ERROR] failed to create EDMA class.");
		return -EINVAL;
	}
#if 0
	/* using kmem_cache_create to enable sequential cleanup */
	cdev_cache = kmem_cache_create("cdev_cache", 
									sizeof(struct cdev_async_io), 0,
									SLAB_HWCACHE_ALIGN, NULL);

	if (!cdev_cache) {
		pr_err("[ERROR] memory allocation for cdev_cache failed. OOM\n");
		return -ENOMEM;
	}
#else
	cdev_cache = NULL;
#endif
	return 0;
}

void clean_cdev(void)
{
	if (cdev_cache)
		kmem_cache_destroy(cdev_cache);
	if (g_edma_class)
		class_destroy(g_edma_class);
}

/*
 * Called when the device goes from used to unused.
 */
int char_close(struct inode *inode, struct file *file)
{
	struct efx_pci_dev *epdev;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	if (!ecdev)
	{
		pr_err("[ERROR] char device with inode 0x%lx ecdev NULL\n", inode->i_ino);
		return -EINVAL;
	}

	/* fetch device specific data stored earlier during open */
	epdev = ecdev->epdev;
	if (!epdev)
	{
		pr_err("[ERROR] char device with inode 0x%lx efx pcie device NULL\n", inode->i_ino);
		return -EINVAL;
	}

	return 0;
}

int char_open(struct inode *inode, struct file *file)
{
	struct edma_cdev *ecdev;

	/* pointer to containing structure of the character device inode */
	ecdev = container_of(inode->i_cdev, struct edma_cdev, cdev);
	if (ecdev->magic != MAGIC_CHAR)
	{
		pr_err("ecdev 0x%p inode 0x%lx magic mismatch 0x%lx\n", ecdev, inode->i_ino, ecdev->magic);
		return -EINVAL;
	}
	/* create a reference to our char device in the opened file */
	file->private_data = ecdev;

	return 0;
}

/***************************** SGDMA *****************************************/
// Structure to hold alignment check results
struct alignment_check
{
	uint32_t buf_offset;	 // Buffer address offset
	uint32_t pos_offset;	 // Position offset
	size_t len_remainder; // Length remainder
};

static void calculate_alignment_offsets(const struct edma_engine *engine,
													 const char __user *buf,
													 size_t count,
													 loff_t pos,
													 struct alignment_check *result)
{
	uintptr_t buf_addr = (uintptr_t)buf;
	uint32_t addr_mask = engine->addr_align - 1;
	size_t len_mask = (size_t)engine->len_granularity - 1;

	result->buf_offset = buf_addr & addr_mask;
	result->pos_offset = pos & addr_mask;
	result->len_remainder = count & len_mask;
}

static int check_non_incr_alignment(const struct edma_engine *engine,
												const struct alignment_check *check,
												const char __user *buf,
												size_t count,
												loff_t pos,
												int sync)
{
	pr_info("[DBG] Checking AXI ST/MM non-incremental alignment\n");
	pr_info("[DBG] Buffer offset=%u, Position offset=%u, Length remainder=%zu\n",
			  check->buf_offset, check->pos_offset, check->len_remainder);

	if (check->buf_offset != 0)
	{
		pr_err("[ERROR] Non-aligned buffer address: %p (offset=%u)\n",
				 buf, check->buf_offset);
		return -EINVAL;
	}

	if (check->pos_offset != 0 && sync)
	{
		pr_err("[ERROR] Non-aligned FPGA address: 0x%llx (offset=%u)\n",
				 (unsigned long long)pos, check->pos_offset);
		return -EINVAL;
	}

	if (check->len_remainder != 0)
	{
		pr_err("[ERROR] Length %zu is not a multiple of %u\n",
				 count, engine->len_granularity);
		return -EINVAL;
	}

	return 0;
}

static int check_incr_alignment(const struct alignment_check *check,
										  const char __user *buf,
										  loff_t pos)
{
	if (check->buf_offset != check->pos_offset)
	{
		pr_err("[ERROR] Alignment mismatch between buffer and FPGA addresses\n");
		pr_err("[ERROR] Buffer address: %p (offset=%u), FPGA address: 0x%llx (offset=%u)\n",
				 buf, check->buf_offset,
				 (unsigned long long)pos, check->pos_offset);
		return -EINVAL;
	}

	return 0;
}

/**
 * Validates transfer alignment requirements for DMA operations.
 * @param engine DMA engine structure
 * @param buf User buffer address
 * @param count Transfer length
 * @param pos FPGA address position
 * @param sync Synchronous transfer flag
 * @return 0 if alignment is valid, negative error code otherwise
 */
static int validate_transfer_alignment(struct edma_engine *engine,
													const char __user *buf,
													size_t count,
													loff_t pos,
													int sync)
{
	struct alignment_check check = {0};

	if (!engine)
	{
		pr_err("[ERROR] Invalid DMA engine\n");
		return -EINVAL;
	}

	calculate_alignment_offsets(engine, buf, count, pos, &check);

	if (engine->non_incr_addr)
	{
		return check_non_incr_alignment(engine, &check, buf, count, pos, sync);
	}

	return check_incr_alignment(&check, buf, pos);
}

/**
 * cleanup_user_buffer - Clean up and unmap a user-space buffer
 */

static void cleanup_user_buffer(bool write, struct edma_io_cb *cb)
{
	int i;

	sg_free_table(&cb->sgt);
	if (!cb->pages || !cb->pages_nr)
		return;

	for (i = 0; i < cb->pages_nr; i++)
	{
		if (cb->pages[i])
		{
			if (!write)
				set_page_dirty_lock(cb->pages[i]);
			put_page(cb->pages[i]);
		}
		else
		{
			break;
		}
	}

	if (i != cb->pages_nr)
		pr_info("sgl pages %d/%llu.\n", i, cb->pages_nr);

	kfree(cb->pages);
	cb->pages = NULL;
	return;
}

static int map_buffer_to_sglist(bool write, struct edma_io_cb *cb)
{
	struct scatterlist *sg;
	void __user *buf;
	size_t len;
	uint64_t pages_nr;
	int ret, i;
	struct sg_table *sgt = &cb->sgt;

	if (!cb || !cb->buf)
	{
		return -EINVAL;
	}

	buf = cb->buf;
	len = cb->len;

	/* Calculate number of pages needed */
	pages_nr = (((uint64_t)buf + len + PAGE_SIZE - 1) - ((uint64_t)buf & PAGE_MASK)) >> PAGE_SHIFT;
	if (!pages_nr)
	{
		return -EINVAL;
	}

	/* Allocate scatter-gather table */
	if (sg_alloc_table(&cb->sgt, pages_nr, GFP_KERNEL))
	{
		pr_err("Failed to allocate SGL: Out of memory\n");
		return -ENOMEM;
	}

	/* Allocate pages array */
	cb->pages = kcalloc(pages_nr, sizeof(struct page *), GFP_KERNEL);
	if (!cb->pages)
	{
		pr_err("Failed to allocate pages array: Out of memory\n");
		ret = -ENOMEM;
		goto err_out;
	}

	/* Pin user pages */
	ret = get_user_pages_fast((uint64_t)buf, pages_nr, SGDMA_DIR_WRITE, cb->pages);
	if (ret < 0)
	{
		pr_err("Failed to pin %llu user pages: %d\n", pages_nr, ret);
		goto err_out;
	}
	if (ret != pages_nr)
	{
		pr_err("Pinned %d pages, expected %llu\n", ret, pages_nr);
		cb->pages_nr = ret;
		ret = -EFAULT;
		goto err_out;
	}

	/* Check for duplicate pages */
	for (i = 1; i < pages_nr; i++)
	{
		if (cb->pages[i - 1] == cb->pages[i])
		{
			pr_err("Duplicate pages detected at indices %d and %d\n", i - 1, i);
			ret = -EFAULT;
			cb->pages_nr = pages_nr;
			goto err_out;
		}
	}

	/* Populate scatter-gather list */
	sg = sgt->sgl;
	for (i = 0; i < pages_nr; i++, sg = sg_next(sg))
	{
		uint64_t offset = offset_in_page(buf);
		uint64_t nbytes = min_t(unsigned int, PAGE_SIZE - offset, len);

		flush_dcache_page(cb->pages[i]);
		sg_set_page(sg, cb->pages[i], nbytes, offset);
		buf += nbytes;
		len -= nbytes;
	}

	if (len)
	{
		pr_err("Invalid buffer length: %zu bytes remaining\n", len);
		return -EINVAL;
	}

	cb->pages_nr = pages_nr;
	return 0;

err_out:
	cleanup_user_buffer(write, cb);
	return ret;
}

static ssize_t perform_char_sgdma(struct file *file, bool wr, loff_t *pos, const char __user *buf, size_t cnt) // Rename to perform_char_sgdma
{
	int ret;
	ssize_t done_size = 0;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_engine *engine;
	struct edma_io_cb cb;

	engine = ecdev->engine;

	if ((wr && engine->dir != DMA_TO_DEVICE) || (!wr && engine->dir != DMA_FROM_DEVICE))
	{
		pr_err("[ERROR] r/w mismatch. W %d, engine dir %d.\n", wr, engine->dir);
		return -EINVAL;
	}

	ret = validate_transfer_alignment(engine, buf, cnt, *pos, 1);
	if (ret)
	{
		pr_info("Invalid transfer alignment detected\n");
		return ret;
	}

	memset(&cb, 0, sizeof(struct edma_io_cb));
	cb.buf = (char __user *)buf;
	cb.len = cnt;
	cb.ep_addr = (u64)*pos;
	cb.write = wr;
	ret = map_buffer_to_sglist(wr, &cb);
	if (ret < 0)
		return ret;

	done_size = edm_subreq(&cb.sgt, ecdev->engine, 0, *pos);
	cleanup_user_buffer(wr, &cb);

	return done_size;
}

static ssize_t sgdma_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
{
	return perform_char_sgdma(file, SGDMA_DIR_WRITE, pos, buf, count);
}

static ssize_t sgdma_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
{
	return perform_char_sgdma(file, SGDMA_DIR_READ, pos, buf, count);
}

static int sgdma_open(struct inode *inode, struct file *file)
{
	struct edma_cdev *ecdev;
	struct edma_engine *engine;

	char_open(inode, file);

	ecdev = (struct edma_cdev *)file->private_data;
	engine = ecdev->engine;

	if (engine->streaming && engine->dir == DMA_FROM_DEVICE)
	{
		if (engine->device_open == 1)
			return -EBUSY;

		engine->device_open = 1;
		engine->eop_flush = (file->f_flags & O_TRUNC) ? 1 : 0;
	}

	return 0;
}

static int sgdma_close(struct inode *inode, struct file *file)
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
static loff_t sgdma_seek(struct file *file, loff_t off, int whence)
{
	loff_t newpos = 0;

	switch (whence)
	{
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
	return newpos;
}

static const struct file_operations sgdma_fops = {
	 .owner = THIS_MODULE,
	 .open = sgdma_open,
	 .release = sgdma_close,
	 .write = sgdma_write,
	 .read = sgdma_read,
	 .llseek = sgdma_seek,
};

void sgd_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &sgdma_fops);
	return;
}
/***************************** SGDMA *****************************************/

/***************************** ctrl *****************************************/
/*
 * character device file operations for control bus (through control bridge)
 */
static ssize_t ctrl_rd(struct file *fp, char __user *buf, size_t count,
							  loff_t *pos)
{
	int ret;
	void __iomem *reg;
	uint32_t w;
	struct edma_cdev *ecdev = (struct edma_cdev *)fp->private_data;
	struct efx_pci_dev *epdev;

	epdev = ecdev->epdev;

	/* only 32-bit aligned and 32-bit multiples */
	if (*pos & 3)
		return -EPROTO;
	/* first address is BAR base plus file position offset */
	reg = epdev->bar[ecdev->bar] + *pos;
	// w = reg_rd(reg, epdev);
	w = ioread32(reg);
	pr_info("[DBG] %s(@%p, count=%ld, pos=%d) value = 0x%08x\n", __func__, reg, (long)count, (int)*pos, w);
	ret = copy_to_user(buf, &w, 4);
	if (ret)
		pr_info("[DBG] Copy to userspace failed but continuing\n");

	*pos += 4;
	return 4;
}

static ssize_t ctrl_wr(struct file *fp, const char __user *buf,
							  size_t count, loff_t *pos)
{
	int ret;
	void __iomem *reg;
	uint32_t w;
	struct edma_cdev *ecdev = (struct edma_cdev *)fp->private_data;
	struct efx_pci_dev *epdev;

	epdev = ecdev->epdev;

	/* only 32-bit aligned and 32-bit multiples */
	if (*pos & 3)
		return -EPROTO;

	/* first address is BAR base plus file position offset */
	reg = epdev->bar[ecdev->bar] + *pos;
	ret = copy_from_user(&w, buf, 4);
	if (ret)
		pr_info("copy from user failed %d/4, but continuing.\n", ret);

	pr_info("[DBG] %s(0x%08x @%p, count=%ld, pos=%d)\n", __func__, w, reg, (long)count, (int)*pos);
	// reg_wr(w, reg, epdev);
	iowrite32(w, reg);
	*pos += 4;
	return 4;
}

/* maps the PCIe BAR into user space for memory-like access using mmap() */
int br_mmap(struct file *file, struct vm_area_struct *vma)
{
	int ret;
	uint64_t psize;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct efx_pci_dev *epdev;

#if 0
	uint64_t len, pfn;
	pgoff_t pgoff;
	extern void *bypass_buf_vir;

	epdev = ecdev->epdev;

	psize = 32*1024;//32KB
	len = vma->vm_end - vma->vm_start;
	pgoff = vma->vm_pgoff;
	if (len > psize)
		return -EINVAL;
	/*
	 * Use common vm_area operations to track buffer refcount.
	 */
	//vma->vm_private_data = (void*)fobj;
	//vma->vm_ops = &fly_common_vm_ops;
#if KERNEL_VERSION(6, 3, 0) <= LINUX_VERSION_CODE
	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
#else
	vma->vm_flags |= VM_PFNMAP | VM_DONTCOPY | VM_DONTEXPAND;
#endif
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);


	pfn = __pa(bypass_buf_vir + (pgoff << PAGE_SHIFT)) >> PAGE_SHIFT;
	ret = remap_pfn_range(vma, vma->vm_start, pfn, len, vma->vm_page_prot);
	if (ret < 0) {
		pr_err("ERROR: could not remap kernel buffer to user-space!");
		return -ENXIO;
	}
#else
	unsigned long off;
	unsigned long phys;
	unsigned long vsize;

	epdev = ecdev->epdev;
	if (mmap_bar >= 0)
		ecdev->bar = mmap_bar;

	off = vma->vm_pgoff << PAGE_SHIFT;
	/* BAR physical address */
	phys = pci_resource_start(epdev->pdev, ecdev->bar) + off;
	vsize = vma->vm_end - vma->vm_start;
	/* complete resource */
	psize = pci_resource_end(epdev->pdev, ecdev->bar) -
			  pci_resource_start(epdev->pdev, ecdev->bar) + 1 - off;

	pr_info("mmap(): cdev->bar = %d\n", ecdev->bar);
	pr_info("mmap(): epdev = 0x%p\n", epdev);
	pr_info("mmap(): pci_dev = 0x%08lx\n", (unsigned long)epdev->pdev);
	pr_info("off = 0x%lx, vsize 0x%lu, psize 0x%llu.\n", off, vsize, psize);
	pr_info("start = 0x%llx\n",
			  (unsigned long long)pci_resource_start(epdev->pdev, ecdev->bar));
	pr_info("phys = 0x%lx\n", phys);

	if (vsize > psize)
		return -EINVAL;
	/*
	 * pages must not be cached as this would result in cache line sized
	 * accesses to the end point
	 */
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
	/*
	 * prevent touching the pages (byte access) for swap-in,
	 * and prevent the pages from being swapped out
	 */
#if KERNEL_VERSION(6, 3, 0) <= LINUX_VERSION_CODE
	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
#else
	vma->vm_flags |= VMEM_FLAGS;
#endif

	/* make MMIO accessible to user space */
	ret = io_remap_pfn_range(vma, vma->vm_start, phys >> PAGE_SHIFT,
									 vsize, vma->vm_page_prot);
	pr_info("vma=0x%p, vma->vm_start=0x%lx, phys=0x%lx, size=%lu = %d\n",
			  vma, vma->vm_start, phys >> PAGE_SHIFT, vsize, ret);

	if (ret)
		return -EAGAIN;
#endif
	return 0;
}

/*
 * character device file operations for control bus (through control bridge)
 */
static const struct file_operations ctrl_fops = {
	 .owner = THIS_MODULE,
	 .open = char_open,
	 .release = char_close,
	 .read = ctrl_rd,
	 .write = ctrl_wr,
	 .mmap = br_mmap,
	 //.unlocked_ioctl = char_ctrl_ioctl,
};

void ctrl_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &ctrl_fops);
}

/***************************** ctrl *****************************************/

/***************************** events *****************************************/
/*
 * character device file operations for events
 */
static ssize_t char_events_read(struct file *file, char __user *buf,
										  size_t count, loff_t *pos)
{
	int ret;
	struct edma_user_irq *user_irq;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	uint32_t events_user;
	unsigned long flags;

	user_irq = ecdev->user_irq;
	if (!user_irq)
	{
		pr_info("ecdev 0x%p, user_irq NULL.\n", ecdev);
		return -EINVAL;
	}

	if (count != 4)
		return -EPROTO;

	if (*pos & 3)
		return -EPROTO;

	/*
	 * sleep until any interrupt events have occurred,
	 * or a signal arrived
	 */
	ret = wait_event_interruptible(user_irq->events_wq, user_irq->events_irq != 0);
	if (ret)
		pr_info("[DBG] wait_event_interruptible=%d\n", ret);

	/* wait_event_interruptible() was interrupted by a signal */
	if (ret == -ERESTARTSYS)
		return -ERESTARTSYS;

	/* atomically decide which events are passed to the user */
	spin_lock_irqsave(&user_irq->events_lock, flags);
	events_user = user_irq->events_irq;
	user_irq->events_irq = 0;
	spin_unlock_irqrestore(&user_irq->events_lock, flags);

	ret = copy_to_user(buf, &events_user, 4);
	if (ret)
		pr_info("[DBG] Copy to user failed but continuing\n");

	return 4;
}

static unsigned int char_events_poll(struct file *file, poll_table *wait)
{
	unsigned long flags;
	unsigned int mask = 0;
	struct edma_user_irq *user_irq;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	user_irq = ecdev->user_irq;
	if (!user_irq)
	{
		pr_info("xcdev 0x%p, user_irq NULL.\n", ecdev);
		return -EINVAL;
	}

	poll_wait(file, &user_irq->events_wq, wait);

	spin_lock_irqsave(&user_irq->events_lock, flags);
	if (user_irq->events_irq)
		mask = POLLIN | POLLRDNORM; /* readable */

	spin_unlock_irqrestore(&user_irq->events_lock, flags);

	return mask;
}

/*
 * character device file operations for the irq events
 */
static const struct file_operations events_fops = {
	 .owner = THIS_MODULE,
	 .open = char_open,
	 .release = char_close,
	 .read = char_events_read,
	 .poll = char_events_poll,
};

void event_init(struct edma_cdev *ecdev)
{
	ecdev->user_irq = &(ecdev->epdev->user_irq[ecdev->bar]);
	cdev_init(&ecdev->cdev, &events_fops);
}

/***************************** events *****************************************/

/***************************** bypass *****************************************/
// #define reg_wr(v, mem, off) iowrite32(v, mem)

static int desc_datcopy(size_t size, char __user *buf,
								size_t *buf_offset, struct edma_transfer *transfer)
{
	int i;
	int copy_err;
	int ret = 0;

	if (!buf)
	{
		pr_err("[ERROR] Invalid user buffer\n");
		return -EINVAL;
	}

	if (!buf_offset)
	{
		pr_err("[ERROR] Invalid user buffer offset\n");
		return -EINVAL;
	}

	/* Fill user buffer with descriptor data */
	for (i = 0; i < transfer->desc_num; i++)
	{
		if (*buf_offset + sizeof(struct edma_desc) <= size)
		{
			copy_err = copy_to_user(&buf[*buf_offset],
											transfer->desc_virt + i,
											sizeof(struct edma_desc));

			if (copy_err)
			{
				pr_err("[ERROR] Copy to user buffer failed\n");
				*buf_offset = size;
				ret = -EINVAL;
			}
			else
			{
				*buf_offset += sizeof(struct edma_desc);
			}
		}
		else
		{
			ret = -ENOMEM;
		}
	}

	return ret;
}

static ssize_t bypass_rd(struct file *file, char __user *buf,
								 size_t count, loff_t *pos)
{
	struct efx_pci_dev *epdev;
	struct edma_engine *engine;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_transfer *transfer;
	struct list_head *idx;
	size_t buf_offset = 0;
	int ret = 0;

	epdev = ecdev->epdev;
	engine = ecdev->engine;

	if (count & 3)
	{
		pr_err("[ERROR] Buffer size must be a multiple of 4 bytes\n");
		return -EINVAL;
	}

	if (!buf)
	{
		pr_err("[ERROR] Caught NULL pointer\n");
		return -EINVAL;
	}

	if (epdev->bypass_bar_idx < 0)
	{
		pr_err("[ERROR] Bypass BAR not present - unsupported operation\n");
		return -ENODEV;
	}

	spin_lock(&engine->lock);

	if (!list_empty(&engine->transfer_list))
	{
		list_for_each(idx, &engine->transfer_list)
		{
			transfer = list_entry(idx, struct edma_transfer, entry);

			ret = desc_datcopy(count, buf, &buf_offset, transfer);
		}
	}

	spin_unlock(&engine->lock);

	if (ret < 0)
		return ret;
	else
		return buf_offset;
}

static ssize_t bypass_wr(struct file *file, const char __user *buf,
								 size_t count, loff_t *pos)
{
	struct efx_pci_dev *epdev;
	struct edma_engine *engine;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	uint32_t desc_data;
	void __iomem *bypass_addr;
	size_t buf_offset = 0;
	int ret = 0;
	int copy_err;

	epdev = ecdev->epdev;
	engine = ecdev->engine;

	if (count & 3)
	{
		pr_err("[ERROR] Buffer size must be a multiple of 4 bytes\n");
		return -EINVAL;
	}

	if (!buf)
	{
		pr_err("[ERROR] Caught NULL pointer\n");
		return -EINVAL;
	}

	if (epdev->bypass_bar_idx < 0)
	{
		pr_err("[ERROR] Bypass BAR not present - unsupported operation\n");
		return -ENODEV;
	}

	pr_info("[DBG] In %s()\n", __func__);

	spin_lock(&engine->lock);

	/* Write descriptor data to the bypass BAR */
	bypass_addr = epdev->bar[epdev->bypass_bar_idx];
	bypass_addr = (void __iomem *)((uint32_t __iomem *)bypass_addr + engine->bypass_offset);
	while (buf_offset < count)
	{
		copy_err = copy_from_user(&desc_data, &buf[buf_offset],
										  sizeof(uint32_t));
		if (!copy_err)
		{
			reg_wr(desc_data, bypass_addr,
					 (unsigned long)bypass_addr - engine->bypass_offset, engine->epdev);
			buf_offset += sizeof(uint32_t);
			ret = buf_offset;
		}
		else
		{
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
	 .read = bypass_rd,
	 .write = bypass_wr,
	 .mmap = br_mmap,
};

void bypass_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &bypass_fops);
}

/***************************** bypass *****************************************/

void remove_char_device(struct efx_pci_dev *epdev)
{
	int i = 0;
	int ret;
	/* iterate over channels */
	for (i = 0; i < epdev->htc_channel_max; i++)
	{
		/* remove SG DMA character device */
		ret = des_dev(&epdev->htc_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy htc ecdev %d error :0x%x\n", i, ret);
	}

	for (i = 0; i < epdev->cth_channel_max; i++)
	{
		ret = des_dev(&epdev->cth_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy cth ecdev %d error 0x%x\n", i, ret);
	}
	/* remove control character device */
	ret = des_dev(&epdev->ctrl_cdev);
	if (ret < 0)
		pr_err("[ERROR] Failed to destroy cdev ctrl event %d error 0x%x\n", i, ret);

	if (epdev->custom_bar_idx >= 0)
	{
		ret = des_dev(&epdev->custom_cdev);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy custom cdev %d error 0x%x\n", i, ret);
	}

	if (epdev->bypass_bar_idx > 0)
	{
		/* iterate over channels */
		for (i = 0; i < epdev->htc_channel_max; i++)
		{
			/* remove DMA Bypass character device */
			ret = des_dev(&epdev->bypass_htc_cdev[i]);
			if (ret < 0)
				pr_err("[ERROR] Failed to destroy bypass htc cdev %d error 0x%x\n", i, ret);
		}
		for (i = 0; i < epdev->cth_channel_max; i++)
		{
			ret = des_dev(&epdev->bypass_cth_cdev[i]);
			if (ret < 0)
				pr_err("[ERROR] Failed to destroy bypass cth %d error 0x%x\n", i, ret);
		}
		ret = des_dev(&epdev->bypass_cdev_base);
		if (ret < 0)
			pr_err("Failed to destroy base cdev\n");
	}

	for (i = 0; i < epdev->user_max; i++)
	{
		ret = des_dev(&epdev->events_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy cdev event %d error 0x%x\n", i, ret);
	}
	if (epdev->major)
		unregister_chrdev_region(MKDEV(epdev->major, EDMA_MINOR_BASE), EDMA_MINOR_COUNT);
	return;
}

int init_char_device(struct efx_pci_dev *epdev)
{
	int i = 0;
	int ret = 0;
	struct edma_engine *engine;

	/* initialize control character device */
	ret = create_character_device(NULL, epdev, epdev->config_bar_idx, EFX_FILE_CTRL, &epdev->ctrl_cdev);
	if (ret < 0)
	{
		pr_err("create_char(ctrl_cdev) failed\n");
		goto fail;
	}
	set_flag(EFX_FILE_CTRL, epdev);

	/* iterate over channels */
	for (i = 0; i < epdev->htc_channel_max; i++)
	{
		engine = &epdev->engine_htc[i];
		ret = create_character_device(engine, epdev, i, EFX_FILE_HTC, &epdev->htc_cdev[i]);
		if (ret < 0)
		{
			pr_err("[ERROR] create char htc %d failed, %d.\n", i, ret);
			goto fail;
		}
	}

	for (i = 0; i < epdev->cth_channel_max; i++)
	{
		engine = &epdev->engine_cth[i];
		ret = create_character_device(engine, epdev, i, EFX_FILE_CTH, &epdev->cth_cdev[i]);
		if (ret < 0)
		{
			pr_err("[ERROR] create char cth %d failed, %d.\n", i, ret);
			goto fail;
		}
	}

	/* initialize events character device */
	for (i = 0; i < epdev->user_max; i++)
	{
		ret = create_character_device(NULL, epdev, i, EFX_FILE_EVENTS, &epdev->events_cdev[i]);
		if (ret < 0)
		{
			pr_err("create char event %d failed, %d.\n", i, ret);
			goto fail;
		}
	}

	/* initialize user character device */
	if (epdev->custom_bar_idx >= 0)
	{
		ret = create_character_device(NULL, epdev, epdev->custom_bar_idx, EFX_FILE_USER, &epdev->custom_cdev);
		if (ret < 0)
		{
			pr_err("[ERROR] create_char(custom_cdev) failed\n");
			goto fail;
		}
	}

	/* Initialize Bypass Character Device */
	if (epdev->bypass_bar_idx > 0)
	{
		for (i = 0; i < epdev->htc_channel_max; i++)
		{
			engine = &epdev->engine_htc[i];
			ret = create_character_device(engine, epdev, i, EFX_BYPASS_HTC, &epdev->bypass_htc_cdev[i]);
			if (ret < 0)
			{
				pr_err("[ERROR] create htc %d bypass I/F failed, %d.\n", i, ret);
				goto fail;
			}
		}

		for (i = 0; i < epdev->cth_channel_max; i++)
		{
			engine = &epdev->engine_cth[i];
			ret = create_character_device(engine, epdev, i, EFX_BYPASS_CTH, &epdev->bypass_cth_cdev[i]);
			if (ret < 0)
			{
				pr_err("[ERROR] create cth %d bypass I/F failed, %d.\n", i, ret);
				goto fail;
			}
		}

		ret = create_character_device(NULL, epdev, epdev->bypass_bar_idx, EFX_BYPASS, &epdev->bypass_cdev_base);
		if (ret < 0)
		{
			pr_err("[ERROR] create bypass failed %d.\n", ret);
			goto fail;
		}
		set_flag(EFX_BYPASS, epdev);
	}

	return 0;

fail:
	ret = -1;
	remove_char_device(epdev);
	return ret;
}
