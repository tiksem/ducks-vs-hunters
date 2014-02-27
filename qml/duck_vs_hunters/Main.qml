import QtQuick 2.0

Rectangle {

    id: main
    width: 960
    height: 540

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
            onGameOver: {
                main.state = "GAME_OVER";
            }
        }
    }

    Component {
        id: gameOver

        GameOver {

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
        }
    ]
}
