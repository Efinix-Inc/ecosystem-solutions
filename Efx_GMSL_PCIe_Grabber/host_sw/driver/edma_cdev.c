#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"

static struct class *g_edma_class = NULL;
struct kmem_cache *cdev_cache;

enum cdev_type {
	CHAR_USER,
	CHAR_CTRL,
	CHAR_EVENTS,
	CHAR_DMA_H2D,
	CHAR_DMA_D2H,
	CHAR_BYPASS_H2D,
	CHAR_BYPASS_D2H,
	CHAR_BYPASS,
};

static const char * const devnode_names[] = {
	EDMA_NODE_NAME "%d_user",
	EDMA_NODE_NAME "%d_control",
	EDMA_NODE_NAME "%d_events_%d",
	EDMA_NODE_NAME "%d_h2d_%d",
	EDMA_NODE_NAME "%d_d2h_%d",
	EDMA_NODE_NAME "%d_bypass_h2d_%d",
	EDMA_NODE_NAME "%d_bypass_d2h_%d",
	EDMA_NODE_NAME "%d_bypass",
};

static inline void edma_flag_set(struct edma_pci_dev *epdev, enum cdev_type fbit)
{
	epdev->flags |= 1 << fbit;
}

static inline void edma_flag_clear(struct edma_pci_dev *epdev, enum cdev_type fbit)
{
	epdev->flags &= ~(1 << fbit);
}

static inline int edma_flag_test(struct edma_pci_dev *epdev, enum cdev_type fbit)
{
	return epdev->flags & (1 << fbit);
}

static int config_kobject(struct edma_cdev *ecdev, enum cdev_type type)
{
	int ret = -EINVAL;
	struct edma_engine *engine = ecdev->engine;

	switch (type) {
	case CHAR_DMA_H2D:
	case CHAR_DMA_D2H:
	case CHAR_BYPASS_H2D:
	case CHAR_BYPASS_D2H:
		if (!engine) {
			pr_err("[ERROR] Invalid DMA engine\n");
			return ret;
		}
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type], 
								ecdev->epdev->idx, engine->channel);
		break;
	case CHAR_BYPASS:
	case CHAR_USER:
	case CHAR_CTRL:
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type],
								ecdev->epdev->idx);
		break;
	case CHAR_EVENTS:
		ret = kobject_set_name(&ecdev->cdev.kobj, devnode_names[type],
								ecdev->epdev->idx, ecdev->bar);
		break;
	default:
		pr_warn("%s: UNKNOWN type 0x%x.\n", __func__, type);
		break;
	}
	if (ret)
		pr_err("%s: type 0x%x, failed %d.\n", __func__, type, ret);
	return ret;
}

static int create_sys_device(struct edma_cdev *ecdev, enum cdev_type type)
{
	struct edma_engine *engine = ecdev->engine;
	int last_param;

	if (type == CHAR_EVENTS)
		last_param = ecdev->bar;
	else
		last_param = engine ? engine->channel : 0;

	ecdev->sys_device = device_create(g_edma_class, &ecdev->epdev->pdev->dev,
		ecdev->cdevno, NULL, devnode_names[type], ecdev->epdev->idx,
		last_param);

	if (!ecdev->sys_device) {
		pr_err("[ERROR] device_create(%s) failed\n", devnode_names[type]);
		return -1;
	}

	return 0;
}

static int destroy_ecdev(struct edma_cdev *ecdev)
{
	pr_info("[LINC]>>%s>> Enter\n", __FUNCTION__);
	if (!ecdev) {
		pr_warn("[ERROR] cdev NULL.\n");
		return -EINVAL;
	}

	if (!ecdev->epdev) {
		pr_err("[ERROR] edma pcie dev NULL\n");
		return -EINVAL;
	}
#if 1
	if (!g_edma_class) {
		pr_err("[ERROR] g_edma_class NULL\n");
		return -EINVAL;
	}

	if (!ecdev->sys_device) {
		pr_err("[ERROR] cdev sys_device NULL\n");
		return -EINVAL;
	}

	if (ecdev->sys_device)
		device_destroy(g_edma_class, ecdev->cdevno);
#endif
	cdev_del(&ecdev->cdev);

	return 0;
}


static int create_ecdev(struct edma_pci_dev *epdev, struct edma_cdev *ecdev,
			int bar, struct edma_engine *engine,
			enum cdev_type type)
{
	int ret;
	int minor;
	dev_t dev;

	spin_lock_init(&ecdev->lock);
	/* new instance? */
	if (!epdev->major) {
		/* allocate a dynamically allocated char device node */
		ret = alloc_chrdev_region(&dev, EDMA_MINOR_BASE, EDMA_MINOR_COUNT, EDMA_NODE_NAME);
		if (ret) {
			pr_err("[ERROR] unable to allocate cdev region %d.\n", ret);
			return ret;
		}
		epdev->major = MAJOR(dev);
	}
	/*
	 * do not register yet, create kobjects and name them,
	 */
	ecdev->magic = MAGIC_CHAR;
	ecdev->cdev.owner = THIS_MODULE;
	ecdev->epdev = epdev;
	ecdev->engine = engine;
	ecdev->bar = bar;

