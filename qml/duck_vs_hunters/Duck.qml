import QtQuick 2.0

AnimatedSprite {
    id: duck
    property double movementSpeed: 0.3;
    property int radius: 50;
    property int maxHP: 10;
    property int hp: 10;
    property var targets: [];
    property point assPosition: Qt.point(70, 120);
    property int assRadius: 5;
    property int assBlockingDuration: 5000;

    frameCount: 25
    frameRate: 40
    frameHeight: 140
    frameWidth: 140
    width: 140
    height: 140
    running: true
    interpolate: true
    source: "images/duck.png"

    state: "STOP"

    signal die;
    signal assDamaged;

    states: [
        State {
            name: "STOP"
            StateChangeScript {
                script: {
                    moving.stop();
                }
            }
        },

        State {
            name: "LEFT"
            StateChangeScript {
                script: {
                    move("left");
                }
            }
        },

        State {
            name: "RIGHT"
            StateChangeScript {
                script: {
                    move("right");
                }
            }
        }
    ]

    NumberAnimation on x {
        id: moving
        running: false;
    }


    Timer {
        id: fireLoop
        interval: 1000
        repeat: true
        running: true;

        onTriggered: {
            fire();
        }
    }

    onDie: {
        destroy();
    }

    Image {
        id: assBlocker;
        visible: false;
        source: "images/ass_blocker.png"
        width: 140;
        height: 56;
        anchors.bottom: duck.bottom;
        anchors.left: duck.left;
    }

    function freeAss(){
        assBlocker.visible = false;
        fireLoop.running = true;
        blockedAssFire();
    }

    onAssDamaged: {
        if(assBlocker.visible){
            return;
        }

        assBlocker.visible = true;
        fireLoop.running = false;
        Utils.executeAfterDelay(duck, freeAss, assBlockingDuration);
    }

    function move(direction){
        var to = 0;

        if(direction === "right"){
            to = duck.parent.width - duck.width;
        }

        var distance = Math.abs(to - x);
        moving.to = to;
        var duration = moving.duration = distance / movementSpeed;

        moving.running = true;
    }

    function getAssCircle(){
        return {
            x: assPosition.x + duck.x,
            y: assPosition.y + duck.y,
            radius: assRadius
        };
    }

    Component {
        id: duckBulletComponent

        DuckBullet {

        }
    }

    function fireWithAngle(angle){
        var bullet = duckBulletComponent.createObject(duck.parent, {
            x: assPosition.x + duck.x,
            y: assPosition.y + duck.y,
            targets: targets
        });
        bullet.x -= bullet.width / 2;

        bullet.move(angle);
    }

    function fire(){
        fireWithAngle(Math.PI / 2 * 3)
    }

    function blockedAssFire(){
        for(var angle = Math.PI + Math.PI / 4;
            angle < Math.PI / 2 * 3 + Math.PI / 4 + 0.01;
            angle += Math.PI / 8)
        {
            fireWithAngle(angle);
        }
    }

    onHpChanged: {
        if(hp > maxHP){
            hp = maxHP;
        }
    }

    Keys.onLeftPressed: {
        if(!event.isAutoRepeat){
            state = "LEFT"
        }
    }

    Keys.onReleased: {
        if(!event.isAutoRepeat){
            state = "STOP"
        }
    }

    Keys.onRightPressed: {
        if(!event.isAutoRepeat){
            state = "RIGHT"
        }
    }
}
