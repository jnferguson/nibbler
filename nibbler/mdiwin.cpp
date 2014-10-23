#include "stdafx.h"
#include "mdiwin.h"
#include "nmenu.h"
#include "newscan.h"

mdiWin_t* mdiWin_t::m_instance = nullptr;

mdiWin_t::mdiWin_t(QWidget* p) : QMainWindow(p)
{
	m_central		= new QWidget(this);
	m_status		= new QStatusBar(this);
	m_menubar		= new QMenuBar(this);
	m_layout		= new QVBoxLayout(m_central);
	m_mdi			= new mdi_t(m_central); //new QMdiArea(m_central);
	m_menuFile		= new QMenu(m_menubar);
	m_menuEdit		= new QMenu(m_menubar);
	m_menuSettings	= new QMenu(m_menubar);
	m_menuHelp		= new QMenu(m_menubar);
	m_lnode			= new localNode_t(this);

    this->resize(1024, 768);
	this->setMenuBar(m_menubar);
	this->setStatusBar(m_status);
	this->setCentralWidget(m_central);
	this->setWindowIcon(QIcon(":/img/nibbler.ico"));

	m_layout->addWidget(m_mdi);

	m_menubar->setGeometry(QRect(0, 0, 1024, 21));
	m_menubar->addAction(m_menuFile->menuAction());
	m_menubar->addAction(m_menuEdit->menuAction());
	m_menubar->addAction(m_menuSettings->menuAction());
	m_menubar->addAction(m_menuHelp->menuAction());

	this->setWindowTitle("Nibbler");
	m_menuFile->setTitle("&File");
	m_menuEdit->setTitle("&Edit");
	m_menuSettings->setTitle("&Settings");
	m_menuHelp->setTitle("&Help");

	initMenu();
	return;
}

mdiWin_t::~mdiWin_t(void)
{
	return;
}

mdiWin_t&
mdiWin_t::getInstance(void)
{
	if ( nullptr != m_instance )
		return *m_instance;

	m_instance = new mdiWin_t(nullptr);
	return *m_instance;
}

void
mdiWin_t::openWindow(QWidget* w)
{
	newSubWindow(w);
	return;
}

void
mdiWin_t::initMenu(void)
{
	nmenu_t*		nm = new nmenu_t(this);
	QMdiSubWindow*	sw = new QMdiSubWindow(m_mdi);

	QObject::connect(nm, &nmenu_t::newWindow, this, &mdiWin_t::openWindow);

	sw->setWidget(nm);
	sw->setAttribute(Qt::WA_DeleteOnClose);
	m_mdi->addSubWindow(sw);
	sw->move(m_mdi->width()/4, m_mdi->height()/2);
	sw->show();
	return;
}

void
mdiWin_t::newSubWindow(QWidget* w)
{
	QMdiSubWindow*	s(nullptr);

	if (nullptr == m_mdi || nullptr == w) 
		return;

	s = new QMdiSubWindow(m_mdi);
	w->setParent(s);
	s->setWidget(w);
	s->setAttribute(Qt::WA_DeleteOnClose);
	m_mdi->addSubWindow(s);

	s->move(m_mdi->width()/4, m_mdi->height()/4);
	s->show();
	return;
}

void 
mdiWin_t::startScan(QList< QPair<QHostAddress, int> >& h, QList< uint16_t >& p, QList< QString >& n)
{
	QSettings	s(QSettings::NativeFormat, QSettings::UserScope, org(), app());
	bool		ok(false);
	QList< QPair< QString, uint16_t > > nodes;
	std::size_t idx = 0;

	QString		host(s.value("Nodes/Localhost/address", "127.0.0.1").toString());
	uint16_t	port(s.value("Nodes/Localhost/port", 3030).toInt(&ok));
	QUdpSocket	sock;
	datagram_t* dg(nullptr); // datagram_t::getDatagram(h.size(), p.size()));
	QLinkedList< QString > ll;

	if ( USHRT_MAX < p.size() ) {
		QMessageBox::warning(this, "Invalid Scan Parameters", "An invalid scan size was specified; there were over 65,000 ports");
		return;
	}

	for ( auto& node : n ) {
		QString		nhost(s.value("Nodes/" + node + "/address", "").toString());
		uint16_t	nport(s.value("Nodes/" + node + "/port", 0).toInt(&ok));

		if ( 0 == nhost.length() || 0 == nport || false == ok || 65535 < nport ) {
			QMessageBox::warning(this, "Error", "Error while retrieving node address/port pair: " + node);
			return;
		}

		nodes.push_back(QPair< QString, uint16_t >(nhost, nport));
	}

	for ( auto& rnet : h ) {
		qint64 ret = 0;

		if ( idx >= nodes.size() )
			idx = 0;

		dg = ::allocateDatagram(p.size());

		dg->cmd		= CMD_SCAN;
		dg->ver		= 0x00;
		dg->netmask = rnet.second;
		dg->network = rnet.first.toIPv4Address();
		dg->cnt		= p.size();

		for ( std::size_t pidx = 0; pidx < dg->cnt; pidx++ )
			dg->ports[ pidx ] = p.at(pidx);

		ret = sock.writeDatagram(reinterpret_cast< const char*>( dg ), dg->size(), QHostAddress(nodes.at(idx).first), nodes.at(idx).second);

		if ( ret != dg->size() ) {
			QMessageBox::warning(this, "Error", "Error sending request to node " + nodes.at(idx).first);
			::destroyDatagram(dg);
			return;
		}

		::destroyDatagram(dg);
	}

	/*
	dg = ::allocateDatagram(h.size(), p.size());
	dg->cmd		= CMD_SCAN;
	dg->ncnt	= h.size();
	dg->pcnt	= p.size();
	
	for ( std::size_t idx = 0; idx < dg->ncnt; idx++ ) {
		dg->net[ idx ].address	= h.at(idx).first.toIPv4Address();
		dg->net[ idx ].netmask	= h.at(idx).second;
	}

	for ( std::size_t idx = 0; idx < dg->pcnt; idx++ )
		dg->ports[ idx ] = p.at(idx);

	sock.writeDatagram(reinterpret_cast< const char*>( dg ), dg->size(), QHostAddress(host), port);
	//sock.writeDatagram(QByteArray("HELLO"), QHostAddress(host), port);

	::destroyDatagram(dg);*/

	return;
}