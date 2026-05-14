#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/vmalloc.h>
#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"
#include "edma_thread.h"

/* Module Parameters */
static unsigned int poll_mode;
module_param(poll_mode, uint, 0644);
MODULE_PARM_DESC(poll_mode, "Set 1 for hw polling, default is 0 (interrupts)");

static unsigned int interrupt_mode = 3;// 0 - Auto , 1 - MSI, 2 - Legacy, 3 - MSI-x
module_param(interrupt_mode, uint, 0644);
MODULE_PARM_DESC(interrupt_mode, "0 - Auto , 1 - MSI, 2 - Legacy, 3 - MSI-x");

static unsigned int desc_blen_max = EDMA_DESC_BLEN_MAX; // 128MB size
static unsigned int enable_st_d2h_credit = 0;

/* Kernel version adaptative code */
#if HAS_SWAKE_UP_ONE
/* since 4.18, using simple wait queues is not recommended
 * except for realtime constraint (see swait.h comments)
 * and will likely be removed in future kernel versions
 */
#define dma_wake_up	swake_up_one
#define dma_wait_event_interruptible_timeout \
			swait_event_interruptible_timeout_exclusive
#define dma_wait_event_interruptible \
			swait_event_interruptible_exclusive
#elif HAS_SWAKE_UP
#define dma_wake_up	swake_up
#define dma_wait_event_interruptible_timeout \
			swait_event_interruptible_timeout
#define dma_wait_event_interruptible \
			swait_event_interruptible
#else
#define dma_wake_up	wake_up_interruptible
/* wait_event_interruptible_timeout() could return prematurely (-ERESTARTSYS)
 * if it is interrupted by a signal */
#define dma_wait_event_interruptible_timeout(wq, condition, timeout) \
({\
	int __ret = 0;  \
	unsigned long expire = timeout + jiffies; \
	do { \
		__ret = wait_event_interruptible_timeout(wq, condition, \
							timeout); \
	} while ((__ret < 0) && (jiffies < expire)); \
       __ret; \
})
#define dma_wait_event_interruptible \
			wait_event_interruptible
#endif

#ifdef __EDMA_DEBUG__
/* SECTION: Function definitions */
inline void __write_register(const char *fn, u32 value, void *iomem,
			     unsigned long off)
{
	pr_err("%s: wr reg 0x%lx(0x%p), 0x%x.\n", fn, off, iomem, value);
	iowrite32(value, iomem);
}
#define write_register(v, mem, off) __write_register(__func__, v, mem, off)
#else
#define write_register(v, mem, off) iowrite32(v, mem)
#endif
inline u32 read_register(void *iomem)
{
	return ioread32(iomem);
}

static inline uint32_t build_uint32(uint32_t hi, uint32_t lo)
{
	return ((hi & 0xFFFFUL) << 16) | (lo & 0xFFFFUL);
}

static inline uint64_t build_uint64(uint64_t hi, uint64_t lo)
{
	return ((hi & 0xFFFFFFFULL) << 32) | (lo & 0xFFFFFFFFULL);
}

/* edma_desc_control -- Set complete control field of a descriptor. */
static int edma_desc_control_set(struct edma_desc *first, uint32_t control_field)
{
	/* remember magic and adjacent number */
	uint32_t control = le32_to_cpu(first->control) & ~(LS_BYTE_MASK);

	if (control_field & ~(LS_BYTE_MASK)) {
		pr_err("[ERROR] Invalid control field\n");
		return -EINVAL;
	}
	/* merge adjacent and control field */
	control |= control_field;
	/* write control and next_adjacent */
	first->control = cpu_to_le32(control);
	return 0;
}

/* edma_desc_adjacent -- Set how many descriptors are adjacent to this one */
static void edma_desc_adjacent(struct edma_desc *desc, uint32_t next_adjacent)
{
	/* remember reserved and control bits */
	uint32_t control = le32_to_cpu(desc->control) & 0x0000f0ffUL;
	/* merge adjacent and control field */
	control |= 0xAD4B0000UL | (next_adjacent << 8);
	/* write control and next_adjacent */
	desc->control = cpu_to_le32(control);
	return;
}

static int engine_start_mode_config(struct edma_engine *engine)
{
	uint32_t reg_val;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/* If a perf test is running, enable the engine interrupts */
	//if (engine->edma_perf) {
		reg_val = EDMA_CTRL_IE_DESC_STOPPED;
		reg_val |= EDMA_CTRL_IE_DESC_COMPLETED;
		reg_val |= EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
		reg_val |= EDMA_CTRL_IE_MAGIC_STOPPED;
		reg_val |= EDMA_CTRL_IE_IDLE_STOPPED;
		reg_val |= EDMA_CTRL_IE_READ_ERROR;
		reg_val |= EDMA_CTRL_IE_DESC_ERROR;

		write_register(reg_val, &engine->regs->interrupt_enable_mask,
				(unsigned long)(&engine->regs->interrupt_enable_mask) - (unsigned long)(&engine->regs));
	//}

	/* write control register of SG DMA engine */
	reg_val = (uint32_t)EDMA_CTRL_RUN_STOP;
	reg_val |= (uint32_t)EDMA_CTRL_IE_READ_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
	reg_val |= (uint32_t)EDMA_CTRL_IE_MAGIC_STOPPED;

	if (poll_mode) {
		reg_val |= (uint32_t)EDMA_CTRL_POLL_MODE_WB;
	} else {
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_STOPPED;
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_COMPLETED;
	}
	/* set non-incremental addressing mode */
	if (engine->non_incr_addr)
		reg_val |= (uint32_t)EDMA_CTRL_NON_INCR_ADDR;

	//pr_info("[DBG] iowrite32(0x%08x to 0x%p) (control)\n", reg_val, (void *)&engine->regs->control);
	/* start the engine */
	write_register(reg_val, &engine->regs->control,
					(unsigned long)(&engine->regs->control) - (unsigned long)(&engine->regs));

	/* dummy read of status register to flush all previous writes */
	reg_val = read_register(&engine->regs->status);
	//pr_info("[DBG] ioread32(0x%p) = 0x%08x (dummy read flushes writes).\n", &engine->regs->status, reg_val);

	return 0;
}

static uint32_t edma_get_next_adj(unsigned int remaining, uint32_t next_lo)
{
	unsigned int next_index;

	//pr_info("[DBG] remaining_desc %u, next_lo 0x%x\n", remaining, next_lo);

	if (remaining <= 1)
		return 0;

	/* shift right 5 times corresponds to a division by
	 * sizeof(edma_desc) = 32
	 */
	next_index = ((next_lo & (EDMA_PAGE_SIZE - 1)) >> 5) %	EDMA_MAX_ADJ_BLOCK_SIZE;
	return min(EDMA_MAX_ADJ_BLOCK_SIZE - next_index - 1, remaining - 1);
}

static int transfer_desc_init(struct edma_transfer *transfer, int count)
{
	struct edma_desc *desc_virt = transfer->desc_virt;
	dma_addr_t desc_bus = transfer->desc_bus;
	int i;

	/* create singly-linked list for SG DMA controller */
	for (i = 0; i < count - 1; i++) {
		/* increment bus address to next in array */
		desc_bus += sizeof(struct edma_desc);

		/* singly-linked list uses bus addresses */
		desc_virt[i].next_lo = cpu_to_le32(PCI_DMA_L(desc_bus));
		desc_virt[i].next_hi = cpu_to_le32(PCI_DMA_H(desc_bus));
		desc_virt[i].bytes = cpu_to_le32(0);

		desc_virt[i].control = cpu_to_le32(DESC_MAGIC);
	}
	/* { i = number - 1 } */
	/* zero the last descriptor next pointer */
	desc_virt[i].next_lo = cpu_to_le32(0);
	desc_virt[i].next_hi = cpu_to_le32(0);
	desc_virt[i].bytes = cpu_to_le32(0);
	desc_virt[i].control = cpu_to_le32(DESC_MAGIC);

	return 0;
}

static void edma_desc_set(struct edma_desc *desc, dma_addr_t rc_bus_addr, uint64_t ep_addr, int len, int dir)
{
	/* transfer length */
	desc->bytes = cpu_to_le32(len);
	if (dir == DMA_TO_DEVICE) {
		/* read from root complex memory (source address) */
		desc->src_addr_lo = cpu_to_le32(PCI_DMA_L(rc_bus_addr));
		desc->src_addr_hi = cpu_to_le32(PCI_DMA_H(rc_bus_addr));
		/* write to end point address (destination address) */
		desc->dst_addr_lo = cpu_to_le32(PCI_DMA_L(ep_addr));
		desc->dst_addr_hi = cpu_to_le32(PCI_DMA_H(ep_addr));
	} else {
		/* read from end point address (source address) */
		desc->src_addr_lo = cpu_to_le32(PCI_DMA_L(ep_addr));
		desc->src_addr_hi = cpu_to_le32(PCI_DMA_H(ep_addr));
		/* write to root complex memory (destination address) */
		desc->dst_addr_lo = cpu_to_le32(PCI_DMA_L(rc_bus_addr));
		desc->dst_addr_hi = cpu_to_le32(PCI_DMA_H(rc_bus_addr));
	}
}

static inline void edma_desc_done(struct edma_desc *desc_virt, int count)
{
	memset(desc_virt, 0, count * sizeof(struct edma_desc));
}

