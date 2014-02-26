import QtQuick 2.0

AnimatedSprite {
    id: duck
    property double movementSpeed: 0.3;
    property int radius: 50;
    property int hp: 10;
    property var targets: [];

    frameCount: 12
    frameRate: 25
    frameHeight: 140
    frameWidth: 140
    width: 140
    height: 140
    running: true
    source: "images/duck.png"

    state: "STOP"

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

    function die(){
        destroy();
    }

    function fire(){
        var bullet = Qt.createComponent("DuckBullet.qml").
        createObject(duck.parent, {
            x: x,
            y: y,
            targets: targets
        });

        bullet.move(Math.PI / 2 * 3);
    }

    Keys.onLeftPressed: state = "LEFT"
    Keys.onReleased: state = "STOP"
    Keys.onRightPressed: state = "RIGHT"
}
