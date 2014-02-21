import QtQuick 2.0

AnimatedSprite {
    id: hunter
    property double movementSpeed: 0.5; // in pixels per millisecond

    frameCount: 6
    frameRate: 10
    frameHeight: 100
    frameWidth: 100
    width: 100
    height: 100
    running: true
    source: "images/hunter.png"
    state: "MOVE"

    states: [
        State {
            name: "MOVE"
            StateChangeScript {
                script: {
                    moving.move();
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