/* transfer_destroy() - free transfer */
static void transfer_destroy(struct edma_pci_dev *epdev, struct edma_transfer *trans)
{
    /* free descriptors */
	edma_desc_done(trans->desc_virt, trans->desc_num);

	if (trans->last_in_request && (trans->flags & TRANSFER_FLAG_NEED_UNMAP)) {
		struct sg_table *sgt = trans->sgt;

		if (sgt->nents) {
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
			dma_unmap_sg(&(epdev->pdev)->dev, sgt->sgl, sgt->nents,
#else
			pci_unmap_sg(epdev->pdev, sgt->sgl, sgt->nents,
#endif
				     trans->dir);
			sgt->nents = 0;
		}
	}
}

static int transfer_build(struct edma_engine *engine,
			struct edma_request_cb *req, struct edma_transfer *trans, uint32_t desc_max)
{
	int i = 0, j = 0;
	dma_addr_t bus = trans->res_bus;
	struct sw_desc *sdesc = &(req->sdesc[req->sw_desc_idx]);
	//pr_info("[DBG][transfer_build] Enter, desc_max=%d!\n", desc_max);
	for (; i < desc_max; i++, j++, sdesc++) {
		//pr_info("[DBG][transfer_build] sw desc %lld/%llu: 0x%llx, 0x%llx, ep 0x%llx.trans->desc_virt=0x%llx\n",
			 //i + req->sw_desc_idx, req->sw_desc_cnt, sdesc->addr,
			 //sdesc->len, req->ep_addr,  (uint64_t)trans->desc_virt);
		//pr_info("[DBG][transfer_build] i=%d, j=%d!\n", i, j);
		/* fill in descriptor entry j with transfer details */
		edma_desc_set(trans->desc_virt + j, sdesc->addr, req->ep_addr, sdesc->len, trans->dir);
		trans->len += sdesc->len;

		/* for non-inc-add mode don't increment ep_addr */
		if (!engine->non_incr_addr)
			req->ep_addr += sdesc->len;

		if (engine->streaming && engine->dir == DMA_FROM_DEVICE) {
			memset(trans->res_virt + j, 0,
				sizeof(struct edma_result));
			trans->desc_virt[j].src_addr_lo =
						cpu_to_le32(PCI_DMA_L(bus));
			trans->desc_virt[j].src_addr_hi =
						cpu_to_le32(PCI_DMA_H(bus));
			bus += sizeof(struct edma_result);
		}

	}
	req->sw_desc_idx += desc_max;
	//pr_info("[DBG][transfer_build] End, sw_desc_idx=%d!\n", req->sw_desc_idx);
	return 0;
}

static int transfer_init(struct edma_engine *engine, struct edma_request_cb *req, struct edma_transfer *trans)
{
	int ret = 0;
	unsigned int desc_max = min_t(unsigned int, req->sw_desc_cnt - req->sw_desc_idx, engine->desc_max);
	int i = 0;
	int last = 0;
	u32 control;
	unsigned long flags;

	memset(trans, 0, sizeof(*trans));

	/* lock the engine state */
	spin_lock_irqsave(&engine->lock, flags);
	/* initialize wait queue */
#if HAS_SWAKE_UP
	init_swait_queue_head(&trans->wq);
#else
	init_waitqueue_head(&trans->wq);
#endif

	/* remember direction of transfer */
	trans->dir = engine->dir;
	trans->desc_virt = engine->desc + engine->desc_idx;
	trans->res_virt = engine->cyclic_result + engine->desc_idx;
	trans->desc_bus = engine->desc_bus +
			(sizeof(struct edma_desc) * engine->desc_idx);
	trans->res_bus = engine->cyclic_result_bus +
			(sizeof(struct edma_result) * engine->desc_idx);
	trans->desc_index = engine->desc_idx;

	/* Need to handle desc_used >= engine->desc_max */
	if ((engine->desc_idx + desc_max) >= engine->desc_max)
		desc_max = engine->desc_max - engine->desc_idx;

	transfer_desc_init(trans, desc_max);
	//pr_info("[DBG][transfer_init] (%s)engine->desc=%p(0x%llx) desc_max=%d\n", engine->name, engine->desc, (uint64_t)engine->desc, desc_max);
	transfer_build(engine, req, trans, desc_max);
		

	//pr_info("[DBG][transfer_init] transfer=%p transfer->desc_bus = 0x%llx.trans->desc_virt=0x%llx\n", trans, (uint64_t)trans->desc_bus,  (uint64_t)trans->desc_virt);
	trans->desc_adjacent = desc_max;

	/* terminate last descriptor */
	last = desc_max - 1;
	/* stop engine, EOP for AXI ST, req IRQ on last descriptor */
	control = EDMA_DESC_STOPPED;
	control |= EDMA_DESC_EOP;
	control |= EDMA_DESC_COMPLETED;
	edma_desc_control_set(trans->desc_virt + last, control);

	if (engine->eop_flush) {
		for (i = 0; i < last; i++)
			edma_desc_control_set(trans->desc_virt + i, EDMA_DESC_COMPLETED);
		trans->desc_cmpl_th = 1;
	} else
		trans->desc_cmpl_th = desc_max;

	trans->desc_num = desc_max;
	engine->desc_idx = (engine->desc_idx + desc_max) % engine->desc_max;
	engine->desc_used += desc_max;

	/* fill in adjacent numbers */
	for (i = 0; i < trans->desc_num; i++) {
		uint32_t next_adj = edma_get_next_adj(trans->desc_num - i - 1,
						(trans->desc_virt + i)->next_lo);

		//pr_info("[DBG] set next adj at index %d to %u\n", i, next_adj);
		edma_desc_adjacent(trans->desc_virt + i, next_adj);
	}

	spin_unlock_irqrestore(&engine->lock, flags);

	return ret;
}

static struct edma_request_cb *edma_request_alloc(unsigned int sdesc_nr)
{
	struct edma_request_cb *req;
	unsigned int size = sizeof(struct edma_request_cb) + sdesc_nr * sizeof(struct sw_desc);

	req = kzalloc(size, GFP_KERNEL);
	if (!req) {
		req = vmalloc(size);
		if (req)
			memset(req, 0, size);
	}
	if (!req) {
		pr_warn("[WARN] OOM, %u sw_desc, %u.\n", sdesc_nr, size);
		return NULL;
	}

	return req;
}

static void edma_request_free(struct edma_request_cb *req)
{
	if (((unsigned long)req) >= VMALLOC_START && ((unsigned long)req) < VMALLOC_END)
		vfree(req);
	else
		kfree(req);
}
static struct edma_request_cb *edma_init_request(struct sg_table *sgt, uint64_t ep_addr)
{
	struct edma_request_cb *req;
	struct scatterlist *sg = sgt->sgl;
	int max = sgt->nents;
	int extra = 0;
	int i, j = 0;

	for (i = 0; i < max; i++, sg = sg_next(sg)) {
		unsigned int len = sg_dma_len(sg);

		if (unlikely(len > desc_blen_max))
			extra += (len + desc_blen_max - 1) / desc_blen_max;
	}

	//pr_info("[DBG] ep 0x%llx, desc %u+%u.\n", ep_addr, max, extra);

	max += extra;
	req = edma_request_alloc(max);
	if (!req)
		return NULL;

	req->sgt = sgt;
	req->ep_addr = ep_addr;

	for (i = 0, sg = sgt->sgl; i < sgt->nents; i++, sg = sg_next(sg)) {
		unsigned int tlen = sg_dma_len(sg);
		dma_addr_t addr = sg_dma_address(sg);

		req->total_len += tlen;
		while (tlen) {
			req->sdesc[j].addr = addr;
			if (tlen > desc_blen_max) {
				req->sdesc[j].len = desc_blen_max;
				addr += desc_blen_max;
				tlen -= desc_blen_max;
			} else {
				req->sdesc[j].len = tlen;
				tlen = 0;
			}
			j++;
		}
	}

	if (j > max) {
		pr_err("[ERROR] Cannot transfer more than supported length %d MB\n", desc_blen_max/1024/1024);
		edma_request_free(req);
		return NULL;
	}
	req->sw_desc_cnt = j;
#ifdef __EDMA_DEBUG__
	//edma_request_cb_dump(req);
#endif
	return req;
}

/**
 * engine_status_read() - read status of SG DMA engine (optionally reset)
 *
 * Stores status in engine->status.
 *
 * @return error value on failure, 0 otherwise
 */
static int engine_status_read(struct edma_engine *engine, bool clear)
{
	int ret = 0;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/* read status register */
	if (clear)
		engine->status = read_register(&engine->regs->status_rc);
	else
		engine->status = read_register(&engine->regs->status);

	return ret;
}

/**
 * xdma_engine_stop() - stop an SG DMA engine
 *
 */
static int edma_engine_stop(struct edma_engine *engine)
{
	uint32_t reg_val;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}
	if (enable_st_d2h_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE)
		write_register(0, &engine->sgdma_regs->credits, 0);
	reg_val = 0;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
	reg_val |= (uint32_t)EDMA_CTRL_IE_MAGIC_STOPPED;
	reg_val |= (uint32_t)EDMA_CTRL_IE_READ_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ERROR;

	if (poll_mode) {
		reg_val |= (uint32_t)EDMA_CTRL_POLL_MODE_WB;
	} else {
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_STOPPED;
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_COMPLETED;
	}
	//pr_info("[DBG] Stopping SG DMA %s engine; writing 0x%08x to 0x%p.\n", engine->name, reg_val, (uint32_t *)&engine->regs->control);
	write_register(reg_val, &engine->regs->control,
			(unsigned long)(&engine->regs->control) - (unsigned long)(&engine->regs));
	/* dummy read of status register to flush all previous writes */
	//pr_info("[DBG] %s(%s) done\n", __func__, engine->name);
	engine->running = 0;
	return 0;
}

/**
 * engine_start() - start an idle engine with its first transfer on queue
 *
 * The engine will run and process all transfers that are queued using
 * transfer_queue() and thus have their descriptor lists chained.
 *
 * During the run, new transfers will be processed if transfer_queue() has
 * chained the descriptors before the hardware fetches the last descriptor.
 * A transfer that was chained too late will invoke a new run of the engine
 * initiated from the engine_service() routine.
 *
 * The engine must be idle and at least one transfer must be queued.
 * This function does not take locks; the engine spinlock must already be
 * taken.
 *
 */
static struct edma_transfer *engine_start(struct edma_engine *engine)
{
	int ret;
	uint32_t reg_val, next_adj;
	struct edma_transfer *transfer;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	/* engine must be idle */
	if (engine->running) {
		pr_info("[ERROR] %s engine is not in idle state to start\n", engine->name);
		return NULL;
	}

	/* engine transfer queue must not be empty */
	if (list_empty(&engine->transfer_list)) {
		pr_warn("[WARN] %s engine transfer queue must not be empty\n", engine->name);
		return NULL;
	}
	/* inspect first transfer queued on the engine */
	transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
	if (!transfer) {
		pr_warn("[WARN] %s queued transfer must not be empty\n", engine->name);
		return NULL;
	}

	/* engine is no longer shutdown */
	engine->shutdown = ENGINE_SHUTDOWN_NONE;

	//pr_info("[DBG] %s(%s): transfer=0x%p.\n", __func__, engine->name, transfer);
	/* Add credits for Streaming mode C2H */
	if (enable_st_d2h_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE)
		write_register(engine->desc_used, &engine->sgdma_regs->credits, 0);
	
	/* initialize number of descriptors of dequeued transfers */
	engine->desc_dequeued = 0;

	/* write lower 32-bit of bus address of transfer first descriptor */
	reg_val = cpu_to_le32(PCI_DMA_L(transfer->desc_bus));
	//pr_info("[DBG] iowrite32(0x%08x to 0x%p) (first_desc_lo)\n", reg_val, (void *)&engine->sgdma_regs->first_desc_lo);
	write_register(reg_val, &engine->sgdma_regs->first_desc_lo, 
					(unsigned long)(&engine->sgdma_regs->first_desc_lo) - (unsigned long)(&engine->sgdma_regs));
	/* write upper 32-bit of bus address of transfer first descriptor */
	reg_val = cpu_to_le32(PCI_DMA_H(transfer->desc_bus));
	//pr_info("[DBG] iowrite32(0x%08x to 0x%p) (first_desc_hi)\n", reg_val, (void *)&engine->sgdma_regs->first_desc_hi);
	write_register(reg_val, &engine->sgdma_regs->first_desc_hi,
					(unsigned long)(&engine->sgdma_regs->first_desc_hi) - (unsigned long)(&engine->sgdma_regs));

	next_adj = edma_get_next_adj(transfer->desc_adjacent, cpu_to_le32(PCI_DMA_L(transfer->desc_bus)));

	//pr_info("[DBG] iowrite32(0x%08x to 0x%p) (first_desc_adjacent)\n", next_adj,
	//				(void *)&engine->sgdma_regs->first_desc_adjacent);

	write_register(next_adj, &engine->sgdma_regs->first_desc_adjacent,
					(unsigned long)(&engine->sgdma_regs->first_desc_adjacent) -
					(unsigned long)(&engine->sgdma_regs));

	//pr_info("[DBG] ioread32(0x%p) (dummy read flushes writes).\n", &engine->regs->status);
	
	//linc dbg
	//void dbg_set_desc_info(uint32_t lo_addr, uint32_t hi_addr, uint8_t adj);
	//dbg_set_desc_info(PCI_DMA_L(transfer->desc_bus), PCI_DMA_H(transfer->desc_bus), next_adj);

#if HAS_MMIOWB
	mmiowb();
#endif
	ret = engine_start_mode_config(engine);
	if (ret < 0) {
		pr_err("[ERROR] Failed to start engine mode config\n");
		return NULL;
	}

	ret = engine_status_read(engine, 0);
	if (ret < 0) {
		pr_err("[ERROR] Failed to read engine status\n");
		return NULL;
	}
	//pr_info("[DBG] %s engine 0x%p now running\n", engine->name, engine);
	
	/* remember the engine is running */
	engine->running = 1;

	return transfer;
}

/* transfer_queue() - Queue a DMA transfer on the engine
 *
 * @engine DMA engine doing the transfer
 * @transfer DMA transfer submitted to the engine
 *
 * Takes and releases the engine spinlock
 */
static int transfer_queue(struct edma_engine *engine, struct edma_transfer *transfer)
{
	int ret = 0;
	unsigned long flags;
	struct edma_transfer *transfer_started;
	struct edma_pci_dev *epdev;
	
	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	if (!engine->epdev) {
		pr_err("[ERROR] Invalid edma PCIE device\n");
		return -EINVAL;
	}

	if (!transfer) {
		pr_err("[ERROR] %s Invalid DMA transfer\n", engine->name);
		return -EINVAL;
	}

	if (transfer->desc_num == 0) {
		pr_err("[ERROR] %s void descriptors in the transfer list\n", engine->name);
		return -EINVAL;
	}

	epdev = (struct edma_pci_dev *)engine->epdev;
	/* lock the engine state */
	spin_lock_irqsave(&engine->lock, flags);

	engine->prev_cpu = get_cpu();
	put_cpu();

	/* engine is being shutdown; do not accept new transfers */
	if (engine->shutdown & ENGINE_SHUTDOWN_REQUEST) {
		pr_info("engine %s offline, transfer 0x%p not queued.\n", engine->name, transfer);
		ret = -EBUSY;
		goto shutdown;
	}

	/* mark the transfer as submitted */
	transfer->state = TRANSFER_STATE_SUBMITTED;
	/* add transfer to the tail of the engine transfer queue */
	list_add_tail(&transfer->entry, &engine->transfer_list);

	/* engine is idle? */
	if (!engine->running) {
		/* start engine */
		//pr_info("[DBG] %s(): starting %s engine.\n", __func__, engine->name);
		transfer_started = engine_start(engine);
		if (!transfer_started) {
			pr_err("[ERROR] Failed to start dma engine\n");
			goto shutdown;
		}
		//pr_info("[DBG] transfer=0x%p started %s engine with transfer 0x%p.\n", transfer, engine->name, transfer_started);
	} else {
		//pr_info("[DBG] transfer=0x%p queued, with %s engine running.\n", transfer, engine->name);
	}

shutdown:
	/* unlock the engine state */
	//pr_info("[DBG] engine->running = %d\n", engine->running);
	spin_unlock_irqrestore(&engine->lock, flags);
	
	return ret;
}

