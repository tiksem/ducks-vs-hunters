import QtQuick 2.0

AnimatedSprite {
    id: duck
    property double movementSpeed: 0.3;
    property int radius: 50;
    property int hp: 10;

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

    function damage(value){
        hp -= value;
        if(hp <= 0){
            die();
        }
    }

    function die(){
        destroy();
    }

    Keys.onLeftPressed: state = "LEFT"
    Keys.onReleased: state = "STOP"
    Keys.onRightPressed: state = "RIGHT"
}
