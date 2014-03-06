import QtQuick 2.0

Rectangle {
    id: main
    width: parent.width
    height: parent.height

    property string background: ""
    property string foreground: ""

    signal finished;

    Image {
        width: parent.width
        height: parent.height
        source: background
    }

    Image {
        width: parent.width
        height: parent.height
        source: foreground
        opacity: 0

        NumberAnimation on opacity {
            to: 1;
            duration: 800
            running: true

            onStopped: {
                finished();
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("Game Over")
        font.family: "Verdana"
        font.pixelSize: 120
        opacity: 0.5

        NumberAnimation on font.pixelSize {
            to: 100
            duration: 800
            running: true;
        }

        NumberAnimation on opacity {
            to: 1
            duration: 800
            running: true;
        }
    }
}
