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
    m_category = XP_PRODUCT_CATEGORY_NONE;
    m_description ="";
    m_unit = XP_PRODUCT_UNIT_NONE;

    m_unitPrice = 0.0;
    m_discountPrice = 0.0;
    m_discountStartTime = 0;
    m_discountEndTime = 0;

    m_quantityInstock = 0;
    m_quantitySold = 0;
    m_vendorIDs.clear();
}


/**
 * @brief Product::copyTo
 */
void Product::copyTo(Product &_product)
{
    _product.m_code = m_code;
    _product.m_name = m_name;
    _product.m_category = m_category;
    _product.m_description = m_description;
    _product.m_unit = m_unit;

    _product.m_unitPrice = m_unitPrice;
    _product.m_discountPrice = m_discountPrice;
    _product.m_discountStartTime = m_discountStartTime;
    _product.m_discountEndTime = m_discountEndTime;

    _product.m_quantityInstock = m_quantityInstock;
    _product.m_quantitySold = m_quantitySold;
    _product.m_vendorIDs = m_vendorIDs;
}


/**
 * @brief Product::printInfo
 */
void Product::printInfo()
{
    LOG_MSG( "\n---------Product---------\n" );
    LOG_MSG( ". CODE:           %s\n", m_code.c_str() );
    LOG_MSG( ". NAME:           %s\n", m_name.c_str() );
    LOG_MSG( ". CATEGORY:       %d\n", m_category );
    LOG_MSG( ". DESCRIPTION:    %s\n", m_description.c_str() );
    LOG_MSG( ". UNIT:           %d\n", m_unit );
    LOG_MSG( ". UNIT PRICE:     %f\n", m_unitPrice );
    LOG_MSG( ". DISCOUNT PRICE: %f\n", m_discountPrice );
    LOG_MSG( ". DISCOUNT START: %d\n", m_discountStartTime );
    LOG_MSG( ". DISCOUNT END:   %d\n", m_discountEndTime );
    LOG_MSG( ". # INSTOCK:      %d\n", m_quantityInstock );
    LOG_MSG( ". # SOLD:         %d\n", m_quantitySold );
    LOG_MSG( "-------------------------\n" );
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


//TODO: Implement methods to connect, write to and read record from database
//
//===== Database interface
//

/**
 * @brief Product::searchCallBack
 */
xpError_t Product::searchCallBack(void *data, int fieldsNum, char **fieldName, char **fieldVal)
{
    Product* product = (Product*)data;
    std::string vendorIDsStr("");
    for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
    {
        if( !strcmp(fieldName[fieldId], "CODE") )
        {
            product->m_code = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "NAME") )
        {
            product->m_name = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "CATEGORY") )
        {
            product->m_category = fieldVal[fieldId] ? atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "DESCRIPTION") )
        {
            product->m_description = fieldVal[fieldId];
        }
        else if( !strcmp(fieldName[fieldId], "UNIT_NAME") )
        {
            product->m_unit = fieldVal[fieldId] ? atoi( fieldVal[fieldId] ) : 0;
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
            product->m_discountStartTime = fieldVal[fieldId] ? (time_t)atol( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "DISCOUNT_END") )
        {
            product->m_discountEndTime = fieldVal[fieldId] ? (time_t)atol( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "QUANTITY_INSTOCK") )
        {
            product->m_quantityInstock = fieldVal[fieldId] ? (uint32_t)atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "QUANTITY_SOLD") )
        {
            product->m_quantitySold = fieldVal[fieldId] ? (uint32_t)atoi( fieldVal[fieldId] ) : 0;
        }
        else if( !strcmp(fieldName[fieldId], "VENDOR_IDS") )
        {
            vendorIDsStr = std::string( fieldVal[fieldId] );
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
            product->setDefault();
            return xpErrorProcessFailure;
        }
    }

    if( vendorIDsStr != "" )
    {
        product->m_vendorIDs.clear();
        std::stringstream ss( vendorIDsStr );
        while( ss.good() )
        {
            std::string subStr;
            std::getline( ss, subStr, ',' );
            uint64_t vendorId = 0;
            try
            {
                vendorId = std::stoi( subStr );
                product->m_vendorIDs.push_back( (uint64_t)vendorId );
            }
            catch( std::exception &e )
            {
                LOG_MSG( "[ERR:%d] %s:%d:%s: An invalid vendor IDs is encountered\n",
                         xpErrorProcessFailure, __FILE__, __LINE__, e.what() );
                return xpErrorProcessFailure;
            }
        }
    }

    return xpSuccess;
}


