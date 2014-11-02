#include <nbd/global.h>
#include <nbd/net.h>
#include <nbd/dev.h>
#include <nbd/bitops.h>

static signed int ipv4_pkt_handler( struct sk_buff*,
                                    struct net_device*,
                                    struct packet_type*,
                                    struct net_device*);

//static signed int ipv6_pkt_handler( struct sk_buff*,
//                                  struct net_device*, 
//                                  struct packet_type*, 
//                                  struct net_device*);

static void start_rx(void);
static void stop_rx(void);

static struct packet_type ipv4_pkt_type = {
    .type = cpu_to_be16(ETH_P_IP),
    .func = &ipv4_pkt_handler
};

//static struct packet_type ipv6_pkt_type = {
//  .type = cpu_to_be16(ETH_P_IP6),
//  .func = &ipv6_pkt_handler
//};

static pkt_metadata_t m_data = {{{0}},{0},0};

typedef struct {
    void*       hw_addr;
    size_t      hw_length;
} net_hw_t;

signed int
get_ipv4_hw_dest(uint32_t dest, net_hw_t* hw_dest, struct net_device** devo, struct rtable** rto)
{
    struct net*         net = NULL;
    struct net_device*  dev = NULL;
    struct rtable*      rt  = NULL;
    struct neighbour*   ne  = NULL;
    uint32_t            nh  = 0;

    if (NULL == hw_dest) {
        ERR("Provided invalid NULL parameter\n");
        return -EINVAL;
    }

    INF("DEST: %#x\n", dest);

    rtnl_lock();
    for_each_net(net) {
        if (NULL == net)
            continue;

        rt = ip_route_output(net, dest, 0, RT_TOS(IPTOS_LOWDELAY), 0);

        if (NULL != rt)
            break;
    }

    if (NULL == rt || NULL == rt->dst.dev) {
        ERR("Could not find a suitable route to the destination host\n");
        rtnl_unlock();
        return -EHOSTUNREACH;
    }

    dev = rt->dst.dev;
    dev_hold(rt->dst.dev);
    get_net(net);
    rtnl_unlock();

    hw_dest->hw_addr = kzalloc(dev->addr_len, GFP_ATOMIC);

    if (NULL == hw_dest->hw_addr) {
        ERR("Error allocating destination hardware address memory\n");
        dev_put(dev);
        put_net(net);
        ip_rt_put(rt);
        return -ENOMEM;
    }

    hw_dest->hw_length = dev->addr_len;

    rcu_read_lock_bh();

    nh = rt_nexthop(rt, dest);
    ne = __ipv4_neigh_lookup_noref(dev, nh);

    if (unlikely(NULL == ne)) {
        ne = __neigh_create(&arp_tbl, &nh, dev, false);

        if (IS_ERR(ne)) {
            ip_rt_put(rt);
            dev_put(dev);
            put_net(net);
            rcu_read_unlock_bh();
            return PTR_ERR(ne);
        }
    }
    rcu_read_unlock_bh();
    neigh_ha_snapshot(hw_dest->hw_addr, ne, dev);

    if (NULL != devo)
            *devo = dev;
    else
        dev_put(dev);

    if (NULL != rto)
            *rto = rt;
    else
        ip_rt_put(rt);

    return 0;
}

