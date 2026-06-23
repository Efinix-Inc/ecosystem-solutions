#ifndef __COMMON_H__
#define __COMMON_H__
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

#define EDMA_MOD_NAME "EfinixPCIEDMA"
#define MAGIC_CHAR 0xEEEEEEEEUL
/* SECTION: Preprocessor macros/constants */
#define EDMA_CHANNEL_NUM_MAX (4)
#define MAX_USER_IRQ 16
#define MAX_DMA_CHANNEL (4)
// #define EDMA_CONFIG_BAR_NUM		(0)
#define EDMA_BYPASS_BAR_NUM (1)
#define EDMA_BAR_NUM (6)

//#define __EDMA_DEBUG__

struct edma_user_irq;
struct edma_cdev
{
	unsigned long magic; /* structure ID for sanity checks */
	struct efx_pci_dev *epdev;

	dev_t cdevno;		  /* character device major:minor */
	struct cdev cdev;	  /* character device embedded struct */
	int bar;				  /* PCIe BAR for HW access, if needed */
	unsigned long base; /* bar access offset */
	spinlock_t lock;
	struct edma_engine *engine;	  /* engine instance, if needed */
	struct edma_user_irq *user_irq; /* IRQ value, if needed */
	struct device *sys_device;		  /* sysfs device */
};

struct efx_pci_dev
{
	struct pci_dev *pdev; // pci device struct from probe func
	int idx;
	int major;	  // major number
	int instance; // instance number
	struct list_head list_head;
	struct list_head rcu_node;

	unsigned int flags;
	/* character device structures */
	struct edma_cdev ctrl_cdev;
	struct edma_cdev custom_cdev;
	struct edma_cdev htc_cdev[EDMA_CHANNEL_NUM_MAX];		  // RootComplex to Endpoint char dev
	struct edma_cdev cth_cdev[EDMA_CHANNEL_NUM_MAX];		  // Endpoint to RootComplex char dev
	struct edma_cdev bypass_htc_cdev[EDMA_CHANNEL_NUM_MAX]; // Bypass RootComplex to Endpoint char dev
	struct edma_cdev bypass_cth_cdev[EDMA_CHANNEL_NUM_MAX]; // Bypass Endpoint to RootComplex char dev
	struct edma_cdev bypass_cdev_base;
	struct edma_cdev events_cdev[16];

	struct kobject kobj; // sysfs kobject for misc debug

	void *pri_data; // just for conseverative data

	/* PCIe BAR management */
	void __iomem *bar[EDMA_BAR_NUM]; /* addresses for mapped BARs */
	int custom_bar_idx;					/* BAR index of customize logic */
	int config_bar_idx;					/* BAR index of EDMA config logic */
	int bypass_bar_idx;					/* BAR index of EDMA bypass logic */
	int regions_in_use;					/* flag if dev was in use during probe() */
	int got_regions;						/* flag if probe() obtained the regions */

	int user_irqs_max;
	int user_max;
	int cth_channel_max;
	int htc_channel_max;

	/* Interrupt management */
	int irq_count;		/* interrupt counter */
	int irq_line;		/* flag if irq allocated successfully */
	int msi_enabled;	/* flag if msi was enabled for the device */
	int msix_enabled; /* flag if msi-x was enabled for the device */
#if KERNEL_VERSION(4, 12, 0) > LINUX_VERSION_CODE
	struct msix_entry entry[32]; /* msi-x vector/entry table */
#endif
	struct edma_user_irq user_irq[16]; /* user IRQ management */
	spinlock_t irq_reg_lock;

	/* EDMA engine management */
	int engines_num; /* Total engine count */
	uint32_t mask_irq_htc;
	uint32_t mask_irq_cth;
	struct edma_engine engine_htc[EDMA_CHANNEL_NUM_MAX];
	struct edma_engine engine_cth[EDMA_CHANNEL_NUM_MAX];
};
#define TO_EFX_PDEV(x) container_of(x, struct efx_pci_dev, kobj)

/* a custom attribute that works just for a struct efx_pci_dev. */
struct efx_attr
{
	struct attribute attr;
	ssize_t (*show)(struct efx_pci_dev *epdev, struct efx_attr *attr, char *buf);
	ssize_t (*store)(struct efx_pci_dev *epdev, struct efx_attr *attr, const char *buf, size_t count);
};
#define TO_EFX_ATTR(x) container_of(x, struct efx_attr, attr)

uint32_t __reg_rd(void *iomem, void *epdev);
void __reg_wr(const char *fn, uint32_t value, void *iomem, unsigned long off, void *epdev);

#define reg_wr(v, mem, off, epdev) __reg_wr(__func__, v, mem, off, (void *)epdev)
#define reg_rd(iomem, epdev) __reg_rd(iomem, (void *)epdev)

#endif /*__COMMON_H__*/
