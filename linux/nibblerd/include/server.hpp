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
#include <future>
#include <atomic>

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <netdb.h>

#include "ssl.hpp"
#include "log.hpp"

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

typedef std::function< void(ssl_conn_t) > connect_callback_t;


class server_t {
	private:
		std::mutex										m_mutex;
		std::mutex										m_qmutex;
		std::queue< ssl_conn_t >						m_queue;
		std::atomic< std::size_t >						m_tcount;
		std::list< std::thread* >						m_threads;
		std::size_t										m_max_threads;
		connect_callback_t								m_callback;
		std::atomic< bool >								m_continue;
		uint16_t										m_port;
		std::list< signed int >							m_sockets;
		signed int 										m_epoll;
		log_t&											m_log;
		ssl_t											m_ssl;

	protected:
		bool bind_address(signed int, struct sockaddr*, std::size_t);
		bool initialize_socket(std::vector< std::string >&);
		bool listen_socket(signed int backlog);
		inline bool server_continue(void) { return m_continue; }

		void 
		close_sockets(void)
		{
			for (auto& socket : m_sockets) {
				//m_sockets.remove(socket);
				::shutdown(socket, SHUT_RDWR);
				::close(socket);

			}

			m_sockets.clear();
			return;
				
		}

		static void 
		default_handler(ssl_conn_t cd) 
		{
			if (nullptr == cd.get())
				return;

			cd->close();
			cd = nullptr;
			//cd.release();
			return;
		}

	public:
		server_t(log_t& log, std::string host,  uint16_t port, std::vector< uint8_t >&, std::vector< uint8_t >&, std::vector< std::vector< uint8_t > >& ); 
		server_t(log_t& log, std::vector< std::string > hosts, uint16_t port, std::vector< uint8_t >&, std::vector< uint8_t >&, std::vector< std::vector< uint8_t > >&);
		virtual ~server_t(void);

		void shutdown_server(void) { m_continue.store(false); return; }
		bool accept_connections(signed int backlog = SOMAXCONN);

		bool set_max_threads(std::size_t max = 0) { std::lock_guard< std::mutex > l(m_mutex); m_max_threads = max; return true; } 
		bool register_callback(connect_callback_t cb) { std::lock_guard< std::mutex > l(m_mutex); m_callback = cb; return true; }
};

typedef server_t svr_t;

#endif
