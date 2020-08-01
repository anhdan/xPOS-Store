#ifndef PERSON_H
#define PERSON_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"

namespace xpos_store {

class Person : protected Item
{
public:
    Person() : Item() {}
    ~Person() {}

public:
    void setId( const std::string &_id );
    std::string getId();
    void setName( const std::string &_name );
    std::string getName();
    void setPhone( const std::string &_phone );
    std::string getPhone();
    void setEmail( const std::string &_email );
    std::string getEmail();

    virtual void setDefault() = 0;
    virtual void copyTo( Item *_item ) = 0;
    virtual void printInfo() = 0;
    virtual QVariant toQVariant( ) = 0;
    virtual xpError_t fromQVariant( const QVariant &_item ) = 0;
    virtual QString toJSONString() = 0;

protected:
    std::string m_id;
    std::string m_name;
    std::string m_phone;
    std::string m_email;
};

}

#endif // PERSON_H
