#include <nbd/global.h>
#include <nbd/char.h>
#include <nbd/dev.h>
#include <nbd/ioctl.h>
#include <nbd/net.h>

static signed int check_device(struct inode*);
static signed int check_device_file(struct file*);
static signed int char_open(struct inode*, struct file*);
static signed int char_close(struct inode*, struct file*);
static signed long char_ioctl(struct file *, unsigned int, unsigned long);
static void char_destroy(nb_dev_t*, signed int);
static signed int char_create(nb_dev_t*, signed int);
static signed int char_data_init(nb_dev_t*, ip_network_t*);
static signed int char_mmap(struct file *, struct vm_area_struct*);
static signed int char_vmem(nb_dev_t*, struct vm_area_struct*);

static struct file_operations nb_ops =
{
	.owner			= THIS_MODULE,
	.open			= char_open,
	.release		= char_close,
	.poll			= NULL,
	.compat_ioctl	= NULL,
	.unlocked_ioctl	= char_ioctl,
	.mmap			= char_mmap
};

static char_metadata_t  m_data	  = {NULL, 0, NULL, {{0}}};

extern global_data_t	g_vars;

static signed int
check_device_file(struct file* f)
{
	DBG("entered");

	BUG_ON(NULL == f || NULL == f->f_dentry);

	DBG("exiting tail call");
	return check_device(f->f_dentry->d_inode);
}

static signed int
check_device(struct inode* i)
{
	unsigned int maj = imajor(i);
	unsigned int min = iminor(i);

	DBG("entered");

	BUG_ON(NULL == i);

	if (maj != m_data.major || min >= g_vars.device_count) {
		ERR("No device found with major=%u and minor=%u", maj, min);
		DBG("exiting -ENODEV");
		return -ENODEV;
	}

	if (i->i_cdev != m_data.devices[min].cdev) {
		ERR("Internal error, inode cdev != devices[x].cdev");
		DBG("exiting -ENODEV");
		return  -ENODEV;
	}

	DBG("exiting 0");
	return 0;
}

static signed int
char_open(struct inode* i, struct file* f)
{
	signed int		ret = check_device(i);
	unsigned int	min = iminor(i);

	DBG("entered");

	if (0 > ret) {
		DBG("exiting %u", ret);
		return ret;
	}

	if (0 != down_trylock(&m_data.devices[min].sem)) {
		ERR("The device is currently busy/accessed by another application");
		DBG("exiting -EBUSY");
		return -EBUSY;
	}

	INF("Opening device major:minor %u:%u", imajor(i), min);
	DBG("exiting 0");
	return 0;
}

static signed int
char_close(struct inode* i, struct file* f)
{
	signed int		ret = check_device(i);
	unsigned int	min = iminor(i);
	nb_dev_t*		nbd = NULL;

	DBG("entered");

	if (0 > ret) {
		DBG("exiting %u", ret);
		return ret;
	}

	nbd = &m_data.devices[min];

	mutex_lock(&nbd->mutex);

	if (NULL != nbd->data) {
		FRE("nbd->data pointer %p", nbd->data);
		vfree(nbd->data);

		nbd->data	= NULL;
		nbd->dlen	= 0;
		nbd->udlen	= 0;
	}

	if (NULL != nbd->pkt) {
		nbd_net_del(nbd->pkt);
		// pkt is deallocated in 
		// nbd_net_del() we set it
		// to NULL here out of 
		// pedantry
		nbd->pkt = NULL;
	}

	mutex_unlock(&nbd->mutex);

	INF("Closing device major:minor %u:%u", imajor(i), min);
	up(&m_data.devices[min].sem);
	DBG("exiting 0");
	return 0;
}

