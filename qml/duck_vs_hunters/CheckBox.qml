import QtQuick 2.0

Item {
    id: main
    property string imageOn: "";
    property string imageOff: "";

    property bool on: false;

    signal clicked;

    Image {
        MouseArea {
            width: parent.width
            height: parent.height

            onClicked: {
                on = !on;
                main.clicked();
            }
        }

        source: on ? imageOn : imageOff
    }
}
