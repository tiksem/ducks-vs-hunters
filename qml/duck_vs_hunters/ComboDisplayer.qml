import QtQuick 2.0

Rectangle {
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

    function displayCombo(count) {
        count -= 2;
        if(count >= combos.length){
            count = combos.length - 1;
        }

        var combo = combos[count];
        combo.createObject(main.parent);
    }
}