static signed long
char_ioctl(struct file * f, unsigned int c, unsigned long a)
{
	signed int		ret		= check_device_file(f);
	unsigned int	min		= iminor(f->f_dentry->d_inode);
	ip_network_t	net		= {0};
	void __user*	argp	= (void __user*)a;
	nb_dev_t*		nbd		= NULL;

	DBG("entered");

	if (0 > ret) {
		DBG("exiting %u", ret);
		return ret;
	}

	mutex_lock(&m_data.ioctl_lock);

	nbd = &m_data.devices[min];

	if (NULL == nbd)
		goto err_notty;

	if (NBD_IOCTL != _IOC_TYPE(c))
		goto err_notty;

	switch (c) {
		case SET_IP_NETWORK_IOCTL:
			if (_IOC_DIR(c) & _IOC_READ && !access_ok(VERIFY_READ, argp, _IOC_SIZE(c)))
				goto err_eacces;

			if (copy_from_user(&net, (ip_network_t*)argp, sizeof(ip_network_t)))
				goto err_efault;

			mutex_lock(&nbd->mutex);

			if (NULL != nbd->pkt) {
				ERR("Attempted to start a new scan without prior scan");
				goto err_notty;
			}

			nbd->ndata.type		= net.type;
			nbd->ndata.mask		= net.mask;
			nbd->ndata.sport	= net.sport;
			nbd->ndata.dport	= net.dport;

			if (TYPE_IPV4 == net.type)
				nbd->ndata.net.ipv4 = net.net.ipv4;
			else
				memcpy(nbd->ndata.net.ipv6, net.net.ipv6, sizeof(nbd->ndata.net.ipv6));

			if (0 != char_data_init(nbd, &net)) {
				mutex_unlock(&nbd->mutex);
				goto err_efault;
			}

			mutex_unlock(&nbd->mutex);
			break;

		case GET_IP_NETWORK_IOCTL:
			if (_IOC_DIR(c) & _IOC_WRITE && !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(c)))
				goto err_eacces;

			mutex_lock(&nbd->mutex);

			if (copy_to_user((ip_network_t*)argp, &nbd->ndata, sizeof(ip_network_t))) {
				mutex_unlock(&nbd->mutex);
				goto err_efault;
			}

			mutex_unlock(&nbd->mutex);
			break;

		case GET_DATA_LENGTH_IOCTL:
			if (_IOC_DIR(c) & _IOC_WRITE && !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(c)))
				goto err_eacces;

			mutex_lock(&nbd->mutex);

			if (copy_to_user((uint64_t*)argp, &nbd->udlen, sizeof(uint64_t))) {
				mutex_unlock(&nbd->mutex);
				goto err_efault;
			}

			mutex_unlock(&nbd->mutex);
			break;

		case START_SCAN_IOCTL:
			ret = nbd_net_add(nbd);

			if (0 > ret) {
				mutex_unlock(&m_data.ioctl_lock);
				return ret;
			}

			DBG("nbd->pkt: %p", nbd->pkt);
			break;

		case STOP_SCAN_IOCTL:
			mutex_lock(&nbd->mutex);

			if (NULL == nbd->pkt) {
				ERR("Attempted to stop a non-existant scan");
				mutex_unlock(&nbd->mutex);
				goto err_notty;
			}

			if (NULL != nbd->pkt) {
				nbd_net_del(nbd->pkt);

				//FRE("nbd->pkt pointer %p", nbd->pkt);
				//vfree(nbd->pkt);
				nbd->pkt = NULL;
			}

			mutex_unlock(&nbd->mutex);
			break;

		default:
			goto err_notty;
			break;
	}

	mutex_unlock(&m_data.ioctl_lock);
	DBG("exiting 0");
	return 0;

err_notty:
	ret = -ENOTTY;
	goto err;

err_eacces:
	ret = -EACCES;
	goto err;

err_efault:
	ret = -EFAULT;
err:
	mutex_unlock(&m_data.ioctl_lock);
	DBG("exiting %u", ret);
	return ret;
}
			
static int
char_mmap(struct file* f, struct vm_area_struct * v)
{
	signed int		ret	 = check_device_file(f);
	unsigned int	min	 = iminor(f->f_dentry->d_inode);

	DBG("entered");

	if (0 > ret) {
		DBG("exiting %u", ret);
		return ret;
	}

	if (0 == v->vm_pgoff) {
		DBG("exiting tail call");
		return char_vmem(&m_data.devices[min], v);
	}

	DBG("exiting -EIO");
	return -EIO;
}

