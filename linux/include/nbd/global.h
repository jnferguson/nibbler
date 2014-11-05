#ifndef HAVE_NBD_GLOBAL_H
#define HAVE_NBD_GLOBAL_H

#if defined(__KERNEL__)

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/types.h>
#include <linux/stat.h>
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


#ifdef DEBUG
#define ERR(fmt, ...) printk(KERN_ALERT "NIBBLER[ERR]: "fmt, ## __VA_ARGS__)
#define INF(fmt, ...) printk(KERN_INFO  "NIBBLER[INF]: "fmt, ## __VA_ARGS__)
#else
#define ERR(fmt, ...) plog("NIBBLER[ERR]: "fmt, ## __VA_ARGS__) 
#define INF(fmt, ...) plog("NIBBLER[INF]: "fmt, ## __VA_ARGS__)
#endif /* DEBUG */

#ifdef DEBUG_ALLOCS
#define ALO(fmt, ...) printk(KERN_INFO "NIBBLER[ALO]: "fmt, ## __VA_ARGS__)
#define FRE(fmt, ...) printk(KERN_INFO "NIBBLER[FRE]: "fmt, ## __VA_ARGS__)
#else
#define ALO(fmt, ...) plog("NIBBLER[ALO]: "fmt, ## __VA_ARGS__)
#define FRE(fmt, ...) plog("NIBBLER[FRE]: "fmt, ## __VA_ARGS__)
#endif /* DEBUG_ALLOCS */
#else
#error You are attempting to incldue a kernel header in a user-space application.
#endif /* __KERNEL__ */

#endif /* HAVE_NBD_GLOBAL_H */
