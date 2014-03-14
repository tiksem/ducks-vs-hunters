#include "qmlutils.h"
#include <QTimer>
#include "qutils.h"
#include <QQuickImageProvider>
#include <QRect>
#include <assert.h>
#include <QQmlContext>
#include <QPointer>

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

static QJSValue parseJson(const QString& str, QJSEngine* engine)
{
    QJSValue func = engine->evaluate("JSON.parse");
    QJSValue result = func.call(QJSValueList()<<str);
    if(result.isObject())
    {
        return result;
    }

    return engine->newObject();
}

static QString stringify(const QJSValue& value, QJSEngine* engine)
{
    QJSValue func = engine->evaluate("JSON.stringify");
    QJSValue result = func.call(QJSValueList()<<value);
    if(result.isString())
    {
        return result.toString();
    }

    return "{}";
}

QMLUtils::QMLUtils(QQuickView* view, QObject *parent) :
    QObject(parent),
    view(view)
{
    QJSEngine* engine = view->engine();
    gameState_ = engine->newObject();
    QString settings = readFromFile("settings");
    gameSettings_ = parseJson(settings, engine);

    connect(view, SIGNAL(destroyed()), this, SLOT(onMainViewDestroyed()));

    timersPaused = false;

    QCoreApplication::instance()->installEventFilter(this);
}

void QMLUtils::executeAfterDelay(QJSValue parent, QJSValue callback, int delay)
{
    QTimer* timer = new QTimer(parent.toQObject());
    timer->setInterval(delay);
    timer->connect(timer, &QTimer::timeout, [=]() mutable {
        callback.call();
        timer->stop();
        timers.remove(timer);
    });
    timer->start();
    timers.insert(timer);
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
    QFile file(path);
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

    if(file.error() != QFile::NoError)
    {
        qDebug()<<"file error = "<<file.errorString();
        qDebug()<<"filePath = "<<path;
    }

    return fileContent;
}

void QMLUtils::writeToFile(QString path, QString content)
{
    QFile file(path);
    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream out(&file);
        out<<content;
        file.close();
    }

    if(file.error() != QFile::NoError)
    {
        qDebug()<<"file error = "<<file.errorString();
        qDebug()<<"filePath = "<<path;
    }
}

QJSValue QMLUtils::getGameState()
{
    return gameState_;
}

void QMLUtils::pause(QObject* item)
{
    if(isPaused(item))
    {
        return;
    }

    QEvent e(QEvent::ApplicationDeactivate);
    QCoreApplication::instance()->sendEvent(item, &e);
    pausedItems.insert(item);
}

void QMLUtils::resume(QObject* item)
{
    if(!pausedItems.remove(item))
    {
        return;
    }

    QEvent e(QEvent::ApplicationActivate);
    QCoreApplication::instance()->sendEvent(item, &e);
}

bool QMLUtils::isPaused(QObject* item)
{
    return pausedItems.contains(item);
}

void QMLUtils::triggerPausedState(QObject* item)
{
    if(isPaused(item))
    {
        resume(item);
    }
    else
    {
        pause(item);
    }
}

QJSValue QMLUtils::getGameSettings()
{
    return gameSettings_;
}

QMLUtils::~QMLUtils()
{
    QCoreApplication::instance()->removeEventFilter(this);
}

void QMLUtils::onMainViewDestroyed()
{
    QString value = stringify(gameSettings_, view->engine());
    writeToFile("settings", value);
}

void QMLUtils::pauseTimers()
{
    for(QPointer<QTimer> timer : timers)
    {
        if(!timer.isNull())
        {
            timer->stop();
        }
        else
        {
            timers.remove(timer);
        }
    }
}

void QMLUtils::resumeTimers()
{
    for(QPointer<QTimer> timer : timers)
    {
        if(!timer.isNull())
        {
            timer->start();
        }
        else
        {
            timers.remove(timer);
        }
    }
}

bool QMLUtils::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::ApplicationDeactivate)
    {
        emit onApplicationDeactivated();
        return true;
    }

    if(event->type() == QEvent::ApplicationActivate)
    {
        emit onApplicationActivated();
        return true;
    }

    return QObject::eventFilter(obj, event);
}
