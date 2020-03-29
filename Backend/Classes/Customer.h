#ifndef CUSTOMER_H
#define CUSTOMER_H

#include "xPos.h"
#include "Point.h"

namespace xpos_store
{

class Customer
{
private:
    void setDefault( )
    {
        m_id = "";
        m_name = "";
        m_enrollmentTime = "";
        m_phoneNumber = "";
        m_email = "";
        m_gender = Gender::UNKNOWN;
        m_birthYear = 0;
        m_point = 0;
    }


public:
    Customer();
    ~Customer(){}

public:
    // get set ID
    inline void setId( const std::string &_id ) { m_id = _id; }
    inline std::string getId() { return m_id; }

    // get set Name
    inline void setName( const std::string &_name ) { m_name = _name; }
    inline std::string getName() { return m_name; }

    // Get Set Enrollment Time
    inline void setEnrollmentTime( const time_t _enrollmentTime ) { m_enrollmentTime = _enrollmentTime; }
    inline time_t getEnrollmentTime( ) { return m_enrollmentTime; }

    // Get Set Phone
    inline void setPhoneNumber( const std::string &_phoneNumber )
    {
        m_phoneNumber = _phoneNumber;
    }
    inline std::string getPhoneNumber() { return m_phoneNumber; }
    inline void deletePhoneNumber() { m_phoneNumber = ""; }

    // Get Set Mail
    inline void setEmail( const std::string &_email )
    {
        m_email = _email;
    }
    inline std::string getEmail() { return m_email; }
    inline void deleteEmail() { m_email = ""; }

    // Get Set Gender
    inline void setGender( const Gender _gender ){ m_gender = _gender; }
    inline Gender getGender() { return m_gender; }

    // Get Set Birth Year
    inline void setBirthYear( const int _birthYear ) { m_birthYear = _birthYear; }
    inline int getBirthYear() { return m_birthYear; }

    // Update and Get Payment
    inline xpError_t addPayment( const double _additive )
    {
        if( _additive < 0 )
            return xpErrorInvalidValues;
        m_totalPayment += _additive;
        return xpSuccess;
    }
    inline double getTotalPayment() { return m_totalPayment; }

    // Update and Get Point
    inline xpError_t rewardPoint( const Point &_rewardedPoint )
    {
        if( _rewardedPoint < 0 )
            return xpErrorInvalidValues;
        m_point = m_point + _rewardedPoint;
        return xpSuccess;
    }

    inline xpError_t usePoint( const Point &_usedPoint )
    {
        if( (_usedPoint < 0) || (_usedPoint > m_point) )
            return xpErrorInvalidValues;
        m_point = m_point - _usedPoint;
        return xpSuccess;
    }

    inline void getPoint() { return m_point; }


private:
    std::string m_id;
    std::string m_name;
    time_t m_enrollmentTime;
    std::string m_phoneNumber;
    std::string m_email;
    Gender m_gender;
    int m_birthYear;
    int m_shoppingCount;
    double m_totalPayment;
    Point m_point;                /**< Loyal points rewarded to customer by store */
};

}

#endif // CUSTOMER_H
