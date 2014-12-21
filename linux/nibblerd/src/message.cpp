#include "message.hpp"

ip_addr_t::ip_addr_t(void) : type(ADDRESS_INVALID_TYPE), mask(0)
{
	::memset(&this->addr.v6, 0, sizeof(struct in6_addr));
	return;
}

ip_addr_t::ip_addr_t(struct in_addr& a, uint8_t m) : type(ADDRESS_IPV4_TYPE), mask(m)
{
	if (32 < m)
		throw std::runtime_error("Invalid IPv4 netmask specified");

	::memcpy(&this->addr.v4, &a, sizeof(struct in_addr));
	return;
}

ip_addr_t::ip_addr_t(struct in6_addr& a, uint8_t m) : type(ADDRESS_IPV6_TYPE), mask(m)
{
	if (128 < m)
		throw std::runtime_error("Invalid IPv6 netmask specified");

	::memcpy(&this->addr.v6, &a, sizeof(struct in6_addr));
	return;
}

ip_addr_t::~ip_addr_t(void) 
{
	type = ADDRESS_INVALID_TYPE;
	mask = 0;
	::memset(&this->addr.v6, 0, sizeof(struct in6_addr));
	return;
}

void 
ip_addr_t::set_address(struct in_addr& a, uint8_t m)
{
	type = ADDRESS_IPV4_TYPE;
	mask = m;

	if (32 < m)
		throw std::runtime_error("Invalid IPv4 netmask specified");

	::memset(&this->addr.v6, 0, sizeof(struct in6_addr));
	::memcpy(&this->addr.v4, &a, sizeof(struct in_addr));
	return;
}

void
ip_addr_t::set_address(struct in6_addr& a, uint8_t m)
{
	type = ADDRESS_IPV6_TYPE;
	mask = m;

	if (128 < m)
		throw std::runtime_error("Invalid IPv6 netmask specified");

	::memcpy(&this->addr.v6, &a, sizeof(struct in6_addr));
	return;
}

std::vector< uint8_t >
ip_addr_t::data(void)
{
	std::vector< uint8_t > 	data;
	std::size_t				idx(0);

	data.push_back(type);
	data.push_back(mask);
	idx = data.size();

	//if (ADDRESS_IPV6_TYPE == type) {
		data.resize(data.size() + sizeof(in6_addr));
		::memcpy(data.data()+idx, &this->addr.v6, sizeof(in6_addr));
	/*} else {
		data.resize(data.size() + sizeof(in_addr));
		::memcpy(data.data()+idx, &this->addr.v4, sizeof(in_addr));
	}*/

	return data;
}

inline bool
message_t::is_valid_idx(std::size_t idx, std::size_t max, std::size_t off)
{
	std::size_t noff(0);

	if (idx >= SIZE_MAX - off)
		return false;

	noff = idx+off;
	return noff < max;
}

bool
message_t::parse_ports(std::vector< uint8_t >& buf, std::size_t& idx)
{
	const std::size_t   max = buf.size();
	uint16_t            cnt = 0;

	if (idx >= max) {
		throw std::runtime_error("parse_ports() idx >= max");
		return false;
	}

	if (! is_valid_idx(idx, max, sizeof(uint16_t))) {
		throw std::runtime_error("is_valid_idx() sizeof(uint16_t)");
		return false;
	}

	cnt = *reinterpret_cast< uint16_t* >(m_buf.data()+idx);
	cnt = ::ntohs(cnt);
	idx += sizeof(uint16_t);

	if (0 == cnt) {
		throw std::runtime_error("0 == cnt");
		return false;
	}

	for (std::size_t cidx = 0; cidx < cnt; cidx++) {
		std::size_t     off     = idx+(cidx*(sizeof(port_proto_t)+sizeof(uint16_t)));
		port_proto_t    proto   = 0;
		uint16_t        port    = 0;

		if (! is_valid_idx(idx, max, (cidx*sizeof(port_proto_t)+sizeof(uint16_t)))) {
			m_addrs.clear();
			m_ports.clear();
			throw std::runtime_error("is_valid_idx() for(...)");
			return false;
		}

		proto   = *reinterpret_cast< port_proto_t* >(m_buf.data()+off);
		off     += sizeof(port_proto_t);
		port    = *reinterpret_cast< uint16_t* >(m_buf.data()+off);
		off		+= sizeof(uint16_t);

		if (PORT_PROTO_TCP == proto)
			m_ports.push_back(port_t(proto, port));
		else if (PORT_PROTO_UDP == proto)
			; // XXX JF FIXME - skipping UDP for now
		else {
			m_addrs.clear();
			m_ports.clear();
			throw std::runtime_error("invalid protocol encountered, off: " + std::to_string(off - sizeof(port_proto_t)));
			return false;
		}
	}

	return true;
}