/*
 * should hold the engine->lock;
 */
static int transfer_abort(struct edma_engine *engine, struct edma_transfer *transfer)
{
	struct edma_transfer *head;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	if (!transfer) {
		pr_err("[ERROR] Invalid DMA transfer\n");
		return -EINVAL;
	}

	if (transfer->desc_num == 0) {
		pr_err("[ERROR] %s void descriptors in the transfer list\n", engine->name);
		return -EINVAL;
	}

	pr_info("[DBG] abort transfer 0x%p, desc %d, engine desc queued %d.\n",
		transfer, transfer->desc_num, engine->desc_dequeued);

	head = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
	if (head == transfer)
		list_del(engine->transfer_list.next);
	else
		pr_info("[DBG] engine %s, transfer 0x%p NOT found, 0x%p.\n", engine->name, transfer, head);

	if (transfer->state == TRANSFER_STATE_SUBMITTED)
		transfer->state = TRANSFER_STATE_ABORTED;
	return 0;
}

static void dump_desc(struct edma_desc *desc_virt)
{
	int j;
	u32 *p = (u32 *)desc_virt;
	static char *const field_name[] = { "magic|extra_adjacent|control",
					    "bytes",
					    "src_addr_lo",
					    "src_addr_hi",
					    "dst_addr_lo",
					    "dst_addr_hi",
					    "next_addr",
					    "next_addr_pad" };
	char *dummy;

	/* remove warning about unused variable when debug printing is off */
	dummy = field_name[0];

	for (j = 0; j < 8; j += 1) {
		pr_info("0x%08lx/0x%02lx: 0x%08x 0x%08x %s\n", (uintptr_t)p,
			(uintptr_t)p & 15, (int)*p, le32_to_cpu(*p),
			field_name[j]);
		p++;
	}
	pr_info("\n");
}

static void transfer_dump(struct edma_transfer *transfer)
{
	int i;
	struct edma_desc *desc_virt = transfer->desc_virt;

	pr_info("[DBG] transfer 0x%p, state 0x%x, f 0x%x, dir %d, len %u, last %d.\n",
		transfer, transfer->state, transfer->flags, transfer->dir,
		transfer->len, transfer->last_in_request);

	pr_info("DBG] transfer 0x%p, desc %d, bus 0x%llx, adj %d.\n", transfer,
		transfer->desc_num, (u64)transfer->desc_bus,
		transfer->desc_adjacent);
	for (i = 0; i < transfer->desc_num; i += 1)
		dump_desc(desc_virt + i);
}


ssize_t edma_submit_request(struct edma_engine *engine, uint64_t ep_addr, struct sg_table *sgt, bool dma_mapped)
{
	int i, ret, nents, trans_idx = 0;
	unsigned long flags;
	struct edma_pci_dev *epdev;
	struct scatterlist *sg = sgt->sgl;
	ssize_t done_size = 0;
	struct edma_request_cb *req = NULL;
	struct edma_transfer *trans;

	if (!engine) {
		pr_err("[ERROR] dma engine is NULL\n");
		return -EINVAL;
	}
	epdev = (struct edma_pci_dev *)engine->epdev;
	
	if (!dma_mapped) {
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		nents = dma_map_sg(&(epdev->pdev)->dev, sg, sgt->orig_nents, engine->dir);
#else
		nents = pci_map_sg(epdev->pdev, sg, sgt->orig_nents, engine->dir);
#endif
		if (!nents) {
			pr_err("[ERROR] map sgl failed, sgt 0x%p.\n", sgt);
			return -EIO;
		}
		sgt->nents = nents;
	} else {
		if (!sgt->nents) {
			pr_err("[ERROR] sg table has invalid number of entries 0x%p.\n", sgt);
			return -EIO;
		}
	}

	req = edma_init_request(sgt, ep_addr);
	if (!req) {
		ret = -ENOMEM;
		goto UNMAP_SGL;
	}
	
	
	while (nents) {
		/* build transfer */
		ret = transfer_init(engine, req, &req->tfer[0]);
		if (ret < 0) {
			mutex_unlock(&engine->desc_lock);
			goto UNMAP_SGL;
		}
		trans = &req->tfer[0];
		if (!dma_mapped)
			trans->flags = TRANSFER_FLAG_NEED_UNMAP;

		/* last transfer for the given request? */
		nents -= trans->desc_num;
		if (!nents) {
			trans->last_in_request = 1;
			trans->sgt = sgt;
		}

		//pr_info("[DBG] transfer, %u, ep=0x%llx, done size=%lu, sg=%llu/%llu.\n", trans->len, req->ep_addr, done_size, req->sw_desc_idx, req->sw_desc_cnt);

#ifdef __EDMA_DEBUG__
		transfer_dump(trans);
#endif
		ret = transfer_queue(engine, trans);
		if (ret < 0) {
			mutex_unlock(&engine->desc_lock);
			pr_info("unable to submit %s, %d.\n", engine->name, ret);
			goto UNMAP_SGL;
		}
		
		if (engine->cmplthp)
			edma_kthread_wakeup(engine->cmplthp);
		
		// wait for DMA done signal
		edma_wait_event_interruptible(trans->wq, (trans->state != TRANSFER_STATE_SUBMITTED));

		
		spin_lock_irqsave(&engine->lock, flags);

		switch (trans->state) {
			case TRANSFER_STATE_COMPLETED:
				spin_unlock_irqrestore(&engine->lock, flags);
				ret = 0;
				//pr_info("[DBG] transfer=%p, %u, ep 0x%llx compl, +%lu.\n", trans, trans->len, req->ep_addr - trans->len, done_size);
				/* For D2H streaming use writeback results */
				if (engine->streaming && engine->dir == DMA_FROM_DEVICE) {
					struct edma_result *result = trans->res_virt;

					for (i = 0; i < trans->desc_cmpl; i++)
						done_size += result[i].length;

					/* finish the whole request */
					if (engine->eop_flush)
						nents = 0;
				} else {
					done_size += trans->len;
				}
				break;
			case TRANSFER_STATE_FAILED:
				pr_info("[DBG] transfer=%p, %u, failed, ep 0x%llx.\n", trans, trans->len, req->ep_addr - trans->len);
				spin_unlock_irqrestore(&engine->lock, flags);
#ifdef __EDMA_DEBUG__
				transfer_dump(trans);
				//sgt_dump(sgt);
#endif
				ret = -EIO;
				break;
		default:
			/* transfer can still be in-flight */
			pr_info("[DBG] transfer=%p,%u, s 0x%x timed out, ep 0x%llx.\n", trans, trans->len, trans->state, req->ep_addr);
			ret = engine_status_read(engine, 0);
			if (ret < 0) {
				pr_err("[ERROR] Failed to read engine status\n");
			} else if (ret == 0) {
				//engine_status_dump(engine);
				ret = transfer_abort(engine, trans);
				if (ret < 0) {
					pr_err("[ERROR] Failed to stop engine\n");
				} else if (ret == 0) {
					ret = edma_engine_stop(engine);
					if (ret < 0)
						pr_err("[ERROR] Failed to stop engine\n");
				}
			}
			spin_unlock_irqrestore(&engine->lock, flags);
#ifdef __EDMA_DEBUG__
			transfer_dump(trans);
			//sgt_dump(sgt);
#endif
			ret = -ERESTARTSYS;
			break;
		}

		engine->desc_used -= trans->desc_num;
		transfer_destroy(epdev, trans);

		/* use multiple transfers per request if we could not fit
		 * all data within single descriptor chain.
		 */
		trans_idx++;

		if (ret < 0) {
			mutex_unlock(&engine->desc_lock);
			goto UNMAP_SGL;
		}
	} /* while (sg) */
	mutex_unlock(&engine->desc_lock);
UNMAP_SGL:
	if (!dma_mapped && sgt->nents) {
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		dma_unmap_sg(&(epdev->pdev)->dev, sgt->sgl, sgt->orig_nents, engine->dir);
#else
		pci_unmap_sg(epdev->pdev, sgt->sgl, sgt->orig_nents, engine->dir);
#endif
		sgt->nents = 0;
	}

	if (req)
		edma_request_free(req);

	/* as long as some data is processed, return the count */
	return done_size ? done_size : ret;
}

static int request_regions(struct edma_pci_dev *epdev)
{
	int ret;

	if (!epdev) {
		pr_err("[ERROR] Invalid edma PCIE dev\n");
		return -EINVAL;
	}

	if (!epdev->pdev) {
		pr_err("[ERROR] Invalid pdev\n");
		return -EINVAL;
	}

	pr_info("[DBG] pci_request_regions()\n");
	ret = pci_request_regions(epdev->pdev, EDMA_MOD_NAME);
	/* could not request all regions? */
	if (ret) {
		pr_info("[DBG] pci_request_regions() = %d, device in use?\n", ret);
		/* assume device is in use so do not disable it later */
		epdev->regions_in_use = 1;
	} else {
		epdev->got_regions = 1;
	}

	return ret;
}

/*
 * Unmap the BAR regions that had been mapped earlier using map_bars()
 */
static void unmap_bars(struct edma_pci_dev *epdev)
{
	int i;

	for (i = 0; i < EDMA_PCIE_BAR_NUM; i++) {
		/* is this BAR mapped? */
		if (epdev->bar[i]) {
			/* unmap BAR */
			pci_iounmap(epdev->pdev, epdev->bar[i]);
			/* mark as unmapped */
			epdev->bar[i] = NULL;
		}
	}
}

static int map_single_bar(struct edma_pci_dev *epdev, int idx)
{
	resource_size_t bar_start;
	resource_size_t bar_len;
	resource_size_t map_len;

	bar_start = pci_resource_start(epdev->pdev, idx);
	bar_len = pci_resource_len(epdev->pdev, idx);
	map_len = bar_len;

	epdev->bar[idx] = NULL;

	/* do not map BARs with length 0. Note that start MAY be 0! */
	if (!bar_len) {
		//pr_info("BAR #%d is not present - skipping\n", idx);
		return 0;
	}

	/* BAR size exceeds maximum desired mapping? */
	if (bar_len > INT_MAX) {
		pr_info("Limit BAR %d mapping from %llu to %d bytes\n", idx,
			(u64)bar_len, INT_MAX);
		map_len = (resource_size_t)INT_MAX;
	}
	/*
	 * map the full device memory or IO region into kernel virtual
	 * address space
	 */
	pr_info("[DBG] BAR%d: %llu bytes to be mapped.\n", idx, (u64)map_len);
	epdev->bar[idx] = pci_iomap(epdev->pdev, idx, map_len);

	if (!epdev->bar[idx]) {
		pr_info("[ERROR] Could not map BAR %d.\n", idx);
		return -1;
	}

	pr_info("BAR%d at 0x%llx mapped at 0x%p, length=%llu(/%llu)\n", idx,
		(u64)bar_start, epdev->bar[idx], (u64)map_len, (u64)bar_len);

	return (int)map_len;
}

static int is_config_bar(struct edma_pci_dev *epdev, int idx)
{
	uint32_t irq_id = 0, cfg_id = 0, flag = 0;
	uint32_t mask = 0xffff0000;
	struct interrupt_regs *irq_regs = (struct interrupt_regs *)(epdev->bar[idx] + EDMA_OFS_INT_CTRL);
	struct config_regs *cfg_regs = (struct config_regs *)(epdev->bar[idx] + EDMA_OFS_CONFIG);

	irq_id = read_register(&irq_regs->identifier);
	cfg_id = read_register(&cfg_regs->identifier);

	if (((irq_id & mask) == IRQ_BLOCK_ID) && ((cfg_id & mask) == CONFIG_BLOCK_ID)) {
		pr_info("[DBG] BAR %d is the EDMA config BAR\n", idx);
		flag = 1;
	} else {
		pr_info("[DBG] BAR %d is NOT the EDMA config BAR: 0x%x, 0x%x.\n", idx, irq_id, cfg_id);
		flag = 0;
	}

	return flag;
}

