#include "SellingRecord.h"

namespace xpos_store {

/**
 * @brief SellingRecord::setDefault
 */
void SellingRecord::setDefault()
{
    m_billId = "";
    m_productBarcode = "";
    m_quantity = 0;
    m_totalPrice = 0;
}

/**
 * @brief SellingRecord::copyTo
 */
void SellingRecord::copyTo( Item *_item )
{
    if( _item )
    {
        SellingRecord* record = (SellingRecord*)_item;
        record->m_billId = m_billId;
        record->m_productBarcode = m_productBarcode;
        record->m_quantity = m_quantity;
        record->m_totalPrice = m_totalPrice;
    }
}

/**
 * @brief SellingRecord::printInfo
 */
void SellingRecord::printInfo()
{
    LOG_MSG( "\n---------Customer---------\n" );
    LOG_MSG( ". BILL ID:                %s\n", m_billId );
    LOG_MSG( ". PRODUCT BARCOE:         %s\n", m_productBarcode.c_str() );
    LOG_MSG( ". QUANTITY:               %d\n", m_quantity );
    LOG_MSG( ". TOTAL PRICE:            %f\n", m_totalPrice );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief SellingRecord::toQVariant
 */
QVariant SellingRecord::toQVariant( )
{

}


/**
 * @brief SellingRecord::fromQVariant
 */
xpError_t SellingRecord::fromQVariant( const QVariant &_item )
{
    return xpSuccess;
}


/**
 * @brief SellingRecord::setBillId
 */
void SellingRecord::setBillId( const std::string &_billId )
{
    m_billId = _billId;
}


/**
 * @brief SellingRecord::getBillId
 */
std::string SellingRecord::getBillId()
{
    return m_billId;
}


/**
 * @brief SellingRecord::setProductBarcode
 */
void SellingRecord::setProductBarcode( const std::string &_barcode )
{
    m_productBarcode = _barcode;
}

/**
 * @brief SellingRecord::getProductBarcode
 */
std::string SellingRecord::getProductBarcode()
{
    return m_productBarcode;
}


/**
 * @brief SellingRecord::setQuantity
 */
void SellingRecord::setQuantity( const int _quantity )
{
    m_quantity = _quantity;
}


/**
 * @brief SellingRecord::getQuantity
 */
int SellingRecord::getQuantity()
{
    return m_quantity;
}


/**
 * @brief SellingRecord::setTotalPrice
 */
void SellingRecord::setTotalPrice( const double _totalPrice )
{
    m_totalPrice = _totalPrice;
}


/**
 * @brief SellingRecord::getTotalPrice
 */
double SellingRecord::getTotalPrice()
{
    return m_totalPrice;
}


}
