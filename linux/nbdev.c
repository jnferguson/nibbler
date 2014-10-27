#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/semaphore.h>
#include <linux/mutex.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/ioctl.h>
#include <asm/page.h>
#include <linux/mm.h>

#include "nbdev.h"

MODULE_AUTHOR("jf@ownco.net");
MODULE_DESCRIPTION("Nibbler Scanner Device Driver");
MODULE_LICENSE("GPL v2");
MODULE_SUPPORTED_DEVICE("NIBBLER");

#define NUMBER_OF_DEVICES 2
#define DEVICENAME "NIBBLER"

#define DEBUG_ALLOCS
#define DEBUG
#define IGNORE_PROT_NONE

typedef struct {
    struct semaphore    sem;    // enforces one application per device
    struct mutex        mutex;  // locked whenever the device accesses instance data
    struct cdev*        cdev;
    dev_t               num;
    struct device*      device;
    void*               data;
    size_t              dlen;
    size_t              udlen;
    ip_network_t        ndata;
} nb_dev_t;


static signed int nb_open(struct inode*, struct file*);
static signed int nb_close(struct inode*, struct file*);
static signed long nb_ioctl(struct file *, unsigned int, unsigned long);
static void nb_destroy(nb_dev_t*, signed int);
static signed int nb_create(nb_dev_t*, signed int);
static signed int nb_init(void);
static void nb_exit(void);
static signed int nb_data_init(nb_dev_t*, ip_network_t*);
static int nb_mmap(struct file *, struct vm_area_struct*);
static int nb_vmem(nb_dev_t*, struct vm_area_struct*);

static struct file_operations nb_ops =
{
    .owner          = THIS_MODULE,
    .open           = nb_open,
    .release        = nb_close,
    .poll           = NULL,
    .compat_ioctl   = NULL,
    .unlocked_ioctl = nb_ioctl,
    .mmap           = nb_mmap
};

static nb_dev_t*        devices     = NULL;
static signed int       major       = 0;
static struct class*    nbclass     = NULL;
static struct mutex     ioctl_mutex = {{0}};

static signed int
nb_open(struct inode* i, struct file* f)
{
    unsigned int maj = imajor(i);
    unsigned int min = iminor(i);

    if (maj != major || min >= NUMBER_OF_DEVICES) {
        printk(KERN_ALERT DEVICENAME": No device found with major=%u and minor=%u\n", maj, min);
        return -ENODEV;
    }

    if (i->i_cdev != devices[min].cdev) {
        printk(KERN_ALERT DEVICENAME": Internal error while opening device.\n");
        return -ENODEV;
    }

    if (0 != down_trylock(&devices[min].sem)) {
        printk(KERN_ALERT DEVICENAME": The device is currently busy/accessed by another application\n");
        return -EBUSY;
    }

#ifdef DEBUG
    printk(KERN_INFO DEVICENAME": Opening %u:%u\n", maj, min);
#endif
    return 0;
}

static signed int
nb_close(struct inode* i, struct file* f)
{
    unsigned int    maj = imajor(i);
    unsigned int    min = iminor(i);
    nb_dev_t*       nbd = NULL;

    if (maj != major || min >= NUMBER_OF_DEVICES) {
#ifdef DEBUG
        printk(KERN_ALERT DEVICENAME": No device found with major=%u and minor=%u\n", maj, min);
#endif
        return -ENODEV;
    }

    if (i->i_cdev != devices[min].cdev) {
#ifdef DEBUG
        printk(KERN_ALERT DEVICENAME": Internal error while opening device.\n");
#endif
        return -ENODEV;
    }

    nbd = &devices[min];

    mutex_lock(&nbd->mutex);

    if (NULL != nbd->data) {
#ifdef DEBUG_ALLOCS
        printk(KERN_INFO DEVICENAME": Calling vfree() on pointer %p\n", nbd->data);
#endif
        vfree(nbd->data);

        nbd->data   = NULL;
        nbd->dlen   = 0;
        nbd->udlen  = 0;
    }
    mutex_unlock(&nbd->mutex);

#ifdef DEBUG
    printk(KERN_INFO DEVICENAME": Closing %u:%u\n", maj, min);
#endif
    up(&devices[min].sem);
    return 0;
}

