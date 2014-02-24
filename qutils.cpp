#include "qutils.h"
#include <functional>

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
