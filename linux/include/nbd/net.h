#ifndef HAVE_NBD_NET_H
#define HAVE_NBD_NET_H

#if defined(__KERNEL__)

#include <linux/types.h>
#include <linux/mutex.h>
#include <linux/list.h>
#include <linux/in6.h>
#include <linux/in.h>
#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <linux/udp.h>
#include <linux/if_ether.h>
#include <net/ip6_route.h>
#include <net/route.h>
#include <linux/neighbour.h>
#include <net/neighbour.h>
#include <net/net_namespace.h>
#include <net/arp.h>
#include <linux/route.h>
#include <linux/pkt_sched.h>
#include <linux/random.h>
#include <asm/atomic.h>
#include <linux/kthread.h>

#include <nbd/global.h>
#include <nbd/dev.h>
#include <nbd/thread.h>

typedef struct {
	struct mutex		lock;
	struct list_head	head;
	size_t				count;
} pkt_metadata_t;

signed int nbd_net_init(void);
signed int nbd_net_destroy(void);
signed int nbd_net_add(nb_dev_t*);
signed int nbd_net_del(pkt_data_t*);


#else
#error You are trying to include a kernel-space header file in a user-space application
#endif

#endif
