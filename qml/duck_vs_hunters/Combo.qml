import QtQuick 2.0

Image {
    id: main
    property int fadeOutDuration: 1000;
    property int duration: 10000;
    width: 356;
    height: 71;
    source: "images/double.png"
    anchors.centerIn: parent

    opacity: 1;

    Component.onCompleted: {
        var gameState = Utils.gameState;
        if(gameState.currentCombo){
            gameState.currentCombo.destroy();
        }

        gameState.currentCombo = main;
    }

    Timer {
        repeat: false;
        running: true;
        interval: duration;

        onTriggered: {
            console.log("onTriggered")
            fade.running = true;
            main.destroy(duration);
        }
    }

    NumberAnimation on opacity {
        running: false;
        id: fade;
        to: 0;
        duration: duration;
    }
}
