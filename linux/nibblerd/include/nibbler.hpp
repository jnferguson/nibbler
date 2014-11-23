#ifndef HAVE_NIBBLER_T_HPP
#define HAVE_NIBBLER_T_HPP

#include <cstdint>
#include <cstdlib>
#include <string>
#include <memory>
#include <vector>
#include <mutex>
#include <chrono>
#include <exception>

#include "service.hpp"
#include "server.hpp"

typedef struct _nibbler_conf_opts_t {
	std::string 				root_dir;
	std::string 				log_file;
	std::string 				user;
	std::vector< std::string > 	bind_hosts;	
	uint16_t					bind_port;
	std::size_t 				max_request_threads;
	bool						verbose;
	bool						chroot;
	bool						detach;

	_nibbler_conf_opts_t(void) : 
			root_dir(""), log_file(""), user(""), bind_port(31336), max_request_threads(1024), verbose(false), chroot(true), detach(true)
			{ return; }

} nibbler_conf_opts_t;

class nibbler_t {
	private:
		std::mutex					m_mutex;
		svc_t&						m_svc;
		svr_t&						m_tcp;
		svr_t&						m_udp;

	protected:
	public:
		nibbler_t(nibbler_conf_opts_t& opts, svc_t& svc, svr_t& tcp, svr_t& udp) : m_svc(svc), m_tcp(tcp), m_udp(udp)
		{ 
			
			if (8 >= opts.max_request_threads) {
				// XXX JF DOUBLE CHECK ME
				m_svc.info("Invalid maximum request threads specified (1), increasing to minimum (8)");
				opts.max_request_threads = 8;
			}


			if (false == m_tcp.set_max_threads(opts.max_request_threads / 2))
				throw std::runtime_error("Unable to set TCP servers maximum thread count");

			if (false == m_udp.set_max_threads(opts.max_request_threads / 2))
				throw std::runtime_error("Unable to set UDP servers maximum thread count");

			return; 
		}

		virtual ~nibbler_t(void) 
		{
			std::lock_guard< std::mutex > l(m_mutex);

			return; 
		}

		virtual signed int
		start(void)
		{

			m_mutex.lock();

			if (false == m_tcp.accept_connections()) { 
				m_svc.error("Error while accepting connections on TCP service.");
				return EXIT_FAILURE;
			}

			if (false == m_udp.accept_connections()) {
				m_svc.error("Error while accepting connections on UDP service.");
				return EXIT_FAILURE;
			}

			m_mutex.unlock();

			do { std::this_thread::sleep_for(std::chrono::milliseconds(200)); } while( false == m_svc.pending_signals(SIGTERM) );

			m_tcp.shutdown_server();
			m_udp.shutdown_server();

			m_svc.info("Received SIGTERM signal");
			return EXIT_SUCCESS;
		}
};

#endif
