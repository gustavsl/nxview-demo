#include "qmlplot.h"
#include "qcustomplot.h"
#include "fileio.h"
#include <QDebug>
#include <QFile>

CustomPlotItem::CustomPlotItem( QQuickItem* parent ) : QQuickPaintedItem( parent )
    , m_CustomPlot( nullptr ), m_timerId( 0 )
{
    setFlag( QQuickItem::ItemHasContents, true );
    //setAcceptedMouseButtons( Qt::AllButtons );

    connect( this, &QQuickPaintedItem::widthChanged, this, &CustomPlotItem::updateCustomPlotSize );
    connect( this, &QQuickPaintedItem::heightChanged, this, &CustomPlotItem::updateCustomPlotSize );
}

CustomPlotItem::~CustomPlotItem()
{
    delete m_CustomPlot;
    m_CustomPlot = nullptr;

    if(m_timerId != 0) {
        killTimer(m_timerId);
    }
}

void CustomPlotItem::initCustomPlot()
{
    m_CustomPlot = new QCustomPlot();

    updateCustomPlotSize();
    m_CustomPlot->addGraph();
    m_CustomPlot->graph( 0 )->setPen( QPen(Qt::red,3) );
    m_CustomPlot->xAxis->setLabel( "t" );
    m_CustomPlot->yAxis->setLabel( "T" );
    m_CustomPlot->xAxis->setRange( 0, 10 );
    m_CustomPlot->yAxis->setRange( 0, 120 );
    //m_CustomPlot ->setInteractions( );

    startTimer(1000);

    connect( m_CustomPlot, &QCustomPlot::afterReplot, this, &CustomPlotItem::onCustomReplot );

    m_CustomPlot->replot();
}


void CustomPlotItem::paint( QPainter* painter )
{
    if (m_CustomPlot)
    {
        QPixmap    picture( boundingRect().size().toSize() );
        QCPPainter qcpPainter( &picture );

        m_CustomPlot->toPainter( &qcpPainter );

        painter->drawPixmap( QPoint(), picture );
    }
}


void CustomPlotItem::timerEvent(QTimerEvent *event)
{
    static double t;
//    U = ((double)rand() / RAND_MAX) * 5;
    QFile file("/analog_ios/ain1/input");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return;
    int tempInt = file.readAll().trimmed().toInt();
    //qDebug() << tempInt;
    double tempValue = (double)tempInt/10;
    m_CustomPlot->graph(0)->addData(t, tempValue);
    //qDebug() << Q_FUNC_INFO << QString("Adding dot t = %1, T = %2").arg(t).arg(tempValue);
    t++;
    m_CustomPlot->xAxis->rescale();
    m_CustomPlot->replot();
}


void CustomPlotItem::updateCustomPlotSize()
{
    if (m_CustomPlot)
    {
        m_CustomPlot->setGeometry(0, 0, (int)width(), (int)height());
        m_CustomPlot->setViewport(QRect(0, 0, (int)width(), (int)height()));
    }
}

void CustomPlotItem::onCustomReplot()
{
   // qDebug() << Q_FUNC_INFO;
    update();
}
