#ifndef CUSTOMER_H
#define CUSTOMER_H

#include "xPos.h"
#include "Person.h"
#include "Point.h"

namespace xpos_store
{

class Customer : public Person
{
protected:
    void setDefault( );

public:
    Customer()
    {
        setDefault();
    }
    ~Customer(){}

public:
    // Get Set Enrollment Time
    inline void setEnrollmentTime( const time_t _enrollmentTime ) { m_enrollmentTime = _enrollmentTime; }
    inline time_t getEnrollmentTime( ) { return m_enrollmentTime; }

    // Update and Get Payment
    xpError_t addPayment( const double _additive );
    inline double getTotalPayment() { return m_totalPayment; }

    // Shopping count
    inline void increaseShoppingCnt() { m_shoppingCount++; }
    inline uint32_t getShoppingCnt() { return m_shoppingCount; }

    // Update and Get Point
    xpError_t rewardPoint( const Point &_rewardedPoint );
    xpError_t usePoint( const Point &_usedPoint );
    inline Point getPoint() { return m_point; }


private:
    time_t m_enrollmentTime;
    uint32_t m_shoppingCount;
    double m_totalPayment;
    Point m_point;                /**< Loyal points rewarded to customer by store */
};

}

#endif // CUSTOMER_H
