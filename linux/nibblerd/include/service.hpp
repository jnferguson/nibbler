#ifndef HAVE_SERVICE_T_HPP
#define HAVE_SERVICE_T_HPP

#include <cstdint>
#include <cstdlib>
#include <string>
#include <exception>
//#include <bitset>
//#include <mutex>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <pwd.h>
#include <unistd.h>
#include <fcntl.h>
//#include <signal.h>

class serviceException_t : public std::exception
{
	protected:
		std::string m_msg;

	public:
		explicit serviceException_t(const char* m) : m_msg(m) {}
		explicit serviceException_t(const std::string m) : m_msg(m) {}
		virtual ~serviceException_t(void) {}
		virtual const char* what(void) { return m_msg.c_str(); }
};

class invalidUserException_t : public serviceException_t 
{
	public:
		explicit invalidUserException_t(const char* m) : serviceException_t(m) {}
		explicit invalidUserException_t(const std::string m) : serviceException_t(m) {}
		virtual ~invalidUserException_t(void) {}
};

class detachException_t : public serviceException_t
{
	public:
		explicit detachException_t(const char* m) : serviceException_t(m) {}
		explicit detachException_t(const std::string m) : serviceException_t(m) {}
		virtual ~detachException_t(void) {}
};

class filesystemException_t : public serviceException_t
{
	public:
		explicit filesystemException_t(const char* m) : serviceException_t(m) {}
		explicit filesystemException_t(const std::string m) : serviceException_t(m) {}
		virtual ~filesystemException_t(void) {}
};

class userGroupException_t : public serviceException_t
{
	public:
		explicit userGroupException_t(const char* m) : serviceException_t(m) {}
		explicit userGroupException_t(const std::string m) : serviceException_t(m) {}
		virtual ~userGroupException_t(void) {}
};

class rlimitException_t : public serviceException_t
{
	public:
		explicit rlimitException_t(const char* m) : serviceException_t(m) {}
		explicit rlimitException_t(const std::string m) : serviceException_t(m) {}
		virtual ~rlimitException_t(void) {}
};

class signalHandlerException_t : public serviceException_t
{
	public:
		explicit signalHandlerException_t(const char* m) : serviceException_t(m) {}
		explicit signalHandlerException_t(const std::string m) : serviceException_t(m) {}
		virtual ~signalHandlerException_t(void) {}
};

class service_t
{
    private:
        //std::bitset< _NSIG >
        std::string m_dir;
        std::string m_user;
        uid_t       m_uid;
        gid_t       m_gid;

    protected:
        bool doUserGroupOperations(void);
        bool doDetachOperations(void);
        bool doFileSystemOperations(void);
        bool doResourceLimitOperations(void);
        bool doSignalHandlerOperations(void);

    public:
        service_t(std::string& dir);
		service_t(const char* dir);
		virtual ~service_t(void);
};

#endif // HAVE_SERVICE_T_HPP
