#ifndef HAVE_LOG_HPP
#define HAVE_LOG_HPP

#include <cstdlib>
#include <cstdint>
#include <fstream>
#include <string>
#include <exception>
#include <mutex>

class logException_t : public std::exception
{
	protected:
		std::string m_msg;

	public:
		explicit logException_t(const char* m) : m_msg(m) {}
		explicit logException_t(const std::string m) : m_msg(m) {}
		virtual ~logException_t(void) {}
		virtual const char* what(void) { return m_msg.c_str(); }
};

class logOpenException_t : public logException_t
{
    public:
		explicit logOpenException_t(const char* m) : logException_t(m) {}
		explicit logOpenException_t(const std::string m) : logException_t(m) {}
		virtual ~logOpenException_t(void) {}

};

class log_t {
	private:
		std::string 	m_file;
		std::ofstream	m_log;
		std::mutex		m_mutex;

	protected:
		void message(const std::string&);

	public:
		log_t(std::string&);
		log_t(const char*);
		virtual ~log_t(void);
		void debug(std::string&);
		void debug(const char*);
		void info(std::string&);
		void info(const char*);
		void warn(std::string&);
		void warn(const char*);
		void error(std::string&);
		void error(const char*);

};

#endif
