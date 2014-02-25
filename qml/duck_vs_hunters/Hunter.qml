import QtQuick 2.0
import "random.js" as Random

AnimatedSprite {
    id: hunter
    property double movementSpeed: 0.3; // in pixels per millisecond
    property var bulletAngles: [Math.PI / 2, Math.PI / 4, Math.PI / 2 + Math.PI / 4]

    frameCount: 30
    frameRate: 30
    frameHeight: 150
    frameWidth: 120
    width: 120
    height: 150
    running: true
    source: "images/hunter.png"
    state: "MOVE"

    function changeStateAfterDelay(newState, delay){
        Utils.executeAfterDelay(function(){
            hunter.state = newState;
        }, delay);
    }

    states: [
        State {
            name: "MOVE"
            StateChangeScript {
                script: {
                    moving.move();
                    changeStateAfterDelay("FIRE", 3000);
                }
            }
        },

        State {
            name: "FIRE"

            StateChangeScript {
                script: {
                    var bullet = Qt.createComponent("Bullet.qml").createObject(hunter.parent, {
                                                                  x: hunter.x,
                                                                  y: hunter.y
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

            var distance = Math.abs(to - x);
            duration = distance / hunter.movementSpeed;
            running = true;
        }
    }
}