#ifndef EDMA_CONFIG_BAR_NUM
static int identify_bars(struct edma_pci_dev *epdev, int *bar_id_list, int num_bars,
			 int config_bar_pos)
{
	if (!epdev) {
		pr_err("[ERROR] Invalid xdev\n");
		return -EINVAL;
	}

	if (!bar_id_list) {
		pr_err("[ERROR] Invalid bar id list.\n");
		return -EINVAL;
	}

	pr_info("epdev 0x%p, bars %d, config at %d.\n", epdev, num_bars, config_bar_pos);

	switch (num_bars) {
	case 1:
		/* Only one BAR present - no extra work necessary */
		break;

	case 2:
		if (config_bar_pos == 0) {
			epdev->bypass_bar_idx = bar_id_list[1];
		} else if (config_bar_pos == 1) {
			epdev->user_bar_idx = 4;//bar_id_list[0];
		} else {
			pr_info("2, EDMA config BAR unexpected %d.\n", config_bar_pos);
		}
		break;

	case 3:
	case 4:
		if ((config_bar_pos == 1) || (config_bar_pos == 2)) {
			/* user bar at bar #0 */
			epdev->user_bar_idx = bar_id_list[0];
			/* bypass bar at the last bar */
			epdev->bypass_bar_idx = bar_id_list[num_bars - 1];
		} else {
			pr_info("3/4, EDMA config BAR unexpected %d.\n", config_bar_pos);
		}
		break;

	default:
		/* Should not occur - warn user but safe to continue */
		pr_info("Unexpected # BARs (%d), EDMA config BAR only.\n", num_bars);
		break;
	}
	pr_info("%d BARs: config %d, user %d, bypass %d.\n", num_bars,
		config_bar_pos, epdev->user_bar_idx, epdev->bypass_bar_idx);
	return 0;
}
#endif

/* map_bars() -- map device regions into kernel virtual address space
 *
 * Map the device memory regions into kernel virtual address space after
 * verifying their sizes respect the minimum sizes needed
 */
static int map_bars(struct edma_pci_dev *epdev)
{
	int ret;
#ifdef EDMA_CONFIG_BAR_NUM
	ret = map_single_bar(epdev, EDMA_CONFIG_BAR_NUM);
	if (ret <= 0) {
		pr_info("%s, map config bar %d failed, %d.\n",
			dev_name(&epdev->pdev->dev), EDMA_CONFIG_BAR_NUM, ret);
		return -EINVAL;
	}

	if (is_config_bar(epdev, EDMA_CONFIG_BAR_NUM) == 0) {
		pr_info("%s, unable to identify config bar %d.\n",
			dev_name(&epdev->pdev->dev), EDMA_CONFIG_BAR_NUM);
		return -EINVAL;
	}
	epdev->config_bar_idx = EDMA_CONFIG_BAR_NUM;

	if (!pci_resource_len(epdev->pdev, EDMA_BYPASS_BAR_NUM))
		return 0;
	ret = map_single_bar(epdev, EDMA_BYPASS_BAR_NUM);
	if (ret <= 0) {
		pr_info("%s, map bypass bar %d failed, %d.\n",
			dev_name(&epdev->pdev->dev), EDMA_BYPASS_BAR_NUM, ret);
		return -EINVAL;
	}
	epdev->config_bar_idx = EDMA_CONFIG_BAR_NUM;
	pr_info("%s, map bypass bar on bar[%d] DONE!\n", dev_name(&epdev->pdev->dev), EDMA_BYPASS_BAR_NUM);
#else
	int i;
	int bar_id_list[EDMA_BAR_NUM];
	int bar_id_idx = 0;
	int config_bar_pos = 0;

	/* iterate through all the BARs */
	for (i = 0; i < EDMA_BAR_NUM; i++) {
		int bar_len;

		bar_len = map_single_bar(epdev, i);
		if (bar_len == 0) {
			continue;
		} else if (bar_len < 0) {
			ret = -EINVAL;
			goto fail;
		}

		/* Try to identify BAR as EDMA control BAR */
		if (epdev->config_bar_idx < 0) {
			if (is_config_bar(epdev, i)) {
				epdev->config_bar_idx = i;
				config_bar_pos = bar_id_idx;
				pr_info("config bar %d, pos %d.\n",	epdev->config_bar_idx, config_bar_pos);
			}
		}
		if (i == 4 || i ==5) {
			epdev->user_bar_idx = i;
		}
		bar_id_list[bar_id_idx] = i;
		bar_id_idx++;
	}

	/* The XDMA config BAR must always be present */
	if (epdev->config_bar_idx < 0) {
		pr_info("[ERROR] Failed to detect EDMA config BAR\n");
		ret = -EINVAL;
		goto fail;
	}
/*
	ret = identify_bars(epdev, bar_id_list, bar_id_idx, config_bar_pos);
	if (ret < 0) {
		pr_err("[ERROR] Failed to identify bars\n");
		return ret;
	}
*/
	/* successfully mapped all required BAR regions */
	return 0;

fail:
	/* unwind; unmap any BARs that we did map */
	unmap_bars(epdev);
	return ret;

#endif
	return 0;
}

