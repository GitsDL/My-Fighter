#include "helper.h"
#include <QTimer>
#include <QString>

helper::helper(QObject *parent) : QObject(parent)
{

}

void helper::startTimer()
{
    timer = new QTimer(this);
    timer->setSingleShot(true);
    timer->start(1000*30);
}
void helper::stopTimer()
{
   timer->stop();
}
void helper::nullScore()
{
    score = 0;
}
QString helper::currentTime()
{
    if (timer->remainingTime()==-1) return "0";
    else
    return QString::number(qRound((double)timer->remainingTime()/1000));

}
QString helper::currentScore()
{
    return QString::number(score);
}
void helper::addScore(qint64 number)
{
    score = score+number;
}
