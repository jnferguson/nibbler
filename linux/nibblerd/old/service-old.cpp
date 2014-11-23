#include "service.hpp"

static std::mutex* g_signals_mutex = nullptr;
static std::bitset< _NSIG >* g_signals = nullptr;
static uint8_t* g_sigstack[_NSIG] = {0};

void
service_t::shandler(signed int num, siginfo_t* sinf, void* ctxt)
{
	if (nullptr != g_signals_mutex) {
		g_signals_mutex->lock();
		g_signals->set(num, true);
		g_signals_mutex->unlock();
	}

	return;
}

service_t::service_t(std::string& dir, std::string& log) : m_dir(dir), m_lpath(log), m_user("nobody")
{
	std::lock_guard< std::mutex > l(m_mutex);

	m_log = new log_t(log);

	m_log->DEBUG("entered");

    if (0 != ::geteuid()) 
        throw invalidUserException_t("User is not super while requiring a chroot call");

	if (false == translateUserGroupToUidGid()) 
		throw invalidUserException_t("Error while retrieving uid/gid for user 'nobody'");

	if (false == doFileSystemOperations())
		throw filesystemException_t("Error while closing files, chrooting, et cetera");

//	if (false == doDetachOperations())
//		throw detachException_t("Error while forking/detaching from controlling terminal");

	if (false == doUserGroupOperations())
		throw userGroupException_t("Error while dropping privileges");

    if (false == doResourceLimitOperations())
        throw rlimitException_t("Error while setting service rlimits");

    if (false == doSignalHandlerOperations())
        throw signalHandlerException_t("Error while installing signal handlers");

	m_log->INFO("Successfully daemonized, PID ", ::getpid());
	m_log->DEBUG("returning success");
    return;
}

service_t::service_t(const char* dir, const char* log) : m_dir(dir), m_lpath(log), m_log(nullptr), m_user("nobody")
{
	std::lock_guard< std::mutex > l(m_mutex);

	m_log = new log_t(log);

	m_log->DEBUG("entered");

	if (0 != ::getuid())
		throw invalidUserException_t("User is not super while requiring a chroot call");

	if (false == translateUserGroupToUidGid())
		throw invalidUserException_t("Error while retrieving uid/gid for user 'nobody'");

	if (false == doFileSystemOperations())
		throw filesystemException_t("Error while closing files, chrooting, et cetera");

//	if (false == doDetachOperations())
//		throw detachException_t("Error while forking/detaching from controlling terminal");

	if (false == doUserGroupOperations())
		throw userGroupException_t("Error while dropping privileges");

	if (false == doResourceLimitOperations())
		throw rlimitException_t("Error while setting service rlimits");

	if (false == doSignalHandlerOperations())
		throw signalHandlerException_t("Error while installing signal handlers");

	m_log->INFO("Successfully daemonized, PID ", ::getpid());
	m_log->DEBUG("returning success");
	return;
}

service_t::~service_t(void)
{
	m_log->DEBUG("entered");

	m_mutex.lock();

	for (std::size_t sig = 0; sig < _NSIG; sig++) {
		struct sigaction act = {0};

		switch (sig) {
			case SIGSEGV:
			case SIGILL:
			case SIGFPE:
			case SIGABRT:
			default:	
				break;

			case SIGHUP:
			case SIGINT:
			case SIGQUIT:
			case SIGTRAP:
			case SIGUSR2:
			case SIGPIPE:
			case SIGALRM:
			case SIGCHLD:
			case SIGSTKFLT:
			case SIGUSR1:
			case SIGTERM:
			case SIGCONT:
			case SIGTSTP:
			case SIGTTIN:
			case SIGTTOU:
			case SIGURG:
			case SIGXCPU:
			case SIGXFSZ:
			case SIGVTALRM:
			case SIGPROF:
			case SIGWINCH:
			case SIGIO:
			case SIGPWR:
			case SIGUNUSED:
				act.sa_flags 		= SA_SIGINFO|SA_NOCLDWAIT|SA_ONSTACK;
				act.sa_sigaction	= &service_t::shandler;

				if (0 > ::sigaction(sig, &act, nullptr)) 
					m_log->ERROR("Failed to reset signal ", sig, " to SIG_DFL");
	
				m_mutex.unlock();
				unblock_signal(sig); 
				m_mutex.lock();
				break;
		}
	}
	

	m_log->INFO("deleting logging object");
	
	delete m_log;
	m_log = nullptr;
	m_mutex.unlock();

    return;
}

