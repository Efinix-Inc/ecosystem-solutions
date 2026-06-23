#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/vmalloc.h>
#include "dma.h"
#include "common.h"
#include "file_io.h"
#include "poll.h"

// #define __EDMA_DEBUG__

/* Define the maximum value for resource_size_t */
#if defined(CONFIG_PHYS_ADDR_T_64BIT)
#define RES_SIZE_MAX U64_MAX // 2^64 - 1 if resource_size_t is 64-bit
#else
#define RES_SIZE_MAX ULONG_MAX // 2^32 - 1 or 2^64 - 1 depending on unsigned long
#endif

#define MAX_BAR_SIZE RES_SIZE_MAX

/* Module Parameters */
static unsigned int poll;
module_param(poll, uint, 0644);
MODULE_PARM_DESC(poll, "Set 1 for hw polling, default is 0 (interrupts)");

static unsigned int desc_blen_max = EDMA_DESC_BLEN_MAX; // 128MB size
static unsigned int enable_st_cth_credit = 0;

static int dma_mask_ready(struct pci_dev *pdev);
static inline int epdev_list_add(struct efx_pci_dev *epdev);
static inline void epdev_list_remove(struct efx_pci_dev *epdev);
static int cfg_desc_ctrl(uint32_t control_field, struct edma_desc *desc);
static void cfg_desc_adj(uint32_t next_adjacent, struct edma_desc *desc);
static uint32_t get_desc_next_adj(uint32_t next_lo, unsigned int remaining);
static void write_desc(int dir, int len, uint64_t ep_addr, struct edma_desc *desc, dma_addr_t rc_bus_addr);
static inline void clear_desc(int cnt, struct edma_desc *desc_virt);
static int trans_desc_init(int cnt, struct edma_transfer *transfer);
static void trans_des(struct edma_transfer *trans, struct efx_pci_dev *epdev);
static int trans_bud(struct edma_request_cb *req, uint32_t des_max, struct edma_engine *engine, struct edma_transfer *trans);
static int trans_que(struct edma_transfer *transfer, struct edma_engine *engine);
static int trans_abt(struct edma_transfer *transfer, struct edma_engine *engine);
static int trans_init(struct edma_request_cb *req, struct edma_engine *engine, struct edma_transfer *trans);
static int engine_cfg(struct edma_engine *engine);
static void edm_req_free(struct edma_request_cb *req);
static int engine_status_rd(bool clr, struct edma_engine *engine);
static int edmeng_done(struct edma_engine *engine);
#ifdef __EDMA_DEBUG__
	static void dup_des(struct edma_desc *desc_virt);
	static void transdup(struct edma_transfer *transfer);
#endif
static int req_reg(struct efx_pci_dev *epdev);
static void unmap_dma_bar(struct efx_pci_dev *epdev);
static int map_pci_bar(int idx, struct efx_pci_dev *epdev);
static int is_cfg_bar(int idx, struct efx_pci_dev *epdev);
static int setup_dma_bar(struct efx_pci_dev *epdev);
static int read_engine_id(struct engine_regs *regs, struct efx_pci_dev *epdev);
static int engine_channel_id(struct engine_regs *regs, struct efx_pci_dev *epdev);
static void engine_free(struct edma_engine *engine);
static int eng_allsource(struct edma_engine *engine);
static int eng_serv_shutdown(struct edma_engine *engine);
static uint32_t eng_servmoni(uint32_t expwb, struct edma_engine *engine);
static int engine_service_resume(struct edma_engine *engine);
static int eng_serv(int des_wrb, struct edma_engine *engine);
static void eng_servwork(struct work_struct *work);
static void eng_alig(struct edma_engine *engine);
static int eng_wrset(struct edma_engine *engine);
static int eng_reg(struct edma_engine *engine);
static int eng_init(int channel, struct edma_engine *engine, int offset, enum dma_data_direction dir, struct efx_pci_dev *epdev);
static int destroy_engine(struct edma_engine *engine, struct efx_pci_dev *epdev);
static int probe_engine(int channel, enum dma_data_direction dir, struct efx_pci_dev *epdev);
static void remove_engine(struct efx_pci_dev *epdev);
static int dma_probeng(struct efx_pci_dev *epdev);
static void pci_capen(int cap, struct pci_dev *pdev);

static int dma_mask_ready(struct pci_dev *pdev)
{
	if (!pdev)
	{
		pr_err("[ERROR] Invalid pdev\n");
		return -EINVAL;
	}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
	{
#else
	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
	{
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
	}
	else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))
	{
#else
		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
	}
	else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
	{
#endif
		pr_info("[DBG] Could not set 64-bit DMA mask.\n");
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
#else
		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
#endif
		/* use 32-bit DMA */
		pr_info("[DBG] Using a 32-bit DMA mask.\n");
	}
	else
	{
		pr_info("[DBG] No suitable DMA possible.\n");
		return -EINVAL;
	}

	return 0;
}

/*
 * Efinix device management
 * maintains a list of the pcie_dma devices
 */
static LIST_HEAD(epdev_list);
static DEFINE_MUTEX(epdev_mutex);

static LIST_HEAD(epdev_rcu_list);
static DEFINE_SPINLOCK(epdev_rcu_lock);

#ifndef list_last_entry
#define list_last_entry(ptr, type, member) list_entry((ptr)->prev, type, member)
#endif

static inline int epdev_list_add(struct efx_pci_dev *epdev)
{
	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIE dev\n");
		return -EINVAL;
	}

	mutex_lock(&epdev_mutex);
	if (list_empty(&epdev_list))
	{
		epdev->idx = 0;
		if (poll)
		{
			int ret = efx_thrd_create(epdev->htc_channel_max + epdev->cth_channel_max);
			if (ret < 0)
			{
				mutex_unlock(&epdev_mutex);
				return ret;
			}
		}
	}
	else
	{
		struct efx_pci_dev *last;
		last = list_last_entry(&epdev_list, struct efx_pci_dev, list_head);
		epdev->idx = last->idx + 1;
	}
	list_add_tail(&epdev->list_head, &epdev_list);
	mutex_unlock(&epdev_mutex);

	pr_info("Added device %s, efxdev 0x%p, pcie_dma idx %d\n", dev_name(&epdev->pdev->dev), epdev, epdev->idx);

	spin_lock(&epdev_rcu_lock);
	list_add_tail_rcu(&epdev->rcu_node, &epdev_rcu_list);
	spin_unlock(&epdev_rcu_lock);

	return 0;
}

#undef list_last_entry

static inline void epdev_list_remove(struct efx_pci_dev *epdev)
{
	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIE dev\n");
		return;
	}

	mutex_lock(&epdev_mutex);
	list_del(&epdev->list_head);
	if (poll && list_empty(&epdev_list))
		efx_thrd_dest();
	mutex_unlock(&epdev_mutex);

	spin_lock(&epdev_rcu_lock);
	list_del_rcu(&epdev->rcu_node);
	spin_unlock(&epdev_rcu_lock);
	synchronize_rcu();
}

struct efx_pci_dev *epdev_find_by_pdev(struct pci_dev *pdev)
{
	struct efx_pci_dev *epdev, *tmp;

	mutex_lock(&epdev_mutex);
	list_for_each_entry_safe(epdev, tmp, &epdev_list, list_head)
	{
		if (epdev->pdev == pdev)
		{
			mutex_unlock(&epdev_mutex);
			return epdev;
		}
	}
	mutex_unlock(&epdev_mutex);
	return NULL;
}

uint32_t __reg_rd(void *iomem, void *epdev)
{
	uint32_t read_val;
	unsigned long flags;
	// mutex_lock(&dbg_reg_lock);
	struct efx_pci_dev *_epdev = (struct efx_pci_dev *)epdev;
	spin_lock_irqsave(&_epdev->irq_reg_lock, flags);
	read_val = ioread32(iomem);
	spin_unlock_irqrestore(&_epdev->irq_reg_lock, flags);
	// mutex_unlock(&dbg_reg_lock);
	return read_val;
}
void __reg_wr(const char *function, uint32_t value, void *iomem, unsigned long off, void *epdev)
{
#ifdef __EDMA_DEBUG__
	pr_info("%s: Writing register 0x%lx(0x%p), 0x%x.\n", function, off, iomem, value);
#endif
	unsigned long flags;
	struct efx_pci_dev *_epdev = (struct efx_pci_dev *)epdev;

	// mutex_lock(&dbg_reg_lock);
	spin_lock_irqsave(&_epdev->irq_reg_lock, flags);
	iowrite32(value, iomem);
	spin_unlock_irqrestore(&_epdev->irq_reg_lock, flags);
	// mutex_unlock(&dbg_reg_lock);
}

