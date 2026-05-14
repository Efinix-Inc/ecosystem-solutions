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

#define MAX_USER_IRQ			16
#define MAX_DMA_CHANNEL			(4)
//#define EDMA_CONFIG_BAR_NUM		(0)
#define EDMA_BYPASS_BAR_NUM		(1)
#define EDMA_BAR_NUM 			(6)

/* Add compatibility checking for RHEL versions */
#if defined(RHEL_RELEASE_CODE)
#	define ACCESS_OK_2_ARGS (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#else
#	define ACCESS_OK_2_ARGS (LINUX_VERSION_CODE >= KERNEL_VERSION(5, 0, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#	define HAS_MMIOWB (RHEL_RELEASE_CODE <= RHEL_RELEASE_VERSION(8, 0))
#else
#	define HAS_MMIOWB (LINUX_VERSION_CODE <= KERNEL_VERSION(5, 1, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#	define HAS_SWAKE_UP_ONE (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#	define HAS_SWAKE_UP (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 0))
#else
#	define HAS_SWAKE_UP_ONE (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 19, 0))
#	define HAS_SWAKE_UP (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0))
#endif

#if defined(RHEL_RELEASE_CODE)
#	define PCI_AER_NAMECHANGE (RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(8, 3))
#else
#	define PCI_AER_NAMECHANGE (LINUX_VERSION_CODE >= KERNEL_VERSION(5, 7, 0))
#endif

#if	HAS_SWAKE_UP
#include <linux/swait.h>
#endif

/* Kernel version adaptative code */
#if HAS_SWAKE_UP_ONE
/* since 4.18, using simple wait queues is not recommended
 * except for realtime constraint (see swait.h comments)
 * and will likely be removed in future kernel versions
 */
#define edma_wake_up	swake_up_one
#define edma_wait_event_interruptible_timeout \
			swait_event_interruptible_timeout_exclusive
#define edma_wait_event_interruptible \
			swait_event_interruptible_exclusive
#elif HAS_SWAKE_UP
#define edma_wake_up	swake_up
#define edma_wait_event_interruptible_timeout \
			swait_event_interruptible_timeout
#define edma_wait_event_interruptible \
			swait_event_interruptible
#else
#define edma_wake_up	wake_up_interruptible
/* wait_event_interruptible_timeout() could return prematurely (-ERESTARTSYS)
 * if it is interrupted by a signal */
#define edma_wait_event_interruptible_timeout(wq, condition, timeout) \
({\
	int __ret = 0;  \
	unsigned long expire = timeout + jiffies; \
	do { \
		__ret = wait_event_interruptible_timeout(wq, condition, \
							timeout); \
	} while ((__ret < 0) && (jiffies < expire)); \
       __ret; \
})
#define edma_wait_event_interruptible \
			wait_event_interruptible
#endif
#define EDMA_MOD_NAME		"EdmaDMA"

/* Target internal components on XDMA control BAR */
#define EDMA_OFS_INT_CTRL	(0x2000UL)
#define EDMA_OFS_CONFIG		(0x3000UL)


/* bits of the SGDMA descriptor control field */
#define EDMA_DESC_STOPPED	(1UL << 0)
#define EDMA_DESC_COMPLETED	(1UL << 1)
#define EDMA_DESC_EOP		(1UL << 4)
#define EDMA_PERF_RUN		(1UL << 0)
#define EDMA_PERF_CLEAR		(1UL << 1)
#define EDMA_PERF_AUTO		(1UL << 2)
/*
 * interrupts per engine, rad2_vul.sv:237
 * .REG_IRQ_OUT	(reg_irq_from_ch[(channel*2) +: 2]),
 */
#define EDMA_ENG_IRQ_NUM		(1)
#define EDMA_MAX_ADJ_BLOCK_SIZE	0x40
#define EDMA_PAGE_SIZE			0x1000
#define RX_STATUS_EOP			(1)

/* maximum size of a single DMA transfer descriptor */
#define EDMA_DESC_BLEN_BITS		28
#define EDMA_DESC_BLEN_MAX		((1 << (EDMA_DESC_BLEN_BITS)) - 1)