bool
service_t::doFileSystemOperations(void)
{
    long            mfd = 0;
    signed int      fd  = 0;

	m_log->DEBUG("entered");

    ::umask(S_IRUSR|S_IWUSR|S_IXUSR);

    mfd = ::sysconf(_SC_OPEN_MAX);

    if (0 > mfd) {
    	m_log->ERROR("Error in ::sysconf(_SC_OPEN_MAX)", ::strerror(errno));
		return false;
	}

	m_log->close_log();

    for (long idx = 0; idx < mfd; idx++)
        (void)::close(idx);

	// we closed the file descriptor of our logfile
	// and can't reopen it until we've dup2()'d 
	// stdin/stdout/stderr
    fd = ::open("/dev/null", O_WRONLY);

    if (0 > fd) 
		return false;
	
    if (0 != fd)
        if (0 > ::dup2(fd, 0))
            return false;

    if (0 > ::dup2(fd, 1))
        return false;

    if (0 > ::dup2(fd, 2))
        return false;

	m_log->open_log();

    if (0 > ::chdir(m_dir.c_str())) {
		m_log->ERROR("Error in ::chdir('", m_dir, "'): ", ::strerror(errno));
        return false;
	}

	if (false == fixPermissions(m_dir))
		return false;

	if (false == fixPermissions(m_dir + "/etc"))
		return false;

	if (false == fixPermissions(m_dir + "/etc/hosts"))
		return false;

	if (false == fixPermissions(m_dir + "/etc/resolv.conf"))
		return false;

	if (false == fixPermissions(m_dir + "/etc/localtime"))
		return false;

    if (0 > ::chroot(m_dir.c_str())) {
     	m_log->ERROR("Error in ::chroot('", m_dir, "'): ", ::strerror(errno));
	 	return false;
	}

	m_log->DEBUG("returning success");
    return true;
}

bool
service_t::fixPermissions(std::string f)
{

	if (0 > ::chown(f.c_str(), static_cast< uid_t >(0), static_cast< gid_t >(0))) {
		m_log->ERROR("Error in ::chown('", f, "'): ", ::strerror(errno));
		return false;
	}

	if (0 > ::chmod(f.c_str(), S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH)) {
		m_log->ERROR("Error in ::chmod('", f, "'): ", ::strerror(errno));
		return false;
	}

	return true;
}

bool
service_t::doUserGroupOperations(void)
{

	m_log->DEBUG("entered");

    if (0 > ::setgid(m_gid)) {
     	m_log->ERROR("Error in ::setgid(): ", ::strerror(errno));
	 	return false;
	}

    if (0 > ::setuid(m_uid)) {
     	m_log->ERROR("Error in ::setuid(): ", ::strerror(errno));
	 	return false;
	}

	m_log->DEBUG("returning success");
    return true;
}

bool
service_t::doDetachOperations(void)
{
    pid_t pid   = 0;

	m_log->DEBUG("entered");

    if (1 == ::getppid()) {
		m_log->DEBUG("Attempted to daemonize when already daemonized (1 == ::getppid())");
        return true;
	}

    pid = ::fork();

    switch (pid) {
        case 0:     // child
            break;
        case -1:    // error
			m_log->ERROR("Error in ::fork()", ::strerror(errno));
            return false;
            break;
        default:    // parent
            ::_exit(EXIT_SUCCESS);
            break;
    }

    if (0 > ::setsid()) {
     	m_log->ERROR("Error in ::setsid(): ", ::strerror(errno));
		return false;
	}

	m_log->DEBUG("returning success");
    return true;
}

bool
service_t::doResourceLimitOperations(void)
{
	m_log->DEBUG("entered");
	m_log->DEBUG("returning success");
    return true;
}

