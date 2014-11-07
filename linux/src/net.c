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


static signed int
tx_skb(struct sk_buff* skb)
{
	struct netdev_queue*    txq     	= NULL;
	struct net_device*		dev			= NULL;
	signed int				ret			= 0;
	netdev_features_t 		features	= 0;

	DBG("entered");

	if (NULL == skb || NULL == skb->dev || 
		NULL == skb->dev->netdev_ops || 
		NULL == skb->dev->netdev_ops->ndo_start_xmit) {
		kfree_skb(skb);
		DBG("exited -EINVAL");
		return -EINVAL;
	}
	dev = skb->dev;

	if (unlikely(!netif_running(dev) || !netif_carrier_ok(dev))) {
		kfree_skb(skb);
		DBG("exited -ENETDOWN");
		return -ENETDOWN;
	}

	features = netif_skb_features(skb);

	/* XXX ??
     * Reading through the source briefly, i think
     * we will always avoid this branch because we
     * never deal with fragments.
     *
     * Leaving in place 'just in case though'
 	 */
	 if (skb_needs_linearize(skb, features) && __skb_linearize(skb)) {
		//atomic_long_inc(&dev->tx_dropped);
		kfree_skb(skb);
		DBG("exited -ECANCELED");
		return -ECANCELED;
	}

	txq = netdev_get_tx_queue(skb->dev, skb_get_queue_mapping(skb));

	local_bh_disable();
	HARD_TX_LOCK(dev, txq, get_cpu()); 

	if (unlikely(netif_xmit_frozen_or_stopped(txq))) {
		HARD_TX_UNLOCK(dev, txq);
		put_cpu();
		local_bh_enable();
		DBG("exited -EAGAIN");
		return -EAGAIN;
	}

	ret = dev_queue_xmit(skb);
    //ret = dev->netdev_ops->ndo_start_xmit(skb, dev);

    switch (ret) {
        case NETDEV_TX_OK:		
			txq_trans_update(txq);
			ret = 0;
            break;

        case NET_XMIT_DROP:
			atomic_long_inc(&dev->tx_dropped);
			/* SKB was consumed apparently? */
			/* Many code paths seem to kfree_skb()
 			 * before returning this. So that seems
 			 * like a safe assumption that this is 
 			 * generally/always the case */
			ret = -ECANCELED;
            break;

        case NET_XMIT_CN:
            /* We are not dropping packets yet
 			 * but will be soon. 
 			 */
			ret = -EDQUOT;
			txq_trans_update(txq);
			break;
        
		case NET_XMIT_POLICED:
    	default: 
	       /* The comments in the header for this
 			 * literally say the skb was shot by 
 			 * the police. I'm not even sure what
 			 * that means exactly.
 			 */

			/* The only places this is used in
 			 * 3.17 is in the packet scheduler
 			 * as a default initializer value that
 			 * is *never* returned, and in the batman
 			 * mesh protocol code. As such, we should
 			 * never see this really?
 			 *
 			 * We can discern how to treat this via 
 			 * dev_xmit_complete(), and if the SKB
 			 * was not consumed we treat it as the
 			 * same as the device being busy/etc.
 			 */

			if (! dev_xmit_complete(ret)) {
				ret = -EAGAIN;
				break;
			}
	
			ret = -ECOMM;
			atomic_long_inc(&dev->tx_dropped);
			break;
        
		case NETDEV_TX_LOCKED:
        case NETDEV_TX_BUSY:
			ret = -EAGAIN;
            break;
    }

	HARD_TX_UNLOCK(dev, txq);
	put_cpu();
	local_bh_enable();
	DBG("exited %d", ret);
	return ret;
}

