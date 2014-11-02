#include <nbd/global.h>
#include <nbd/dev.h>
#include <nbd/net.h>
#include <nbd/char.h>

MODULE_AUTHOR("jf@ownco.net");
MODULE_DESCRIPTION("Nibbler Scanner Device Driver");
MODULE_LICENSE("GPL v2");
MODULE_SUPPORTED_DEVICE("NIBBLER");

static size_t device_cnt    = 1;
static uint8_t verbose      = 0;

module_param(device_cnt, ulong, S_IRUSR|S_IRGRP|S_IROTH);
MODULE_PARM_DESC(device_cnt, "The number of character devices to create");

module_param(verbose, byte, 0444);
MODULE_PARM_DESC(verbose, "Whether the driver should be verbose or not");


global_data_t g_vars = {0, 0};

inline size_t
get_device_count(void)
{
    return g_vars.device_count;
}

inline uint8_t
is_verbose(void)
{
    return g_vars.verbose != 0;
}

inline void
plog(char* fmt, ...)
{
    va_list args = {{0}};

    if (! is_verbose())
        return;

    va_start(args, fmt);
    vprintk(fmt, args);
    va_end(args);

    return;
}

static signed int __init
nb_init(void)
{
    signed int      ret         = 0;

    g_vars.device_count = device_cnt;
    g_vars.verbose      = verbose;

    if (device_cnt < 1) {
        ERR("Invalid number of devices requested: %u\n", device_cnt);
        return -EINVAL;
    }

    ret = nbd_char_init();

    if (0 > ret) {
        ERR("Failed to initialize character device\n");
        return ret;
    }
    ret = nbd_net_init();

    if (0 > ret) {
        ERR("Failed to initialize network components");
        return ret;
    }

    INF("Successfully inserted module.\n");
    return 0;
}

static void __exit
nb_exit(void)
{
    signed int ret = 0;

    ret = nbd_net_destroy();

#ifdef DEBUG
    if (0 > ret)
        ERR("Failed to properly deinitialize network components.\n");
#endif

    ret = nbd_char_destroy();

#ifdef DEBUG
    if (0 > ret)
        ERR("Failed to properly deinitialize character device.\n");
#endif

    INF("Successfully removed module from kernel.\n");
    return;
}

module_init(nb_init);
module_exit(nb_exit);