static void check_nonzero_interrupt_status(struct edma_pci_dev *epdev)
{
	struct interrupt_regs *reg;
	uint32_t val;
	
	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);
	val = read_register(&reg->user_int_enable);
	if (val)
		pr_info("%s edma%d user_int_enable = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);

	val = read_register(&reg->channel_int_enable);
	if (val)
		pr_info("%s edma%d channel_int_enable = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);

	val = read_register(&reg->user_int_request);
	if (val)
		pr_info("%s edma%d user_int_request = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);
	val = read_register(&reg->channel_int_request);
	if (val)
		pr_info("%s edma%d channel_int_request = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);

	val = read_register(&reg->user_int_pending);
	if (val)
		pr_info("%s edma%d user_int_pending = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);
	val = read_register(&reg->channel_int_pending);
	if (val)
		pr_info("%s edma%d channel_int_pending = 0x%08x\n",
			dev_name(&epdev->pdev->dev), epdev->idx, val);
	return;
}

/* user_interrupts_disable -- Disable interrupts we not interested in */
static void user_interrupts_disable(struct edma_pci_dev *epdev, u32 mask)
{
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);

	write_register(mask, &reg->user_int_enable_w1c, EDMA_OFS_INT_CTRL);
	return;
}

/* channel_interrupts_disable -- Disable interrupts we not interested in */
static void channel_interrupts_disable(struct edma_pci_dev *epdev, uint32_t mask)
{
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);

	//write_register(0, &reg->channel_int_enable, EDMA_OFS_INT_CTRL);
	write_register(mask, &reg->channel_int_enable_w1c, EDMA_OFS_INT_CTRL);
	return;
}

/* read_interrupts -- Print the interrupt controller status */
static u32 read_interrupts(struct edma_pci_dev *epdev)
{
	uint32_t lo, hi;
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);
	/* extra debugging; inspect complete engine set of registers */
	hi = read_register(&reg->user_int_request);
	pr_info("[DBG] ioread32(0x%p) returned 0x%08x (user_int_request).\n",
	       &reg->user_int_request, hi);
	lo = read_register(&reg->channel_int_request);
	pr_info("[DBG] ioread32(0x%p) returned 0x%08x (channel_int_request)\n",
	       &reg->channel_int_request, lo);

	/* return interrupts: user in upper 16-bits, channel in lower 16-bits */
	return build_uint32(hi, lo);
}

#ifndef arch_msi_check_device
static int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
{
	return 0;
}
#endif

/* type = PCI_CAP_ID_MSI or PCI_CAP_ID_MSIX */
static int msi_msix_capable(struct pci_dev *dev, int type)
{
	struct pci_bus *bus;
	int ret;

	if (!dev || dev->no_msi)
		return 0;

	for (bus = dev->bus; bus; bus = bus->parent)
		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
			return 0;

	ret = arch_msi_check_device(dev, 1, type);
	if (ret)
		return 0;

	if (!pci_find_capability(dev, type))
		return 0;

	return 1;
}

static int enable_msi_msix(struct edma_pci_dev *epdev)
{
	int ret = 0;

	if (!epdev) {
		pr_err("[ERROR] Invalid edma PCIE dev\n");
		return -EINVAL;
	}

	if ((interrupt_mode == 3 || !interrupt_mode) && msi_msix_capable(epdev->pdev, PCI_CAP_ID_MSIX)) {
		int req_nvec = epdev->d2h_channel_max + epdev->h2d_channel_max + epdev->user_irqs_max;

#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		pr_info("[DBG] Enabling MSI-X, req_nvec=%d\n", req_nvec);
		ret = pci_alloc_irq_vectors(epdev->pdev, req_nvec, req_nvec, PCI_IRQ_MSIX);
#else
		int i;
		pr_info("[DBG] Enabling MSI-X\n");
		for (i = 0; i < req_nvec; i++)
			epdev->entry[i].entry = i;

		ret = pci_enable_msix(pdev, epdev->entry, req_nvec);
#endif
		if (ret < 0)
			pr_info("[DBG] Couldn't enable MSI-X mode: %d\n", ret);

		epdev->msix_enabled = 1;

	} else if ((interrupt_mode == 1 || !interrupt_mode) &&
		   msi_msix_capable(epdev->pdev, PCI_CAP_ID_MSI)) {
		/* enable message signalled interrupts */
		pr_info("[DBG] pci_enable_msi()\n");
		ret = pci_enable_msi(epdev->pdev);
		if (ret < 0)
			pr_info("[DBG] Couldn't enable MSI mode: %d\n", ret);
		epdev->msi_enabled = 1;

	} else {
		pr_info("[DBG] MSI/MSI-X not detected - using legacy interrupts\n");
	}

	return ret;
}

static void disable_msi_msix(struct edma_pci_dev *epdev)
{
	if (epdev->msix_enabled) {
		pci_disable_msix(epdev->pdev);
		epdev->msix_enabled = 0;
	} else if (epdev->msi_enabled) {
		pci_disable_msi(epdev->pdev);
		epdev->msi_enabled = 0;
	}
	write_register(0, epdev->bar[epdev->config_bar_idx] + 0x400a8, 0x400a8);//linc: disable msix intr
}

static int get_engine_id(struct engine_regs *regs)
{
	int value;

	if (!regs) {
		pr_err("[ERROR] Invalid engine registers\n");
		return -EINVAL;
	}

	value = read_register(&regs->identifier);
	return (value & 0xffff0000U) >> 16;
}

static int get_engine_channel_id(struct engine_regs *regs)
{
	int value;

	if (!regs) {
		pr_err("[ERROR] Invalid engine registers\n");
		return -EINVAL;
	}

	value = read_register(&regs->identifier);

	return (value & 0x00000f00U) >> 8;
}


extern uint32_t *dbg_poll_mode_addr_virt;

static void engine_free_resource(struct edma_engine *engine)
{
	struct edma_pci_dev *epdev = (struct edma_pci_dev *)engine->epdev;

	/* Release memory use for descriptor writebacks */
	if (engine->poll_mode_addr_virt) {
		pr_info("[DBG] Releasing memory for descriptor writeback\n");
		dbg_poll_mode_addr_virt = NULL;
		dma_free_coherent(&epdev->pdev->dev, sizeof(struct edma_poll_wb),
				  engine->poll_mode_addr_virt,
				  engine->poll_mode_bus);
		pr_info("[DBG] Released memory for descriptor writeback\n");
		engine->poll_mode_addr_virt = NULL;
	}
	
	if (engine->desc) {
		pr_info("[DBG] device %s, engine %s pre-alloc desc 0x%p,0x%llx.\n",
			 dev_name(&epdev->pdev->dev), engine->name, engine->desc,
			 engine->desc_bus);
		dma_free_coherent(&epdev->pdev->dev,
				  engine->desc_max * sizeof(struct edma_desc),
				  engine->desc, engine->desc_bus);
		engine->desc = NULL;
	}
}

static int engine_alloc_resource(struct edma_engine *engine)
{
	struct edma_pci_dev *epdev = (struct edma_pci_dev *)engine->epdev;

	engine->desc = dma_alloc_coherent(&epdev->pdev->dev, engine->desc_max * sizeof(struct edma_desc),
					  &engine->desc_bus, GFP_KERNEL);
	if (!engine->desc) {
		pr_err("[ERROR] dev %s, %s pre-alloc desc OOM.\n", dev_name(&epdev->pdev->dev), engine->name);
		goto err_out;
	}
	
	if (poll_mode) {
		engine->poll_mode_addr_virt =
			dma_alloc_coherent(&epdev->pdev->dev, sizeof(struct edma_poll_wb),
					   &engine->poll_mode_bus, GFP_KERNEL);
		//dbg_poll_mode_addr_virt = (uint32_t*)engine->poll_mode_addr_virt;//linc dbg
		if (!engine->poll_mode_addr_virt) {
			pr_warn("[WARN] %s, %s poll pre-alloc writeback OOM.\n", dev_name(&epdev->pdev->dev), engine->name);
			goto err_out;
		}
	}
	if (engine->streaming && engine->dir == DMA_FROM_DEVICE) {
		engine->cyclic_result = dma_alloc_coherent(
			&epdev->pdev->dev,
			engine->desc_max * sizeof(struct edma_result),
			&engine->cyclic_result_bus, GFP_KERNEL);

		if (!engine->cyclic_result) {
			pr_warn("%s, %s pre-alloc result OOM.\n",
				dev_name(&epdev->pdev->dev), engine->name);
			goto err_out;
		}
	}
	return 0;

err_out:
	engine_free_resource(engine);
	return -ENOMEM;
}

/* channel_interrupts_enable -- Enable interrupts we are interested in */
static void channel_interrupts_enable(struct edma_pci_dev *epdev, uint32_t mask)
{
	struct interrupt_regs *reg =
		(struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);

	write_register(mask, &reg->channel_int_enable_w1s, EDMA_OFS_INT_CTRL);
}

static struct edma_transfer *engine_transfer_completion(struct edma_engine *engine, struct edma_transfer *transfer)
{
	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (unlikely(!transfer)) {
		pr_err("[ERROR] %s transfer empty.\n", engine->name);
		return NULL;
	}
	/* synchronous I/O? */
	/* awake task on transfer's wait queue */
	dma_wake_up(&transfer->wq);

	return transfer;
}

static struct edma_transfer *engine_service_transfer_list(struct edma_engine *engine,
			     struct edma_transfer *transfer, uint32_t *pdesc_completed)
{
	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (!pdesc_completed) {
		pr_err("[ERROR] %s completed descriptors are null.\n", engine->name);
		return NULL;
	}

	if (unlikely(!transfer)) {
		pr_err("[ERROR] %s transfer empty, pdesc completed %u.\n", engine->name, *pdesc_completed);
		return NULL;
	}

	/*
	* iterate over all the transfers completed by the engine,
	* except for the last (i.e. use > instead of >=).
	*/
	while (transfer && (!transfer->cyclic) && (*pdesc_completed > transfer->desc_num)) {
		/* remove this transfer from pdesc_completed */
		*pdesc_completed -= transfer->desc_num;
		pr_info("[DBG] %s engine completed non-cyclic transfer 0x%p (%d desc)\n", engine->name, transfer, transfer->desc_num);

		/* remove completed transfer from list */
		list_del(engine->transfer_list.next);
		/* add to dequeued number of descriptors during this run */
		engine->desc_dequeued += transfer->desc_num;
		/* mark transfer as succesfully completed */
		transfer->state = TRANSFER_STATE_COMPLETED;

		/*
		* Complete transfer - sets transfer to NULL if an async
		* transfer has completed
		*/
		transfer = engine_transfer_completion(engine, transfer);

		/* if exists, get the next transfer on the list */
		if (!list_empty(&engine->transfer_list)) {
			transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
			pr_info("[DBG] Non-completed transfer %p\n", transfer);
		} else {
			/* no further transfers? */
			transfer = NULL;
		}
	}

	return transfer;
}

static int engine_service_shutdown(struct edma_engine *engine)
{
	int ret;
	/* if the engine stopped with RUN still asserted, de-assert RUN now */
	ret = edma_engine_stop(engine);
	if (ret < 0) {
		pr_err("Failed to stop engine\n");
		return ret;
	}

	/* awake task on engine's shutdown wait queue */
	dma_wake_up(&engine->shutdown_wq);
	return 0;
}

static struct edma_transfer *engine_service_final_transfer(struct edma_engine *engine,
			      struct edma_transfer *transfer, uint32_t *pdesc_completed)
{
	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (!pdesc_completed) {
		pr_err("[ERROR] %s completed descriptors are null.\n", engine->name);
		return NULL;
	}

	if (unlikely(!transfer)) {
		pr_err("[ERROR] %s transfer empty, pdesc completed %u.\n", engine->name, *pdesc_completed);
		return NULL;
	}


	if (((engine->dir == DMA_FROM_DEVICE) && (engine->status & EDMA_STAT_D2H_ERR_MASK)) ||
	    ((engine->dir == DMA_TO_DEVICE) && (engine->status & EDMA_STAT_H2D_ERR_MASK))) {

		pr_err("[ERROR] engine %s, status error 0x%x.\n", engine->name,	engine->status);
		//engine_status_dump(engine);
		//engine_err_handle(engine, transfer, *pdesc_completed);
		goto transfer_del;
	}

	//if (engine->status & EDMA_STAT_BUSY)
		//pr_info("[WARN] engine %s is unexpectedly busy - ignoring\n", engine->name);

	/* the engine stopped on current transfer? */
	if (*pdesc_completed < transfer->desc_num) {
		if (engine->eop_flush) {
			/* check if eop received */
			struct edma_result *result = transfer->res_virt;
			int i;
			int max = *pdesc_completed;

			for (i = 0; i < max; i++) {
				if ((result[i].status & RX_STATUS_EOP) != 0) {
					transfer->flags |= TRANSFER_FLAG_ST_D2H_EOP_RCVED;
					break;
				}
			}

			transfer->desc_cmpl += *pdesc_completed;
			if (!(transfer->flags & TRANSFER_FLAG_ST_D2H_EOP_RCVED)) {
				return NULL;
			}

			/* mark transfer as successfully completed */
			engine_service_shutdown(engine);

			transfer->state = TRANSFER_STATE_COMPLETED;

			engine->desc_dequeued += transfer->desc_cmpl;

		} else {
			transfer->state = TRANSFER_STATE_FAILED;
			pr_info("[WARN] %s, xfer 0x%p, stopped half-way, %d/%d.\n", engine->name, transfer, *pdesc_completed,
														transfer->desc_num);

			/* add dequeued number of descriptors during this run */
			engine->desc_dequeued += transfer->desc_num;
			transfer->desc_cmpl = *pdesc_completed;
		}
	} else {
		//pr_info("[DBG][FINISH] engine %s completed transfer\n", engine->name);
		//pr_info("[DBG][FINISH] Completed transfer ID = 0x%p\n", transfer);
		//pr_info("[DBG][FINISH] *pdesc_completed=%d, transfer->desc_num=%d", *pdesc_completed, transfer->desc_num);

		if (!transfer->cyclic) {
			/*
			 * if the engine stopped on this transfer,
			 * it should be the last
			 */
			WARN_ON(*pdesc_completed > transfer->desc_num);
		}
		/* mark transfer as successfully completed */
		transfer->state = TRANSFER_STATE_COMPLETED;
		transfer->desc_cmpl = transfer->desc_num;
		/* add dequeued number of descriptors during this run */
		engine->desc_dequeued += transfer->desc_num;
	}

transfer_del:
	/* remove completed transfer from list */
	list_del(engine->transfer_list.next);
	
	/*
	 * Complete transfer - sets transfer to NULL if an asynchronous
	 * transfer has completed
	 */
	transfer = engine_transfer_completion(engine, transfer);

	return transfer;
}

static uint32_t engine_service_wb_monitor(struct edma_engine *engine, uint32_t expected_wb)
{
	uint32_t desc_wb = 0, sched_limit = 0;
	unsigned long timeout;
	struct edma_poll_wb *wb_data;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}
	wb_data = (struct edma_poll_wb *)engine->poll_mode_addr_virt;
	//pr_info("[LINC][POLLING] Enter %s engine_service_wb_monitor wb_data addr=%p， expected=%d.\n", engine->name, wb_data, expected_wb);
	/*
	 * Poll the writeback location for the expected number of
	 * descriptors / error events This loop is skipped for cyclic mode,
	 * where the expected_desc_count passed in is zero, since it cannot be
	 * determined before the function is called
	 */

	timeout = jiffies + (POLL_TIMEOUT_SECONDS * HZ);
	while (expected_wb != 0) {
		desc_wb = wb_data->completed_desc_count;

		if (desc_wb)
			wb_data->completed_desc_count = 0;

		if (desc_wb & WB_ERR_MASK){
			break;
		} else if (desc_wb >= expected_wb) {
			break;
		}
		/* prevent system from hanging in polled mode */
		if (time_after(jiffies, timeout)) {
			pr_info("[DBG][POLLING]  Polling timeout occurred");
			if ((desc_wb & WB_COUNT_MASK) > expected_wb)
				desc_wb = expected_wb | WB_ERR_MASK;

			break;
		}

		/*
		 * Define NUM_POLLS_PER_SCHED to limit how much time is spent
		 * in the scheduler
		 */
		if (sched_limit != 0) {
			if ((sched_limit % NUM_POLLS_PER_SCHED) == 0)
				schedule();
		}
		sched_limit++;
	}
	//pr_info("[LINC][POLLING] %s engine_service_wb_monitor END desc_wb=%d.\n", engine->name, desc_wb);
	return desc_wb;
}

static int engine_service_resume(struct edma_engine *engine)
{
	struct edma_transfer *transfer_started;

	if (!engine) {
		pr_err("dma engine NULL\n");
		return -EINVAL;
	}

	/* engine stopped? */
	if (!engine->running) {
		/* in the case of shutdown, let it finish what's in the Q */
		if (!list_empty(&engine->transfer_list)) {
			/* (re)start engine */
			transfer_started = engine_start(engine);
			if (!transfer_started) {
				pr_err("[ERROR] Failed to start dma engine\n");
				return -EINVAL;
			}
			//pr_info("[DBG] re-started %s engine with pending xfer 0x%p\n", engine->name, transfer_started);
			/* engine was requested to be shutdown? */
		} else if (engine->shutdown & ENGINE_SHUTDOWN_REQUEST) {
			engine->shutdown |= ENGINE_SHUTDOWN_IDLE;
			/* awake task on engine's shutdown wait queue */
			dma_wake_up(&engine->shutdown_wq);
		} else {
			//pr_info("[DBG] no pending transfers, %s engine stays idle.\n", engine->name);
		}
	} else if (list_empty(&engine->transfer_list)) {
		engine_service_shutdown(engine);
	}
	return 0;
}

static int engine_service(struct edma_engine *engine, int desc_writeback)
{
	struct edma_transfer *transfer = NULL;
	uint32_t desc_count = desc_writeback & WB_COUNT_MASK;
	uint32_t err_flag = desc_writeback & WB_ERR_MASK;
	int ret = 0;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}
	
	/* Service the engine */
	if (!engine->running) {
		pr_info("[DBG] Engine was not running!!! Clearing status\n");
		ret = engine_status_read(engine, 1);
		if (ret < 0) {
			pr_err("[ERROR] %s failed to read status\n", engine->name);
			return ret;
		}
		return 0;
	}

	/*
	* If called by the ISR or polling detected an error, read and clear
	* engine status. For polled mode descriptor completion, this read is
	* unnecessary and is skipped to reduce latency
	*/
	if ((desc_count == 0) || (err_flag != 0)) {
		ret = engine_status_read(engine, 1);
		if (ret < 0) {
			pr_err("[ERROR] Failed to read engine status\n");
			return ret;
		}
	}

	/*
	* engine was running but is no longer busy, or writeback occurred,
	* shut down
	*/
	if ((engine->running && !(engine->status & EDMA_STAT_BUSY)) || (!engine->eop_flush && desc_count != 0)) {
		ret = engine_service_shutdown(engine);
		if (ret < 0) {
			pr_err("[ERROR] Failed to shutdown engine\n");
			return ret;
		}
	}

	/*
	* If called from the ISR, or if an error occurred, the descriptor
	* count will be zero.	In this scenario, read the descriptor count
	* from HW.  In polled mode descriptor completion, this read is
	* unnecessary and is skipped to reduce latency
	*/
	if (!desc_count)
		desc_count = read_register(&engine->regs->completed_desc_count);

	//pr_info("[DBG][INTR-SERVICE] %s wb 0x%x, desc_count %u, err %u, dequeued %u.\n", engine->name, desc_writeback, desc_count, err_flag, engine->desc_dequeued);

	if (!desc_count)
		goto done;

	/* transfers on queue? */
	if (!list_empty(&engine->transfer_list)) {
		/* pick first transfer on queue (was submitted to the engine) */
		transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
#if 0
		ret = engine_service_perf(engine, desc_count);
		if (ret < 0) {
			pr_err("Failed to service descriptors\n");
			return ret;
		}
#endif
	}

	/* account for already dequeued transfers during this engine run */
	desc_count -= engine->desc_dequeued;

	/* Process all but the last transfer */
	transfer = engine_service_transfer_list(engine, transfer, &desc_count);

	/*
	* Process final transfer - includes checks of number of descriptors to
	* detect faulty completion
	*/
	transfer = engine_service_final_transfer(engine, transfer, &desc_count);
