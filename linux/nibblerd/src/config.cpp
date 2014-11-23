#include "config.hpp"

config_t::config_t(std::string file, bool p) : m_file(file)
{
	std::string 				line("");
	std::string::size_type		pos(0);
	std::ifstream				stream; //(m_file, std::ios_base::in);

	if (false == make_path_absolute()) 
		throw std::runtime_error("Error canonicalizing path");
	
	stream.open(m_file, std::ios_base::in);

	if (! stream.is_open() || ! stream.good()) 
		throw std::runtime_error("Error opening configuration file");

	do {
		line.clear();
		std::getline(stream, line);

		if (stream.eof())
			break;

		if (stream.fail() || stream.bad())
			throw std::runtime_error("Error reading configuration file line");

		
		line = trim(line);

				
		pos = line.find("#");

		if (0 == pos)
			continue;
		else if (std::string::npos == pos) {
			m_lines.push_back(line);
			continue;
		} 

		m_lines.push_back(line.substr(0, pos));

	} while (! stream.eof());

	stream.close();

	if (true == p) 
		if (false == parse())
			throw std::runtime_error("Error parsing configuration file");

	return;
}

config_t::~config_t(void)
{
	m_config.clear();
	m_parse_errors.clear();
	return;
}

inline std::string&
config_t::ltrim(std::string& s) 
{         
	s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
	return s; 
} 

inline std::string&
config_t::rtrim(std::string& s) 
{         
	s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());         
	return s; 
} 

inline std::string&
config_t::trim(std::string& s) 
{
	return ltrim(rtrim(s));
}


bool
config_t::parse(void)
{
	std::size_t lnum(0);

	for (auto& line : m_lines) {
		std::string::size_type 	pos = line.find("=");
		std::string 			key = "";
		std::string 			val = "";

		if (std::string::npos == pos) {
			m_parse_errors.push_back("No assignment token (=) found at line " + std::to_string(lnum++));
			continue;
		} 

		if (pos != line.find_last_of("=")) {
			m_parse_errors.push_back("More than one assignment token (=) found at line " + std::to_string(lnum++));
			continue;
		}

		key = line.substr(0, pos);
		val = line.substr(pos+1);

		key = trim(key);
		val = trim(val);

		std::transform(key.begin(), key.end(), key.begin(), ::tolower);

		if (m_config.end() != m_config.find(key)) {
			m_parse_errors.push_back("Overwriting pre-existing token: " + key + " at line " + std::to_string(lnum++));
			m_config[key] = val;
			continue;
		}

		m_config[key] = val;
		lnum++;
	}

	return true;
}

bool
config_t::has_value(std::string key)
{
	std::transform(key.begin(), key.end(), key.begin(), ::tolower);

	if (m_config.end() != m_config.find(key)) 
		return true;
			
	return false;
}

std::string&
config_t::get_value(std::string key)
{
	std::transform(key.begin(), key.end(), key.begin(), ::tolower);

	return m_config[key];
}

bool
config_t::add(std::string key, std::string value) 
{
	std::transform(key.begin(), key.end(), key.begin(), ::tolower);

	m_config[key] = value;

	return true;
}

bool
config_t::del(std::string key)
{
	std::transform(key.begin(), key.end(), key.begin(), ::tolower);

	if (false == has_value(key))
		return false;

	m_config.erase(key);
	return true;
}

std::vector< std::string >
config_t::errors(void)
{
	return m_parse_errors;
}

void
config_t::clear_errors(void)
{
	m_parse_errors.clear();	
}

std::size_t
config_t::value_to_unsigned(std::string name)
{
	std::size_t ret(0);
	std::string	value("");

	if (false == has_value(name))
		throw std::runtime_error("Invalid name specified (no such key)");

	value = get_value(name);
	ret = std::strtoul(value.c_str(), nullptr, 10);
	return ret;
}

bool
config_t::value_is_true(std::string name)
{
	std::string value("");

	if (false == has_value(name))
		return false;

	value = get_value(name);
	std::transform(value.begin(), value.end(), value.begin(), ::tolower);

	if (! value.compare("true") || ! value.compare("1") || ! value.compare("on") || ! value.compare("yes"))
		return true;

	return false;

}
