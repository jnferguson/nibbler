#ifndef HAVE_GLOBALS_HPP
#define HAVE_GLOBALS_HPP

//#include "mdiWin.h"
#include <QString>
#include <QSettings>

#include <cstdint>
#include <cstddef>

const char* org(void);
const char* url(void);
const char* app(void);

QSettings* getSettings(void);
//mdiWin_t& getTopWindow(void);

#pragma pack(push,1)
#define CMD_SCAN 0x00
#define CMD_STATUS 0x01
#define CMD_RESULTS 0x02

#define DATAGRAM_MAGIC 0x22221010
#define VERSION_IPV4 0x00
#define VERSION_IPV6 0x01

typedef struct _network_addr_t
{
	uint32_t	address;
	uint8_t		netmask;

	_network_addr_t(void) : address(0), netmask(0) { return; }
	_network_addr_t(uint32_t a) : address(a), netmask(32) { return; }
	_network_addr_t(uint32_t a, uint8_t m) : address(a), netmask(m) { return; }
	~_network_addr_t(void) { address = 0; netmask = 0; return; }

} network_addr_t;

typedef struct _network_address_vector_t
{
	uint32_t		count;
	network_addr_t	networks[ 1 ];
} network_address_vector_t;

typedef struct _network_ports_vector_t
{
	uint32_t	count;
	uint16_t	ports[ 1 ];
} network_ports_vector_t;

// XXX JF FIXME - packed


typedef struct _datagram_t
{
	uint32_t					magic;
	uint8_t						cmd;
	uint8_t						ver;
	uint16_t					cnt;
	uint32_t					network;
	uint8_t						netmask;
	uint16_t					ports[ 1 ];
	
	_datagram_t(void) : cmd(0), ver(0), cnt(0), network(0), netmask(0), magic(DATAGRAM_MAGIC)
	{
		ports[ 0 ] = 0;
		return;
	}

	~_datagram_t(void)
	{
		return;
	}

	std::size_t
	size(void)
	{ 
		return offsetof(_datagram_t, ports[ cnt ]);
	}

} datagram_t;
#pragma pack(pop)

void destroyDatagram(datagram_t*);
datagram_t* allocateDatagram(uint16_t);

#endif