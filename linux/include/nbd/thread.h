#ifndef HAVE_NBD_THREADS_H
#define HAVE_NBD_THREADS_H

#include <linux/types.h>
#include <linux/mutex.h>
#include <linux/list.h>
#include <linux/kthread.h>  
#include <linux/sched.h>

#include <nbd/dev.h>

#ifdef __KERNEL__

typedef ssize_t thread_id_t;

typedef struct {
	signed int (*init)(void*,size_t);
	signed int (*destroy)(void);
} thread_ops_t;

typedef struct {
	nb_dev_t*		dev;
	void*			data;
	thread_opts_t	ops;
} thread_data_t;

typedef struct {
	thread_id_t			id;
	thread_data_t*		tdata;
	struct task_struct*	task;
} threads_t;

typedef struct {
	struct mutex		lock;
	struct list_head	head;
	threads_t*			threads;
} thread_metadata_t;


signed int nbd_thread_init(void);
signed int nbd_thread_destroy(void);
thread_it_t nbd_thread_start(threads_data_t*);
signed int nbd_thread_del(thread_id_t);


#else 
#error You are trying to include a kernel header in a userspace application!
#endif /* __KERNEL__ */

#endif /* HAVE_NBD_THREADS_H */
