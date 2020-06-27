import QtQuick 2.0

Rectangle {


    id: bullet
    width: 10
    height: 10
    radius: width/2
    color: "lightgray"

    NumberAnimation on y{
        from: y
        to: -100
        duration: 1000
        running: true
    }
    onYChanged: {
        if (y<-5) {
            bullet.destroy()
        }
        else
        for (var i=0; i<enemyList.length; i++) {
            var en = enemyList[i]
            if (bullet.x > en.x && bullet.x < en.x+en.width && bullet.y < en.y+en.height/2 && bullet.y > en.y-en.height/2){
                en.destroy()
                bullet.destroy()
                helper.addScore(1);
            }
        }
    }
}
