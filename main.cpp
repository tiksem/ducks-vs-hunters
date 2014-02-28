#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QScreen>
#include <QQmlContext>
#include "qmlutils.h"
#include <functional>
#include "qmlkeyvaluedatabase.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView viewer;
    QScreen* screen = app.screens().at(0);
    QSize screenSize = screen->size();

    QQmlContext* context = viewer.rootContext();
    context->setContextProperty("screenSize", screenSize);
    QMLUtils* utils = new QMLUtils(&viewer);
    context->setContextProperty("Utils", utils);

    qmlRegisterType<QMLKeyValueDatabase>("com.tiksem.database", 1, 0, "Database");

    viewer.setSource(QUrl("qrc:///Main.qml"));

    viewer.showNormal();

    return app.exec();
}