static signed int
get_ipv4_hw_dest(uint32_t dest, net_hw_t* hw_dest, struct net_device** devo, struct rtable** rto)
{
    struct net*         net = NULL;
    struct net_device*  dev = NULL;
    struct rtable*      rt  = NULL;
    struct neighbour*   ne  = NULL;
    uint32_t            nh  = 0;

	DBG("entered");

    if (NULL == hw_dest) {
        ERR("Provided invalid NULL parameter");
		DBG("enxited -EINVAL");
        return -EINVAL;
    }

    rtnl_lock();
    for_each_net(net) {
        if (NULL == net)
            continue;

        rt = ip_route_output(net, dest, 0, RT_TOS(IPTOS_LOWDELAY), 0);

        if (NULL != rt)
            break;
    }

    if (NULL == rt || NULL == rt->dst.dev) {
        rtnl_unlock();
		ERR("Could not find a suitable route to the destination host");
		DBG("exited -EHOSTUNREACH"); 
		return -EHOSTUNREACH;
    }

    dev = rt->dst.dev;
    dev_hold(rt->dst.dev);
    get_net(net);
    rtnl_unlock();

    hw_dest->hw_addr = kzalloc(dev->addr_len, GFP_ATOMIC);

    if (NULL == hw_dest->hw_addr) {
        ERR("Error allocating destination hardware address memory");
        dev_put(dev);
        put_net(net);
        ip_rt_put(rt);
		DBG("exited -ENOMEM");
        return -ENOMEM;
    }

	ALO("hw_dest->hw_addr: %p %u bytes", hw_dest->hw_addr, dev->addr_len);
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
			FRE("hw_addr->hw_addr: %p", hw_dest->hw_addr);
			kfree(hw_dest->hw_addr);
			hw_dest->hw_addr = NULL;
			DBG("exited %d", PTR_ERR(ne));

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

	DBG("exited 0");
    return 0;
}

