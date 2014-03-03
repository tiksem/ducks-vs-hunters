import QtQuick 2.0

Bullet {
    id: main

    width: 30
    height: 25

    movementSpeed: 0.5;
    damage: 10;
    radius: 15;

    source: "images/shit.png"

    Component {
        id: doubleCombo

        Combo {
            width: 356;
            height: 71;
            source: "images/double.png"
        }
    }

    Component {
        id: tripleCombo

        Combo {
            width: 356;
            height: 71;
            source: "images/triple.png"
        }
    }

    Component {
        id: ultraCombo

        Combo {
            width: 356;
            height: 71;
            source: "images/ultra.png"
        }
    }

    Component {
        id: rampageCombo

        Combo {
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
