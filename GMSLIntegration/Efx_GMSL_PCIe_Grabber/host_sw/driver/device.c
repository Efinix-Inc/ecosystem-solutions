#include "dma.h"
#include "common.h"
#include "file_io.h"
#include "misc.h"

#define DRV_MODULE_NAME "pcie_dma"
#define DRV_MODULE_DESC "Efinix PCIe DMA Driver"
#define DRV_MODULE_VERSION "1.0"

static char version[] = DRV_MODULE_VERSION;

/* Vendor and device ID */
static const struct pci_device_id pci_ids[] = {
	 {
		  PCI_DEVICE(0x1F7A, 0x0100),
	 },
	 {
		  0,
	 }};

static void epdev_free(struct efx_pci_dev *epdev)
{
	if (!epdev)
		return;
	kfree(epdev);
	return;
}

static struct efx_pci_dev *epdev_alloc(struct pci_dev *pdev)
{
	struct efx_pci_dev *epdev = NULL;

	if (!pdev)
		return NULL;

	epdev = kmalloc(sizeof(struct efx_pci_dev), GFP_KERNEL);
	if (!epdev)
		return NULL;
	memset((void *)epdev, 0, sizeof(struct efx_pci_dev));

	epdev->pdev = pdev;
	epdev->config_bar_idx = -1;
	epdev->custom_bar_idx = -1;
	epdev->bypass_bar_idx = -1;

	spin_lock_init(&epdev->irq_reg_lock);
	return epdev;
}

static int efx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
	int ret = 0;
	struct efx_pci_dev *epdev = NULL, *tmp;

	pr_info("[PROBE] EDMA driver probe one Efinix device!\n");

	epdev = epdev_alloc(pdev);
	if (!epdev)
	{
		pr_err("[ERROR] Alloc PCI device object failed! pdev=%p\n", pdev);
		return -ENOMEM;
	}

	ret = edmadev_on((void *)epdev);
	if (ret)
	{
		ret = -EINVAL;
		goto err_out;
	}

	/* make sure no duplicate */
	tmp = epdev_find_by_pdev(pdev);
	if (!tmp)
	{
		pr_warn("NO epdev found!\n");
		ret = -EINVAL;
		goto err_out;
	}

	if (tmp != epdev)
	{
		pr_err("Efinix PCIe device handle mismatch\n");
		ret = -EINVAL;
		goto err_out;
	}
	pr_info("[PROBE] EDMA driver create MISC sysfs interfaces!\n");
	// Register and add kobject to the kernel
	ret = add_kobject(epdev, "dma");
	if (ret)
	{
		pr_err("[ERROR] Kobject failed to register! <%d>epdev=%p\n", epdev->major, epdev);
	}
	pr_info("[PROBE] EDMA driver create cdev interfaces!\n");

	// init character device
	ret = init_char_device(epdev);
	if (ret)
		goto err_out;

	dev_set_drvdata(&pdev->dev, epdev);
	pr_info("[PROBE] Pcie dma driver probe Efinix device Done!\n");
	return 0;
err_out:
	pr_err("[ERROR] pdev 0x%p, err %d.\n", pdev, ret);
	// Remove kobject from the kernal and free up the memory
	remove_kobject(epdev);
	epdev_free(epdev);
	return ret;
}

static void efx_remove(struct pci_dev *pdev)
{
	struct efx_pci_dev *epdev = NULL;

	if (!pdev)
		return;

	epdev = dev_get_drvdata(&pdev->dev);
	if (!epdev)
		return;

	remove_char_device(epdev);
	remove_kobject(epdev);
	edmadev_off((void *)epdev);
	epdev_free(epdev);
	dev_set_drvdata(&pdev->dev, NULL);
}

/* Driver registration struct */
static struct pci_driver pci_driver = {
	 .name = DRV_MODULE_NAME,
	 .id_table = pci_ids,
	 .probe = efx_probe,
	 .remove = efx_remove,
};

static int efx_module_init(void)
{
	pr_info("Driver entry-> Version: %s", version);
	// Initialize character device
	init_cdev();
	// Register kobject to sysfs
	register_sysfs();
	return pci_register_driver(&pci_driver);
}

static void efx_module_exit(void)
{
	/* unregister this driver from the PCI bus driver */
	remove_sysfs();
	pci_unregister_driver(&pci_driver);
	clean_cdev();
}

module_init(efx_module_init);
module_exit(efx_module_exit);

MODULE_AUTHOR("Efinix Inc");
MODULE_DESCRIPTION(DRV_MODULE_DESC);
MODULE_LICENSE("Dual BSD/GPL");
