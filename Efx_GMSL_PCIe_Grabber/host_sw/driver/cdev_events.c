#include <linux/types.h>
#include <asm/cacheflush.h>
#include <linux/slab.h>
#include <linux/aio.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/kthread.h>
#include <linux/version.h>

#include "edma_core.h"
#include "edma_pci.h"
#include "edma_cdev.h"

/*
 * character device file operations for events
 */
static ssize_t char_events_read(struct file *file, char __user *buf,
		size_t count, loff_t *pos)
{
	int ret;
	struct edma_user_irq *user_irq;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;
	uint32_t events_user;
	unsigned long flags;

	user_irq = ecdev->user_irq;
	if (!user_irq) {
		pr_info("ecdev 0x%p, user_irq NULL.\n", ecdev);
		return -EINVAL;
	}

	if (count != 4)
		return -EPROTO;

	if (*pos & 3)
		return -EPROTO;

	/*
	 * sleep until any interrupt events have occurred,
	 * or a signal arrived
	 */
	ret = wait_event_interruptible(user_irq->events_wq, user_irq->events_irq != 0);
	if (ret)
		pr_info("[DBG] wait_event_interruptible=%d\n", ret);

	/* wait_event_interruptible() was interrupted by a signal */
	if (ret == -ERESTARTSYS)
		return -ERESTARTSYS;

	/* atomically decide which events are passed to the user */
	spin_lock_irqsave(&user_irq->events_lock, flags);
	events_user = user_irq->events_irq;
	user_irq->events_irq = 0;
	spin_unlock_irqrestore(&user_irq->events_lock, flags);

	ret = copy_to_user(buf, &events_user, 4);
	if (ret)
		pr_info("[DBG] Copy to user failed but continuing\n");

	return 4;
}

static unsigned int char_events_poll(struct file *file, poll_table *wait)
{
	unsigned long flags;
	unsigned int mask = 0;
	struct edma_user_irq *user_irq;
	struct edma_cdev *ecdev = (struct edma_cdev *)file->private_data;

	user_irq = ecdev->user_irq;
	if (!user_irq) {
		pr_info("xcdev 0x%p, user_irq NULL.\n", ecdev);
		return -EINVAL;
	}

	poll_wait(file, &user_irq->events_wq,  wait);

	spin_lock_irqsave(&user_irq->events_lock, flags);
	if (user_irq->events_irq)
		mask = POLLIN | POLLRDNORM;	/* readable */

	spin_unlock_irqrestore(&user_irq->events_lock, flags);

	return mask;
}

/*
 * character device file operations for the irq events
 */
static const struct file_operations events_fops = {
	.owner = THIS_MODULE,
	.open = char_open,
	.release = char_close,
	.read = char_events_read,
	.poll = char_events_poll,
};

void cdev_event_init(struct edma_cdev *ecdev)
{
	ecdev->user_irq = &(ecdev->epdev->user_irq[ecdev->bar]); 
	cdev_init(&ecdev->cdev, &events_fops);
}