/* cfg_desc_ctrl -- Merge (OR) edma_desc desc-> control with the control field. */
static int cfg_desc_ctrl(uint32_t control_field, struct edma_desc *desc)
{
	/* remember magic and adjacent number */
	uint32_t control = le32_to_cpu(desc->control) & ~(0x7UL); // the first 3 bit of the control bit is preserve

	/*if (control_field & ~(LS_BYTE_MASK)) {
		pr_err("[ERROR] Invalid control field\n");
		return -EINVAL;
	}*/
	/* merge adjacent and control field */
	control |= control_field;
	/* write control and next_adjacent */
	desc->control = cpu_to_le32(control);
	return 0;
}

/* cfg_desc_adj -- Set how many descriptors are adjacent to this one */
static void cfg_desc_adj(uint32_t next_adjacent, struct edma_desc *desc)
{
	/* remember reserved and control bits */
	uint32_t control = le32_to_cpu(desc->control) & EDMA_DESC_CTRL_MASK;
	/* merge adjacent and control field */
	control |= EDMA_DESC_SET_CNTRL(next_adjacent);
	/* write control and next_adjacent */
	desc->control = cpu_to_le32(control);
	return;
}

// get_desc_next_adj()
//	Get the index of the next adjacent desc in a desc_set
static uint32_t get_desc_next_adj(uint32_t next_lo, unsigned int remaining)
{
	unsigned int next_index;

	if (remaining <= 1)
		return 0;

	/* shift right 5 times corresponds to a division by
	 * sizeof(edma_desc) = 32
	 */
	next_index = ((next_lo & (EDMA_PAGE_SIZE - 1)) >> 5) % EDMA_MAX_ADJ_BLOCK_SIZE;
	return min(EDMA_MAX_ADJ_BLOCK_SIZE - next_index - 1, remaining - 1);
}

static void write_desc(int dir, int len, uint64_t ep_addr, struct edma_desc *desc, dma_addr_t rc_bus_addr)
{
	/* transfer length */
	desc->bytes = ((len & 0xFFFFFFF) >> 23) & 0x1F; // high 5 bits [23-27]
	desc->control = (len & 0x7FFFFF) << 9;				// low 23 bits [0-22]
	if (dir == DMA_TO_DEVICE)
	{
		/* read from root complex memory (source address) */
		desc->src_addr_lo = cpu_to_le32(PCI_DMA_L(rc_bus_addr));
		desc->src_addr_hi = cpu_to_le32(PCI_DMA_H(rc_bus_addr));
		/* write to end point address (destination address) */
		desc->dst_addr_lo = cpu_to_le32(PCI_DMA_L(ep_addr));
		desc->dst_addr_hi = cpu_to_le32(PCI_DMA_H(ep_addr));
	}
	else
	{
		/* read from end point address (source address) */
		desc->src_addr_lo = cpu_to_le32(PCI_DMA_L(ep_addr));
		desc->src_addr_hi = cpu_to_le32(PCI_DMA_H(ep_addr));
		/* write to root complex memory (destination address) */
		desc->dst_addr_lo = cpu_to_le32(PCI_DMA_L(rc_bus_addr));
		desc->dst_addr_hi = cpu_to_le32(PCI_DMA_H(rc_bus_addr));
	}
}

// clear_desc() - clear @cnt of descriptor at @desc_virt by setting all field to 0
static inline void clear_desc(int cnt, struct edma_desc *desc_virt)
{
	memset(desc_virt, 0, cnt * sizeof(struct edma_desc));
}
static int trans_desc_init(int cnt, struct edma_transfer *transfer)
{
	struct edma_desc *desc_virt = transfer->desc_virt;
	dma_addr_t desc_bus = transfer->desc_bus;
	int i;

	/* create singly-linked list for SG DMA controller */
	for (i = 0; i < cnt - 1; i++)
	{
		/* increment bus address to next in array */
		desc_bus += sizeof(struct edma_desc);

		/* singly-linked list uses bus addresses */
		desc_virt[i].next_lo = cpu_to_le32(PCI_DMA_L(desc_bus));
		desc_virt[i].next_hi = cpu_to_le32(PCI_DMA_H(desc_bus));
		desc_virt[i].bytes = cpu_to_le32(0);

		desc_virt[i].control = cpu_to_le32(0); // cpu_to_le32(DESC_MAGIC);
	}
	/* { i = number - 1 } */
	/* zero the last descriptor next pointer */
	desc_virt[i].next_lo = cpu_to_le32(0);
	desc_virt[i].next_hi = cpu_to_le32(0);
	desc_virt[i].bytes = cpu_to_le32(0);
	desc_virt[i].control = cpu_to_le32(0); // cpu_to_le32(DESC_MAGIC);

	return 0;
}