	ret = config_kobject(ecdev, type);
	if (ret < 0)
		return ret;

	switch (type) {
		case CHAR_USER:
		case CHAR_CTRL:
			/* minor number is type index for non-SGDMA interfaces */
			minor = type;
			cdev_ctrl_init(ecdev);
			break;
		case CHAR_DMA_H2D:
			minor = 32 + engine->channel;
			cdev_sgdma_init(ecdev);
			break;
		case CHAR_DMA_D2H:
			minor = 36 + engine->channel;
			cdev_sgdma_init(ecdev);
			break;
		case CHAR_EVENTS:
			minor = 10 + bar;
			cdev_event_init(ecdev);
			break;
		case CHAR_BYPASS_H2D:
			minor = 64 + engine->channel;
			cdev_bypass_init(ecdev);
			break;
		case CHAR_BYPASS_D2H:
			minor = 68 + engine->channel;
			cdev_bypass_init(ecdev);
			break;
		case CHAR_BYPASS:
			minor = 100;
			cdev_bypass_init(ecdev);
			break;
			default:
			pr_info("type 0x%x NOT supported.\n", type);
			return -EINVAL;
	}
	ecdev->cdevno = MKDEV(epdev->major, minor);

	/* bring character device live */
	ret = cdev_add(&ecdev->cdev, ecdev->cdevno, 1);
	if (ret < 0) {
		pr_err("[ERROR] cdev_add failed %d, type 0x%x.\n", ret, type);
		goto unregister_region;
	}

	pr_info("[DBG] ecdev 0x%p, %u:%u, %s, type 0x%x.\n", ecdev, epdev->major, minor, ecdev->cdev.kobj.name, type);
	/* create device on our class */
	if (g_edma_class) {
		ret = create_sys_device(ecdev, type);
		if (ret < 0)
			goto del_cdev;
	}
	return 0;

del_cdev:
	cdev_del(&ecdev->cdev);
unregister_region:
	unregister_chrdev_region(ecdev->cdevno, EDMA_MINOR_COUNT);
	return ret;
}


int edma_cdev_init(void)
{
#if KERNEL_VERSION(6, 4, 0) <= LINUX_VERSION_CODE
	g_edma_class = class_create("pcie_dma");
#else
	g_edma_class = class_create(THIS_MODULE, "pcie_dma");
#endif	
	if (IS_ERR(g_edma_class)) {
		pr_err("[ERROR] failed to create EDMA class.");
		return -EINVAL;
	}
#if 0
	/* using kmem_cache_create to enable sequential cleanup */
	cdev_cache = kmem_cache_create("cdev_cache", 
									sizeof(struct cdev_async_io), 0,
									SLAB_HWCACHE_ALIGN, NULL);

	if (!cdev_cache) {
		pr_err("[ERROR] memory allocation for cdev_cache failed. OOM\n");
		return -ENOMEM;
	}
#else
	cdev_cache = NULL;
#endif
	return 0;
}

void edma_cdev_cleanup(void)
{
	if (cdev_cache)
		kmem_cache_destroy(cdev_cache);
	if (g_edma_class)
		class_destroy(g_edma_class);
}

/*
 * Called when the device goes from used to unused.
 */
int char_close(struct inode *inode, struct file *file)
{
	struct edma_pci_dev *epdev;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	if (!ecdev) {
		pr_err("[ERROR] char device with inode 0x%lx ecdev NULL\n", inode->i_ino);
		return -EINVAL;
	}

	/* fetch device specific data stored earlier during open */
	epdev = ecdev->epdev;
	if (!epdev) {
		pr_err("[ERROR] char device with inode 0x%lx edma pcie device NULL\n", inode->i_ino);
		return -EINVAL;
	}
	
	return 0;
}


int char_open(struct inode *inode, struct file *file)
{
	struct edma_cdev *ecdev;

	/* pointer to containing structure of the character device inode */
	ecdev = container_of(inode->i_cdev, struct edma_cdev, cdev);
	if (ecdev->magic != MAGIC_CHAR) {
		pr_err("ecdev 0x%p inode 0x%lx magic mismatch 0x%lx\n", ecdev, inode->i_ino, ecdev->magic);
		return -EINVAL;
	}
	/* create a reference to our char device in the opened file */
	file->private_data = ecdev;

	return 0;
}

