#ifndef HAVE_SERVER_T_HPP
#define HAVE_SERVER_T_HPP

#include <cstdint>
#include <cstdlib>
#include <exception>
#include <string>
#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <list>
#include <functional>
#include <chrono>

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <netdb.h>


#include "log.hpp"

typedef enum { SERVER_TCP_TYPE = 0, SERVER_UDP_TYPE } server_proto_t;

typedef struct _connection_t {
	signed int 			socket;
	struct sockaddr*	addr;
	std::size_t			len;

	_connection_t(void) : socket(-1), addr(nullptr), len(0) { return; }
	_connection_t(signed int s, struct sockaddr* a, std::size_t l) : socket(s), addr(nullptr), len(l) 
	{ 
		addr = reinterpret_cast< struct sockaddr* >(new uint8_t[l]);
		::memcpy(addr, a, l);

		return; 
	}

	~_connection_t(void) 
	{

		if (nullptr != addr)
			delete addr;

		addr	= nullptr;
		len 	= 0;
		socket 	= -1;

		return;
	}

} connection_t;

typedef std::function< void(connection_t*) > connect_callback_t;

class server_t {
	private:
		std::mutex					m_mutex;
		std::mutex					m_qmutex;
		std::mutex					m_tmutex;
		std::queue< connection_t* >	m_queue;
		std::list< std::thread* >	m_threads;
		std::list< std::thread* >	m_svc_threads;
		std::size_t					m_max_threads;
		connect_callback_t			m_callback;
		volatile bool				m_continue;
		uint16_t					m_port;
		signed int 					m_sock;
		signed int 					m_epoll;
		server_proto_t				m_proto;
		log_t&						m_log;

	protected:
		bool bind_address(struct sockaddr*, std::size_t);
		bool initialize_socket(std::vector< std::string >&);
		bool listen_socket(signed int backlog);
		inline bool server_continue(void) { std::lock_guard< std::mutex > l(m_mutex); return m_continue; }

		static void 
		default_handler(connection_t* cd) 
		{
			if (nullptr == cd)
				return;

			::close(cd->socket);
			delete cd->addr;
			cd->addr = nullptr;
			return;
		}

		void
		test_function(void)
		{
			m_log.INFO("test function");
			return;
		}

	public:
		server_t(log_t& log, std::string host,  uint16_t port = 31336, server_proto_t proto = SERVER_TCP_TYPE); 
		server_t(log_t& log, std::vector< std::string > hosts, uint16_t port = 31336, server_proto_t proto = SERVER_TCP_TYPE);
		virtual ~server_t(void);

		void shutdown_server(void) { std::lock_guard< std::mutex > l(m_mutex); m_continue = false; return; }
		bool accept_connections(signed int backlog = SOMAXCONN);

		bool set_max_threads(std::size_t max = 0) { std::lock_guard< std::mutex > l(m_mutex); m_max_threads = max; return true; } 
		bool register_callback(connect_callback_t& cb) { std::lock_guard< std::mutex > l(m_mutex); m_callback = cb; return true; }
	
};

typedef server_t svr_t;

#endif
