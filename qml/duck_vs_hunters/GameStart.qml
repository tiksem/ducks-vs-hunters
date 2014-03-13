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
        about.open();
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
        id: startGameButtonMouseArea
        width: parent.width
        height: parent.height / 2

        onClicked: {
            startGameAnimation.running = true;
        }
    }

    MouseArea {
        width: parent.width
        height: parent.height / 2
        anchors.top: startGameButtonMouseArea.bottom

        onClicked: {
            openAbout();
        }
    }

    About {
        id: about;
    }
}
