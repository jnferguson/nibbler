#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0xfa42c719, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0xa090cd28, __VMLINUX_SYMBOL_STR(cdev_alloc) },
	{ 0xdb998b83, __VMLINUX_SYMBOL_STR(cdev_del) },
	{ 0xecad82ad, __VMLINUX_SYMBOL_STR(kmalloc_caches) },
	{ 0xd2b09ce5, __VMLINUX_SYMBOL_STR(__kmalloc) },
	{ 0x305a9962, __VMLINUX_SYMBOL_STR(cdev_init) },
	{ 0x705fa2c9, __VMLINUX_SYMBOL_STR(_raw_spin_unlock) },
	{ 0x4f2bfeaa, __VMLINUX_SYMBOL_STR(mutex_destroy) },
	{ 0x79aa04a2, __VMLINUX_SYMBOL_STR(get_random_bytes) },
	{ 0xc7a4fbed, __VMLINUX_SYMBOL_STR(rtnl_lock) },
	{ 0x9c41a079, __VMLINUX_SYMBOL_STR(arp_tbl) },
	{ 0x9449e625, __VMLINUX_SYMBOL_STR(dst_release) },
	{ 0x6aacbe93, __VMLINUX_SYMBOL_STR(device_destroy) },
	{ 0xd3448b33, __VMLINUX_SYMBOL_STR(mutex_unlock) },
	{ 0x7485e15e, __VMLINUX_SYMBOL_STR(unregister_chrdev_region) },
	{ 0x999e8297, __VMLINUX_SYMBOL_STR(vfree) },
	{ 0x4629334c, __VMLINUX_SYMBOL_STR(__preempt_count) },
	{ 0x7a2af7b4, __VMLINUX_SYMBOL_STR(cpu_number) },
	{ 0x44f1033b, __VMLINUX_SYMBOL_STR(__put_net) },
	{ 0xba5b23ae, __VMLINUX_SYMBOL_STR(__neigh_create) },
	{ 0xcb8d000d, __VMLINUX_SYMBOL_STR(kthread_create_on_node) },
	{ 0x7d11c268, __VMLINUX_SYMBOL_STR(jiffies) },
	{ 0x6bb2de6a, __VMLINUX_SYMBOL_STR(__pskb_pull_tail) },
	{ 0xc671e369, __VMLINUX_SYMBOL_STR(_copy_to_user) },
	{ 0x6d2fc5a6, __VMLINUX_SYMBOL_STR(net_namespace_list) },
	{ 0x3744cf36, __VMLINUX_SYMBOL_STR(vmalloc_to_pfn) },
	{ 0xc7e3f4fe, __VMLINUX_SYMBOL_STR(current_task) },
	{ 0x7ca7f9b9, __VMLINUX_SYMBOL_STR(down_trylock) },
	{ 0xf2841cd2, __VMLINUX_SYMBOL_STR(__mutex_init) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0xb394067b, __VMLINUX_SYMBOL_STR(kthread_stop) },
	{ 0x3c3fce39, __VMLINUX_SYMBOL_STR(__local_bh_enable_ip) },
	{ 0xa1c76e0a, __VMLINUX_SYMBOL_STR(_cond_resched) },
	{ 0xbf8ba54a, __VMLINUX_SYMBOL_STR(vprintk) },
	{ 0xecd3b43, __VMLINUX_SYMBOL_STR(mutex_lock) },
	{ 0x4604a43a, __VMLINUX_SYMBOL_STR(mem_section) },
	{ 0xd51171fc, __VMLINUX_SYMBOL_STR(dev_remove_pack) },
	{ 0xe9a93a23, __VMLINUX_SYMBOL_STR(device_create) },
	{ 0x1e0ebb, __VMLINUX_SYMBOL_STR(cdev_add) },
	{ 0x40a9b349, __VMLINUX_SYMBOL_STR(vzalloc) },
	{ 0x9aa9441e, __VMLINUX_SYMBOL_STR(kmem_cache_alloc) },
	{ 0x6ea6a822, __VMLINUX_SYMBOL_STR(__alloc_skb) },
	{ 0xfab44189, __VMLINUX_SYMBOL_STR(netif_skb_features) },
	{ 0xdb7305a1, __VMLINUX_SYMBOL_STR(__stack_chk_fail) },
	{ 0x1000e51, __VMLINUX_SYMBOL_STR(schedule) },
	{ 0x1daf6437, __VMLINUX_SYMBOL_STR(kfree_skb) },
	{ 0xb81d4f5a, __VMLINUX_SYMBOL_STR(wake_up_process) },
	{ 0xf2adf149, __VMLINUX_SYMBOL_STR(_raw_spin_lock) },
	{ 0x4b899485, __VMLINUX_SYMBOL_STR(ip_route_output_flow) },
	{ 0x8779a34f, __VMLINUX_SYMBOL_STR(param_ops_byte) },
	{ 0xb3f7646e, __VMLINUX_SYMBOL_STR(kthread_should_stop) },
	{ 0x37a0cba, __VMLINUX_SYMBOL_STR(kfree) },
	{ 0x90e790a6, __VMLINUX_SYMBOL_STR(remap_pfn_range) },
	{ 0xd3e9983e, __VMLINUX_SYMBOL_STR(up) },
	{ 0x9e665923, __VMLINUX_SYMBOL_STR(class_destroy) },
	{ 0xca243129, __VMLINUX_SYMBOL_STR(dev_add_pack) },
	{ 0xe113bbbc, __VMLINUX_SYMBOL_STR(csum_partial) },
	{ 0x774e5a6e, __VMLINUX_SYMBOL_STR(dev_queue_xmit) },
	{ 0x317be3cf, __VMLINUX_SYMBOL_STR(skb_put) },
	{ 0xb5419b40, __VMLINUX_SYMBOL_STR(_copy_from_user) },
	{ 0x8d2e268b, __VMLINUX_SYMBOL_STR(param_ops_ulong) },
	{ 0x5a75f140, __VMLINUX_SYMBOL_STR(__class_create) },
	{ 0x6e720ff2, __VMLINUX_SYMBOL_STR(rtnl_unlock) },
	{ 0x29537c9e, __VMLINUX_SYMBOL_STR(alloc_chrdev_region) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "FCCEE12ACCA44DE9A203650");
