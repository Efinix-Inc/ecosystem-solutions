#ifndef __EDMA_CDEV_H__
#define __EDMA_CDEV_H__
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/errno.h>

#define EDMA_NODE_NAME		"pcie_dma"
#define EDMA_MINOR_BASE 	(0)
#define EDMA_MINOR_COUNT 	(255)

int edma_create_cdev(struct edma_pci_dev *epdev);
void edma_destory_cdev(struct edma_pci_dev *epdev);
int edma_cdev_init(void);
void edma_cdev_cleanup(void);
int char_close(struct inode *inode, struct file *file);
int char_open(struct inode *inode, struct file *file);
int epdev_create_interfaces(struct edma_pci_dev *epdev);
void epdev_destroy_interfaces(struct edma_pci_dev *epdev);
void cdev_bypass_init(struct edma_cdev *ecdev);
void cdev_ctrl_init(struct edma_cdev *ecdev);
void cdev_event_init(struct edma_cdev *ecdev);
void cdev_sgdma_init(struct edma_cdev *ecdev);

int bridge_mmap(struct file *file, struct vm_area_struct *vma);

#endif /*__EDMA_CDEV_H__*/
