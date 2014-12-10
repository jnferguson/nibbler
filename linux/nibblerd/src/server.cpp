#include "server.hpp"

#include <arpa/inet.h>

bool 
server_t::bind_address(signed int sock, struct sockaddr* addr, std::size_t len)
{
	m_log.DEBUG("entered");

	if (nullptr == addr || 0 == len)
		return false;
	
	if (0 > ::bind(sock, addr, len)) {
		m_log.ERROR("Error in ::bind(): ", ::strerror(errno));
		return false;
	}

	m_log.DEBUG("returning");
	return true;
}

bool 
server_t::initialize_socket(std::vector< std::string >& hosts)
{
	struct addrinfo						hints 	= {0};
	struct addrinfo*					res		= nullptr;
	const signed int					tval	= 1;
	signed int							sock	= -1;
	
	m_log.DEBUG("entered");

	hints.ai_family 	= AF_UNSPEC;
	hints.ai_flags		= AI_IDN;
	hints.ai_socktype	= SOCK_STREAM;
	hints.ai_protocol	= 6; // TCP
	hints.ai_canonname	= nullptr;
	hints.ai_addr		= nullptr;
	hints.ai_next		= nullptr;

	for (auto& host : hosts) {
		m_log.INFO("Binding to: ", host);

		if (0 > ::getaddrinfo(host.c_str(), std::to_string(m_port).c_str(), &hints, &res)) {
			m_log.ERROR("Error in ::getaddrinfo(): ", ::strerror(errno));
			close_sockets();
			return false;
		}

		switch (res->ai_family) {
			case AF_INET:
				sock = ::socket( AF_INET, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 6);
				break;

			case AF_INET6:
				sock = ::socket(AF_INET6, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 6);
				break;
			default:
				throw std::runtime_error("Unknown or otherwise unsupported protocol family encountered");
				break;
		}


		for (struct addrinfo* ptr = res; ptr != nullptr; ptr = ptr->ai_next) 
				if (true == bind_address(sock, ptr->ai_addr, ptr->ai_addrlen))
					break;

		::freeaddrinfo(res);

		if (0 > ::setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &tval, sizeof(tval))) {
			m_log.ERROR("Error in ::setsockopt(): ", ::strerror(errno));
			::close(sock);
			close_sockets();
			return false;
		}

		m_sockets.push_back(sock);
	}

	m_log.DEBUG("returning true");
	return true;
}

server_t::server_t(	log_t& log, std::string host, 
					uint16_t port, 
					std::vector< uint8_t >& cert, 
					std::vector< uint8_t >& key, 
					std::vector< std::vector< uint8_t > >& chain) 
						: 	m_log(log), m_port(port), 
							m_ssl(m_log, cert, key, chain),
							m_epoll(-1), m_max_threads(0), 
							m_callback(&server_t::default_handler),
							m_continue(true), m_tcount(0)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	std::vector< std::string > 		v;

	m_log.DEBUG("entered");

	v.push_back(host);

	if (false == initialize_socket(v)) 
		throw std::runtime_error("Error in server_t::initialize_socket()");

	m_log.DEBUG("returning");
	return;
}

server_t::server_t(	log_t& log, std::vector< std::string > hosts, 
					uint16_t port, 
					std::vector< uint8_t >& cert, 
					std::vector< uint8_t >& key, 
					std::vector< std::vector< uint8_t > >& chain) 
							: 	m_log(log), m_port(port), 
								m_ssl(m_log, cert, key, chain),
								m_epoll(-1), m_max_threads(0),
								m_callback(&server_t::default_handler),
								m_continue(true), m_tcount(0)
{
	std::lock_guard< std::mutex > l(m_mutex);
	
	m_log.DEBUG("entered");

	if (false == initialize_socket(hosts))
		throw std::runtime_error("Error in server_t::initialize_socket()");

	m_log.DEBUG("returning");
	return;
}

server_t::~server_t(void)
{
	std::lock_guard< std::mutex > l(m_mutex);
	std::lock_guard< std::mutex > q(m_qmutex);

	m_log.DEBUG("entered");

	while (! m_threads.empty()) {
		std::thread* thread = m_threads.front();
	
		m_threads.pop_front();

		if (nullptr == thread) 
			continue;

		delete thread;
	}

	while (! m_queue.empty()) {
		ssl_conn_t cd = m_queue.front();

		m_queue.pop();

		if (nullptr == cd.get()) 
			continue;

		cd->close();
		cd = nullptr;
	}

	close_sockets();
	::close(m_epoll);

	m_log.DEBUG("returning");
	return;
}

