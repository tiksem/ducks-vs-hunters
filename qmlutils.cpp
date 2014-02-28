#include "qmlutils.h"
#include <QTimer>
#include "qutils.h"
#include <QQuickImageProvider>
#include <QRect>
#include <assert.h>
#include <QQmlContext>

class ExecuteAfterDelay : public QObject
{
public:
    ExecuteAfterDelay(QJSValue callback) : callback(callback) {}

    QJSValue callback;

public slots:
    void executeAfterDelay()
    {
        callback.call();
    }
};

QMLUtils::QMLUtils(QQuickView* view, QObject *parent) :
    QObject(parent),
    view(view)
{
    gameState_ = view->rootContext()->engine()->newObject();
}

void QMLUtils::executeAfterDelay(QJSValue parent, QJSValue callback, int delay)
{
    QTimer* timer = new QTimer(parent.toQObject());
    timer->setInterval(delay);
    timer->connect(timer, &QTimer::timeout, [=]() mutable {
        callback.call();
        timer->stop();
    });
    timer->start();
}

static QString getSource(QJSValue value)
{
    return value.property("source").toString();
}

static QRect getItemRect(QJSValue value)
{
    return QRect(value.property("x").toInt(), value.property("y").toInt(), value.property("width").toInt(), value.property("height").toInt());
}

static QRect getRectIntersection(QJSValue a, QJSValue b)
{
    QRect aRect = getItemRect(a);
    QRect bRect = getItemRect(b);

    return aRect.intersected(bRect);
}

static QSize getItemSize(QJSValue item)
{
    return QSize(item.property("width").toInt(), item.property("height").toInt());
}

bool QMLUtils::collide(QJSValue a, QJSValue b)
{
    QRect aRect = getItemRect(a);
    QRect bRect = getItemRect(b);

    QRect intersection = aRect.intersected(bRect);
    if(intersection.isEmpty())
    {
        return false;
    }

    QString aSource = getSource(a);
    QString bSource = getSource(b);

    QSize requestedASize = getItemSize(a);
    QSize actualASize;
    QImage aImage = static_cast<QQuickImageProvider*>
            (view->engine()->imageProvider(aSource))->requestImage(aSource, &actualASize, requestedASize);
    assert(requestedASize == actualASize);

    QSize requestedBSize = getItemSize(b);
    QSize actualBSize;
    QImage bImage = static_cast<QQuickImageProvider*>
            (view->engine()->imageProvider(bSource))->requestImage(bSource, &actualBSize, requestedBSize);
    assert(requestedBSize == actualBSize);

    QRect aCollisionRect = intersection;
    aCollisionRect.moveLeft(aRect.x());
    aCollisionRect.moveTop(aRect.y());

    QRect bCollisionRect = intersection;
    bCollisionRect.moveLeft(bRect.x());
    bCollisionRect.moveTop(bRect.y());

    for(int y = 0; y < intersection.height(); y++)
    {
        for(int x = 0; x < intersection.width(); x++)
        {
            int aX = x + aCollisionRect.x();
            int bX = x + bCollisionRect.x();

            int aY = y + aCollisionRect.y();
            int bY = y + bCollisionRect.y();

            int aAlpha = qAlpha(aImage.pixel(aX, aY));
            if(aAlpha > 0)
            {
                int bAlpha = qAlpha(bImage.pixel(bX, bY));
                if(bAlpha > 0)
                {
                    return true;
                }
            }
        }
    }

    return false;
}

QString QMLUtils::readFromFile(QString path)
{
    QFile file(QCoreApplication::instance()->applicationDirPath() + '/' + path);
    QString fileContent;

    if(file.open(QIODevice::ReadOnly))
    {
        QString line;
        QTextStream t( &file );
        do
        {
            line = t.readLine();
            fileContent += line;
        }
        while (!line.isNull());
        file.close();
    }

    return fileContent;
}

void QMLUtils::writeToFile(QString path, QString content)
{
    QFile file(QCoreApplication::instance()->applicationDirPath() + '/' + path);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out<<content;

    file.close();
}

QJSValue QMLUtils::getGameState()
{
    return gameState_;
}
