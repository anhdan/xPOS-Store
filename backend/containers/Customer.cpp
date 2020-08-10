#include "Customer.h"

namespace xpos_store {

/**
 * @brief Customer::setDefault
 */
void Customer::setDefault()
{
    m_id = "";
    m_name = "";
    m_phone = "";
    m_email = "";
    m_shoppingCnt = 0;
    m_totalPayment = 0.0;
    m_rewardPoint = 0;
    m_usedPoint = 0;
}


/**
 * @brief Customer::copyTo
 */
void Customer::copyTo(Item *_item)
{
    if( _item )
    {
        Customer* _cust = (Customer*)_item;
        _cust->m_id = m_id;
        _cust->m_name = m_name;
        _cust->m_phone = m_phone;
        _cust->m_email = m_email;
        _cust->m_shoppingCnt = m_shoppingCnt;
        _cust->m_totalPayment = m_totalPayment;
        _cust->m_rewardPoint = m_rewardPoint;
    }
}


/**
 * @brief Customer::printInfo
 */
void Customer::printInfo()
{
    LOG_MSG( "\n---------Customer---------\n" );
    LOG_MSG( ". ID:             %s\n", m_id.c_str() );
    LOG_MSG( ". NAME:           %s\n", m_name.c_str() );
    LOG_MSG( ". PHONE NUMBER:   %s\n", m_phone.c_str() );
    LOG_MSG( ". EMAIL:          %s\n", m_email.c_str() );
    LOG_MSG( ". SHOPPING_COUNT: %d\n", m_shoppingCnt );
    LOG_MSG( ". TOTAL_PAYMENT:  %f\n", m_totalPayment );
    LOG_MSG( ". POINT:          %d\n", m_rewardPoint );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Customer::toQVariant
 */
QVariant Customer::toQVariant( )
{
    QVariantMap map;
    map["id"] = QString::fromStdString( getId() );
    map["name"] = QString::fromStdString( getName() );
    map["phone"] = QString::fromStdString( getPhone() );
    map["email"] = QString::fromStdString( getEmail() );
    map["shopping_count"] = getShoppingCount();
    map["total_payment"] = getTotalPayment();
    map["point"] = getRewardedPoint();
    map["used_point"] = getUsedPoint();

    return QVariant( map );
}


/**
 * @brief Customer::fromQVariant
 */
xpError_t Customer::fromQVariant( const QVariant &_item )
{
    setDefault();
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        if( map.contains( "id" ) )
            m_id = map["id"].toString().toStdString();

        if( map.contains( "name" ) )
            m_name = map["name"].toString().toStdString();

        if( map.contains( "phone" ) )
            m_phone = map["phone"].toString().toStdString();

        if( map.contains( "email" ) )
            m_email = map["email"].toString().toStdString();

        if( map.contains( "shopping_count" ) )
        {
            m_shoppingCnt = map["shopping_count"].toString().toInt( &ret );
            finalRet &= ret;
        }

        if( map.contains( "total_payment" ) )
        {
            m_totalPayment = map["total_payment"].toString().toDouble( &ret );
            finalRet &= ret;
        }

        if( map.contains( "point" ) )
        {
            m_rewardPoint = map["point"].toString().toInt( &ret );
            finalRet &= ret;
        }

        if( map.contains( "used_point" ) )
        {
            m_rewardPoint = map["used_point"].toString().toInt( &ret );
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
 * @brief Customer::isValid
 */
bool Customer::isValid()
{
    return (m_id != "");
}


/**
 * @brief Customer::toJSONString
 */
QString Customer::toJSONString()
{
    //! TODO:
    //!     Implement this
    return QString("");
}

/**
 * @brief Customer::searchCallBack
 */
xpError_t Customer::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    Customer* customer = (Customer*)data;
    for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
    {
        if( !strcmp(fieldName[fieldId], "ID") )
        {
            customer->m_id = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "NAME") )
        {
            customer->m_name = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "PHONE") )
        {
            customer->m_phone = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "EMAIL") )
        {
            customer->m_email = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "TOTAL_PAYMENT") )
        {
            customer->m_totalPayment = fieldVal[fieldId] ? atof( fieldVal[fieldId] ) : 0.0;
        }
        else if( !strcmp(fieldName[fieldId], "REWARDED_POINT") )
        {
            customer->m_rewardPoint = fieldVal[fieldId] ? atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "USED_POINT") )
        {
            customer->m_usedPoint = fieldVal[fieldId] ? atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "SHOPPING_COUNT") )
        {
            customer->m_shoppingCnt = fieldVal[fieldId] ? atoi( fieldVal[fieldId] ) : 0;
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
            customer->setDefault();
            return xpErrorProcessFailure;
        }
    }
    return xpSuccess;
}

//==========================================================
//
//           get set functions
//
//==========================================================
/**
 * @brief Customer::setShoppingCount
 */
void Customer::setShoppingCount( const int _shoppingCnt )
{
    m_shoppingCnt = _shoppingCnt;
}


/**
 * @brief Customer::getShoppingCount
 */
int Customer::getShoppingCount()
{
    return m_shoppingCnt;
}


/**
 * @brief Customer::setTotalPayment
 */
void Customer::setTotalPayment(const double _total )
{
    m_totalPayment = _total;
}


/**
 * @brief Customer::getTotalPayment
 */
double Customer::getTotalPayment()
{
    return m_totalPayment;
}


/**
 * @brief Customer::setRewardedPoint
 */
void Customer::setRewardedPoint( const int _point )
{
    m_rewardPoint = _point;
}


/**
 * @brief Customer::getRewardedPoint
 */
int Customer::getRewardedPoint()
{
    return m_rewardPoint;
}


/**
 * @brief Customer::setUsedPoint
 */
void Customer::setUsedPoint(const int _point)
{
    m_usedPoint = _point;
}


/**
 * @brief Customer::getUsedPoint
 */
int Customer::getUsedPoint()
{
    return m_usedPoint;
}


/**
 * @brief Customer::makePayment
 */
xpError_t Customer::makePayment(const double _payment, const int _usedPoint, const int _rewardedPoint)
{
    if( _payment < 0 || _usedPoint > m_rewardPoint || _rewardedPoint < 0 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid payment info\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_totalPayment += _payment;
    m_shoppingCnt++;
    m_rewardPoint = m_rewardPoint + _rewardedPoint - _usedPoint;
    m_usedPoint += _usedPoint;

    return xpSuccess;
}


/**
 * @brief Customer::makePayment
 */
xpError_t Customer::makePayment( Payment &_payment)
{
    if( !_payment.isValid() )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid payment info\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_totalPayment += _payment.getTotalCharging();
    m_shoppingCnt++;
    m_rewardPoint = m_rewardPoint + _payment.getRewardedPoint() - m_usedPoint;
    m_usedPoint += _payment.getUsedPoint();

    return xpSuccess;
}

}
