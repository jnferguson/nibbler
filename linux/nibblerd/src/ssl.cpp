#include "ssl.hpp"



SSL*
ssl_connection_t::new_ssl(ssl_ctx_t& ctx)
{
	SSL* r(nullptr);

	if (nullptr == ctx.get()) 
		throw std::runtime_error("Passed invalid SSL context (nullptr)");

	r = ::SSL_new(ctx.get());

	if (nullptr == r) 
		throw std::runtime_error(ssl_connection_t::last_error_string("Error in ::SSL_new()").c_str());

	return r;

}

struct sockaddr*
ssl_connection_t::new_sockaddr(struct sockaddr* addr, std::size_t len)
{
	struct sockaddr* ret(reinterpret_cast< struct sockaddr* >(new uint8_t[len]));

	::memcpy(ret, addr, len);
	return ret;
}

ssl_connection_t::ssl_connection_t(ssl_ctx_t& ctx, log_t& log, signed int fd, struct sockaddr* addr, std::size_t len) 
				: m_ssl(ssl_connection_t::new_ssl(ctx), &::SSL_free), 
				m_socket(fd),
				m_addr(new_sockaddr(addr, len)),
				m_addr_len(len),
				m_log(log)
{
	m_log.DEBUG("entered");


	if (1 != ::SSL_set_fd(m_ssl.get(), fd)) {
		m_log.ERROR("Error in ::SSL_set_fd(): ", last_error_string());
		throw std::runtime_error(ssl_connection_t::last_error_string("Error in ::SSL_set_fd()").c_str());
	}

	if (1 != ::SSL_accept(m_ssl.get())) {
		m_log.ERROR("Error in ::SSL_accept(): ", last_error_string());
		throw std::runtime_error(ssl_connection_t::last_error_string("Error in ::SSL_accept()").c_str());
	}

	m_log.DEBUG("returning");
	return;
}

ssl_connection_t::~ssl_connection_t(void)
{
	m_log.INFO("entered");
	this->shutdown();
	m_addr.release();
	return;
}

std::string
ssl_connection_t::last_error_string(const char* msg)
{
	std::string ret(msg);
			
	ret += + ": ";
	ret += ssl_connection_t::last_error_string();

	return ret;
}

std::string
ssl_connection_t::last_error_string(void)
{
	std::string ret			= "";
	char        buf[4096] 	= {0};

	::ERR_error_string_n(::ERR_get_error(), buf, sizeof(buf));
	ret = buf;
	return ret;
}


bool 
ssl_connection_t::read(std::vector< uint8_t >& d, std::size_t len)
{
	d.clear();
	d.resize(len);

	if (0 >= ::SSL_read(m_ssl.get(), d.data(), len)) { 
		m_log.ERROR("Error in ::SSL_read(): ", ssl_connection_t::last_error_string());			
		return false;
	}

	return true;
}

bool
ssl_connection_t::write(std::vector< uint8_t >& d)
{
	if (0 == d.size())
		return true;

	if (0 >= ::SSL_write(m_ssl.get(), d.data(), d.size())) {
		m_log.ERROR("Error in ::SSL_write(): ", ssl_connection_t::last_error_string());
		return false;
	}

	return true;
}

bool
ssl_connection_t::shutdown(ssl_shut_how_t how)
{
	signed int h(0);

	switch (how) {
		case S_RD:
			h = SHUT_RD;
			break;
		case S_WR:
			h = SHUT_WR;
			break;
		case S_BO:
			h = SHUT_RDWR;
			break;
		default:
			return false;
	}

	if (0 != ::shutdown(m_socket, h)) {
		m_log.ERROR("Error in ::shutdown(): ", ::strerror(errno));
		return false;
	}

	return true;
}

bool
ssl_connection_t::close(void)
{
	shutdown();
	::close(m_socket);
	return true;
}


ssl_base_t::ssl_base_t(void) 
{
	::SSL_library_init();
	::OpenSSL_add_all_algorithms();
	::SSL_load_error_strings();
	::ERR_load_BIO_strings();
	return;
}


std::string
ssl_t::error_string(void)
{
	std::string ret("");
	char 		buf[4096] = {0};
	
	::ERR_error_string_n(::ERR_get_error(), buf, sizeof(buf));
	ret = buf;
	return ret;
}

		

