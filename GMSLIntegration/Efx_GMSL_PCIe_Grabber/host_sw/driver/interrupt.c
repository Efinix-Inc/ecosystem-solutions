#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/vmalloc.h>
#include "dma.h"
#include "common.h"

// Interrupt type definitions
enum interrupt_type
{
	INTR_TYPE_AUTO = 0,
	INTR_TYPE_MSI = 1,
	INTR_TYPE_LEGACY = 2,
	INTR_TYPE_MSIX = 3
};

static unsigned int intr = INTR_TYPE_MSIX; // Default to MSI-X interrupt
module_param(intr, uint, 0644);
MODULE_PARM_DESC(intr, "0 - Auto , 1 - MSI, 2 - Legacy, 3 - MSI-x");

void check_intersta(struct efx_pci_dev *epdev)
{
	struct interrupt_regs *regs;
	uint32_t value;
	char *dev_names;

	dev_names = (char *)dev_name(&epdev->pdev->dev);
	regs = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	if (!regs)
	{
		pr_err("Failed to get interrupt registers\n");
		return;
	}

	// Check and log interrupt registers
#define CHECK_REG(reg_name, field)                        \
	do                                                     \
	{                                                      \
		value = reg_rd(&regs->field, epdev);                \
		if (value)                                          \
		{                                                   \
			pr_info("%s: edma%d %s = 0x%08x\n",              \
					  dev_names, epdev->idx, reg_name, value); \
		}                                                   \
	} while (0)

	CHECK_REG("user_int_enable", user_int_enable);
	CHECK_REG("channel_int_enable", channel_int_enable);
	CHECK_REG("user_int_request", user_int_request);
	CHECK_REG("channel_int_request", channel_int_request);
	CHECK_REG("user_int_pending", user_int_pending);
	CHECK_REG("channel_int_pending", channel_int_pending);

#undef CHECK_REG
}

/* ur_interdisable -- Disable interrupts we not interested in */
void ur_interdisable(uint32_t mask, struct efx_pci_dev *epdev) // TODO: rename
{
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	reg_wr(mask, &reg->user_int_enable_w1c,
			 (unsigned long)(&reg->user_int_enable_w1c) - (unsigned long)(epdev->bar[epdev->config_bar_idx]), epdev);
	return;
}

/* chan_interdisable -- Disable interrupts we not interested in */
void chan_interdisable(uint32_t mask, struct efx_pci_dev *epdev)

{
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	reg_wr(mask, &reg->channel_int_enable_w1c,
			 ((uint64_t)&reg->channel_int_enable_w1c - (uint64_t)epdev->bar[epdev->config_bar_idx]), epdev);
	return;
}

/* rd_inter -- Print the interrupt controller status */
uint32_t rd_inter(struct efx_pci_dev *epdev)
{
	uint32_t lo, hi;
	struct interrupt_regs *reg;

	reg = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	if (!reg)
	{
		pr_err("Failed to get interrupt registers\n");
		return 0;
	}

	/* extra debugging; inspect complete engine set of registers */
	hi = reg_rd(&reg->user_int_request, epdev);
	lo = reg_rd(&reg->channel_int_request, epdev);

	/* return interrupts: user in upper 16-bits, channel in lower 16-bits */
	return bud_u32(lo, hi);
}

#ifndef arch_msi_check_device
static int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
{
	return 0;
}
#endif

/* type = PCI_CAP_ID_MSI or PCI_CAP_ID_MSIX */
static int msi_cap(int type, struct pci_dev *dev)
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

