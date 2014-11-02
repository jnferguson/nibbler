#ifndef HAVE_NBD_CHAR_H
#define HAVE_NBD_CHAR_H

#if defined(__KERNEL__)

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

#include <nbd/dev.h>

signed int nbd_char_init(void);
signed int nbd_char_destroy(void);

typedef struct {
    nb_dev_t*       devices;
    signed int      major;
    struct class*   class;
    struct mutex    ioctl_lock;
} char_metadata_t;

#else
#error You are attempting to include a kernel-space header in a user-space application!
#endif
#endif
