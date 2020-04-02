#ifndef STAFF_H
#define STAFF_H

#include "xPos.h"
#include "Person.h"

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

private:
    Privilege m_privilege;
    std::string m_loginName;
    std::string m_loginPwd;
};

}

#endif // STAFF_H