signed int
init_ipv4_skb(uint32_t addr, uint16_t dest, uint16_t source)
{
    net_hw_t                dhw     = {NULL,0};
    struct iphdr*           iph     = NULL;
    struct tcphdr*          tcph    = NULL;
    struct net_device*      dev     = NULL;
    struct sk_buff*         skb     = NULL;
    struct rtable*          rt      = NULL;
    struct netdev_queue*    txq     = NULL;
    size_t                  len     = 0;
    size_t                  res     = 0;
    size_t                  tlen    = 0;
//  const size_t            plen    = 8;
    signed int              ret     = 0;
//  uint8_t*                opts    = "\x02\x04\x05\xb4\x04\x02\x08\x0a\x00\x61\x29\x7c\x00\x00\x00\x00\x01\x03\x03\x07";
//  const size_t            plen    = 20;
//  uint8_t*                ptr     = NULL;
    ret = get_ipv4_hw_dest(addr, &dhw, &dev, &rt);

    if (0 > ret)
        return ret;

    res     = LL_RESERVED_SPACE(dev);
    tlen    = dev->needed_tailroom;
    len     = res + tlen + sizeof(struct iphdr) + sizeof(struct tcphdr); //+ plen;

    if (len > dev->mtu) { // ?? dev->mtu + res ??
        ERR("Length exceeds device MTU ...?\n");
        ret = -EINVAL;
        goto err;
    }

    INF("Routing outbound packets through device %s\n", dev->name);

    skb = alloc_skb(len, GFP_ATOMIC);

    if (NULL == skb) {
        ERR("Error allocating sk_buff structure\n");
        ret = -ENOMEM;
        goto err;
    }

    skb_get(skb);

    skb->ip_summed      = CHECKSUM_NONE;
    skb->dev            = dev;
    skb->protocol       = ETH_P_IP; //IPPROTO_TCP;
    skb->priority       = TC_PRIO_CONTROL;
    skb->pkt_type       = PACKET_OUTGOING;

    skb_dst_set(skb, &rt->dst);
    //skb_set_queue_mapping(skb, smp_processor_id()); // ??
    skb_reserve(skb, len);
    skb_set_mac_header(skb, 0);

    ret = dev_hard_header(skb, dev, ETH_P_IP, dhw.hw_addr, dev->dev_addr, skb->len);

    if (0 > ret) {
        kfree_skb(skb);
        ERR("Error creating hardware header in dev_hard_header()\n");
        goto err;
    }

    skb_set_network_header(skb, skb->len);
    iph     = (struct iphdr*)skb_put(skb, sizeof(struct iphdr));

    skb_set_transport_header(skb, skb->len);
    tcph    = (struct tcphdr*)skb_put(skb, sizeof(struct tcphdr));

//  ptr = (uint8_t*)skb_put(skb, plen);
//  memcpy(ptr, opts, plen);

    iph->ihl        = 5;
    iph->version    = 4;
    iph->ttl        = 255;
    iph->tos        = IPTOS_LOWDELAY;
    iph->protocol   = IPPROTO_TCP;
    iph->saddr      = dev->ip_ptr->ifa_list->ifa_address;
    iph->daddr      = addr;
    iph->id         = cpu_to_be16(44139); // FIXME
    iph->frag_off   = cpu_to_be16(IP_DF);
    iph->tot_len    = cpu_to_be16(sizeof(struct iphdr) + sizeof(struct tcphdr)); //+plen);
    iph->check      = 0;
    iph->check      = ip_fast_csum((void *)iph, iph->ihl);

    tcph->seq = cpu_to_be32(1185973523);
    tcph->ack_seq = 0;
    ((u_int8_t *)tcph)[13] = 0;
    tcph->dest = dest;
    tcph->source = source;
    tcph->syn = 1;
    tcph->rst = 0;
    tcph->ack = 0;
    tcph->window = cpu_to_be16(29200);
    tcph->urg_ptr = 0;
    tcph->check = 0;
    tcph->doff = (sizeof(struct tcphdr))/4; //+plen)/4;


    skb->ip_summed      = CHECKSUM_NONE;
    tcph->check = tcp_v4_check(sizeof(struct tcphdr)/*+plen*/, iph->saddr, iph->daddr,
                                csum_partial((char*)tcph, sizeof(struct tcphdr)/*+plen*/, 0));

    txq = netdev_get_tx_queue(skb->dev, skb_get_queue_mapping(skb));

    __netif_tx_lock_bh(txq);
    atomic_inc(&skb->users);
    ret = dev->netdev_ops->ndo_start_xmit(skb, dev);
    atomic_dec(&skb->users);
    __netif_tx_unlock_bh(txq);

    switch (ret) {
        case NETDEV_TX_OK:
            ERR("NET_TX_OK\n");
            break;
        case NET_XMIT_DROP:
            ERR("NET_XMIT_DROP\n");
            break;
        case NET_XMIT_CN:
            ERR("NET_XMIT_CN\n");
            break;
        case NET_XMIT_POLICED:
            ERR("NET_XMIT_POLICED\n");
            break;
        default:
            ERR("OTHER\n");
            break;
        case NETDEV_TX_LOCKED:
            ERR("NETDEV_TX_LOCKED\n");
            break;
        case NETDEV_TX_BUSY:
            ERR("NETDEV_TX_BUSY\n");
            kfree_skb(skb);
            break;
    }

    dev_put(dev);
    return 0;

err:
    dev_put(dev);
    ip_rt_put(rt);
    return ret;
}

signed int
nbd_net_add(nb_dev_t* nbd)
{
    pkt_data_t* pd  = NULL;
    size_t      cnt = 0;

    if (NULL == nbd)
        return -EINVAL;
    pd = kzalloc(sizeof(pkt_data_t), GFP_KERNEL);

    if (NULL == pd)
        return -ENOMEM;

    ALO("pkt_data_t pointer %p len %lu\n", pd, sizeof(pkt_data_t));

    mutex_lock(&nbd->mutex);

    if (NULL != nbd->pkt) {
        ERR("Error while adding packet data for device, it alread exists?\n");
        mutex_unlock(&nbd->mutex);
        return -EINVAL;
    }

    if (TYPE_IPV4 != nbd->ndata.type) {
        ERR("IPV6 Support currently unimplemented.\n");
        FRE("pkt_data_t pointer %p\n", pd);
        kfree(pd);
        mutex_unlock(&nbd->mutex);
        return -EINVAL;
    }

    pd->net_addr.ipv4.min.s_addr    = nbd->ndata.net.ipv4;
    pd->net_addr.ipv4.max.s_addr    = nbd->ndata.net.ipv4 + (1 << (32 - nbd->ndata.mask));
    pd->trans_addr.source           = nbd->ndata.sport;
    pd->trans_addr.dest             = nbd->ndata.dport;
    pd->data                        = nbd->data;
    pd->len                         = nbd->udlen;

    nbd->pkt                = pd;

    mutex_unlock(&nbd->mutex);

    mutex_lock(&m_data.lock);
    list_add_tail(&pd->list, &m_data.head);
    m_data.count += 1;
    cnt = m_data.count;
    mutex_unlock(&m_data.lock);

    if (1 == m_data.count)
        start_rx();

    return 0;
}

