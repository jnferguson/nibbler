#include "database.hpp"

pqxx::lazyconnection*
database_t::new_db_connection(log_t& l, db_opts_t& opts, bool ro)
{	
	pqxx::lazyconnection* 	retval(nullptr);
	std::string 			cstr("dbname=" + opts.database + " hostaddr=" + opts.host + " port=" + opts.port);

	if (true == ro) {
		cstr += " user=" + opts.ro_user + " password=" + opts.ro_password;
	} else 
		cstr += " user=" + opts.rw_user + " password=" + opts.rw_password;

			
	try {
		retval = new pqxx::lazyconnection(cstr);
	} catch (pqxx::broken_connection& e) {
		l.ERROR("Error while opening connection to database: ", e.what());
		return nullptr;
	}
			

	l.INFO("Connected to database: ", retval->dbname(), " on host: ", retval->hostname()); 
	return retval;
}

database_t::database_t(log_t& l,  db_opts_t& opts) : m_log(l), m_opts(opts), m_db(new_db_connection(l, opts))
{
	if (nullptr == m_db.get()) {
		l.ERROR("Error while initializing database");
		throw std::runtime_error("Error while initializing database");
	}

	return;
}

database_t::~database_t(void)
{
	if (nullptr != m_db.get())
		m_db.reset();

	return;
}

