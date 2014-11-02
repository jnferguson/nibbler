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
#include <nbd/ioctl.h> // for type #define's

typedef struct {
    struct in_addr min;
    struct in_addr max;
} ipv4_minmax_t;

typedef struct {
    struct in6_addr min;
    struct in6_addr max;
} ipv6_minmax_t;


typedef struct {
    uint8_t             type;   // TYPE_IPV4 || TYPE_IPV6 
    void*               data;   // the memory mapped into userspace
    size_t              len;    // the usable portion of data
    struct list_head    list;   // next/prev pointers

    // this union is so we can use the same
    // structure for both ipv6 and ipv4.
    // this is the second instance where
    // C++ polymorphism would be nice, but
    // i guess the performance hit from it
    // may not be wise.
    union {
            ipv4_minmax_t   ipv4;   // these contain the network and broadcast
            ipv6_minmax_t   ipv6;   // addresses for a scanned range
    } net_addr;

    struct {
        uint16_t source;            // the source and destination TCP port
        uint16_t dest;              // we are scanning for. I guess it could be UDP two
    } trans_addr;

} pkt_data_t;

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
    pkt_data_t*         pkt;
} nb_dev_t;

#else
#error You are trying to include a kernel-space header file in a user-space application!
#endif

#endif
