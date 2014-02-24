import QtQuick 2.0

Rectangle {
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
        x: 0
        y: 0
        focus: true
    }

    Hunter {
        anchors.bottom: parent.bottom
    }
}
