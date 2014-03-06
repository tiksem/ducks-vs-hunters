import QtQuick 2.0

Rectangle {

    id: main
    width: 960
    height: 540

    property string screenBackground: "images/background.jpg"
    property string screenForeground: "images/foreground.jpg"

    state: "GAME"

    //transform: Scale { xScale: screenSize.width / width; yScale: screenSize.height / height}

    Loader {
        id: screenLoader
        focus: true
        anchors.fill: parent
    }

    Component {
        id: game

        Game {
            background: screenBackground

            onGameOver: {
                main.state = "GAME_OVER";
            }
        }
    }

    Component {
        id: gameOver

        GameOver {
            background: screenBackground
            foreground: screenForeground

            onFinished: {
                main.state = "MENU"
            }
        }
    }

    Component {
        id: gameMenu

        GameStart {
            background: screenBackground
            foreground: screenForeground
        }
    }

    states: [
        State {
            name: "GAME"
            StateChangeScript {
                script: {
                    screenLoader.sourceComponent = game;
                }
            }
        },

        State {
            name: "GAME_OVER"
            StateChangeScript {
                script: {
                    screenLoader.sourceComponent = gameOver;
                }
            }
        },

        State {
            name: "MENU"
            StateChangeScript {
                script: {
                    screenLoader.sourceComponent = gameMenu;
                }
            }
        }
    ]
}
