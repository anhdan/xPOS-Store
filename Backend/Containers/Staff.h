#ifndef STAFF_H
#define STAFF_H

#include "xPos.h"
#include "Person.h"
#include "Database.h"
#include "Backend/Configs/sqlitecmdFormat.h"

namespace xpos_store
{

class Staff : public Person
{
protected:
    void setDefault()
    {
        m_privilege = Privilege::GUEST;
        m_loginName = "";
        m_loginPwd  = "";
    }

public:
    Staff()
    {
        setDefault();
    }

    Staff( const std::string _loginName, const std::string _loginPwd, const Privilege _privilege )
    {
        m_privilege = _privilege;
        m_loginName = _loginName;
        m_loginPwd  = _loginPwd;
    }

    ~Staff(){}

public:
    inline void setPrivilege( const Privilege _privilege ) { m_privilege = _privilege; }
    inline Privilege getPrivilege( ) { return m_privilege; }

    inline void setLoginName( const std::string _loginName ) { m_loginName = _loginName; }
    inline std::string getLoginName( ) { return m_loginName; }

    inline void setLoginPwd( const std::string _loginPwd ) { m_loginPwd = _loginPwd; }
    inline std::string getLoginPwd( ) { return m_loginPwd; }

    //
    //===== Database interface
    //
    static Staff* authenticate( const Table* _staffTable, const std::string &_staffName, const std::string &_staffPwd );
    xpError_t insertNewStaff( const Table* _staffTable, const Staff* _newStaff );

private:
    static xpError_t searchCallBack( void* data, int fieldsNum, char **fieldVal, char** fieldName );

private:
    Privilege m_privilege;
    std::string m_loginName;
    std::string m_loginPwd;
};

}

#endif // STAFF_H
