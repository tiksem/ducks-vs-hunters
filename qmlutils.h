#ifndef QMLUTILS_H
#define QMLUTILS_H

#include <QObject>
#include <QJSValue>
#include <QQuickItem>
#include <QQuickImageProvider>
#include <QQuickView>
#include <QSet>

class QMLUtils : public QObject
{
    Q_OBJECT
public:
    explicit QMLUtils(QQuickView* view, QObject *parent = 0);
    Q_INVOKABLE void executeAfterDelay(QJSValue parent, QJSValue callback, int delay);
    Q_INVOKABLE bool collide(QJSValue a, QJSValue b);
    Q_INVOKABLE QString readFromFile(QString path);
    Q_INVOKABLE void writeToFile(QString path, QString content);
    Q_INVOKABLE void pause(QObject* item);
    Q_INVOKABLE void resume(QObject* item);
    Q_INVOKABLE bool isPaused(QObject* item);
    Q_INVOKABLE void triggerPausedState(QObject* item);
    QJSValue getGameState();
    bool isAudioEnabled();
    void setAudioEnabled(bool value);
    Q_PROPERTY(QJSValue gameState READ getGameState)
    Q_PROPERTY(bool audioEnabled READ isAudioEnabled() WRITE setAudioEnabled NOTIFY audioEnabledChanged)

signals:
    void audioEnabledChanged();
private:
    QQuickView* view;
    QJSValue gameState_;
    QSet<QObject*> pausedItems;
    bool audioEnabled_;
signals:

public slots:

};

#endif // QMLUTILS_H
