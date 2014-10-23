#include "stdafx.h"
#include "mdiwin.h"
#include "globals.hpp"
#include <QApplication>
#include <QSettings>

#include "localnode.hpp"

signed int
main(signed int ac, char** av)
{
	QApplication::setStyle(QStyleFactory::create("Fusion"));
	QCoreApplication::setOrganizationName(org());
	QCoreApplication::setOrganizationDomain(url());
	QCoreApplication::setApplicationName(app());
	QSettings set(QSettings::NativeFormat, QSettings::UserScope, org(), app());

	QApplication a(ac, av);
	mdiWin_t& w(mdiWin_t::getInstance());
	
	if ( !set.value("Nodes/localhost", "").toString().length() ) {
		set.setValue("Nodes/localhost/address", "127.0.0.1");
		set.setValue("Nodes/localhost/port", "3030");
		set.setValue("Nodes/localhost/auth", "false");
	}

	w.show();
	return a.exec();
}
