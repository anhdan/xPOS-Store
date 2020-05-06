#ifndef PERSON_H
#define PERSON_H


#include "xPos.h"

namespace xpos_store
{

class Person
{
protected:
    void setDefault( )
    {
        m_id = 0;
        m_name = "";
        m_phoneNumber = "";
        m_email = "";
        m_gender = Gender::UNKNOWN;
        m_birthYear = 0;
    }


public:
    Person()
    {
        setDefault();
    }
    ~Person(){}

public:
    // get set ID
    inline void setId( const uint64_t _id ) { m_id = _id; }
    inline uint64_t getId() { return m_id; }

    // get set Name
    inline void setName( const std::string &_name ) { m_name = _name; }
    inline std::string getName() { return m_name; }

    // Get Set Phone
    inline void setPhoneNumber( const std::string &_phoneNumber ) { m_phoneNumber = _phoneNumber; }
    inline std::string getPhoneNumber() { return m_phoneNumber; }
    inline void deletePhoneNumber() { m_phoneNumber = ""; }

    // Get Set Mail
    inline void setEmail( const std::string &_email ) { m_email = _email; }
    inline std::string getEmail() { return m_email; }
    inline void deleteEmail() { m_email = ""; }

    // Get Set Gender
    inline void setGender( const Gender _gender ){ m_gender = _gender; }
    inline Gender getGender() { return m_gender; }

    // Get Set Birth Year
    inline void setBirthYear( const int _birthYear ) { m_birthYear = _birthYear; }
    inline int getBirthYear() { return m_birthYear; }


protected:
    uint64_t m_id;
    std::string m_name;
    std::string m_phoneNumber;
    std::string m_email;
    Gender m_gender;
    int m_birthYear;
};

}

#endif // PERSON_H