bool
server_t::listen_socket(signed int backlog)
{
	m_log.DEBUG("entered");

	for (auto& socket : m_sockets)
		if (0 > ::listen(socket, backlog))
			return false;

	m_log.DEBUG("returning");
	return true;
}

bool
server_t::accept_connections(signed int backlog)
{
	std::lock_guard< std::mutex > 	l(m_mutex);

	m_log.DEBUG("entered");

	if (false == listen_socket(backlog)) { 
		m_log.ERROR("Error in listen_socket(): ", ::strerror(errno));
		return false;
	}

	if (0 > m_epoll)
		::close(m_epoll);

	m_epoll = ::epoll_create1(EPOLL_CLOEXEC);

	if (0 > m_epoll) {
		m_log.ERROR("Error in ::epoll_create1(): ", ::strerror(errno));
		return false;
	}

	for (auto& socket : m_sockets) {
		struct epoll_event ev = {0};
		
		ev.events 	= EPOLLIN|EPOLLERR;
		ev.data.fd	= socket;

		if (0 > ::epoll_ctl(m_epoll, EPOLL_CTL_ADD, socket, &ev)) {
			m_log.ERROR("Error in ::epoll_ctl(): ", ::strerror(errno));
			::close(m_epoll);
			m_epoll = -1;
			return false;
		}

		ev.events 	= EPOLLIN|EPOLLERR|EPOLLRDHUP|EPOLLPRI|EPOLLHUP; // need others?
		ev.data.fd	= socket;
	}

	m_threads.push_back(new std::thread([&](){
		m_log.INFO("Accept task thread started, TID: ", std::this_thread::get_id());

		do {
			signed int			ecnt		= 0;
			struct epoll_event  events[32]  = {0};

			ecnt = ::epoll_wait(m_epoll, events, 32, -1);

			if (0 > ecnt) {
				m_log.ERROR("Error in ::epoll_wait(): ", ::strerror(errno));
				return;
			} else if (0 == ecnt) 
				continue;

			for (signed int cnt = 0; cnt < ecnt; cnt++) {
				signed int		fd = -1;
				struct sockaddr sa = {0};
				socklen_t		le = sizeof(struct sockaddr);
				connection_t*	cd = nullptr;

				if (0 != (events[cnt].events & ~(EPOLLIN|EPOLLPRI))) {
					m_log.ERROR("Received exceptional error/hang-up event on listening socket.");
					::shutdown(events[cnt].data.fd, SHUT_RDWR);
					::close(events[cnt].data.fd);
					// XXX mutex? 
					m_sockets.remove(events[cnt].data.fd);
					continue;
				}

				fd = ::accept(events[cnt].data.fd, &sa, &le);

				if (0 > fd) {
					m_log.ERROR("Error in ::accept(): ", ::strerror(errno));
					continue;
				}

				try {
					// grmbl. there is no safe way to do shit 
					// relating to a mutex in a try/catch that
					// doesnt _exit() outside of a scoped lock.
					// because there is no way to check and see
					// if the fucking lock is locked.
					std::lock_guard< std::mutex > 	l(m_qmutex);
					ssl_conn_t 						s(m_ssl.accept(fd, &sa, le));

					m_queue.push(s);

				} catch(std::runtime_error& e) {
					m_log.ERROR(e.what());
					::close(fd);
				}

			}

		} while ( true == server_continue() );

		m_log.DEBUG("Accept task returning...");
		return;
	}));

	m_threads.push_back(new std::thread([&]()
	{
		m_log.INFO("Queue thread started, TID: ", std::this_thread::get_id());

		do {
			m_qmutex.lock();
			
			if (true == m_queue.empty()) {
				m_qmutex.unlock();
				std::this_thread::sleep_for(std::chrono::milliseconds(100));
				continue;
			}


			if (m_max_threads <= m_tcount.load()) { 
				std::this_thread::sleep_for(std::chrono::milliseconds(100));
				continue;
			}

			{
				ssl_conn_t 	sc(m_queue.front());
				
				m_queue.pop();
				m_qmutex.unlock();

				m_tcount++;
				
				try {
					std::async(std::launch::async, [&](){ this->m_callback(sc); m_tcount--; return; });

				} catch (std::runtime_error& e) {
					m_log.ERROR(e.what());
				}

				sc = nullptr;
			}

		} while ( true == server_continue() );
    
		m_log.DEBUG("Queue thread returning");
		return;
	}));

	for (auto itr = m_threads.begin(); itr != m_threads.end(); itr++) {
		if (*itr) {
			(*itr)->detach();
		}
	}

	m_log.DEBUG("returning true");
	return true;
}
