#ifndef HAVE_MESSAGE_T_HPP
#define HAVE_MESSAGE_T_HPP

#include <cstdint>
#include <climits>
#include <vector>
#include <mutex>
#include <stdexcept>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>

#define MIN_MSG_SZ (sizeof(uint64_t)+sizeof(uint8_t)) 
#define IPV6_ADDR_LEN (128/8)
#define IPV4_ADDR_LEN (32/8)

#define OP_START_SCAN 0
#define OP_STOP_SCAN 1
#define OP_SCAN_STATUS 2

#define ADDRESS_IPV4_TYPE 0xEE
#define ADDRESS_IPV6_TYPE 0xEF
#define ADDRESS_INVALID_TYPE 2

#define PORT_PROTO_TCP 0x0e 
#define PORT_PROTO_UDP 1
#define PORT_PROTO_INVALID 2

typedef uint8_t addr_type_t;
typedef uint8_t port_proto_t;
typedef uint8_t op_type_t;

inline std::string inet6_mask_string(uint8_t);
inline struct in6_addr inet6_mask_convert(uint8_t);
inline struct in6_addr inet6_lnaof(struct in6_addr&, uint8_t);

struct ip_addr_t { 

	addr_type_t type;
	uint8_t		mask;

	union {
		struct in_addr	v4;
		struct in6_addr	v6;
	} addr;

	ip_addr_t(void); 
	ip_addr_t(struct in_addr&, uint8_t m = 32);
	ip_addr_t(struct in6_addr&, uint8_t m = 128);

	~ip_addr_t(void); 

	void set_address(struct in_addr&, uint8_t m = 32);
	void set_address(struct in6_addr&, uint8_t m = 128);
	std::vector< uint8_t > data(void);
}; 

struct port_t {
	port_proto_t	proto;
	uint16_t		port;

	port_t(void) : port(80), proto(PORT_PROTO_TCP) { return; }
	port_t(uint16_t p) : port(p), proto(PORT_PROTO_TCP) { return; }
	port_t(port_proto_t r, uint16_t p) : port(p), proto(r) { return; }

	~port_t(void) { port = 0; proto = PORT_PROTO_INVALID; return; }

	std::vector< uint8_t > 
	data(void) 
	{ 
		std::vector< uint8_t > data;

		data.resize(sizeof(port_proto_t) + sizeof(uint16_t));
		::memcpy(data.data(), &proto, sizeof(port_proto_t));
		::memcpy(data.data()+sizeof(port_proto_t), &port, sizeof(uint16_t));
		return data;
	}
};

class message_t {
	private:
		std::mutex					m_mutex;
		std::vector< uint8_t >		m_buf;
		op_type_t					m_command;
		std::vector< ip_addr_t >	m_addrs;
		std::vector< port_t >		m_ports;
		uint64_t					m_id;

	protected:
		inline bool is_valid_idx(std::size_t, std::size_t, std::size_t);
		bool parse_ports(std::vector< uint8_t >&, std::size_t&);
		bool parse_addresses(std::vector< uint8_t >&, std::size_t&);
		bool parse(void);

	public:
		message_t(void);
		message_t(std::vector< uint8_t >&); 
		message_t(std::vector< ip_addr_t >&, std::vector< port_t >&);
		message_t(op_type_t, uint64_t);
		~message_t(void); 

		op_type_t command(void);
		uint64_t id(void);
		std::vector< ip_addr_t > addresses(void);
		std::vector< port_t > ports(void);

		bool parse_data(std::vector< uint8_t >&);
		std::vector< uint8_t > data(void);
};

#endif
