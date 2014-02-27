# Add more folders to ship with the application, here
folder_01.source = qml/duck_vs_hunters
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    qmlutils.cpp \
    qutils.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qml/duck_vs_hunters/Hunter.qml \
    qml/duck_vs_hunters/geom.js \
    qml/duck_vs_hunters/Game.qml \
    qml/duck_vs_hunters/GameOver.qml

HEADERS += \
    qmlutils.h \
    qutils.h

CONFIG += c++11

QMAKE_CXXFLAGS += -std=c++11

RESOURCES += qml/duck_vs_hunters/resources.qrc
