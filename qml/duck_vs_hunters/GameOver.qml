import QtQuick 2.0

Rectangle {
    id: main
    width: parent.width
    height: parent.height

    Rectangle {
        width: parent.width
        height: parent.height
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("Game Over")
        font.family: "Verdana"
        font.pixelSize: 100
    }
}
