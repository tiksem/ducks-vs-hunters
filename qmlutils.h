#ifndef QMLUTILS_H
#define QMLUTILS_H

#include <QObject>
#include <QJSValue>
#include <QQuickItem>
#include <QQuickImageProvider>

class QMLUtils : public QObject
{
    Q_OBJECT
public:
    explicit QMLUtils(QObject *parent = 0);
    Q_INVOKABLE void executeAfterDelay(QJSValue callback, int delay);
    Q_INVOKABLE bool collide(QJSValue a, QJSValue b);
private:
    QQuickImageProvider imageProvider;
signals:

public slots:

};

#endif // QMLUTILS_H
