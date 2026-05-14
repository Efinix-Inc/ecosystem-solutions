#ifndef __EDMA_MISC_H__
#define __EDMA_MISC_H__

int misc_kobj_init(struct edma_pci_dev *epdev, const char *name);
void misc_kobj_evict(struct edma_pci_dev *epdev);
void misc_sysfs_register(void);
void misc_sysfs_destroy(void);

#endif /*__EDMA_MISC_H__*/