/**
 * @brief Product::searchInDatabase
 */
Product* Product::searchInDatabase(const Table *_productTable, const std::string &_productCode)
{
    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return nullptr;
    }

    // Execute SQLITE command to search for record
    Product product;
    std::string sqliteCmd = "SELECT * from " + _productTable->name + " where CODE='" + _productCode + "';";
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd.c_str(), searchCallBack, (void*)&product, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return nullptr;
    }

    if( product.getCode() == "" )
    {
        LOG_MSG( "[WAR] The searched entry does not exist in the given database\n" );
        return nullptr;
    }

    return &product;
}


/**
 * @brief Product::insertToDatabase
 */
xpError_t Product::insertToDatabase(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    std::cout << "===========> 1.1 " << m_vendorIDs.size() << std::endl;

    std::string vendorIdsStr ="";
    int id = 0;
    while( id < ((int)m_vendorIDs.size()-1))
    {
        vendorIdsStr = vendorIdsStr + std::to_string(m_vendorIDs[id]) + ",";
        id++;
    }
    if( m_vendorIDs.size() > 0 )
    {
        vendorIdsStr = vendorIdsStr + std::to_string(m_vendorIDs[m_vendorIDs.size()-1]);
    }

    std::cout << "===========> 1.2  " << _productTable->name;

    char sqliteCmd[1000];
    std::cout <<  FMT_PRODUCT_INSERT << std::endl;
    sprintf( sqliteCmd, FMT_PRODUCT_INSERT,
             _productTable->name.c_str(), m_code.c_str(), m_name.c_str(), std::to_string( (double)m_category ), m_description.c_str(), std::to_string( (double)m_unit), m_unitPrice,
             m_discountPrice, m_discountStartTime, m_discountEndTime, m_quantityInstock, m_quantitySold, vendorIdsStr.c_str() );

    std::cout << "===========> 1.3" << std::string( sqliteCmd ) << std::endl;

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    std::cout << "===========> 1.4\n";

//    free( sqliteCmd );
    std::cout << "===========> 1.5\n";
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }
    std::cout << "===========> 1.6\n";

    return xpSuccess;
}

/**
 * @brief Product::deleteFromDatabase
 */
xpError_t Product::deleteFromDatabase(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    char *sqliteCmd;
    sprintf( sqliteCmd, FMT_PRODUCT_DELETE,
             _productTable->name, m_code.c_str() );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    free( sqliteCmd );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief Product::updateBasicInfoInDB
 */
xpError_t Product::updateBasicInfoInDB(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    char *sqliteCmd;
    sprintf( sqliteCmd, FMT_PRODUCT_UPDATE_BASIC,
             _productTable->name, m_name.c_str(), std::to_string((int)m_category), m_description.c_str(), std::to_string((int)m_unit), m_code.c_str()  );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    free( sqliteCmd );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}



/**
 * @brief Product::updatePriceInDB
 */
xpError_t Product::updatePriceInDB(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    char *sqliteCmd;
    sprintf( sqliteCmd, FMT_PRODUCT_UPDATE_PRICE,
             _productTable->name, std::to_string(m_unitPrice), std::to_string(m_discountPrice), std::to_string(m_discountStartTime), std::to_string(m_discountEndTime), m_code.c_str()  );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    free( sqliteCmd );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief Product::updateQuantityInDB
 */
xpError_t Product::updateQuantityInDB(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    char *sqliteCmd;
    sprintf( sqliteCmd, FMT_PRODUCT_UPDATE_QUANTITY,
             _productTable->name, std::to_string(m_quantityInstock), std::to_string(m_quantitySold), m_code.c_str()  );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    free( sqliteCmd );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief Product::updateVendorsInDB
 */
xpError_t Product::updateVendorsInDB(const Table *_productTable)
{
    if( m_code == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if(_productTable == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null database table\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    std::string vendorIdsStr ="";
    for(int id = 0; id < m_vendorIDs.size()-1; id++ )
    {
        vendorIdsStr = vendorIdsStr + std::to_string(m_vendorIDs[id]) + ",";
    }
    if( m_vendorIDs.size() > 0 )
    {
        vendorIdsStr = vendorIdsStr + std::to_string(m_vendorIDs[m_vendorIDs.size()-1]);
    }

    char *sqliteCmd;
    sprintf( sqliteCmd, FMT_PRODUCT_UPDATE_VENDORS,
             _productTable->name, vendorIdsStr.c_str(), m_code.c_str()  );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( _productTable->db, sqliteCmd, nullptr, nullptr, &sqliteMsg );
    free( sqliteCmd );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}

}
