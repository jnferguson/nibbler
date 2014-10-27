#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#include "nbdev.h"

signed int
main(void)
{
    char*           dev = "/dev/NIBBLER0";
    signed int      fd  = open(dev, O_RDWR);
    ip_network_t    net = {0};
    uint64_t        len = 0;
    void*           ptr = NULL;

    if (0 > fd) {
        perror("open()");
        return EXIT_FAILURE;
    }

    net.type        = TYPE_IPV4;
    net.net.ipv4    = 0x7FFF0001;
    net.mask        = 8;
    net.dport       = 1;

    if (0 != ioctl(fd, SET_IP_NETWORK_IOCTL, &net)) {
            perror("ioctl(SET_IP_NETWORK_IOCTL)");
        close(fd);
        return EXIT_FAILURE;
    }

    if (0 != ioctl(fd, GET_DATA_LENGTH_IOCTL, &len)) {
        perror("ioctl(GET_DATA_LENGTH_IOCTL)");
        close(fd);
        return EXIT_FAILURE;
    }

    ptr = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);

    if (MAP_FAILED == ptr) {
        perror("mmap()");
        close(fd);
        return EXIT_FAILURE;
    }

    printf("[%u] ptr: %p\n", getpid(), ptr);
    sleep(60*5);
    close(fd);
    return EXIT_SUCCESS;

}
