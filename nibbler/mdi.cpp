#include "stdafx.h"
#include "mdi.h"

//mdi_t* mdi_t::m_mdi = nullptr;


mdi_t::mdi_t(QWidget* p) : QMdiArea(p)
{
	m_image = new QImage(":/img/nibbler-head.png");

	this->setMinimumSize(800,600);
	return;
}

mdi_t::~mdi_t(void)
{
	delete m_image;
	return;
}

/*mdi_t&
mdi_t::getInstance(void)
{
	if ( nullptr != m_mdi )
		return *m_mdi;

	m_mdi = new mdi_t();
	return *m_mdi;
}*/

void
mdi_t::resizeEvent(QResizeEvent* e)
{
	// XXX JF nullptr == e ? 
	QImage		nbg(e->size(), QImage::Format_ARGB32_Premultiplied);
	QPainter	p(&nbg);
    QImage		scaled = m_image->scaled(e->size()/3,Qt::KeepAspectRatio);
	QRect		scaledRect = scaled.rect();

	p.fillRect(nbg.rect(), Qt::gray);
	scaledRect.moveCenter(nbg.rect().center());
	p.drawImage(scaledRect, scaled);
	setBackground(nbg);
	QMdiArea::resizeEvent(e);
	return; 
}