static struct sk_buff*
init_ipv4_skb(uint32_t addr, uint16_t dest, uint16_t source)
{
    net_hw_t                dhw     = {NULL,0};
    struct iphdr*           iph     = NULL;
    struct tcphdr*          tcph    = NULL;
    struct net_device*      dev     = NULL;
    struct sk_buff*         skb     = NULL;
    struct rtable*          rt      = NULL;
    size_t                  len     = 0;
    size_t                  res     = 0;
    size_t                  tlen    = 0;
//  const size_t            plen    = 8;
    signed int              ret     = 0;
//  uint8_t*                opts    = "\x02\x04\x05\xb4\x04\x02\x08\x0a\x00\x61\x29\x7c\x00\x00\x00\x00\x01\x03\x03\x07";
//  const size_t            plen    = 20;
//  uint8_t*                ptr     = NULL;
    ret = get_ipv4_hw_dest(addr, &dhw, &dev, &rt);

	DBG("entered");

    if (0 > ret) {
		if (NULL != dhw.hw_addr) {
			FRE("dhw.hw_addr %p", dhw.hw_addr);
			dhw.hw_addr = NULL;
		}

		DBG("exited NULL");
        return NULL;
	}

    res     = LL_RESERVED_SPACE(dev);
    tlen    = dev->needed_tailroom;
    len     = res + tlen + sizeof(struct iphdr) + sizeof(struct tcphdr); //+ plen;

    if (len > dev->mtu) { // ?? dev->mtu + res ??
        ERR("Length exceeds device MTU ...?");
        goto err;
    }

    DBG("Routing outbound packets through device %s", dev->name);

    skb = alloc_skb(len, GFP_ATOMIC);

    if (NULL == skb) {
        ERR("Error allocating sk_buff structure");
        goto err;
    }

    skb->ip_summed      = CHECKSUM_NONE;
    skb->dev            = dev;
    skb->protocol       = ETH_P_IP; 
    skb->priority       = TC_PRIO_CONTROL;

	// For loopback traffic this appears to 
	// have to be PACKET_HOST or else it seems
	// to get dropped by a kernel filter?
	// Inversely, for real devices it needs
	// to be PACKET_OUTGOING.
	// Amusingly, this would imply that the
	// pktgen.c code in the kernel is not
	// routinely used other than with loopback
	// traffic? It's not 100% clear that the
	// packet doesn't actually go out, it just
	// doesn't show up in tcpdump et al, which
	// despite some mailing list conjectures it
	// should. It's also possible that the code
	// in the mainline kernel is purposefully 
	// broken to "prevent" people from using it
	// to DoS others. 
    skb->pkt_type       = PACKET_HOST; //OUTGOING;

    skb_dst_set(skb, &rt->dst);
    skb_set_queue_mapping(skb, get_cpu()); // ??
    skb_reserve(skb, len);
    skb_set_mac_header(skb, 0);

    ret = dev_hard_header(skb, dev, ETH_P_IP, dhw.hw_addr, dev->dev_addr, skb->len);

    if (0 > ret) {
        kfree_skb(skb);
        ERR("Error creating hardware header in dev_hard_header()");
        goto err;
    }

	FRE("dhw.hw_addr: %p", dhw.hw_addr);

	kfree(dhw.hw_addr);
	dhw.hw_addr = NULL;

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
    iph->frag_off   = cpu_to_be16(IP_DF);
    iph->tot_len    = cpu_to_be16(sizeof(struct iphdr) + sizeof(struct tcphdr)); //+plen);
    iph->check      = 0;

	get_random_bytes(&iph->id, sizeof(iph->id));
	
	iph->check		= ip_fast_csum((void*)iph, iph->ihl);

    tcph->ack_seq = 0;
    //((u_int8_t *)tcph)[13] = 0;
    tcph->dest = dest;
    tcph->source = source;
    tcph->syn = 1;
    tcph->rst = 0;
    tcph->ack = 0;
    tcph->urg_ptr = 0;
    tcph->check = 0;
    tcph->doff = (sizeof(struct tcphdr))/4; //+plen)/4;

	get_random_bytes(&tcph->seq, sizeof(tcph->seq));
	get_random_bytes(&tcph->window, sizeof(tcph->window));

	if (128 > cpu_to_be16(tcph->window))
		tcph->window = cpu_to_be16(128);

    skb->ip_summed	= CHECKSUM_NONE;
    tcph->check 	= tcp_v4_check(sizeof(struct tcphdr)/*+plen*/, iph->saddr, iph->daddr,
								csum_partial((char*)tcph, sizeof(struct tcphdr)/*+plen*/, 0));

	DBG("exited skb");
    return skb;

err:
	FRE("dhw.hw_addr: %p", dhw.hw_addr);
	kfree(dhw.hw_addr);
	dhw.hw_addr = NULL;

    dev_put(dev);
    ip_rt_put(rt);
	DBG("exited NULL");
    return NULL;
}

signed int
tx_init(pkt_data_t* pd)
{
	struct sk_buff* skb = NULL;
	uint32_t		cip	= 0;
	signed int 		ret = 0;

	DBG("entered");

	if (NULL == pd) {
		DBG("exited -EINVAL");
		return -EINVAL;
	}

	if (1 == atomic_read(&pd->started)) {
		DBG("exited 0");
		return 0;
	}

	atomic_set(&pd->started, 1);

	cip = pd->net_addr.ipv4.min.s_addr;

	set_current_state(TASK_INTERRUPTIBLE);

	while (1 == atomic_read(&pd->started) && !kthread_should_stop()) {
		if (cip >= pd->net_addr.ipv4.max.s_addr) {
			DBG("finished scan.");
			break;
		}

		skb = init_ipv4_skb(cpu_to_be32(cip++), 
							cpu_to_be16(pd->trans_addr.dest), 
							cpu_to_be16(pd->trans_addr.source));

		if (NULL == skb) {
			DBG("NULL skb.");
			goto tx_abort;
		}

		ret = tx_skb(skb);

		switch (ret) {
			case -ECANCELED:
				DBG("Dropped packet to %#x", --cip);
				break;
			case -EAGAIN:
				DBG("Other transient error while sending to %#x", --cip);
		        atomic_dec(&skb->users);
		        dev_put(skb->dev);
		        kfree_skb(skb);
				break;

			case -EDQUOT:
				DBG("Will start dropping packets soon at %#x", cip);
				break;
			case -EINVAL:
			case -ENETDOWN:
				DBG("Initialization/etc error while trying to send to %#x", --cip);
				goto tx_abort;
				break;
			default:
    		    atomic_dec(&skb->users);
		        dev_put(skb->dev);
		        kfree_skb(skb);
				break;
		}
		cond_resched(); 
	}

tx_abort:
	set_current_state(TASK_INTERRUPTIBLE);

	while (!kthread_should_stop()) {
		schedule();
		set_current_state(TASK_INTERRUPTIBLE);
	}

	set_current_state(TASK_RUNNING);

	DBG("exited 0");
	return 0;
}

