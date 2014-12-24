#include <iostream>
#include <stdio.h> 
#include <errno.h> 
#include <unistd.h> 
#include <malloc.h> 
#include <string.h> 
#include <sys/socket.h> 
#include <resolv.h> 
#include <netdb.h> 
#include <openssl/ssl.h> 
#include <openssl/err.h> 
#include <arpa/inet.h>

#include "message.hpp"

signed int
open_connection(std::string h, std::string p)
{
	signed int 			retval(-1);
	struct hostent*		host(nullptr);
	struct sockaddr_in	addr = {0};

	if (nullptr == (host = ::gethostbyname(h.c_str()))) {
		std::cerr << "Error calling ::gethostbyname(): " << ::strerror(errno) << std::endl;
		return -1;
	}

	retval = ::socket(PF_INET, SOCK_STREAM, 0);

	addr.sin_family 		= AF_INET;
	addr.sin_port			= ::htons(::atoi(p.c_str()));
	addr.sin_addr.s_addr	= *(signed long*)(host->h_addr);

	if (0 != ::connect(retval, reinterpret_cast< struct sockaddr* >(&addr), sizeof(addr))) {
		std::cerr << "Error calling ::connect(): " << ::strerror(errno) << std::endl;
		return -1;
	}

	return retval;
}

signed int
verify_cb(signed int pv, X509_STORE_CTX* ctx)
{
	signed int 	depth 	= ::X509_STORE_CTX_get_error_depth(ctx);
	signed int 	err		= ::X509_STORE_CTX_get_error(ctx);
	X509*		cert	= ::X509_STORE_CTX_get_current_cert(ctx);
	char*		nm		= X509_NAME_oneline(::X509_get_subject_name(cert), 0, 0);
	char*		sn		= X509_NAME_oneline(::X509_get_issuer_name(cert), 0, 0);

	std::cout << "Depth: " << depth << " PV: " << pv << std::endl;
	std::cout << "Issuer: " << nm << std::endl;
	std::cout << "Subject: " << sn << std::endl;

	return 1;
}

