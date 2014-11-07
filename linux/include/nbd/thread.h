#ifndef HAVE_NBD_THREADS_H
#define HAVE_NBD_THREADS_H

#include <linux/types.h>
#include <linux/mutex.h>
#include <linux/list.h>
#include <linux/kthread.h>  
#include <linux/sched.h>

#include <nbd/global.h>
#include <nbd/dev.h>

#ifdef __KERNEL__

typedef struct {
	signed int (*init)(void*);
	signed int (*destroy)(void*);
} thread_ops_t;

typedef struct {
	char*			name;
	void*			data;
	thread_ops_t	ops;
} thread_data_t;

typedef struct {
	thread_id_t			id;
	thread_data_t*		tdata;
	struct task_struct*	task;
	struct list_head	list;
} threads_t;

typedef struct {
	struct mutex		lock;
	struct list_head	head;
	threads_t*			threads;
	atomic_t			tids;
} thread_metadata_t;


signed int nbd_thread_init(void);
signed int nbd_thread_destroy(void);
thread_id_t nbd_thread_start(thread_data_t*);
signed int nbd_thread_del(thread_id_t);


#else 
#error You are trying to include a kernel header in a userspace application!
#endif /* __KERNEL__ */

#endif /* HAVE_NBD_THREADS_H */
