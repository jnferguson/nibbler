#ifndef HAVE_SERVICE_T_HPP
#define HAVE_SERVICE_T_HPP

#include <cstdint>
#include <cstdlib>
#include <string>
#include <exception>
#include <bitset>
#include <mutex>
#include <functional>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <pwd.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <openssl/rand.h>

#include "log.hpp"


static const char* _g_user = "nobody";
static std::string _g_str_user = _g_user;

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
		std::mutex				m_mutex;
		sigset_t				m_sigset;
		static log_t*			m_log;
        std::string				m_lpath;
		std::string 			m_dir;
        std::string 			m_user;
        uid_t       			m_uid;
        gid_t       			m_gid;
		static signed int		m_urnd;
		static signed int		m_rnd;

    protected:
		bool translateUserGroupToUidGid(void);
		bool doUserGroupOperations(void);
        bool doDetachOperations(bool detach);
        bool doFileSystemOperations(bool chroot);
        bool doResourceLimitOperations(void);
        bool doSignalHandlerOperations(void);
		bool fixPermissions(std::string);
		signed int openReadFile(std::string, bool nb = false);

		static void shandler(signed int, siginfo_t*, void*);
		
    public:
        service_t(std::string&, std::string&, std::string& user = _g_str_user, bool verb = false, bool chroot = true, bool detach = true);
		service_t(const char*, const char*, const char* user = _g_user, bool verb = false, bool chroot = true, bool detach = true);
		virtual ~service_t(void);
		static log_t* get_log_instance(void);
		log_t& get_log(void);
		static bool seed_prng(void);
		bool block_signal(signed int);
		bool unblock_signal(signed int);
		bool pending_signals(std::bitset< _NSIG >&);
		bool pending_signals(signed int);
		bool has_signals(void);
		template< typename F, typename... R > void debug(const F& first, const R&... rest) { get_log().DEBUG(first, rest...); }
		template< typename F, typename... R > void info(const F& first, const R&... rest) { get_log().INFO(first, rest...); }
		template< typename F, typename... R > void warn(const F& first, const R&... rest) { get_log().WARN(first, rest...); }
		template< typename F, typename... R > void error(const F& first, const R&... rest) { get_log().ERROR(first, rest...); }

};

typedef service_t svc_t;

#endif // HAVE_SERVICE_T_HPP
