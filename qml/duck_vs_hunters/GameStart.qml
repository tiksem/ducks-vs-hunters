import QtQuick 2.0

Rectangle {
    id: main
    width: parent.width
    height: parent.height

    property string background: ""
    property string foreground: ""

    signal startGame;

    Image {
        width: parent.width
        height: parent.height
        source: background
    }

    Image {
        id: foregroundImage
        width: parent.width
        height: parent.height
        source: foreground
    }

    Image {
        id: menu
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

    function openAbout(){

    }

    ParallelAnimation {
        id: startGameAnimation
        running: false

        NumberAnimation {
            target: menu
            property: "y"
            to: -parent.height
            duration: 500
        }

        NumberAnimation {
            target: foregroundImage
            property: "opacity"
            duration: 800
            to: 0
        }

        onStopped: {
            startGame();
        }
    }

    MouseArea {
        width: parent.width
        height: parent.height

        onClicked: {
            startGameAnimation.running = true;
        }
    }

    MouseArea {
        width: 0;
        height: 0;

        onClicked: {
            openAbout();
        }
    }
}
