#include "Product.h"

namespace xpos_store {


/**
 * @brief Product::setDefault
 */
void Product::setDefault()
{
    m_barcode = "";
    m_name = "";
    m_description = "";
    m_unit = "";

    m_unitPrice = m_discountPrice = 0.0;
    m_discountStart = m_discountEnd = 0;

    m_numInstock = m_numSold = m_numDisqualified = 0;
}


/**
 * @brief Product::copyTo
 */
void Product::copyTo(Item *_item)
{
    if( _item )
    {
        Product* _prod = (Product*)_item;
        _prod->m_barcode = m_barcode;
        _prod->m_name = m_name;
        _prod->m_description = m_description;
        _prod->m_unit = m_unit;
        _prod->m_unitPrice = m_unitPrice;
        _prod->m_discountPrice = m_discountPrice;
        _prod->m_discountStart = m_discountStart;
        _prod->m_discountEnd = m_discountEnd;
        _prod->m_numInstock = m_numInstock;
        _prod->m_numSold = m_numSold;
        _prod->m_numDisqualified = m_numDisqualified;
    }
}


/**
 * @brief Product::printInfo
 */
void Product::printInfo()
{
    LOG_MSG( "\n---------Product---------\n" );
    LOG_MSG( ". CODE:           %s\n", m_barcode.c_str() );
    LOG_MSG( ". NAME:           %s\n", m_name.c_str() );
    LOG_MSG( ". DESCRIPTION:    %s\n", m_description.c_str() );
    LOG_MSG( ". UNIT:           %s\n", m_unit.c_str() );
    LOG_MSG( ". UNIT PRICE:     %f\n", m_unitPrice );
    LOG_MSG( ". DISCOUNT PRICE: %f\n", m_discountPrice );
    LOG_MSG( ". DISCOUNT START: %d\n", m_discountStart );
    LOG_MSG( ". DISCOUNT END:   %d\n", m_discountEnd );
    LOG_MSG( ". # INSTOCK:      %d\n", m_numInstock );
    LOG_MSG( ". # SOLD:         %d\n", m_numSold );
    LOG_MSG( ". # DISQUALIFIED: %d\n", m_numDisqualified );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Product::toQVariant
 */
QVariant Product::toQVariant( )
{
    QVariantMap map;
    map["barcode"] = QString::fromStdString( getBarcode() );
    map["name"] = QString::fromStdString( getName() );
    map["desc"] = QString::fromStdString( getDescription() );
    map["unit"] = QString::fromStdString( getUnit() );
    map["unit_price"] = getUnitPrice();
    map["discount_price"] = m_discountPrice;

    QDateTime qTime;
    qTime.setTime_t( (uint)m_discountStart );
    map["discount_start"] = qTime.toString( "dd/MM/yyyy" );
    qTime.setTime_t( (uint)m_discountEnd );
    map["discount_end"] = qTime.toString( "dd/MM/yyyy" );

    map["num_instock"]    = getNumInstock();
    map["num_sold"]       = getNumSold();
    map["num_disqualified"] = getNumDisqualified();

    return QVariant( map );
}


/**
 * @brief Product::fromQVariant
 */
xpError_t Product::fromQVariant( const QVariant &_item )
{
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        m_barcode = map["barcode"].toString().toStdString();
        m_name = map["name"].toString().toStdString();
        m_description = map["desc"].toString().toStdString();
        m_unit = map["unit"].toString().toStdString();               
        m_unitPrice = map["unit_price"].toDouble(&ret);
        finalRet &= ret;

        m_discountPrice = map["discount_price"].toDouble(&ret);
        finalRet &= ret;
        m_discountStart = (time_t)QDateTime::fromString( map["discount_start"].toString(), "dd/MM/yyyy" ).toTime_t();
        m_discountEnd = (time_t)QDateTime::fromString( map["discount_end"].toString(), "dd/MM/yyyy" ).toTime_t();

        m_numInstock = map["num_instock"].toInt( &ret );
        finalRet &= ret;
        m_numSold = map["num_sold"].toInt( &ret );
        finalRet &= ret;
        m_numDisqualified = map["num_disqualified"].toInt( &ret );
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
 * @brief Product::isValid
 */
bool Product::isValid()
{
    return (m_barcode != "");
}


/**
 * @brief Product::isIdenticalTo
 */
bool Product::isIdenticalTo(const Product &_product)
{
    bool ret = true;
    ret &= (m_barcode == _product.m_barcode);
    ret &= (m_name == _product.m_name);
    ret &= (m_description == _product.m_description);
    ret &= (m_unit == _product.m_unit);
    ret &= (m_unitPrice == _product.m_unitPrice);
    ret &= (m_discountPrice == _product.m_discountPrice);
    ret &= (m_discountStart == _product.m_discountStart);
    ret &= (m_discountEnd == _product.m_discountEnd);
    ret &= (m_numInstock == _product.m_numInstock);
    ret &= (m_numSold = _product.m_numSold);
    ret &= (m_numDisqualified == _product.m_numDisqualified);
}


/**
 * @brief Product::searchCallBack
 */
xpError_t Product::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    Product* product = (Product*)data;
    for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
    {
        if( !strcmp(fieldName[fieldId], "BARCODE") )
        {
            product->m_barcode = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "NAME") )
        {
            product->m_name = fieldVal[fieldId] ? fieldVal[fieldId] : "Không có thông tin";
        }
        else if( !strcmp(fieldName[fieldId], "DESC") )
        {
            product->m_description = fieldVal[fieldId] ? fieldVal[fieldId] : "Không có thông tin";
        }
        else if( !strcmp(fieldName[fieldId], "UNIT") )
        {
            product->m_unit = fieldVal[fieldId] ? fieldVal[fieldId] : "Không có thông tin";
        }
        else if( !strcmp(fieldName[fieldId], "UNIT_PRICE") )
        {
            product->m_unitPrice = fieldVal[fieldId] ? atof( fieldVal[fieldId] ) : 0.0;     
        }
        else if( !strcmp(fieldName[fieldId], "DISCOUNT_PRICE") )
        {
            product->m_discountPrice = fieldVal[fieldId] ? atof( fieldVal[fieldId] ) : 0.0;
        }
        else if( !strcmp(fieldName[fieldId], "DISCOUNT_START") )
        {
            product->m_discountStart = fieldVal[fieldId] ? (time_t)atol( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "DISCOUNT_END") )
        {
            product->m_discountEnd = fieldVal[fieldId] ? (time_t)atol( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "NUM_INSTOCK") )
        {
            product->m_numInstock = fieldVal[fieldId] ? (uint32_t)atoi( fieldVal[fieldId] ) : 0;            
        }
        else if( !strcmp(fieldName[fieldId], "NUM_SOLD") )
        {
            product->m_numSold = fieldVal[fieldId] ? (uint32_t)atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "NUM_DISQUALIFIED") )
        {
            product->m_numDisqualified = fieldVal[fieldId] ? (uint32_t)atoi( fieldVal[fieldId] ) : 0;
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
            product->setDefault();
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
 * @brief Product::setBarcode
 */
void Product::setBarcode(const std::string &_barcode)
{
    m_barcode = _barcode;
}


/**
 * @brief Product::getBarcode
 */
std::string Product::getBarcode()
{
    return m_barcode;
}


/**
 * @brief Product::setName
 */
void Product::setName(const std::string &_name)
{
    m_name = _name;
}


/**
 * @brief Product::getName
 */
std::string Product::getName()
{
    return m_name;
}


/**
 * @brief Product::setDescription
 */
void Product::setDescription(const std::string &_des)
{
    m_description = _des;
}



/**
 * @brief Product::getDescription
 */
std::string Product::getDescription()
{
    return m_description;
}


/**
 * @brief Product::setUnit
 */
void Product::setUnit(const std::string &_unit)
{
    m_unit = _unit;
}


/**
 * @brief Product::getUnit
 */
std::string Product::getUnit()
{
    return m_unit;
}


/**
 * @brief Product::setUnitPrice
 */
void Product::setUnitPrice(const double _price)
{
    m_unitPrice = _price;
}


/**
 * @brief Product::getUnitPrice
 */
double Product::getUnitPrice()
{
    return m_unitPrice;
}


/**
 * @brief Product::runDiscount
 */
xpError_t Product::runDiscount(const double _discountPrice, const time_t _start, const time_t _end)
{
    time_t currTime = time( NULL );
    if( (_discountPrice >= m_unitPrice) || (_start > _end) || (currTime >= _end) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid discount program info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    m_discountPrice = _discountPrice;
    m_discountStart = _start;
    m_discountEnd = _end;
    return xpSuccess;
}


/**
 * @brief Product::getDiscountInfo
 */
void Product::getDiscountInfo( double *_discountPrice, time_t *_start, time_t *_end)
{
    if( _discountPrice )
    {
        *_discountPrice = m_discountPrice;
    }

    if( _start )
    {
        *_start = m_discountStart;
    }

    if( _end )
    {
        *_end = m_discountEnd;
    }
}


/**
 * @brief Product::cancelDiscount
 */
void Product::cancelDiscount()
{
    m_discountPrice = 0.0;
    m_discountStart = 0;
    m_discountEnd = 0;
}


/**
 * @brief Product::setNumInstock
 */
void Product::setNumInstock(const uint32_t _numInstock)
{
    m_numInstock = _numInstock;
}


/**
 * @brief Product::getNumInstock
 */
uint32_t Product::getNumInstock()
{
    return m_numInstock;
}


/**
 * @brief Product::addToStock
 */
xpError_t Product::addToStock(const uint32_t _add)
{
    if( _add > 10000 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameter value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_numInstock += _add;
    return xpSuccess;
}

/**
 * @brief Product::removeFromStock
 */
xpError_t Product::disqualifyFromStock(const uint32_t _sub)
{
    if( _sub > m_numInstock )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameter value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_numInstock -= _sub;
    m_numDisqualified += _sub;
    return xpSuccess;
}


/**
 * @brief Product::getNumDisqualified
 */
uint32_t Product::getNumDisqualified()
{
    return m_numDisqualified;
}


/**
 * @brief Product::sellFromStock
 */
xpError_t Product::sellFromStock(const uint32_t _sub)
{
    if( _sub > m_numInstock )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameter value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_numInstock -= _sub;
    m_numSold += _sub;
    return xpSuccess;
}

/**
 * @brief Product::getNumSold
 */
uint32_t Product::getNumSold()
{
    return m_numSold;
}


}
