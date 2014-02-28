#ifndef QMLKEYVALUEDATABASE_H
#define QMLKEYVALUEDATABASE_H

#include <QObject>
#include <QJSValue>
#include <QSettings>
#include <QString>

class QMLKeyValueDatabase : public QObject
{
    Q_OBJECT
public:
    explicit QMLKeyValueDatabase(QObject *parent = 0);
    Q_INVOKABLE void get(QString key, QJSValue onFinish);
    Q_INVOKABLE void set(QString key, QString value, QJSValue onFinish);
    QString getFileName();
    void setFileName(const QString& value);
signals:

public slots:

private:
    QString fileName_;

    Q_PROPERTY(QString fileName READ getFileName WRITE setFileName)
    QSettings* settings;
};

#endif // QMLKEYVALUEDATABASE_H