bool
service_t::doSignalHandlerOperations(void)
{
	sigset_t 		old = {0};

	m_log->DEBUG("entered");

	if (0 > ::sigfillset(&m_sigset)) {
		m_log->ERROR("Error in ::sigfillset(): ", ::strerror(errno));
		return false;
	}

	if (0 > ::sigdelset(&m_sigset, SIGSEGV)) {
		m_log->ERROR("Error in ::sigdelset(): ", ::strerror(errno));
		return false;
	}

	if (0 > ::sigdelset(&m_sigset, SIGILL)) {
		m_log->ERROR("Error in ::sigdelset(): ", ::strerror(errno));
		return false;
	}

	if (0 > ::sigdelset(&m_sigset, SIGFPE)) {
		m_log->ERROR("Error in ::sigdelset(): ", ::strerror(errno));
		return false;
	}

	if (0 > ::sigprocmask(SIG_SETMASK, &m_sigset, &old)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	if (nullptr == g_signals_mutex)
		g_signals_mutex = new std::mutex();

	if (nullptr == g_signals)
		g_signals = new std::bitset< _NSIG >();

	for (std::size_t sig = 1; sig < _NSIG; sig++) {
		struct sigaction 	act = {0};

		switch (sig) {
			case SIGHUP:
			case SIGINT:
			case SIGQUIT:
			case SIGTRAP:
			case SIGUSR2:
			case SIGPIPE:
			case SIGALRM:
			case SIGCHLD:
			case SIGSTKFLT:
			case SIGUSR1:
			case SIGTERM:
			case SIGCONT:
			case SIGTSTP:
			case SIGTTIN:
			case SIGTTOU:
			case SIGURG:
			case SIGXCPU:
			case SIGXFSZ:
			case SIGVTALRM:
			case SIGPROF:
			case SIGWINCH:
			case SIGIO:
			case SIGPWR:
			case SIGUNUSED:
				act.sa_flags 		= SA_NOCLDWAIT|SA_SIGINFO|SA_ONSTACK;
				act.sa_sigaction  	= &service_t::shandler;
	
				::memcpy(&act.sa_mask, &m_sigset, sizeof(sigset_t));

				if (0 > ::sigdelset(&act.sa_mask, sig)) {
					m_log->ERROR("Error in ::sigdelset(", sig, "): ", ::strerror(errno));
					break;
				}

				if (0 > ::sigaction(sig, &act, nullptr)) 
					m_log->ERROR("Error in ::sigaction(", sig, "): ", ::strerror(errno));

				break;
		
			case SIGSEGV:
			case SIGILL:
			case SIGFPE:
			case SIGABRT:
			default:
				break;
		}
	}

	if (0 > ::sigprocmask(SIG_SETMASK, &old, nullptr)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	m_log->DEBUG("returning success");
    return true;
}

bool
service_t::block_signal(signed int num)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	struct sigaction 				a({0});
	sigset_t						o({0});

	m_log->DEBUG("entered");

	if (0 > num || _NSIG <= num) {
		m_log->ERROR("Called with an invalid parameter: ", num);
		return false;
	}

	if (0 > ::sigprocmask(SIG_SETMASK, &m_sigset, &o)) {
		m_log->ERROR("Error in ::sigprocmask(): ", 
	}

	if (0 > ::sigaddset(&m_sigset, num)) {
		m_log->ERROR("Error in ::sigaddset(): ", ::strerror(errno));
		return false;
	}

	a.sa_flags 		= SA_SIGINFO|SA_ONSTACK|SA_NOCLDSTOP;
	a.sa_sigaction	= &service_t::shandler;
	
	::memcpy(&a.sa_mask, &m_sigset, sizeof(sigset_t));


	if (0 > ::sigaction(num, &a, nullptr)) {
		m_log->ERROR("Error in ::sigaction(): ", ::strerror(errno));
		return false;
	}

	m_log->DEBUG("returning successfully");
	return true;
}

bool
service_t::unblock_signal(signed int num)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	struct sigaction				a({0});

	m_log->DEBUG("entered");

	if (0 > num || _NSIG <= num) {
		m_log->ERROR("Called with an invalid parameter: ", num);
		return false;
	}

	if (0 > ::sigdelset(&m_sigset, num)) {
		m_log->ERROR("Error in ::sigdelset(): ", ::strerror(errno));
		g_signals_mutex->unlock();
		return false;
	}

	a.sa_flags 		= 0;
	a.sa_handler 	= SIG_DFL;

	if (0 > ::sigaction(num, &a, nullptr)) {
		m_log->ERROR("Error in ::sigaction(): ", ::strerror(errno));
		return false;
	}

	m_log->DEBUG("returning successfully");
	return true;
}

bool
service_t::pending_signals(std::bitset< _NSIG >& bs)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	sigset_t						o({0});

	m_log->DEBUG("entered");


	if (0 > ::sigprocmask(SIG_SETMASK, &m_sigset, &o)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	bs = *g_signals;
	g_signals->reset();

	if (0 > ::sigprocmask(SIG_SETMASK, &o, nullptr)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	m_log->DEBUG("exited successfully");
	return true;
}

bool
service_t::pending_signals(signed int num)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	bool							r(false);
	sigset_t						o({0});

	//m_log->DEBUG("entered");

	if (0 > ::sigprocmask(SIG_SETMASK, &m_sigset, &o)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	if (0 > num || _NSIG <= num) {
		m_log->ERROR("Parameter specifies an invalid signal number: ", num);
		return false;
	}

	
	r = g_signals->test(num);
	g_signals->reset(num);

	if (0 > ::sigprocmask(SIG_SETMASK, &o)) {
		m_log->ERROR("Error in ::sigprocmask(): ", ::strerror(errno));
		return false;
	}

	if (true == r)
		m_log->DEBUG("exited ", r);

	return r;
}

bool
service_t::has_signals(void)
{
	std::lock_guard< std::mutex > 	l(m_mutex);
	bool							r(false);

	m_log->DEBUG("entered");

	if (nullptr == g_signals_mutex) {
		m_log->ERROR("Global signals mutex has not been initialized");
		return false;
	}

	g_signals_mutex->lock();
	r = g_signals->any();
	g_signals_mutex->unlock();

	m_log->DEBUG("exiting ", r);
	return r;
}

log_t&
service_t::get_log(void)
{
	std::lock_guard< std::mutex > l(m_mutex);

	m_log->DEBUG("entered/exit (tail call)");
	return *m_log;
}

bool
service_t::translateUserGroupToUidGid(void)
{
	struct passwd* pwd = ::getpwnam(m_user.c_str());

	m_log->DEBUG("entered");

	if (nullptr == pwd) {
		m_log->ERROR("Error calling ::getpwnam()", ::strerror(errno));
		return false;
	}

	m_uid = pwd->pw_uid;
	m_gid = pwd->pw_gid;
	
	m_log->DEBUG("returning success");
	return true;
}
