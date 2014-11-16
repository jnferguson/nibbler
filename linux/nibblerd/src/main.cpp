#include <cstdlib>
#include <cstdint>
#include <iostream>

#include <service.hpp>
#include <log.hpp>

#include <unistd.h>

signed int
main(signed int ac, char** av)
{
	log_t		log("/tmp/tmp.log");
	service_t* 	svc(nullptr);

	try {
		log.debug("initializing service...");
		svc = new service_t("/tmp");
	} catch (std::exception& e) {
		log.error(e.what());
		return EXIT_FAILURE;
	} catch(...) {
		log.error("Unknown exception");
		return EXIT_FAILURE;
	}

	while (1) {
		log.debug("Sleeping for 30 seconds...");
		sleep(1*30);
	}

    return EXIT_SUCCESS;
}
