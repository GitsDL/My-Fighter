import QtQuick 2.0

Rectangle {
    height: 100
    width: 100
    color: "transparent"
    Image {
        anchors.fill: parent
        source: "qrc:/resources/battery.png"
    }
    NumberAnimation on y{
        from: y-100
        to: parent.height+100
        duration: 2000
        running: true
    }
    onYChanged: {
        if (y>parent.height+50) {
            destroy()
        }
    }
}
