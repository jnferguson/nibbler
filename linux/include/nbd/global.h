#ifndef HAVE_NBD_GLOBAL_H
#define HAVE_NBD_GLOBAL_H

#if defined(__KERNEL__)

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/types.h>
#include <linux/stat.h>
#include <linux/in6.h>
#include <linux/in.h>
#include <linux/list.h>
#include <stdarg.h>

#define DEVICENAME "NIBBLER"

typedef struct {
	size_t  device_count;
	uint8_t verbose;
} global_data_t;

inline size_t get_device_count(void);
inline uint8_t is_verbose(void);
void plog(char*, ...);

//#define DEBUG
//#define DEBUG_ALLOCS
#define IGNORE_PROT_NONE

#define DBG_FMT "NIBBLER[DBG] %s@%.4u: "
#define INF_FMT "NIBBLER[INF] %s@%.4u: "
#define WRN_FMT "NIBBLER[WRN] %s@%.4u: "
#define NOT_FMT "NIBBLER[NOT] %s@%.4u: "
#define ERR_FMT "NIBBLER[ERR] %s@%.4u: "
#define ALO_FMT "NIBBLER[ALO] %s@%.4u: "
#define FRE_FMT "NIBBLER[FRE] %s@%.4u: "

#ifdef DEBUG

#define DBG(fmt, ...) printk(KERN_DEBUG DBG_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define INF(fmt, ...) printk(KERN_INFO  INF_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define NOT(fmt, ...) printk(KERN_NOTICE NOT_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define WRN(fmt, ...) printk(KERN_WARNING WRN_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ERR(fmt, ...) printk(KERN_ERR ERR_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)

#else
#define DBG(fmt, ...) 
#define INF(fmt, ...) 
#define NOT(fmt, ...) plog(KERN_NOTICE NOT_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define WRN(fmt, ...) plog(KERN_WARNING WRN_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define ERR(fmt, ...) plog(KERN_ERR ERR_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif /* DEBUG */

#ifdef DEBUG_ALLOCS
#define ALO(fmt, ...) printk(KERN_DEBUG ALO_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#define FRE(fmt, ...) printk(KERN_DEBUG FRE_FMT fmt"\n", __FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define ALO(fmt, ...) 
#define FRE(fmt, ...) 
#endif /* DEBUG_ALLOCS */

typedef struct {
	struct in_addr min;
	struct in_addr max;
} ipv4_minmax_t;

typedef struct {
	struct in6_addr min;
	struct in6_addr max;
} ipv6_minmax_t;

typedef ssize_t thread_id_t;

typedef struct {
	thread_id_t			id;
	uint8_t				type;	   // TYPE_IPV4 || TYPE_IPV6 
	void*				data;	   // the memory mapped into userspace
	size_t				len;		// the usable portion of data
	atomic_t			started;	// whether TX has started or not
	struct list_head	list;	   // next/prev pointers

	// this union is so we can use the same
	// structure for both ipv6 and ipv4.
	// this is the second instance where
	// C++ polymorphism would be nice, but
	// i guess the performance hit from it
	// may not be wise.
	union {
		ipv4_minmax_t	ipv4;   // these contain the network and broadcast
		ipv6_minmax_t	ipv6;   // addresses for a scanned range
	} net_addr;

	struct {
		uint16_t	source;			// the source and destination TCP port
		uint16_t	dest;			  // we are scanning for. I guess it could be UDP two
	} trans_addr;

} pkt_data_t;


#else
#error You are attempting to incldue a kernel header in a user-space application.
#endif /* __KERNEL__ */

#endif /* HAVE_NBD_GLOBAL_H */
