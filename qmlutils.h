#ifndef QMLUTILS_H
#define QMLUTILS_H

#include <QObject>
#include <QJSValue>

class QMLUtils : public QObject
{
    Q_OBJECT
public:
    explicit QMLUtils(QObject *parent = 0);
    Q_INVOKABLE void executeAfterDelay(QJSValue callback, int delay);
private:

signals:

public slots:

};

#endif // QMLUTILS_H
