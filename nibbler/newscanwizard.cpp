#include "stdafx.h"
#include "newscanwizard.hpp"

newscanWizard_t::newscanWizard_t(QWidget* p) : QWizard(p)
{
	confirmPage_t* confirm = new confirmPage_t(this);

	setDefaultProperty("QPlainTextEdit", "plainText", SIGNAL(textChanged())); // &QPlainTextEdit::textChanged); // "textChanged");

	addPage(new hostsPage_t(this));
	addPage(new portsPage_t(this));
	addPage(new nodesPage_t(this));
	addPage(confirm);
	setWindowTitle("New scan wizard");
	setWizardStyle(QWizard::ModernStyle);
	setOption(QWizard::WizardOption::ExtendedWatermarkPixmap); 
	setPixmap(QWizard::WizardPixmap::WatermarkPixmap, QPixmap(":/img/nibbler-logo.png"));

	
	connect(this, &QWizard::finished, this, &newscanWizard_t::isDone);
	return;
}

newscanWizard_t::~newscanWizard_t(void)
{
	return;
}

void newscanWizard_t::isDone(void)
{
	QMdiSubWindow* c = qobject_cast<QMdiSubWindow*>( parentWidget() );
	c->close();
	return;
}

hostsPage_t::hostsPage_t(QWizard* p) : QWizardPage(p)
{

	m_hosts		= new QPlainTextEdit(this);
	m_layout	= new QVBoxLayout(this);

	m_layout->addWidget(m_hosts);
	setLayout(m_layout);

	setTitle("Add hosts");
	setSubTitle("Specify a series of comma separated hosts and/or networks either by name or IP address in CIDR format");

	m_hosts->setPlaceholderText("127.0.0.0/8, 127, 192.168.10.0/255.255.255.0");

	registerField("hosts", m_hosts);

	return;
}

hostsPage_t::~hostsPage_t(void)
{
	return;
}

bool 
hostsPage_t::validatePage(void)
{
	QString				hosts		= m_hosts->toPlainText();
	QString				normalized	= "";
	std::size_t			cnt			= 0;

	for ( QString& host : hosts.split(",", QString::SkipEmptyParts) ) {
		QPair<QHostAddress, int> np = QHostAddress::parseSubnet(host);

		if ( QAbstractSocket::IPv4Protocol != np.first.protocol() ) {
			QMessageBox::warning(this, "Add hosts", "At present, only IPv4 addresses are specified and an address from "
								 "another protocol address was specified");
			return false;
		}

		normalized += np.first.toString() + "/" + QString::number(np.second) + ",";

		cnt++;
	}

	if ( 0 == cnt ) {
		QMessageBox::warning(this, "Add hosts", "No hosts specified!");
		return false;
	}

	normalized.chop(1);
	setField("hosts", normalized);
//	setField("hosts", m_hosts->toPlainText());
	return true;
}

portsPage_t::portsPage_t(QWizard* p) : QWizardPage(p)
{
	m_ports		= new QPlainTextEdit(this);
	m_layout	= new QVBoxLayout(this);

	m_layout->addWidget(m_ports);
	setLayout(m_layout);

	setTitle("Add Ports");
	setSubTitle("Specify a series of comma separated hosts and/or networks either by name number");
	m_ports->setPlaceholderText("22, http, 53, 443, 1-65535");

	registerField("ports", m_ports);
	return;
}

portsPage_t::~portsPage_t(void)
{
	return;
}

bool
portsPage_t::validatePage(void)
{
	QString				ports = m_ports->toPlainText();
	std::size_t			cnt = 0;
	uint16_t			p = 0;

	if ( 0 == ports.length() ) {
		QMessageBox::warning(this, "Invalid port selection", "You must select at least one port to scan.");
		return false;
	}

	for ( QString& port : ports.split(",", QString::SkipEmptyParts) ) {
		bool ok		= false;
		long val	= 0; // port.toLong(&ok, 10);

		if ( port.contains("-") ) {
			QStringList p = port.split("-", QString::SkipEmptyParts);
			long		v0 = 0;
			long		v1 = 0;

			if ( 2 != p.size() ) {
				QMessageBox::warning(this, "Invalid port selection", "A range of ports was specified, however its format was invalid");
				return false;
			}
			
			v0 = p.at(0).toLong(&ok, 10);

			if ( false == ok ) {
				if ( false == services_map_t::isValidProtocolName(const_cast< QString& >(p.at(0))) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					return false;
				}

				if ( false == services_map_t::getPortByName(const_cast< QString& >( p.at(0) ), 
															reinterpret_cast< uint16_t& >( v0 )) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					return false;
				}
			}

			v1 = p.at(1).toLong(&ok, 10);

			if ( false == ok ) {
				if ( false == services_map_t::isValidProtocolName(const_cast< QString& >( p.at(1) )) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					return false;
				}

				if ( false == services_map_t::getPortByName(const_cast< QString& >( p.at(1) ), 
															reinterpret_cast< uint16_t& >( v1 )) ) {

					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					return false;
				}
			}

			if ( 65535 < v0 || 65535 < v1 || v1 < v0 ) {
				QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
				return false;
			}

			continue;
		}

		val = port.toLong(&ok, 10);

		if ( false == ok ) {
			if ( false == services_map_t::isValidProtocolName(port) )  {
				QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
				return false;
			} 

			continue;
		}

		if ( port.toLong() > 65535 ) {
			QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
			return false;
		}
	}

	return true;
}

