#ifndef __EDMA_CORE_H__
#define __EDMA_CORE_H__
#include <linux/version.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/module.h>
#include <linux/dma-mapping.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/jiffies.h>
#include <linux/kernel.h>
#include <linux/pci.h>
#include <linux/workqueue.h>
#include "dma_regs.h"

/* Add compatibility checking for RHEL versions */
#if defined(RHEL_RELEASE_CODE)
#define ACCESS_OK_2_ARGS (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#else
#define ACCESS_OK_2_ARGS (LINUX_VERSION_CODE >= KERNEL_VERSION(5, 0, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#define HAS_MMIOWB (RHEL_RELEASE_CODE <= RHEL_RELEASE_VERSION(8, 0))
#else
#define HAS_MMIOWB (LINUX_VERSION_CODE <= KERNEL_VERSION(5, 1, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#define HAS_SWAKE_UP_ONE (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#define HAS_SWAKE_UP (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#else
#define HAS_SWAKE_UP_ONE (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 19, 0))
#define HAS_SWAKE_UP (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#define PCI_AER_NAMECHANGE (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 3))
#else
#define PCI_AER_NAMECHANGE (LINUX_VERSION_CODE >= KERNEL_VERSION(5, 7, 0))
#endif

#if HAS_SWAKE_UP
#include <linux/swait.h>
#endif

/* Kernel version adaptative code */
#if HAS_SWAKE_UP_ONE
/* since 4.18, using simple wait queues is not recommended
 * except for realtime constraint (see swait.h comments)
 * and will likely be removed in future kernel versions
 */
#define edma_wake_up swake_up_one
#define edma_wait_event_interruptible_timeout \
	swait_event_interruptible_timeout_exclusive
#define edma_wait_event_interruptible \
	swait_event_interruptible_exclusive
#elif HAS_SWAKE_UP
#define edma_wake_up swake_up
#define edma_wait_event_interruptible_timeout \
	swait_event_interruptible_timeout
#define edma_wait_event_interruptible \
	swait_event_interruptible
#else
#define edma_wake_up wake_up_interruptible
/* wait_event_interruptible_timeout() could return prematurely (-ERESTARTSYS)
 * if it is interrupted by a signal */
#define edma_wait_event_interruptible_timeout(wq, condition, timeout) \
	({                                                                 \
		int __ret = 0;                                                  \
		unsigned long expire = timeout + jiffies;                       \
		do                                                              \
		{                                                               \
			__ret = wait_event_interruptible_timeout(wq, condition,      \
																  timeout);           \
		} while ((__ret < 0) && (jiffies < expire));                    \
		__ret;                                                          \
	})
#define edma_wait_event_interruptible \
	wait_event_interruptible
#endif

/*
 * interrupts per engine, rad2_vul.sv:237
 * .REG_IRQ_OUT	(reg_irq_from_ch[(channel*2) +: 2]),
 */
#define EDMA_ENG_IRQ_NUM (1)
#define EDMA_MAX_ADJ_BLOCK_SIZE 0x40
#define EDMA_PAGE_SIZE 0x1000
#define RX_STATUS_EOP (1)

/* maximum size of a single DMA transfer descriptor */
#define EDMA_DESC_BLEN_BITS 28
#define EDMA_DESC_BLEN_MAX ((1 << (EDMA_DESC_BLEN_BITS)) - 1)

#define LS_BYTE_MASK 0x000000FFUL
#define DESC_MAGIC 0x00000000UL
/* obtain the 32 most significant (high) bits of a 32-bit or 64-bit address */
#define PCI_DMA_H(addr) ((addr >> 16) >> 16)
/* obtain the 32 least significant (low) bits of a 32-bit or 64-bit address */
#define PCI_DMA_L(addr) (addr & 0xffffffffUL)

#ifndef VM_RESERVED
#define VMEM_FLAGS (VM_IO | VM_DONTEXPAND | VM_DONTDUMP)
#else
#define VMEM_FLAGS (VM_IO | VM_RESERVED)
#endif

/* SECTION: Enum definitions */
enum transfer_state
{
	TRANSFER_STATE_NEW = 0,
	TRANSFER_STATE_SUBMITTED,
	TRANSFER_STATE_COMPLETED,
	TRANSFER_STATE_FAILED,
	TRANSFER_STATE_ABORTED
};

enum shutdown_state
{
	ENGINE_SHUTDOWN_NONE = 0,	  /* No shutdown in progress */
	ENGINE_SHUTDOWN_REQUEST = 1, /* engine requested to shutdown */
	ENGINE_SHUTDOWN_IDLE = 2	  /* engine has shutdown and is idle */
};

/* Structure for polled mode descriptor writeback */
struct edma_poll_wb
{
	uint32_t completed_desc_count;
	uint32_t reserved_1[7];
} __packed;

