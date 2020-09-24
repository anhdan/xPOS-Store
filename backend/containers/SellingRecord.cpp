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
    m_creationTime = 0;
    m_quantity = 0;
    m_totalProfit = 0;
    m_totalPrice = 0;
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
        record->m_creationTime = m_creationTime;
        record->m_quantity = m_quantity;
        record->m_totalProfit = m_totalProfit;
        record->m_totalPrice = m_totalPrice;
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
    LOG_MSG( ". CREATION TIME:          %ld\n", m_creationTime );
    LOG_MSG( ". QUANTITY:               %d\n", m_quantity );
    LOG_MSG( ". TOTAL PROFIT:           %f\n", m_totalProfit );
    LOG_MSG( ". TOTAL PRICE:            %f\n", m_totalPrice );
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
    map["desc"] = QString::fromStdString( m_desc );
    map["creation_time"] = (uint)m_creationTime;
    map["quantity"] = m_quantity;
    map["total_price"] = m_totalPrice;
    map["discount_percent"] = m_discountPercent;
    map["total_profit"] = m_totalProfit;

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
        m_creationTime = (time_t)map["creation_time"].toUInt(&ret);
        finalRet &= ret;
        m_quantity = map["quantity"].toInt( &ret );
        finalRet &= ret;
        m_totalProfit = map["total_profit"].toDouble( &ret );
        finalRet &= ret;
        m_totalPrice = map["total_price"].toDouble( &ret );
        finalRet &= ret;
        m_discountPercent = map["discount_percent"].toDouble( &ret );
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
 * @brief SellingRecord::setCreationTime
 */
void SellingRecord::setCreationTime(const time_t _creationTime)
{
    m_creationTime = _creationTime;
}


/**
 * @brief SellingRecord::getCreationTime
 */
time_t SellingRecord::getCreationTime()
{
    return m_creationTime;
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
 * @brief SellingRecord::setTotalProfit
 */
void SellingRecord::setTotalProfit(const double _profit)
{
    m_totalProfit = _profit;
}


/**
 * @brief SellingRecord::getTotalProfit
 */
double SellingRecord::getTotalProfit()
{
    return m_totalProfit;
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
 * @brief SellingRecord::fromProduct
 */
SellingRecord SellingRecord::fromProduct(Product &_product)
{
    SellingRecord record;
    record.setProductBarcode( _product.getBarcode() );
    record.setDescription( _product.getName() );
    record.setQuantity( _product.getItemNum() );
    record.setTotalPrice( _product.getItemNum() * _product.getSellingPrice() );
    record.setTotalProfit( _product.getItemNum() * (_product.getSellingPrice() - _product.getInputPrice()) );
    record.setDiscountPercent( (_product.getUnitPrice() - _product.getSellingPrice()) / _product.getUnitPrice() );

    return record;
}


/**
 * @brief SellingRecord::searchCallBack
 */
xpError_t SellingRecord::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    if( data )
    {
        std::vector<SellingRecord> *records = (std::vector<SellingRecord>*)data;
        SellingRecord record;
        for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
        {
            if( !strcmp(fieldName[fieldId], "BILL_ID") )
            {
                record.m_billId = fieldVal[fieldId] ? fieldVal[fieldId] : "";
            }
            else if( !strcmp(fieldName[fieldId], "PRODUCT_BARCODE") )
            {
                record.m_productBarcode = fieldVal[fieldId] ? fieldVal[fieldId] : "";
            }
            if( !strcmp(fieldName[fieldId], "DESCRIPTION") )
            {
                record.m_desc = fieldVal[fieldId] ? fieldVal[fieldId] : "";
            }
            else if( !strcmp(fieldName[fieldId], "CREATION_TIME") )
            {
                record.m_creationTime = fieldVal[fieldId] ? (time_t)atol(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "QUANTITY") )
            {
                record.m_quantity = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_PROFIT") )
            {
                record.m_totalProfit = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_PRICE") )
            {
                record.m_totalPrice = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "DISCOUNT_PERCENT") )
            {
                record.m_discountPercent = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else
            {
                LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
                record.setDefault();
                return xpErrorProcessFailure;
            }
        }
        records->push_back( record );
    }

    return xpSuccess;
}


/**
 * @brief SellingRecord::searchCallBackGroup
 */
xpError_t SellingRecord::searchCallBackGroup(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    if( data )
    {
        std::vector<SellingRecord> *records = (std::vector<SellingRecord>*)data;
        SellingRecord record;
        for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
        {
            if( !strcmp(fieldName[fieldId], "PRODUCT_BARCODE") )
            {
                record.m_productBarcode = fieldVal[fieldId] ? fieldVal[fieldId] : "";
            }
            else if( !strcmp(fieldName[fieldId], "SUM(QUANTITY)") )
            {
                record.m_quantity = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "SUM(TOTAL_PRICE)") )
            {
                record.m_totalPrice = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "SUM(TOTAL_PROFIT)") )
            {
                record.m_totalProfit = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else
            {
                LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
                record.setDefault();
                return xpErrorProcessFailure;
            }
        }
        record.m_billId = "grouped";
        record.m_desc = "";
        record.m_creationTime = time( NULL );
        record.m_discountPercent = 0;

        records->push_back( record );
    }

    return xpSuccess;
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
                        m_totalPrice/m_quantity, m_discountPercent, m_quantity );
    return QString::fromStdString( std::string(cJSONStr) );
}


}