bool 
ssl_t::init_ctx(void)
{
	signed long	flags(0);

	flags |= (	SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3 | SSL_OP_NO_TLSv1 |
				SSL_OP_NO_TLSv1_1 |
				SSL_OP_CIPHER_SERVER_PREFERENCE | 
				SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION );

	::SSL_CTX_set_options(m_ctx.get(), flags);
			
	if (1 != ::SSL_CTX_set_cipher_list(m_ctx.get(), "HIGH:!aNULL:@STRENGTH")) {
		m_log.ERROR("Error in ::SSL_CTX_set_cipher_list(): ", error_string());
		return false;
	}

	if (1 != ::SSL_CTX_use_certificate(m_ctx.get(), m_cert.get())) {
		m_log.ERROR("Error calling ::SSL_CTX_use_certificate(): ", error_string());
		return false;
	}
			
	if (1 != ::SSL_CTX_use_RSAPrivateKey(m_ctx.get(), m_key.get())) {
		m_log.ERROR("Error calling ::SSL_CTX_use_RSAPrivateKey(): ", error_string());
		return false;
	}

	if (1 != ::SSL_CTX_check_private_key(m_ctx.get())) {
		m_log.ERROR("Error in SSL_CTX_check_private_key(): ", error_string());
		return false;
	}

	if (1 != ::SSL_CTX_add_client_CA(m_ctx.get(), new_x509(m_chain.at(0)))) { //.get())) {
		m_log.ERROR("Error calling ::SSL_CTX_add_client_CA(): ", error_string());
		return false;
	}

	if (false == init_cert_chain()) {
		m_log.ERROR("Failure while initializing certificate chain");
		return false;
	}

	::SSL_CTX_set_verify(m_ctx.get(), SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, nullptr);
	::SSL_CTX_set_verify_depth(m_ctx.get(), 5);

	return true;
}

bool
ssl_t::init_cert_chain(void)
{
	X509_STORE* store(nullptr);

	if (nullptr == m_ctx.get()) {
		m_log.ERROR("SSL CTX is in an invalid state");
		return false;
	}

	store = ::SSL_CTX_get_cert_store(m_ctx.get());

	if (nullptr == store) {
		m_log.ERROR("Error calling ::SSL_CTX_get_cert_store(): ", error_string());
		return false;
	}

	for (auto& cert : m_chain) 
		if (0 == ::X509_STORE_add_cert(store, new_x509(cert))) 
			m_log.ERROR("Error calling ::X509_STORE_add_cert(): ", error_string());


	return true;

}

SSL_CTX*
ssl_t::new_ctx(void)
{
	const SSL_METHOD* 	m(::TLSv1_2_server_method());
	SSL_CTX*			c(nullptr);

	if (nullptr == m) 
		throw std::runtime_error("Error in ::TLSv1_2_server_method()");

	c = ::SSL_CTX_new(m);
			
	if (nullptr == c) 
		throw std::runtime_error("Error in ::SSL_CTX_new()");

	return c;
}

BIO*
ssl_t::new_bio(std::vector< uint8_t >& v)
{
	BIO* r(nullptr);

	if (0 == v.size()) 
		throw std::runtime_error("Invalid parameter passed to ssl_t::new_bio()");

	r = ::BIO_new_mem_buf(v.data(), v.size());

	if (nullptr == r) 
		throw std::runtime_error("Error in ::BIO_new_mem_buf()");

	return r;
}

X509*
ssl_t::new_x509(std::vector< uint8_t >& v) //ssl_bio_t& b)
{
	ssl_bio_t 	b(new_bio(v), &::BIO_free_all);
	X509* 		r(nullptr);

	r = ::PEM_read_bio_X509(b.get(), nullptr, 0, nullptr);

	if (nullptr == r) 
		throw std::runtime_error("Error in ::PEM_read_bio_X509()");
			
	return r;
}

RSA*
ssl_t::new_rsa(std::vector< uint8_t >& v) 
{
	ssl_bio_t 	b(new_bio(v), &::BIO_free_all);
	RSA*		r(nullptr);

	r = ::PEM_read_bio_RSAPrivateKey(b.get(), nullptr, 0, nullptr);

	if (nullptr == r)  
		throw std::runtime_error("Error calling ::PEM_read_bio_RSAPrivateKey()");

	return r;
}

ssl_t::ssl_t(log_t& l, std::vector< uint8_t >& cert, std::vector< uint8_t >& key, std::vector< ssl_bvec_t >& chain) 
							: ssl_base_t(), m_log(l), 
							m_ctx(ssl_t::new_ctx(), &::SSL_CTX_free),
							m_cert(ssl_t::new_x509(cert), &::X509_free),
							m_key(ssl_t::new_rsa(key), &::RSA_free),
							m_chain(chain) //(ssl_t::new_x509(chain.at(0)), &::X509_free) //chain), &::X509_free)
{
	if (false == init_ctx()) { 
		m_log.ERROR("Error while initializing SSL context");
		throw std::runtime_error("Error initializing SSL context");
	}

	return;
}

ssl_t::~ssl_t(void) 
{
	m_log.INFO("entered");
	m_chain.clear(); //.release();
	m_key.release();
	m_cert.release();
	m_ctx.release();
	m_log.INFO("returning");
	return; 
}

ssl_conn_t
ssl_t::accept(signed int socket, struct sockaddr* addr, std::size_t len)
{
	return std::make_shared< ssl_connection_t >(m_ctx, m_log, socket, addr, len);
}