signed int
main(signed int ac, char** av)
{
	SSL_CTX* 	ctx(nullptr);
	SSL_METHOD*	meth(nullptr);
	SSL*		ssl(nullptr);
	signed long	sflags(0);
	signed int	sockfd(-1);
	signed int	retval(-1);
	std::string	host("");
	std::string	port("");
	std::string key("");
	std::string cert("");
	std::string	store("");
	std::string root("");

	::SSL_library_init();
	::OpenSSL_add_all_algorithms();
	::SSL_load_error_strings();

	sflags = ( 	SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3 | SSL_OP_NO_TLSv1 | 
				SSL_OP_NO_TLSv1_1 | SSL_OP_CIPHER_SERVER_PREFERENCE | 
				SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION );

	if (7 != ac) {
		std::cerr << "Usage: " << av[0] << " <host> <port> <certificate> <key> <root certificate> <certificate store>" << std::endl;
		return EXIT_FAILURE;
	}

	host 	= av[1];
	port 	= av[2];
	cert	= av[3];
	key 	= av[4];
	root	= av[5];
	store	= av[6];

	meth	= const_cast< SSL_METHOD* >(::TLSv1_2_client_method());
	ctx		= ::SSL_CTX_new(meth);

	if (nullptr == meth) {
		::ERR_print_errors_fp(stderr);
		return EXIT_FAILURE;
	}

	::SSL_CTX_set_options(ctx, sflags);

	if (0 >= ::SSL_CTX_use_certificate_file(ctx, cert.c_str(), SSL_FILETYPE_PEM)) {
		::ERR_print_errors_fp(stderr);
		return EXIT_FAILURE;
	}

	if (0 >= ::SSL_CTX_use_PrivateKey_file(ctx, key.c_str(), SSL_FILETYPE_PEM)) {
		::ERR_print_errors_fp(stderr);
		return EXIT_FAILURE;
	}

	if (! ::SSL_CTX_check_private_key(ctx)) {
		std::cerr << "Private key does not match certificate" << std::endl;
		return EXIT_FAILURE;
	}

	if (! ::SSL_CTX_load_verify_locations(ctx, root.c_str(), store.c_str())) {
		std::cerr << "Load certificate store location failure" << std::endl;
		return EXIT_FAILURE;
	}

	::SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, nullptr); //&verify_cb);
	::SSL_CTX_set_verify_depth(ctx, 5);

	std::cout << "Connecting to: " << host << ":" << port << std::endl;

	sockfd = open_connection(host, port);

	if (0 > sockfd) 
		return EXIT_FAILURE;

	ssl = SSL_new(ctx);
	::SSL_set_fd(ssl, sockfd);

	do {
		retval = ::ERR_get_error();
		
		if (0 != retval) 
			std::cerr << "SSL ERR: " << ::ERR_reason_error_string(retval) << std::endl;

	} while (0 != retval);

	retval = ::SSL_connect(ssl);

	if (1 != retval) {
		std::cerr << "Error in SSL_connect()" << std::endl;
		::ERR_print_errors_fp(stderr);


	} else {
		X509* 			ccert(::SSL_get_peer_certificate(ssl));
		char* 			line(nullptr);
		char 			buf[4096] = {0};
		signed int		len(-1);
		struct in_addr	ia;
		struct in6_addr	i6a;
		std::vector< ip_addr_t > avec;
		std::vector< port_t >	pvec;

		//message_t		msg(OP_SCAN_STATUS, 0x4141414141414141);


		if (0 >= ::inet_pton(AF_INET, "127.0.0.0", &ia)) {
			std::cerr << "inet_pton() error: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		avec.push_back(ip_addr_t(ia, 24));
		
		if (0 >= ::inet_pton(AF_INET, "192.0.0.0", &ia)) {
			std::cerr << "inet_pton() error: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		avec.push_back(ip_addr_t(ia, 8));

		if (0 >= ::inet_pton(AF_INET6, "fe80:20c:29ff:feee:4b72::1", &i6a)) {
			std::cerr << "inet_pton() error: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		avec.push_back(ip_addr_t(i6a, 120));

		if (0 >= ::inet_pton(AF_INET, "10.0.0.1", &ia)) {
			std::cerr << "inet_pton() error: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		avec.push_back(ip_addr_t(ia));

		if (0 >= ::inet_pton(AF_INET6, "::1", &i6a)) {
			std::cerr << "inet_pton() error: " << ::strerror(errno) << std::endl;
			return EXIT_FAILURE;
		}

		avec.push_back(ip_addr_t(i6a));
		pvec.push_back(port_t(PORT_PROTO_TCP, 80));
		pvec.push_back(port_t(PORT_PROTO_TCP, 443));
		pvec.push_back(port_t(PORT_PROTO_TCP, 143));
		pvec.push_back(port_t(PORT_PROTO_TCP, 22));
		pvec.push_back(port_t(PORT_PROTO_TCP, 139));
		pvec.push_back(port_t(PORT_PROTO_TCP, 31336));
		pvec.push_back(port_t(PORT_PROTO_TCP, 15));

		message_t msg(avec, pvec);

		if (X509_V_OK != ::SSL_get_verify_result(ssl)) 
			std::cout << "Certificate validation failed" << std::endl;
		else
			std::cout << "Certificate successfully validated" << std::endl;

		std::cout << "Connected with " << ::SSL_get_cipher(ssl) << " encryption." << std::endl;
	
		if (nullptr == ccert) {
			std::cerr << "ccert is nullptr" << std::endl;
			return EXIT_FAILURE;
		}

		line = ::X509_NAME_oneline(::X509_get_subject_name(ccert), 0, 0);
		std::cout << "Subject: " << line << std::endl;
		::free(line);
		line = ::X509_NAME_oneline(::X509_get_issuer_name(ccert), 0, 0); 
		std::cout << "Issuer: " << line << std::endl;
		::free(line);
		std::cout << "Version: " << ::X509_get_version(ccert) << std::endl;
		::X509_free(ccert);

		len = ::SSL_read(ssl, buf, sizeof(buf));

		if (0 < len && 4096 > len) {
			buf[len] = 0;
			std::cout << "buf: " << buf << std::endl;
		}

		std::vector< uint8_t > d(msg.data());
		::SSL_write(ssl, d.data(), d.size());
	}

	::close(sockfd);
	::SSL_CTX_free(ctx);
	return EXIT_SUCCESS;	
}