signed int
nbd_net_del(pkt_data_t* pd)
{
    size_t cnt = 0;

    if (NULL == pd)
        return -EINVAL;

    mutex_lock(&m_data.lock);

    if (0 == m_data.count) {
        mutex_unlock(&m_data.lock);
        return -EINVAL;
    }

    list_del(&pd->list);
    m_data.count -= 1;
    cnt = m_data.count;

    mutex_unlock(&m_data.lock);

    if (0 == cnt)
        stop_rx();

    return 0;
}

static void
start_rx(void)
{
    dev_add_pack(&ipv4_pkt_type);
    return;
}

static void
stop_rx(void)
{
    dev_remove_pack(&ipv4_pkt_type);
    return;
}

// we want this to be relatively fast and simple and return 
// pretty quickly the instant we know the packet is not for us
// this routine will be called for *every* ipv4 packet that
// not only comes to us, but crosses us on the network if 
// the device is in promisc mode, and of course multicast
// broadcast, etc. 
//
// after that, we sadly have to walk the entire list of 
// pkt_data_t structures-- one for each device that is
// currently scanning. For each IPV4 packet we receive
// we check to see if the source address was our destination
// address and if so then we check the source/dest port 
// pairs, and if those also match.. then we have a match.
// Then we subtract the source IP from the network address
// and calculate a byte offset and bit offset into the data
// and SET_BIT(), which is mapped into userspace. 
//
// If the packet was a response to ours, we have no further
// need to let the rest of the network stack process it. We
// orphan the sk_buff and destroy it/drop the packet.
static signed int
ipv4_pkt_handler(struct sk_buff* s, struct net_device* d, struct packet_type* p, struct net_device* o)
{
    pkt_data_t*     pd      = NULL;
    struct iphdr*   iph     = NULL;
    struct tcphdr*  tcph    = NULL;

    if (PACKET_HOST != s->pkt_type)
        return NET_RX_SUCCESS;

    // well.. its not for us, that is for certain.
    if (unlikely(s->len < sizeof(struct iphdr)+sizeof(struct tcphdr)))
        return NET_RX_SUCCESS;

    iph     = ip_hdr(s);
    tcph    = tcp_hdr(s);

    printk(KERN_ALERT "NIBBLER[RCV]: %#x:%hu %#x:%hu\n", iph->saddr, htons(tcph->source), iph->daddr, htons(tcph->dest));

    // ugh.. this would be so much less of a performance impact if we didnt {need, want} to 
    // support scanning more than one network at a time...
    mutex_lock(&m_data.lock);
    list_for_each_entry(pd, &m_data.head, list) {
        if (TYPE_IPV4 == pd->type ) {
            if (pd->net_addr.ipv4.min.s_addr <= iph->saddr && pd->net_addr.ipv4.max.s_addr >= iph->saddr)
                if (likely(pd->trans_addr.source == tcph->dest && pd->trans_addr.dest == tcph->source)) {
                    uint32_t cnt = iph->saddr - pd->net_addr.ipv4.min.s_addr;
                    uint32_t byte = cnt / 8;
                    uint32_t bit =  cnt % 8;

                    SET_BIT(pd->data, byte, bit);
                    mutex_unlock(&m_data.lock);
                    skb_orphan(s);
                    kfree_skb(s);
                    return NET_RX_SUCCESS;
                }
        }
    }

    mutex_unlock(&m_data.lock);
    return NET_RX_SUCCESS;
}

signed int
nbd_net_init(void)
{
    mutex_init(&m_data.lock);
    INIT_LIST_HEAD(&m_data.head);
    //start_rx();

    init_ipv4_skb(cpu_to_be32(0xd822b52d), cpu_to_be16(80), cpu_to_be16(41671));
     //0x7f000001),cpu_to_be16(80), cpu_to_be16(45733));    
    //stop_rx();
    return 0;
}

signed int
nbd_net_destroy(void)
{
    pkt_data_t* cur     = NULL;
    pkt_data_t* next    = NULL;

    //stop_rx();
    mutex_lock(&m_data.lock);

    list_for_each_entry_safe(cur, next, &m_data.head, list) {
        list_del(&cur->list);
        FRE("cur pointer %p\n", cur);
        kfree(cur);
        cur = NULL;
    }

    mutex_unlock(&m_data.lock);
    mutex_destroy(&m_data.lock);

    return 0;
}
