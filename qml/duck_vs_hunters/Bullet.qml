import QtQuick 2.0

AnimatedSprite {
    id: bullet
    property double movementSpeed: 0.5;
    property int distance: -1000;

    frameCount: 6
    frameRate: 10
    frameHeight: 100
    frameWidth: 100
    width: 100
    height: 100
    running: true
    source: "images/bullet.png"

    NumberAnimation on x {
        id: moveByX;
        running: false;
    }

    NumberAnimation on y {
        id: moveByY;
        running: false;
    }

    function move(angle){
        var sin = Math.sin(angle);
        var cos = Math.cos(angle);
        var toX = moveByX.to = distance * cos + x;
        var toY = moveByY.to = distance * sin + y;
        var duration = moveByX.duration = moveByY.duration = Math.abs(distance) / movementSpeed;
        moveByX.running = moveByY.running = true;
        bullet.destroy(duration);
    }
}

