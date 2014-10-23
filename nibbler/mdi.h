#ifndef MDI_H
#define MDI_H

#include <QMdiArea>
#include <QResizeEvent>
#include <QPainter>
#include <QImage>

class mdi_t : public QMdiArea
{
	Q_OBJECT

	private:
		//static mdi_t*	m_mdi;
		QImage*			m_image;

		
		//mdi_t& operator=( const mdi_t& );

	protected:
		void resizeEvent(QResizeEvent*);

	public:
		mdi_t(QWidget* p = nullptr);
		~mdi_t(void);
		//static mdi_t& getInstance(void);


};

#endif // MDI_H
