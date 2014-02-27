import QtQuick 2.0
import "random.js" as Random

AnimatedSprite {
    id: hunter
    property double movementSpeed: 0.3; // in pixels per millisecond
    property var bulletAngles: [Math.PI / 2, Math.PI / 4, Math.PI / 2 + Math.PI / 4]
    property var target: undefined;
    property int hp: 10;
    property int radius: 150;

    frameCount: 30
    frameRate: 30
    frameHeight: 150
    frameWidth: 120
    width: 120
    height: 150
    running: true
    source: "images/hunter.png"
    state: "IDLE"

    transform: Rotation {
        id: rotation
        origin.x: hunter.width / 2
        origin.y: hunter.height / 2
        axis.x: 0; axis.y: 0; axis.z: 0     // set axis.x to 1 to rotate around y-axis
        angle: 180    // the default angle
    }

    function changeStateAfterDelay(newState, delay){
        Utils.executeAfterDelay(hunter, function(){
            hunter.state = newState;
        }, delay);
    }

    function die(){
        destroy();
    }

    states: [
        State {
            name: "MOVE"
            StateChangeScript {
                script: {
                    moving.move();
                    changeStateAfterDelay("FIRE", Random.randomIntFromInterval(200, 1800));
                }
            }
        },

        State {
            name: "FIRE"

            StateChangeScript {
                script: {
                    var bullet = Qt.createComponent("Bullet.qml").createObject(hunter.parent, {
                                                                  x: hunter.x,
                                                                  y: hunter.y,
                                                                  targets: [target]
                                                              });
                    var angle = Random.getRandomElementOfArray(bulletAngles);
                    bullet.move(angle);
                    moving.stop();
                    changeStateAfterDelay("MOVE", 500);
                }
            }
        }

    ]


    NumberAnimation on x {
        id: moving

        onStopped: {
            if(hunter.state == "MOVE"){
                move();
            }
        }

        function move(){
            to = 0;
            var maximumDistance = hunter.parent.width - hunter.width;
            if(x < (hunter.parent.width - hunter.width) / 2.0){
                to = maximumDistance;
            }

            if(to == 0){
                rotation.axis.y = 1;
            } else {
                rotation.axis.y = 0;
            }

            var distance = Math.abs(to - x);
            duration = distance / hunter.movementSpeed;
            running = true;
        }
    }
}