#define LS_BYTE_MASK 			0x000000FFUL
#define DESC_MAGIC 				0xAD4B0000UL
/* obtain the 32 most significant (high) bits of a 32-bit or 64-bit address */
#define PCI_DMA_H(addr) 		((addr >> 16) >> 16)
/* obtain the 32 least significant (low) bits of a 32-bit or 64-bit address */
#define PCI_DMA_L(addr) 		(addr & 0xffffffffUL)

#ifndef VM_RESERVED
#define VMEM_FLAGS (VM_IO | VM_DONTEXPAND | VM_DONTDUMP)
#else
#define VMEM_FLAGS (VM_IO | VM_RESERVED)
#endif

/* SECTION: Enum definitions */
enum transfer_state {
	TRANSFER_STATE_NEW = 0,
	TRANSFER_STATE_SUBMITTED,
	TRANSFER_STATE_COMPLETED,
	TRANSFER_STATE_FAILED,
	TRANSFER_STATE_ABORTED
};

enum shutdown_state {
	ENGINE_SHUTDOWN_NONE = 0,	/* No shutdown in progress */
	ENGINE_SHUTDOWN_REQUEST = 1,	/* engine requested to shutdown */
	ENGINE_SHUTDOWN_IDLE = 2	/* engine has shutdown and is idle */
};

/* upper 16-bits of engine identifier register */
#define EDMA_ID_H2D 	0xef10U
#define EDMA_ID_D2H 	0xef11U
/**
 * SG DMA Controller status and control registers
 *
 * These registers make the control interface for DMA transfers.
 *
 * It sits in End Point (FPGA) memory BAR[0] for 32-bit or BAR[0:1] for 64-bit.
 * It references the first descriptor which exists in Root Complex (PC) memory.
 *
 * @note The registers must be accessed using 32-bit (PCI DWORD) read/writes,
 * and their values are in little-endian byte ordering.
 */
struct engine_regs {
	uint32_t identifier;
	uint32_t control;
	uint32_t control_w1s;
	uint32_t control_w1c;
	uint32_t reserved_1[12];	/* padding */

	uint32_t status;
	uint32_t status_rc;
	uint32_t completed_desc_count;
	uint32_t alignments;
	uint32_t reserved_2[14];	/* padding */

	uint32_t poll_mode_wb_lo;
	uint32_t poll_mode_wb_hi;
	uint32_t interrupt_enable_mask;
	uint32_t interrupt_enable_mask_w1s;
	uint32_t interrupt_enable_mask_w1c;
	uint32_t reserved_3[9];	/* padding */

	uint32_t perf_ctrl;
	uint32_t perf_cyc_lo;
	uint32_t perf_cyc_hi;
	uint32_t perf_dat_lo;
	uint32_t perf_dat_hi;
	uint32_t perf_pnd_lo;
	uint32_t perf_pnd_hi;
} __packed;

struct engine_sgdma_regs {
	uint32_t identifier;
	uint32_t reserved_1[31];	/* padding */

	/* bus address to first descriptor in Root Complex Memory */
	uint32_t first_desc_lo;
	uint32_t first_desc_hi;
	/* number of adjacent descriptors at first_desc */
	uint32_t first_desc_adjacent;
	uint32_t credits;
} __packed;

#define CONFIG_BLOCK_ID 0xef130000UL
struct config_regs {
	uint32_t identifier;
	uint32_t reserved_1[4];
	uint32_t msi_enable;
};

#define IRQ_BLOCK_ID 0xef120000UL
struct interrupt_regs {
	uint32_t identifier;
	uint32_t user_int_enable;
	uint32_t user_int_enable_w1s;
	uint32_t user_int_enable_w1c;
	uint32_t channel_int_enable;
	uint32_t channel_int_enable_w1s;
	uint32_t channel_int_enable_w1c;
	uint32_t reserved_1[9];	/* padding */

	uint32_t user_int_request;
	uint32_t channel_int_request;
	uint32_t user_int_pending;
	uint32_t channel_int_pending;
	uint32_t reserved_2[12];	/* padding */

	uint32_t user_msi_vector[8];
	uint32_t channel_msi_vector[8];
} __packed;

struct sgdma_common_regs {
	uint32_t padding[8];
	uint32_t credit_mode_enable;
	uint32_t credit_mode_enable_w1s;
	uint32_t credit_mode_enable_w1c;
} __packed;

