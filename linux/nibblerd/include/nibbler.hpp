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
#include "config.hpp"
#include "file.hpp"
#include "ssl.hpp"
#include "message.hpp"

typedef struct _nibbler_conf_opts_t {
	std::string 				root_dir;
	std::string 				log_file;
	std::string 				user;
	std::string					cert;
	std::string					key;
	std::string					db_host;
	std::string					db_port;
	std::string					db_database;
	std::string					db_ro_user;
	std::string					db_ro_password;
	std::string					db_rw_user;
	std::string					db_rw_password;
	std::vector< std::string >	chain;
//	std::string					chain;
	std::vector< std::string > 	bind_hosts;	
	uint16_t					bind_port;
	std::size_t 				max_request_threads;
	bool						verbose;
	bool						chroot;
	bool						detach;

	_nibbler_conf_opts_t(void) : 
			root_dir("/var/db/nibbler"), log_file("/var/log/nibbler"), 
			cert("/etc/nibbler/nibbler.crt"), key("/etc/nibbler/nibbler.key"), 
			user("nobody"), db_host("127.0.0.1"), db_database("inet"), 
			db_ro_user("inet_ro_user"), db_rw_user("inet_rw_user"),
			db_ro_password(""), db_rw_password(""), db_port("5432"),
			bind_port(31336), max_request_threads(1024), 
			verbose(false), chroot(true), detach(true)
			{ 	
				bind_hosts.push_back("127.0.0.1");
				bind_hosts.push_back("::1");

				chain.push_back("/etc/nibbler/certs");
				return; 
			}

} nibbler_conf_opts_t;

typedef std::vector< uint8_t > byte_vec_t;

class nibbler_t {
	private:
		std::mutex					m_mutex;
		svc_t*						m_svc;
		svr_t*						m_tcp;
		config_t*					m_cnf;
		std::string					m_cfile;
		std::vector< uint8_t >		m_cert;
		std::vector< uint8_t >		m_key;
		std::vector< byte_vec_t >	m_chain;

	protected:
		static void handler(ssl_conn_t);
		nibbler_conf_opts_t initialize_configuration(void);

	public:
		nibbler_t(const std::string&);
		nibbler_t(const char*);
		virtual ~nibbler_t(void); 
		virtual signed int start(void);
};

#endif
