#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QTimer>
#include <QString>

class helper : public QObject
{
    Q_OBJECT
public:
    explicit helper(QObject *parent = nullptr);

private:
    QTimer *timer;
    qint64 score;

signals:

public slots:
    void startTimer();
    void stopTimer();
    void nullScore();
    void addScore(qint64);
    QString currentTime();
    QString currentScore();

};

#endif // HELPER_H
