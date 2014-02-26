import QtQuick 2.0
import "geom.js" as Geom
import "game.js" as Game

AnimatedSprite {
    id: bullet
    property double movementSpeed: 0.5;
    property int distance: -1000;
    property var targets: [];
    property int damage: 10;

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

    function onCollide(target){
        bullet.destroy();
        Game.damageTarget(target, damage);
    }

    function tryCollideWithTarget(target){
        var bulletCenterX = Geom.getItemCenterX(bullet);
        var bulletCenterY = Geom.getItemCenterY(bullet);

        var targetCenterX = Geom.getItemCenterX(target);
        var targetCenterY = Geom.getItemCenterY(target);

        if(Geom.isPointInsideCircle(bulletCenterX, bulletCenterY, targetCenterX, targetCenterY, target.radius)){
            onCollide(target);
        }
    }

    Timer {
        id: collisionTest
        repeat: true;
        running: true;
        interval: 50

        onTriggered: {
            for(var i = 0; i < targets.length; i++){
                if(targets[i]){
                    tryCollideWithTarget(targets[i]);
                }
            }
        }
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

