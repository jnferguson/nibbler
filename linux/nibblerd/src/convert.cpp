#include "convert.hpp"

std::vector< std::string >
split(const std::string& str, const std::string& delim, const bool keep_empty)
{
	std::vector< std::string > 	retval;
	std::string::const_iterator	substart(str.begin());
	std::string::const_iterator subend;


	if (true == delim.empty()) {
		retval.push_back(str);
		return retval;
	}

	while (true) {
		std::string tmp("");

		subend = std::search(substart, str.end(), delim.begin(), delim.end());

		tmp.insert(tmp.begin(), substart, subend);
		
		if (true == keep_empty || false == tmp.empty()) 
			retval.push_back(tmp);

		if (subend == str.end())
			break;				

		substart = subend + delim.size();
	}

	return retval;
}

std::vector< std::string >
split(const char* str, const char* delim, const bool keep_empty)
{
	const std::string s(str);
	const std::string d(delim);

	return split(s, d, keep_empty);
}

std::string&
ltrim(std::string& s)
{
	s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
	return s;
}

std::string&
rtrim(std::string& s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

std::string&
trim(std::string& s)
{
	return ltrim(rtrim(s));
}

