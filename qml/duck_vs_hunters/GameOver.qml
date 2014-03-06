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
        }
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: qsTr("Game Over")
        font.family: "Verdana"
        font.pixelSize: 120
        opacity: 0.1

        SequentialAnimation {
            running: true

            ParallelAnimation {
                NumberAnimation {
                    target: text
                    property: "opacity"
                    to: 0.5
                    duration: 800
                }

                NumberAnimation {
                    target: text
                    property: "font.pixelSize"
                    to: 100
                    duration: 800
                }
            }

            PauseAnimation { duration: 800 }

            NumberAnimation {
                target: text
                property: "opacity"
                to: 0
                duration: 400
            }

            onStopped: {
                finished();
            }
        }
    }
}
