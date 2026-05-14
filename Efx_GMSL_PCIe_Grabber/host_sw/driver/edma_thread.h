#ifndef __EDMA_KTHREAD_H__
#define __EDMA_KTHREAD_H__
#include <linux/version.h>
#include <linux/spinlock.h>
#include <linux/kthread.h>
#include <linux/cpuset.h>
#include <linux/signal.h>

#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include "edma_core.h"

/** lock thread macro */
#define lock_thread(thp)		spin_lock(&(thp)->lock)
/** un lock thread macro */
#define unlock_thread(thp)		spin_unlock(&(thp)->lock)
#define edma_kthread_wakeup(thp) \
	do { \
		thp->schedule = 1; \
		wake_up_interruptible(&thp->waitq); \
	} while (0)

/**
 * @struct - edma_kthread
 * @brief	Edma thread book keeping parameters
 */
struct edma_kthread {
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
	int (*finit)(struct edma_kthread *);
	/**  thread pending handler */
	int (*fpending)(struct list_head *);
	/**  thread peocessing handler */
	int (*fproc)(struct list_head *);
	/**  thread done handler */
	int (*fdone)(struct edma_kthread *);
};

void edma_thread_remove_work(struct edma_engine *engine);
void edma_thread_add_work(struct edma_engine *engine);
int edma_threads_create(unsigned int num_threads);
void edma_threads_destroy(void);

#endif /* #ifndef __EDMA_KTHREAD_H__ */
