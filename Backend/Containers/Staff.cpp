#include "Staff.h"

namespace xpos_store
{


void Staff::printInfo()
{
    LOG_MSG( "\n---------Staff---------\n" );
    LOG_MSG( ". ID:             %d\n", m_id );
    LOG_MSG( ". NAME:           %s\n", m_name.c_str() );
    LOG_MSG( ". PHONE:          %s\n", m_phoneNumber.c_str() );
    LOG_MSG( ". EMAIL:          %s\n", m_email.c_str() );
    LOG_MSG( ". GENDER:         %d\n", (int)m_gender );
    LOG_MSG( ". BIRTH YEAR:     %d\n", m_birthYear );
    LOG_MSG( ". PRIVILEGE:      %d\n", (int)m_privilege );
    LOG_MSG( ". LOGIN NAME:     %s\n", m_loginName.c_str() );
    LOG_MSG( ". LOGIN PWD:      %s\n", m_loginPwd.c_str() );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Staff::copyTo
 * @param _staff
 */
void Staff::copyTo(Staff &_staff)
{
    _staff.m_id = m_id;
    _staff.m_name = m_name;
    _staff.m_phoneNumber = m_phoneNumber;
    _staff.m_email = m_email;
    _staff.m_birthYear = m_birthYear;
    _staff.m_gender = m_gender;
    _staff.m_loginName = m_loginName;
    _staff.m_loginPwd = m_loginPwd;
    _staff.m_privilege = m_privilege;
}

/**
 * @brief Staff::authenticate
 */
Staff* Staff::authenticate(const Table *_staffTable, const std::string &_staffName, const std::string &_staffPwd)
{
    if(_staffTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return nullptr;
    }

    // Execute SQLITE command to search for record
    Staff *staff = new Staff;
    std::string sqliteCmd = "SELECT * from " + _staffTable->name + " where LOGIN_NAME='" + _staffName + "';";
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _staffTable->db, sqliteCmd.c_str(), searchCallBack, (void*)staff, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return nullptr;
    }

    staff->printInfo();

    if( staff->getLoginName() == "" || (staff->getLoginPwd() != _staffPwd) )
    {
        LOG_MSG( "[WAR] %s:%d: Login user name or password is incorrect\n", __FILE__, __LINE__ );
        delete staff;
    }

    return staff;
}


/**
 * @brief Staff::searchCallBack
 */
xpError_t Staff::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    Staff* staff = (Staff*)data;
    for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
    {
        if( !strcmp(fieldName[fieldId], "LOGIN_NAME") )
        {
            staff->m_loginName = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "PASSWORD") )
        {
            staff->m_loginPwd = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "NAME") )
        {
            staff->m_name = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "PHONE_NUMBER") )
        {
            staff->m_phoneNumber = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "EMAIL") )
        {
            staff->m_email = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "GENDER") )
        {
            staff->m_gender = fieldVal[fieldId] ? (Gender)atoi(fieldVal[fieldId]) : Gender::UNKNOWN;
        }
        else if( !strcmp(fieldName[fieldId], "BIRTH_YEAR") )
        {
            staff->m_birthYear = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "PRIVILEGE") )
        {
            staff->m_birthYear = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
            staff->setDefault();
            return xpErrorProcessFailure;
        }
    }

    return xpSuccess;
}


}
