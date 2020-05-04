#ifndef WorkShiftProcess_H
#define WorkShiftProcess_H

#include <QObject>

#include "xPos.h"
#include "Backend/Containers/Staff.h"
#include "Backend/Containers/Database.h"

class WorkShiftProcess : public QObject
{
    Q_OBJECT

public:
    explicit WorkShiftProcess(QObject *parent = nullptr );

public:

    Q_INVOKABLE int invokLogin( QString _userName, QString _userPwd );

signals:
    void sigLoginSucceed();
    void sigLoginFailed();

private:
    xpos_store::Staff m_currStaff;

};

#endif // WorkShiftProcess_H
