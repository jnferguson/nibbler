#include "stdafx.h"
#include "localnode.hpp"


localNode_t::localNode_t(QObject* p) : QObject(p)
{
	QSettings	s(QSettings::NativeFormat, QSettings::UserScope, org(), app());
	bool		ok(false);
	std::size_t	t(s.value("General/LocalNode/ThreadCount", 10).toInt(&ok));
	QString		h(s.value("Nodes/Localhost/address", "127.0.0.1").toString());
	uint16_t	o(s.value("Nodes/Localhost/port", 3030).toInt(&ok));
	
	if ( false == ok || 65535 < o )
		throw std::runtime_error("Error initializing localhost node, bad port");

	m_socket = new QUdpSocket(this);

	if ( false == m_socket->bind(QHostAddress(h), o) )
		throw std::runtime_error("Failed to bind UDP socket");

	connect(m_socket, &QUdpSocket::readyRead, this, &localNode_t::process);
	initThreads();

	return;
}

localNode_t::~localNode_t(void)
{
	m_socket->close();

	/*//for ( std::size_t idx = 0; idx < m_count; idx++ ) {
	//	m_threads[ idx ]->quit();
	//}
	emit exiting();
	m_condition.wakeAll();
	
	for ( std::size_t idx = 0; idx < m_count; idx++ ) {
		m_threads[ idx ]->wait();
	}*/

	return;
}

void
localNode_t::initThreads(void)
{
	QSettings	s(QSettings::NativeFormat, QSettings::UserScope, org(), app());
	bool		ok(false);
	std::size_t	cnt(s.value("General/LocalNode/ThreadCount", 10).toInt(&ok));

	if ( false == ok ) {
		QMessageBox::warning(nullptr, "Error", "Failed to obtain valid number of threads for localhost node");
		return;
	}

	m_count = cnt;

	m_threads = new QThread*[ m_count ];

	for ( std::size_t idx = 0; idx < cnt; idx++ ) {
		worker_t* wrk		= new worker_t(this, m_condition, m_list, m_mutex);
		m_threads[ idx ]	= new QThread(this); 

		wrk->moveToThread(m_threads[ idx ]);
		connect(m_threads[idx], &QThread::finished, wrk, &QObject::deleteLater);
		connect(m_threads[ idx ], &QThread::started, wrk, &worker_t::run);
		m_threads[ idx ]->start();
	}
}

void 
localNode_t::process(void)
{
	while ( m_socket->hasPendingDatagrams() ) {
		QByteArray	datagram;
		datagram_t*	ptr(nullptr);
		QString		str("");

		datagram.resize(m_socket->pendingDatagramSize());
		m_socket->readDatagram(datagram.data(), datagram.size());

		ptr = reinterpret_cast<datagram_t*>( ::calloc(datagram.size(), 1) );
		::memcpy_s(ptr, datagram.size(), datagram.data(), datagram.size());

		if ( ptr->magic != DATAGRAM_MAGIC ) //{
			//QMessageBox::warning(nullptr, "Error", "Received data that was not in the proper protocol format");
			continue;
		//}

		m_mutex.lock();
		m_list.push_back(ptr);
		m_mutex.unlock();
		m_condition.wakeOne();
	}

	return;
}

worker_t::worker_t(QObject* p, QWaitCondition& wc, QLinkedList< datagram_t* >& l, QMutex& m) 
	: QObject(p), m_wait(wc), m_list(l), m_mutex(m) 
{
	return;
}

worker_t::~worker_t(void)
{
	return;
}

void 
worker_t::run(void)
{
	forever{
		datagram_t* ptr(nullptr);
		uint32_t min = 0; //= ptr->network;
		uint32_t max = 0; //ptr->network | ( ~ptr->netmask );
		std::size_t cnt = 0;

		m_mutex.lock();
		m_wait.wait(&m_mutex);

		if ( m_list.empty() ) {
			m_mutex.unlock();
			continue;
		}

		ptr = m_list.takeFirst();
		m_mutex.unlock();

		if ( nullptr == ptr )
			continue;

		switch ( ptr->cmd ) {
			case CMD_SCAN:
				processScan(*ptr);

				/*if ( 0 == ptr->ver ) {
					min = ptr->network;
					max = ptr->network | ( uint32_t(-1) >> ptr->netmask );
					cnt = std::pow(2, ( 32 - ptr->netmask )); // max - min;
				}*/

				break;

			case CMD_STATUS:
				processStatus(*ptr);
				break;

			case CMD_RESULTS:
				processResults(*ptr);
				break;

			default:
				// ...
				break;
		}

		// ... do work
		::free(ptr);
	}

	return;
}

void 
worker_t::processScan(datagram_t& dg)
{
	QList< std::uint32_t >	ip_list;
	QList< std::uint16_t >	port_list;
	std::uint32_t			network_ip		= 0;
	std::uint32_t			broadcast_ip	= 0;
	std::size_t				total_ips		= 0;

	for ( std::uint16_t idx = 0; idx < dg.cnt; idx++ )
		port_list.push_back(dg.ports[ idx ]);

	switch ( dg.ver ) {
		case VERSION_IPV4:
			network_ip		= dg.network;
			broadcast_ip	= dg.network | ( std::uint32_t(-1) >> dg.netmask );
			total_ips		= std::pow(2, ( 32 - dg.netmask )); 

			for ( std::uint32_t ip = network_ip; ip < broadcast_ip; ip++ )
				ip_list.push_back(ip);

			break;

		case VERSION_IPV6:
			break;
		default:
			break;
	}

	return;
}

void 
worker_t::processStatus(datagram_t&)
{
	return;
}

void 
worker_t::processResults(datagram_t&)
{
	return;
}