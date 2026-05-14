/*
 * Edma Device debug method kset and ktype implementation
 *
 */
#include "edma_core.h"
#include "edma_pci.h" 
#include "edma_misc.h" 

static struct kobject *g_misc_sys_kobj = NULL;
void *bypass_buf_vir;
dma_addr_t bypass_buf_dma;

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

static ssize_t reg_show(struct edma_pci_dev *epdev, struct edma_attr *attr,
		      char *buf)
{
	int rc = 0;
	return rc;
}

static ssize_t reg_store(struct edma_pci_dev *epdev, struct edma_attr *attr,
		       const char *buf, size_t count)
{
	char *p, *this_opt;
	unsigned int reg_oft, reg_val;
	void *reg = NULL;

	while ((this_opt = strsep((char **)&buf, ",")) != NULL) {
		if (!(p = strsep(&this_opt, "=")) || !*p)
			return count;
		reg_oft = simple_strtoul(p, NULL, 16);
		if (!(p = strsep(&this_opt, "")) || !*p)
			continue;
		if ('?' == *p) {
			reg = epdev->bar[0] + reg_oft;
			reg_val = ioread32(reg);
			pr_info("SYS rd reg[0x%x] val[0x%x]\n", reg_oft, reg_val);
		} else {
			reg_val = simple_strtoul(p, NULL, 16);
			
			reg = epdev->bar[0] + reg_oft;
			pr_info("SYS wr reg[0x%x] val[0x%x]\n", reg_oft, reg_val);
			iowrite32(reg_val, reg);
		}
	}
	return count;
}

static struct edma_attr reg_attribute =
	__ATTR(reg, 0664, reg_show, reg_store);


struct edma_transfer *dbg_trans;
uint32_t *dbg_poll_mode_addr_virt = NULL;
uint32_t dbg_first_desc_lo_addr = 0;
uint32_t dbg_first_desc_hi_addr = 0;
uint8_t	dbg_first_desc_adj = 0;

dma_addr_t desc_bus_addr;
void* desc_addr;
void dbg_set_desc_bus_info(dma_addr_t bus_addr, void* addr)
{
	desc_bus_addr = bus_addr;
	desc_addr = addr;
}
void dbg_set_desc_info(uint32_t lo_addr, uint32_t hi_addr, uint8_t adj)
{
	dbg_first_desc_lo_addr = lo_addr;
	dbg_first_desc_hi_addr = hi_addr;
	dbg_first_desc_adj = adj;
}
uint64_t trans_jiffs = 0;
uint64_t trans_size;

void dbg_set_trans_jiffies(uint64_t trans_sz, uint64_t jiffs)
{
	trans_jiffs = jiffs;
	trans_size = trans_sz;
}

static ssize_t test_show(struct edma_pci_dev *epdev, struct edma_attr *attr,
			char *buf)
{
	ssize_t rc = 0;
#if 1
	uint64_t msecs;
	double bw = 0.0;
	uint64_t bw_1 = 0;
	if (trans_jiffs && trans_size) {
		msecs = jiffies64_to_msecs(trans_jiffs);
		pr_info("[LINC]>>> trans_size=%lld, trans_jiffs=%lld, msecs=%lld\n", trans_size, trans_jiffs, msecs);
		bw = (double)(trans_size / 1024 / 1024) / msecs;
		bw_1 = ((trans_size*10) / 1024 / 1024) / msecs;
		//pr_info("Current Bandwidth : %.2fGBPS\n", bw);
		rc += sprintf(buf + rc, "Current Bandwidth : %03lldGBPS\n", bw_1);
		rc += sprintf(buf + rc, "Current Bandwidth : %.2fGBPS\n", bw);
		
	} else {
		rc += sprintf(buf + rc, "Current Bandwidth is unknown!\n");
	}
#else
	uint64_t dbg_first_desc_addr;
	void *access;
	uint32_t *desc;
	
	if (dbg_first_desc_lo_addr || dbg_first_desc_hi_addr) {
		dbg_first_desc_addr = dbg_first_desc_hi_addr;
		dbg_first_desc_addr = dbg_first_desc_addr << 32;
		dbg_first_desc_addr |= dbg_first_desc_lo_addr;
		rc += sprintf(buf + rc, "First descriptor dma address=0x%lx(%p), adjacent=%d\n", dbg_first_desc_addr, desc_addr, dbg_first_desc_adj);
		desc = (uint32_t *)desc_addr;
		rc += sprintf(buf + rc, "First descriptor control=0x%x\n", *desc);
		rc += sprintf(buf + rc, "First descriptor len=0x%x\n", *(desc + 1));
		rc += sprintf(buf + rc, "First descriptor src addr=0x%x%x\n", *(desc + 3), *(desc + 2));
		rc += sprintf(buf + rc, "First descriptor dest addr=0x%x%x\n", *(desc + 5), *(desc + 4));
		rc += sprintf(buf + rc, "First descriptor next addr=0x%x%x\n", *(desc + 7), *(desc + 6));
	}
	if (dbg_poll_mode_addr_virt)
		rc += sprintf(buf + rc, "Compl_descriptor_count[23:0]=0x%x\n", *dbg_poll_mode_addr_virt);
#endif
	return rc;
}