/* trans_des() - free transfer */
static void trans_des(struct edma_transfer *trans, struct efx_pci_dev *epdev)
{
	/* free descriptors */
	clear_desc(trans->desc_num, trans->desc_virt);

	if (trans->last_in_request && (trans->flags & TRANSFER_FLAG_NEED_UNMAP))
	{
		struct sg_table *sgt = trans->sgt;

		if (sgt->nents)
		{
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

static int trans_bud(struct edma_request_cb *req, uint32_t des_max,
							struct edma_engine *engine,
							struct edma_transfer *trans)
{
	int i = 0, j = 0;
	dma_addr_t bus = trans->res_bus;
	struct sw_desc *sdesc = &(req->sdesc[req->sw_desc_idx]);

	for (; i < des_max; i++, j++, sdesc++)
	{
		/* fill in descriptor entry j with transfer details */
		write_desc(trans->dir, sdesc->len, req->ep_addr, trans->desc_virt + j, sdesc->addr);
		trans->len += sdesc->len;

		/* for non-inc-add mode don't increment ep_addr */
		if (!engine->non_incr_addr)
			req->ep_addr += sdesc->len;

		if (engine->streaming && engine->dir == DMA_FROM_DEVICE)
		{
			memset(trans->res_virt + j, 0,
					 sizeof(struct edma_result));
			trans->desc_virt[j].src_addr_lo =
				 cpu_to_le32(PCI_DMA_L(bus));
			trans->desc_virt[j].src_addr_hi =
				 cpu_to_le32(PCI_DMA_H(bus));
			bus += sizeof(struct edma_result);
		}
	}
	req->sw_desc_idx += des_max;

	return 0;
}

/*
 * should hold the engine->lock;
 */
// ABORT transfer
static int trans_abt(struct edma_transfer *transfer, struct edma_engine *engine)
{
	struct edma_transfer *head;
	uint32_t reg_val;
	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	if (!transfer)
	{
		pr_err("[ERROR] Invalid DMA transfer\n");
		return -EINVAL;
	}

	if (transfer->desc_num == 0)
	{
		pr_err("[ERROR] %s void descriptors in the transfer list\n", engine->name);
		return -EINVAL;
	}

	pr_info("[DBG] abort transfer 0x%p, desc %d, engine desc queued %d.\n",
			  transfer, transfer->desc_num, engine->desc_dequeued);

	reg_val = reg_rd(&engine->regs->status, engine->epdev);
	pr_info("Status : %x", reg_val);
	reg_val = reg_rd(&engine->regs->completed_desc_count, engine->epdev);
	pr_info("Desc completed: %x", reg_val);

	// list_ is linux queue.h system
	head = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
	if (head == transfer)
		list_del(engine->transfer_list.next);
	else
		pr_info("[DBG] engine %s, transfer 0x%p NOT found, 0x%p.\n", engine->name, transfer, head);

	if (transfer->state == TRANSFER_STATE_SUBMITTED)
		transfer->state = TRANSFER_STATE_ABORTED;
	return 0;
}

static int trans_init(struct edma_request_cb *req, struct edma_engine *engine, struct edma_transfer *trans)
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

	trans_desc_init(desc_max, trans);
	trans_bud(req, desc_max, engine, trans);

	trans->desc_adjacent = desc_max;

	/* terminate last descriptor */
	last = desc_max - 1;
	/* stop engine, EOP for AXI ST, req IRQ on last descriptor */
	control = EDMA_DESC_STOPPED;
	control |= EDMA_DESC_EOP;
	control |= EDMA_DESC_COMPLETED;
	cfg_desc_ctrl(control, trans->desc_virt + last);

	if (engine->eop_flush)
	{
		for (i = 0; i < last; i++)
			cfg_desc_ctrl(EDMA_DESC_COMPLETED, trans->desc_virt + i);
		trans->desc_cmpl_th = 1;
	}
	else
		trans->desc_cmpl_th = desc_max;

	trans->desc_num = desc_max;
	engine->desc_idx = (engine->desc_idx + desc_max) % engine->desc_max;
	engine->desc_used += desc_max;

	/* fill in adjacent numbers */
	for (i = 0; i < trans->desc_num; i++)
	{
		uint32_t next_adj = get_desc_next_adj((trans->desc_virt + i)->next_lo,
														  trans->desc_num - i - 1);
		cfg_desc_adj(next_adj, trans->desc_virt + i);
	}

	spin_unlock_irqrestore(&engine->lock, flags);

	return ret;
}

static int engine_cfg(struct edma_engine *engine)
{
	uint32_t reg_val;
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;
	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/* If a perf test is running, enable the engine interrupts */
	// if (engine->edma_perf) {
	reg_val = EDMA_INTR_MASK_DESC_STOPPED;
	reg_val |= EDMA_INTR_MASK_DESC_COMPLETED;
	reg_val |= EDMA_INTR_MASK_ALIGN_MISMATCH;
	reg_val |= EDMA_INTR_MASK_MAGIC_STOPPED;
	reg_val |= EDMA_INTR_MASK_IDLE_STOPPED;
	reg_val |= EDMA_INTR_MASK_READ_ERROR;
	reg_val |= EDMA_INTR_MASK_DESC_ERROR;

	reg_wr(reg_val, &engine->regs->interrupt_enable_mask,
			 (unsigned long)(&engine->regs->interrupt_enable_mask) - (unsigned long)epdev->bar[epdev->config_bar_idx], engine->epdev);
	//}

	/* write control register of SG DMA engine */
	reg_val = (uint32_t)EDMA_CTRL_RUN_STOP;
	reg_val |= (uint32_t)EDMA_CTRL_IE_READ_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
	reg_val |= (uint32_t)EDMA_CTRL_IE_MAGIC_STOPPED;

	if (poll)
	{
		reg_val |= (uint32_t)EDMA_CTRL_POLL_MODE_WB;
	}
	else
	{
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_STOPPED;
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_COMPLETED;
	}
	/* set non-incremental addressing mode */
	if (engine->non_incr_addr)
		reg_val |= (uint32_t)EDMA_CTRL_NON_INCR_ADDR;

	/* start the engine */
	// reg_val = reg_rd(&engine->regs->status, engine->epdev);
	//  pr_info("Status : %x", reg_val);

	reg_wr(reg_val, &engine->regs->control,
			 (unsigned long)(&engine->regs->control) - (unsigned long)(engine->regs), engine->epdev);

	/* dummy read of status register to flush all previous writes */
	reg_val = reg_rd(&engine->regs->status, engine->epdev);
	//pr_info("Status : %x", reg_val);
	return 0;
}

static struct edma_request_cb *edma_request_alloc(unsigned int sdesc_nr)
{
	struct edma_request_cb *req;
	unsigned int size = sizeof(struct edma_request_cb) + sdesc_nr * sizeof(struct sw_desc);

	req = kzalloc(size, GFP_KERNEL);
	if (!req)
	{
		req = vzalloc(size);
		if (!req)
		{
			pr_warn("[WARN] Out of memory, %u sw_desc, %u.\n", sdesc_nr, size);
			return NULL;
		}
	}
	return req;
}

static void edm_req_free(struct edma_request_cb *req)
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

	for (i = 0; i < max; i++, sg = sg_next(sg))
	{
		unsigned int len = sg_dma_len(sg);

		if (unlikely(len > desc_blen_max))
			extra += (len + desc_blen_max - 1) / desc_blen_max;
	}

	max += extra;
	req = edma_request_alloc(max);
	if (!req)
		return NULL;

	req->sgt = sgt;
	req->ep_addr = ep_addr;

	for (i = 0, sg = sgt->sgl; i < sgt->nents; i++, sg = sg_next(sg))
	{
		unsigned int tlen = sg_dma_len(sg);
		dma_addr_t addr = sg_dma_address(sg);

		req->total_len += tlen;
		while (tlen)
		{
			req->sdesc[j].addr = addr;
			if (tlen > desc_blen_max)
			{
				req->sdesc[j].len = desc_blen_max;
				addr += desc_blen_max;
				tlen -= desc_blen_max;
			}
			else
			{
				req->sdesc[j].len = tlen;
				tlen = 0;
			}
			j++;
		}
	}

	if (j > max)
	{
		pr_err("[ERROR] Cannot transfer more than supported length %d MB\n", desc_blen_max / 1024 / 1024);
		edm_req_free(req);
		return NULL;
	}
	req->sw_desc_cnt = j;
#ifdef __EDMA_DEBUG__
	// edma_request_cb_dump(req);
#endif
	return req;
}

/**
 * engine_status_rd() - read status of SG DMA engine (optionally reset)
 *
 * Stores status in engine->status.
 *
 * @return error value on failure, 0 otherwise
 */
static int engine_status_rd(bool clr, struct edma_engine *engine)
{
	int ret = 0;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/* read status register */
	if (clr)
		engine->status = reg_rd(&engine->regs->status_rc, engine->epdev);
	else
		engine->status = reg_rd(&engine->regs->status, engine->epdev);

	return ret;
}

/**
 * edmeng_done() - stop an SG DMA engine
 *
 */
static int edmeng_done(struct edma_engine *engine)
{
	uint32_t reg_val;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}
	if (enable_st_cth_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE)
		reg_wr(0, &engine->regs->credits, 0, engine->epdev);
	reg_val = 0;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ALIGN_MISMATCH;
	reg_val |= (uint32_t)EDMA_CTRL_IE_MAGIC_STOPPED;
	reg_val |= (uint32_t)EDMA_CTRL_IE_READ_ERROR;
	reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_ERROR;

	if (poll)
	{
		reg_val |= (uint32_t)EDMA_CTRL_POLL_MODE_WB;
	}
	else
	{
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_STOPPED;
		reg_val |= (uint32_t)EDMA_CTRL_IE_DESC_COMPLETED;
	}

	reg_wr(reg_val, &engine->regs->control,
			 (unsigned long)(&engine->regs->control) - (unsigned long)(engine->regs), engine->epdev);
	/* dummy read of status register to flush all previous writes */
	engine->running = 0;
	return 0;
}

static struct edma_transfer *engine_start(struct edma_engine *engine)
{
	int ret;
	uint32_t reg_val, next_adj;
	struct edma_transfer *transfer;
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	/* engine must be idle */
	if (engine->running)
	{
		pr_info("[ERROR] %s engine is not in idle state to start\n", engine->name);
		return NULL;
	}

	/* engine transfer queue must not be empty */
	if (list_empty(&engine->transfer_list))
	{
		pr_warn("[WARN] %s engine transfer queue must not be empty\n", engine->name);
		return NULL;
	}
	/* inspect first transfer queued on the engine */
	transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
	if (!transfer)
	{
		pr_warn("[WARN] %s queued transfer must not be empty\n", engine->name);
		return NULL;
	}

	/* engine is no longer shutdown */
	engine->shutdown = ENGINE_SHUTDOWN_NONE;

	/* Add credits for Streaming mode CTH */
	if (enable_st_cth_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE)
		reg_wr(engine->desc_used, &engine->regs->credits, 0, engine->epdev);

	/* initialize number of descriptors of dequeued transfers */
	engine->desc_dequeued = 0;

