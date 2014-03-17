#ifndef QMLUTILS_H
#define QMLUTILS_H

#include <QObject>
#include <QJSValue>
#include <QQuickItem>
#include <QQuickImageProvider>
#include <QQuickView>
#include <QSet>
#include <QAudioOutput>
#include <QPointer>

template<typename T>
uint qHash(QPointer<T> key)
{
    return qHash(key.data());
}

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
    Q_INVOKABLE void pauseTimers();
    Q_INVOKABLE void resumeTimers();
    Q_INVOKABLE void saveGameSettings();
    QJSValue getGameState();
    Q_PROPERTY(QJSValue gameState READ getGameState)
    QJSValue getGameSettings();
    Q_PROPERTY(QJSValue gameSettings READ getGameSettings)

    bool eventFilter(QObject *obj, QEvent *event);

    ~QMLUtils();
signals:
    void onApplicationActivated();
    void onApplicationDeactivated();
private:
    QQuickView* view;
    QJSValue gameState_;
    QJSValue gameSettings_;
    QSet<QObject*> pausedItems;
    QSet<QPointer<QTimer>> timers;
    bool timersPaused;
signals:
private slots:
    void onMainViewDestroyed();
public slots:

};

#endif // QMLUTILS_H