confirmPage_t::confirmPage_t(QWizard* p) : QWizardPage(p)
{
	m_text		= new QTextEdit(this);
	m_layout	= new QVBoxLayout(this);

	m_text->setReadOnly(true);
	m_layout->addWidget(m_text);
	setLayout(m_layout);

	setTitle("Confirm Scan Settings");
	setSubTitle("Confirm the settings for your scan.");
	
	return;
}

confirmPage_t::~confirmPage_t(void)
{
	return;
}

void 
confirmPage_t::initializePage(void)
{
	m_text->clear();
	m_text->append("Hosts: " + field("hosts").toString() + 
				   "\nPorts: " + field("ports").toString() + 
				   "\nNodes: " + field("nodes").toString());

	return;
}

bool
confirmPage_t::validatePage(void)
{
	QList< QPair< QHostAddress, int > >		hosts;
	QList< uint16_t >						ports;
	QList< QString >						nodes;
	mdiWin_t&								mw(mdiWin_t::getInstance());

	for ( auto& host : field("hosts").toString().split(",", QString::SkipEmptyParts) ) 
		hosts.push_back(QHostAddress::parseSubnet(host));

	for ( auto& node : field("nodes").toString().split(",", QString::SkipEmptyParts) )
		nodes.push_back(node);

	ports = getPorts(field("ports").toString());
	
	connect(this, &confirmPage_t::confirmed, &mw, &mdiWin_t::startScan);
	//mw.newScan(hosts, ports, nodes);
	emit confirmed(hosts, ports, nodes);
	return true;
}

QList< uint16_t > 
confirmPage_t::getPorts(QString& p)
{
	QList< uint16_t > ret;

	for ( QString& port : p.split(",", QString::SkipEmptyParts) ) {
		bool ok = false;
		long val = 0; 

		if ( port.contains("-") ) {
			QStringList p = port.split("-", QString::SkipEmptyParts);
			long		v0 = 0;
			long		v1 = 0;

			if ( 2 != p.size() ) {
				QMessageBox::warning(this, "Invalid port selection", "A range of ports was specified, however its format was invalid");
				throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
			}

			v0 = p.at(0).toLong(&ok, 10);

			if ( false == ok ) {
				if ( false == services_map_t::isValidProtocolName(const_cast< QString& >( p.at(0) )) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
				}

				if ( false == services_map_t::getPortByName(const_cast< QString& >( p.at(0) ),
					reinterpret_cast< uint16_t& >( v0 )) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
				}
			}

			v1 = p.at(1).toLong(&ok, 10);

			if ( false == ok ) {
				if ( false == services_map_t::isValidProtocolName(const_cast< QString& >( p.at(1) )) ) {
					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
				}

				if ( false == services_map_t::getPortByName(const_cast< QString& >( p.at(1) ),
					reinterpret_cast< uint16_t& >( v1 )) ) {

					QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
					throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
				}
			}

			if ( 65535 < v0 || 65535 < v1 || v1 < v0 ) {
				QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
				throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
			}


			for ( std::size_t pnum = v0; pnum < v1; pnum++ )
				ret.push_back(pnum);

			ret.push_back(v1);
			continue;
		}

		val = port.toLong(&ok, 10);

		if ( false == ok ) {
			if ( false == services_map_t::isValidProtocolName(port) ) {
				QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
				throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
			}

			if ( false == services_map_t::getPortByName(const_cast< QString& >( port ), 
												reinterpret_cast< uint16_t& >( val )) ) {

				QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
				throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
			}

			ret.push_back(val);

			continue;
		}

		if ( port.toLong() > 65535 ) {
			QMessageBox::warning(this, "Invalid port", "An invalid port was specified");
			throw std::runtime_error("A condition that shouldn't be possible to occur none the less somehow occurred.");
		}

		ret.push_back(val);
	}

	return ret;
}

bool 
nodesPage_t::validatePage(void)
{
	std::size_t cnt = 0;

	if ( !m_list->count() ) {
		QMessageBox::warning(this, "Invaid Node Selection", "You must select at least one node to scan with");
		return false;
	}

	m_nodes->clear();

	for ( std::size_t idx = 0; idx < m_list->count(); idx++ ) {
		QListWidgetItem* ptr = m_list->item(0);

		if ( ptr->checkState() == Qt::CheckState::Checked ) {
			m_nodes->appendPlainText(ptr->text());
			cnt++;
		}
	}
	

	if ( 0 == cnt ) {
		QMessageBox::warning(this, "Invaid Node Selection", "You must select at least one node to scan with");
		return false;
	}

	return true;
}

nodesPage_t::nodesPage_t(QWizard* p) : QWizardPage(p)
{
	m_nodes		= new QPlainTextEdit(this);
	m_layout	= new QVBoxLayout(this);
	m_list		= new QListWidget(this);

	m_nodes->setVisible(false);

	m_layout->addWidget(m_list);
	setLayout(m_layout);

	setTitle("Add Nodes");
	setSubTitle("Specify the nodes you wish to scan the hosts with.");

	registerField("nodes", m_nodes);
	return;

}

nodesPage_t::~nodesPage_t(void)
{
	return;
}

void
nodesPage_t::initializePage(void)
{
	QSettings*	s(::getSettings());
	QStringList n;

	s->beginGroup("Nodes");
	n = s->childGroups(); 

	for ( auto& node : n ) {
		QListWidgetItem* item = new QListWidgetItem(m_list);

		item->setFlags(item->flags() | Qt::ItemIsUserCheckable);
		item->setCheckState(Qt::CheckState::Checked);
		item->setText(node);
		m_list->addItem(item);

	}

	s->endGroup();
	delete s;

	return;
}