static signed int
tx_destroy(pkt_data_t* pd)
{
	DBG("entered");

	if (NULL == pd) {
		DBG("exited -EINVAL");
		return -EINVAL;
	}

	atomic_set(&pd->started, 0);
	pd = NULL;
	
	DBG("exited 0");
	return 0;
}

static signed int
start_tx(void)
{
	pkt_data_t* 	pd = NULL;
	thread_data_t	td = {0};

	DBG("entered");

    mutex_lock(&m_data.lock);

    list_for_each_entry(pd, &m_data.head, list) {
		if (0 == atomic_read(&pd->started))  {
			td.name 		= "knibbler_tx/%u";
			td.ops.init		= (signed int(*)(void*))&tx_init;
			td.ops.destroy	= (signed int(*)(void*))&tx_destroy;
			td.data			= (void*)pd;
		
			if (0 > nbd_thread_start(&td)) 
				ERR("Error starting TX thread...");

		}
	}

	mutex_unlock(&m_data.lock);
	DBG("exited 0");
	return 0;
}

signed int
nbd_net_add(nb_dev_t* nbd)
{
    pkt_data_t*	pd  = NULL;
    size_t     	cnt = 0;

	DBG("entered");

    if (NULL == nbd) {
		DBG("exited -EINVAL");
        return -EINVAL;
	}

    pd = vzalloc(sizeof(pkt_data_t));

    if (NULL == pd) {
		DBG("exited -ENOMEM");
        return -ENOMEM;
	}

    ALO("pkt_data_t pointer %p len %lu", pd, sizeof(pkt_data_t));

    mutex_lock(&nbd->mutex);

    if (NULL != nbd->pkt) {
        mutex_unlock(&nbd->mutex);
		DBG("exited -EINVAL");
        return -EINVAL;
    }

    if (TYPE_IPV4 != nbd->ndata.type) {
        ERR("IPV6 Support currently unimplemented.");
        FRE("pkt_data_t pointer %p", pd);
        vfree(pd);
        mutex_unlock(&nbd->mutex);
		DBG("exited -EINVAL");
        return -EINVAL;
    }

    pd->net_addr.ipv4.min.s_addr    = nbd->ndata.net.ipv4;
    pd->net_addr.ipv4.max.s_addr    = nbd->ndata.net.ipv4 + (1 << (32 - nbd->ndata.mask));
    pd->trans_addr.source           = nbd->ndata.sport;
    pd->trans_addr.dest             = nbd->ndata.dport;
    pd->data                        = nbd->data;
    pd->len                         = nbd->udlen;
	
    nbd->pkt                		= pd;

    mutex_unlock(&nbd->mutex);

	atomic_set(&pd->started, 0);

    mutex_lock(&m_data.lock);
    list_add_tail(&pd->list, &m_data.head);
    m_data.count += 1;
    cnt = m_data.count;
    mutex_unlock(&m_data.lock);

    if (1 == m_data.count) 
        start_rx();

	start_tx();
	DBG("exited 0");
    return 0;
}