#if 1
	/* Restart the engine following the servicing */
	if (!engine->eop_flush) {
		ret = engine_service_resume(engine);
		if (ret < 0)
			pr_err("[ERROR] Failed to resume engine\n");
	}
#endif

done:
	/* If polling detected an error, signal to the caller */
	return err_flag ? -1 : 0;

}

int engine_service_poll(struct edma_engine *engine,        uint32_t expected_desc_count)
{
	uint32_t desc_wb = 0;
	unsigned long flags;
	int ret = 0;
	//pr_info("[LINC][POLLING] Enter %s engine_service_poll.\n", engine->name);
	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/*
	 * Poll the writeback location for the expected number of
	 * descriptors / error events This loop is skipped for cyclic mode,
	 * where the expected_desc_count passed in is zero, since it cannot be
	 * determined before the function is called
	 */

	desc_wb = engine_service_wb_monitor(engine, expected_desc_count);
	if (!desc_wb)
		return 0;

	spin_lock_irqsave(&engine->lock, flags);
	ret = engine_service(engine, desc_wb);
	spin_unlock_irqrestore(&engine->lock, flags);
	//pr_info("[LINC][POLLING] %s engine_service_poll END.\n", engine->name);
	return ret;
}

/* engine_service_work */
static void engine_service_work(struct work_struct *work)
{
	struct edma_engine *engine;
	unsigned long flags;
	int ret;
	struct edma_pci_dev *epdev;

	engine = container_of(work, struct edma_engine, work);
	epdev = (struct edma_pci_dev *)engine->epdev;

	/* lock the engine */
	spin_lock_irqsave(&engine->lock, flags);

	pr_info("[DBG][INTR] engine_service() for %s engine %p\n", engine->name, engine);
	ret = engine_service(engine, 0);
	if (ret < 0) {
		pr_err("[ERROR] Failed to service engine\n");
		goto unlock;
	}

	/* re-enable interrupts for this engine */
	if (epdev->msix_enabled) {
		write_register(engine->interrupt_enable_mask_value, &engine->regs->interrupt_enable_mask_w1s,
						(unsigned long)(&engine->regs->interrupt_enable_mask_w1s) - (unsigned long)(&engine->regs));
	} else
		channel_interrupts_enable((struct edma_pci_dev *)engine->epdev, engine->irq_bitmask);

	/* unlock the engine */
unlock:
	spin_unlock_irqrestore(&engine->lock, flags);
}

static void engine_alignments(struct edma_engine *engine)
{
	uint32_t w;
	uint32_t align_bytes, granularity_bytes, address_bits;

	w = read_register(&engine->regs->alignments);
	pr_info("[DBG] engine %p name %s alignments=0x%08x\n", engine, engine->name, (int)w);

	align_bytes = (w & 0x00ff0000U) >> 16;
	granularity_bytes = (w & 0x0000ff00U) >> 8;
	address_bits = (w & 0x000000ffU);

	pr_info("[DBG] align_bytes = %d\n", align_bytes);
	pr_info("[DBG] granularity_bytes = %d\n", granularity_bytes);
	pr_info("[DBG] address_bits = %d\n", address_bits);

	if (w) {
		engine->addr_align = align_bytes;
		engine->len_granularity = granularity_bytes;
		engine->addr_bits = address_bits;
	} else {
		/* Some default values if alignments are unspecified */
		engine->addr_align = 1;
		engine->len_granularity = 1;
		engine->addr_bits = 64;
	}
}

static int engine_writeback_setup(struct edma_engine *engine)
{
	uint32_t reg_value;
	struct edma_poll_wb *writeback;

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/*
	 * better to allocate one page for the whole device during probe()
	 * and set per-engine offsets here
	 */
	writeback = (struct edma_poll_wb *)engine->poll_mode_addr_virt;
	writeback->completed_desc_count = 0;

	pr_info("[DBG] Setting writeback location to 0x%llx for engine %p",
		 engine->poll_mode_bus, engine);
	reg_value = cpu_to_le32(PCI_DMA_L(engine->poll_mode_bus));
	write_register(reg_value, &engine->regs->poll_mode_wb_lo,
		       (unsigned long)(&engine->regs->poll_mode_wb_lo) -
			       (unsigned long)(&engine->regs));
	reg_value = cpu_to_le32(PCI_DMA_H(engine->poll_mode_bus));
	write_register(reg_value, &engine->regs->poll_mode_wb_hi,
		       (unsigned long)(&engine->regs->poll_mode_wb_hi) -
			       (unsigned long)(&engine->regs));

	return 0;
}

static int engine_init_regs(struct edma_engine *engine)
{
	uint32_t reg_value;
	int ret = 0;

	write_register(EDMA_CTRL_NON_INCR_ADDR, &engine->regs->control_w1c,
		       (unsigned long)(&engine->regs->control_w1c) -
			       (unsigned long)(&engine->regs));

	engine_alignments(engine);

	/* Configure error interrupts by default */
	reg_value = EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
	reg_value |= EDMA_CTRL_IE_MAGIC_STOPPED;
	reg_value |= EDMA_CTRL_IE_MAGIC_STOPPED;
	reg_value |= EDMA_CTRL_IE_READ_ERROR;
	reg_value |= EDMA_CTRL_IE_DESC_ERROR;

	/* if using polled mode, configure writeback address */
	if (poll_mode) {
		ret = engine_writeback_setup(engine);
		if (ret) {
			pr_info("[DBG] %s descr writeback setup failed.\n", engine->name);
			goto fail_wb;
		}
	} else {
		/* enable the relevant completion interrupts */
		reg_value |= EDMA_CTRL_IE_DESC_STOPPED;
		reg_value |= EDMA_CTRL_IE_DESC_COMPLETED;
	}
	/* Apply engine configurations */
	write_register(reg_value, &engine->regs->interrupt_enable_mask,
		       (unsigned long)(&engine->regs->interrupt_enable_mask) -
			       (unsigned long)(&engine->regs));

	engine->interrupt_enable_mask_value = reg_value;
	
	return 0;
fail_wb:
	return ret;
}

static int engine_init(struct edma_engine *engine, struct edma_pci_dev *epdev, int offset, enum dma_data_direction dir, int channel)
{
	int ret;
	uint32_t val;

	pr_info("[DBG] channel %d, offset 0x%x, dir %d.\n", channel, offset, dir);

	engine->channel = channel;
	spin_lock_init(&engine->lock);
	INIT_LIST_HEAD(&engine->transfer_list);
	mutex_init(&engine->desc_lock);
#if HAS_SWAKE_UP
	init_swait_queue_head(&engine->shutdown_wq);
#else
	init_waitqueue_head(&engine->shutdown_wq);
#endif
	/* engine interrupt request bit */
	engine->irq_bitmask = (1 << EDMA_ENG_IRQ_NUM) - 1;
	engine->irq_bitmask <<= (epdev->engines_num * EDMA_ENG_IRQ_NUM);
	engine->bypass_offset = epdev->engines_num * BYPASS_MODE_SPACING;
	
	/* parent */
	engine->epdev = (void*)epdev;
	/* register address */
	engine->regs = (epdev->bar[epdev->config_bar_idx] + offset);
	engine->sgdma_regs = epdev->bar[epdev->config_bar_idx] + offset + SGDMA_OFFSET_FROM_CHANNEL;
	val = read_register(&engine->regs->identifier);
	if (val & 0x8000U)
		engine->streaming = 1; //linc:set streaming mode

	/* remember SG DMA direction */
	engine->dir = dir;
	snprintf(engine->name, sizeof(engine->name), "%d-%s%d-%s", epdev->idx,
		(dir == DMA_TO_DEVICE) ? "H2D" : "D2H", channel,
		engine->streaming ? "ST" : "MM");
	
	if (enable_st_d2h_credit && engine->streaming &&
	    engine->dir == DMA_FROM_DEVICE)
	    	engine->desc_max = EDMA_ENGINE_CREDIT_XFER_MAX_DESC;
	else
	    	engine->desc_max = EDMA_ENGINE_XFER_MAX_DESC;

	pr_info("[DBG] engine %p name %s irq_bitmask=0x%08x\n", engine, engine->name, (int)engine->irq_bitmask);

	/* initialize the deferred work for transfer completion */
	INIT_WORK(&engine->work, engine_service_work);

	if (dir == DMA_TO_DEVICE)
		epdev->mask_irq_h2d |= engine->irq_bitmask;
	else
		epdev->mask_irq_d2h |= engine->irq_bitmask;
	epdev->engines_num++;

	ret = engine_alloc_resource(engine);
	if (ret)
		return ret;

	ret = engine_init_regs(engine);
	if (ret)
		return ret;

	if (poll_mode) 
		edma_thread_add_work(engine);

	return 0;

}

