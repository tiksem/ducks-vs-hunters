import QtQuick 2.0
import "geom.js" as Geom
import "game.js" as Game

AnimatedSprite {
    id: bullet
    property double movementSpeed: 0.5;
    property int distance: -1000;
    property var targets: [];
    property int damage: 10;
    property int radius: 50;

    frameCount: 6
    frameRate: 10
    frameHeight: 100
    frameWidth: 100
    width: 100
    height: 100
    running: true
    source: "images/bullet.png"

    signal combo(int count);

    NumberAnimation on x {
        id: moveByX;
        running: false;
    }

    NumberAnimation on y {
        id: moveByY;
        running: false;
    }

    function onCollide(target){
        Game.damageTarget(target, damage);
    }

    function onCollideWithAss(target){
        target.assDamaged();
    }

    function tryCollideWithTarget(target){
        if(target.getAssCircle)
        {
            var ass = target.getAssCircle();
            if(Geom.circleCollide(ass, bullet)){
                onCollideWithAss(target);
                return;
            }
        }

        if(Geom.itemCircleCollide(target, bullet)){
            onCollide(target);
        }
    }

    function checkForCombo(killedTargetsPerShoot){
        if(killedTargetsPerShoot <= 1){
            return;
        }

        console.log("combo detected");
        combo(killedTargetsPerShoot);
    }

    Timer {
        id: collisionTest
        repeat: true;
        running: true;
        interval: 50

        onTriggered: {
            var killedTargetsPerShoot = 0;
            for(var i in targets){
                var target = targets[i];
                if(target){
                    tryCollideWithTarget(target);
                    if(!target || target.hp <= 0){
                        killedTargetsPerShoot++;
                    }
                }
            }

            checkForCombo(killedTargetsPerShoot);

            if(killedTargetsPerShoot >= 1){
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
        bullet.destroy(duration);
    }
}