	/* write lower 32-bit of bus address of transfer first descriptor */
	reg_val = cpu_to_le32(PCI_DMA_L(transfer->desc_bus));
	reg_wr(reg_val, &engine->regs->first_desc_lo,
			 (unsigned long)(&engine->regs->first_desc_lo) - (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);
	/* write upper 32-bit of bus address of transfer first descriptor */
	reg_val = cpu_to_le32(PCI_DMA_H(transfer->desc_bus));
	reg_wr(reg_val, &engine->regs->first_desc_hi,
			 (unsigned long)(&engine->regs->first_desc_hi) - (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);

	next_adj = get_desc_next_adj(cpu_to_le32(PCI_DMA_L(transfer->desc_bus)), transfer->desc_adjacent);

	reg_wr(next_adj, &engine->regs->first_desc_adjacent,
			 (unsigned long)(&engine->regs->first_desc_adjacent) -
				  (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);

#if HAS_MMIOWB
	mmiowb();
#endif
	ret = engine_cfg(engine);
	if (ret < 0)
	{
		pr_err("[ERROR] Failed to start engine mode config\n");
		return NULL;
	}

	ret = engine_status_rd(0, engine);
	if (ret < 0)
	{
		pr_err("[ERROR] Failed to read engine status\n");
		return NULL;
	}
	/* remember the engine is running */
	engine->running = 1;

	return transfer;
}

#ifdef __EDMA_DEBUG__
static void dup_des(struct edma_desc *desc_virt)
{
	int j;
	u32 *p = (u32 *)desc_virt;
	static char *const field_name[] = {"bytes(hi 5 bits)",
												  "lo 23 bits|extra_adjacent|control",
												  "src_addr_hi",
												  "src_addr_lo",
												  "dst_addr_hi",
												  "dst_addr_lo",
												  "next_addr_pad",
												  "next_addr"};

	char *dummy;

	/* remove warning about unused variable when debug printing is off */
	dummy = field_name[0];

	for (j = 0; j < 8; j += 1)
	{
		pr_info("0x%08lx/0x%02lx: 0x%08x 0x%08x %s\n", (uintptr_t)p,
				  (uintptr_t)p & 15, (int)*p, le32_to_cpu(*p),
				  field_name[j]);
		p++;
	}
	pr_info("\n");
}

static void transdup(struct edma_transfer *transfer)
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
		dup_des(desc_virt + i);
}
#endif

static int req_reg(struct efx_pci_dev *epdev)
{
	int ret;

	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIE dev\n");
		return -EINVAL;
	}

	if (!epdev->pdev)
	{
		pr_err("[ERROR] Invalid pdev\n");
		return -EINVAL;
	}

	ret = pci_request_regions(epdev->pdev, EDMA_MOD_NAME);
	/* could not request all regions? */
	if (ret)
	{
		/* assume device is in use so do not disable it later */
		epdev->regions_in_use = 1;
	}
	else
	{
		epdev->got_regions = 1;
	}

	return ret;
}

/*
 * Unmap the BAR regions that had been mapped earlier using map_b()
 */
static void unmap_dma_bar(struct efx_pci_dev *epdev)
{
	int i;

	for (i = 0; i < EDMA_BAR_NUM; i++)
	{
		/* is this BAR mapped? */
		if (epdev->bar[i])
		{
			/* unmap BAR */
			pci_iounmap(epdev->pdev, epdev->bar[i]);
			/* mark as unmapped */
			epdev->bar[i] = NULL;
		}
	}
}

/* map_pci_bar() -- Map a PCI BAR into kernel virtual address space */
static int map_pci_bar(int idx, struct efx_pci_dev *epdev)
{
	resource_size_t bar_start = pci_resource_start(epdev->pdev, idx);
	resource_size_t bar_len = pci_resource_len(epdev->pdev, idx);
	resource_size_t map_len = bar_len;

	epdev->bar[idx] = NULL;

	/* Skip mapping if BAR length is zero (start can be zero) */
	if (bar_len == 0)
	{
		// pr_info("BAR #%d is not present - skipping\n", idx);
		return 0;
	}

	/* Cap mapping size if it exceeds maximum */
	/* Cap map_len if it exceeds the maximum value of resource_size_t */
	if (map_len > MAX_BAR_SIZE)
	{
		pr_info("Limiting BAR %d mapping from %llu to %llu bytes due to resource_size_t limit\n",
				  idx, (u64)bar_len, (u64)RES_SIZE_MAX);
		map_len = MAX_BAR_SIZE;
	}

	/* Map the BAR into kernel virtual address space */
	pr_info("[DBG] Mapping BAR%d: %llu bytes\n", idx, (u64)map_len);
	epdev->bar[idx] = pci_iomap(epdev->pdev, idx, map_len);

	if (!epdev->bar[idx])
	{
		pr_info("[ERROR] Failed to map BAR %d\n", idx);
		return -EINVAL; // Using standard error code instead of -1
	}

	pr_info("BAR%d at 0x%llx mapped at 0x%p, length=%llu(/%llu)\n",
			  idx, (u64)bar_start, epdev->bar[idx], (u64)map_len, (u64)bar_len);

	return 1;
}

static int is_cfg_bar(int idx, struct efx_pci_dev *epdev) // TODO: Obsolete this, need a better method to search config bar
{
	uint32_t irq_id = 0, cfg_id = 0, flag = 0;
	uint32_t mask = 0xffffff;
	struct interrupt_regs *irq_regs = (struct interrupt_regs *)(epdev->bar[idx] + EDMA_OFFSET_INT_CTRL);
	struct config_regs *cfg_regs = (struct config_regs *)(epdev->bar[idx] + EDMA_OFFSET_CONFIG);

	irq_id = reg_rd(&irq_regs->identifier, epdev);
	cfg_id = reg_rd(&cfg_regs->identifier, epdev);

	if (((irq_id & mask) == IRQ_BLOCK_ID) && ((cfg_id & mask) == CONFIG_BLOCK_ID))
	{
		pr_info("[DBG] BAR %d is the EDMA config BAR\n", idx);
		flag = 1;
	}
	else
	{
		pr_info("[DBG] BAR %d is NOT the EDMA config BAR: 0x%x[0x%lx], 0x%x[0x%lx].\n", idx, irq_id, IRQ_BLOCK_ID, cfg_id, CONFIG_BLOCK_ID);
		flag = 0;
	}

	return flag;
}

/*
 * Setup BAR configuration for DMA.
 * 3 types of possible BAR:
 * CONFIG_BAR: BAR to access DMA internal registers
 * BYPASS_BAR: BAR to access AXI master bypass interface
 * USER_BAR: BAR to access APB slave (user) interface
 */
static int setup_dma_bar(struct efx_pci_dev *epdev)
{
	int ret;
#ifdef EDMA_CONFIG_BAR_NUM
	ret = map_pci_bar(EDMA_CONFIG_BAR_NUM, epdev);
	if (ret <= 0)
	{
		pr_info("%s, map config bar %d failed, %d.\n",
				  dev_name(&epdev->pdev->dev), EDMA_CONFIG_BAR_NUM, ret);
		return -EINVAL;
	}

	//	if (is_bar(EDMA_CONFIG_BAR_NUM, epdev) == 0) {
	//		pr_info("%s, unable to identify config bar %d.\n",
	//			dev_name(&epdev->pdev->dev), EDMA_CONFIG_BAR_NUM);
	//		return -EINVAL;
	//	}
	epdev->config_bar_idx = EDMA_CONFIG_BAR_NUM;

	if (!pci_resource_len(epdev->pdev, EDMA_BYPASS_BAR_NUM))
		return 0;
	ret = map_pci_bar(EDMA_BYPASS_BAR_NUM, epdev);
	if (ret <= 0)
	{
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
	for (i = 0; i < EDMA_BAR_NUM; i++)
	{
		int bar_len;

		bar_len = map_pci_bar(i, epdev);
		if (bar_len == 0)
		{
			continue;
		}
		else if (bar_len < 0)
		{
			ret = -EINVAL;
			goto fail;
		}

		/* Try to identify BAR as EDMA control BAR */
		if (epdev->config_bar_idx < 0 && (0 == i || 1 == i))
		{
			if (is_cfg_bar(i, epdev))
			{
				epdev->config_bar_idx = i;
				config_bar_pos = bar_id_idx;
				pr_info("config bar %d, pos %d.\n", epdev->config_bar_idx, config_bar_pos);
			}
		}

		if (epdev->custom_bar_idx < 0 && (4 == i || 5 == i))
		{
			epdev->custom_bar_idx = i;
			pr_info("customize bar %d.\n", epdev->custom_bar_idx);
		}

		if (epdev->bypass_bar_idx < 0 && (2 == i || 3 == i))
		{
			epdev->bypass_bar_idx = i;
			pr_info("bypass bar %d.\n", epdev->bypass_bar_idx);
		}

		bar_id_list[bar_id_idx] = i;
		bar_id_idx++;
	}

	/* The EDMA config BAR must always be present */
	if (epdev->config_bar_idx < 0)
	{
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
	/* unmap any BARs that we did map */
	unmap_dma_bar(epdev);
	return ret;

#endif
	return 0;
}

static int read_engine_id(struct engine_regs *regs, struct efx_pci_dev *epdev)
{
	int value;

	if (!regs)
	{
		pr_err("[ERROR] Invalid engine registers\n");
		return -EINVAL;
	}

	value = reg_rd(&regs->identifier, epdev);
	return (value) >> 16; //
}

static int engine_channel_id(struct engine_regs *regs, struct efx_pci_dev *epdev)
{
	int value;

	if (!regs)
	{
		pr_err("[ERROR] Invalid engine registers\n");
		return -EINVAL;
	}

	value = reg_rd(&regs->identifier, epdev);

	return (value & 0x00000f00U) >> 8;
}

static void engine_free(struct edma_engine *engine)
{
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;

	/* Release memory use for descriptor writebacks */
	if (engine->poll_mode_addr_virt)
	{
		dma_free_coherent(&epdev->pdev->dev, sizeof(struct edma_poll_wb),
								engine->poll_mode_addr_virt,
								engine->poll_mode_bus);
		engine->poll_mode_addr_virt = NULL;
	}

	if (engine->desc)
	{
		dma_free_coherent(&epdev->pdev->dev,
								engine->desc_max * sizeof(struct edma_desc),
								engine->desc, engine->desc_bus);
		engine->desc = NULL;
	}
}

static int eng_allsource(struct edma_engine *engine)
{
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;

	engine->desc = dma_alloc_coherent(&epdev->pdev->dev, engine->desc_max * sizeof(struct edma_desc),
												 &engine->desc_bus, GFP_KERNEL);
	if (!engine->desc)
	{
		pr_err("[ERROR] dev %s, %s pre-alloc desc OOM.\n", dev_name(&epdev->pdev->dev), engine->name);
		goto err_out;
	}

	if (poll)
	{
		engine->poll_mode_addr_virt =
			 dma_alloc_coherent(&epdev->pdev->dev, sizeof(struct edma_poll_wb),
									  &engine->poll_mode_bus, GFP_KERNEL);
		if (!engine->poll_mode_addr_virt)
		{
			pr_warn("[WARN] %s, %s poll pre-alloc writeback OOM.\n", dev_name(&epdev->pdev->dev), engine->name);
			goto err_out;
		}
	}
	if (engine->streaming && engine->dir == DMA_FROM_DEVICE)
	{
		engine->cyclic_result = dma_alloc_coherent(
			 &epdev->pdev->dev,
			 engine->desc_max * sizeof(struct edma_result),
			 &engine->cyclic_result_bus, GFP_KERNEL);

		if (!engine->cyclic_result)
		{
			pr_warn("%s, %s pre-alloc result OOM.\n",
					  dev_name(&epdev->pdev->dev), engine->name);
			goto err_out;
		}
	}
	return 0;

err_out:
	engine_free(engine);
	return -ENOMEM;
}

static struct edma_transfer *engine_transfer_completion(struct edma_engine *engine, struct edma_transfer *transfer)
{
	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (unlikely(!transfer))
	{
		pr_err("[ERROR] %s transfer empty.\n", engine->name);
		return NULL;
	}
	/* synchronous I/O? */
	/* awake task on transfer's wait queue */
	edma_wake_up(&transfer->wq);

	return transfer;
}

static struct edma_transfer *engine_service_transfer_list(struct edma_engine *engine,
																			 struct edma_transfer *transfer, uint32_t *pdesc_completed)
{
	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (!pdesc_completed)
	{
		pr_err("[ERROR] %s completed descriptors are null.\n", engine->name);
		return NULL;
	}

	if (unlikely(!transfer))
	{
		pr_err("[ERROR] %s transfer empty, pdesc completed %u.\n", engine->name, *pdesc_completed);
		return NULL;
	}

	/*
	 * iterate over all the transfers completed by the engine,
	 * except for the last (i.e. use > instead of >=).
	 */
	while (transfer && (!transfer->cyclic) && (*pdesc_completed > transfer->desc_num))
	{
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
		if (!list_empty(&engine->transfer_list))
		{
			transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
			pr_info("[DBG] Non-completed transfer %p\n", transfer);
		}
		else
		{
			/* no further transfers? */
			transfer = NULL;
		}
	}

	return transfer;
}

static int eng_serv_shutdown(struct edma_engine *engine)
{
	int ret;
	/* if the engine stopped with RUN still asserted, de-assert RUN now */
	ret = edmeng_done(engine);
	if (ret < 0)
	{
		pr_err("Failed to stop engine\n");
		return ret;
	}

	/* awake task on engine's shutdown wait queue */
	edma_wake_up(&engine->shutdown_wq);
	return 0;
}

static struct edma_transfer *engine_service_final_transfer(struct edma_engine *engine,
																			  struct edma_transfer *transfer, uint32_t *pdesc_completed)
{
	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return NULL;
	}

	if (!pdesc_completed)
	{
		pr_err("[ERROR] %s completed descriptors are null.\n", engine->name);
		return NULL;
	}

	if (unlikely(!transfer))
	{
		pr_err("[ERROR] %s transfer empty, pdesc completed %u.\n", engine->name, *pdesc_completed);
		return NULL;
	}

	if (((engine->dir == DMA_FROM_DEVICE) && (engine->status & EDMA_STAT_CTH_ERR_MASK)) ||
		 ((engine->dir == DMA_TO_DEVICE) && (engine->status & EDMA_STAT_HTC_ERR_MASK)))
	{

		pr_err("[ERROR] engine %s, status error 0x%x.\n", engine->name, engine->status);
		// engine_status_dump(engine);
		// engine_err_handle(engine, transfer, *pdesc_completed);
		goto transfer_del;
	}

	// if (engine->status & EDMA_STAT_BUSY)
	// pr_info("[WARN] engine %s is unexpectedly busy - ignoring\n", engine->name);

	/* the engine stopped on current transfer? */
	if (*pdesc_completed < transfer->desc_num)
	{
		if (engine->eop_flush)
		{
			/* check if eop received */
			struct edma_result *result = transfer->res_virt;
			int i;
			int max = *pdesc_completed;

			for (i = 0; i < max; i++)
			{
				if ((result[i].status & RX_STATUS_EOP) != 0)
				{
					transfer->flags |= TRANSFER_FLAG_ST_CTH_EOP_RCVED;
					break;
				}
			}

			transfer->desc_cmpl += *pdesc_completed;
			if (!(transfer->flags & TRANSFER_FLAG_ST_CTH_EOP_RCVED))
			{
				return NULL;
			}

			/* mark transfer as successfully completed */
			eng_serv_shutdown(engine);

			transfer->state = TRANSFER_STATE_COMPLETED;

			engine->desc_dequeued += transfer->desc_cmpl;
		}
		else
		{
			transfer->state = TRANSFER_STATE_FAILED;
			pr_info("[WARN] %s, xfer 0x%p, stopped half-way, %d/%d.\n", engine->name, transfer, *pdesc_completed,
					  transfer->desc_num);

			/* add dequeued number of descriptors during this run */
			engine->desc_dequeued += transfer->desc_num;
			transfer->desc_cmpl = *pdesc_completed;
		}
	}
	else
	{
		// pr_info("[DBG][FINISH] engine %s completed transfer\n", engine->name);
		// pr_info("[DBG][FINISH] Completed transfer ID = 0x%p\n", transfer);
		// pr_info("[DBG][FINISH] *pdesc_completed=%d, transfer->desc_num=%d", *pdesc_completed, transfer->desc_num);

		if (!transfer->cyclic)
		{
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

static uint32_t eng_servmoni(uint32_t expwb, struct edma_engine *engine)
{
	uint32_t desc_wb = 0, sched_limit = 0;
	unsigned long timeout;
	struct edma_poll_wb *wb_data;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}
	wb_data = (struct edma_poll_wb *)engine->poll_mode_addr_virt;
	/*
	 * Poll the writeback location for the expected number of
	 * descriptors / error events This loop is skipped for cyclic mode,
	 * where the expected_desc_count passed in is zero, since it cannot be
	 * determined before the function is called
	 */

	timeout = jiffies + (POLL_TIMEOUT_SECONDS * HZ);
	while (expwb != 0)
	{
		desc_wb = wb_data->completed_desc_count;

		if (desc_wb)
			wb_data->completed_desc_count = 0;

		if (desc_wb & WB_ERR_MASK)
		{
			break;
		}
		else if (desc_wb >= expwb)
		{
			break;
		}
		/* prevent system from hanging in polled mode */
		if (time_after(jiffies, timeout))
		{
			pr_info("[DBG][POLLING]  Polling timeout(%d sec) occurred\n", POLL_TIMEOUT_SECONDS);
			if ((desc_wb & WB_COUNT_MASK) > expwb)
				desc_wb = expwb | WB_ERR_MASK;

			break;
		}

		/*
		 * Define NUM_POLLS_PER_SCHED to limit how much time is spent
		 * in the scheduler
		 */
		if (sched_limit != 0)
		{
			if ((sched_limit % NUM_POLLS_PER_SCHED) == 0)
				schedule();
		}
		sched_limit++;
	}
	return desc_wb;
}

/* trans_que() - Queue a DMA transfer on the engine
 *
 * @engine DMA engine doing the transfer
 * @transfer DMA transfer submitted to the engine
 *
 * Takes and releases the engine spinlock
 */
static int trans_que(struct edma_transfer *transfer, struct edma_engine *engine)
{
	int ret = 0;
	unsigned long flags;
	struct edma_transfer *transfer_started;
	struct efx_pci_dev *epdev;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	if (!engine->epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIe device\n");
		return -EINVAL;
	}

	if (!transfer)
	{
		pr_err("[ERROR] %s Invalid DMA transfer\n", engine->name);
		return -EINVAL;
	}

	if (transfer->desc_num == 0)
	{
		pr_err("[ERROR] %s void descriptors in the transfer list\n", engine->name);
		return -EINVAL;
	}

	epdev = (struct efx_pci_dev *)engine->epdev;
	/* lock the engine state */
	spin_lock_irqsave(&engine->lock, flags);

	engine->prev_cpu = get_cpu();
	put_cpu();

	/* engine is being shutdown; do not accept new transfers */
	if (engine->shutdown & ENGINE_SHUTDOWN_REQUEST)
	{
		pr_info("engine %s offline, transfer 0x%p not queued.\n", engine->name, transfer);
		ret = -EBUSY;
		goto shutdown;
	}

	/* mark the transfer as submitted */
	transfer->state = TRANSFER_STATE_SUBMITTED;
	/* add transfer to the tail of the engine transfer queue */
	list_add_tail(&transfer->entry, &engine->transfer_list);

	/* engine is idle? */
	if (!engine->running)
	{
		/* start engine */
		transfer_started = engine_start(engine);
		if (!transfer_started)
		{
			pr_err("[ERROR] Failed to start dma engine\n");
			goto shutdown;
		}
		// pr_info("[DBG] transfer=0x%p started %s engine with transfer 0x%p.\n", transfer, engine->name, transfer_started);
	}
	else
	{
		// pr_info("[DBG] transfer=0x%p queued, with %s engine running.\n", transfer, engine->name);
	}

shutdown:
	/* unlock the engine state */
	spin_unlock_irqrestore(&engine->lock, flags);

	return ret;
}

static int engine_service_resume(struct edma_engine *engine)
{
	struct edma_transfer *transfer_started;

	if (!engine)
	{
		pr_err("dma engine NULL\n");
		return -EINVAL;
	}

	/* Check the engine running status */
	if (!engine->running)
	{
		/* in the case of shutdown, let it finish what's in the Q */
		if (!list_empty(&engine->transfer_list))
		{
			/* (re)start engine */
			transfer_started = engine_start(engine);
			if (!transfer_started)
			{
				pr_err("[ERROR] Failed to start dma engine\n");
				return -EINVAL;
			}
			/* engine was requested to be shutdown? */
		}
		else if (engine->shutdown & ENGINE_SHUTDOWN_REQUEST)
		{
			engine->shutdown |= ENGINE_SHUTDOWN_IDLE;
			/* awake task on engine's shutdown wait queue */
			edma_wake_up(&engine->shutdown_wq);
		}
		else
		{
			// pr_info("[DBG] no pending transfers, %s engine stays idle.\n", engine->name);
		}
	}
	else if (list_empty(&engine->transfer_list))
	{
		eng_serv_shutdown(engine);
	}
	return 0;
}

ssize_t edm_subreq(struct sg_table *sgt, struct edma_engine *engine, bool map, uint64_t addr)
{
	int i, ret, nents, trans_idx = 0;
	unsigned long flags;
	struct efx_pci_dev *epdev;
	struct scatterlist *sg = sgt->sgl;
	ssize_t done_size = 0;
	struct edma_request_cb *req = NULL;
	struct edma_transfer *trans;

	if (!engine)
	{
		pr_err("[ERROR] dma engine is NULL\n");
		return -EINVAL;
	}
	epdev = (struct efx_pci_dev *)engine->epdev;

	if (!map)
	{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		nents = dma_map_sg(&(epdev->pdev)->dev, sg, sgt->orig_nents, engine->dir);
#else
		nents = pci_map_sg(epdev->pdev, sg, sgt->orig_nents, engine->dir);
#endif
		if (!nents)
		{
			pr_err("[ERROR] map sgl failed, sgt 0x%p.\n", sgt);
			return -EIO;
		}
		sgt->nents = nents;
	}
	else
	{
		if (!sgt->nents)
		{
			pr_err("[ERROR] sg table has invalid number of entries 0x%p.\n", sgt);
			return -EIO;
		}
	}

	req = edma_init_request(sgt, addr);
	if (!req)
	{
		ret = -ENOMEM;
		goto UNMAP_SGL;
	}

	mutex_lock(&engine->desc_lock);
	while (nents)
	{
		/* build transfer */
		ret = trans_init(req, engine, &req->tfer[0]);
		if (ret < 0)
		{
			mutex_unlock(&engine->desc_lock);
			goto UNMAP_SGL;
		}
		trans = &req->tfer[0];
		if (!map)
			trans->flags = TRANSFER_FLAG_NEED_UNMAP;

		/* last transfer for the given request? */
		nents -= trans->desc_num;
		if (!nents)
		{
			trans->last_in_request = 1;
			trans->sgt = sgt;
		}

#ifdef __EDMA_DEBUG__
		transdup(trans);
#endif
		ret = trans_que(trans, engine);
		// End of transfer detected
		if (ret < 0)
		{
			mutex_unlock(&engine->desc_lock);
			pr_info("unable to submit %s, %d.\n", engine->name, ret);
			goto UNMAP_SGL;
		}

		if (engine->cmplthp)
			edma_kthread_wakeup(engine->cmplthp);

		// wait for DMA done signal
		edma_wait_event_interruptible(trans->wq, (trans->state != TRANSFER_STATE_SUBMITTED));

		spin_lock_irqsave(&engine->lock, flags);

		switch (trans->state)
		{
		case TRANSFER_STATE_COMPLETED:
			spin_unlock_irqrestore(&engine->lock, flags);
			ret = 0;
			/* For CTH streaming use writeback results */
			if (engine->streaming && engine->dir == DMA_FROM_DEVICE)
			{
				struct edma_result *result = trans->res_virt;

				for (i = 0; i < trans->desc_cmpl; i++)
					done_size += result[i].length;

				/* finish the whole request */
				if (engine->eop_flush)
					nents = 0;
			}
			else
			{
				done_size += trans->len;
			}
			break;
		case TRANSFER_STATE_FAILED:
			pr_info("[DBG] transfer=%p, %u, failed, ep 0x%llx.\n", trans, trans->len, req->ep_addr - trans->len);
			spin_unlock_irqrestore(&engine->lock, flags);
#ifdef __EDMA_DEBUG__
			// transdup(trans);
			// sgt_dump(sgt);
#endif
			ret = -EIO;
			break;
		default:
			/* transfer can still be in-flight */
			ret = engine_status_rd(0, engine);
			if (ret < 0)
			{
				pr_err("[ERROR] Failed to read engine status\n");
			}
			else if (ret == 0)
			{
				// engine_status_dump(engine);
				ret = trans_abt(trans, engine);
				if (ret < 0)
				{
					pr_err("[ERROR] Failed to stop engine\n");
				}
				else if (ret == 0)
				{
					ret = edmeng_done(engine);
					if (ret < 0)
						pr_err("[ERROR] Failed to stop engine\n");
				}
			}
			spin_unlock_irqrestore(&engine->lock, flags);
#ifdef __EDMA_DEBUG__
			// transdup(trans);
			// sgt_dump(sgt);
#endif
			ret = -ERESTARTSYS;
			break;
		}

		engine->desc_used -= trans->desc_num;
		trans_des(trans, epdev);

		/* use multiple transfers per request if we could not fit
		 * all data within single descriptor chain.
		 */
		trans_idx++;

		if (ret < 0)
		{
			mutex_unlock(&engine->desc_lock);
			goto UNMAP_SGL;
		}
	} /* while (sg) */
	mutex_unlock(&engine->desc_lock);
UNMAP_SGL:
	if (!map && sgt->nents)
	{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
		dma_unmap_sg(&(epdev->pdev)->dev, sgt->sgl, sgt->orig_nents, engine->dir);
#else
		pci_unmap_sg(epdev->pdev, sgt->sgl, sgt->orig_nents, engine->dir);
#endif
		sgt->nents = 0;
	}

	if (req)
		edm_req_free(req);

	/* as long as some data is processed, return the count */
	return done_size ? done_size : ret;
}
static int eng_serv(int des_wrb, struct edma_engine *engine)
{
	struct edma_transfer *transfer = NULL;
	uint32_t desc_count = des_wrb & WB_COUNT_MASK;
	uint32_t err_flag = des_wrb & WB_ERR_MASK;
	int ret = 0;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/* Service the engine */
	if (!engine->running)
	{
		pr_info("[DBG] Engine was not running!!! Clearing status\n");
		ret = engine_status_rd(1, engine);
		if (ret < 0)
		{
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
	if ((desc_count == 0) || (err_flag != 0))
	{
		ret = engine_status_rd(1, engine);
		if (ret < 0)
		{
			pr_err("[ERROR] Failed to read engine status\n");
			return ret;
		}
	}

	/*
	 * engine was running but is no longer busy, or writeback occurred,
	 * shut down
	 */
	if ((engine->running && !(engine->status & EDMA_STAT_BUSY)) || (!engine->eop_flush && desc_count != 0))
	{
		ret = eng_serv_shutdown(engine);
		if (ret < 0)
		{
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
		desc_count = reg_rd(&engine->regs->completed_desc_count, engine->epdev);

	// pr_info("[DBG][INTR-SERVICE] %s wb 0x%x, desc_count %u, err %u, dequeued %u.\n", engine->name, des_wrb, desc_count, err_flag, engine->desc_dequeued);

	if (!desc_count)
		goto done;

	/* transfers on queue? */
	if (!list_empty(&engine->transfer_list))
	{
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
	if (!engine->eop_flush)
	{
		ret = engine_service_resume(engine);
		if (ret < 0)
			pr_err("[ERROR] Failed to resume engine\n");
	}
#endif

done:
	/* If polling detected an error, signal to the caller */
	return err_flag ? -1 : 0;
}

int eng_serv_poll(uint32_t exp_cnt, struct edma_engine *engine)
{
	uint32_t desc_wb = 0;
	unsigned long flags;
	int ret = 0;

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	/*
	 * Poll the writeback location for the expected number of
	 * descriptors / error events This loop is skipped for cyclic mode,
	 * where the expected_desc_count passed in is zero, since it cannot be
	 * determined before the function is called
	 */

	desc_wb = eng_servmoni(exp_cnt, engine);
	if (!desc_wb)
		return 0;

	spin_lock_irqsave(&engine->lock, flags);
	ret = eng_serv(desc_wb, engine);
	spin_unlock_irqrestore(&engine->lock, flags);
	return ret;
}

/* eng_servwork */
static void eng_servwork(struct work_struct *work)
{
	struct edma_engine *engine;
	unsigned long flags;
	int ret;
	struct efx_pci_dev *epdev;

	engine = container_of(work, struct edma_engine, work);
	epdev = (struct efx_pci_dev *)engine->epdev;

	/* lock the engine */
	spin_lock_irqsave(&engine->lock, flags);

	ret = eng_serv(0, engine);
	if (ret < 0)
	{
		pr_err("[ERROR] Failed to service engine\n");
		goto unlock;
	}

	/* re-enable interrupts for this engine */
	if (epdev->msix_enabled)
	{
		reg_wr(engine->interrupt_enable_mask_value, &engine->regs->interrupt_enable_mask_w1s,
				 (unsigned long)(&engine->regs->interrupt_enable_mask_w1s) - (unsigned long)(engine->regs), engine->epdev);
	}
	else
		chan_inter_en(engine->irq_bitmask, (struct efx_pci_dev *)engine->epdev);

	/* unlock the engine */
unlock:
	spin_unlock_irqrestore(&engine->lock, flags);
}

static void eng_alig(struct edma_engine *engine)
{
	uint32_t w;
	uint32_t align_bytes, granularity_bytes, address_bits;

	w = reg_rd(&engine->regs->alignments, engine->epdev);
	pr_info("[DBG] engine %p name %s alignments=0x%08x\n", engine, engine->name, (int)w);

	align_bytes = (w & 0x00ff0000U) >> 16;
	granularity_bytes = (w & 0x0000ff00U) >> 8;
	address_bits = (w & 0x000000ffU);

	if (w)
	{
		engine->addr_align = align_bytes;
		engine->len_granularity = granularity_bytes;
		engine->addr_bits = address_bits;
	}
	else
	{
		/* Some default values if alignments are unspecified */
		engine->addr_align = 1;
		engine->len_granularity = 1;
		engine->addr_bits = 64;
	}
}

static int eng_wrset(struct edma_engine *engine)
{
	uint32_t reg_value;
	struct edma_poll_wb *writeback;
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;

	if (!engine)
	{
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
	reg_wr(reg_value, &engine->regs->poll_mode_wb_lo,
			 (unsigned long)(&engine->regs->poll_mode_wb_lo) -
				  (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);
	reg_value = cpu_to_le32(PCI_DMA_H(engine->poll_mode_bus));
	reg_wr(reg_value, &engine->regs->poll_mode_wb_hi,
			 (unsigned long)(&engine->regs->poll_mode_wb_hi) -
				  (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);

	return 0;
}

static int eng_reg(struct edma_engine *engine)
{
	uint32_t reg_value;
	int ret = 0;
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)engine->epdev;

	reg_wr(EDMA_CTRL_NON_INCR_ADDR, &engine->regs->control_w1c,
			 (unsigned long)(&engine->regs->control_w1c) -
				  (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);

	eng_alig(engine);

	/* Configure error interrupts by default */
	reg_value = EDMA_INTR_MASK_ALIGN_MISMATCH;
	reg_value |= EDMA_INTR_MASK_MAGIC_STOPPED;
	reg_value |= EDMA_INTR_MASK_READ_ERROR;
	reg_value |= EDMA_INTR_MASK_DESC_ERROR;

	/* if using polled mode, configure writeback address */
	if (poll)
	{
		ret = eng_wrset(engine);
		if (ret)
		{
			pr_info("[DBG] %s descr writeback setup failed.\n", engine->name);
			goto fail_wb;
		}
	}
	else
	{
		/* enable the relevant completion interrupts */
		reg_value |= EDMA_INTR_MASK_DESC_STOPPED;
		reg_value |= EDMA_INTR_MASK_DESC_COMPLETED;
	}
	/* Apply engine configurations */
	reg_wr(reg_value, &engine->regs->interrupt_enable_mask,
			 (unsigned long)(&engine->regs->interrupt_enable_mask) -
				  (unsigned long)(engine->regs) +
				  ((unsigned long)(engine->regs) - (unsigned long)epdev->bar[epdev->config_bar_idx]),
			 engine->epdev);

	engine->interrupt_enable_mask_value = reg_value;

	return 0;
fail_wb:
	return ret;
}

static int eng_init(int channel, struct edma_engine *engine, int offset, enum dma_data_direction dir, struct efx_pci_dev *epdev)
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
	engine->epdev = (void *)epdev;
	/* register address */
	engine->regs = (epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_ENGINE_REG + offset);
	// engine->sgdma_regs = epdev->bar[epdev->config_bar_idx] + offset + SGDMA_OFFSET_FROM_CHANNEL;
	val = reg_rd(&engine->regs->identifier, engine->epdev);
	if (val & EDMA_ID_STREAM_MODE)
		engine->streaming = 1; // linc:set streaming mode

	/* remember SG DMA direction */
	engine->dir = dir;
	snprintf(engine->name, sizeof(engine->name), "%d-%s%d-%s", epdev->idx,
				(dir == DMA_TO_DEVICE) ? "HTC" : "CTH", channel,
				engine->streaming ? "ST" : "MM");

	if (enable_st_cth_credit && engine->streaming &&
		 engine->dir == DMA_FROM_DEVICE)
		engine->desc_max = EDMA_ENGINE_CREDIT_XFER_MAX_DESC;
	else
		engine->desc_max = EDMA_ENGINE_XFER_MAX_DESC;

	pr_info("[DBG] engine %p name %s irq_bitmask=0x%08x\n", engine, engine->name, (int)engine->irq_bitmask);

	/* initialize the deferred work for transfer completion */
	INIT_WORK(&engine->work, eng_servwork);

	if (dir == DMA_TO_DEVICE)
		epdev->mask_irq_htc |= engine->irq_bitmask;
	else
		epdev->mask_irq_cth |= engine->irq_bitmask;
	epdev->engines_num++;

	ret = eng_allsource(engine);
	if (ret)
		return ret;

	ret = eng_reg(engine);
	if (ret)
		return ret;

	if (poll)
		efx_thrd_add(engine);

	return 0;
}

static int destroy_engine(struct edma_engine *engine, struct efx_pci_dev *epdev)
{
	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIe device\n");
		return -EINVAL;
	}

	if (!engine)
	{
		pr_err("[ERROR] dma engine NULL\n");
		return -EINVAL;
	}

	pr_info("[INFO] Shutting down engine %s%d", engine->name, engine->channel);

	/* Disable interrupts to stop processing new events during shutdown */
	reg_wr(0x0, &engine->regs->interrupt_enable_mask,
			 (unsigned long)(&engine->regs->interrupt_enable_mask) -
				  (unsigned long)(engine->regs),
			 engine->epdev);

	if (enable_st_cth_credit && engine->streaming && engine->dir == DMA_FROM_DEVICE)
	{
		uint32_t reg_value = (0x1 << engine->channel) << 16;
		struct sgdma_common_regs *reg =
			 (struct sgdma_common_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_COMMON_SGDMA);
		reg_wr(reg_value, &reg->credit_mode_enable_w1c, 0, engine->epdev);
	}

	if (poll)
		efx_thrdload(engine);

	/* Release memory use for descriptor writebacks */
	engine_free(engine);

	memset(engine, 0, sizeof(struct edma_engine));
	/* Decrement the number of engines available */
	epdev->engines_num--;
	return 0;
}

static int probe_engine(int channel, enum dma_data_direction dir, struct efx_pci_dev *epdev)
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
	if (dir == DMA_TO_DEVICE)
	{
		engine_id_expected = EDMA_ID_HTC;
		engine = &epdev->engine_htc[channel];
	}
	else
	{
		offset += HTC_CHANNEL_OFFSET;
		engine_id_expected = EDMA_ID_CTH;
		engine = &epdev->engine_cth[channel];
	}

	regs = epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_ENGINE_REG + offset;
	engine_id = read_engine_id(regs, epdev);
	channel_id = engine_channel_id(regs, epdev);

	if ((engine_id != engine_id_expected) || (channel_id != channel))
	{
		pr_info(
			 "[DBG] %s %d engine, reg off 0x%x, id mismatch 0x%x,0x%x,exp 0x%x,0x%x, SKIP.\n",
			 dir == DMA_TO_DEVICE ? "HTC" : "CTH", channel, offset,
			 engine_id, channel_id, engine_id_expected,
			 channel_id != channel);
		return -EINVAL;
	}

	pr_info("[DBG] found DMA %s %d engine, reg. off 0x%x, id 0x%x,0x%x.\n",
			  dir == DMA_TO_DEVICE ? "HTC" : "CTH", channel, offset,
			  engine_id, channel_id);

	/* allocate and initialize engine */
	ret = eng_init(channel, engine, offset, dir, epdev);
	if (ret != 0)
	{
		pr_warn("[WARN] failed to create DMA %s %d engine.\n",
				  dir == DMA_TO_DEVICE ? "HTC" : "CTH", channel);
		return ret;
	}

	return 0;
}

static void remove_engine(struct efx_pci_dev *epdev)
{
	int i;
	int ret;
	struct edma_engine *engine;

	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIE device\n");
		return;
	}

	/* iterate over channels */
	for (i = 0; i < epdev->htc_channel_max; i++)
	{
		engine = &epdev->engine_htc[i];
		pr_info("[DBG] Remove %s, %d", engine->name, i);
		ret = destroy_engine(engine, epdev);
		if (ret < 0)
			pr_err("[ERROR] Failed to remove HTC engine %d\n", i);
		pr_info("[INFO] %s, %d removed", engine->name, i);
	}

	for (i = 0; i < epdev->cth_channel_max; i++)
	{
		engine = &epdev->engine_cth[i];
		pr_info("[DBG] Remove %s, %d", engine->name, i);
		ret = destroy_engine(engine, epdev);
		if (ret < 0)
			pr_err("[ERROR] Failed to remove CTH engine %d\n", i);
		pr_info("[INFO] %s, %d removed", engine->name, i);
	}
}

static int dma_probeng(struct efx_pci_dev *epdev)
{
	int i, ret = 0;

	if (!epdev)
	{
		pr_err("[ERROR] Invalid Efinix PCIe device\n");
		return -EINVAL;
	}

	/* iterate over channels */
	for (i = 0; i < epdev->htc_channel_max; i++)
	{
		ret = probe_engine(i, DMA_TO_DEVICE, epdev);
		if (ret)
			break;
	}
	epdev->htc_channel_max = i;

	for (i = 0; i < epdev->cth_channel_max; i++)
	{
		ret = probe_engine(i, DMA_FROM_DEVICE, epdev);
		if (ret)
			break;
	}
	epdev->cth_channel_max = i;

	return 0;
}

#if KERNEL_VERSION(3, 5, 0) <= LINUX_VERSION_CODE
static void pci_capen(int cap, struct pci_dev *pdev)
{
	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL, cap);
}
#else
static void pci_capen(int cap, struct pci_dev *pdev)
{
	uint16_t v;
	int pos;

	pos = pci_pcie_cap(pdev);
	if (pos > 0)
	{
		pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &v);
		v |= cap;
		pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, v);
	}
}
#endif

void edmadev_off(void *p_epdev)
{
	struct efx_pci_dev *epdev;

	if (!p_epdev)
		return;

	epdev = (struct efx_pci_dev *)p_epdev;

	chan_interdisable(~0, epdev);
	ur_interdisable(~0, p_epdev);
	rd_inter(epdev);

	irq_trdown(p_epdev);
	msi_msix_dis(epdev);

	remove_engine(epdev);
	// if (poll)	efx_thrd_dest();
	unmap_dma_bar(epdev);

	pci_release_regions(epdev->pdev);

	pci_disable_device(epdev->pdev);

	epdev_list_remove(epdev);

	return;
}

int edmadev_on(void *p_epdev)
{
	int ret = 0, i;
	struct efx_pci_dev *epdev = (struct efx_pci_dev *)p_epdev;

	epdev->user_irqs_max = MAX_USER_IRQ;
	epdev->user_max = MAX_USER_IRQ;
	epdev->cth_channel_max = MAX_DMA_CHANNEL;
	epdev->htc_channel_max = MAX_DMA_CHANNEL;

	ret = epdev_list_add(epdev);
	if (ret < 0)
		return -ENODEV;

	/* Set up data user IRQ data structures */
	for (i = 0; i < 16; i++)
	{
		epdev->user_irq[i].epdev = epdev;
		spin_lock_init(&epdev->user_irq[i].events_lock);
		init_waitqueue_head(&epdev->user_irq[i].events_wq);
		epdev->user_irq[i].handler = NULL;
		epdev->user_irq[i].user_idx = i; /* 0 based */
	}

	ret = pci_enable_device(epdev->pdev);
	if (ret)
	{
		pr_info("[DBG] pci_enable_device() failed, %d.\n", ret);
		return -ENODEV;
	}

	/* keep INTx enabled */
	pci_intr_pend(epdev->pdev);

	/* enable relaxed ordering */
	pci_capen(PCI_EXP_DEVCTL_RELAX_EN, epdev->pdev);

	/* enable extended tag */
	pci_capen(PCI_EXP_DEVCTL_EXT_TAG, epdev->pdev);

	/* force MRRS to be 512 */
	ret = pcie_set_readrq(epdev->pdev, 2048);
	if (ret)
		pr_info("device %s, error set PCI_EXP_DEVCTL_READRQ: %d.\n", dev_name(&epdev->pdev->dev), ret);

	/* enable bus master capability */
	pci_set_master(epdev->pdev);

	ret = req_reg(epdev);
	if (ret)
		goto err_regions;

	ret = setup_dma_bar(epdev);
	if (ret)
		goto err_map;

	ret = dma_mask_ready(epdev->pdev);
	if (ret)
		goto err_mask;

	check_intersta(epdev);
	/* explicitely zero all interrupt enable masks */
	chan_interdisable(~0, epdev);
	ur_interdisable(~0, epdev);
	rd_inter(epdev);
	/*
		if (poll) {
			ret = efx_thrd_create(epdev->htc_channel_max + epdev->cth_channel_max);
		}
	*/
	ret = dma_probeng(epdev);
	if (ret)
		goto err_mask;

	ret = msi_msix_en(epdev);
	if (ret < 0)
		goto err_engines;

	ret = irq_ready(epdev);
	if (ret < 0)
		goto err_msix;

	if (!poll)
		chan_inter_en(~0, epdev);

	/* Flush writes */
	rd_inter(epdev);

	return 0;
err_msix:
	msi_msix_dis(epdev);
err_engines:
	remove_engine(epdev);
// if (poll) efx_thrd_dest();
err_mask:
	unmap_dma_bar(epdev);
err_map:
	if (epdev->got_regions)
		pci_release_regions(epdev->pdev);
err_regions:
	if (!epdev->regions_in_use)
		pci_disable_device(epdev->pdev);
	epdev_list_remove(epdev);
	return -ENODEV;
}
