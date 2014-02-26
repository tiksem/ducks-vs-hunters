#ifndef QMLUTILS_H
#define QMLUTILS_H

#include <QObject>
#include <QJSValue>
#include <QQuickItem>
#include <QQuickImageProvider>
#include <QQuickView>

class QMLUtils : public QObject
{
    Q_OBJECT
public:
    explicit QMLUtils(QQuickView* view, QObject *parent = 0);
    Q_INVOKABLE void executeAfterDelay(QJSValue parent, QJSValue callback, int delay);
    Q_INVOKABLE bool collide(QJSValue a, QJSValue b);
private:
    QQuickView* view;
signals:

public slots:

};

#endif // QMLUTILS_H
