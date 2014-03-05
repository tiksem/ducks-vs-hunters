import QtQuick 2.0
import "random.js" as Random

AnimatedSprite {
    id: hunter
    property double movementSpeed: 0.3; // in pixels per millisecond
    property var bulletAngles: [Math.PI / 2, Math.PI / 4, Math.PI / 2 + Math.PI / 4]
    property var target: undefined;
    property int hp: 1;
    property int radius: 60;
    property int points: 10;

    frameCount: 30
    frameRate: 30
    frameHeight: 150
    frameWidth: 120
    width: 120
    height: 150
    running: true
    source: "images/light_hunter.png"
    state: "IDLE"

    property bool rotated: false;

    signal die;

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

    Component {
        id: deathAnimation

        AnimatedSprite {
            frameCount: 30
            frameRate: 30
            frameHeight: hunter.frameHeight
            frameWidth: hunter.frameWidth

            width: hunter.width
            height: hunter.height
            running: true
            source: "images/light_die.png"

            x: hunter.x;
            y: hunter.y;

            transform: Rotation {
                origin.x: hunter.width / 2
                origin.y: hunter.height / 2
                axis.x: 0; axis.y: rotated ? 1 : 0; axis.z: 0     // set axis.x to 1 to rotate around y-axis
                angle: 180    // the default angle
            }
        }
    }

    onDie: {
        var death = deathAnimation.createObject(hunter.parent);
        death.destroy(death.frameCount / death.frameRate * 1000)
        destroy();
    }

    Component {
        id: bulletComponent

        HunterBullet {

        }
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
                    var bullet = bulletComponent.createObject(hunter.parent, {
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

    onRotatedChanged: {
        rotation.axis.y = rotated ? 1 : 0;
    }

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

            rotated = to == 0;

            var distance = Math.abs(to - x);
            duration = distance / hunter.movementSpeed;
            running = true;
        }
    }
}
