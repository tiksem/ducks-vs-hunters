import QtQuick 2.0

CheckBox {
    imageOn: "images/sound_on.png"
    imageOff: "images/sound_off.png"

    onClicked: {
        Utils.gameState.audioEnabled = on;
    }
}
