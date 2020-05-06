#include "WorkShiftProcess.h"

/**
 * @brief WorkShiftProcess::WorkShiftProcess
 */
WorkShiftProcess::WorkShiftProcess(QObject *parent) : QObject(parent)
{

}


/**
 * @brief WorkShiftProcess::invokLogin
 */
int WorkShiftProcess::invokLogin(QString _userName, QString _userPwd)
{
    if( !glbProductDB->isOpen() )
    {
        glbProductDB->open();
    }

    xpos_store::Table *table = glbProductDB->getTableByName( "STAFF" );
    if( table == nullptr )
    {
        glbProductDB->close();
        LOG_MSG( "[ERR:%d] %s:%d: Failed to connect to database\n", xpErrorNotExist, __FILE__, __LINE__);
        return xpErrorNotExist;
    }

    xpos_store::Staff *staff = xpos_store::Staff::authenticate( table, _userName.toStdString(), _userPwd.toStdString() );
    if( staff == nullptr )
    {
        m_loggedIn = false;
        m_currStaff.setDefault();
        delete staff;
        glbProductDB->close();
        return xpErrorProcessFailure;
    }

    m_loggedIn = true;
    staff->copyTo(m_currStaff);
    delete staff;
    glbProductDB->close();

    return xpSuccess;
}
