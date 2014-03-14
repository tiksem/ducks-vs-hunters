import QtQuick 2.0
import QtMultimedia 5.0
import "geom.js" as Geom
import "game.js" as Game

Image {
    id: bullet
    property double movementSpeed: 0.5;
    property int distance: -1000;
    property var targets: [];
    property int damage: 1;
    property int radius: 8;
    property Audio sound: null;

    property bool paused: false;

    width: 15
    height: 15
    source: "images/real_bullet.png"

    NumberAnimation on x {
        id: moveByX;
        running: false;
        paused: bullet.paused ? bullet.paused && running : false;
    }

    NumberAnimation on y {
        id: moveByY;
        running: false;
        paused: bullet.paused ? bullet.paused && running : false;
    }

    function onCollide(target){
        Game.damageTarget(target, damage);
    }

    function tryCollideWithTarget(target){
        if(target.getAssCircle)
        {
            var ass = target.getAssCircle();
            if(Geom.circleCollide(ass, bullet)){
                target.assDamaged();
                return true;
            }
        }

        if(Geom.itemCircleCollide(target, bullet)){
            onCollide(target);
            return true;
        }

        return false;
    }

    Timer {
        id: collisionTest
        repeat: true;
        running: true;
        interval: 50

        onTriggered: {
            var targetReached = false;
            for(var i in targets){
                var target = targets[i];
                if(target){
                    if(tryCollideWithTarget(target)){
                        targetReached = true;
                    }
                }
            }

            if(targetReached){
                bullet.destroy();
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

        Utils.executeAfterDelay(bullet, function(){
           bullet.destroy();
        }, duration)

        if(sound){
            sound.play();
        }
    }
}

