#include "Payment.h"

namespace xpos_store {

/**
 * @brief Payment::setDefault
 */
void Payment::setDefault()
{
    m_totalCharging = m_totalDiscount = m_customerPayment = m_tax = 0;
    m_usedPoint = m_rewardedPoint = 0;
    m_payingMethod = PayingMethod::CASH;
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
        payment->m_payingMethod = m_payingMethod;
        payment->m_customerPayment = m_customerPayment;
        payment->m_usedPoint = m_usedPoint;
        payment->m_rewardedPoint = m_rewardedPoint;
        payment->m_tax = m_tax;
    }
}


/**
 * @brief Payment::printInfo
 */
void Payment::printInfo()
{
    LOG_MSG( "\n---------PAYMENT---------\n" );
    LOG_MSG( ". TOTAL CHARGING:     %f\n", m_totalCharging );
    LOG_MSG( ". TOTAL TAX:          %f\n", m_tax );
    LOG_MSG( ". TOTAL DISCOUNT:     %f\n", m_totalDiscount );
    LOG_MSG( ". PAYING METHOD:      %s\n", (m_payingMethod == PayingMethod::CASH) ? "CASH" : "CARD" );
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
    QVariantMap map;
    map["total_charging"] = m_totalCharging;
    map["total_discount"] = m_totalDiscount;
    map["customer_payment"] = m_customerPayment;
    map["used_point"] = m_usedPoint;
    map["rewarded_point"] = m_rewardedPoint;
    map["paying_method"] = (int)m_payingMethod;

    return QVariant::fromValue( map );
}


/**
 * @brief Payment::fromQVariant
 */
xpError_t Payment::fromQVariant( const QVariant &_item )
{
    setDefault();
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        if( map.contains("total_charging") )
        {
            m_totalCharging = map["total_charging"].toDouble( &ret );
            finalRet &= ret;
        }

        if( map.contains("total_discount") )
        {
            m_totalDiscount = map["total_discount"].toDouble( &ret );
            finalRet &= ret;
        }

        if( map.contains("paying_method") )
        {
            m_payingMethod = (PayingMethod)(map["paying_method"].toInt( &ret ));
            finalRet &= ret;
        }

        if( map.contains("customer_payment") )
        {
            m_customerPayment = map["customer_payment"].toDouble( &ret );
            finalRet &= ret;
        }

        if( map.contains("used_point") )
        {
            m_usedPoint = map["used_point"].toInt( &ret );
            finalRet &= ret;
        }

        if( map.contains("rewarded_point") )
        {
            m_rewardedPoint = map["rewarded_point"].toInt( &ret );
            finalRet &= ret;
        }
    }
    else
    {
        finalRet = false;
    }

    if( !finalRet )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert from QVariant\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        setDefault();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief Payment::isValid
 */
bool Payment::isValid()
{
    return (m_totalCharging >= 0 && m_customerPayment >=0);
}


/**
 * @brief Payment::toJSONString
 */
QString Payment::toJSONString()
{
    //! TODO:
    //!     Implement this
    return QString("");
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
 * @brief Payment::setPayingMethod
 */
void Payment::setPayingMethod(const PayingMethod _payingMethod)
{
    m_payingMethod = _payingMethod;
}


/**
 * @brief Payment::getPayingMethod
 */
PayingMethod Payment::getPayingMethod()
{
    return m_payingMethod;
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
 * @brief Payment::setTax
 */
void Payment::setTax(const double _tax)
{
    m_tax = _tax;
}


/**
 * @brief Payment::getTax
 */
double Payment::getTax()
{
    return  m_tax;
}

/**
 * @brief Payment::setUsedPoints
 */
void Payment::setUsedPoints( const int _usedPoint )
{
    m_usedPoint = _usedPoint;
}


/**
 * @brief Payment::getUsedPoint
 */
int Payment::getUsedPoint()
{
    return m_usedPoint;
}


/**
 * @brief Payment::setRewardedPoints
 */
void Payment::setRewardedPoints( const int _rewardedPoint )
{
    m_rewardedPoint = _rewardedPoint;
}


/**
 * @brief Payment::getRewardedPoint
 */
int Payment::getRewardedPoint()
{
    return m_rewardedPoint;
}

}
