import QtQuick 2.0
import "random.js" as Random
import "file.js" as File
import "array.js" as Array

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

    HealthBar {
        maxHitPoints: duck.maxHP
        hitPoints: duck.hp
        anchors.top: main.top
        anchors.right: records.left
        anchors.topMargin: 10
        anchors.rightMargin: 10
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
        duck.hp++;
    }

    Component {
        id: lightHunterComponent;

        Hunter {
            hp: 1
            image: "images/light_hunter.png"
        }
    }

    Component {
        id: middleHunterComponent;

        Hunter {
            hp: 2
            level: 2
            image: "images/middle_hunter.png"
        }
    }

    Component {
        id: hardHunterComponent;

        Hunter {
            hp: 3
            level: 3
            image: "images/hard_hunter.png"
        }
    }

    QtObject {
        id: hunterFactoryLogic
        property real k: 1.5;
        property real incrementValue: 0.2;

        property real lightHunterProbability: 1.0;
        property real middleHunterProbability: 0.0;
        property real hardHunterProbability: 0.0;

        property real middleHunterProbabilityIncrement: 0.005;
        property real hardHunterProbabilityIncrement: 0.0025;

        function increaseFactorySpeed(){
            k += incrementValue;
        }

        function increaseDifficulty(){
            middleHunterProbability += middleHunterProbabilityIncrement * (1 - middleHunterProbability);
            hardHunterProbability += hardHunterProbabilityIncrement * (1 - hardHunterProbability);

            var sum = lightHunterProbability + middleHunterProbability + hardHunterProbability;
            lightHunterProbability /= sum;
            middleHunterProbability /= sum;
            hardHunterProbability /= sum;
        }
    }

    Timer {
        id: hunterFactory
        interval: 1000 / Math.log(hunterFactoryLogic.k);
        running: true
        repeat: true

        property var hunters: []
        property int maxHuntersCount: 8;
        property int maxHardHuntersCount: 2;
        property int maxMiddleHuntersCount: 3;

        property int huntersCount: 0;
        property int middleHuntersCount: 0;
        property int hardHuntersCount: 0;

        property int comboDelay: 700;

        property var lastHunterDeathTime: 0;
        property int comboDetected: 1;
        property bool stopComboCalculation: false;

        function updateComboStats(){
            if(stopComboCalculation){
                return;
            }

            var now = Date.now();
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
        }

        function onHunterDie(hunter){
            points += hunter.points;

            huntersCount--;
            Array.findAndRemove(hunters, hunter);

            updateComboStats();

            hunterFactoryLogic.increaseFactorySpeed();
            hunterFactoryLogic.increaseDifficulty();

            if(hunter.level === 2){
                middleHuntersCount--;
            } else if(hunter.level === 3) {
                hardHuntersCount--;
            }
        }

        function createHunter(){
            var component = getHunterComponent();
            return component.createObject(main);
        }

        function getHunterComponent(){
            var rand = Math.random();
            var sum = hunterFactoryLogic.lightHunterProbability;
            huntersCount++;

            if(rand <= sum){
                return lightHunterComponent;
            }

            sum += hunterFactoryLogic.middleHunterProbability;
            if(rand <= sum){
                if(middleHuntersCount >= maxMiddleHuntersCount){
                    return lightHunterComponent;
                }

                middleHuntersCount++;
                return middleHunterComponent;
            }

            if(hardHuntersCount >= maxHardHuntersCount){
                return lightHunterComponent;
            }

            hardHuntersCount++;
            return hardHunterComponent;
        }

        onTriggered: {
            if(huntersCount >= maxHuntersCount){
                return;
            }

            var hunter = createHunter();
            hunter.target = duck;
            hunter.anchors.bottom = main.bottom;
            hunter.x = Random.getRandomElementOfArray([0, main.width - hunter.width]);
            hunters.push(hunter);
            hunter.state = "MOVE";

            hunter.die.connect(function(){
                onHunterDie(hunter);
            });

            if(Array.count(hunters) > maxHuntersCount){
                console.error("Array.count(hunters) > maxHuntersCount");
            }
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

    MouseArea {
        x: 0
        width: main.width / 2
        height: main.height

        onPressed: {
            duck.state = "LEFT"
            console.log("onPressed");
        }

        onReleased: {
            duck.state = "STOP"
            console.log("onReleased");
        }
    }

    MouseArea {
        x: main.width / 2
        width: main.width / 2
        height: main.height

        onPressed: {
            duck.state = "RIGHT"
            console.log("onPressed");
        }

        onReleased: {
            duck.state = "STOP"
            console.log("onReleased");
        }
    }
}
