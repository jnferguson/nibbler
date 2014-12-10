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
#include "convert.hpp"
#include "ssl.hpp"

#include <unistd.h>
#include <signal.h>
#include <dlfcn.h>
#include <string.h>

bool
parse_args(signed int ac, char** av, std::string& conf)
{

	for (signed int cnt = 1; cnt < ac - 1; cnt++) {
		if (! ::strcmp(av[cnt], "-f") || ! ::strcmp(av[cnt], "-F")) {
			conf = av[++cnt];
		} else {
			std::cerr << "Usage: " << av[0] << "[-d|-D][-c|-C] [-f|-F] < configuration file >" << std::endl;
			std::cerr << std::endl << std::endl;
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
	try {
		void*						dns(::dlopen("libnss_dns.so", RTLD_NOW|RTLD_GLOBAL));
		std::string					conf("/etc/nibbler.conf");
		nibbler_t*  				nb(nullptr);
		signed int  				ret(EXIT_SUCCESS);


		if (nullptr == dns) {
			std::cerr << "Failed to load libnss_dns.so...: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		if (false == parse_args(ac, av, conf))
			return EXIT_FAILURE;

		nb = new nibbler_t(conf); 
		ret = nb->start();
		
		delete nb;
		::dlclose(dns);

		return ret;
	} catch (std::exception& e) {
		std::cerr << "Caught exception: " << e.what() << std::endl;
		return EXIT_FAILURE;
	} 
}
