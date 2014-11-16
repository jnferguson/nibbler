
#include <nbd/global.h>
#include <nbd/thread.h>

#include <linux/preempt.h>

static thread_metadata_t m_data;

static void
thread_destroy(threads_t* t)
{
	signed int ret = 0;

	DBG("entered");

	if (NULL == t) {
		DBG("exited (void)");
		return;
	}

	if (NULL != t->tdata && NULL != t->tdata->data && NULL != t->tdata->ops.destroy)
		t->tdata->ops.destroy(t->tdata->data);

	if (NULL != t->task) {
		ret = kthread_stop(t->task);

		DBG("Thread %x returned %d", t->id, ret);
	}

	FRE("threads_t->tdata pointer %p", t->tdata);
	kfree(t->tdata);
	t->tdata = NULL;

	FRE("threads_t pointer %p", t);
	kfree(t);
	t = NULL;

	DBG("exited (void)");
	return;
}

signed int
nbd_thread_init(void)
{

	DBG("entered");

	mutex_init(&m_data.lock);
	INIT_LIST_HEAD(&m_data.head);
	
	mutex_lock(&m_data.lock);

	m_data.threads = NULL;
	atomic_set(&m_data.tids, 0);

	mutex_unlock(&m_data.lock);
	
	DBG("exited 0");
	return 0;
}

signed int 
nbd_thread_destroy(void)
{
	threads_t*	cur 	= NULL;
	threads_t*	next	= NULL;

	DBG("entered");

	mutex_lock(&m_data.lock);
	list_for_each_entry_safe(cur, next, &m_data.head, list) {
		list_del(&cur->list);
		thread_destroy(cur);
	}

	mutex_unlock(&m_data.lock);
	mutex_destroy(&m_data.lock);

	DBG("exited 0");
	return 0;
}

thread_id_t
nbd_thread_start(thread_data_t* td)
{
	threads_t* 	nt 	= NULL;
	thread_id_t	id	= 0;
	signed int	ret = 0;

	DBG("entered");	

	if (NULL == td) {
		DBG("exited -EINVAL");
		return -EINVAL;
	}

	nt = kzalloc(sizeof(threads_t), GFP_KERNEL);

	if (NULL == nt) {
		DBG("exited -ENOMEM");
		return -ENOMEM;
	}

	ALO("nt %p %u bytes", nt, sizeof(threads_t));

	nt->tdata = kzalloc(sizeof(thread_data_t), GFP_KERNEL);

	if (NULL == nt->tdata) {
		kfree(nt);
		DBG("exited -ENOMEM");
		return -ENOMEM;
	}

	ALO("nt->tdata: %p %u bytes", nt->tdata, sizeof(thread_data_t));

	nt->tdata->data			= td->data;
	nt->tdata->ops.init		= td->ops.init;
	nt->tdata->ops.destroy	= td->ops.destroy;
	nt->tdata->name			= td->name;

	nt->task = kthread_create(nt->tdata->ops.init, nt->tdata->data, nt->tdata->name, atomic_read(&m_data.tids));

	if (! IS_ERR(nt->task)) 
		wake_up_process(nt->task);
	else {
		ret = PTR_ERR(nt->task);
		ERR("Error starting kernel thread: %d", ret); 
		
		nt->task = NULL;
		thread_destroy(nt);	

		DBG("exited %d", ret);
		return ret;
	}

	mutex_lock(&m_data.lock);
	id = atomic_add_return(1, &m_data.tids);
	list_add_tail(&nt->list, &m_data.head);
	mutex_unlock(&m_data.lock);

	DBG("exited TID: %d", id);
	return id;
}

signed int
nbd_thread_del(thread_id_t id)
{
	threads_t*  cur		= NULL;
	threads_t*  next	= NULL;

	DBG("entered");

	mutex_lock(&m_data.lock);
	list_for_each_entry_safe(cur, next, &m_data.head, list) {
		if (cur->id == id) {
			list_del(&cur->list);
			thread_destroy(cur);
			atomic_dec(&m_data.tids);
			break;
		}
	}

	mutex_unlock(&m_data.lock);
	DBG("exited 0");
	return 0;
}
