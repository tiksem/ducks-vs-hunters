import QtQuick 2.0

Rectangle {
    id: main

    width: 960
    height: 540

    //transform: Scale { xScale: screenSize.width / width; yScale: screenSize.height / height}

    Image {
        width: parent.width
        height: parent.height
        source: "images/background.jpg"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    Duck {
        id: duck
        x: 0
        y: 0
        focus: true
        targets: hunterFactory.hunters
    }

    Timer {
        id: hunterFactory
        interval: 2000
        running: true
        repeat: true

        property var hunters: []

        onTriggered: {
            var hunter = Qt.createComponent("Hunter.qml").createObject(main);
            hunter.target = duck;
            hunter.anchors.bottom = hunter.parent.bottom;
            hunters.push(hunter);
        }
    }
}
