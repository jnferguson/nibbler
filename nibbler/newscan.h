#ifndef NEWSCAN_H
#define NEWSCAN_H

#include <QWidget>
#include <QVariant>
#include <QAction>
#include <QApplication>
#include <QButtonGroup>
#include <QDialog>
#include <QDialogButtonBox>
#include <QHeaderView>
#include <QLabel>
#include <QTextEdit>
#include <QPushButton>
#include <QSplitter>
#include <QVBoxLayout>
#include <QWidget>
#include <QMdiSubWindow>
#include <QMessageBox>
#include <QFileDialog>
#include <QCoreApplication>

#include <cstdint>

class newscan_t : public QWidget
{
	Q_OBJECT

	protected slots:
		void closeWindow(void);
		void setPorts(void);
		void startScan(void);
		void openHostFile(void);
		void openPortFile(void);

	private:
		QVBoxLayout*		m_layout; 
		QSplitter*			m_mainHSplitter;
		QWidget*			m_logo;
		QSplitter*			m_mainVSplitter;
		QLabel*				m_label;
		QTextEdit*			m_edit;
		QSplitter*			m_fileSplitter;
		QWidget*			m_fileWidget;
		QPushButton*		m_loadFileButton;
		QDialogButtonBox*	m_buttons;

		QStringList			m_hosts;
		QStringList			m_ports;

	protected:
		bool		validateHosts(void);
		bool		validatePorts(void);
		bool		isIpv4(QString&);
		bool		isIpv6(QString&);

		uint32_t	ipv4Address(QString&);
		uint32_t	ipv4Bitmask(QString&);

	public:
		newscan_t(QWidget* p = nullptr);
		~newscan_t(void);
};

#endif // NEWSCAN_H
