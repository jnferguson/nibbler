#include "service.hpp"

service_t::service_t(std::string& dir) : m_dir(dir), m_user("nobody")
{

    if (0 != ::geteuid())
        throw invalidUserException_t("User is not super while requiring a chroot call");

    if (false == doFileSystemOperations())
        throw filesystemException_t("Error while closing files, chrooting, et cetera");

    if (false == doDetachOperations())
        throw detachException_t("Error while forking/detaching from controlling terminal");

    if (false == doUserGroupOperations())
        throw userGroupException_t("Error while dropping privileges");

    if (false == doResourceLimitOperations())
        throw rlimitException_t("Error while setting service rlimits");

    if (false == doSignalHandlerOperations())
        throw signalHandlerException_t("Error while installing signal handlers");

    return;
}

service_t::service_t(const char* dir) : m_dir(dir), m_user("nobody")
{
	if (0 != ::getuid())
		throw invalidUserException_t("User is not super while requiring a chroot call");

	if (false == doFileSystemOperations())
		throw filesystemException_t("Error while closing files, chrooting, et cetera");

	if (false == doDetachOperations())
		throw detachException_t("Error while forking/detaching from controlling terminal");

	if (false == doUserGroupOperations())
		throw userGroupException_t("Error while dropping privileges");

	if (false == doResourceLimitOperations())
		throw rlimitException_t("Error while setting service rlimits");

	if (false == doSignalHandlerOperations())
		throw signalHandlerException_t("Error while installing signal handlers");

	return;
}

service_t::~service_t(void)
{
    return;
}

bool
service_t::doFileSystemOperations(void)
{
    long            mfd = 0;
    signed int      fd  = 0;

    ::umask(S_IRUSR|S_IWUSR|S_IXUSR);

    mfd = ::sysconf(_SC_OPEN_MAX);

    if (0 > mfd)
        return false;

    for (long idx = 0; idx < mfd; idx++)
        (void)::close(idx);

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

    if (0 > ::chdir(m_dir.c_str()))
        return false;

    if (0 > ::chown(m_dir.c_str(), static_cast< uid_t >(0), static_cast< gid_t >(0)))
        return false;

    if (0 > ::chmod(m_dir.c_str(), S_IRUSR|S_IWUSR|S_IXUSR))
        return false;

    if (0 > ::chroot(m_dir.c_str()))
        return false;

    return true;
}

bool
service_t::doUserGroupOperations(void)
{

    struct passwd* pwd = ::getpwnam(m_user.c_str());

    if (NULL == pwd)
        return false;

    m_uid = pwd->pw_uid;
    m_gid = pwd->pw_gid;

    if (0 > ::setgid(m_gid))
        return false;

    if (0 > ::setuid(m_uid))
        return false;

    return true;
}

bool
service_t::doDetachOperations(void)
{
    pid_t pid   = 0;

    if (1 == ::getppid())
        return true;

    pid = ::fork();

    switch (pid) {
        case 0:     // child
            break;
        case -1:    // error
            return false;
            break;
        default:    // parent
            ::_exit(EXIT_SUCCESS);
            break;
    }

    if (0 > ::setsid())
        return false;


    return true;
}

bool
service_t::doResourceLimitOperations(void)
{
    return true;
}

bool
service_t::doSignalHandlerOperations(void)
{
    return true;
}