/* Structure for polled mode descriptor writeback */
struct edma_poll_wb {
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
struct edma_desc {
	uint32_t control;
	uint32_t bytes;		/* transfer length in bytes */
	uint32_t src_addr_lo;	/* source address (low 32-bit) */
	uint32_t src_addr_hi;	/* source address (high 32-bit) */
	uint32_t dst_addr_lo;	/* destination address (low 32-bit) */
	uint32_t dst_addr_hi;	/* destination address (high 32-bit) */
	uint32_t next_lo;		/* next desc address (low 32-bit) */
	uint32_t next_hi;		/* next desc address (high 32-bit) */
} __packed;

/* 32 bytes (four 32-bit words) or 64 bytes (eight 32-bit words) */
struct edma_result {
	uint32_t status;
	uint32_t length;
	uint32_t reserved_1[6];	/* padding */
} __packed;

struct sw_desc {
	dma_addr_t addr;
	uint64_t len;
};

/* Describes a (SG DMA) single transfer for the engine */
#define TRANSFER_FLAG_NEED_UNMAP		0x1
#define TRANSFER_FLAG_ST_D2H_EOP_RCVED	0x2	/* ST d2h only */ 

/* Describes a (SG DMA) single transfer for the engine */
struct edma_transfer {
	struct list_head entry;		/* queue of non-completed transfers */
	struct edma_desc *desc_virt;	/* virt addr of the 1st descriptor */
	struct edma_result *res_virt;   /* virt addr of result, d2h streaming */
	dma_addr_t res_bus;		/* bus addr for result descriptors */
	dma_addr_t desc_bus;		/* bus addr of the first descriptor */
	int desc_adjacent;		/* adjacent descriptors at desc_bus */
	int desc_num;			/* number of descriptors in transfer */
	int desc_index;			/* index for 1st desc. in transfer */
	int desc_cmpl;			/* completed descriptors */
	int desc_cmpl_th;		/* completed descriptor threshold */
	enum dma_data_direction dir;
#if	HAS_SWAKE_UP
	struct swait_queue_head wq;
#else
	wait_queue_head_t wq;		/* wait queue for transfer completion */
#endif

