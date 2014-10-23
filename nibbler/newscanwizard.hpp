#ifndef NEWSCANWIZARD_HPP
#define NEWSCANWIZARD_HPP

#include <QWidget>
#include <QWizard>
#include <QWizardPage>
#include <QVBoxLayout>
#include <QPlainTextEdit>
#include <QTextEdit>
#include <QPixmap>
#include <QMdiSubWindow>
#include <QListWidget>
#include <QLineEdit>
#include <QMessageBox>
#include <QHostAddress>
#include <QList>
#include <QSettings>
#include <cstdint>
#include "mdiwin.h"
#include "services.hpp"
#include "globals.hpp"

class hostsPage_t : public QWizardPage
{
	private:
		QVBoxLayout*		m_layout;
		QPlainTextEdit*		m_hosts;

	protected:
		bool validatePage(void);

	public:
		hostsPage_t(QWizard* p = nullptr);
		~hostsPage_t(void);

};

class portsPage_t : public QWizardPage
{
	private:
		QVBoxLayout*		m_layout;
		QPlainTextEdit*		m_ports;

	protected:
		bool validatePage(void);

	public:
		portsPage_t(QWizard* p = nullptr);
		~portsPage_t(void);
};

class nodesPage_t : public QWizardPage
{
	private:
		QVBoxLayout*		m_layout;
		QListWidget*		m_list;
		QPlainTextEdit*		m_nodes;

	protected:
		bool validatePage(void);

	public:
		nodesPage_t(QWizard* p = nullptr);
		~nodesPage_t(void);
		void initializePage(void);

};

class confirmPage_t : public QWizardPage
{
	Q_OBJECT

	signals:
		void confirmed(QList< QPair<QHostAddress, int> >&, QList< uint16_t >&, QList< QString >&);

	private:
		QVBoxLayout*	m_layout;
		QTextEdit*		m_text;

	protected:
		bool validatePage(void);
		QList< uint16_t > getPorts(QString&);

	public:
		confirmPage_t(QWizard* p = nullptr);
		~confirmPage_t(void);
		void initializePage(void);

};

class newscanWizard_t : public QWizard
{
	Q_OBJECT

	private slots:
			void isDone(void);
	private:
		QWizardPage*	m_pages[ 2 ];

	protected:
	public:
		newscanWizard_t(QWidget* p = nullptr);
		~newscanWizard_t(void);
};

#endif // NEWSCANWIZARD_HPP