/**
 * Descriptor for a single contiguous memory block transfer.
 *
 * Multiple descriptors are linked by means of the next pointer. An additional
 * extra adjacent number gives the amount of extra contiguous descriptors.
 *
 * The descriptors are in root complex memory, and the bytes in the 32-bit
 * words must be in little-endian byte ordering.
 */
struct edma_desc
{
	uint32_t bytes; /* transfer length in bytes hi 5 bits */
	uint32_t control;
	uint32_t src_addr_hi; /* source address (high 32-bit) */
	uint32_t src_addr_lo; /* source address (low 32-bit) */
	uint32_t dst_addr_hi; /* destination address (high 32-bit) */
	uint32_t dst_addr_lo; /* destination address (low 32-bit) */
	uint32_t next_hi;		 /* next desc address (high 32-bit) */
	uint32_t next_lo;		 /* next desc address (low 32-bit) */
} __packed;

/* 32 bytes (four 32-bit words) or 64 bytes (eight 32-bit words) */
struct edma_result
{
	uint32_t status;
	uint32_t length;
	uint32_t reserved_1[6]; /* padding */
} __packed;

struct sw_desc
{
	dma_addr_t addr;
	uint64_t len;
};

/* Describes a (SG DMA) single transfer for the engine */
#define TRANSFER_FLAG_NEED_UNMAP 0x1
#define TRANSFER_FLAG_ST_CTH_EOP_RCVED 0x2 /* ST cth only */

/* Describes a (SG DMA) single transfer for the engine */
struct edma_transfer
{
	struct list_head entry;			/* queue of non-completed transfers */
	struct edma_desc *desc_virt;	/* virt addr of the 1st descriptor */
	struct edma_result *res_virt; /* virt addr of result, cth streaming */
	dma_addr_t res_bus;				/* bus addr for result descriptors */
	dma_addr_t desc_bus;				/* bus addr of the first descriptor */
	int desc_adjacent;				/* adjacent descriptors at desc_bus */
	int desc_num;						/* number of descriptors in transfer */
	int desc_index;					/* index for 1st desc. in transfer */
	int desc_cmpl;						/* completed descriptors */
	int desc_cmpl_th;					/* completed descriptor threshold */
	enum dma_data_direction dir;
#if HAS_SWAKE_UP
	struct swait_queue_head wq;
#else
	wait_queue_head_t wq; /* wait queue for transfer completion */
#endif

	enum transfer_state state; /* state of the transfer */
	unsigned int flags;
	int cyclic;				/* flag if transfer is cyclic */
	int last_in_request; /* flag if last within request */
	unsigned int len;
	struct sg_table *sgt;
	struct edma_io_cb *cb;
	// speed test
	// uint64_t total_time;
};

struct edma_request_cb
{
	struct sg_table *sgt;
	uint64_t ep_addr;
	uint64_t aperture;

	uint64_t total_len;
	uint64_t offset;

	struct scatterlist *sg;
	uint64_t sg_idx;
	uint64_t sg_offset;

	/* Use two transfers in case single request needs to be split */
	struct edma_transfer tfer[2];

	struct edma_io_cb *cb;

	uint64_t sw_desc_idx;
	uint64_t sw_desc_cnt;
	struct sw_desc sdesc[0];
};

struct edma_io_cb
{
	void __user *buf;
	size_t len;
	void *private;
	uint64_t pages_nr;
	struct sg_table sgt;
	struct page **pages;
	// total data size
	uint64_t count;
	uint64_t ep_addr;
	struct edma_request_cb *req;
	uint8_t write : 1;
	void (*io_done)(uint64_t cb_hndl, int err);
};

#define MAX_NUM_ENGINES (EDMA_CHANNEL_NUM_MAX * 2)
#define HTC_CHANNEL_OFFSET 0x1000
#define SGDMA_OFFSET_FROM_CHANNEL 0x4000
#define CHANNEL_SPACING 0x100
#define TARGET_SPACING 0x1000

#define BYPASS_MODE_SPACING 0x0100

/* maximum number of desc per transfer request */
#define EDMA_ENGINE_XFER_MAX_DESC 0x800
#define EDMA_ENGINE_CREDIT_XFER_MAX_DESC 0x3FF

#define WB_COUNT_MASK 0x00ffffffUL
#define WB_ERR_MASK (1UL << 31)
#define POLL_TIMEOUT_SECONDS 60
/* Use this definition to poll several times between calls to schedule */
#define NUM_POLLS_PER_SCHED 100
struct edma_user_irq
{
	struct efx_pci_dev *epdev;	  /* parent device */
	uint8_t user_idx;				  /* 0 ~ 15 */
	uint8_t events_irq;			  /* accumulated IRQs */
	spinlock_t events_lock;		  /* lock to safely update events_irq */
	wait_queue_head_t events_wq; /* wait queue to sync waiting threads */
	irq_handler_t handler;

	void *dev;
};

struct edma_engine
{
	// struct efx_pci_dev	*epdev;	/* parent device */
	void *epdev;	/* parent device */
	char name[16]; /* name of this engine */
	int version;	/* version of this engine */

