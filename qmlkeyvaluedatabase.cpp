#include "qmlkeyvaluedatabase.h"
#include <QCoreApplication>
#include <QtConcurrent/QtConcurrent>
#include <QFutureWatcher>
#include <assert.h>

QMLKeyValueDatabase::QMLKeyValueDatabase(QObject *parent) :
    QObject(parent)
{

}

void QMLKeyValueDatabase::get(QString key, QJSValue onFinish)
{
    assert(!fileName_.isNull());

    QFuture<QString> future = QtConcurrent::run([=]() mutable {
        return settings->value(key, QString()).toString();
    });

    QFutureWatcher<QString>* watcher = new QFutureWatcher<QString>(this);
    watcher->setFuture(future);
    watcher->connect(watcher, &QFutureWatcher<QString>::finished, [=]() mutable {
        QJSValueList args;
        QString result = watcher->result();

        if(result.isNull())
        {
            args.append(QJSValue());
        }
        else
        {
            args<<result;
        }

        onFinish.call(args);
    });
}

void QMLKeyValueDatabase::set(QString key, QString value, QJSValue onFinish)
{
    assert(!fileName_.isNull());

    QFuture<void> future = QtConcurrent::run([=]() mutable {
        settings->setValue(key, value);
        settings->sync();
    });

    QFutureWatcher<void>* watcher = new QFutureWatcher<void>(this);
    watcher->setFuture(future);

    if(onFinish.isCallable())
    {
        watcher->connect(watcher, &QFutureWatcher<void>::finished, [=]() mutable {
            onFinish.call();
        });
    }
}

QString QMLKeyValueDatabase::getFileName(){
    return fileName_;
}

void QMLKeyValueDatabase::setFileName(const QString& value)
{
    if(fileName_ == value)
    {
        return;
    }

    fileName_ = value;
    QString path = QCoreApplication::instance()->applicationDirPath();
    settings = new QSettings(path + "/" + fileName_, QSettings::NativeFormat, this);
}