signed int
nbd_net_del(pkt_data_t* pd)
{
    size_t cnt = 0;

	DBG("entered");

    if (NULL == pd) {
		DBG("exited -EINVAL");
        return -EINVAL;
	}

    mutex_lock(&m_data.lock);

    if (0 == m_data.count) {
        mutex_unlock(&m_data.lock);
		DBG("exited -EINVAL");
        return -EINVAL;
    }

    list_del(&pd->list);
    m_data.count -= 1;
    cnt = m_data.count;

    mutex_unlock(&m_data.lock);

    if (0 == cnt) {
        stop_rx();
	}

	(void)nbd_thread_del(pd->id);
	FRE("Releasing pkt_data_t pointer: %p", pd);
	pd->data = NULL;
	vfree(pd);
	pd = NULL;

	DBG("exited 0");
    return 0;
}

static void
start_rx(void)
{
	DBG("entered");
    dev_add_pack(&ipv4_pkt_type);
	DBG("exited (void)");
    return;
}

static void
stop_rx(void)
{
	DBG("entered");
    dev_remove_pack(&ipv4_pkt_type);
	DBG("exited (void)");
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
    pkt_data_t*		pd      = NULL;
    struct iphdr*  	iph     = NULL;
    struct tcphdr*	tcph    = NULL;

	DBG("entered");

	if (PACKET_HOST != s->pkt_type) {
		DBG("exited NET_RX_SUCCESS");
		return NET_RX_SUCCESS;
	}

    // well.. its not for us, that is for certain.
    if (unlikely(s->len < sizeof(struct iphdr)+sizeof(struct tcphdr))) {
		DBG("exited NET_RX_SUCCESS");
        return NET_RX_SUCCESS;
	}

    iph     = ip_hdr(s);
    tcph    = tcp_hdr(s);

    mutex_lock(&m_data.lock);

    list_for_each_entry(pd, &m_data.head, list) {
			uint16_t sport = pd->trans_addr.source;
			uint16_t dport = pd->trans_addr.dest;
		    uint32_t min = pd->net_addr.ipv4.min.s_addr;
			uint32_t max = pd->net_addr.ipv4.max.s_addr;

        if (TYPE_IPV4 == pd->type && IPPROTO_TCP == iph->protocol) {
			if (min <= cpu_to_be32(iph->saddr) && max >= cpu_to_be32(iph->saddr)) {
				if (0 == tcph->rst && 1 == tcph->syn && 1 == tcph->ack) {
                	if (likely(sport == cpu_to_be16(tcph->dest) && dport == cpu_to_be16(tcph->source))) {
                	    uint32_t cnt = cpu_to_be32(iph->saddr) - pd->net_addr.ipv4.min.s_addr;
                	    uint32_t byte = cnt / 8;
                	    uint32_t bit =  cnt % 8;

						printk(KERN_INFO "NIBBLER[DBG]: MATCHED %#x\n", cpu_to_be32(iph->saddr));
                    	SET_BIT(pd->data, byte, bit);
                    	mutex_unlock(&m_data.lock);
                    	skb_orphan(s);
                    	kfree_skb(s);
						DBG("exited NET_RX_SUCCESS");
                    	return NET_RX_SUCCESS;
                	}
        		}
			}
		}
    }

    mutex_unlock(&m_data.lock);
	DBG("exited NET_RX_SUCCESS");
    return NET_RX_SUCCESS;
}

signed int
nbd_net_init(void)
{
	DBG("entered");
    mutex_init(&m_data.lock);
    INIT_LIST_HEAD(&m_data.head);
    DBG("exited 0");
    return 0;
}

signed int
nbd_net_destroy(void)
{
    pkt_data_t*	cur     = NULL;
    pkt_data_t*	next    = NULL;

	DBG("entered");
    mutex_lock(&m_data.lock);

    list_for_each_entry_safe(cur, next, &m_data.head, list) {
        list_del(&cur->list);
        FRE("pkt_data_t pointer %p", cur);
        vfree(cur);
        cur = NULL;
    }

    mutex_unlock(&m_data.lock);
    mutex_destroy(&m_data.lock);

	DBG("exited 0");
    return 0;
}