static int engine_destroy(struct edma_pci_dev *epdev, struct edma_engine *engine)
{
	if (!epdev) {
		pr_err("[ERROR] Invalid edma pcie device\n");
		return -EINVAL;
	}

	if (!engine) {
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	pr_info("[DBG] Shutting down engine %s%d", engine->name, engine->channel);

	/* Disable interrupts to stop processing new events during shutdown */
	write_register(0x0, &engine->regs->interrupt_enable_mask,
		       (unsigned long)(&engine->regs->interrupt_enable_mask) -
			       (unsigned long)(&engine->regs));

	if (enable_st_d2h_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE) {
		uint32_t reg_value = (0x1 << engine->channel) << 16;
		struct sgdma_common_regs *reg =
			(struct sgdma_common_regs*)(epdev->bar[epdev->config_bar_idx] + (0x6 * TARGET_SPACING));
		write_register(reg_value, &reg->credit_mode_enable_w1c, 0);
	}
	
	if (poll_mode)
		edma_thread_remove_work(engine);

	/* Release memory use for descriptor writebacks */
	engine_free_resource(engine);

	memset(engine, 0, sizeof(struct edma_engine));
	/* Decrement the number of engines available */
	epdev->engines_num--;
	return 0;
}

static int probe_one_engine(struct edma_pci_dev *epdev, enum dma_data_direction dir,
			    int channel)
{
	int ret;
	int offset = channel * CHANNEL_SPACING;
	uint32_t engine_id, engine_id_expected, channel_id;
	struct engine_regs *regs;
	struct edma_engine *engine;

	/* register offset for the engine */
	/* read channels at 0x0000, write channels at 0x1000,
	 * channels at 0x100 interval
	 */
	if (dir == DMA_TO_DEVICE) {
		engine_id_expected = EDMA_ID_H2D;
		engine = &epdev->engine_h2d[channel];
	} else {
		offset += H2D_CHANNEL_OFFSET;
		engine_id_expected = EDMA_ID_D2H;
		engine = &epdev->engine_d2h[channel];
	}

	regs = epdev->bar[epdev->config_bar_idx] + offset;
	engine_id = get_engine_id(regs);
	channel_id = get_engine_channel_id(regs);

	if ((engine_id != engine_id_expected) || (channel_id != channel)) {
		pr_info(
			"[DBG] %s %d engine, reg off 0x%x, id mismatch 0x%x,0x%x,exp 0x%x,0x%x, SKIP.\n",
			dir == DMA_TO_DEVICE ? "H2D" : "D2H", channel, offset,
			engine_id, channel_id, engine_id_expected,
			channel_id != channel);
		return -EINVAL;
	}

	pr_info("[DBG] found DMA %s %d engine, reg. off 0x%x, id 0x%x,0x%x.\n",
		 dir == DMA_TO_DEVICE ? "H2D" : "D2H", channel, offset,
		 engine_id, channel_id);

	/* allocate and initialize engine */
	ret = engine_init(engine, epdev, offset, dir, channel);
	if (ret != 0) {
		pr_warn("[WARN] failed to create DMA %s %d engine.\n",
			dir == DMA_TO_DEVICE ? "H2D" : "D2H", channel);
		return ret;
	}

	return 0;
}

static void remove_engines(struct edma_pci_dev *epdev)
{
	int i;
	int ret;
	struct edma_engine *engine;

	if (!epdev) {
		pr_err("[ERROR] Invalid edma pcie device\n");
		return;
	}

	/* iterate over channels */
	for (i = 0; i < epdev->h2d_channel_max; i++) {
		engine = &epdev->engine_h2d[i];
		pr_info("[DBG] Remove %s, %d", engine->name, i);
		ret = engine_destroy(epdev, engine);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy H2D engine %d\n", i);
		pr_info("[DBG] %s, %d removed", engine->name, i);
	}

	for (i = 0; i < epdev->d2h_channel_max; i++) {
		engine = &epdev->engine_d2h[i];
		pr_info("[DBG] Remove %s, %d", engine->name, i);
		ret = engine_destroy(epdev, engine);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy D2H engine %d\n", i);
		pr_info("[DBG] %s, %d removed", engine->name, i);
	}
}

static int probe_dma_engines(struct edma_pci_dev *epdev)
{
	int i, ret = 0;

	if (!epdev) {
		pr_err("[ERROR] Invalid edma pcie device\n");
		return -EINVAL;
	}

	/* iterate over channels */
	for (i = 0; i < epdev->h2d_channel_max; i++) {
		ret = probe_one_engine(epdev, DMA_TO_DEVICE, i);
		if (ret)
			break;
	}
	epdev->h2d_channel_max = i;

	for (i = 0; i < epdev->d2h_channel_max; i++) {
		ret = probe_one_engine(epdev, DMA_FROM_DEVICE, i);
		if (ret)
			break;
	}
	epdev->d2h_channel_max = i;

	return 0;

}

static irqreturn_t user_irq_service(int irq, struct edma_user_irq *user_irq)
{
	unsigned long flags;

	if (!user_irq) {
		pr_err("[ERROR] Invalid user_irq\n");
		return IRQ_NONE;
	}

	if (user_irq->handler)
		return user_irq->handler(user_irq->user_idx, user_irq->dev);

	spin_lock_irqsave(&(user_irq->events_lock), flags);
	if (!user_irq->events_irq) {
		user_irq->events_irq = 1;
		wake_up_interruptible(&(user_irq->events_wq));
	}
	spin_unlock_irqrestore(&(user_irq->events_lock), flags);

	return IRQ_HANDLED;
}

/*
 * edma_user_irq() - Interrupt handler for user interrupts in MSI-X mode
 *
 * @dev_id pointer to edma_pci_dev
 */
static irqreturn_t edma_user_irq(int irq, void *dev_id)
{
	struct edma_user_irq *user_irq;

	pr_info("[DBG-IRQ] (irq=%d) <<<< INTERRUPT SERVICE ROUTINE\n", irq);

	if (!dev_id) {
		pr_err("[ERROR] Invalid dev_id on irq line %d\n", irq);
		return IRQ_NONE;
	}
	user_irq = (struct edma_user_irq *)dev_id;

	return user_irq_service(irq, user_irq);
}

/*
 * edma_channel_irq() - Interrupt handler for channel interrupts in MSI-X mode
 *
 * @dev_id pointer to edma_pci_dev
 */
static irqreturn_t edma_channel_irq(int irq, void *dev_id)
{
	struct edma_pci_dev *epdev;
	struct edma_engine *engine;
	struct interrupt_regs *irq_regs;

	pr_info("[IRQ] (irq=%d) <<<< INTERRUPT service ROUTINE\n", irq);
	if (!dev_id) {
		pr_err("[ERROR-irq]Invalid dev_id on irq line %d\n", irq);
		return IRQ_NONE;
	}

	engine = (struct edma_engine *)dev_id;
	epdev = (struct edma_pci_dev *)engine->epdev;

	if (!epdev) {
		WARN_ON(!epdev);
		pr_info("[IRQ] %s(irq=%d) xdev=%p ??\n", __func__, irq, epdev);
		return IRQ_NONE;
	}

	irq_regs = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);

	/* Disable the interrupt for this engine */
	write_register(
		engine->interrupt_enable_mask_value,
		&engine->regs->interrupt_enable_mask_w1c,
		(unsigned long)(&engine->regs->interrupt_enable_mask_w1c) -
			(unsigned long)(&engine->regs));
	/* Dummy read to flush the above write */
	read_register(&irq_regs->channel_int_pending);
	/* Schedule the bottom half */
	schedule_work(&engine->work);

	/*
	 * need to protect access here if multiple MSI-X are used for
	 * user interrupts
	 */
	epdev->irq_count++;
	return IRQ_HANDLED;
}
/*
 * edma_isr() - Interrupt handler
 *
 * @dev_id pointer to epdev
 */
static irqreturn_t edma_isr(int irq, void *dev_id)
{
	uint32_t ch_irq, user_irq, mask;
	struct edma_pci_dev *epdev;
	struct interrupt_regs *irq_regs;

	//pr_info("[DBG-IRQ] edma_isr>> (irq=%d, dev 0x%p) <<<< ISR.\n", irq, dev_id);
	if (!dev_id) {
		pr_err("[ERROR] Invalid dev_id on irq line %d\n", irq);
		return -IRQ_NONE;
	}
	epdev = (struct edma_pci_dev *)dev_id;

	if (!epdev) {
		WARN_ON(!epdev);
		pr_info("[WARN-IRQ] %s(irq=%d) epdev=%p ??\n", __func__, irq, epdev);
		return IRQ_NONE;
	}
	//disable_irq_nosync(epdev->pdev->irq);// to be fixed
	irq_regs = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);

	/* read channel interrupt requests */
	ch_irq = read_register(&irq_regs->channel_int_request);
	pr_info("[DBG-IRQ] ch_irq = 0x%08x\n", ch_irq);
	
	/*
	 * disable all interrupts that fired; these are re-enabled individually
	 * after the causing module has been fully serviced.
	 */
	if (ch_irq)
		channel_interrupts_disable(epdev, ch_irq);
	/* read user interrupts - this read also flushes the above write */
	user_irq = read_register(&irq_regs->user_int_request);

	if (user_irq) {
		int user = 0;
		uint32_t mask = 1;
		int max = epdev->user_max;
		
		pr_info("[DBG-IRQ] user_irq = 0x%08x\n", user_irq);

		for (; user < max && user_irq; user++, mask <<= 1) {
			if (user_irq & mask) {
				user_irq &= ~mask;
				user_irq_service(irq, &epdev->user_irq[user]);
			}
		}
	}

	mask = ch_irq & epdev->mask_irq_h2d;
	if (mask) {
		int channel = 0;
		int max = epdev->h2d_channel_max;

		/* iterate over H2D (PCIe read) */
		for (channel = 0; channel < max && mask; channel++) {
			struct edma_engine *engine = &epdev->engine_h2d[channel];
			/* engine present and its interrupt fired? */
			if (engine->irq_bitmask & mask) {
				mask &= ~engine->irq_bitmask;
				engine_status_read(engine, 1); // for legacy intr bug
				//pr_info("[DBG-IRQ] schedule_work, %s.\n", engine->name);
				schedule_work(&engine->work);
			}
		}
	}

	mask = ch_irq & epdev->mask_irq_d2h;
	if (mask) {
		int channel = 0;
		int max = epdev->d2h_channel_max;

		/* iterate over D2H (PCIe write) */
		for (channel = 0; channel < max && mask; channel++) {
			struct edma_engine *engine = &epdev->engine_d2h[channel];
			/* engine present and its interrupt fired? */
			if (engine->irq_bitmask & mask) {
				mask &= ~engine->irq_bitmask;
				engine_status_read(engine, 1); // for legacy intr bug
				//pr_info("[DBG-IRQ] schedule_work, %s.\n", engine->name);
				schedule_work(&engine->work);
			}
		}
	}

	epdev->irq_count++;
	return IRQ_HANDLED;
}

static int irq_legacy_setup(struct edma_pci_dev *epdev)
{
	uint32_t w;
	uint8_t val;
	void *reg;
	int ret;

	pci_read_config_byte(epdev->pdev, PCI_INTERRUPT_PIN, &val);
	if (val == 0) {
		pr_info("[DBG] Legacy interrupt not supported\n");
		return -EINVAL;
	}

	pr_info("[DBG] Legacy Interrupt register value = %d\n", val);

	if (val > 1) {
		val--;
		w = (val << 24) | (val << 16) | (val << 8) | val;
		/* Program IRQ Block Channel vector and IRQ Block User vector
		 * with Legacy interrupt value
		 */
		reg = epdev->bar[epdev->config_bar_idx] + 0x2080; // IRQ user
		write_register(w, reg, 0x2080);
		write_register(w, reg + 0x4, 0x2084);
		write_register(w, reg + 0x8, 0x2088);
		write_register(w, reg + 0xC, 0x208C);
		reg = epdev->bar[epdev->config_bar_idx] + 0x20A0; // IRQ Block
		write_register(w, reg, 0x20A0);
		write_register(w, reg + 0x4, 0x20A4);
	}

	epdev->irq_line = (int)epdev->pdev->irq;
	//ret = request_irq(epdev->pdev->irq, edma_isr, IRQF_ONESHOT, "pcie_dma", epdev);
	ret = request_irq(epdev->pdev->irq, edma_isr, IRQF_SHARED, "pcie_dma", epdev);
	if (ret)
		pr_info("[DBG] Couldn't use IRQ#%d, %d\n", epdev->pdev->irq, ret);
	else
		pr_info("[DBG] Using IRQ#%d with 0x%p\n", epdev->pdev->irq, epdev);

	return ret;
}

static int irq_msix_user_setup(struct edma_pci_dev *epdev)
{
	int i;
	int j = epdev->h2d_channel_max + epdev->d2h_channel_max;
	int ret = 0;

	/* vectors set in probe_scan_for_msi() */
	for (i = 0; i < epdev->user_max; i++, j++) {
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		uint32_t vector = pci_irq_vector(epdev->pdev, j);
#else
		uint32_t vector = epdev->entry[j].vector;
#endif
		ret = request_irq(vector, edma_user_irq, 0, "pcie_dma", &epdev->user_irq[i]);
		if (ret) {
			pr_info("[DBG] user %d couldn't use IRQ#%d, %d\n", i, vector, ret);
			break;
		}
		pr_info("[DBG] %d-USR-%d, IRQ#%d with 0x%p\n", epdev->idx, i, vector, &epdev->user_irq[i]);
	}

	/* If any errors occur, free IRQs that were successfully requested */
	if (ret) {
		for (i--, j--; i >= 0; i--, j--) {
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
			uint32_t vector = pci_irq_vector(epdev->pdev, j);
#else
			uint32_t vector = epdev->entry[j].vector;
#endif
			free_irq(vector, &epdev->user_irq[i]);
		}
	}

	return ret;
}

static int irq_msi_setup(struct edma_pci_dev *epdev)
{
	int ret;

	epdev->irq_line = (int)epdev->pdev->irq;
	ret = request_irq(epdev->pdev->irq, edma_isr, 0, "pcie_dma", epdev);
	if (ret)
		pr_info("[DBG] Couldn't use IRQ#%d, %d\n", epdev->pdev->irq, ret);
	else
		pr_info("[DBG] Using IRQ#%d with 0x%p\n", epdev->pdev->irq, epdev);

	return ret;
}