int msi_msix_en(struct efx_pci_dev *epdev) // TODO: RENAME
{
	int ret = 0;
	int req_nvec = epdev->cth_channel_max + epdev->htc_channel_max + epdev->user_irqs_max;
	int i;
	u16 control;
	void *msi_reg = NULL;

	if (!epdev)
	{
		pr_err("[ERROR] Invalid EFX PCIe dev\n");
		return -EINVAL;
	}

	if ((intr == INTR_TYPE_MSIX || !intr) && msi_cap(PCI_CAP_ID_MSIX, epdev->pdev))
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		pr_info("[DBG] Enabling MSI-X, requested vector count=%d\n", req_nvec);
		ret = pci_alloc_irq_vectors(epdev->pdev, req_nvec, req_nvec, PCI_IRQ_MSIX);
#else
		pr_info("[DBG] Enabling MSI-X\n");
		for (i = 0; i < req_nvec; i++)
			epdev->entry[i].entry = i;

		ret = pci_enable_msix(epdev->pdev, epdev->entry, req_nvec);
#endif
		if (ret < 0)
			pr_warn("[WARN] FAILED to enable MSI-X mode: %d\n", ret);

		epdev->msix_enabled = 1; // TODO: Set this to 0 if ret < 0??
	}
	else if ((intr == INTR_TYPE_MSI || !intr) &&
				msi_cap(PCI_CAP_ID_MSI, epdev->pdev))
	{
		/* enable message signalled interrupts */
		u32 msi_addr_l = 0;
		u32 msi_addr_h = 0;
		u32 msi_data = 0;

#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		pr_info("[DBG] Enabling MSI, requested vector count=%d\n", req_nvec);
		ret = pci_alloc_irq_vectors(epdev->pdev, 1, 1, PCI_IRQ_MSI);
		for (i = 0; i < ret; i++)
		{
			pr_info("[DBG] irq_vector#%d = %d \n", pci_irq_vector(epdev->pdev, i), epdev->pdev->irq);
		}

#else

		ret = pci_enable_msi(epdev->pdev); // PCIe read MSI
#endif
		if (ret < 0)
		{
			pr_warn("[WARN] FAILED to enable MSI mode: %d\n", ret);
		}
		ret = pci_find_capability(epdev->pdev, PCI_CAP_ID_MSI);
		if (!ret)
		{
			pr_err("[ERR] FAILED to find PCI Capability: %d\n", ret);
		}
		// Read the lower 32 bits of the MSI address
		pci_read_config_dword(epdev->pdev, ret + PCI_MSI_ADDRESS_LO, &msi_addr_l);
		// Check if the device supports 64-bit MSI address

		pci_read_config_word(epdev->pdev, ret + PCI_MSI_FLAGS, &control);
		if (control & PCI_MSI_FLAGS_64BIT)
		{
			// Read the upper 32 bits of the MSI address
			pci_read_config_dword(epdev->pdev, ret + PCI_MSI_ADDRESS_HI, &msi_addr_h);
		}

		pr_info("[TEST] MSI Address Low = %d\n", msi_addr_l);
		pr_info("[TEST] MSI Address High = %d\n", msi_addr_h);
		pr_info("[TEST] MSI Enabled\n");

		msi_reg = epdev->bar[0] + 0x8000;
		iowrite32(msi_addr_l, msi_reg + 0xF00);
		iowrite32(msi_addr_h, msi_reg + 0xF04);
		iowrite32(msi_data, msi_reg + 0xF08);
		iowrite32(0, msi_reg + 0x00C);

		// write vector to 0x94 0x98
		//  Then write to F00
		epdev->msi_enabled = 1; // TODO: Set this to 0 if ret < 0??
	}
	else
	{
		pr_info("[DBG] MSI/MSI-X not detected - using legacy interrupts\n");
	}

	return ret;
}

void msi_msix_dis(struct efx_pci_dev *epdev) // TODO: RENAME Disable MSI
{
	if (epdev->msix_enabled)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		pci_free_irq_vectors(epdev->pdev);
#else
		pci_disable_msix(epdev->pdev);
#endif
		epdev->msix_enabled = 0;
	}
	else if (epdev->msi_enabled)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		pci_free_irq_vectors(epdev->pdev);
#else
		pci_disable_msi(epdev->pdev);
#endif
		epdev->msi_enabled = 0;
	}
	reg_wr(0, epdev->bar[epdev->config_bar_idx] + 0x400a8, 0x400a8, epdev);
}