void epdev_destroy_interfaces(struct edma_pci_dev *epdev)
{
	int i = 0;
	int ret;
	/* iterate over channels */
	for (i = 0; i < epdev->h2d_channel_max; i++) {
		/* remove SG DMA character device */
		ret = destroy_ecdev(&epdev->sgdma_h2d_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy h2d ecdev %d error :0x%x\n", i, ret);
	}

	for (i = 0; i < epdev->d2h_channel_max; i++) {
		ret = destroy_ecdev(&epdev->sgdma_d2h_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy d2h ecdev %d error 0x%x\n", i, ret);
	}
	/* remove control character device */
	ret = destroy_ecdev(&epdev->ctrl_cdev);
	if (ret < 0)
		pr_err("[ERROR] Failed to destroy cdev ctrl event %d error 0x%x\n", i, ret);

	if (epdev->user_bar_idx >= 0) {
		ret = destroy_ecdev(&epdev->user_cdev);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy user cdev %d error 0x%x\n", i, ret);
	}
	
	if (epdev->bypass_bar_idx > 0) {
		/* iterate over channels */
		for (i = 0; i < epdev->h2d_channel_max; i++) {
			/* remove DMA Bypass character device */
			ret = destroy_ecdev(&epdev->bypass_h2d_cdev[i]);
			if (ret < 0)
				pr_err("[ERROR] Failed to destroy bypass h2d cdev %d error 0x%x\n",	i, ret);
		}
		for (i = 0; i < epdev->d2h_channel_max; i++) {
			ret = destroy_ecdev(&epdev->bypass_d2h_cdev[i]);
			if (ret < 0)
				pr_err("[ERROR] Failed to destroy bypass d2h %d error 0x%x\n", i, ret);
		}
		ret = destroy_ecdev(&epdev->bypass_cdev_base);
		if (ret < 0)
			pr_err("Failed to destroy base cdev\n");
	}

	for (i = 0; i < epdev->user_max; i++) {
		ret = destroy_ecdev(&epdev->events_cdev[i]);
		if (ret < 0)
			pr_err("[ERROR] Failed to destroy cdev event %d error 0x%x\n", i, ret);
	}
	if (epdev->major)
		unregister_chrdev_region(MKDEV(epdev->major, EDMA_MINOR_BASE), EDMA_MINOR_COUNT);
	return;
}

int epdev_create_interfaces(struct edma_pci_dev *epdev)
{
	int i = 0;
	int ret = 0;
	struct edma_engine *engine;

	/* initialize control character device */
	ret = create_ecdev(epdev, &epdev->ctrl_cdev, epdev->config_bar_idx, NULL, CHAR_CTRL);
	if (ret < 0) {
		pr_err("create_char(ctrl_cdev) failed\n");
		goto fail;
	}
	edma_flag_set(epdev, CHAR_CTRL);

	/* iterate over channels */
	for (i = 0; i < epdev->h2d_channel_max; i++) {
		engine = &epdev->engine_h2d[i];
		ret = create_ecdev(epdev, &epdev->sgdma_h2d_cdev[i], i, engine, CHAR_DMA_H2D);
		if (ret < 0) {
			pr_err("[ERROR] create char h2d %d failed, %d.\n", i, ret);
			goto fail;
		}
	}

	for (i = 0; i < epdev->d2h_channel_max; i++) {
		engine = &epdev->engine_d2h[i];
		ret = create_ecdev(epdev, &epdev->sgdma_d2h_cdev[i], i, engine, CHAR_DMA_D2H);
		if (ret < 0) {
			pr_err("[ERROR] create char d2h %d failed, %d.\n", i, ret);
			goto fail;
		}
	}
	
	/* initialize events character device */
	for (i = 0; i < epdev->user_max; i++) {
		ret = create_ecdev(epdev, &epdev->events_cdev[i], i, NULL,
			CHAR_EVENTS);
		if (ret < 0) {
			pr_err("[ERROR] create char event %d failed, %d.\n", i, ret);
			goto fail;
		}
	}
	/* initialize user character device */
	if (epdev->user_bar_idx >= 0) {
		ret = create_ecdev(epdev, &epdev->user_cdev, epdev->user_bar_idx, NULL, CHAR_USER);
		if (ret < 0) {
			pr_err("[ERROR] create_char(user_cdev) failed\n");
			goto fail;
		}
	}
	
	/* Initialize Bypass Character Device */
	if (epdev->bypass_bar_idx > 0) {
		for (i = 0; i < epdev->h2d_channel_max; i++) {
			engine = &epdev->engine_h2d[i];
			ret = create_ecdev(epdev, &epdev->bypass_h2d_cdev[i], i, engine, CHAR_BYPASS_H2D);
			if (ret < 0) {
				pr_err("[ERROR] create h2d %d bypass I/F failed, %d.\n", i, ret);
				goto fail;
			}
		}

		for (i = 0; i < epdev->d2h_channel_max; i++) {
			engine = &epdev->engine_d2h[i];
			ret = create_ecdev(epdev, &epdev->bypass_d2h_cdev[i], i, engine, CHAR_BYPASS_D2H);
			if (ret < 0) {
				pr_err("[ERROR] create d2h %d bypass I/F failed, %d.\n", i, ret);
				goto fail;
			}
		}

		ret = create_ecdev(epdev, &epdev->bypass_cdev_base, epdev->bypass_bar_idx, NULL, CHAR_BYPASS);
		if (ret < 0) {
			pr_err("[ERROR] create bypass failed %d.\n", ret);
			goto fail;
		}
		edma_flag_set(epdev, CHAR_BYPASS);
	}
		
	return 0;

fail:
	ret = -1;
	epdev_destroy_interfaces(epdev);
	return ret;

}