/******************************* BYPASS Demo *********************/
#define DESC_BYPASS_CTRL_R		0x40004
#define H2D_DESC_SRC_ADDR_L_R	0x40008
#define H2D_DESC_SRC_ADDR_H_R	0x4000c
#define D2H_DESC_SRC_ADDR_L_R	0x40010
#define D2H_DESC_SRC_ADDR_H_R	0x40014
#define BYPASS_DIR_H2D			0
#define BYPASS_DIR_D2H			1

void misc_bypass_test(struct edma_pci_dev *epdev, int dir)
{
	int timeout = 1000000;
	unsigned int reg_oft, reg_val;
	void *reg = NULL;
	struct edma_poll_wb *wb_data;
	struct edma_engine *engine;

	reg_val = bypass_buf_dma & 0xFFFFFFFF;
	pr_info("BYPASS set address Low32bit=0x%08x\n", reg_val);
	reg = epdev->bar[0] + H2D_DESC_SRC_ADDR_L_R;
	iowrite32(reg_val, reg);
	reg = epdev->bar[0] + D2H_DESC_SRC_ADDR_L_R;
	iowrite32(reg_val, reg);

	reg_val = (bypass_buf_dma >> 32) & 0xFFFFFFFF;
	pr_info("BYPASS set address High32bit=0x%08x\n", reg_val);
	reg = epdev->bar[0] + H2D_DESC_SRC_ADDR_H_R;
	iowrite32(reg_val, reg);
	reg = epdev->bar[0] + D2H_DESC_SRC_ADDR_H_R;
	iowrite32(reg_val, reg);

	reg_val = (uint32_t)EDMA_CTRL_RUN_STOP;
	reg_val |= (uint32_t)EDMA_CTRL_POLL_MODE_WB;
	pr_info("BYPASS set engine config val=0x%x\n", reg_val);
	// enable poll mode and enable run bit
	if (dir == BYPASS_DIR_H2D) {
		engine = &epdev->engine_h2d[0];
		wb_data = (struct edma_poll_wb *)engine->poll_mode_addr_virt;
		wb_data->completed_desc_count = 0;
	
		reg = epdev->bar[0] + 0x04;
		iowrite32(reg_val, reg); // enable H2D running bit & poll mode
		reg_val = 0;
		reg = epdev->bar[0] + DESC_BYPASS_CTRL_R;
		iowrite32(reg_val, reg);

		reg_val = 1;
		reg = epdev->bar[0] + DESC_BYPASS_CTRL_R;
		iowrite32(reg_val, reg);
	} else { //BYPASS_DIR_D2H
		engine = &epdev->engine_d2h[0];
		wb_data = (struct edma_poll_wb *)engine->poll_mode_addr_virt;
		wb_data->completed_desc_count = 0;

		reg = epdev->bar[0] + 0x1004;
		iowrite32(reg_val, reg); // enable H2D running bit & poll mode

		reg_val = 0;
		reg = epdev->bar[0] + DESC_BYPASS_CTRL_R;
		iowrite32(reg_val, reg);

		reg_val = 2;
		reg = epdev->bar[0] + DESC_BYPASS_CTRL_R;
		iowrite32(reg_val, reg);
	}

	// wait for polling done
	do {
		timeout--;
	} while (!wb_data->completed_desc_count && timeout);
	pr_info("BYPASS %s test done! wb count=%d\n", dir ? "D2H" : "H2D", wb_data->completed_desc_count);
	//reg_val = ioread32(reg);
	return;
}

/******************************* BYPASS Demo *********************/

static ssize_t test_store(struct edma_pci_dev *epdev, struct edma_attr *attr,
			 const char *buf, size_t count)
{
	if ('1' == *buf) {
		pr_info("Begining to wake up transfer waiting queue.\n");
		if (dbg_trans) {
			dbg_trans->state = TRANSFER_STATE_COMPLETED;
			dma_wake_up(&dbg_trans->wq);
			dbg_trans = NULL;
		}
	} else if (!strncmp(buf, "h2d", 3)) {
		misc_bypass_test(epdev, BYPASS_DIR_H2D);
	} else if (!strncmp(buf, "d2h", 3)) {
		misc_bypass_test(epdev, BYPASS_DIR_D2H);
	}
	return count;
}

