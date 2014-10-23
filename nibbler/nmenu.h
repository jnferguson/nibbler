#ifndef NMENU_H
#define NMENU_H

#include <QWidget>
#include <QVariant>
#include <QAction>
#include <QApplication>
#include <QButtonGroup>
#include <QDialog>
#include <QHeaderView>
#include <QPushButton>
#include <QVBoxLayout>
#include "newscanwizard.hpp"

class nmenu_t : public QWidget
{
	Q_OBJECT

	signals:
		void newWindow(QWidget*);

	protected slots:
		void newScan(void);

	private:
		QVBoxLayout*	m_layout;
		QPushButton*	m_new;
		QPushButton*	m_load;
		QPushButton*	m_settings;
		QPushButton*	m_quit;

	protected:
	public:
		nmenu_t(QWidget* p = nullptr);
		~nmenu_t(void);
};

#endif // NMENU_H
