import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0

Window {
    property var enemyList: []
    property var batteryList: []
    property var fuelList: []

    function clearlists() {
        for (var i=enemyList.length; i>0; i--) {
            enemyList.pop()
        }
        for (var j=batteryList.length; j>0; j--) {
            batteryList.pop()
        }
        for (var k=fuelList.length; k>0; k--) {
            fuelList.pop()
        }
    }

    function currentTime() {
        if (helper.currentTime()!=="0")
            return helper.currentTime()
        else return ""
    }
    function startGame() {
        clearlists()
        endScreen.visible = false
        helper.nullScore();
        player.enabled = true
        player.visible = true
        bullet_timer.running = true
        enemy_timer.running = true
        fuel_timer.running = true
        battery_timer.running = true
        helper.startTimer()
        timerFieldcheck.running = true
        timer_place.visible = true
    }
    function stopGame() {
        helper.stopTimer()
        timerFieldcheck.running = false
        timer_place.visible = false
        bullet_timer.running = false
        enemy_timer.running = false
        fuel_timer.running = false
        battery_timer.running = false
        player.visible = false
        player.enabled = false
        scoreText.text = "Your Score: "+helper.currentScore();
        endScreen.visible = true
    }

    id: w
    visible: true
    minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 480
    maximumHeight: 480

    title: qsTr("Fighter")

    AnimatedImage {
        id: animatedImage
        anchors.fill: parent
        source: "qrc:/resources/background.gif"
    }

    Component.onCompleted: startGame();

    Timer {
        id: timerFieldcheck
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            if (currentTime() === "") stopGame()
            gameTimer.text = currentTime()
        }
    }


    Rectangle {
        id: player
        width: 100
        height: 100
        color: "transparent"
        x: w.width/2-width/2
        y: w.height-height

        AnimatedImage {
            anchors.fill: parent
            source: "qrc:/resources/Fighter.gif"
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.maximumX: w.width-parent.width
            drag.minimumX: 0
            drag.maximumY: w.height-parent.height
            drag.minimumY: w.height/1.5-parent.height/1.5
        }
        Timer {
            id: status_check
            interval: 10
            running: true
            repeat: true
            onTriggered: {
                for (var i=0; i<enemyList.length; i++) {
                    var en = enemyList[i]
                    if (player.x+player.width/2 > en.x && player.x+player.width/2 < en.x+en.width && player.y < en.y+en.height/2 && player.y > en.y-en.height/2) {
                        stopGame();
                    }
                }
                for (var j=0; j<batteryList.length; j++) {
                    var ba = batteryList[j]
                    if (player.x+player.width/2 > ba.x && player.x+player.width/2 < ba.x+ba.width && player.y < ba.y+ba.height/2 && player.y > ba.y-ba.height/2) {
                        ba.visible = false
                        bullet_timer.interval = 250;
                        power_down.restart()
                    }
                }
                for (var k=0; k<fuelList.length; k++) {
                    var fu = fuelList[k]
                    if (player.x+player.width/2 > fu.x && player.x+player.width/2 < fu.x+fu.width && player.y < fu.y+fu.height/2 && player.y > fu.y-fu.height/2) {
                        fu.visible = false
                        helper.startTimer();
                    }
                }
            }
        }
    }

    Rectangle {
        id: endScreen
        color: "transparent"
        visible: false
        width: parent.width
        height: parent.height

        Text {
            id: scoreText
            text: qsTr("Your score:")
            anchors.topMargin: 100
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            anchors.fill: parent
            font.pixelSize: 40
        }

        ColumnLayout {
            scale: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Button {
                id: button_new_game
                text: qsTr("Start New Game")
                onClicked: startGame()
            }

            Button {
                id: button_exit
                text: qsTr("Exit Game")
                onClicked: Qt.quit()
            }
        }


    }

    Rectangle {
        id: timer_place
        width: w.width
        height: 200
        color: "transparent"

        Text {
            id: gameTimer
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 40
        }
        Text {
            id: pointScore
            color: "white"
            text: "Score: 0"
            anchors.right: parent.right
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 20
        }
    }
    Timer {
        id: score_check
        interval: 100
        repeat: true
        running: true
        onTriggered: pointScore.text = "Score: "+helper.currentScore();
    }

    Timer {
        id: power_down
        repeat: false
        running: false
        interval: 5000
        onTriggered: bullet_timer.interval = 1000
    }

    Timer {
        id: bullet_timer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var com = Qt.createComponent("bullet.qml")
            if (com.status === Component.Ready) {
                com.createObject(w,{"x":player.x+45, "y":player.y+45})
            }
        }
    }

    Timer {
        id: enemy_timer
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            var com = Qt.createComponent("asteroid.qml")
            if (com.status === Component.Ready) {
                var en = com.createObject(w,{"x":Math.random()*w.width, "y":0})
                enemyList.push(en)
            }
        }
    }
    Timer {
        id: battery_timer
        interval: 7000
        running: true
        repeat: true
        onTriggered: {
            var com = Qt.createComponent("battery.qml")
            if (com.status === Component.Ready) {
                var en = com.createObject(w,{"x":Math.random()*w.width, "y":0})
                batteryList.push(en)
            }
        }
    }
    Timer {
        id: fuel_timer
        interval: 13000
        running: true
        repeat: true
        onTriggered: {
            var com = Qt.createComponent("fuel.qml")
            if (com.status === Component.Ready) {
                var en = com.createObject(w,{"x":Math.random()*w.width, "y":0})
                fuelList.push(en)
            }
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequences: [StandardKey.Close, "Ctrl+Q"]
        onActivated: Qt.quit()
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequences: [StandardKey.Close, "Esc"]
        onActivated: stopGame()
    }

}