/* Sysfs attributes cannot be world-writable. */
static struct edma_attr test_attribute =
	__ATTR(test, 0664, test_show, test_store);

static ssize_t bypass_show(struct edma_pci_dev *epdev, struct edma_attr *attr,
			char *buf)
{
	ssize_t rc = 0;
	uint8_t *print_buf;
	int i;
	rc += sprintf(buf + rc, "32KB DMA address: 0x%llx\n", bypass_buf_dma);
	if (bypass_buf_vir) {
		print_buf = (uint8_t *)bypass_buf_vir;
		//rc += sprintf(buf + rc, "32KB DMA data:{0x%02x, 0x%02x, 0x%02x, 0x%02x}\n", 
		//		print_buf[0], print_buf[1], print_buf[2], print_buf[3]);
		rc += sprintf(buf + rc, "32KB DMA data:\n");
		for (i = 0; i < 128; i++) {
			rc += sprintf(buf + rc, "%02x ", print_buf[i]);
			if ((i + 1) % 8 == 0)
				rc += sprintf(buf + rc, "\n ");
		}
		rc += sprintf(buf + rc, "]\n");
	}
	return rc;
}

static ssize_t bypass_store(struct edma_pci_dev *epdev, struct edma_attr *attr,
			 const char *buf, size_t count)
{
	uint32_t test_data;
	if (bypass_buf_vir && bypass_buf_dma) {
		int i;
		uint8_t *cpy = (uint8_t*) bypass_buf_vir;
		test_data = simple_strtoul(buf, NULL, 16);
		//pr_info("[BYPASS] test_data=0x%x\n", test_data);
		for (i = 0; i < (32*1024); i++)
			cpy[i] = (test_data + i) & 0xFF;
	}
	return count;
}

/* Sysfs attributes cannot be world-writable. */
static struct edma_attr bypass_attribute =
	__ATTR(bypass, 0664, bypass_show, bypass_store);


static ssize_t msix_show(struct edma_pci_dev *epdev, struct edma_attr *attr,
		      char *buf)
{
	int i, rc = 0;
	unsigned int reg_oft;
	void *reg = NULL;

	reg = epdev->bar[0] + 0x8000;

	for (i = 0; i < 32; i++) {
		reg_oft = i * 0x10;
		rc += sprintf(buf + rc, "MSI-X vector[%d] addr=0x%08x %08x, data=0x%08x, control=0x%08x\n", i, 
					ioread32(reg + reg_oft + 0x04), ioread32(reg + reg_oft),
					ioread32(reg + reg_oft + 0x08), ioread32(reg + reg_oft + 0x0C));

	}
	if (i == 0)
		rc += sprintf(buf + rc, "There is no MSI-X vectors!\n");
	return rc;
}

static ssize_t msix_store(struct edma_pci_dev *epdev, struct edma_attr *attr,
		       const char *buf, size_t count)
{
	unsigned int reg_oft;
	void *reg = NULL;
	reg = epdev->bar[0] + 0x8000;
	if ('0' == *buf) {
		int i;
		for (i = 0; i < 32; i++) {
			reg_oft = i * 0x10;
			iowrite32(0, reg + reg_oft);
			iowrite32(0, reg + reg_oft + 0x04);
			iowrite32(0, reg + reg_oft + 0x08);
			iowrite32(0, reg + reg_oft + 0x0C);
		}		
	} else {
		uint32_t msi_addr = 0;
		// H2D msi-x configuration
        pci_read_config_dword(epdev->pdev, 0x94, &msi_addr);
		iowrite32(msi_addr, reg + reg_oft);
		pci_read_config_dword(epdev->pdev, 0x98, &msi_addr);
		iowrite32(msi_addr, reg + reg_oft + 0x04);
		iowrite32(0, reg + reg_oft + 0x08);
		iowrite32(0, reg + reg_oft + 0x0C);
		// D2H msi-x configuration
        pci_read_config_dword(epdev->pdev, 0x94, &msi_addr);
		iowrite32(msi_addr, reg + reg_oft + 0x10);
		pci_read_config_dword(epdev->pdev, 0x98, &msi_addr);
		iowrite32(msi_addr, reg + reg_oft + 0x14);
		iowrite32(1, reg + reg_oft + 0x18);
		iowrite32(0, reg + reg_oft + 0x1C);
		pr_info("Configuration for MSI done!\n");
	}
	return count;
}