/* chan_inter_en -- Enable interrupts we are interested in */
void chan_inter_en(uint32_t mask, struct efx_pci_dev *epdev)
{
	struct interrupt_regs *reg =
		 (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	reg_wr(mask, &reg->channel_int_enable_w1s,
			 (unsigned long)(&reg->channel_int_enable_w1s) - (unsigned long)(epdev->bar[epdev->config_bar_idx]), epdev);
}

static irqreturn_t user_irq_service(int irq, struct edma_user_irq *user_irq)
{
	unsigned long flags;

	pr_info("[DBG-IRQ] (user irq=%d) <<<< INTERRUPT SERVICE ROUTINE\n", irq);
	if (!user_irq)
	{
		pr_err("[ERROR] Invalid user_irq\n");
		return IRQ_NONE;
	}

	if (user_irq->handler)
		return user_irq->handler(user_irq->user_idx, user_irq->dev);

	spin_lock_irqsave(&(user_irq->events_lock), flags);
	if (!user_irq->events_irq)
	{
		user_irq->events_irq = 1;
		wake_up_interruptible(&(user_irq->events_wq));
	}
	spin_unlock_irqrestore(&(user_irq->events_lock), flags);

	return IRQ_HANDLED;
}

/*
 * edma_user_irq() - Interrupt handler for user interrupts in MSI-X mode
 *
 * @dev_id pointer to efxe_pci_dev
 */
static irqreturn_t edma_user_irq(int irq, void *dev_id)
{
	struct edma_user_irq *user_irq;

	pr_info("[DBG-IRQ] (irq=%d) <<<< INTERRUPT SERVICE ROUTINE\n", irq);

	if (!dev_id)
	{
		pr_err("[ERROR] Invalid dev_id on irq line %d\n", irq);
		return IRQ_NONE;
	}
	user_irq = (struct edma_user_irq *)dev_id;

	return user_irq_service(irq, user_irq);
}

/*
 * edma_chanirt() - Interrupt handler for channel interrupts in MSI-X mode
 *
 * @dev_id pointer to efxe_pci_dev
 */
static irqreturn_t edma_chanirt(int irq, void *dev_id)
{
	struct efx_pci_dev *epdev;
	struct edma_engine *engine;
	struct interrupt_regs *irq_regs;

	// pr_info("[IRQ] (irq=%d) <<<< INTERRUPT service ROUTINE\n", irq);
	if (!dev_id)
	{
		pr_err("[ERROR-irq]Invalid dev_id on irq line %d\n", irq);
		return IRQ_NONE;
	}

	engine = (struct edma_engine *)dev_id;
	epdev = (struct efx_pci_dev *)engine->epdev;

	if (!epdev)
	{
		WARN_ON(!epdev);
		pr_info("[IRQ] %s(irq=%d) epdev=%p ??\n", __func__, irq, epdev);
		return IRQ_NONE;
	}

	irq_regs = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	/* Disable the interrupt for this engine */
	reg_wr(
		 engine->interrupt_enable_mask_value,
		 &engine->regs->interrupt_enable_mask_w1c,
		 (unsigned long)(&engine->regs->interrupt_enable_mask_w1c) -
			  (unsigned long)(epdev->bar[epdev->config_bar_idx]),
		 epdev);

	/* Dummy read to flush the above write */
	reg_rd(&irq_regs->channel_int_pending, epdev);
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
	struct efx_pci_dev *epdev;
	struct interrupt_regs *irq_regs;

	// pr_info("[DBG-IRQ] edma_isr>> (irq=%d, dev 0x%p) <<<< ISR.\n", irq, dev_id);
	if (!dev_id)
	{
		pr_err("[ERROR] Invalid dev_id on irq line %d\n", irq);
		return -IRQ_NONE;
	}
	epdev = (struct efx_pci_dev *)dev_id;

	if (!epdev)
	{
		WARN_ON(!epdev);
		pr_info("[WARN-IRQ] %s(irq=%d) epdev=%p ??\n", __func__, irq, epdev);
		return IRQ_NONE;
	}

	irq_regs = (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);

	/* read channel interrupt requests */
	ch_irq = reg_rd(&irq_regs->channel_int_request, epdev);
	// pr_info("[DBG-IRQ] ch_irq = 0x%08x\n", ch_irq);

	/*
	 * disable all interrupts that fired; these are re-enabled individually
	 * after the causing module has been fully serviced.
	 */
	if (ch_irq)
		chan_interdisable(ch_irq, epdev);
	/* read user interrupts - this read also flushes the above write */
	user_irq = reg_rd(&irq_regs->user_int_request, epdev);
	//pr_info("[DBG-IRQ] user_irq = 0x%08x\n", user_irq);

	if (user_irq)
	{
		int user = 0;
		uint32_t mask = 1;
		int max = epdev->user_max;

		for (; user < max && user_irq; user++, mask <<= 1)
		{
			if (user_irq & mask)
			{
				user_irq &= ~mask;
				user_irq_service(irq, &epdev->user_irq[user]);
			}
		}
	}

	mask = ch_irq & epdev->mask_irq_htc;
	if (mask)
	{
		int channel = 0;
		int max = epdev->htc_channel_max;

		/* iterate over HTC (PCIe read) */
		for (channel = 0; channel < max && mask; channel++)
		{
			struct edma_engine *engine = &epdev->engine_htc[channel];
			/* engine present and its interrupt fired? */
			if (engine->irq_bitmask & mask)
			{
				mask &= ~engine->irq_bitmask;
				reg_rd(&engine->regs->status_rc, engine->epdev);
				// pr_info("[DBG-IRQ] schedule_work, %s.\n", engine->name);
				schedule_work(&engine->work);
			}
		}
	}

	mask = ch_irq & epdev->mask_irq_cth;
	if (mask)
	{
		int channel = 0;
		int max = epdev->cth_channel_max;

		/* iterate over CTH (PCIe write) */
		for (channel = 0; channel < max && mask; channel++)
		{
			struct edma_engine *engine = &epdev->engine_cth[channel];
			/* engine present and its interrupt fired? */
			if (engine->irq_bitmask & mask)
			{
				mask &= ~engine->irq_bitmask;
				reg_rd(&engine->regs->status_rc, engine->epdev);
				// pr_info("[DBG-IRQ] schedule_work, %s.\n", engine->name);
				schedule_work(&engine->work);
			}
		}
	}

	epdev->irq_count++;
	return IRQ_HANDLED;
}

static int irq_legpre(struct efx_pci_dev *epdev)
{
	uint32_t w;
	uint8_t val;
	void *reg;
	int ret;

	pci_read_config_byte(epdev->pdev, PCI_INTERRUPT_PIN, &val);
	if (val == 0)
	{
		pr_info("[DBG] Legacy interrupt not supported\n");
		return -EINVAL;
	}

	pr_info("[DBG] Legacy Interrupt register value = %d\n", val);

	if (val > 1)
	{
		val--;
		w = (val << 24) | (val << 16) | (val << 8) | val;
		/* Program IRQ Block Channel vector and IRQ Block User vector
		 * with Legacy interrupt value
		 */
		reg = epdev->bar[epdev->config_bar_idx] + 0x2014; // IRQ user
		reg_wr(w, reg, 0x2014, epdev);
		reg_wr(w, reg + 0x4, 0x2018, epdev);
		reg_wr(w, reg + 0x8, 0x201c, epdev);
		reg_wr(w, reg + 0xC, 0x2020, epdev);
		reg = epdev->bar[epdev->config_bar_idx] + 0x2024; // IRQ Block
		reg_wr(w, reg, 0x2024, epdev);
		reg_wr(w, reg + 0x4, 0x2028, epdev);
	}

	epdev->irq_line = (int)epdev->pdev->irq;
	// ret = request_irq(epdev->pdev->irq, edma_isr, IRQF_ONESHOT, "edma", epdev);
	ret = request_irq(epdev->pdev->irq, edma_isr, IRQF_SHARED, "edma_leg", epdev);
	if (ret)
		pr_info("[DBG] Couldn't use IRQ#%d, %d\n", epdev->pdev->irq, ret);
	else
		pr_info("[DBG] Using IRQ#%d with 0x%p\n", epdev->pdev->irq, epdev);

	return ret;
}

static int irq_msix_user_setup(struct efx_pci_dev *epdev)
{
	int i;
	int j = epdev->htc_channel_max + epdev->cth_channel_max;
	int ret = 0;

	/* vectors set in probe_scan_for_msi() */
	for (i = 0; i < epdev->user_max; i++, j++)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		uint32_t vector = pci_irq_vector(epdev->pdev, j);
#else
		uint32_t vector = epdev->entry[j].vector;
#endif
		ret = request_irq(vector, edma_user_irq, 0, "edma_msix_user", &epdev->user_irq[i]);
		if (ret)
		{
			pr_info("[DBG] user %d couldn't use IRQ#%d, %d\n", i, vector, ret);
			break;
		}
		pr_info("[DBG] %d-USR-%d, IRQ#%d with 0x%p\n", epdev->idx, i, vector, &epdev->user_irq[i]);
	}

	/* If any errors occur, free IRQs that were successfully requested */
	if (ret)
	{
		for (i--, j--; i >= 0; i--, j--)
		{
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

static int irmsi_ready(struct efx_pci_dev *epdev)
{
	int ret;

	epdev->irq_line = (int)epdev->pdev->irq;
	ret = request_irq(epdev->pdev->irq, edma_isr, 0, "edma_msi", epdev);
	if (ret)
		pr_info("[DBG] Couldn't use IRQ#%d, %d\n", epdev->pdev->irq, ret);
	else
		pr_info("[DBG] Using IRQ#%d with 0x%p\n", epdev->pdev->irq, epdev);

	return ret;
}

static int irmsix_chanready(struct efx_pci_dev *epdev)
{
	int i, j;
	int ret = 0;
	uint32_t vector;
	struct edma_engine *engine;

	if (!epdev)
	{
		pr_err("[ERROR] EFX PCIe device is NULL\n");
		return -EINVAL;
	}
	if (!epdev->msix_enabled)
		return 0;

	j = epdev->htc_channel_max;
	engine = epdev->engine_htc;
	for (i = 0; i < epdev->htc_channel_max; i++, engine++)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		vector = pci_irq_vector(epdev->pdev, i);
#else
		vector = epdev->entry[i].vector;
#endif
		ret = request_irq(vector, edma_chanirt, 0, "edma_msix_cth", engine);
		if (ret)
		{
			pr_warn("[WARN] requesti irq#%d failed %d, engine %s.\n", vector, ret, engine->name);
			return ret;
		}
		pr_info("[DBG] engine %s, irq#%d.\n", engine->name, vector);
		engine->msix_irq_line = vector;
	}

	engine = epdev->engine_cth;
	for (i = 0; i < epdev->cth_channel_max; i++, j++, engine++)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		vector = pci_irq_vector(epdev->pdev, j);
#else
		vector = epdev->entry[j].vector;
#endif
		ret = request_irq(vector, edma_chanirt, 0, "edma_msix_htc", engine);
		if (ret)
		{
			pr_warn("[WARN] requesti irq#%d failed %d, engine %s.\n", vector, ret, engine->name);
			return ret;
		}
		pr_info("[DBG] engine %s, irq#%d.\n", engine->name, vector);
		engine->msix_irq_line = vector;
	}
	reg_wr(1, epdev->bar[epdev->config_bar_idx] + 0x400a8, 0x400a8, epdev);
	return 0;
}

static void progirq_mchan(bool clr, struct efx_pci_dev *epdev)
{
	struct interrupt_regs *int_regs =
		 (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);
	uint32_t max = epdev->cth_channel_max + epdev->htc_channel_max;
	uint32_t i;
	int j;

	/* engine */
	for (i = 0, j = 0; i < max; j++)
	{
		int k, shift = 0;
		uint32_t val = 0;

		if (clr)
			i += 4;
		else
			for (k = 0; k < 4 && i < max; i++, k++, shift += 8)
				val |= (i & 0x1f) << shift;

		reg_wr(val, &int_regs->channel_msi_vector[j],
				 EDMA_OFFSET_INT_CTRL + ((unsigned long)&int_regs->channel_msi_vector[j] -
												 (unsigned long)int_regs),
				 epdev);
		pr_info("[DBG] vector %d, 0x%x.\n", j, val);
	}
}

static void irqmsix_chandown(struct efx_pci_dev *epdev)
{
	struct edma_engine *engine;
	int j = 0;
	int i = 0;

	if (!epdev->msix_enabled)
		return;

	progirq_mchan(1, epdev);

	engine = epdev->engine_htc;
	for (i = 0; i < epdev->htc_channel_max; i++, j++, engine++)
	{
		if (!engine->msix_irq_line)
			break;
		pr_info("[DBG] Release IRQ#%d for engine %p\n", engine->msix_irq_line,
				  engine);
		free_irq(engine->msix_irq_line, engine);
	}

	engine = epdev->engine_cth;
	for (i = 0; i < epdev->cth_channel_max; i++, j++, engine++)
	{
		if (!engine->msix_irq_line)
			break;
		pr_info("[DBG] Release IRQ#%d for engine %p\n", engine->msix_irq_line,
				  engine);
		free_irq(engine->msix_irq_line, engine);
	}
}

static void irq_msix_ur(bool clr, struct efx_pci_dev *epdev)
{
	/* user */
	struct interrupt_regs *int_regs =
		 (struct interrupt_regs *)(epdev->bar[epdev->config_bar_idx] + EDMA_OFFSET_INT_CTRL);
	uint32_t i = epdev->cth_channel_max + epdev->htc_channel_max;
	uint32_t max = i + epdev->user_max;
	int j;

	for (j = 0; i < max; j++)
	{
		uint32_t val = 0;
		int k, shift = 0;

		if (clr)
			i += 4;
		else
			for (k = 0; k < 4 && i < max; i++, k++, shift += 8)
				val |= (i & 0x1f) << shift;

		reg_wr(val, &int_regs->user_msi_vector[j],
				 EDMA_OFFSET_INT_CTRL + ((unsigned long)&int_regs->user_msi_vector[j] -
												 (unsigned long)int_regs),
				 epdev);

		pr_info("[DBG] vector %d, 0x%x.\n", j, val);
	}
}

static void irqmsix_ur_teardown(struct efx_pci_dev *epdev)
{
	int i, j;

	if (!epdev)
	{
		pr_err("[ERROR] EFX PCIe device is NULL\n");
		return;
	}

	if (!epdev->msix_enabled)
		return;

	j = epdev->htc_channel_max + epdev->cth_channel_max;

	irq_msix_ur(true, epdev);

	for (i = 0; i < epdev->user_max; i++, j++)
	{
#if KERNEL_VERSION(4, 12, 0) <= LINUX_VERSION_CODE
		uint32_t vector = pci_irq_vector(epdev->pdev, j);
#else
		uint32_t vector = epdev->entry[j].vector;
#endif
		pr_info("[DBG] user %d, releasing IRQ#%d\n", i, vector);
		free_irq(vector, &epdev->user_irq[i]);
	}
}

void irq_trdown(struct efx_pci_dev *epdev)
{
	if (epdev->msix_enabled)
	{
		irqmsix_chandown(epdev);
		irqmsix_ur_teardown(epdev);
	}
	else if (epdev->irq_line != -1)
	{
		pr_info("[INFO] Releasing IRQ#%d\n", epdev->irq_line);
		free_irq(epdev->irq_line, epdev);
	}
}

static void pciintx_keepen(struct pci_dev *pdev)
{
	uint16_t pcmd, pcmd_new;

	pci_read_config_word(pdev, PCI_COMMAND, &pcmd);
	pcmd_new = pcmd & ~PCI_COMMAND_INTX_DISABLE;
	if (pcmd_new != pcmd)
	{
		pr_info("[DBG] %s: clear INTX_DISABLE, 0x%x -> 0x%x.\n",
				  dev_name(&pdev->dev), pcmd, pcmd_new);
		pci_write_config_word(pdev, PCI_COMMAND, pcmd_new);
	}
}

int irq_ready(struct efx_pci_dev *epdev)
{
	int ret;
	pciintx_keepen(epdev->pdev);

	if (epdev->msix_enabled)
	{
		ret = irmsix_chanready(epdev);

		if (ret)
			return ret;
		ret = irq_msix_user_setup(epdev);
		if (ret)
			return ret;
		progirq_mchan(0, epdev);
		irq_msix_ur(0, epdev);

		return 0;
	}
	else if (epdev->msi_enabled)
		return irmsi_ready(epdev);

	return irq_legpre(epdev);
}

void pci_intr_pend(struct pci_dev *pdev)
{
	uint16_t v;

	pci_read_config_word(pdev, PCI_STATUS, &v);
	if (v & PCI_STATUS_INTERRUPT)
	{
		pr_info("%s PCI STATUS Interrupt pending 0x%x.\n",
				  dev_name(&pdev->dev), v);
		pci_write_config_word(pdev, PCI_STATUS, PCI_STATUS_INTERRUPT);
	}
}
