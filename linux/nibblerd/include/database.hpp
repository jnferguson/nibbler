#ifndef HAVE_DATABASE_T_HPP
#define HAVE_DATABASE_T_HPP

#include <cstdint>
#include <string>
#include <pqxx/pqxx>
#include <pqxx/prepared_statement>
#include <pqxx/transaction>
#include <memory>

#include "log.hpp"

typedef struct _db_opts_t {
	std::string 	host;
	std::string		port;
	std::string		database;
	std::string		ro_user;
	std::string		ro_password;
	std::string		rw_user;
	std::string		rw_password;
	
	_db_opts_t(void) : 	host("127.0.0.1"), port("5432"), database("inet"), ro_user("pgsql"), rw_user("pgsql"), rw_password(""), ro_password("")
	{
		return;
	}

	_db_opts_t(std::string h, std::string p, std::string d, std::string rou, std::string rop, std::string rwu, std::string rwp)
					: host(h), port(p), database(d), ro_user(rou), ro_password(rop), rw_user(rwu), rw_password(rwp)
	{
		return;
	}

	~_db_opts_t(void) 
	{
		return;
	}

} db_opts_t;

typedef std::shared_ptr< pqxx::lazyconnection > db_conn_t;
typedef enum { PROTOCOL_TCP_T = 0, PROTOCOL_UDP_T } protocol_t;

class database_t {
	private:
		log_t& 				m_log;
		static db_conn_t	m_rodb;
		static db_conn_t	m_rwdb;
		db_opts_t			m_opts;

	protected:
		static db_conn_t new_db_connection(log_t& l, db_opts_t& opts, bool ro = true);

	public:
		database_t(log_t& l,  db_opts_t& opts);
		~database_t(void);
		uint64_t create_scan(void);
		bool delete_scan(uint64_t);
		bool new_scan(std::string, uint16_t, protocol_t, uint64_t&);
		uint8_t scan_status(uint64_t);
};

#endif
