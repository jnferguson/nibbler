#include "stdafx.h"
#include "nmenu.h"

nmenu_t::nmenu_t(QWidget* p) : QWidget(p)
{
	m_layout	= new QVBoxLayout(this);
	m_new		= new QPushButton(this);
	m_load		= new QPushButton(this);
	m_settings	= new QPushButton(this);
	m_quit		= new QPushButton(this);

	this->resize(175, 130);

	m_layout->addWidget(m_new);
	m_layout->addWidget(m_load);
	m_layout->addWidget(m_settings);
	m_layout->addWidget(m_quit);

	m_quit->setMinimumSize(QSize(160, 25));
	
	this->setWindowTitle("MENU");
	m_new->setText("New Scan");
	m_load->setText("Load Scan");
	m_settings->setText("Settings");
	m_quit->setText("Quit");

	QObject::connect(m_new, &QPushButton::pressed, this, &nmenu_t::newScan);

	return;
}

nmenu_t::~nmenu_t(void)
{
	return;
}

void 
nmenu_t::newScan(void)
{
	newscanWizard_t* ns = new newscanWizard_t(nullptr);
	emit newWindow(ns);

	//newscan_t* ns = new newscan_t(nullptr);
	//emit newWindow(ns);
	return;
}
