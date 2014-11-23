#ifndef HAVE_LOG_HPP
#define HAVE_LOG_HPP

#include <cstdlib>
#include <cstdint>
#include <cstdarg>
#include <fstream>
#include <string>
#include <exception>
#include <mutex>
#include <type_traits>
#include <chrono>
#include <sstream>
#include <iomanip>
#include <string.h>
#include <errno.h>

extern signed int errno;


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

template< typename T > void write_log(std::ostream& out, const T& p) { out << p; }

class log_t {
	private:
		std::string 	m_file;
		std::ofstream	m_log;
		std::mutex		m_mutex;
		bool			m_verbose;

	protected:
		std::string
		get_timestamp(void)
		{
			char buf[512] = {0};
			std::ostringstream str;
			auto n = std::chrono::system_clock::now();
			auto c = std::chrono::system_clock::to_time_t(n);
			//str << std::put_time(c, "[%c]");
			if (std::strftime(buf, sizeof(buf), "%c", localtime(&c)))
				str << buf;

			return str.str();
		}
		void 
		message(void) 
		{
			m_log << std::endl; 
			return;
		}
		
		template< typename T > void 
		message(const T& p) 
		{
			m_log << p << std::endl; 
		}

		template< typename F, typename... R > void 
		message(const F& first, const R&... rest)
		{
			m_log << first;
			message(rest...);
			
			return;
		}
		
	public:
		log_t(std::string&, bool verb = false);
		log_t(const char*, bool verb = false);

		virtual ~log_t(void);

		void open_log(void);
		void close_log(void);

#define LOG_PREFIX(x) x, "[", __FUNCTION__, "()@", __LINE__, "]: "
#define DEBUG(y, ...) _log_dbg(LOG_PREFIX("[DBG]"), y, ## __VA_ARGS__)
#define INFO(y, ...) _log_info(LOG_PREFIX("[INF]"), y, ##__VA_ARGS__)
#define WARN(y, ...) _log_warn(LOG_PREFIX("[WRN]"), y, ##__VA_ARGS__)
#define ERROR(y, ...) _log_error(LOG_PREFIX("[ERR]"), y, ##__VA_ARGS__)

		template< typename F, typename... R >
		void
		_log_dbg(const F& first, const R&... rest)
		{
			std::lock_guard< std::mutex > l(m_mutex);

			if ( true == m_verbose )
				message("[", get_timestamp(), "]", first, rest...);
			
			return;
		}

		template< typename F, typename... R >
		void
		_log_info(const F& first, const R&... rest)
		{
			std::lock_guard< std::mutex > l(m_mutex);

			message("[", get_timestamp(), "]", first, rest...);
			return;
		}

		template< typename F, typename... R >
		void
		_log_warn(const F& first, const R&... rest)
		{
			std::lock_guard< std::mutex > l(m_mutex);

			message("[", get_timestamp(), "]", first, rest...);
			return;
		}

		template< typename F, typename... R >
		void
		_log_error(const F& first, const R&... rest)
		{
			std::lock_guard< std::mutex > l(m_mutex);

			message("[", get_timestamp(), "]", first, rest...);
			return;
		}

		template< typename F, typename... R > 
		void
		msg(const F& first, const R&... rest)
		{
			std::lock_guard< std::mutex > l(m_mutex);

			message("[", get_timestamp(), "]", first, rest...);
			return;
		}
};

#endif
