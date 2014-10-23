#ifndef LOCALNODE_HPP
#define LOCALNODE_HPP

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QByteArray>
#include <QString>
#include <QList>
#include <QSettings>
#include <QMessageBox>
#include <QMutex>
#include <QWaitCondition>
#include <QRunnable>
#include <QThread>

#include <cstdint>
#include "globals.hpp"

class worker_t : public QObject
{
	Q_OBJECT

	public slots:
		void run(void);


	private:
		//bool							m_quit;
		QWaitCondition&					m_wait;
		QLinkedList< datagram_t* >&		m_list;
		QMutex&							m_mutex;

	protected:
		void processScan(datagram_t&);
		void processStatus(datagram_t&);
		void processResults(datagram_t&);

	public:
		worker_t(QObject*, QWaitCondition&, QLinkedList< datagram_t* >&, QMutex&);
		~worker_t(void);

};


class localNode_t : public QObject
{
	Q_OBJECT

	signals:
		void exiting(void);

	protected slots:
		void process(void);

	private:
		QThread**					m_threads;
		std::size_t					m_count;
		QWaitCondition				m_condition;
		QMutex						m_mutex;
		QUdpSocket*					m_socket;
		QLinkedList< datagram_t* >	m_list;

	protected:
		void initThreads(void);

	public:
		localNode_t(QObject* p = nullptr);
		~localNode_t(void);	
};

#endif // LOCALNODE_HPP
