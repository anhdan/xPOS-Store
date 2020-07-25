#include "Payment.h"

namespace xpos_store {

/**
 * @brief Payment::setDefault
 */
void Payment::setDefault()
{
    m_totalCharging = m_totalDiscount = m_customerPayment = 0;
    m_usedPoint = m_rewardedPoint = 0;
}


/**
 * @brief Payment::copyTo
 */
void Payment::copyTo( Item *_item )
{
    if( _item )
    {
        Payment* payment = (Payment*)_item;
        payment->m_totalCharging = m_totalCharging;
        payment->m_totalDiscount = m_totalDiscount;
        payment->m_customerPayment = m_customerPayment;
        payment->m_rewardedPoint = m_rewardedPoint;
    }
}


/**
 * @brief Payment::printInfo
 */
void Payment::printInfo()
{
    LOG_MSG( "\n---------PAYMENT---------\n" );
    LOG_MSG( ". TOTAL CHARGING:     %f\n", m_totalCharging );
    LOG_MSG( ". TOTAL DISCOUNT:     %f\n", m_totalDiscount );
    LOG_MSG( ". CUSTOMER PAYMENT:   %f\n", m_customerPayment );
    LOG_MSG( ". USED POINT:         %d\n", m_usedPoint );
    LOG_MSG( ". REWARDED POINT:     %d\n", m_rewardedPoint );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Payment::toQVariant
 */
QVariant Payment::toQVariant( )
{

}


/**
 * @brief Payment::fromQVariant
 */
xpError_t Payment::fromQVariant( const QVariant &_item )
{
    return xpSuccess;
}


/**
 * @brief Payment::isValid
 */
bool Payment::isValid()
{
    return (m_totalCharging > 0 && m_customerPayment >=0);
}


/**
 * @brief Payment::setTotalCharging
 */
void Payment::setTotalCharging( const double _totalCharing )
{
    m_totalCharging = _totalCharing;
}


/**
 * @brief Payment::getTotalCharging
 */
double Payment::getTotalCharging()
{
    return m_totalCharging;
}


/**
 * @brief Payment::setTotalDiscount
 */
void Payment::setTotalDiscount( const double _totalDiscount )
{
    m_totalDiscount = _totalDiscount;
}


/**
 * @brief Payment::getTotalDiscount
 */
double Payment::getTotalDiscount()
{
    return m_totalDiscount;
}


/**
 * @brief Payment::setCustmomerPayment
 */
void Payment::setCustmomerPayment( const double _customerPayment )
{
    m_customerPayment = _customerPayment;
}


/**
 * @brief Payment::getCustomerPayment
 */
double Payment::getCustomerPayment()
{
    return m_customerPayment;
}


/**
 * @brief Payment::getReturnToCustomer
 */
double Payment::getReturnToCustomer()
{
    return ((m_customerPayment > m_totalCharging) ? (m_customerPayment - m_totalCharging) : 0);
}


/**
 * @brief Payment::setUsedPoints
 */
void Payment::setUsedPoints( const double _usedPoint )
{
    m_usedPoint = _usedPoint;
}


/**
 * @brief Payment::getUsedPoint
 */
double Payment::getUsedPoint()
{
    return m_usedPoint;
}


/**
 * @brief Payment::setRewardedPoints
 */
void Payment::setRewardedPoints( const double _rewardedPoint )
{
    m_rewardedPoint = _rewardedPoint;
}


/**
 * @brief Payment::getRewardedPoint
 */
double Payment::getRewardedPoint()
{
    return m_rewardedPoint;
}

}
