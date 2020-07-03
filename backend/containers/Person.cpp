#include "Person.h"

namespace xpos_store {

/**
 * @brief Person::setId
 */
void Person::setId( const std::string &_id )
{
    m_id = _id;
}


/**
 * @brief Person::getId
 */
std::string Person::getId()
{
    return m_id;
}


/**
 * @brief Person::setName
 */
void Person::setName( const std::string &_name )
{
    m_name = _name;
}


/**
 * @brief Person::getName
 */
std::string Person::getName()
{
    return m_name;
}


/**
 * @brief Person::setPhone
 */
void Person::setPhone( const std::string &_phone )
{
    m_phone = _phone;
}


/**
 * @brief Person::getPhone
 */
std::string Person::getPhone()
{
    return m_phone;
}


/**
 * @brief Person::setEmail
 */
void Person::setEmail( const std::string &_email )
{
    m_email = _email;
}


/**
 * @brief Person::getEmail
 */
std::string Person::getEmail()
{
    return m_email;
}

}
