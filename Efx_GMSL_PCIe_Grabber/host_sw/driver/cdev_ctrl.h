#ifndef _EDMA_IOCALLS_POSIX_H_
#define _EEDMA_IOCALLS_POSIX_H_

#include <linux/ioctl.h>

/* Use 'x' as magic number */
#define XDMA_IOC_MAGIC	'x'
/* XL OpenCL X->58(ASCII), L->6C(ASCII), O->0 C->C L->6C(ASCII); */
#define EDMA_XCL_MAGIC 0X3e9C4C8a

/*
 * S means "Set" through a ptr,
 * T means "Tell" directly with the argument value
 * G means "Get": reply by setting through a pointer
 * Q means "Query": response is on the return value
 * X means "eXchange": switch G and S atomically
 * H means "sHift": switch T and Q atomically
 *
 * _IO(type,nr)		    no arguments
 * _IOR(type,nr,datatype)   read data from driver
 * _IOW(type,nr.datatype)   write data to driver
 * _IORW(type,nr,datatype)  read/write data
 *
 * _IOC_DIR(nr)		    returns direction
 * _IOC_TYPE(nr)	    returns magic
 * _IOC_NR(nr)		    returns number
 * _IOC_SIZE(nr)	    returns size
 */
struct edma_performance_ioctl {
	/* IOCTL_XDMA_IOCTL_Vx */
	uint32_t version;
	uint32_t transfer_size;
	/* measurement */
	uint32_t stopped;
	uint32_t iterations;
	uint64_t clock_cycle_count;
	uint64_t data_cycle_count;
	uint64_t pending_count;
};

struct edma_bypass_dma_ioctl {
	uint64_t ep_addr;
	unsigned int aperture;
	unsigned long buffer;
	unsigned long len;
	int error;
	unsigned long done;
};


/* IOCTL codes */

#define IOCTL_EDMA_PERF_START   _IOW('q', 1, struct edma_performance_ioctl *)
#define IOCTL_EDMA_PERF_STOP    _IOW('q', 2, struct edma_performance_ioctl *)
#define IOCTL_EDMA_PERF_GET     _IOR('q', 3, struct edma_performance_ioctl *)
#define IOCTL_EDMA_ADDRMODE_SET _IOW('q', 4, int)
#define IOCTL_EDMA_ADDRMODE_GET _IOR('q', 5, int)
#define IOCTL_EDMA_ALIGN_GET    _IOR('q', 6, int)
#define IOCTL_EDMA_APERTURE_R   _IOW('q', 7, struct edma_bypass_dma_ioctl *)
#define IOCTL_EDMA_APERTURE_W   _IOW('q', 8, struct edma_bypass_dma_ioctl *)


#endif /* _XDMA_IOCALLS_POSIX_H_ */