/* Sysfs attributes cannot be world-writable. */
static struct edma_attr msix_attribute =
	__ATTR(msix, 0664, msix_show, msix_store);

/*
 * The default show function that must be passed to sysfs.  This will be
 * called by sysfs for whenever a show function is called by the user on a
 * sysfs file associated with the kobjects we have registered.  We need to
 * transpose back from a "default" kobject to our custom struct foo_obj and
 * then call the show function for that specific object.
 */
static ssize_t misc_attr_show(struct kobject *kobj,
			     struct attribute *attr,
			     char *buf)
{
	struct edma_attr *eattr;
	struct edma_pci_dev *epdev;

	eattr = TO_EDMA_ATTR(attr);
	epdev = TO_EDMA_PDEV(kobj);

	if (!eattr->show)
		return -EIO;

	return eattr->show(epdev, eattr, buf);
}

/*
 * Just like the default show function above, but this one is for when the
 * sysfs "store" is requested (when a value is written to a file.)
 */
static ssize_t misc_attr_store(struct kobject *kobj,
			      struct attribute *attr,
			      const char *buf, size_t len)
{
	struct edma_attr *eattr;
	struct edma_pci_dev *epdev;

	eattr = TO_EDMA_ATTR(attr);
	epdev = TO_EDMA_PDEV(kobj);

	if (!eattr->store)
		return -EIO;

	return eattr->store(epdev, eattr, buf, len);
}

/* Our custom sysfs_ops that we will associate with our ktype later on */
static const struct sysfs_ops misc_sysfs_ops = {
	.show = misc_attr_show,
	.store = misc_attr_store,
};

/*
 * The release function for our object.  This is REQUIRED by the kernel to
 * have.  We free the memory held in our object here.
 *
 * NEVER try to get away with just a "blank" release function to try to be
 * smarter than the kernel.  Turns out, no one ever is...
 */
static void misc_release(struct kobject *kobj)
{
	return;
}

/*
 * Create a group of attributes so that we can create and destroy them all
 * at once.
 */
static struct attribute *misc_default_attrs[] = {
	&reg_attribute.attr,
	&test_attribute.attr,
	&bypass_attribute.attr,
	&msix_attribute.attr,
	NULL,	/* need to NULL terminate the list of attributes */
};
#if KERNEL_VERSION(5, 6, 0) <= LINUX_VERSION_CODE
ATTRIBUTE_GROUPS(misc_default);
#endif

/*
 * Our own ktype for our kobjects.  Here we specify our sysfs ops, the
 * release function, and the set of default attributes we want created
 * whenever a kobject of this type is registered with the kernel.
 */
static struct kobj_type misc_ktype = {
	.sysfs_ops = &misc_sysfs_ops,
	.release = misc_release,
#if KERNEL_VERSION(5, 6, 0) <= LINUX_VERSION_CODE
	.default_groups = misc_default_groups,
#else
	.default_attrs = misc_default_attrs,
#endif
};

int misc_kobj_init(struct edma_pci_dev *epdev, const char *name)
{
	int ret;

	if (!epdev || !g_misc_sys_kobj)
		return -ENODEV;
	/*
	 * Initialize and add the kobject to the kernel.  All the default files
	 * will be created here.  As we have already specified a kset for this
	 * kobject, we don't have to set a parent for the kobject, the kobject
	 * will be placed beneath that kset automatically.
	 */
	ret = kobject_init_and_add(&epdev->kobj, &misc_ktype, g_misc_sys_kobj, "%s-%d", name, epdev->major);
	if (ret) {
		kobject_put(&epdev->kobj);
		return -EINVAL;
	}

	/*
	 * We are always responsible for sending the uevent that the kobject
	 * was added to the system.
	 */

	kobject_uevent(&epdev->kobj, KOBJ_ADD);
	
	bypass_buf_vir = dma_alloc_coherent(&epdev->pdev->dev, 32*1024, &bypass_buf_dma, GFP_KERNEL);
	if (!bypass_buf_vir)
		pr_err("[ERROR] Can not allocate DMA 32KB buffer.\n");
	return 0;
}

void misc_kobj_evict(struct edma_pci_dev *epdev)
{
	dma_free_coherent(&epdev->pdev->dev, 32*1024, bypass_buf_vir, bypass_buf_dma);
	kobject_del(&epdev->kobj);
}

void misc_sysfs_register(void)
{
	g_misc_sys_kobj = kobject_create_and_add("edma", NULL);
}

void misc_sysfs_destroy(void)
{
	kobject_del(g_misc_sys_kobj);
}


