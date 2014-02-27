import QtQuick 2.0
import "random.js" as Random

Rectangle {
    id: main

    width: parent.width
    height: parent.height

    property int points: 0;

    signal gameOver;

    Image {
        width: parent.width
        height: parent.height
        source: "images/background.jpg"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    Duck {
        id: duck
        x: 0
        y: 0
        focus: true
        targets: hunterFactory.hunters

        onDie: {
            gameOver();
        }
    }

    Timer {
        id: hunterFactory
        interval: 2000
        running: true
        repeat: true

        property var hunters: []

        onTriggered: {
            var hunter = Qt.createComponent("Hunter.qml").createObject(main);
            hunter.target = duck;
            hunter.anchors.bottom = main.bottom;
            hunter.x = Random.getRandomElementOfArray([0, main.width - hunter.width]);
            hunters.push(hunter);
            hunter.state = "MOVE";
            hunter.die.connect(function(){
                points += hunter.points;
            })
        }
    }

    Text {
        x: 10
        y: 10
        text: qsTr(points.toString())
        font.family: "Verdana"
        font.pixelSize: 50
        color: Qt.red
    }

    MouseArea {
        x: 0
        width: main.width / 2
        height: main.height

        onPressed: {
            duck.state = "LEFT"
        }

        onReleased: {
            duck.state = "STOP"
        }
    }

    MouseArea {
        x: main.width / 2
        width: main.width / 2
        height: main.height

        onPressed: {
            duck.state = "RIGHT"
        }

        onReleased: {
            duck.state = "STOP"
        }
    }
}
