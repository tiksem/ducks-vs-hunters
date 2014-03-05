import QtQuick 2.0
import QtMultimedia 5.0

Bullet {
    id: main

    width: 30
    height: 25

    movementSpeed: 0.5;
    radius: 15;

    source: "images/shit.png"
    sound: Audio {
        source: "sounds/shit.mp3"
        volume: 0.5
        autoLoad: true
    }
}
