#ifndef QUTILS_H
#define QUTILS_H

#include <functional>
#include <QTimer>

class ExecuteAfterDelaySlotHolder : public QObject
{
    Q_OBJECT
public:
    ExecuteAfterDelaySlotHolder(const std::function<void()>& callback);
public slots:
    void executeAfterDelay();
private:
    std::function<void()> callback;
};

class QUtils
{
public:
    QUtils();
    template<typename Function>
    static void executeAfterDelay(const Function& func, int delay)
    {
        ExecuteAfterDelaySlotHolder* slotHolder = new ExecuteAfterDelaySlotHolder(func);
        QTimer::singleShot(delay, slotHolder, SLOT(executeAfterDelay()));
    }

    static void setPropertyRecursive(QObject* root, const char* propertyName, const QVariant& value);
private:
};

#endif // QUTILS_H
