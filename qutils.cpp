#include "qutils.h"
#include <functional>
#include <QVariant>

QUtils::QUtils()
{
}

ExecuteAfterDelaySlotHolder::ExecuteAfterDelaySlotHolder(const std::function<void()>& callback)
    :callback(callback)
{

}

void ExecuteAfterDelaySlotHolder::executeAfterDelay()
{
    callback();
    delete this;
}

void QUtils::setPropertyRecursive(QObject* root, const char* propertyName, const QVariant& value)
{
    QVariant p(root->property(propertyName));
    if(p.isValid())
    {
        root->setProperty(propertyName, value);
    }

    for(QObject* child : root->children())
    {
        setPropertyRecursive(child, propertyName, value);
    }
}
