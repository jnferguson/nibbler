#include "server.hpp"

bool 
server_t::bind_address(struct sockaddr* addr, std::size_t len)
{
	m_log.DEBUG("entered");

	if (nullptr == addr || 0 == len)
		return false;
		
	if (0 > ::bind(m_sock, addr, len)) {
		m_log.ERROR("Error in ::bind(): ", ::strerror(errno));
		return false;
	}

	m_log.DEBUG("returning");
	return true;
}

bool 
server_t::initialize_socket(std::vector< std::string >& hosts)
{
	struct addrinfo		hints 	= {0};
	struct addrinfo*	res		= nullptr;
	const signed int	tval	= 1;

	m_log.DEBUG("entered");

	hints.ai_family 	= AF_UNSPEC;
	hints.ai_flags		= AI_IDN;
	hints.ai_canonname	= nullptr;
	hints.ai_addr		= nullptr;
	hints.ai_next		= nullptr;

	switch (m_proto) {
		case SERVER_TCP_TYPE:
			m_sock = ::socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 6);

			hints.ai_socktype 	= SOCK_STREAM;
			hints.ai_protocol	= 6;

			m_log.INFO("server is TCP type");
			break;

		case SERVER_UDP_TYPE:
			m_sock = ::socket(AF_INET, SOCK_DGRAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 17);

			hints.ai_socktype 	= SOCK_DGRAM;
			hints.ai_protocol 	= 17;
			m_log.INFO("server is UDP type");
			break;

		default:
			m_log.ERROR("Invalid/unsupported protocol specified: ", static_cast< signed int >(m_proto));
			return false;
			break;
	}

	for (auto& host : hosts) {
		if (0 > ::getaddrinfo(host.c_str(), std::to_string(m_port).c_str(), &hints, &res)) {
			m_log.ERROR("Error in ::getaddrinfo(): ", ::strerror(errno));
			::close(m_sock);
			return false;
		}

		for (struct addrinfo* ptr = res; ptr != nullptr; ptr = ptr->ai_next) 
			bind_address(ptr->ai_addr, ptr->ai_addrlen);

		::freeaddrinfo(res);
	}

	if (0 > ::setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, &tval, sizeof(tval))) {
		m_log.ERROR("Error in ::setsockopt(): ", ::strerror(errno));
		::close(m_sock);
		return false;
	}

	m_log.DEBUG("returning true");
	return true;
}

server_t::server_t(log_t& log, std::string host, uint16_t port, server_proto_t proto) : m_log(log), m_proto(proto), m_port(port), 
																						m_sock(-1), m_epoll(-1), m_max_threads(0), 
																						m_callback(&server_t::default_handler),
																						m_continue(true)
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

server_t::server_t(log_t& log, std::vector< std::string > hosts, uint16_t port, server_proto_t proto) : m_log(log), m_proto(proto), m_port(port), 
																										m_sock(-1), m_epoll(-1), m_max_threads(0),
																										m_callback(&server_t::default_handler),
																										m_continue(true)
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
		
		thread->join();
		delete thread;
	}

	while (! m_queue.empty()) {
		connection_t* cd = m_queue.front();
		
		::close(cd->socket);
		delete cd;
		m_queue.pop();
	}

	::close(m_sock);
	::close(m_epoll);

	m_log.DEBUG("returning");
	return;
}

bool
server_t::listen_socket(signed int backlog)
{
	m_log.DEBUG("entered");

	if (SERVER_UDP_TYPE == m_proto)
		return true;

	if (0 > ::listen(m_sock, backlog))
		return false;

	m_log.DEBUG("returning");
	return true;
}

bool
server_t::accept_connections(signed int backlog)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	struct epoll_event 				ev({0});

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

	ev.events 	= EPOLLIN|EPOLLERR; // need others?
	ev.data.fd	= m_sock;

	if (0 > ::epoll_ctl(m_epoll, EPOLL_CTL_ADD, m_sock, &ev)) {
		m_log.ERROR("Error in ::epoll_ctl()", ::strerror(errno));
		::close(m_epoll);
		m_epoll = -1;
		return false;
	}

	m_tmutex.lock();

	m_threads.push_back(new std::thread([&]()
	{
		m_log.INFO("Accept thread started, TID: ", std::this_thread::get_id());

		do {
			struct epoll_event 	events 	= {0};
			signed int 			fd		= -1;
			struct sockaddr		sa		= {0};
			socklen_t			le		= sizeof(struct sockaddr);
			connection_t*		cd		= nullptr; //{-1, nullptr, 0};

			if (0 > ::epoll_wait(m_epoll, &events, 1, -1)) {
				m_log.ERROR("Error in ::epoll_wait(): ", ::strerror(errno));
				return;
			}

			if (events.data.fd != m_sock) {
				m_log.WARN("::epoll_wait() returned a file descriptor other than the only one we specified...");
				continue;
			}
		
			fd = ::accept(m_sock, &sa, &le);

			if (0 > fd) {
				m_log.ERROR("Error in ::accept(): ", ::strerror(errno));
				//return;
			}
			
			cd = new connection_t(fd, &sa, le);

			m_qmutex.lock();
			m_queue.push(cd);
			m_qmutex.unlock();

		} while ( true == server_continue() );
	
		m_log.DEBUG("Accept thread returning...");
		return;
	}));

	m_threads.push_back(new std::thread([&]()
	{
		m_log.INFO("Queue thread started, TID: ", std::this_thread::get_id());

		do {
			connection_t* cd(nullptr);

			m_qmutex.lock();
			
			if (true == m_queue.empty()) {
				m_qmutex.unlock();
				std::this_thread::sleep_for(std::chrono::milliseconds(100));
				continue;
			}

			m_tmutex.lock();

			if (m_max_threads <= m_threads.size()) {
				m_tmutex.unlock();
				std::this_thread::sleep_for(std::chrono::milliseconds(100));
				continue;
			}

			cd = m_queue.front();
			m_queue.pop();
			m_qmutex.unlock();

			m_threads.push_back(new std::thread([&](){ m_callback(cd); }));
			m_tmutex.unlock();
			cd = nullptr;

		} while ( true == server_continue() );
	
		m_log.INFO("Queue thread returning");
	}));

	m_threads.push_back(new std::thread([&]()
	{
		m_log.INFO("Reaper thread started, TID: ", std::this_thread::get_id());

		do {
			std::lock_guard< std::mutex > 		l(m_tmutex);
			
			for (auto itr = m_threads.begin(); itr != m_threads.end(); itr++) {
				std::thread* t = *itr;

				if (nullptr == t) {
					m_threads.remove(t);
					
				} else if (true == t->joinable()) {
					t->join();
					m_threads.remove(t);
					delete t;
				}
			}

			std::this_thread::sleep_for(std::chrono::milliseconds(100));

		} while (true == server_continue() );

		m_log.INFO("Reaped thread returning");
		return;
	}));
	
	m_tmutex.unlock();

	m_log.DEBUG("returning true");
	return true;
}
