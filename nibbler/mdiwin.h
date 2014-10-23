#ifndef MDIWIN_H
#define MDIWIN_H

#include <QVariant>
#include <QAction>
#include <QApplication>
#include <QButtonGroup>
#include <QHeaderView>
#include <QMainWindow>
#include <QMdiSubWindow>
#include <QMenu>
#include <QMenuBar>
#include <QStatusBar>
#include <QVBoxLayout>
#include <QWidget>
#include <QIcon>
#include <QMessageBox>
#include <QList>
#include <QHostAddress>

#include <cstdint>
#include <limits>
#include "mdi.h"
#include "globals.hpp"
#include "localnode.hpp"

class mdiWin_t : public QMainWindow
{
	Q_OBJECT

	public slots:
		void openWindow(QWidget*);
		
		void startScan(QList< QPair<QHostAddress, int> >&, QList< uint16_t >&, QList< QString >&);
		//void help(void);

	private:
		static mdiWin_t*		m_instance;
		QWidget*				m_central;			//centralwidget;
		QVBoxLayout*			m_layout;			//verticalLayout;
		mdi_t*					m_mdi;
		QMenuBar*				m_menubar;			//menubar;
		QMenu*					m_menuFile;			//menuFile;
		QMenu*					m_menuEdit;			//menuEdit;
		QMenu*					m_menuSettings;		//menuSettings;
		QMenu*					m_menuHelp;			//menuHelp;
		QStatusBar*				m_status;			//statusbar;

		localNode_t*			m_lnode;

		mdiWin_t(QWidget* p = nullptr);
		mdiWin_t& operator=( const mdiWin_t& );

	protected:
		void newSubWindow(QWidget*);
		void initMenu(void);

	public:
		~mdiWin_t(void);
		static mdiWin_t& getInstance(void);
		void newScan(QList< QPair<QHostAddress, int> >&, QList< uint16_t >&, QList< QString >&);

};

#endif // MDIWIN_H
