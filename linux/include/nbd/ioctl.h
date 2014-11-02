#ifndef HAVE_NBD_IOCTL_H
#define HAVE_NBD_IOCTL_H

// for uintX_t's
#if defined(__KERNEL__) 
#include <linux/types.h>
#else
#include <stdint.h>
#endif

#define TYPE_IPV4 0
#define TYPE_IPV6 1

typedef struct {
    uint8_t     type;
    uint8_t     mask;
    uint16_t    sport;
    uint16_t    dport;

    union {
        uint32_t    ipv4;
        uint8_t     ipv6[16];
    } net;

} ip_network_t;

#define NBD_IOCTL 'N'
#define SET_IP_NETWORK_IOCTL    _IOW(NBD_IOCTL, 0, ip_network_t)
#define GET_IP_NETWORK_IOCTL    _IOR(NBD_IOCTL, 1, ip_network_t)
#define GET_DATA_LENGTH_IOCTL   _IOR(NBD_IOCTL, 2, uint64_t)
#define START_SCAN_IOCTL        _IO(NBD_IOCTL,  3)
#define STOP_SCAN_IOCTL         _IO(NBD_IOCTL,  4) 

#endif
