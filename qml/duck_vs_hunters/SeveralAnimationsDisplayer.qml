import QtQuick 2.0

Rectangle {
    property int animationsCountToFinish: 2;

    signal animationCompleted;
    signal allAnimationsCompleted

    QtObject {
        id: internal;
        property int completedAnimationsCount: 0;
    }

    onAnimationCompleted: {
        internal.completedAnimationsCount++;
        if(internal.completedAnimationsCount >= animationsCountToFinish){
            allAnimationsCompleted();
        }
    }
}
