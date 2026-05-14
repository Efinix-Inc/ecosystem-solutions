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

/*
 * character device file operations for control bus (through control bridge)
 */
static ssize_t char_ctrl_read(struct file *fp, char __user *buf, size_t count,
		loff_t *pos)
{
	int ret;
	void __iomem *reg;
	uint32_t w;
	struct edma_cdev *ecdev = (struct edma_cdev *)fp->private_data;
	struct edma_pci_dev *epdev;

	epdev = ecdev->epdev;

	/* only 32-bit aligned and 32-bit multiples */
	if (*pos & 3)
		return -EPROTO;
	/* first address is BAR base plus file position offset */
	reg = epdev->bar[ecdev->bar] + *pos;
	//w = read_register(reg);
	w = ioread32(reg);
	pr_info("[DBG] %s(@%p, count=%ld, pos=%d) value = 0x%08x\n", __func__, reg, (long)count, (int)*pos, w);
	ret = copy_to_user(buf, &w, 4);
	if (ret)
		pr_info("[DBG] Copy to userspace failed but continuing\n");

	*pos += 4;
	return 4;
}

static ssize_t char_ctrl_write(struct file *fp, const char __user *buf,
			size_t count, loff_t *pos)
{
	int ret;
	void __iomem *reg;
	uint32_t w;
	struct edma_cdev *ecdev = (struct edma_cdev *)fp->private_data;
	struct edma_pci_dev *epdev;

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
	//write_register(w, reg);
	iowrite32(w, reg);
	*pos += 4;
	return 4;
}

/* maps the PCIe BAR into user space for memory-like access using mmap() */
int bridge_mmap(struct file *file, struct vm_area_struct *vma)
{
	int ret;
	unsigned long off;
	unsigned long phys;
	unsigned long vsize;
	unsigned long psize;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	struct edma_pci_dev *epdev;

	epdev = ecdev->epdev;
#if 0
	unsigned long len, pfn;
	pgoff_t pgoff;
	extern void *bypass_buf_vir;

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
	pr_info("off = 0x%lx, vsize 0x%lu, psize 0x%lu.\n", off, vsize, psize);
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
	.read = char_ctrl_read,
	.write = char_ctrl_write,
	.mmap = bridge_mmap,
	//.unlocked_ioctl = char_ctrl_ioctl,
};

void cdev_ctrl_init(struct edma_cdev *ecdev)
{
	cdev_init(&ecdev->cdev, &ctrl_fops);
}

