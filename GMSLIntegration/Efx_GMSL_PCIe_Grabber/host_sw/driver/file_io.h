#ifndef __EDMA_CDEV_H__
#define __EDMA_CDEV_H__
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include <asm/cacheflush.h>

#define EDMA_NODE_NAME "pcie_dma"
#define EDMA_MINOR_BASE (0)
#define EDMA_MINOR_COUNT (255)

enum cdev_type
{
	EFX_FILE_USER,
	EFX_FILE_CTRL,
	EFX_FILE_EVENTS,
	EFX_FILE_HTC,
	EFX_FILE_CTH,
	EFX_BYPASS_HTC,
	EFX_BYPASS_CTH,
	EFX_BYPASS,
};
#define SGDMA_DIR_WRITE 1
#define SGDMA_DIR_READ 0

int init_cdev(void);
void clean_cdev(void);
int char_close(struct inode *inode, struct file *file);
int char_open(struct inode *inode, struct file *file);
int init_char_device(struct efx_pci_dev *epdev);
void remove_char_device(struct efx_pci_dev *epdev);
void bypass_init(struct edma_cdev *ecdev);
void ctrl_init(struct edma_cdev *ecdev);
void event_init(struct edma_cdev *ecdev);
void sgd_init(struct edma_cdev *ecdev);
int br_mmap(struct file *file, struct vm_area_struct *vma);

#endif /*__EDMA_CDEV_H__*/