static signed long
nb_ioctl(struct file * f, unsigned int c, unsigned long a)
{
    ip_network_t    net     = {0};
    void __user*    argp    = (void __user*)a;
    struct inode*   i       = NULL;
    nb_dev_t*       nbd     = NULL;
    unsigned int    maj     = 0;
    unsigned int    min     = 0;

    mutex_lock(&ioctl_mutex);

    if (NULL == f || NULL == f->f_dentry)  {
        mutex_unlock(&ioctl_mutex);
        return -EBADF;
    }

    i = f->f_dentry->d_inode;

    maj = imajor(i);
    min = iminor(i);

    if (maj != major || min >= NUMBER_OF_DEVICES) {
        mutex_unlock(&ioctl_mutex);
        return -EBADF;
    }

    nbd = &devices[min];

    if (NULL == nbd) {
        mutex_unlock(&ioctl_mutex);
        return -ENOTTY;
    }

    if (NBD_IOCTL != _IOC_TYPE(c)) {
        mutex_unlock(&ioctl_mutex);
        return -ENOTTY;
    }

    switch (c) {
        case SET_IP_NETWORK_IOCTL:
            if (_IOC_DIR(c) & _IOC_READ && !access_ok(VERIFY_READ, argp, _IOC_SIZE(c))) {
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            if (copy_from_user(&net, (ip_network_t*)argp, sizeof(ip_network_t))) {
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            mutex_lock(&nbd->mutex);

            nbd->ndata.type     = net.type;
            nbd->ndata.mask     = net.mask;
            nbd->ndata.sport    = net.sport;
            nbd->ndata.dport    = net.dport;

            if (TYPE_IPV4 == net.type)
                nbd->ndata.net.ipv4 = net.net.ipv4;
            else
                memcpy(nbd->ndata.net.ipv6, net.net.ipv6, sizeof(nbd->ndata.net.ipv6));

            if (0 != nb_data_init(nbd, &net)) {
                mutex_unlock(&nbd->mutex);
                mutex_unlock(&ioctl_mutex);
                return -EFAULT; // XXX JF FIXME better retval?
            }

            mutex_unlock(&nbd->mutex);

            // XXX TODO
            // netif_rx_register_handler()
            // start kernel thread to transmit packets
            break;

        case GET_IP_NETWORK_IOCTL:
            if (_IOC_DIR(c) & _IOC_WRITE && !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(c))) {
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            mutex_lock(&nbd->mutex);

            if (copy_to_user((ip_network_t*)argp, &nbd->ndata, sizeof(ip_network_t))) {
                mutex_unlock(&nbd->mutex);
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            mutex_unlock(&nbd->mutex);
            break;

        case GET_DATA_LENGTH_IOCTL:
            if (_IOC_DIR(c) & _IOC_WRITE && !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(c))) {
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            mutex_lock(&nbd->mutex);

            if (copy_to_user((uint64_t*)argp, &nbd->udlen, sizeof(uint64_t))) {
                mutex_unlock(&nbd->mutex);
                mutex_unlock(&ioctl_mutex);
                return -EFAULT;
            }

            mutex_unlock(&nbd->mutex);
            break;

        default:
            mutex_unlock(&ioctl_mutex);
            return -ENOTTY;
            break;
    }

    mutex_unlock(&ioctl_mutex);
    return 0;
}

static int
nb_mmap(struct file * f, struct vm_area_struct * v)
{
    struct inode*   i       = NULL;
    nb_dev_t*       nbd     = NULL;
    unsigned int    maj     = 0;
    unsigned int    min     = 0;

    BUG_ON(NULL == f || NULL == v);

    if (NULL == f->f_dentry)
        return -EBADF;

    i = f->f_dentry->d_inode;

    maj = imajor(i);
    min = iminor(i);

    if (maj != major || min >= NUMBER_OF_DEVICES)
        return -EBADF;

    nbd = &devices[min];

    if (0 == v->vm_pgoff)
        return nb_vmem(nbd, v);

    return -EIO;
}

static int
nb_vmem(nb_dev_t* n, struct vm_area_struct* v)
{
    signed int      ret     = 0;
    unsigned long   start   = v->vm_start;
    size_t          len     = v->vm_end - v->vm_start;
    size_t          alen    = 0; //n->dlen;
    size_t          ulen    = 0; //n->udlen;
    char*           ptr     = NULL; //n->data;
    unsigned long   pfn     = 0;

    if (v->vm_end < v->vm_start)
        return -EIO;

    mutex_lock(&n->mutex);

    alen    = n->dlen;
    ulen    = n->udlen;
    ptr     = n->data;

    // The user is trying to mmap() before
    // having called the correct ioctl() to
    // setup the memory.    
    if (NULL == ptr) {
        mutex_unlock(&n->mutex);
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
    if (len != ulen)
        return -EIO;

    // user-space is not allowed to write to the memory
    // region and there is never a reason it would need
    // to execute in it either.
    if (v->vm_flags & VM_WRITE || v->vm_flags & VM_EXEC)
        return -EPERM;

#ifdef IGNORE_PROT_NONE
    v->vm_flags |= VM_READ;
#endif

    v->vm_flags |= (VM_IO|VM_DONTDUMP|VM_DONTEXPAND|VM_LOCKED);
    v->vm_page_prot = pgprot_noncached(v->vm_page_prot);

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
            return -EIO;
        }

        ret = remap_pfn_range(v, start, pfn, PAGE_SIZE, v->vm_page_prot);

        if (0 > ret) {
            mutex_unlock(&n->mutex);
            return ret;
        }

        start   += PAGE_SIZE;
        ptr     += PAGE_SIZE;
        len     -= PAGE_SIZE;
    }

    mutex_unlock(&n->mutex);
    return 0;
}

// Function is only called with d->mutex locked.
static signed int
nb_data_init(nb_dev_t* d, ip_network_t* n)
{
    size_t hcnt = 0;
    size_t len  = 0;
    size_t rem  = 0;

    if (NULL == d || NULL == n)
        return -EINVAL;

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
#ifdef DEBUG
        printk(KERN_INFO DEVICENAME": IPv6 support currently non-functional.\n");
#endif
        return -EINVAL;
    }

    if (32 < n->mask)
        return -EINVAL;

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

    if (rem > SIZE_MAX/len)
        return -EINVAL;

    if (NULL != d->data)
        vfree(d->data);

    d->data = (void*)vzalloc(len+rem);

    if (NULL == d->data)
        return -ENOMEM;

    d->dlen     = len+rem;
    d->udlen    = len;
#ifdef DEBUG_ALLOCS
    printk(KERN_INFO DEVICENAME": Allocated pointer at %p\n", d->data);
    printk(KERN_INFO DEVICENAME": Allocated %lu bytes of memory with %lu remainder bytes or %lu IPs\n", len+rem, rem, len*8);
#endif
    return 0;
}

static void
nb_destroy(nb_dev_t* d, signed int min)
{
    BUG_ON(NULL == d || NULL == nbclass);

    if (min >= NUMBER_OF_DEVICES) {
        printk(KERN_ALERT DEVICENAME": Somehow we attempted to destroy a device that doesn't exist.\n");
        printk(KERN_ALERT DEVICENAME": Naturally, we are refusing this request\n");
        return;
    }

    device_destroy(nbclass, MKDEV(major, min));
    cdev_del(d->cdev);
    mutex_destroy(&d->mutex);
    return;
}

static signed int
nb_create(nb_dev_t* d, signed int min)
{
    signed int ret = 0;

    if (NULL == d)
        return -EINVAL;

    d->cdev         = cdev_alloc();
    d->cdev->owner  = THIS_MODULE;
    d->data         = NULL;
    d->dlen         = 0;
    d->udlen        = 0;

    cdev_init(d->cdev, &nb_ops);
    sema_init(&d->sem, 1);
    mutex_init(&d->mutex);

    ret = cdev_add(d->cdev, MKDEV(major, min), 1);

    if (0 != ret) {
        printk(KERN_ALERT DEVICENAME": Error while trying to add device\n");
        goto fail;
    }

    d->device = device_create(nbclass, NULL, MKDEV(major, min), NULL, DEVICENAME "%u", min);

    if (IS_ERR(d->device)) {
        ret = PTR_ERR(d->device);

        printk(KERN_ALERT DEVICENAME": Error %d while trying to create %s%u\n",
                        ret, DEVICENAME, min);
        goto fail;
    }

    return 0;

fail:
    nb_destroy(d, min);
    return -1;
}

static signed int __init
nb_init(void)
{
    signed int      ret = 0;
    dev_t           dev = 0;
    signed int      idx = 0;

    if (NUMBER_OF_DEVICES < 1) {
        printk(KERN_ALERT DEVICENAME": Invalid compile time value; number of devices < 1\n");
        return -EINVAL;
    }

    mutex_init(&ioctl_mutex);

    devices = (nb_dev_t*)kzalloc(NUMBER_OF_DEVICES * sizeof(nb_dev_t), GFP_KERNEL);

    if (NULL == devices) {
        printk(KERN_ALERT DEVICENAME": Failed to allocate device related structures\n");
        return -ENOMEM;
    }

    ret = alloc_chrdev_region(&dev, 0, NUMBER_OF_DEVICES, DEVICENAME);

    if (0 > ret) {
        printk(KERN_ALERT DEVICENAME": Failed to allocate device major number\n");
        return ret;
    }

    nbclass = class_create(THIS_MODULE, DEVICENAME);

    if (IS_ERR(nbclass)) {
        printk(KERN_ALERT DEVICENAME": Error while creating device class\n");
        unregister_chrdev_region(dev, NUMBER_OF_DEVICES);
        kfree(devices);
        return PTR_ERR(nbclass);
    }

    major = MAJOR(dev);

    for (idx = 0; idx < NUMBER_OF_DEVICES; idx++) {
        if (0 > nb_create(&devices[idx], idx))
            goto fail;
    }

#ifdef DEBUG
    printk(KERN_INFO DEVICENAME": Successfully inserted module.\n");
#endif
    return 0;

fail:
    for (idx = 0; idx < NUMBER_OF_DEVICES; idx++)
        nb_destroy(&devices[idx], idx);

    if (NULL != nbclass)
        class_destroy(nbclass);

    unregister_chrdev_region(MKDEV(major, 0), NUMBER_OF_DEVICES);
    kfree(devices);
    return -1;
}

static void __exit
nb_exit(void)
{
    signed int idx = 0;

    for (idx = 0; idx < NUMBER_OF_DEVICES; idx++)
        nb_destroy(&devices[idx], idx);

    if (NULL != nbclass)
        class_destroy(nbclass);

    unregister_chrdev_region(MKDEV(major, 0), NUMBER_OF_DEVICES);
    kfree(devices);

    mutex_destroy(&ioctl_mutex);
#ifdef DEBUG
    printk(KERN_INFO DEVICENAME": Removed device from kernel\n");
#endif
    return;
}

module_init(nb_init);
module_exit(nb_exit);
