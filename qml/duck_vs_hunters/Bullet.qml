import QtQuick 2.0

AnimatedSprite {
    id: bullet
    property double movementSpeed: 0.5; // in pixels per millisecond
    property double angle: Math.pi / 2;

    frameCount: 6
    frameRate: 10
    frameHeight: 100
    frameWidth: 100
    width: 100
    height: 100
    running: true
    source: "images/hunter.png"

    NumberAnimation on x{
        running: true
        to: 1000 * Math.sin(angle)
        duration: (to - x) / movementSpeed;
    }

    NumberAnimation on y{
        running: true
        to: 1000 * Math.cos(angle)
        duration: (to - y) / movementSpeed;
    }
}

