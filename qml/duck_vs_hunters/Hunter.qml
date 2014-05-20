import QtQuick 2.0
import "random.js" as Random
import "math.js" as MathUtils
import "animation.js" as Animation

Item {
    id: hunter
    property double movementSpeed: 0.3; // in pixels per millisecond
    property var bulletAngles: MathUtils.generateArrayFromRange(MathUtils.deegresToRadians(45),
                                                                MathUtils.deegresToRadians(70),
                                                                55 - 31);
    property var target: undefined;
    property int hp: 1;
    property int radius: 55;
    property point center: Qt.point(100, 67);
    property int points: 10;
    property string image: "images/Separatist.png";

    property int level: 1;

    SpriteSequence {
        id: animation
        running: true
        width: 200
        height: 170
        interpolate: true;
        Sprite {
            name: "run"
            frameCount: 6
            frameRate: 20
            frameHeight: 170
            frameWidth: 200
            source: image
        }
        Sprite {
            name: "death"
            frameCount: 24
            frameRate: 30
            frameHeight: 170
            frameWidth: 200
            frameX: 200 * 72
            source: image
        }
        Sprite {
            name: "fire"
            frameCount: 18-6
            frameRate: 20
            frameHeight: 170
            frameWidth:200
            frameX: 200 * 6
            source: image
        }
    }

    width: 200
    height: 170
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
            if(hunter.state == "DIE"){
                return;
            }

            hunter.state = newState;
        }, delay);
    }

    onDie: {
        state = "DIE";
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
                    animation.jumpTo("run");
                    moving.move();
                    changeStateAfterDelay("FIRE", Random.randomIntFromInterval(200, 1800));
                }
            }
        },

        State {
            name: "DIE"

            StateChangeScript {
                script: {
                    animation.jumpTo("death");
                    var death = animation.sprites[1];
                    console.log("time = " + death.frameCount / death.frameRate * 1000);
                    hunter.destroy(death.frameCount / death.frameRate * 1000);
                    moving.stop();
                }
            }
        },

        State {
            name: "FIRE"

            StateChangeScript {
                script: {
                    var bulletPosition = Random.randomInt(bulletAngles.length);
                    var angle = bulletAngles[bulletPosition];
                    if(!rotated){
                        angle = Math.PI - angle;
                    }

                    moving.stop();
                    var animationDuration = Animation.getDuration(animation.sprites[2].frameRate, bulletPosition);
                    animation.jumpTo("fire");

                    Utils.executeAfterDelay(hunter, function(){
                        var bullet = bulletComponent.createObject(hunter.parent, {
                                                                      x: hunter.x,
                                                                      y: hunter.y,
                                                                      targets: [target]
                                                                  });
                        bullet.move(angle);
                        changeStateAfterDelay("MOVE", 500);
                    }, animationDuration)
                }
            }
        }

    ]

    onRotatedChanged: {
        rotation.axis.y = rotated ? 1 : 0;
    }

    NumberAnimation on x {
        id: moving
        paused: running && !animation.running;

        onPausedChanged: {
            console.log("onPausedChanged = " + moving.paused)
        }

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
