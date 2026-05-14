#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"
#include "edma_misc.h"

#define DRV_MOD_MAJOR		2024
#define DRV_MOD_MINOR		5
#define DRV_MOD_PATCHLEVEL	2

#define DRV_MODULE_VERSION      \
	__stringify(DRV_MOD_MAJOR) "." \
	__stringify(DRV_MOD_MINOR) "." \
	__stringify(DRV_MOD_PATCHLEVEL)

#define DRV_MOD_VERSION_NUMBER  \
	((DRV_MOD_MAJOR)*1000 + (DRV_MOD_MINOR)*100 + DRV_MOD_PATCHLEVEL)

#define DRV_MODULE_NAME		"pcie_dma"
#define DRV_MODULE_DESC		"Edma Reference Driver"

static char version[] =
	DRV_MODULE_DESC " " DRV_MODULE_NAME " v" DRV_MODULE_VERSION "\n";

MODULE_AUTHOR("Efinix, Inc.");
MODULE_DESCRIPTION(DRV_MODULE_DESC);
MODULE_VERSION(DRV_MODULE_VERSION);
MODULE_LICENSE("Dual BSD/GPL");

static const struct pci_device_id pci_ids[] = {
	{ PCI_DEVICE(0x17cd, 0x0100), },
	{ PCI_DEVICE(0x1f7a, 0x0100), },
	{ PCI_DEVICE(0x10ee, 0x8034), },
	{0,}
};

static void epdev_free(struct edma_pci_dev *epdev)
{
	if (!epdev)
		return;
	kfree(epdev);
	return;
}

static struct edma_pci_dev *epdev_alloc(struct pci_dev *pdev)
{
	struct edma_pci_dev *epdev = NULL;

	if (!pdev)
		return NULL;
	
	epdev = kmalloc(sizeof(struct edma_pci_dev), GFP_KERNEL);
	if (!epdev)
		return NULL;
	memset((void*)epdev, 0, sizeof(struct edma_pci_dev));

	epdev->pdev = pdev;
	
	return epdev;
}

static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
{
	int ret = 0;
	struct edma_pci_dev *epdev = NULL;
	
	pr_info("[PROBE] EDMA driver probe one Edma device!\n");

	epdev = epdev_alloc(pdev);
	if (!epdev) {
		pr_err("[ERROR] Alloc Edma PCI device object failed! pdev=%p\n", pdev);
		return -ENOMEM;
	}

	ret = edma_device_open((void*)epdev);
	if (ret) {
		ret = -EINVAL;
		goto err_out;
	}
	pr_info("[PROBE] EDMA driver create MISC sysfs interfaces!\n");
	// create misc sys object
	ret = misc_kobj_init(epdev, "dma");
	if (ret) {
		pr_err("[ERROR] Registed Edma misc sys kobject failed! <%d>epdev=%p\n", epdev->major, epdev);
	}
	pr_info("[PROBE] EDMA driver create cdev interfaces!\n");
	// create char device interfaces
	ret = epdev_create_interfaces(epdev);
	if (ret)
		goto err_out;

	dev_set_drvdata(&pdev->dev, epdev);
	pr_info("[PROBE] EDMA driver probe one Edma device Done!\n");
	return 0;
err_out:
	pr_err("[ERROR] pdev 0x%p, err %d.\n", pdev, ret);
	misc_kobj_evict(epdev);
	epdev_free(epdev);
	return ret;

}

static void remove_one(struct pci_dev *pdev)
{
	struct edma_pci_dev *epdev = NULL;

	if (!pdev) 
		return;

	epdev = dev_get_drvdata(&pdev->dev);
	if (!epdev)
		return;

	epdev_destroy_interfaces(epdev);
	misc_kobj_evict(epdev);
	edma_device_close((void*)epdev);
	epdev_free(epdev);
	dev_set_drvdata(&pdev->dev, NULL);
}


static struct pci_driver pci_driver = {
	.name = DRV_MODULE_NAME,
	.id_table = pci_ids,
	.probe = probe_one,
	.remove = remove_one,
};

static int edma_module_init(void)
{
	pr_info("%s", version);
	edma_cdev_init();
	misc_sysfs_register();
	return pci_register_driver(&pci_driver);
}

static void edma_module_exit(void)
{
	/* unregister this driver from the PCI bus driver */
	misc_sysfs_destroy();
	pci_unregister_driver(&pci_driver);
	edma_cdev_cleanup();
}

module_init(edma_module_init);
module_exit(edma_module_exit);

