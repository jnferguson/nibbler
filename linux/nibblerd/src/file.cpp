#include "file.hpp"

std::string&
file_t::to_absolute(std::string& file)
{
	char*		path(::realpath(file.c_str(), nullptr));

	if (nullptr == path) 
		throw std::runtime_error("Error calling ::realpath()");

	file = path;
	return file;
}

std::size_t
file_t::get_file_size(std::ifstream& fs)
{
	std::streampos pos(0);

	fs.seekg(0, fs.end);
	pos = fs.tellg();
	fs.seekg(0, fs.beg);

	if (0 > pos) 
		throw std::runtime_error("Error retrieving file stream position");

	return std::size_t(pos);

}

std::vector< uint8_t > 
file_t::get_file(const std::string& file)
{
	std::string				fcopy(file);
	std::string				path(file_t::to_absolute(trim(fcopy)));
	std::ifstream 			stream(path, std::ios_base::in);
	std::vector< uint8_t >	retval;
	
	if (! stream.is_open() || ! stream.good())
		throw std::runtime_error("Error opening file");
	
	retval.resize(file_t::get_file_size(stream));

	stream.read(reinterpret_cast< char* >(retval.data()), retval.size());
	stream.close();
	return retval;
}

std::vector< uint8_t > 
file_t::get_file(const char* file)
{
	std::string f(file);

	return file_t::get_file(f);
}

std::vector< std::string >
file_t::read_dir(const std::string& dir)
{
	DIR*						d(nullptr);
	struct dirent* 				dent(nullptr);
	struct dirent*				res(nullptr);
	std::vector< std::string >	retval;
	std::vector< std::string >	tmp;
	std::string					tpath("");
	signed long					nmax(::pathconf(dir.c_str(), _PC_NAME_MAX));
	std::size_t					len(0);
	signed int 					rdret(0);

	d = ::opendir(dir.c_str());

	if (nullptr == d)
		throw std::runtime_error("Error in ::opendir()");

	if (0 > nmax)
		nmax = 256;

	len = offsetof(struct dirent, d_name) + nmax + 1;

	dent = reinterpret_cast< struct dirent* >(new uint8_t[len]);
	::memset(dent, 0, len);

	do {
		rdret = ::readdir_r(d, dent, &res);
		
		if (0 > rdret) 
			throw std::runtime_error("Error in ::readdir_r()");

		if (nullptr == res)
			break;
		
		switch (dent->d_type) {
			case DT_DIR:
				if (! ::strcmp(dent->d_name, "..") || ! ::strcmp(dent->d_name, "."))
					break;

				tpath = dir + "/" + dent->d_name;
				tmp = file_t::read_dir(tpath.c_str());
				retval.insert(retval.end(), tmp.begin(), tmp.end());
				break;

			case DT_REG:
				retval.push_back(dir + "/" + dent->d_name);
				break;
			default:
				break;
		}
	} while(1);

	return retval;
}

std::vector< std::string >
file_t::read_dir(const char* dir)
{
	std::string d(dir);

	return file_t::read_dir(dir);
}
