import QtQuick 2.0
import "random.js" as Random
import "file.js" as File

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

    ComboDisplayer {
        id: comboDisplayer
    }

    function onCombo(count){
        comboDisplayer.displayCombo(count);
        duck.hp += count - 1;
    }

    Timer {
        id: hunterFactory
        interval: 100
        running: true
        repeat: true
        property var hunterComponent: Qt.createComponent("Hunter.qml");

        property var hunters: []
        property int maxHuntersCount: 5;
        property int huntersCount: 0;
        property int comboDelay: 700;

        property var lastHunterDeathTime: 0;
        property int comboDetected: 1;
        property bool stopComboCalculation: false;

        onTriggered: {
            if(huntersCount >= maxHuntersCount){
                return;
            }

            var hunter = hunterComponent.createObject(main);
            hunter.target = duck;
            hunter.anchors.bottom = main.bottom;
            hunter.x = Random.getRandomElementOfArray([0, main.width - hunter.width]);
            hunters.push(hunter);
            hunter.state = "MOVE";
            huntersCount++;
            hunter.die.connect(function(){
                points += hunter.points;
                huntersCount--;

                if(stopComboCalculation){
                    return;
                }

                var now = Date.now();
                console.log("now = " + now);
                if(now - lastHunterDeathTime <= comboDelay){
                    comboDetected++;
                    onCombo(comboDetected);
                } else {
                    comboDetected = 1;
                }

                if(comboDetected >= 5){
                    comboDetected = 1;
                    lastHunterDeathTime = 0;
                    stopComboCalculation = true;
                    Utils.executeAfterDelay(main, function(){
                       stopComboCalculation = false;
                    }, comboDelay)
                }

                lastHunterDeathTime = now;
                console.log("lastHunterDeathTime = " + lastHunterDeathTime);
            })
        }
    }

    function onRecordReached(){
        records.value = points;
    }

    onPointsChanged: {
        if(points > records.value){
            onRecordReached();
        }
    }

    onGameOver: {
        var settings = {
            records: records.value
        }

        File.writeObjectToFile("settings", settings);
    }

    Component.onCompleted: {
        var settings = File.readObjectFromFile("settings");
        records.value = settings.records || 0;
    }

    Text {
        x: 10
        y: 10
        text: qsTr(points.toString())
        font.family: "Verdana"
        font.pixelSize: 50
        color: Qt.red
    }

    Text {
        id: records
        property int value: 0;

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10;
        anchors.rightMargin: 10;

        text: qsTr(value.toString())
        font.family: "Verdana"
        font.pixelSize: 50
        color: Qt.red
    }

    HealthBar {
        maxHitPoints: duck.maxHP
        hitPoints: duck.hp
        anchors.top: main.top
        anchors.right: records.left
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
