import QtQuick 2.0

Image {
    id: main
    source: "images/about.jpg"
    y: - height
    focus: y != -height

    Text {
        font.family: "Verdana"
        font.pixelSize: 50
        text: "Ва обосрали " + (Utils.gameSettings.records || 0) + " сепаратистов!"
        anchors.centerIn: parent
    }

    NumberAnimation on y {
        id: openAnimation;
        to: 0;
        duration: 600
        running: false;
    }

    NumberAnimation on y {
        id: closeAnimation;
        to: -main.height;
        duration: 600;
        running: false;
    }

    function close(){
        closeAnimation.running = true;
    }

    function open(){
        openAnimation.running = true;
    }

    MouseArea {
        width: parent.width
        height: parent.height

        onClicked: {
            close();
        }
    }

    Keys.onBackPressed: {
        close();
    }
}
