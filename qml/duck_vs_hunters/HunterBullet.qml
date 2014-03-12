import QtQuick 2.0
import QtMultimedia 5.0

Bullet {
    sound: Audio {
        source: "sounds/hunter_shoot.mp3"
        volume: 0.2
        autoLoad: true
        muted: !Utils.audioEnabled
    }
}
