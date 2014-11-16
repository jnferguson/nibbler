#include <log.hpp>

#define LOG_T_FLAGS std::ios_base::out|std::ios_base::ate|std::ios_base::app

log_t::log_t(std::string& file) : m_log(file, LOG_T_FLAGS)
{
	if (! m_log.is_open() || ! m_log.good())
		throw logOpenException_t("Failed to open log file");

	return;
}

log_t::log_t(const char* file) : m_log(file, LOG_T_FLAGS)
{
	if (! m_log.is_open() || ! m_log.good())
		throw logOpenException_t("Failed to open log file");
}

log_t::~log_t(void)
{
	m_log.flush();
	m_log.close();
}

void
log_t::message(const std::string& m)
{
	std::lock_guard< std::mutex > l(m_mutex);

	m_log << m << std::endl;
	m_log.flush();
	return;
}

void
log_t::debug(std::string& m)
{
	static const std::string dpre("[DEBUG]: ");

	message(dpre + m);
	return;
}

void
log_t::debug(const char* m)
{
	std::string msg(m);

	if (nullptr == m)
		return;

	debug(msg);
	return;
}

void
log_t::info(std::string& m)
{
	static const std::string dpre("[INFO]: ");

	message(dpre + m);
	return;
}

void
log_t::info(const char* m)
{
	std::string msg(m);

	if (nullptr == m)
		return;

	info(msg);
	return;
}

void
log_t::warn(std::string& m)
{
	static const std::string dpre("[WARN]: ");

	message(dpre + m);
	return;
}

void
log_t::warn(const char* m)
{
	std::string msg(m);

	if (nullptr == m)
		return;

	warn(msg);
	return;
}

void
log_t::error(std::string& m)
{
	static const std::string dpre("[ERROR]: ");

	message(dpre + m);
	return;
}

void
log_t::error(const char* m)
{
	std::string msg(m);

	if (nullptr == m)
		return;

	error(msg);
	return;
}
