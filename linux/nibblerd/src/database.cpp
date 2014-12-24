#include "database.hpp"

db_conn_t database_t::m_rodb = nullptr;
db_conn_t database_t::m_rwdb = nullptr;

db_conn_t
database_t::new_db_connection(log_t& l, db_opts_t& opts, bool ro)
{
	db_conn_t				retval(nullptr);
	std::string 			cstr("dbname=" + opts.database + " hostaddr=" + opts.host + " port=" + opts.port);

	if (true == ro && nullptr != database_t::m_rodb)
		return database_t::m_rodb;
	else if (false == ro && nullptr != database_t::m_rwdb)
		return database_t::m_rwdb;

	if (true == ro) {
		cstr += " user=" + opts.ro_user + " password=" + opts.ro_password;
	} else 
		cstr += " user=" + opts.rw_user + " password=" + opts.rw_password;

			
	try {
		retval = std::make_shared< pqxx::lazyconnection >(cstr); 
	} catch (pqxx::broken_connection& e) {
		l.ERROR("Error while opening connection to database: ", e.what());
		return nullptr;
	}
			

	l.INFO("Connected to ", (ro == true ? "read-only " : "read-write "), "database: ", retval->dbname()); //, " on host: ", retval->hostname()); 
	
	if (false == ro) {
		retval->prepare("new_scan", "INSERT INTO scan_data (ssid, address, port, protocol) VALUES ($1, $2, $3, $4)");
		// XXX JF FIXME
		retval->prepare("delete_scan", "DELETE FROM scan_status WHERE id = $1");
	} else
		retval->prepare("scan_status", "SELECT percent FROM scan_status WHERE id = $1");

	return retval;
}

database_t::database_t(log_t& l,  db_opts_t& opts) : 	m_log(l), m_opts(opts)
{
	if (nullptr == m_rodb.get()) 
		m_rodb = new_db_connection(l, opts);
	if (nullptr == m_rwdb.get())
		m_rwdb = new_db_connection(l, opts, false);

	if (nullptr == m_rodb.get() || nullptr == m_rwdb.get()) {
		l.ERROR("Error while initializing database");
		throw std::runtime_error("Error while initializing database");
	}

	return;
}

database_t::~database_t(void)
{
	if (nullptr != m_rodb.get())
		m_rodb.reset();
	if (nullptr != m_rwdb.get())
		m_rwdb.reset();

	return;
}

uint64_t
database_t::create_scan(void)
{
	uint64_t 		retval(0);
	pqxx::work 		trans(*m_rwdb.get(), "CreateScanTransaction");
	pqxx::result	row(trans.exec("INSERT INTO scan_status (percent) VALUES (0) RETURNING id"));

	if (1 != row.size())
		throw std::runtime_error("Invalid row size in create_scan()");

	retval = row[0]["id"].as< uint64_t >();
	trans.commit();

	return retval;
}

bool
database_t::delete_scan(uint64_t id)
{
	pqxx::work	trans(*m_rwdb.get(), "DeleteScanTransaction");

	trans.prepared("delete_scan")(id).exec();
	trans.commit();
	return true;
}

uint8_t
database_t::scan_status(uint64_t id)
{
	pqxx::work 		trans(*m_rodb.get(), "ScanStatusTransaction");
	pqxx::result	row(trans.prepared("scan_status")(id).exec());

	if (1 != row.size())
		throw std::runtime_error("Invalid row size in scan_status");

	trans.commit();

	// database constraint ensures this value never exceeds 100.
	// and if we use .as< uint8_t >() pqxx tries to turn it into
	// a string because its presumably an unsigned char.
	// so this works around that safely.
	return static_cast< uint8_t >(row[0]["percent"].as< unsigned int >());
}

bool 
database_t::new_scan(std::string cidr, uint16_t dport, protocol_t protocol, uint64_t& scan_id)
{
	uint64_t		 		sid_sav(scan_id);
	static const char*		tcp("tcp");
	static const char*		udp("udp");

	try {
		pqxx::work 		trans(*m_rwdb.get(), "NewScanTransaction");

		if (PROTOCOL_TCP_T == protocol)
			trans.prepared("new_scan")(scan_id)(cidr)(dport)(tcp).exec();
		else
			trans.prepared("new_scan")(scan_id)(cidr)(dport)(udp).exec();

		trans.commit();

	} catch(std::exception& e) {
		m_log.ERROR("Database error while creating new scan: ", e.what());
		scan_id = sid_sav;
		return false;

	} catch(...) {
		m_log.ERROR("Database error while creating new scan");
		scan_id = sid_sav;
		return false;
	}

	return true;
}

