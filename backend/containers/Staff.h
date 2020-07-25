#ifndef STAFF_H
#define STAFF_H

#include "backend/xPos.h"
#include "backend/containers/Person.h"

namespace xpos_store {

class Staff : public Person
{
public:
    Staff() : Person()
    {
        setDefault();
    }
    ~Staff() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant();
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();

    void setPrivilege( const Privilege _privilege );
    Privilege getPrivilege();
    void setLoginName( const std::string &_userName );
    std::string getLoginName();
    void setLoginPwd( const std::string &_pwd );
    std::string getLoginPwd();

    static xpError_t searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName);

private:
    Privilege m_privilege;
    std::string m_loginName;
    std::string m_loginPwd;
};

}

#endif // STAFF_H
