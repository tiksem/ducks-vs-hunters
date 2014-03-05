import QtQuick 2.0

Rectangle {
    id: main;

    property int hitPoints: 5;
    property int maxHitPoints: 5;

    QtObject {
        id: internal;
        property var hearts: [];
    }

    Component {
        id: heartComponent

        Heart {

        }
    }

    Component.onCompleted: {
         var hearts = internal.hearts;

        for(var i = 0; i < maxHitPoints; i++){
            var heart = heartComponent.createObject(main);

            heart.anchors.top = main.top;

            if(i == 0){
                heart.anchors.right = main.right;
            } else {
                heart.anchors.right = hearts[i - 1].left;
            }

            hearts.push(heart);
        }
    }

    onHitPointsChanged: {
        var hearts = internal.hearts;
        if(!hearts){
            return;
        }

        var len = hearts.length;
        for(var i = 0; i < len; i++){
            var heart = hearts[i];
            heart.visible = hitPoints > i;
        }
    }
}
