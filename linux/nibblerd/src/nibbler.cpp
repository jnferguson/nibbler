#include "nibbler.hpp"

database_t* nibbler_t::m_db = nullptr;

void 
nibbler_t::handler(ssl_conn_t cd)
{
	std::vector< uint8_t > 	vec;
	message_t*				msg(nullptr);
	void* 					ptr(nullptr);
	char					buf[INET6_ADDRSTRLEN] = {0};
	uint64_t				sid(0);

	if (nullptr == cd.get())
		return;

	cd->get_log().INFO("Received inbound connection from: ", cd->remote_ip(), ":", cd->remote_port());
	cd->write(vec);
	vec.clear();
	cd->read(vec);

	try {
		msg = new message_t(vec);

		switch (msg->command()) {
			case OP_START_SCAN:
				sid = nibbler_t::m_db->create_scan();

				cd->get_log().INFO("OP_START_SCAN: ", sid);
				for (auto& a : msg->addresses()) {
					::memset(&buf, 0, INET6_ADDRSTRLEN);

					if (ADDRESS_IPV4_TYPE == a.type) {
						const char* addr = ::inet_ntop(AF_INET, &a.addr.v4, &buf[0], INET6_ADDRSTRLEN);
						std::string	cidr = addr; 
	
						cidr += "/";
						cidr += std::to_string(a.mask);

						for (auto& p : msg->ports()) {
							nibbler_t::m_db->new_scan(cidr, p.port, (PORT_PROTO_TCP == p.proto ? PROTOCOL_TCP_T : PROTOCOL_UDP_T), sid); 
							cd->get_log().DEBUG("IPv4 Scan: ", cidr, ":", p.port, (PORT_PROTO_TCP == p.proto ? " tcp" : " udp"));
						}
	
					} else {
						const char* addr6 = ::inet_ntop(AF_INET6, &a.addr.v6, &buf[0], INET6_ADDRSTRLEN);
						std::string	cidr6 = addr6;

						cidr6 += "/";
						cidr6 += std::to_string(a.mask);

						for (auto& p : msg->ports()) {
							nibbler_t::m_db->new_scan(cidr6, p.port, (PORT_PROTO_TCP == p.proto ? PROTOCOL_TCP_T : PROTOCOL_UDP_T), sid);
							cd->get_log().DEBUG("IPv6 Scan: ", cidr6, ":", p.port, (PORT_PROTO_TCP == p.proto ? " tcp" : " udp"));
						}
					}
				}

				break;

			case OP_STOP_SCAN:
				cd->get_log().INFO("Received command OP_STOP_SCAN");
				cd->get_log().INFO("Requested stop scan for scan with id: ", std::to_string(msg->id()));
				nibbler_t::m_db->delete_scan(msg->id());

				break;

			case OP_SCAN_STATUS:
				cd->get_log().INFO("Received command OP_SCAN_STATUS");
				cd->get_log().INFO("Requested scan status for scan with id: ", msg->id());
				cd->get_log().INFO("Scan status: ", nibbler_t::m_db->scan_status(msg->id()));
				break;

			default:
				cd->get_log().INFO("Received unknown command: ", msg->command());

				break;
		}

		delete msg;

	} catch (std::runtime_error& e) {
		cd->get_log().ERROR("Exception: ", e.what());
		cd = nullptr;
		return;
	}

	cd = nullptr;
	return;
}

