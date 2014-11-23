#include <cstdlib>
#include <cstdint>
#include <iostream>
#include <thread>
#include <chrono>
#include <algorithm>
#include <vector>

#include "config.hpp"
#include "service.hpp"
#include "server.hpp"
#include "nibbler.hpp"

#include <unistd.h>
#include <signal.h>
#include <dlfcn.h>
#include <string.h>

bool
parse_args(signed int ac, char** av, bool& do_chroot, bool& do_detach, std::string& conf)
{

	for (signed int cnt = 1; cnt < ac - 1; cnt++) {
		if (! ::strcmp(av[cnt], "-f") || ! ::strcmp(av[cnt], "-F")) {
			conf = av[++cnt];
		} else if (! ::strcmp(av[cnt], "-d") || ! ::strcmp(av[cnt], "-D")) {
			do_detach = true;
		} else if (! ::strcmp(av[cnt], "-c") || ! ::strcmp(av[cnt], "-C")) {
			do_chroot = true;
		} else {
			std::cerr << "Usage: " << av[0] << "[-d|-D][-c|-C] [-f|-F] < configuration file >" << std::endl;
			std::cerr << std::endl << std::endl;
			std::cerr << "[-d|-D]        Disable detaching from the console" << std::endl;
			std::cerr << "[-c|-C]        Disable chrooting the server process" << std::endl;
			std::cerr << "[-f|-F]        Specifies the configuration file path" << std::endl;
			std::cerr << "               (Defaults to '/etc/nibbler.conf)" << std::endl;
			return false;
		}
	}
	
	return true;
}

signed int
main(signed int ac, char** av)
{
	config_t*	cfg(nullptr);  
	svc_t*		svc(nullptr);
	svr_t*		tcp(nullptr);
	svr_t*		udp(nullptr);
	void*		dns(nullptr);
	std::size_t port(31336);
	std::string	conf("/etc/nibbler.conf");
	nibbler_conf_opts_t opts;

	// we do this because the chroot laterscrews up the calls to getaddrinfo
	// and we could either move this file and a whole host of other files 
	// into the chroot now, or we could just load it before we chroot.
	dns = ::dlopen("libnss_dns.so", RTLD_NOW|RTLD_GLOBAL);

	if (nullptr == dns) {
		std::cerr << "Failed to load libnss_dns.so...: " << ::strerror(errno) << std::endl;
		return EXIT_FAILURE;
	}

	if (false == parse_args(ac, av, opts.chroot, opts.detach, conf))
		return EXIT_FAILURE;

	try {
		nibbler_t*	nb 	= nullptr;

		cfg = new config_t(conf);

		if (true == cfg->has_value("root_dir"))
			opts.root_dir = cfg->get_value("root_dir");
		if (true == cfg->has_value("log_file"))
			opts.log_file = cfg->get_value("log_file");
		if (true == cfg->has_value("user"))
			opts.user = cfg->get_value("user");
		if (true == cfg->has_value("bind_host"))
			opts.bind_hosts.push_back(cfg->get_value("bind_host"));
		if (true == cfg->has_value("bind_port"))
			opts.bind_port = cfg->value_to_unsigned("bind_port");
		if (true == cfg->has_value("max_request_threads"))
			opts.max_request_threads = cfg->value_to_unsigned("max_request_threads");
		if (true == cfg->has_value("verbose")) 
				opts.verbose = cfg->value_is_true("verbose");

		svc = new svc_t(opts.root_dir, opts.log_file, opts.user, opts.verbose, opts.chroot, opts.detach);
		tcp = new svr_t(svc->get_log(), opts.bind_hosts[0], opts.bind_port, SERVER_TCP_TYPE);
		udp = new svr_t(svc->get_log(), opts.bind_hosts[0], opts.bind_port, SERVER_UDP_TYPE);
		nb = new nibbler_t(opts, *svc, *tcp, *udp);
		nb->start();

	//	do {
	//		std::this_thread::sleep_for(std::chrono::milliseconds(200));
			
			/*if (true == svc->pending_signals(SIGUSR1)) {
				svr->shutdown_server();
				std::this_thread::sleep_for(std::chrono::milliseconds(500));
				delete svr;
				svr = new server_t(svc->get_log(), "localhost");
			}


		} while (false == svc->pending_signals(SIGTERM));

		svr->shutdown_server();
		std::this_thread::sleep_for(std::chrono::milliseconds(500));*/

	} catch (std::exception& e) {
		std::cerr << "Caught exception: " << e.what() << std::endl;
	} 

	if (nullptr != svc)
		delete svc;

	if (nullptr != tcp)
		delete tcp;

	if (nullptr != udp)
		delete udp;

	//if (nullptr != svc)
	//	svc->info("Service finished, exiting process.");

	::dlclose(dns);
    return EXIT_SUCCESS;
}
