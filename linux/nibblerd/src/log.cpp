#include <log.hpp>

#define LOG_T_FLAGS std::ios_base::out|std::ios_base::ate|std::ios_base::app

log_t::log_t(std::string& file, bool verb) : m_log(file, LOG_T_FLAGS), m_file(file), m_verbose(verb)
{
	std::lock_guard< std::mutex > l(m_mutex);

	if (! m_log.is_open() || ! m_log.good())
		throw logOpenException_t("Failed to open log file");

	return;
}

log_t::log_t(const char* file, bool verb) : m_log(file, LOG_T_FLAGS), m_file(file), m_verbose(verb)
{
	std::lock_guard< std::mutex > l(m_mutex);

	if (! m_log.is_open() || ! m_log.good())
		throw logOpenException_t("Failed to open log file");
}

log_t::~log_t(void)
{
	std::lock_guard< std::mutex > l(m_mutex);

	m_log.flush();
	m_log.close();
}

void
log_t::open_log(void)
{
	std::lock_guard< std::mutex > l(m_mutex);

	if (m_log.is_open())
		return;

	m_log.open(m_file, LOG_T_FLAGS);

	if (! m_log.is_open() || ! m_log.good())
		throw logOpenException_t("Failed to open log file");
	

	return;
}

void
log_t::close_log(void)
{
	std::lock_guard< std::mutex > l(m_mutex);

	if (! m_log.is_open())
		return;

	m_log.flush();
	m_log.close();

	return;
}
