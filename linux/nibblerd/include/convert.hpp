#ifndef HAVE_CONVERT_T_HPP
#define HAVE_CONVERT_T_HPP

#include <cstdint>
#include <type_traits>
#include <string>
#include <exception>
#include <vector>
#include <algorithm>
#include <iterator>

template< typename T, typename std::enable_if< std::is_integral< T >::value, bool >::type = true >
static T 
convert_to_integral(const std::string& val) 
{
	T				retval(0);
	std::string		fmt("%");
	signed int		rv(0);
	bool			sgn(std::is_signed< T >::value);

	if (typeid(T) == typeid(bool)) {
		std::string tmp(val);

		std::transform(tmp.begin(), tmp.end(), tmp.begin(), ::tolower);

		if (! tmp.compare("1") || ! tmp.compare("yes")  || ! tmp.compare("true") || ! tmp.compare("on"))
			retval = true;
		else
			retval = false;

		return retval;
	}

	switch (sizeof(T)) {
		case sizeof(int8_t):
			fmt +=  "hh";
			break;

		case sizeof(int16_t):
			fmt += "h";
			break;

		case sizeof(int32_t):
			break;

		case sizeof(int64_t):
			fmt += "ll";
			break;

		default:
			throw std::runtime_error("Unknown/unsupported size integer specified!");
			break;
	}

	if (true == std::is_signed< T >::value) 
			fmt += "i";
	else 
			fmt += "u";
			
	rv = std::sscanf(val.c_str(), fmt.c_str(), &retval);

	if (1 != rv || EOF == rv)
		throw std::runtime_error("Error while calling std::sscanf()!");

	return retval;

}

template< typename T, typename std::enable_if< std::is_integral< T >::value, bool >::type = true >
static T
convert_to_integral(const char* val)
{
	std::string v(val);

	return convert_to_integral< T >(v);
}

std::vector< std::string > split(const std::string& str, const std::string& delim, const bool keep_empty = false);
std::vector< std::string > split(const char* str, const char* delim, const bool keep_empty = false);
std::string& ltrim(std::string&);
std::string& rtrim(std::string&);
std::string& trim(std::string&);


#endif