	enum transfer_state state;	/* state of the transfer */
	unsigned int flags;
	int cyclic;			/* flag if transfer is cyclic */
	int last_in_request;		/* flag if last within request */
	unsigned int len;
	struct sg_table *sgt;
	struct edma_io_cb *cb;
	//speed test
	//uint64_t total_time;
};

struct edma_request_cb {
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


struct edma_io_cb {
	void __user	*buf;
	size_t len;
	void *private;
	uint64_t pages_nr;
	struct sg_table sgt;
	struct page **pages;
	// total data size
	uint64_t count;
	uint64_t ep_addr;
	struct edma_request_cb *req;
	uint8_t write:1;
	void (*io_done)(uint64_t cb_hndl, int err);
};


#define MAX_NUM_ENGINES 		(EDMA_CHANNEL_NUM_MAX * 2)
#define H2D_CHANNEL_OFFSET 		0x1000
#define SGDMA_OFFSET_FROM_CHANNEL 0x4000
#define CHANNEL_SPACING 		0x100
#define TARGET_SPACING 			0x1000

#define BYPASS_MODE_SPACING 	0x0100

/* maximum number of desc per transfer request */
#define EDMA_ENGINE_XFER_MAX_DESC			0x800
#define EDMA_ENGINE_CREDIT_XFER_MAX_DESC	0x3FF

#define WB_COUNT_MASK 0x00ffffffUL
#define WB_ERR_MASK (1UL << 31)
//#define POLL_TIMEOUT_SECONDS 10
#define POLL_TIMEOUT_SECONDS 20
/* Use this definition to poll several times between calls to schedule */
#define NUM_POLLS_PER_SCHED 100

/* bits of the SG DMA control register */
#define EDMA_CTRL_RUN_STOP					(1UL << 0)
#define EDMA_CTRL_IE_DESC_STOPPED			(1UL << 1)
#define EDMA_CTRL_IE_DESC_COMPLETED			(1UL << 2)
#define EDMA_CTRL_IE_DESC_ALIGN_MISMATCH	(1UL << 3)
#define EDMA_CTRL_IE_MAGIC_STOPPED			(1UL << 4)
#define EDMA_CTRL_IE_IDLE_STOPPED			(1UL << 6)
#define EDMA_CTRL_IE_READ_ERROR				(0x1FUL << 9)
#define EDMA_CTRL_IE_DESC_ERROR				(0x1FUL << 19)
#define EDMA_CTRL_NON_INCR_ADDR				(1UL << 25)
#define EDMA_CTRL_POLL_MODE_WB				(1UL << 26)
#define EDMA_CTRL_STM_MODE_WB				(1UL << 27)

/* bits of the SG DMA status register */
#define EDMA_STAT_BUSY				(1UL << 0)
#define EDMA_STAT_DESC_STOPPED		(1UL << 1)
#define EDMA_STAT_DESC_COMPLETED	(1UL << 2)
#define EDMA_STAT_ALIGN_MISMATCH	(1UL << 3)
#define EDMA_STAT_MAGIC_STOPPED		(1UL << 4)
#define EDMA_STAT_INVALID_LEN		(1UL << 5)
#define EDMA_STAT_IDLE_STOPPED		(1UL << 6)

#define EDMA_STAT_COMMON_ERR_MASK \
	(EDMA_STAT_ALIGN_MISMATCH | EDMA_STAT_MAGIC_STOPPED | EDMA_STAT_INVALID_LEN)

/* desc_error, D2H & H2D */
#define EDMA_STAT_DESC_UNSUPP_REQ	(1UL << 19)
#define EDMA_STAT_DESC_COMPL_ABORT	(1UL << 20)
#define EDMA_STAT_DESC_PARITY_ERR	(1UL << 21)
#define EDMA_STAT_DESC_HEADER_EP	(1UL << 22)
#define EDMA_STAT_DESC_UNEXP_COMPL	(1UL << 23)

#define EDMA_STAT_DESC_ERR_MASK	\
	(EDMA_STAT_DESC_UNSUPP_REQ | EDMA_STAT_DESC_COMPL_ABORT | \
	 EDMA_STAT_DESC_PARITY_ERR | EDMA_STAT_DESC_HEADER_EP | \
	 EDMA_STAT_DESC_UNEXP_COMPL)

/* read error: H2D */
#define EDMA_STAT_H2D_R_UNSUPP_REQ	(1UL << 9)
#define EDMA_STAT_H2D_R_COMPL_ABORT	(1UL << 10)
#define EDMA_STAT_H2D_R_PARITY_ERR	(1UL << 11)
#define EDMA_STAT_H2D_R_HEADER_EP	(1UL << 12)
#define EDMA_STAT_H2D_R_UNEXP_COMPL	(1UL << 13)

#define EDMA_STAT_H2D_R_ERR_MASK	\
	(EDMA_STAT_H2D_R_UNSUPP_REQ | EDMA_STAT_H2D_R_COMPL_ABORT | \
	 EDMA_STAT_H2D_R_PARITY_ERR | EDMA_STAT_H2D_R_HEADER_EP | \
	 EDMA_STAT_H2D_R_UNEXP_COMPL)

/* write error, H2D only */
#define EDMA_STAT_H2D_W_DECODE_ERR	(1UL << 14)
#define EDMA_STAT_H2D_W_SLAVE_ERR	(1UL << 15)

#define EDMA_STAT_H2D_W_ERR_MASK	\
	(EDMA_STAT_H2D_W_DECODE_ERR | EDMA_STAT_H2D_W_SLAVE_ERR)

/* read error: D2H */
#define EDMA_STAT_D2H_R_DECODE_ERR	(1UL << 9)
#define EDMA_STAT_D2H_R_SLAVE_ERR	(1UL << 10)

#define EDMA_STAT_D2H_R_ERR_MASK	(EDMA_STAT_D2H_R_DECODE_ERR | EDMA_STAT_D2H_R_SLAVE_ERR)

/* all combined */
#define EDMA_STAT_H2D_ERR_MASK	(EDMA_STAT_COMMON_ERR_MASK | EDMA_STAT_DESC_ERR_MASK | \
	 			EDMA_STAT_H2D_R_ERR_MASK | EDMA_STAT_H2D_W_ERR_MASK)

#define EDMA_STAT_D2H_ERR_MASK	(EDMA_STAT_COMMON_ERR_MASK | EDMA_STAT_DESC_ERR_MASK | EDMA_STAT_D2H_R_ERR_MASK)

struct edma_user_irq {
	struct edma_pci_dev *epdev;		/* parent device */
	uint8_t user_idx;					/* 0 ~ 15 */
	uint8_t events_irq;					/* accumulated IRQs */
	spinlock_t events_lock;				/* lock to safely update events_irq */
	wait_queue_head_t events_wq;		/* wait queue to sync waiting threads */
	irq_handler_t handler;

