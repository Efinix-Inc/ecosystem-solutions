#ifndef __EDMA_PCI_H__
#define __EDMA_PCI_H__
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <linux/aer.h>
#include <linux/types.h>
#include <linux/module.h>
#include <linux/cdev.h>
#include <linux/dma-mapping.h>
#include <linux/delay.h>
#include <linux/fb.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/jiffies.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/mm_types.h>
#include <linux/poll.h>
#include <linux/pci.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/workqueue.h>
#include <linux/aio.h>
#include <linux/splice.h>
#include <linux/version.h>
#include <linux/uio.h>
#include <linux/spinlock_types.h>

#define MAGIC_CHAR	0xEEEEEEEEUL
/* SECTION: Preprocessor macros/constants */
#define EDMA_PCIE_BAR_NUM 	(6)
#define EDMA_CHANNEL_NUM_MAX 	(4)

//#define __EDMA_DEBUG__

struct edma_user_irq;
struct edma_cdev {
	unsigned long magic;		/* structure ID for sanity checks */
	struct edma_pci_dev *epdev;

	dev_t cdevno;			/* character device major:minor */
	struct cdev cdev;		/* character device embedded struct */
	int bar;			/* PCIe BAR for HW access, if needed */
	unsigned long base;		/* bar access offset */
	spinlock_t lock;
	struct edma_engine *engine;	/* engine instance, if needed */
	struct edma_user_irq *user_irq;	/* IRQ value, if needed */
	struct device *sys_device;	/* sysfs device */
};

/* Edma PCIe device specific book-keeping, one device one object. */
struct edma_pci_dev {
	struct pci_dev *pdev;	// pci device struct from probe func
	int idx;
	int major;				// major number
	int instance;			// instance number

	unsigned int flags;
	/* character device structures */
	struct edma_cdev ctrl_cdev;
	struct edma_cdev sgdma_h2d_cdev[EDMA_CHANNEL_NUM_MAX]; // Host to Device char dev
	struct edma_cdev sgdma_d2h_cdev[EDMA_CHANNEL_NUM_MAX]; // Device to Host char dev
	struct edma_cdev bypass_h2d_cdev[EDMA_CHANNEL_NUM_MAX]; // Bypass Host to Device char dev
	struct edma_cdev bypass_d2h_cdev[EDMA_CHANNEL_NUM_MAX]; // Bypass Device to Host char dev
	struct edma_cdev bypass_cdev_base;
	struct edma_cdev events_cdev[16];
	struct edma_cdev user_cdev;
	
	struct kobject kobj;	// sysfs kobject for misc debug
	
	void *pri_data;			// just for conseverative data

	/* PCIe BAR management */
	void __iomem *bar[EDMA_PCIE_BAR_NUM];	/* addresses for mapped BARs */
	int user_bar_idx;	/* BAR index of user logic */
	int config_bar_idx;	/* BAR index of XDMA config logic */
	int bypass_bar_idx;	/* BAR index of XDMA bypass logic */
	int regions_in_use;	/* flag if dev was in use during probe() */
	int got_regions;	/* flag if probe() obtained the regions */

	int user_irqs_max;
	int user_max;
	int d2h_channel_max;
	int h2d_channel_max;

	/* Interrupt management */
	int irq_count;		/* interrupt counter */
	int irq_line;		/* flag if irq allocated successfully */
	int msi_enabled;	/* flag if msi was enabled for the device */
	int msix_enabled;	/* flag if msi-x was enabled for the device */
#if KERNEL_VERSION(4, 12, 0) > LINUX_VERSION_CODE
	struct msix_entry entry[32];	/* msi-x vector/entry table */
#endif
	struct edma_user_irq user_irq[16];	/* user IRQ management */

	/* EDMA engine management */
	int engines_num;	/* Total engine count */
	uint32_t mask_irq_h2d;
	uint32_t mask_irq_d2h;
	struct edma_engine engine_h2d[EDMA_CHANNEL_NUM_MAX];
	struct edma_engine engine_d2h[EDMA_CHANNEL_NUM_MAX];
};
#define TO_EDMA_PDEV(x) container_of(x, struct edma_pci_dev, kobj)

/* a custom attribute that works just for a struct edma_pci_dev. */
struct edma_attr {
	struct attribute attr;
	ssize_t (*show)(struct edma_pci_dev *epdev, struct edma_attr *attr, char *buf);
	ssize_t (*store)(struct edma_pci_dev *epdev, struct edma_attr *attr, const char *buf, size_t count);
};
#define TO_EDMA_ATTR(x) container_of(x, struct edma_attr, attr)

#endif /*__EDMA_PCI_H__*/
