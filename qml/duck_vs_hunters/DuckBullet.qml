import QtQuick 2.0

Bullet {
    id: main

    frameCount: 6
    frameRate: 10
    frameHeight: 100
    frameWidth: 100
    width: 100
    height: 100

    movementSpeed: 0.5;
    damage: 10;

    source: "images/duck_bullet.png"

    Component {
        id: doubleCombo

        Combo {
            fadeOutDuration: 1000;
            duration: 1500;
            width: 356;
            height: 71;
            source: "images/double.png"
        }
    }

    Component {
        id: tripleCombo

        Combo {
            fadeOutDuration: 1000;
            duration: 1500;
            width: 356;
            height: 71;
            source: "images/triple.png"
        }
    }

    Component {
        id: ultraCombo

        Combo {
            fadeOutDuration: 1000;
            duration: 1500;
            width: 356;
            height: 71;
            source: "images/ultra.png"
        }
    }

    Component {
        id: rampageCombo

        Combo {
            fadeOutDuration: 1000;
            duration: 1500;
            width: 356;
            height: 71;
            source: "images/rampage.png"
        }
    }

    property var combos: [doubleCombo, tripleCombo, ultraCombo, rampageCombo];

    onCombo: {
        count -= 2;
        if(count >= combos.length){
            count = combos.length - 1;
        }

        var combo = combos[count];
        combo.createObject(main.parent);
    }
}
