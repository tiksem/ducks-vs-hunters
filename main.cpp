#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QScreen>
#include <QQmlContext>
#include "qmlutils.h"
#include <functional>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    QScreen* screen = app.screens().at(0);
    QSize screenSize = screen->size();

    QQmlContext* context = viewer.rootContext();
    context->setContextProperty("screenSize", screenSize);
    QMLUtils* utils = new QMLUtils();
    context->setContextProperty("Utils", utils);

    viewer.setSource(QUrl("qml/duck_vs_hunters/main.qml"));

    std::function<void()> e;

    viewer.showExpanded();

    return app.exec();
}
