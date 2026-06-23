#ifndef __MISC_H__
#define __MISC_H__

int add_kobject(struct efx_pci_dev *epdev, const char *name);
void remove_kobject(struct efx_pci_dev *epdev);
void register_sysfs(void);
void remove_sysfs(void);

#endif /*__MISC_H__*/
