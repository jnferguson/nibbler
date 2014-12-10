#ifndef HAVE_SSL_T_HPP
#define HAVE_SSL_T_HPP

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/bio.h>
#include <openssl/x509.h>
#include <openssl/x509_vfy.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

//#include "server.hpp"
#include "log.hpp"


class ssl_connection_t;

typedef std::unique_ptr< SSL_CTX, decltype(&::SSL_CTX_free) > ssl_ctx_t;
typedef std::unique_ptr< X509, decltype(&::X509_free) > ssl_x509_t;
typedef std::unique_ptr< BIO, decltype(&::BIO_free_all) > ssl_bio_t;
typedef std::unique_ptr< RSA, decltype(&::RSA_free) > ssl_rsa_t;
typedef std::unique_ptr< SSL, decltype(&::SSL_free) > ssl_ssl_t;
typedef std::shared_ptr< ssl_connection_t > ssl_conn_t;

typedef std::unique_ptr< struct sockaddr > sock_addr_t;

typedef enum { S_RD = 0, S_WR, S_BO } ssl_shut_how_t;

class ssl_connection_t 
{
	private:
		ssl_ssl_t		m_ssl;
		signed int		m_socket;
		sock_addr_t		m_addr;
		std::size_t		m_addr_len;
		log_t&			m_log;
	protected:
		static SSL* new_ssl(ssl_ctx_t&);

		static struct sockaddr* new_sockaddr(struct sockaddr* addr, std::size_t len);

	public:
		ssl_connection_t(ssl_ctx_t&, log_t&, signed int, struct sockaddr*, std::size_t); 
		~ssl_connection_t(void);

		static std::string last_error_string(const char*);
        static std::string last_error_string(void);

		bool read(std::vector< uint8_t >& d, std::size_t len = 8192);
		bool write(std::vector< uint8_t >& d);
		bool shutdown(ssl_shut_how_t how = S_BO);
		bool close(void);
};


class ssl_base_t {
	private:
	protected:
	public:
		ssl_base_t(void); 
};

typedef std::vector< uint8_t > ssl_bvec_t;

class ssl_t : protected ssl_base_t {
	private:
		log_t&						m_log;
		ssl_ctx_t					m_ctx;
		ssl_x509_t					m_cert;
		ssl_rsa_t					m_key;
		std::vector< ssl_bvec_t >	m_chain;
//		ssl_x509_t					m_chain;

	protected:
		static std::string error_string(void);

		virtual bool init_ctx(void);
		bool init_cert_chain(void);
		static SSL_CTX* new_ctx(void);
		static BIO* new_bio(std::vector< uint8_t >&);
		static X509* new_x509(std::vector< uint8_t >&);
		static RSA* new_rsa(std::vector< uint8_t >&);

	public:
		ssl_t(log_t& l, std::vector< uint8_t >&, std::vector< uint8_t >&, std::vector< ssl_bvec_t >&); 
		~ssl_t(void);
		ssl_conn_t accept(signed int, struct sockaddr*, std::size_t);
};

#endif
