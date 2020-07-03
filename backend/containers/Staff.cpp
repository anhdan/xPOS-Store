#include "Staff.h"

namespace xpos_store {


/**
 * @brief Staff::copyTo
 * @param _staff
 */
void Staff::copyTo(Item *_item)
{
    if( _item )
    {
        Staff *_staff = (Staff*)_item;
        _staff->m_id = m_id;
        _staff->m_name = m_name;
        _staff->m_phone = m_phone;
        _staff->m_email = m_email;
        _staff->m_privilege = m_privilege;
        _staff->m_loginName = m_loginName;
        _staff->m_loginPwd = m_loginPwd;
    }
}


void Staff::printInfo()
{
    LOG_MSG( "\n---------Staff---------\n" );
    LOG_MSG( ". ID:             %d\n", m_id );
    LOG_MSG( ". NAME:           %s\n", m_name.c_str() );
    LOG_MSG( ". PHONE:          %s\n", m_phone.c_str() );
    LOG_MSG( ". EMAIL:          %s\n", m_email.c_str() );
    LOG_MSG( ". PRIVILEGE:      %d\n", (int)m_privilege );
    LOG_MSG( ". LOGIN NAME:     %s\n", m_loginName.c_str() );
    LOG_MSG( ". LOGIN PWD:      %s\n", m_loginPwd.c_str() );
    LOG_MSG( "-------------------------\n" );
}



/**
 * @brief Staff::toQVariant
 */
QVariant Staff::toQVariant()
{

}


/**
 * @brief Staff::fromQVariant
 */
xpError_t Staff::fromQVariant( const QVariant &_item )
{
    return xpSuccess;
}


/**
 * @brief Staff::searchCallBack
 */
xpError_t Staff::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    Staff* staff = (Staff*)data;
    for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
    {
        if( !strcmp(fieldName[fieldId], "ID") )
        {
            staff->m_id = fieldVal[fieldId] ? fieldVal[fieldId] : "";
        }
        else if( !strcmp(fieldName[fieldId], "NAME") )
        {
            staff->m_name = fieldVal[fieldId] ? fieldVal[fieldId] : "";
        }
        else if( !strcmp(fieldName[fieldId], "PHONE") )
        {
            staff->m_phone = fieldVal[fieldId] ? fieldVal[fieldId] : "";
        }
        else if( !strcmp(fieldName[fieldId], "EMAIL") )
        {
            staff->m_email = fieldVal[fieldId] ? fieldVal[fieldId] : "";
        }
        else if( !strcmp(fieldName[fieldId], "PRIVILEGE") )
        {
            staff->m_privilege = fieldVal[fieldId] ? Privilege(atoi( fieldVal[fieldId] )) : Privilege::GUEST;
        }
        else if( !strcmp(fieldName[fieldId], "LOGIN_NAME") )
        {
            staff->m_loginName = fieldVal[fieldId] ? fieldVal[fieldId] : "";
        }
        else if( !strcmp(fieldName[fieldId], "LOGIN_PWD") )
        {
            staff->m_loginPwd = fieldVal[fieldId] ? fieldVal[fieldId] : "";
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

//==========================================================
//
//           get set functions
//
//==========================================================
/**
 * @brief Staff::setPrivilege
 */
void Staff::setPrivilege( const Privilege _privilege )
{
    m_privilege = _privilege;
}


/**
 * @brief Staff::getPrivilege
 */
Privilege Staff::getPrivilege()
{
    return m_privilege;
}


/**
 * @brief Staff::setLoginName
 */
void Staff::setLoginName( const std::string &_loginName )
{
    m_loginName  = _loginName;
}


/**
 * @brief Staff::getLoginName
 */
std::string Staff::getLoginName()
{
    return m_loginName;
}


/**
 * @brief Staff::setLoginPwd
 */
void Staff::setLoginPwd( const std::string &_pwd )
{
    m_loginPwd = _pwd;
}


/**
 * @brief Staff::getLoginPwd
 */
std::string Staff::getLoginPwd()
{
    return m_loginPwd;
}

}
