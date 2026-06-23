#include <linux/kernel.h>
#include <linux/slab.h>
#include "dma.h"
#include "common.h"
#include "poll.h"

/* ********************* global variables *********************************** */
static struct efx_kthread *cs_threads;
static unsigned int thread_cnt;

static int thrd_statpen(struct list_head *work_item)
{
	int pend = 0;
	unsigned long flags;
	struct edma_engine *engine = list_entry(work_item, struct edma_engine, cmplthp_list);

	spin_lock_irqsave(&engine->lock, flags);
	pend = !list_empty(&engine->transfer_list);
	spin_unlock_irqrestore(&engine->lock, flags);

	return pend;
}

static int thrd_statpro(struct list_head *work_item)
{
	struct edma_engine *engine;
	struct edma_transfer *transfer;

	engine = list_entry(work_item, struct edma_engine, cmplthp_list);
	transfer = list_entry(engine->transfer_list.next, struct edma_transfer, entry);
	if (transfer)
	{
		// pr_info("[T_DBG] process %s engine transfer len=%d\n", engine->name, transfer->len);
		eng_serv_poll(transfer->desc_cmpl_th, engine);
	}
	return 0;
}

static inline int thrd_pen(struct efx_kthread *thp)
{
	struct list_head *work_item, *next;

	/* any work items assigned to this thread? */
	if (list_empty(&thp->work_list))
		return 0;

	/* any work item has pending work to do? */
	list_for_each_safe(work_item, next, &thp->work_list)
	{
		if (thp->fpending && thp->fpending(work_item))
			return 1;
	}
	return 0;
}

static inline void thrd_res(struct efx_kthread *thp)
{
	if (thp->timeout)
	{
		// pr_info("[T_DBG] %s rescheduling for %u seconds", thp->name, thp->timeout);
		wait_event_interruptible_timeout(thp->waitq, thp->schedule,
													msecs_to_jiffies(thp->timeout));
	}
	else
	{
		// pr_info("[T_DBG] %s rescheduling", thp->name);
		wait_event_interruptible(thp->waitq, thp->schedule);
	}
}

static int thrd_main(void *data)
{
	struct efx_kthread *thp = (struct efx_kthread *)data;

	// pr_info("[T-INFO] %s UP.\n", thp->name);

	disallow_signal(SIGPIPE);

	if (thp->finit)
		thp->finit(thp);

	while (!kthread_should_stop())
	{

		struct list_head *work_item, *next;

		// pr_info("[T-INFO] %s interruptible\n", thp->name);
		/* any work to do? */
		// lock_thread(thp);
		if (!thrd_pen(thp))
		{
			// unlock_thread(thp);
			thrd_res(thp);
			// pr_info("[LINC] [T-INFO] %s thread has waken up this thread.\n", thp->name);
			// lock_thread(thp);
		}
		thp->schedule = 0;

		if (thp->work_cnt)
		{
			// pr_info("[T-INFO] %s processing %u work items\n", thp->name, thp->work_cnt);
			/* do work */
			list_for_each_safe(work_item, next, &thp->work_list)
			{
				thp->fproc(work_item);
			}
		}
		// unlock_thread(thp);
		// pr_info("[T-INFO] %s processing %u work items DONE! schedule!\n", thp->name, thp->work_cnt);
		schedule();
	}

	// pr_info("[T-INFO] %s, work done.\n", thp->name);

	if (thp->fdone)
		thp->fdone(thp);

	// pr_info("[T-INFO] %s, exit.\n", thp->name);
	return 0;
}

static int efxrd_init(int id, char *name, struct efx_kthread *thp)
{
	int len, node;

	if (thp->task)
	{
		pr_warn("[WARN] kthread %s task already running?\n", thp->name);
		return -EINVAL;
	}

	len = snprintf(thp->name, sizeof(thp->name), "%s%d", name, id);
	if (len < 0)
	{
		pr_err("[ERROR] thread %d, error in snprintf name %s.\n", id, name);
		return -EINVAL;
	}

	thp->id = id;

	spin_lock_init(&thp->lock);
	INIT_LIST_HEAD(&thp->work_list);
	init_waitqueue_head(&thp->waitq);

	node = cpu_to_node(thp->cpu);
	// pr_info("[DBG] thread node : %d\n", node);

	thp->task = kthread_create_on_node(thrd_main, (void *)thp, node, "%s", thp->name);
	if (IS_ERR(thp->task))
	{
		pr_err("kthread %s, create task failed: 0x%lx\n", thp->name, (unsigned long)IS_ERR(thp->task));
		thp->task = NULL;
		return -EFAULT;
	}

	kthread_bind(thp->task, thp->cpu);

	pr_info("[INFO] kthread 0x%p, %s, cpu %u, task 0x%p.\n", thp, thp->name, thp->cpu, thp->task);

	wake_up_process(thp->task);
	return 0;
}

