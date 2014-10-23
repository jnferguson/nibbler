/* LKM
 * Implements (at present) a useless character device.
 *
 * The intention is to use this as an interface for scanning by short-circuiting the network stack
 * in a manner that is optimized for our usage.
 * Ideally, this would be implemented as a couple of new system calls, but there is no method
 * for implementing a new system call without requiring a patch to the kernel source and recompiling,
 * which i dont feel is a reasonable requirement.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/semaphore.h>
#include <linux/uaccess.h>

signed int nibdrv_init(void);
void nibdrv_exit(void);
static signed int nb_open(struct inode*, struct file*);
static signed int nb_close(struct inode*, struct file*);

// XXX JF need unique names/static?
struct semaphore        lock;   //= {0};
dev_t                   dnum    = {0};
struct cdev*            nbdev   = NULL;
signed int              major   = 0;
signed int              retval  = 0;
static struct class*    nbclass = NULL;

#define DEVICENAME "NIBBLER"

static signed int
nb_open(struct inode* i, struct file* f)
{
	unsigned int maj = imajor(i);
	unsigned int min = iminor(i);

	if (maj != major || min != 0) {
		printk(KERN_ALERT DEVICENAME": No device found with major=%u and minor=%u\n", maj, min);
		return -ENODEV;
	}

	if (i->i_cdev != nbdev) {
		printk(KERN_ALERT DEVICENAME": Internal error while opening device.\n");
		return -ENODEV;
	}

	if (0 != down_trylock(&lock)) {
		printk(KERN_ALERT DEVICENAME": The device is currently busy/accessed by another application\n");
		return -EBUSY;
	}

	return 0;
}

static signed int
nb_close(struct inode* i, struct file* f)
{
	up(&lock);
	return 0;
}

signed long
nb_ioctl(struct file* f, unsigned int n, unsigned long p)
{
	return 0;
}

struct file_operations fops =
{
	.owner          = THIS_MODULE,
	.open           = nb_open,
	.release        = nb_close,
	//.ioctl                = nb_ioctl,
	.poll           = NULL,
	.compat_ioctl   = NULL,
	.unlocked_ioctl = nb_ioctl,
	.mmap           = NULL
	//1492         unsigned int (*poll) (struct file *, struct poll_table_struct *);
	//1493         long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
	//1494         long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
	//1495         int (*mmap) (struct file *, struct vm_area_struct *);
};


signed int
nb_init(void)
{
	struct device *device = NULL;

	retval = alloc_chrdev_region(&dnum, 0, 1, DEVICENAME);

	if (0 > retval) {
		printk(KERN_ALERT DEVICENAME": Failed to allocate device major number\n");
		return retval;
	}

	major = MAJOR(dnum);

	nbdev = cdev_alloc();

	nbdev->ops      = &fops;
	nbdev->owner    = THIS_MODULE;

	retval = cdev_add(nbdev, dnum, 1);

	if (0 > retval) {
		printk(KERN_ALERT DEVICENAME": Failure while adding device to kernel\n");
		return retval;
	}

	sema_init(&lock, 1);
	nbclass = class_create(THIS_MODULE, DEVICENAME"1");

	if (IS_ERR(nbclass)) {
		printk(KERN_ALERT DEVICENAME": Error while creating device class\n");
		cdev_del(nbdev);
		return -1;
	}

	device = device_create(nbclass, NULL, MKDEV(major, 0), NULL, DEVICENAME "%u", 0);

	if (IS_ERR(device)) {
		printk(KERN_ALERT DEVICENAME": Error while creating device node\n");
		cdev_del(nbdev);
		return -1;
	}

	return 0;
}

void
nb_exit(void)
{
	device_destroy(nbclass, MKDEV(major,0));
	cdev_del(nbdev);
	class_destroy(nbclass);
	printk(KERN_INFO DEVICENAME": Removed device from kernel\n");
	unregister_chrdev_region(dnum, 1);

	return;
}
																																										MODULE_AUTHOR("jf@ownco.net");
MODULE_DESCRIPTION("Nibbler Scanner Device Driver");
MODULE_LICENSE("GPL v2");
MODULE_SUPPORTED_DEVICE("NIBBLER");
module_init(nb_init);
module_exit(nb_exit);