nibbler_conf_opts_t
nibbler_t::initialize_configuration(void)
{
	nibbler_conf_opts_t opts;

	if (nullptr != m_cnf)
		delete m_cnf;

	m_cnf = new config_t(m_cfile);

	if (true == m_cnf->has_value("root_dir"))
		opts.root_dir = m_cnf->get_value("root_dir");
	if (true == m_cnf->has_value("log_file"))
		opts.log_file = m_cnf->get_value("log_file");
	if (true == m_cnf->has_value("user"))
		opts.user = m_cnf->get_value("user");
	if (true == m_cnf->has_value("bind_port"))
		opts.bind_port = convert_to_integral< uint16_t >(m_cnf->get_value("bind_port"));
	if (true == m_cnf->has_value("db_host"))
		opts.db_host = m_cnf->get_value("db_host");
	if (true == m_cnf->has_value("db_port"))
		opts.db_port = m_cnf->get_value("db_port");
	if (true == m_cnf->has_value("db_database"))
		opts.db_database = m_cnf->get_value("db_database");
	if (true == m_cnf->has_value("db_ro_user"))
		opts.db_ro_user = m_cnf->get_value("db_ro_user");
	if (true == m_cnf->has_value("db_ro_password"))
		opts.db_ro_password = m_cnf->get_value("db_ro_password");
	if (true == m_cnf->has_value("db_rw_user"))
		opts.db_rw_user = m_cnf->get_value("db_rw_user");
	if (true == m_cnf->has_value("db_rw_password"))
		opts.db_rw_password = m_cnf->get_value("db_rw_password");
	if (true == m_cnf->has_value("ssl_cert"))
		opts.cert = m_cnf->get_value("ssl_cert");
	if (true == m_cnf->has_value("ssl_key"))
		opts.key = m_cnf->get_value("ssl_key");
	if (true == m_cnf->has_value("max_request_threads"))
		opts.max_request_threads = convert_to_integral< std::size_t >(m_cnf->get_value("max_request_threads"));
	if (true == m_cnf->has_value("verbose"))
		opts.verbose = convert_to_integral< bool >(m_cnf->get_value("verbose")); 
	if (true == m_cnf->has_value("do_chroot"))
		opts.chroot = convert_to_integral< bool >(m_cnf->get_value("do_chroot"));
	if (true == m_cnf->has_value("do_detach"))
		opts.detach = convert_to_integral< bool >(m_cnf->get_value("do_detach"));
	
	if (true == m_cnf->has_value("ssl_trust_certs")) {
		opts.chain.clear();

		for (auto& path : split(m_cnf->get_value("ssl_trust_certs"), ","))
			for (auto& file : file_t::read_dir(trim(path)))
				opts.chain.push_back(file);
	}

	if (true == m_cnf->has_value("bind_hosts")) {
		opts.bind_hosts.clear();
				
		for (auto host : split(m_cnf->get_value("bind_hosts"), ","))
			opts.bind_hosts.push_back(trim(host));
	}

	return opts;
}

nibbler_t::nibbler_t(const std::string& cfile) : m_svc(nullptr), m_tcp(nullptr), m_cnf(nullptr), m_cfile(cfile) 
{ 
	nibbler_conf_opts_t opts = initialize_configuration();

	if (8 >= opts.max_request_threads) 
		opts.max_request_threads = 8;

	m_cert	= file_t::get_file(opts.cert);
	m_key	= file_t::get_file(opts.key);

	for (auto& file : opts.chain)
		m_chain.push_back(file_t::get_file(file));
		
	m_svc 	= new svc_t(opts.root_dir, opts.log_file, opts.user, opts.verbose, opts.chroot, opts.detach);
	m_tcp	= new svr_t(m_svc->get_log(), opts.bind_hosts, opts.bind_port, m_cert, m_key, m_chain);

	if (false == m_tcp->set_max_threads(opts.max_request_threads / 2))
		throw std::runtime_error("Unable to set TCP servers maximum thread count");

	if (false == m_tcp->register_callback(&nibbler_t::handler)) 
		throw std::runtime_error("Unable to register callback function on TCP server");

	if (nullptr == m_db) {
		db_opts_t db_opts;

		db_opts.host        = opts.db_host;
		db_opts.port        = opts.db_port;
		db_opts.database    = opts.db_database;
		db_opts.ro_user     = opts.db_ro_user;
		db_opts.ro_password = opts.db_ro_password;
		db_opts.rw_user     = opts.db_rw_user;
		db_opts.rw_password = opts.db_rw_password;

		try { m_db = new database_t(m_svc->get_log(), db_opts); }
		catch (std::exception& e) {
			m_svc->get_log().ERROR("Error while initializing database connection: ", e.what());
		} catch (...) {
			m_svc->get_log().ERROR("Error while initializing database connection: unknown exception");
		}
												
	}

	return; 
}

