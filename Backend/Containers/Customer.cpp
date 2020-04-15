#include "Customer.h"

namespace xpos_store {

/**
 * @brief Customer::setDefault
 */
void Customer::setDefault()
{
    Person::setDefault();
    m_enrollmentTime = 0;
    m_shoppingCount = 0;
    m_point = 0;
}


/**
 * @brief Customer::addPayment
 */
xpError_t Customer::addPayment( const double _additive )
{
    if( _additive < 0 )
        return xpErrorInvalidValues;
    m_totalPayment += _additive;
    return xpSuccess;
}


/**
 * @brief Customer::rewardPoint
 */
xpError_t Customer::rewardPoint( const Point &_rewardedPoint )
{
    if( (Point)_rewardedPoint < 0 )
        return xpErrorInvalidValues;
    m_point = m_point + _rewardedPoint;
    return xpSuccess;
}


/**
 * @brief Customer::usePoint
 */
xpError_t Customer::usePoint( const Point &_usedPoint )
{
    if( ((Point)_usedPoint < 0) || ((Point)_usedPoint > m_point) )
    {
        return xpErrorInvalidValues;
    }
    m_point = m_point - _usedPoint;
    return xpSuccess;
}

}
