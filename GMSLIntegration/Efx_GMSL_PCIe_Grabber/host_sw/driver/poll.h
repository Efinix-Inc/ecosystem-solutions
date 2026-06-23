#ifndef __EDMA_POLL_H__
#define __EDMA_POLL_H__
#include <linux/version.h>
#include <linux/spinlock.h>
#include <linux/kthread.h>
#include <linux/cpuset.h>
#include <linux/signal.h>

#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/errno.h>

/** lock thread macro */
#define lock_thread(thp) spin_lock(&(thp)->lock)
/** un lock thread macro */
#define unlock_thread(thp) spin_unlock(&(thp)->lock)
#define edma_kthread_wakeup(thp)          \
	do                                     \
	{                                      \
		thp->schedule = 1;                  \
		wake_up_interruptible(&thp->waitq); \
	} while (0)

/**
 * @struct - efx_kthread
 * @brief	Efx thread book keeping parameters
 */
struct efx_kthread
{
	/**  thread lock*/
	spinlock_t lock;
	/**  name of the thread */
	char name[16];
	/**  cpu number for which the thread associated with */
	unsigned short cpu;
	/**  thread id */
	unsigned short id;
	/**  thread sleep timeout value */
	unsigned int timeout;
	/**  flags for thread */
	unsigned long flag;
	/**  thread wait queue */
	wait_queue_head_t waitq;
	/* flag to indicate scheduling of thread */
	unsigned int schedule;
	/**  kernel task structure associated with thread*/
	struct task_struct *task;
	/**  thread work list count */
	unsigned int work_cnt;
	/**  thread work list count */
	struct list_head work_list;
	/**  thread initialization handler */
	int (*finit)(struct efx_kthread *);
	/**  thread pending handler */
	int (*fpending)(struct list_head *);
	/**  thread peocessing handler */
	int (*fproc)(struct list_head *);
	/**  thread done handler */
	int (*fdone)(struct efx_kthread *);
};

void efx_thrdload(struct edma_engine *engine);
void efx_thrd_add(struct edma_engine *engine);
int efx_thrd_create(unsigned int num_threads);
void efx_thrd_dest(void);

#endif /* #ifndef __EDMA_POLL_H__ */
