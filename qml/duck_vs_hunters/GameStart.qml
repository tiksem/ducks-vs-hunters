import QtQuick 2.0

Rectangle {
    id: main
    width: parent.width
    height: parent.height

    property string background: ""
    property string foreground: ""

    Image {
        width: parent.width
        height: parent.height
        source: background
    }

    Image {
        width: parent.width
        height: parent.height
        source: foreground
    }

    Image {
        width: parent.width
        height: parent.height
        source: "images/menu.png"

        NumberAnimation on y {
            from: -parent.height + 200
            to: 0
            duration: 500
            running: true
        }
    }
}