static int
char_vmem(nb_dev_t* n, struct vm_area_struct* v)
{
	signed int		ret		= 0;
	unsigned long	start	= v->vm_start;
	size_t			len		= v->vm_end - v->vm_start;
	size_t			alen	= 0;
	size_t			ulen	= 0;
	char*			ptr		= NULL;
	unsigned long	pfn		= 0;

	DBG("entered");

	if (v->vm_end < v->vm_start) {
		DBG("exiting -EIO");
		return -EIO;
	}

	mutex_lock(&n->mutex);

	alen	= n->dlen;
	ulen	= n->udlen;
	ptr	 = n->data;

	// The user is trying to mmap() before
	// having called the correct ioctl() to
	// setup the memory.	
	if (NULL == ptr) {
		mutex_unlock(&n->mutex);
		DBG("exiting -EIO");
		return -EIO;
	}

	mutex_unlock(&n->mutex);

	if (0 == len)
		len = ulen;

	// XXX JF I'm not sure what to do
	// here, it probably makes sense 
	// to just map only alen into the
	// memory and say screw whatever
	// the user asked for, but i can
	// see all sorts of bad corner
	// case instances from that
	// sort of behavior, so i will
	// just error out at present.
	if (len != ulen) {
		/* So, when we map lengths smaller than a
		 * page, we end up with a mmap() request
		 * that is padded to a page size.
		 *
		 * Further testing will probably reveal
		 * this is an inadequate approach
 		 */
		if (ulen >= PAGE_SIZE && len != PAGE_SIZE) {
			ERR("exiting -EIO");
			return -EIO;
		}
	}

	// user-space is not allowed to write to the memory
	// region and there is never a reason it would need
	// to execute in it either.
	if (v->vm_flags & VM_WRITE || v->vm_flags & VM_EXEC) {
		DBG("exiting -EPERM");
		return -EPERM;
	}

#ifdef IGNORE_PROT_NONE
	v->vm_flags |= VM_READ;
#endif

	v->vm_flags |= (VM_DONTDUMP|VM_DONTEXPAND|VM_LOCKED); //(VM_IO|VM_DONTDUMP|VM_DONTEXPAND|VM_LOCKED);
//	v->vm_page_prot = pgprot_noncached(v->vm_page_prot);

	// I'm not actually positive we really
	// need to lock the mutex here, but
	// we are playing with the memory
	// region; even though it should
	// be safe this is not a code
	// path with a huge performance impact
	// so it's easier to just be safe and
	// not really think about it beyond 
	// that.
	mutex_lock(&n->mutex);

	while (0 < len) {
		pfn = vmalloc_to_pfn(ptr);

		if (! pfn_valid(pfn)) {
			mutex_unlock(&n->mutex);
			ERR("exiting -EIO");
			return -EIO;
		}

		ret = remap_pfn_range(v, start, pfn, PAGE_SIZE, v->vm_page_prot);

		if (0 > ret) {
			mutex_unlock(&n->mutex);
			ERR("exiting %u", ret);
			return ret;
		}

		start	+= PAGE_SIZE;
		ptr		+= PAGE_SIZE;
		len		-= PAGE_SIZE;
	}

	mutex_unlock(&n->mutex);
	DBG("exiting 0");
	return 0;
}