static int efxrd_done(struct efx_kthread *thp)
{
	int ret;

	if (!thp->task)
	{
		pr_info("[INFO] kthread %s, already stopped.\n", thp->name);
		return 0;
	}

	thp->schedule = 1;
	ret = kthread_stop(thp->task);
	if (ret < 0)
	{
		pr_warn("[WARN] kthread %s, stop err %d.\n", thp->name, ret);
		return ret;
	}

	pr_info("[INFO] kthread %s, 0x%p, stopped.\n", thp->name, thp->task);
	thp->task = NULL;

	return 0;
}

void efx_thrdload(struct edma_engine *engine)
{
	struct efx_kthread *cmpl_thread;
	unsigned long flags;

	spin_lock_irqsave(&engine->lock, flags);
	cmpl_thread = engine->cmplthp;
	engine->cmplthp = NULL;

	//	pr_debug("%s removing from thread %s, %u.\n",
	//		descq->conf.name, cmpl_thread ? cmpl_thread->name : "?",
	//		cpu_idx);

	spin_unlock_irqrestore(&engine->lock, flags);

#if 0
	if (cpu_idx < cpu_count) {
		spin_lock(&qcnt_lock);
		per_cpu_qcnt[cpu_idx]--;
		spin_unlock(&qcnt_lock);
	}
#endif

	if (cmpl_thread)
	{
		lock_thread(cmpl_thread);
		list_del(&engine->cmplthp_list);
		cmpl_thread->work_cnt--;
		unlock_thread(cmpl_thread);
	}
}

void efx_thrd_add(struct edma_engine *engine)
{
	int i, idx = thread_cnt;
	unsigned int val = 0;
	unsigned long flags;
	struct efx_kthread *thp = cs_threads;
	// pr_info("[LINC]>> thread add work for engine%s\n", engine->name);
	/* Polled mode only */
	for (i = 0; i < thread_cnt; i++, thp++)
	{
		lock_thread(thp);
		if (idx == thread_cnt)
		{
			val = thp->work_cnt;
			idx = i;
		}
		else if (!thp->work_cnt)
		{
			idx = i;
			unlock_thread(thp);
			break;
		}
		else if (thp->work_cnt < val)
			idx = i;
		unlock_thread(thp);
	}

	thp = cs_threads + idx;
	lock_thread(thp);
	list_add_tail(&engine->cmplthp_list, &thp->work_list);
	engine->intr_work_cpu = idx;
	thp->work_cnt++;
	unlock_thread(thp);

	// pr_info("[DBG-thread] %s 0x%p assigned to cmpl status thread %s,%u.\n", engine->name, engine, thp->name, thp->work_cnt);

	spin_lock_irqsave(&engine->lock, flags);
	engine->cmplthp = thp;
	spin_unlock_irqrestore(&engine->lock, flags);
}

int efx_thrd_create(unsigned int num_threads)
{
	struct efx_kthread *thp;
	int ret, cpu;

	if (thread_cnt)
	{
		pr_warn("[WARN] threads already created!");
		return 0;
	}

	cs_threads = kzalloc(num_threads * sizeof(struct efx_kthread), GFP_KERNEL);
	if (!cs_threads)
	{
		pr_err("[ERROR] OOM, # threads %u.\n", num_threads);
		return -ENOMEM;
	}

	/* N dma writeback monitoring threads */
	thp = cs_threads;
	for_each_online_cpu(cpu)
	{
		// pr_info("[DBG] index %d cpu %d online\n", thread_cnt, cpu);
		thp->cpu = cpu;
		thp->timeout = 0;
		thp->fproc = thrd_statpro;
		thp->fpending = thrd_statpen;
		ret = efxrd_init(thread_cnt, "cmpl_status_th", thp);
		if (ret < 0)
			goto cleanup_threads;

		thread_cnt++;
		if (thread_cnt == num_threads)
			break;
		thp++;
	}

	return 0;

cleanup_threads:
	kfree(cs_threads);
	cs_threads = NULL;
	thread_cnt = 0;

	return ret;
}

void efx_thrd_dest(void)
{
	int i;
	struct efx_kthread *thp;

	if (!thread_cnt)
		return;

	/* N dma writeback monitoring threads */
	thp = cs_threads;
	for (i = 0; i < thread_cnt; i++, thp++)
		if (thp->fproc)
			efxrd_done(thp);

	kfree(cs_threads);
	cs_threads = NULL;
	thread_cnt = 0;
}
