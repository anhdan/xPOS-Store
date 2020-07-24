#include "Bill.h"

namespace xpos_store {

/**
 * @brief Bill::setDefault
 */
void Bill::setDefault()
{
    m_staffId = m_customerId = "";
    m_creationTime = 0;
    m_totalCharging = m_totalDiscount = m_customerPayment = 0;
    m_usedPoint = m_rewardedPoint = 0;
}


/**
 * @brief Bill::copyTo
 */
void Bill::copyTo(Item *_item)
{
    if( _item )
    {
        Bill* bill = (Bill*)_item;
        bill->m_staffId = m_staffId;
        bill->m_customerId = m_customerId;
        bill->m_creationTime = m_creationTime;
        bill->m_totalCharging = m_totalCharging;
        bill->m_totalDiscount = m_totalDiscount;
        bill->m_customerPayment = m_customerPayment;
        bill->m_rewardedPoint = m_rewardedPoint;
    }
}


/**
 * @brief Bill::printInfo
 */
void Bill::printInfo()
{
    LOG_MSG( "\n---------Bill---------\n" );
    LOG_MSG( ". STAFF ID:           %s\n", m_staffId.c_str() );
    LOG_MSG( ". CUSTOMER ID:        %s\n", m_customerId.c_str() );
    LOG_MSG( ". CREATION TIME:      %ld\n", (unsigned long)m_creationTime );
    LOG_MSG( ". TOTAL CHARGING:     %f\n", m_totalCharging );
    LOG_MSG( ". TOTAL DISCOUNT:     %f\n", m_totalDiscount );
    LOG_MSG( ". CUSTOMER PAYMENT:   %f\n", m_customerPayment );
    LOG_MSG( ". USED POINT:         %d\n", m_usedPoint );
    LOG_MSG( ". REWARDED POINT:     %d\n", m_rewardedPoint );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Bill::toQVariant
 */
QVariant Bill::toQVariant( )
{

}


/**
 * @brief Bill::fromQVariant
 */
xpError_t Bill::fromQVariant( const QVariant &_item )
{
    return xpSuccess;
}


/**
 * @brief Bill::setStaffId
 */
void Bill::setStaffId( const std::string &_staffId )
{
    m_staffId = _staffId;
}


/**
 * @brief Bill::getStaffId
 */
std::string Bill::getStaffId()
{
    return m_staffId;
}


/**
 * @brief Bill::setCustomerId
 */
void Bill::setCustomerId( const std::string &_custmerId )
{
    m_customerId = _custmerId;
}

/**
 * @brief Bill::getCustomerId
 */
std::string Bill::getCustomerId()
{
    return m_customerId;
}


/**
 * @brief Bill::setCreationTime
 */
void Bill::setCreationTime( const time_t _creationTime )
{
    m_creationTime = _creationTime;
}


/**
 * @brief Bill::getCreationTime
 */
time_t Bill::getCreationTime()
{
    return m_creationTime;
}


/**
 * @brief Bill::setPayment
 */
void Bill::setPayment( const double _totalCharging, const double _totalDiscount, const double _customerPayment )
{
    m_totalCharging = _totalCharging;
    m_totalDiscount = _totalDiscount;
    m_customerPayment = _customerPayment;
}


/**
 * @brief Bill::getPayment
 */
void Bill::getPayment( double *_totalCharging, double *_totalDiscount, double *_customerPayment )
{
    if( _totalCharging )
    {
        *_totalCharging = m_totalCharging;
    }

    if( _totalDiscount )
    {
        *_totalDiscount = m_totalDiscount;
    }

    if( _customerPayment )
    {
        *_customerPayment = m_customerPayment;
    }
}


/**
 * @brief Bill::getTotalCharging
 */
double Bill::getTotalCharging()
{
    return m_totalCharging;
}


/**
 * @brief Bill::getTotalDiscount
 */
double Bill::getTotalDiscount()
{
    return m_totalDiscount;
}


/**
 * @brief Bill::getCustomerPayment
 */
double Bill::getCustomerPayment()
{
    return m_customerPayment;
}


/**
 * @brief Bill::setPoints
 */
void Bill::setPoints( const double _usedPoint, const double _rewardedPoint )
{
    m_usedPoint = _usedPoint;
    m_rewardedPoint = _rewardedPoint;
}


/**
 * @brief Bill::getUsedPoint
 */
double Bill::getUsedPoint()
{
    return m_usedPoint;
}

/**
 * @brief Bill::getRewardedPoint
 */
double Bill::getRewardedPoint()
{
    return m_rewardedPoint;
}

}