bool
message_t::parse_addresses(std::vector< uint8_t >& buf, std::size_t& idx)
{
	const std::size_t   max = buf.size();
	uint32_t            cnt = 0;

	if (! is_valid_idx(idx, max, sizeof(uint32_t))) 
		return false;

	cnt =   *reinterpret_cast< uint32_t* >(m_buf.data()+idx);
	cnt =   ::ntohl(cnt);
	idx +=  sizeof(uint32_t);

	if (USHRT_MAX < cnt) 
		return false;

	// XXX JF CHECKME
	if (cnt > SIZE_MAX / sizeof(ip_addr_t)) 
		return false;

	for (uint32_t cidx = 0; cidx < cnt; cidx++) {
		std::size_t 	off     = idx+(cidx*(sizeof(struct in6_addr)+sizeof(addr_type_t)+sizeof(uint8_t)));
		addr_type_t 	type    = ADDRESS_INVALID_TYPE;
		uint8_t     	mask    = 0;
		struct in_addr	v4addr	= {0};
		struct in6_addr	v6addr	= {0};

		if (! is_valid_idx(idx, max, off)) {
			m_addrs.clear();
			return false;
		}

		type    =   *reinterpret_cast< addr_type_t* >(m_buf.data()+off);
		off     +=  sizeof(addr_type_t);
		mask    =   m_buf.at(off);
		off     +=  sizeof(uint8_t);
		
		switch (type) {
			case ADDRESS_IPV4_TYPE:
				::memset(&v4addr, 0, sizeof(struct in_addr));
				::memcpy(&v4addr, m_buf.data()+off, sizeof(struct in_addr));
				m_addrs.push_back(ip_addr_t(v4addr, mask));
				break;

			case ADDRESS_IPV6_TYPE:
				::memset(&v6addr, 0, sizeof(struct in6_addr));
				::memcpy(&v6addr, m_buf.data()+off, sizeof(struct in6_addr));
				m_addrs.push_back(ip_addr_t(v6addr, mask));
				break;

			default:
				m_addrs.clear();
				throw std::runtime_error("invalid address type encountered");
				return false;
		}
	}

	idx += cnt * (sizeof(struct in6_addr)+sizeof(addr_type_t)+sizeof(uint8_t));
	return true;
}

bool 
message_t::parse(void)
{
	std::lock_guard< std::mutex > 	lck(m_mutex);
	std::size_t 					idx(0);
	const std::size_t				max(m_buf.size());
	uint32_t						hcnt(0);

	if (m_buf.empty() || MIN_MSG_SZ > max)
		return false;

	m_command 	= 	static_cast< op_type_t >(m_buf.at(idx));
	idx 		+= 	sizeof(op_type_t);

	switch (m_command) {
		case OP_START_SCAN:
			if (false == parse_addresses(m_buf, idx))
				return false;

			idx += hcnt*(sizeof(struct in6_addr)+sizeof(addr_type_t)+sizeof(uint8_t));

			if (false == parse_ports(m_buf, idx))
				return false;

			break;

		case OP_STOP_SCAN:
			if (! is_valid_idx(idx, max, sizeof(uint64_t)))
					return false;

			m_id = *reinterpret_cast< uint64_t* >(m_buf.data()+idx);
			break;

		case OP_SCAN_STATUS:
			if (! is_valid_idx(idx, max, sizeof(uint64_t)))
				return false;

			m_id = *reinterpret_cast< uint64_t* >(m_buf.data()+idx);
			break;

		default:
			break;
	}

	return true;
}

message_t::message_t(void) 
{
	return;
}

message_t::message_t(std::vector< uint8_t >& buf) : m_buf(buf), m_id(0) 
{ 
	if (false == parse()) 
		throw std::runtime_error("Error while parsing message buffer");

	return;
}

message_t::message_t(std::vector< ip_addr_t >& v, std::vector< port_t >& p) : 	m_command(OP_START_SCAN), 
																				m_addrs(v), m_ports(p), m_id(0)
{
	return;
}

message_t::message_t(op_type_t type, uint64_t id) : m_command(type), m_id(id)
{
	if (OP_STOP_SCAN != type && OP_SCAN_STATUS != type) 
		throw std::runtime_error("Invalid scan type specified for constructor");

	return;
}

message_t::~message_t(void) 
{
	std::lock_guard< std::mutex > lck(m_mutex);

	m_addrs.clear();
	m_buf.clear();
	return; 
}

bool 
message_t::parse_data(std::vector< uint8_t >& buf)
{
	m_buf = buf;

	return parse();
}

std::vector< uint8_t >
message_t::data(void)
{
	std::vector< uint8_t > 	data;
	std::size_t				idx(0);
	uint32_t				len(0);
	uint16_t				plen(0);

	data.push_back(m_command);
	idx += sizeof(m_command);

	switch (m_command) {
		case OP_START_SCAN:
			len = m_addrs.size();
			len = ::htonl(len);
			data.resize(data.size() + sizeof(uint32_t));
			::memcpy(data.data()+idx, &len, sizeof(uint32_t));
			idx += sizeof(uint32_t);

			for (std::size_t off = 0; off < m_addrs.size(); off++) { 
				std::vector< uint8_t > tmp(m_addrs.at(off).data());
				
				data.insert(data.end(), tmp.begin(), tmp.end());
				idx += tmp.size();
			}

			if (USHRT_MAX < m_ports.size()) 
				throw std::runtime_error("Invalid amount of ports (> USHRT_MAX)");

			
			plen = static_cast< uint16_t >(m_ports.size());
			plen = ::htons(plen);
			data.resize(data.size() + sizeof(uint16_t));
			::memcpy(data.data()+idx, &plen, sizeof(uint16_t));

			for (std::size_t off = 0; off < m_ports.size(); off++) {
				std::vector< uint8_t > tmp(m_ports.at(off).data());
				data.insert(data.end(), tmp.begin(), tmp.end());
			}

			break;

		case OP_STOP_SCAN:
		case OP_SCAN_STATUS:
			
			data.resize(data.size() + sizeof(uint64_t));
			::memcpy(data.data()+idx, &m_id, sizeof(uint64_t));
			break;

		default:

			throw std::runtime_error("Invalid or unknown command type encountered");
			break;
	}

	return data;
}

