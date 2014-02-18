#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QScreen>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/duck_vs_hunters/main.qml"));
    QScreen* screen = app.screens().at(0);
    QSize screenSize = screen->size();

    QQmlContext* context = viewer.rootContext();
    context->setProperty("screenSize", screenSize);

    viewer.showExpanded();

    return app.exec();
}
