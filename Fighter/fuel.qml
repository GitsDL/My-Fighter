import QtQuick 2.0

Rectangle {
    width: 100
    height: 100
    color: "transparent"
    Image {
        anchors.fill: parent
        source: "qrc:/resources/fuel.png"
    }
    NumberAnimation on y{
        from: y-100
        to: parent.height+100
        duration: 3000
        running: true
    }
    onYChanged: {
        if (y>parent.height+50) {
            destroy()
        }
    }
}