	void *dev;
};


struct edma_engine {
	//struct edma_pci_dev	*epdev;	/* parent device */
	void	*epdev;	/* parent device */
	char name[16];		/* name of this engine */
	int version;		/* version of this engine */

	/* HW register address offsets */
	struct engine_regs *regs;		/* Control reg BAR offset */
	struct engine_sgdma_regs *sgdma_regs;	/* SGDAM reg BAR offset */
	uint32_t bypass_offset;			/* Bypass mode BAR offset */
	
	/* Engine state, configuration and flags */
	enum shutdown_state shutdown;	/* engine shutdown mode */
	enum dma_data_direction dir;
	uint8_t addr_align;		/* source/dest alignment in bytes */
	uint8_t len_granularity; /* transfer length multiple */
	uint8_t addr_bits;		/* HW datapath address width */
	uint8_t channel:2;		/* engine indices */
	uint8_t streaming:1;
	uint8_t device_open:1;	/* flag if engine node open, ST mode only */
	uint8_t running:1;		/* flag if the driver started engine */
	uint8_t non_incr_addr:1; /* flag if non-incremental addressing used */
	uint8_t eop_flush:1; 	/* st d2h only, flush up the data with eop */
	uint8_t filler:1;


	int max_extra_adj;	/* descriptor prefetch capability */
	int desc_dequeued;	/* num descriptors of completed transfers */
	uint32_t desc_max;		/* max # descriptors per xfer */
	uint32_t status;			/* last known status of device */
	
#if	HAS_SWAKE_UP
	struct swait_queue_head shutdown_wq;
#else
	wait_queue_head_t shutdown_wq;	/* wait queue for shutdown sync */
#endif

	/* only used for MSIX mode to store per-engine interrupt mask value */
	uint32_t interrupt_enable_mask_value;

	spinlock_t lock;		/* protects concurrent access */
	int prev_cpu;			/* remember CPU# of (last) locker */
	int msix_irq_line;		/* MSI-X vector for this engine */
	uint32_t irq_bitmask;		/* IRQ bit mask for this engine */
	
	/* Transfer list management */
	struct list_head transfer_list;	/* queue of transfers */
	struct work_struct work;	/* Work queue for interrupt handling */

	/* Members applicable to AXI-ST C2H (cyclic) transfers */
	struct edma_result *cyclic_result;
	dma_addr_t cyclic_result_bus;	/* bus addr for transfer */
	uint8_t *perf_buf_virt;
	dma_addr_t perf_buf_bus; /* bus address */

	/* Members associated with polled mode support */
	uint8_t *poll_mode_addr_virt;	/* virt addr for descriptor writeback */
	dma_addr_t poll_mode_bus;	/* bus addr for descriptor writeback */


	struct mutex desc_lock;		/* protects concurrent access */
	dma_addr_t desc_bus;
	struct edma_desc *desc;
	int desc_idx;			/* current descriptor index */
	int desc_used;			/* total descriptors used */

	/* completion status thread list for the queue */
	struct edma_kthread *cmplthp;
	/* pending work thread list */
	struct list_head cmplthp_list;
	/* cpu attached to intr_work */
	unsigned int intr_work_cpu;
	// speed test
	uint64_t m_start_time;
	uint64_t m_end_time;
};

int engine_service_poll(struct edma_engine *engine, uint32_t expected_desc_count);
ssize_t edma_submit_request(struct edma_engine *engine, uint64_t ep_addr, struct sg_table *sgt, bool dma_mapped);
int edma_device_open(void *p_epdev);
void edma_device_close(void *p_epdev);

void dbg_set_trans_jiffies(uint64_t trans_sz, uint64_t jiffs);

#endif /*__EDMA_CORE_H__*/
