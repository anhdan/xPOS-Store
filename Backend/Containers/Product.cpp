#include "Product.h"

namespace xpos_store
{

/**
 * @brief Product::setDefault
 */
void Product::setDefault()
{
    m_code = "";
    m_name = "";
    m_category ="";
    m_description ="";
    m_unitName ="";

    m_unitPrice = 0.0;
    m_discountPrice = 0.0;
    m_discountStartTime = 0;
    m_discountEndTime = 0;

    m_quantityInstock = 0;
    m_quantitySold = 0;
    m_vendorIDs.clear();
}


/**
 * @brief Product::runDiscountProgram
 */
xpError_t Product::runDiscountProgram( const double _discountPrice, const time_t _startTime, const time_t _endTime )
{
    if( isInDiscountProgram() )
    {
        LOG_MSG( "[ERR:%d] %s:%d: There is already a discount program running\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    time_t currTime = time( NULL );
    if( (_discountPrice >= m_unitPrice) || (_startTime > _endTime) || (currTime >= _endTime) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid discount program info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    m_discountPrice = _discountPrice;
    m_discountStartTime = _startTime;
    m_discountEndTime = _endTime;

    return xpSuccess;
}

/**
 * @brief Product::getDiscountInfo
 */
void Product::getDiscountInfo(double *_discountPrice, time_t *_startTime, time_t *_endTime)
{
    if( _discountPrice )
    {
        *_discountPrice = m_discountPrice;
    }

    if( _startTime )
    {
        *_startTime = m_discountStartTime;
    }

    if( _endTime )
    {
        *_endTime = m_discountEndTime;
    }
}


/**
 * @brief Product::cancelDiscountProgram
 */
void Product::cancelDiscountProgram()
{
    m_discountPrice = 0.0;
    m_discountStartTime = m_discountEndTime = 0;
}


/**
 * @brief Product::isInDiscountProgram
 */
bool Product::isInDiscountProgram()
{
    time_t currTime = time( NULL );
    if( (m_discountPrice >= m_unitPrice) || (currTime > m_discountEndTime) || (m_discountStartTime > m_discountEndTime) )
        return false;
    return true;
}


/**
 * @brief Product::addToStock
 */
xpError_t Product::addToStock(const int _quantity)
{
    if( _quantity < 0 )
        return xpErrorInvalidValues;
    m_quantityInstock += _quantity;
    return xpSuccess;
}


/**
 * @brief Product::removeFromStock
 */
xpError_t Product::removeFromStock(const int _quantity)
{
    if( _quantity < 0 || (m_quantityInstock < _quantity) )
        return xpErrorInvalidValues;
    m_quantityInstock -= _quantity;
    return xpSuccess;
}


/**
 * @brief Product::sell
 */
xpError_t Product::sell(const int _quantity)
{
    if( _quantity > m_quantityInstock )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Quantity sold is larger than quantity in stock\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }
    m_quantityInstock -= _quantity;
    m_quantitySold += _quantity;

    return xpSuccess;
}

}
