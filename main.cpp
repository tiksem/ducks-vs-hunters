#include <QtGui/QGuiApplication>
#include <QScreen>
#include <QQmlContext>
#include "qmlutils.h"
#include <functional>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView viewer;
    QScreen* screen = app.screens().at(0);
    QSize screenSize = screen->size();

    QQmlContext* context = viewer.rootContext();
    context->setContextProperty("screenSize", screenSize);
    QMLUtils* utils = new QMLUtils(&viewer, &viewer);
    context->setContextProperty("Utils", utils);

    viewer.setSource(QUrl("qrc:///Main.qml"));

    viewer.showNormal();

    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
