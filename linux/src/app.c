#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <nbd/ioctl.h>

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
    net.net.ipv4    = htonl(inet_addr("127.0.0.1")); //0x7FFF0001;
    net.mask        = 16;
    net.dport       = 80;
	net.sport		= 3001;

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

	if (0 != ioctl(fd, START_SCAN_IOCTL, NULL)) {
		perror("ioctl(START_SCAN_IOCTL)");
		munmap(ptr, len);
		close(fd);
		return EXIT_FAILURE;
	}

	sleep(1*20);

	printf("ioctl(STOP_SCAN_IOCTL)\n");
	if (0 != ioctl(fd, STOP_SCAN_IOCTL, NULL)) {
		perror("ioctl(STOP_SCAN_IOCTL)");
		munmap(ptr, len);
		close(fd);
		return EXIT_FAILURE;
	}

	printf("munmap(ptr, len)\n");
	munmap(ptr, len);
	printf("close(fd)\n");
    close(fd);
    return EXIT_SUCCESS;

}
