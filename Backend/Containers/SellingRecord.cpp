#include "SellingRecord.h"


namespace xpos_store
{

/**
 * @brief SellingRecord::setProduct
 */
void SellingRecord::setProduct(const std::string _productCode, const uint32_t _quantity, const double _totalPrice)
{
    m_productCode = _productCode;
    m_quantity = _quantity;
    m_totalPrice = _totalPrice;
}


/**
 * @brief SellingRecord::getProduct
 */
void SellingRecord::getProduct(std::string *_productCode, uint32_t *_quantity, double *_totalPrice)
{
    if( _productCode )
    {
        *_productCode = m_productCode;
    }

    if( _quantity )
    {
        *_quantity = m_quantity;
    }

    if( _totalPrice )
    {
        *_totalPrice = m_totalPrice;
    }
}

}
