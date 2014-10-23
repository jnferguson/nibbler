#include "stdafx.h"
#include "newscan.h"

newscan_t::newscan_t(QWidget* p) : QWidget(p)
{
	m_layout			= new QVBoxLayout(this);
	m_mainHSplitter		= new QSplitter(this);
	m_fileSplitter		= new QSplitter(this);
	m_buttons			= new QDialogButtonBox(this);
	m_logo				= new QWidget(m_mainHSplitter);
	m_mainVSplitter		= new QSplitter(m_mainHSplitter);
	m_label				= new QLabel(m_mainVSplitter);
	m_edit				= new QTextEdit(m_mainVSplitter);
	m_fileWidget		= new QWidget(m_fileSplitter);
	m_loadFileButton	= new QPushButton(m_fileSplitter);
	
	resize(700, 385);
	setWindowTitle("New Scan...");

	m_mainHSplitter->setOrientation(Qt::Horizontal);
        
	m_logo->setMinimumSize(QSize(218, 288));
	m_logo->setMaximumSize(QSize(218, 288));
	m_logo->setStyleSheet(QStringLiteral("background-image: url(:/img/nibbler-logo.png);"));
	m_mainHSplitter->addWidget(m_logo);
        
	m_mainVSplitter->setOrientation(Qt::Vertical);
        
	m_label->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter);
	m_label->setMargin(3);
	m_mainVSplitter->addWidget(m_label);
        
	m_mainVSplitter->addWidget(m_edit);
	m_mainHSplitter->addWidget(m_mainVSplitter);

	m_layout->addWidget(m_mainHSplitter);
	m_fileSplitter->setOrientation(Qt::Horizontal);

	m_fileWidget->setMinimumSize(QSize(538, 0));
	m_fileSplitter->addWidget(m_fileWidget);

	m_loadFileButton->setMaximumSize(QSize(125, 30));
	m_loadFileButton->setLayoutDirection(Qt::LeftToRight);
	m_fileSplitter->addWidget(m_loadFileButton);

	m_layout->addWidget(m_fileSplitter);
	m_buttons->setOrientation(Qt::Horizontal);
	m_buttons->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);

	m_layout->addWidget(m_buttons);

	m_label->setText("Enumerate host IPs to be scanned...");
	m_edit->setFocus();
	m_edit->setPlaceholderText("127.0.0.0/8, 127.0-255.0-255.0-255\n127.0.0.1");
	m_buttons->clear();
	m_buttons->addButton("Next", QDialogButtonBox::ButtonRole::AcceptRole);
	m_buttons->addButton("Cancel", QDialogButtonBox::ButtonRole::RejectRole);
	
	QObject::connect(m_buttons, &QDialogButtonBox::accepted, this, &newscan_t::setPorts);
	QObject::connect(m_buttons, &QDialogButtonBox::rejected, this, &newscan_t::closeWindow);
	QObject::connect(m_loadFileButton, &QPushButton::pressed, this, &newscan_t::openHostFile);

	m_loadFileButton->setText("Load From File...");

	return;
}

newscan_t::~newscan_t(void)
{
	return;
}

void
newscan_t::closeWindow(void)
{
	QMdiSubWindow* c = qobject_cast<QMdiSubWindow*>(parentWidget());
	c->close();
	return;
}

void
newscan_t::setPorts(void)
{
	if (false == validateHosts()) {
		QMessageBox::warning(this, "Error", "Error while validating host entries", QMessageBox::Ok);
		return;
	}

	m_label->setText("Enumerate ports/services to be scanned...");
	m_edit->setFocus();
	m_edit->setPlaceholderText("80, https, 1-1024\n3000:3010");
	m_buttons->clear();
	m_buttons->addButton("Finish", QDialogButtonBox::ButtonRole::AcceptRole);
	m_buttons->addButton("Cancel", QDialogButtonBox::ButtonRole::RejectRole);

	QObject::disconnect(m_loadFileButton, &QPushButton::pressed, this, &newscan_t::openHostFile);
	QObject::disconnect(m_buttons, &QDialogButtonBox::accepted, this, &newscan_t::setPorts);
	QObject::disconnect(m_buttons, &QDialogButtonBox::rejected, this, &newscan_t::closeWindow);

	QObject::connect(m_buttons, &QDialogButtonBox::accepted, this, &newscan_t::startScan);
	QObject::connect(m_buttons, &QDialogButtonBox::rejected, this, &newscan_t::closeWindow);	
	QObject::connect(m_loadFileButton, &QPushButton::pressed, this, &newscan_t::openPortFile);

	return;
}

void
newscan_t::startScan(void)
{
	if (false == validatePorts()) {
		QMessageBox::warning(this, "Error", "Error while validating port/service entries", QMessageBox::Ok);
		return;
	}
	
	closeWindow();

	return;
}

bool 
newscan_t::isIpv4(QString& host)
{
	QRegExp re(	"^[0-9]{1,3}(-[0-9]{0,3}){0,1}\\."
				"[0-9]{1,3}(-[0-9]{0,3}){0,1}\\."
				"[0-9]{1,3}(-[0-9]{0,3}){0,1}\\."
				"[0-9]{1,3}(-[0-9]{0,3}){0,1}"
				"\\/{0,1}[0-9]{0,2}$");

	return host.contains(re);
}

bool 
newscan_t::isIpv6(QString&)
{
	return true;
}

uint32_t	
newscan_t::ipv4Address(QString&)
{
	return 0;
}

uint32_t
newscan_t::ipv4Bitmask(QString& bm)
{
	bool			ok	= false;
	std::size_t		ret = 0;

	ret = bm.toInt(&ok, 10);
	return 0;
}

bool 
newscan_t::validateHosts(void)
{
	QStringList chosts;
	QString		hosts;

	hosts = m_edit->toPlainText();

	if ( 0 == hosts.size() )
		return false;

	m_hosts = hosts.split(",", QString::SkipEmptyParts);

	for ( auto h : m_hosts ) {
		if ( h.contains("/") && h.contains("-") )
			return false;

		if ( h.contains("/") ) {
			if ( !isIpv4(h) )
				return false;

			signed int slash = h.indexOf("/");
			QString nm = QString(h.data() + slash + 1);
			QString hp = QString(h.mid(0, slash)); 

			QMessageBox::information(this, "CIDR", hp + " " + nm, QMessageBox::Ok);



			// cidr
		} else if ( h.contains("-") ) {
			QMessageBox::information(this, "HYPHEN", h, QMessageBox::Ok);
			// hyphen
		} else {
			QMessageBox::information(this, "SINGLE IP", h, QMessageBox::Ok);
			// single ip
		}
	}

	return true;
}

bool 
newscan_t::validatePorts(void)
{
	QString ports = m_edit->toPlainText();

	if ( 0 == ports.size() )
		return false;

	m_ports = ports.split(",", QString::SkipEmptyParts);

	return true;
}

void
newscan_t::openHostFile(void)
{
	/* QString = */ QFileDialog::getOpenFileName(this, tr("Open file with Hosts"), QCoreApplication::applicationDirPath(), tr("All Files (*.*)"));
	return;
}

void
newscan_t::openPortFile(void)
{
	/* QString = */ QFileDialog::getOpenFileName(this, tr("Open file with Ports"), QCoreApplication::applicationDirPath(), tr("All Files (*.*)"));
	return;
}