	/* HW register address offsets */
	struct engine_regs *regs; /* Control reg BAR offset */
	// struct engine_sgdma_regs *sgdma_regs;	/* SGDAM reg BAR offset */
	uint32_t bypass_offset; /* Bypass mode BAR offset */

	/* Engine state, configuration and flags */
	enum shutdown_state shutdown; /* engine shutdown mode */
	enum dma_data_direction dir;
	uint8_t addr_align;		 /* source/dest alignment in bytes */
	uint8_t len_granularity; /* transfer length multiple */
	uint8_t addr_bits;		 /* HW datapath address width */
	uint8_t channel : 2;		 /* engine indices */
	uint8_t streaming : 1;
	uint8_t device_open : 1;	/* flag if engine node open, ST mode only */
	uint8_t running : 1;			/* flag if the driver started engine */
	uint8_t non_incr_addr : 1; /* flag if non-incremental addressing used */
	uint8_t eop_flush : 1;		/* st cth only, flush up the data with eop */
	uint8_t filler : 1;

	int max_extra_adj; /* descriptor prefetch capability */
	int desc_dequeued; /* num descriptors of completed transfers */
	uint32_t desc_max; /* max # descriptors per xfer */
	uint32_t status;	 /* last known status of device */

#if HAS_SWAKE_UP
	struct swait_queue_head shutdown_wq;
#else
	wait_queue_head_t shutdown_wq; /* wait queue for shutdown sync */
#endif

	/* only used for MSIX mode to store per-engine interrupt mask value */
	uint32_t interrupt_enable_mask_value;

	spinlock_t lock;		 /* protects concurrent access */
	int prev_cpu;			 /* remember CPU# of (last) locker */
	int msix_irq_line;	 /* MSI-X vector for this engine */
	uint32_t irq_bitmask; /* IRQ bit mask for this engine */

	/* Transfer list management */
	struct list_head transfer_list; /* queue of transfers */
	struct work_struct work;		  /* Work queue for interrupt handling */

	/* Members applicable to AXI-ST CTH (cyclic) transfers */
	struct edma_result *cyclic_result;
	dma_addr_t cyclic_result_bus; /* bus addr for transfer */
	uint8_t *perf_buf_virt;
	dma_addr_t perf_buf_bus; /* bus address */

	/* Members associated with polled mode support */
	uint8_t *poll_mode_addr_virt; /* virt addr for descriptor writeback */
	dma_addr_t poll_mode_bus;		/* bus addr for descriptor writeback */

	struct mutex desc_lock; /* protects concurrent access */
	dma_addr_t desc_bus;
	struct edma_desc *desc;
	int desc_idx;	/* current descriptor index */
	int desc_used; /* total descriptors used */

	/* completion status thread list for the queue */
	struct efx_kthread *cmplthp;
	/* pending work thread list */
	struct list_head cmplthp_list;
	/* cpu attached to intr_work */
	unsigned int intr_work_cpu;
	// speed test
	uint64_t m_start_time;
	uint64_t m_end_time;
};

static inline uint32_t bud_u32(uint32_t lo, uint32_t hi)
{
	return ((hi & 0xFFFFUL) << 16) | (lo & 0xFFFFUL);
}

static inline uint64_t bud_u64(uint64_t lo, uint64_t hi)
{
	return ((hi & 0xFFFFFFFULL) << 32) | (lo & 0xFFFFFFFFULL);
}

struct efx_pci_dev *epdev_find_by_pdev(struct pci_dev *pdev);
void chan_inter_en(uint32_t mask, struct efx_pci_dev *epdev);
void chan_interdisable(uint32_t mask, struct efx_pci_dev *epdev);
void ur_interdisable(uint32_t mask, struct efx_pci_dev *epdev);
uint32_t rd_inter(struct efx_pci_dev *epdev);
void irq_trdown(struct efx_pci_dev *epdev);
void msi_msix_dis(struct efx_pci_dev *epdev);
void pci_intr_pend(struct pci_dev *pdev);
void check_intersta(struct efx_pci_dev *epdev);
int msi_msix_en(struct efx_pci_dev *epdev);
int irq_ready(struct efx_pci_dev *epdev);

// int eng_serv_poll(uint32_t exp_cnt, struct edma_engine *engine);
// ssize_t edm_subreq(struct sg_table *sgt, struct edma_engine *engine, bool map, uint64_t addr);
// int edmadev_on(void *p_epdev);
// void edmadev_off(void *p_epdev);
uint32_t __reg_rd(void *iomem, void *epdev);
void __reg_wr(const char *function, uint32_t value, void *iomem, unsigned long off, void *epdev);
ssize_t edm_subreq(struct sg_table *sgt, struct edma_engine *engine, bool map, uint64_t addr);
int eng_serv_poll(uint32_t exp_cnt, struct edma_engine *engine);
void edmadev_off(void *p_epdev);
int edmadev_on(void *p_epdev);

#endif /*__EDMA_CORE_H__*/
