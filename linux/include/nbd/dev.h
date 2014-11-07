#ifndef HAVE_NBD_DEV_H
#define HAVE_NBD_DEV_H

#if defined(__KERNEL__)

#include <linux/types.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/semaphore.h>
#include <linux/mutex.h>
#include <linux/list.h>
#include <linux/in6.h>
#include <linux/in.h>
#include <linux/sched.h>
#include <net/net_namespace.h>
#include <linux/inetdevice.h>
#include <linux/rtnetlink.h>

#include <asm/atomic.h>

#include <nbd/global.h>
#include <nbd/ioctl.h> // for type #define's

typedef struct {
	struct semaphore	sem;    // enforces one application per device
	struct mutex		mutex;  // locked whenever the device accesses instance data
	struct cdev*		cdev;
	dev_t				num;
	struct device*		device;
	void*				data;
	size_t				dlen;
	size_t				udlen;
	ip_network_t		ndata;
	pkt_data_t*		pkt;
} nb_dev_t;

#else
#error You are trying to include a kernel-space header file in a user-space application!
#endif

#endif
