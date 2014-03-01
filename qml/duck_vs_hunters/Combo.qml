import QtQuick 2.0

Image {
    id: main
    property int fadeOutDuration: 1000;
    property int duration: 1000;
    width: 356;
    height: 71;
    source: "images/double.png"
    anchors.centerIn: parent

    opacity: 1;

    Component.onCompleted: {
        var gameState = Utils.gameState;
        if(gameState.currentCombo && gameState.currentCombo.destroy){
            gameState.currentCombo.destroy();
        }

        gameState.currentCombo = main;

        Utils.executeAfterDelay(main, function(){
            fade.running = true;
            main.destroy(duration);
        }, duration)
    }

    NumberAnimation on opacity {
        running: false;
        id: fade;
        to: 0;
        duration: duration;
    }
}
