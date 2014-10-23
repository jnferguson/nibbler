#include "stdafx.h"
#include "globals.hpp"


static const char*	g_org = "The American School of Acrimonious Collisions";
static const char* g_url = "www.asac.co";
static const char* g_app = "nibbler";

const char* org(void) { return g_org; }
const char* url(void) { return g_url; }
const char* app(void) { return g_app; }

QSettings*
getSettings(void)
{
	return new QSettings(QSettings::NativeFormat, QSettings::UserScope, g_org, g_app);
}

datagram_t*
allocateDatagram(uint16_t psiz)
{
	std::size_t len = offsetof(_datagram_t, ports[ psiz ]);
	datagram_t*	ret = static_cast<_datagram_t*>( ::calloc(len, 1) );

	ret->magic = DATAGRAM_MAGIC;
	return ret;
}

void
destroyDatagram(datagram_t* d)
{
	if ( nullptr != d )
		::free(d);

	return;
}

/*mdiWin_t& getTopWindow(void)
{
	return mdiWin_t::getInstance();
}*/