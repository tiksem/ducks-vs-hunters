#include "qmlutils.h"
#include <QTimer>
#include "qutils.h"
#include <QQuickImageProvider>
#include <QRect>
#include <assert.h>

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

QMLUtils::QMLUtils(QObject *parent) :
    QObject(parent),
    imageProvider(QQmlImageProviderBase::Pixmap)
{
}

void QMLUtils::executeAfterDelay(QJSValue callback, int delay)
{
    QUtils::executeAfterDelay([=]() mutable {
        callback.call();
    }, delay);
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
    QRect intersection = getRectIntersection(a, b);
    if(intersection.isEmpty())
    {
        return false;
    }

    QString aSource = getSource(a);
    QString bSource = getSource(b);

    QSize requestedASize = getItemSize(a);
    QSize actualASize;
    QPixmap aPixmap = imageProvider.requestPixmap(aSource, &actualASize, requestedASize);
    assert(requestedASize == actualASize);

    QSize requestedBSize = getItemSize(b);
    QSize actualBSize;
    QPixmap bPixmap = imageProvider.requestPixmap(bSource, &actualBSize, requestedBSize);
    assert(requestedBSize == actualBSize);

    return true;
}