nibbler_t::nibbler_t(const char* cfile) : m_svc(nullptr), m_tcp(nullptr), m_cnf(nullptr), m_cfile(cfile)
{
	nibbler_conf_opts_t opts = initialize_configuration();

	if (8 >= opts.max_request_threads)
		opts.max_request_threads = 8;

	m_cert 	= file_t::get_file(opts.cert);
	m_key	= file_t::get_file(opts.key);
	
	for (auto& file : opts.chain)
		m_chain.push_back(file_t::get_file(file));

	m_svc 	= new svc_t(opts.root_dir, opts.log_file, opts.user, opts.verbose, opts.chroot, opts.detach);
	m_tcp 	= new svr_t(m_svc->get_log(), opts.bind_hosts, opts.bind_port, m_cert, m_key, m_chain);

	if (false == m_tcp->set_max_threads(opts.max_request_threads))
		throw std::runtime_error("Unable to set TCP servers maximum thread count");

	if (false == m_tcp->register_callback(&nibbler_t::handler))
		throw std::runtime_error("Unable to register callback function on TCP server");

	if (nullptr == m_db) {
		db_opts_t db_opts;
		
		db_opts.host 		= opts.db_host;
		db_opts.port 		= opts.db_port;
		db_opts.database	= opts.db_database;
		db_opts.ro_user		= opts.db_ro_user;
		db_opts.ro_password	= opts.db_ro_password;
		db_opts.rw_user		= opts.db_rw_user;
		db_opts.rw_password	= opts.db_rw_password;

		try { m_db = new database_t(m_svc->get_log(), db_opts); }
		catch (std::exception& e) {
			m_svc->get_log().ERROR("Error while initializing database connection: ", e.what());
		} catch (...) {
			m_svc->get_log().ERROR("Error while initializing database connection: unknown exception");
		}
	}

	return;
}

nibbler_t::~nibbler_t(void) 
{
	std::lock_guard< std::mutex > l(m_mutex);

	if (nullptr != m_svc)
		delete m_svc;

	if (nullptr != m_tcp)
		delete m_tcp;

	return; 
}

signed int
nibbler_t::start(void)
{
	m_mutex.lock();

	if (false == m_tcp->accept_connections()) { 
		m_svc->error("Error while accepting connections on TCP service.");
		return EXIT_FAILURE;
	}

	m_mutex.unlock();

	do {
		/* chroot breaks this at present.
		 *
		 * if (true == m_svc->pending_signals(SIGUSR1)) {
			std::lock_guard< std::mutex > 	l(m_mutex);
			nibbler_conf_opts_t 			o(initialize_configuration(true));

			m_svc->info("Reinitializing configuration");

			m_tcp->shutdown_server();
			std::this_thread::sleep_for(std::chrono::milliseconds(100));

			delete m_tcp;

			m_tcp = new svr_t(m_svc->get_log(), o.bind_hosts, o.bind_port);

			if (false == m_tcp->set_max_threads(o.max_request_threads)) {
				m_svc->error("Error while attempting to set the maximum number of request threads");
				delete m_tcp;
				delete m_svc;
				m_tcp = nullptr;
				m_svc = nullptr;
				return EXIT_FAILURE;
			}

			if (false == m_tcp->register_callback(&nibbler_t::handler)) {
				m_svc->error("Unable to register callback function for request server");
				delete m_tcp;
				delete m_svc;
				m_tcp = nullptr;
				m_svc = nullptr;
				return EXIT_FAILURE;
			}

			if (false == m_tcp->accept_connections()) {
				m_svc->error("Error while attempting to initialize TCP service");
				m_tcp->shutdown_server();
				delete m_tcp;
				delete m_svc;
				m_tcp = nullptr;
				m_svc = nullptr;
				return EXIT_FAILURE;
			}

			m_svc->info("Configuration reinitializaion complete");
		}*/

		std::this_thread::sleep_for(std::chrono::milliseconds(200));

	} while (false == m_svc->pending_signals(SIGTERM));


	m_tcp->shutdown_server();

	m_svc->info("Received SIGTERM signal");
	return EXIT_SUCCESS;
}

