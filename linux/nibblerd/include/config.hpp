#ifndef HAVE_CONFIG_T_HPP
#define HAVE_CONFIG_T_HPP

#include <cstdint>
#include <cstdlib>
#include <string>
#include <vector>
#include <map>
#include <fstream>
#include <exception>
#include <algorithm>
#include <cctype>
// #include <filesystem> ... sigh, g++.

#include "convert.hpp"

#include <limits.h>
#include <string.h>
#include <unistd.h>

class config_t {
	private:
		std::string								m_file;
		std::vector< std::string >				m_lines;
		std::vector< std::string >				m_parse_errors;
		std::map< std::string, std::string >	m_config;

	protected:
		inline bool
		make_path_absolute(void) 
		{ 
			char* path = ::realpath(m_file.c_str(), nullptr);

			if (nullptr == path)
				return false;
				
			m_file = path;
			::free(path);

			return true;
		}

	public:
		config_t(std::string, bool p = true); 
		virtual ~config_t(void);

		bool parse(void);
		bool has_value(std::string);
		std::string& get_value(std::string);
		bool add(std::string, std::string);
		bool del(std::string);
		std::vector< std::string > errors(void);
		void clear_errors(void);
		bool value_is_true(std::string);
};

#endif
