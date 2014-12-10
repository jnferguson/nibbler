#ifndef HAVE_FILE_T_HPP
#define HAVE_FILE_T_HPP

#include <cstdint>
#include <cstddef>
#include <fstream>
#include <vector>
#include <stdexcept>

#include <dirent.h>
#include <unistd.h>
#include <string.h>

#include "convert.hpp"

class file_t {
	private:
	protected:
		static std::string& to_absolute(std::string&);
		static std::size_t get_file_size(std::ifstream&);	
	public:
		file_t(void) { return; }
		virtual ~file_t(void) { return; }

		static std::vector< uint8_t > get_file(const std::string&);
		static std::vector< uint8_t > get_file(const char*);
		static std::vector< std::string > read_dir(const std::string&);
		static std::vector< std::string > read_dir(const char*);
};

#endif