static int irq_msix_channel_setup(struct edma_pci_dev *epdev)
{
	int i, j;
	int ret = 0;
	uint32_t vector;
	struct edma_engine *engine;

	if (!epdev) {
		pr_err("[ERROR] edma pcie device is NULL\n");
		return -EINVAL;
	}

	if (!epdev->msix_enabled)
		return 0;

	j = epdev->h2d_channel_max;
	engine = epdev->engine_h2d;
	for (i = 0; i < epdev->h2d_channel_max; i++, engine++) {
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		vector = pci_irq_vector(epdev->pdev, i);
#else
		vector = epdev->entry[i].vector;
#endif
		ret = request_irq(vector, edma_channel_irq, 0, "edma_dma", engine);
		if (ret) {
			pr_warn("[WARN] requesti irq#%d failed %d, engine %s.\n", vector, ret, engine->name);
			return ret;
		}
		pr_info("[DBG] engine %s, irq#%d.\n", engine->name, vector);
		engine->msix_irq_line = vector;
	}

	engine = epdev->engine_d2h;
	for (i = 0; i < epdev->d2h_channel_max; i++, j++, engine++) {
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		vector = pci_irq_vector(epdev->pdev, j);
#else
		vector = epdev->entry[j].vector;
#endif
		ret = request_irq(vector, edma_channel_irq, 0, "edma_dma", engine);
		if (ret) {
			pr_warn("[WARN] requesti irq#%d failed %d, engine %s.\n", vector, ret, engine->name);
			return ret;
		}
		pr_info("[DBG] engine %s, irq#%d.\n", engine->name, vector);
		engine->msix_irq_line = vector;
	}
	write_register(1, epdev->bar[epdev->config_bar_idx] + 0x400a8, 0x400a8);//linc: enable msix intr
	return 0;
}

static void prog_irq_msix_channel(struct edma_pci_dev *epdev, bool clear)
{
	struct interrupt_regs *int_regs =
		(struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);
	uint32_t val = 0, max = epdev->d2h_channel_max + epdev->h2d_channel_max;
	uint32_t i;
	int j, k, shift = 0;

	/* engine */
	for (i = 0, j = 0; i < max; j++) {
		if (clear)
			i += 4;
		else
			for (k = 0; k < 4 && i < max; i++, k++, shift += 8)
				val |= (i & 0x1f) << shift;

		write_register(val, &int_regs->channel_msi_vector[j],
			       	EDMA_OFS_INT_CTRL + ((unsigned long)&int_regs->channel_msi_vector[j] -
					(unsigned long)int_regs));
		pr_info("[DBG] vector %d, 0x%x.\n", j, val);
	}
}

static void irq_msix_channel_teardown(struct edma_pci_dev *epdev)
{
	struct edma_engine *engine;
	int j = 0;
	int i = 0;

	if (!epdev->msix_enabled)
		return;

	prog_irq_msix_channel(epdev, 1);

	engine = epdev->engine_h2d;
	for (i = 0; i < epdev->h2d_channel_max; i++, j++, engine++) {
		if (!engine->msix_irq_line)
			break;
		pr_info("[DBG] Release IRQ#%d for engine %p\n", engine->msix_irq_line,
		       engine);
		free_irq(engine->msix_irq_line, engine);
	}

	engine = epdev->engine_d2h;
	for (i = 0; i < epdev->d2h_channel_max; i++, j++, engine++) {
		if (!engine->msix_irq_line)
			break;
		pr_info("[DBG] Release IRQ#%d for engine %p\n", engine->msix_irq_line,
		       engine);
		free_irq(engine->msix_irq_line, engine);
	}
}

static void prog_irq_msix_user(struct edma_pci_dev *epdev, bool clear)
{
	/* user */
	struct interrupt_regs *int_regs =
		(struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFS_INT_CTRL);
	uint32_t i = epdev->d2h_channel_max + epdev->h2d_channel_max;
	uint32_t max = i + epdev->user_max;
	int j; 

	for (j = 0; i < max; j++) {
		uint32_t val = 0;
		int k, shift = 0;
		if (clear)
			i += 4;
		else
			for (k = 0; k < 4 && i < max; i++, k++, shift += 8)
				val |= (i & 0x1f) << shift;

		write_register( val, &int_regs->user_msi_vector[j],
				EDMA_OFS_INT_CTRL + ((unsigned long)&int_regs->user_msi_vector[j] -
				 (unsigned long)int_regs));

		pr_info("[DBG] vector %d, 0x%x.\n", j, val);
	}
}

static void irq_msix_user_teardown(struct edma_pci_dev *epdev)
{
	int i, j;

	if (!epdev) {
		pr_err("[ERROR] edma pcie device is NULL\n");
		return;
	}

	if (!epdev->msix_enabled)
		return;

	j = epdev->h2d_channel_max + epdev->d2h_channel_max;

	prog_irq_msix_user(epdev, true);

	for (i = 0; i < epdev->user_max; i++, j++) {
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		uint32_t vector = pci_irq_vector(epdev->pdev, j);
#else
		uint32_t vector = epdev->entry[j].vector;
#endif
		pr_info("[DBG] user %d, releasing IRQ#%d\n", i, vector);
		free_irq(vector, &epdev->user_irq[i]);
	}
}

static void irq_teardown(struct edma_pci_dev *epdev)
{
	if (epdev->msix_enabled) {
		irq_msix_channel_teardown(epdev);
		irq_msix_user_teardown(epdev);
	} else if (epdev->irq_line != -1) {
		pr_info("[DBG] Releasing IRQ#%d\n", epdev->irq_line);
		free_irq(epdev->irq_line, epdev);
	}
}

static void pci_keep_intx_enabled(struct pci_dev *pdev)
{
	/* workaround to a h/w bug:
	 * when msix/msi become unavaile, default to legacy.
	 * However the legacy enable was not checked.
	 * If the legacy was disabled, no ack then everything stuck
	 */
	uint16_t pcmd, pcmd_new;

	pci_read_config_word(pdev, PCI_COMMAND, &pcmd);
	pcmd_new = pcmd & ~PCI_COMMAND_INTX_DISABLE;
	if (pcmd_new != pcmd) {
		pr_info("[DBG] %s: clear INTX_DISABLE, 0x%x -> 0x%x.\n",
			dev_name(&pdev->dev), pcmd, pcmd_new);
		pci_write_config_word(pdev, PCI_COMMAND, pcmd_new);
	}
}

static int irq_setup(struct edma_pci_dev *epdev)
{
	int ret;
	pci_keep_intx_enabled(epdev->pdev);
#if 0

	ret = irq_msix_channel_setup(epdev);
	if (ret)
		return ret;
	prog_irq_msix_channel(epdev, false);
	return 0;
#else
	if (epdev->msix_enabled) {
		ret = irq_msix_channel_setup(epdev);

		if (ret)
			return ret;
		ret = irq_msix_user_setup(epdev);
		if (ret)
			return ret;
		prog_irq_msix_channel(epdev, 0);
		prog_irq_msix_user(epdev, 0);

		return 0;
	} else if (epdev->msi_enabled)
		return irq_msi_setup(epdev);

	return irq_legacy_setup(epdev);
#endif
}

static int set_dma_mask(struct pci_dev *pdev)
{
	if (!pdev) {
		pr_err("[ERROR] Invalid pdev\n");
		return -EINVAL;
	}

	pr_info("[DBG] sizeof(dma_addr_t) == %ld\n", sizeof(dma_addr_t));
	/* 64-bit addressing capability for XDMA? */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
#else
	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
#endif
		/* query for DMA transfer */
		/* @see Documentation/DMA-mapping.txt */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		pr_info("[DBG] dma_set_mask()\n");
#else
		pr_info("[DBG] pci_set_dma_mask()\n");
#endif
		/* use 64-bit DMA */
		pr_info("[DBG] Using a 64-bit DMA mask.\n");
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
#else
		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
#endif
		pr_info("[DBG] Could not set 64-bit DMA mask.\n");
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
#else
		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
#endif
		/* use 32-bit DMA */
		pr_info("[DBG] Using a 32-bit DMA mask.\n");
	} else {
		pr_info("[DBG] No suitable DMA possible.\n");
		return -EINVAL;
	}

	return 0;
}

static void pci_check_intr_pend(struct pci_dev *pdev)
{
	uint16_t v;

	pci_read_config_word(pdev, PCI_STATUS, &v);
	if (v & PCI_STATUS_INTERRUPT) {
		pr_info("%s PCI STATUS Interrupt pending 0x%x.\n",
			dev_name(&pdev->dev), v);
		pci_write_config_word(pdev, PCI_STATUS, PCI_STATUS_INTERRUPT);
	}
}

#if KERNEL_VERSION(3, 5, 0) <= LINUX_VERSION_CODE
static void pci_enable_capability(struct pci_dev *pdev, int cap)
{
	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL, cap);
}
#else
static void pci_enable_capability(struct pci_dev *pdev, int cap)
{
	uint16_t v;
	int pos;

	pos = pci_pcie_cap(pdev);
	if (pos > 0) {
		pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &v);
		v |= cap;
		pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, v);
	}
}
#endif

void edma_device_close(void *p_epdev)
{
	struct edma_pci_dev *epdev;

	if (!p_epdev)
		return;

	epdev = (struct edma_pci_dev *)p_epdev;

	pr_info("[DBG] remove(dev = 0x%p) where pdev->dev.driver_data = 0x%p\n", epdev->pdev,
	       p_epdev);


	channel_interrupts_disable(epdev, ~0);
	//user_interrupts_disable(p_epdev, ~0);
	read_interrupts(epdev);

	irq_teardown(p_epdev);
	disable_msi_msix(epdev);

	remove_engines(epdev);
	if (poll_mode)
		edma_threads_destroy();
	unmap_bars(epdev);

	pci_release_regions(epdev->pdev);

	pci_disable_device(epdev->pdev);

	return;
}

int edma_device_open(void *p_epdev)
{
	int ret = 0, i;
	struct edma_pci_dev *epdev = (struct edma_pci_dev *)p_epdev;
	
	epdev->user_irqs_max = MAX_USER_IRQ;
	epdev->user_max = MAX_USER_IRQ;
	epdev->d2h_channel_max = MAX_DMA_CHANNEL;
	epdev->h2d_channel_max = MAX_DMA_CHANNEL;

	
	/* Set up data user IRQ data structures */
	for (i = 0; i < 16; i++) {
		epdev->user_irq[i].epdev = epdev;
		spin_lock_init(&epdev->user_irq[i].events_lock);
		init_waitqueue_head(&epdev->user_irq[i].events_wq);
		epdev->user_irq[i].handler = NULL;
		epdev->user_irq[i].user_idx = i; /* 0 based */
	}
	
	ret = pci_enable_device(epdev->pdev);
	if (ret) {
		pr_info("[DBG] pci_enable_device() failed, %d.\n", ret);
		return -ENODEV;
	}

	/* keep INTx enabled */
	pci_check_intr_pend(epdev->pdev);

	/* enable relaxed ordering */
	pci_enable_capability(epdev->pdev, PCI_EXP_DEVCTL_RELAX_EN);

	/* enable extended tag */
	pci_enable_capability(epdev->pdev, PCI_EXP_DEVCTL_EXT_TAG);

	/* force MRRS to be 512 */
	ret = pcie_set_readrq(epdev->pdev, 512);
	if (ret)
		pr_info("device %s, error set PCI_EXP_DEVCTL_READRQ: %d.\n", dev_name(&epdev->pdev->dev), ret);

	/* enable bus master capability */
	pci_set_master(epdev->pdev);

	ret = request_regions(epdev);
	if (ret)
		goto err_regions;

	ret = map_bars(epdev);
	if (ret)
		goto err_map;

	ret = set_dma_mask(epdev->pdev);
	if (ret)
		goto err_mask;

	check_nonzero_interrupt_status(epdev);
	/* explicitely zero all interrupt enable masks */
	channel_interrupts_disable(epdev, ~0);
	user_interrupts_disable(epdev, ~0);
	read_interrupts(epdev);

	if (poll_mode) {
		ret = edma_threads_create(epdev->h2d_channel_max + epdev->d2h_channel_max);
		interrupt_mode = 1;
	}

	ret = probe_dma_engines(epdev);
	if (ret)
		goto err_mask;

	ret = enable_msi_msix(epdev);
	if (ret < 0)
		goto err_engines;

	ret = irq_setup(epdev);
	if (ret < 0)
		goto err_msix;

	if (!poll_mode)
		channel_interrupts_enable(epdev, ~0);

	/* Flush writes */
	read_interrupts(epdev);

	return 0;
err_msix:
	disable_msi_msix(epdev);
err_engines:
	remove_engines(epdev);
if (poll_mode)
	edma_threads_destroy();
err_mask:
	unmap_bars(epdev);
err_map:
	if (epdev->got_regions)
		pci_release_regions(epdev->pdev);
err_regions:
	if (!epdev->regions_in_use)
		pci_disable_device(epdev->pdev);
	return -ENODEV;

}