// Function is only called with d->mutex locked.
static signed int
char_data_init(nb_dev_t* d, ip_network_t* n)
{
	size_t hcnt = 0;
	size_t len  = 0;
	size_t rem  = 0;

	DBG("entered");

	if (NULL == d || NULL == n) {
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	// XXX JF FIXME - need to decide on a 
	// subnet segmentation scheme for ipv6
	// anything much larger than somewhere
	// around a /100 is much too big to 
	// represent in the same manner as with
	// ipv4; so realistically ipv6 networks
	// will need to be broken down into chunks
	//
	// However, how exactly that will work hasnt
	// been worked out in my head yet.
	if (TYPE_IPV6 == n->type) {
		ERR("IPv6 support currently non-functional.");
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	if (32 < n->mask) {
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	// 2^(32-netmask) 
	// = number of ips in subnet
	hcnt = 1 << (32 - n->mask);

	// Each IPv4 address:port pair is 
	// represented by a single bit that
	// is set to 1 if the port is open 
	// and 0 if the port is closed or 
	// we otherwise did not receive a 
	// response (or possibly dropped it)
	if (8 > hcnt)
		len = 1;
	else
		len = hcnt / 8;

	rem = len % PAGE_SIZE;

	if (rem > SIZE_MAX/len) {
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	if (NULL != d->data) {
		FRE("d->data pointer %p", d->data);
		vfree(d->data);
	}

	d->data = (void*)vzalloc(len+rem);

	if (NULL == d->data) {
		DBG("exiting -ENOMEM");
		return -ENOMEM;
	}

	d->dlen		= len+rem;
	d->udlen	= len;
	ALO("d->data pointer %p %lu bytes, %lu remainder, %lu IPs", d->data, len+rem, rem, len*8);

	DBG("exiting 0");
	return 0;
}

static void
char_destroy(nb_dev_t* d, signed int min)
{
	BUG_ON(NULL == d || NULL == m_data.class);

	DBG("entered");

	if (min >= g_vars.device_count) {
		ERR("Somehow we attempted to destroy a device that doesn't exist.");
		DBG("exiting (void)");
		return;
	}

	mutex_lock(&d->mutex);

	if (NULL != d->data) {
		FRE("nbd->data pointer %p", d->data);
		vfree(d->data);

		d->data		= NULL;
		d->dlen		= 0;
		d->udlen	= 0;
	}

	if (NULL != d->pkt) {
		nbd_net_del(d->pkt);

		FRE("nbd->pkt pointer %p", d->pkt);
 		vfree(d->pkt);
		d->pkt = NULL;
	}

	device_destroy(m_data.class, MKDEV(m_data.major, min));
	cdev_del(d->cdev);
	mutex_unlock(&d->mutex);
	mutex_destroy(&d->mutex);
 
	DBG("exiting (void)"); 
	return;
}

static signed int
char_create(nb_dev_t* d, signed int min)
{
	signed int ret = 0;

	DBG("entered");

	if (NULL == d) {
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	d->cdev		 	= cdev_alloc();
	d->cdev->owner	= THIS_MODULE;
	d->data		 	= NULL;
	d->pkt			= NULL;
	d->dlen			= 0;
	d->udlen		= 0;

	cdev_init(d->cdev, &nb_ops);
	sema_init(&d->sem, 1);
	mutex_init(&d->mutex);

	ret = cdev_add(d->cdev, MKDEV(m_data.major, min), 1);

	if (0 != ret) {
		ERR("Error while calling cdev_add()");
		goto fail;
	}

	d->device = device_create(m_data.class, NULL, MKDEV(m_data.major, min), NULL, DEVICENAME "%u", min);

	if (IS_ERR(d->device)) {
		ret = PTR_ERR(d->device);

		ERR("Error %d while trying to create %s%u via device_create()", ret, DEVICENAME, min);
		goto fail;
	}

	DBG("exiting 0");
	return 0;

fail:
	char_destroy(d, min);
	DBG("exiting -1");
	return -1;
}

signed int
nbd_char_init(void)
{
	signed int		ret = 0;
	dev_t			dev = 0;
	signed int		idx = 0;

	DBG("entered");

	if (1 > g_vars.device_count || g_vars.device_count > SIZE_MAX/sizeof(nb_dev_t)) {
		ERR("Invalid number of devices specified, it must be greater than zero and less than SIZE_MAX");
		DBG("exiting -EINVAL");
		return -EINVAL;
	}

	mutex_init(&m_data.ioctl_lock);

	m_data.devices = (nb_dev_t*)kzalloc(g_vars.device_count * sizeof(nb_dev_t), GFP_KERNEL);

	if (NULL == m_data.devices) {
		ERR("Failed to allocate device related structures");
		DBG("exiting -ENOMEM");
		return -ENOMEM;
	}

	ALO("m_data.devices: %p %u bytes", m_data.devices, g_vars.device_count * sizeof(nb_dev_t));

	ret = alloc_chrdev_region(&dev, 0, g_vars.device_count, DEVICENAME);

	if (0 > ret) {
		ERR("Failure in alloc_chrdev_region()");
		DBG("exiting %u", ret);
		return ret;
	}

	m_data.class = class_create(THIS_MODULE, DEVICENAME);

	if (IS_ERR(m_data.class)) {
		ERR("Failure while calling class_create()");
		unregister_chrdev_region(dev, g_vars.device_count);
		kfree(m_data.devices);
		DBG("exiting %u", PTR_ERR(m_data.class));
		return PTR_ERR(m_data.class);
	}

	m_data.major = MAJOR(dev);

	for (idx = 0; idx < g_vars.device_count; idx++) {
		if (0 > char_create(&m_data.devices[idx], idx))
			goto fail;
	}

	DBG("exiting 0");
	return 0;

fail:
	for (idx = 0; idx < g_vars.device_count; idx++)
		char_destroy(&m_data.devices[idx], idx);

	if (NULL != m_data.class)
		class_destroy(m_data.class);

	unregister_chrdev_region(MKDEV(m_data.major, 0), g_vars.device_count);

	FRE("m_data.devices %p", m_data.devices);
	kfree(m_data.devices);
	DBG("exiting -1");
	return -1;
}

signed int
nbd_char_destroy(void)
{
	signed int idx = 0;

	DBG("entered");

	for (idx = 0; idx < g_vars.device_count; idx++)
		char_destroy(&m_data.devices[idx], idx);

	if (NULL != m_data.class)
		class_destroy(m_data.class);

	unregister_chrdev_region(MKDEV(m_data.major, 0), g_vars.device_count);

	FRE("m_data.devices: %p", m_data.devices);
	kfree(m_data.devices);

	mutex_destroy(&m_data.ioctl_lock);
	DBG("exiting 0");
	return 0;
}
