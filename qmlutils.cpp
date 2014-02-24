#include "qmlutils.h"
#include <QTimer>
#include "qutils.h"

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
    QObject(parent)
{
}

void QMLUtils::executeAfterDelay(QJSValue callback, int delay)
{
    QUtils::executeAfterDelay([=]() mutable {
        callback.call();
    }, delay);
}
