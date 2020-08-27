#include "SellingRecord.h"

namespace xpos_store {

/**
 * @brief SellingRecord::setDefault
 */
void SellingRecord::setDefault()
{
    m_billId = "";
    m_productBarcode = "";
    m_desc = "";
    m_quantity = 0;
    m_sellingPrice = 0;
    m_discountPercent = 0;
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
        record->m_desc = m_desc;
        record->m_quantity = m_quantity;
        record->m_sellingPrice = m_sellingPrice;
        record->m_discountPercent = m_discountPercent;
    }
}

/**
 * @brief SellingRecord::printInfo
 */
void SellingRecord::printInfo()
{
    LOG_MSG( "\n---------SellingRecord---------\n" );
    LOG_MSG( ". BILL ID:                %s\n", m_billId.c_str() );
    LOG_MSG( ". PRODUCT BARCOE:         %s\n", m_productBarcode.c_str() );
    LOG_MSG( ". DESCRIPTION:            %s\n", m_desc.c_str() );
    LOG_MSG( ". QUANTITY:               %d\n", m_quantity );
    LOG_MSG( ". TOTAL PRICE:            %f\n", m_sellingPrice );
    LOG_MSG( ". DISCOUNT PERCENT:       %f\n", m_discountPercent );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief SellingRecord::toQVariant
 */
QVariant SellingRecord::toQVariant( )
{
    QVariantMap map;
    map["bill_id"] = QString::fromStdString(m_billId);
    map["product_barcode"] = QString::fromStdString(m_productBarcode);
    map["quantity"] = m_quantity;
    map["selling_price"] = m_sellingPrice;

    return QVariant::fromValue( map );
}


/**
 * @brief SellingRecord::fromQVariant
 */
xpError_t SellingRecord::fromQVariant( const QVariant &_item )
{
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        m_billId = map["bill_id"].toString().toStdString();
        m_productBarcode = map["product_barcode"].toString().toStdString();
        m_quantity = map["quantity"].toInt( &ret );
        finalRet &= ret;
        m_sellingPrice = map["selling_price"].toDouble( &ret );
        finalRet &= ret;
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
 * @brief SellingRecord::isValid
 */
bool SellingRecord::isValid()
{
    return ((m_billId != "") && (m_productBarcode != ""));
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
 * @brief SellingRecord::setDescription
 */
void SellingRecord::setDescription(const std::string &_desc)
{
    m_desc = _desc;
}


/**
 * @brief SellingRecord::getDescription
 */
std::string SellingRecord::getDescription()
{
    return m_desc;
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
 * @brief SellingRecord::setSellingPrice
 */
void SellingRecord::setSellingPrice( const double _sellingPrice )
{
    m_sellingPrice = _sellingPrice;
}


/**
 * @brief SellingRecord::getSellingPrice
 */
double SellingRecord::getSellingPrice()
{
    return m_sellingPrice;
}


/**
 * @brief SellingRecord::setDiscountPercentage
 */
void SellingRecord::setDiscountPercent(const double _discountPercent)
{
    m_discountPercent = _discountPercent;
}


/**
 * @brief SellingRecord::setDiscountPercent
 */
void SellingRecord::setDiscountPercent(const double _unitPrice, const double _sellingPrice)
{
    if( _unitPrice > _sellingPrice )
    {
        m_discountPercent = (_unitPrice - _sellingPrice) / _unitPrice * 100;
    }
    else
    {
        m_discountPercent = 0;
    }
}


/**
 * @brief SellingRecord::getDiscountPercent
 */
double SellingRecord::getDiscountPercent()
{
    return  m_discountPercent;
}


/**
 * @brief SellingRecord::toJSONString
 */
QString SellingRecord::toJSONString()
{
    char cJSONStr[1000];
    sprintf( cJSONStr,  "{\n"\
                        "\"code\": \"%s\",\n" \
                        "\"desc\": \"%s\",\n" \
                        "\"selling_price\": %f,\n"\
                        "\"discount_percent\": %f,\n"\
                        "\"quantity\": %d\n" \
                        "}", m_productBarcode.c_str(), m_desc.c_str(),
                        m_sellingPrice, m_discountPercent, m_quantity );
    return QString::fromStdString( std::string(cJSONStr) );
}


}
