#include "Staff.h"

namespace xpos_store
{

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
