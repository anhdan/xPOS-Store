#include "InventoryDatabase.h"

namespace xpos_store
{


/**
 * @brief InventoryDatabase::InventoryDatabase
 */
InventoryDatabase::InventoryDatabase(const InventoryDatabase &_db) : Database(_db)
{
}


/**
 * @brief InventoryDatabase::create
 */
xpError_t InventoryDatabase::create(const std::string &_dbPath)
{
    if( m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database is being opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    char *sqliteMsg = nullptr;
    int sqliteErr = 0;

    // Check the existance
    if( access(_dbPath.c_str(), F_OK) != -1 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database file is not exist\n",
                 xpErrorNotExist, __FILE__, __LINE__ );
        return xpErrorNotExist;
    }
    m_dbPath = _dbPath;

    // Try to open database
    sqliteErr = sqlite3_open( _dbPath.c_str(), &m_dbPtr );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to open database file by given path\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        m_dbPath = "";
        m_isOpen = false;
        return xpErrorProcessFailure;
    }
    m_isOpen = true;


    // Create Table
    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS PRODUCT (\n" \
                            "   BARCODE             TEXT        PRIMARY KEY,\n" \
                            "   NAME                TEXT        NOT NULL,\n" \
                            "   DESC                TEXT        NOT NULL,\n" \
                            "   UNIT                TEXT        NOT NULL,\n" \
                            "   UNIT_PRICE          REAL        NOT NULL,\n" \
                            "   DISCOUNT_PRICE      REAL        NOT NULL,\n" \
                            "   DISCOUNT_START      INTEGER     NOT NULL,\n" \
                            "   DISCOUNT_END        INTEGER     NOT NULL,\n" \
                            "   NUM_INSTOCK         INTEGER     NOT NULL,\n" \
                            "   NUM_SOLD            INTEGER     NOT NULL,\n" \
                            "   NUM_DISQUALIFIED    INTEGER     NOT NULL) WITHOUT ROWID;";
    sqliteErr =sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to excute SQLite command\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        close();
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }
    else {
        LOG_MSG( "Created PRODUCT table successfully\n" );
    }


    return xpSuccess;
}


/**
 * @brief InventoryDatabase::searchProductByBarcode
 */
xpError_t InventoryDatabase::searchProductByBarcode(const std::string &_barcode, Product &_product)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "SELECT * from PRODUCT where BARCODE='" + _barcode + "';";
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), Product::searchCallBack, (void*)&_product, &sqliteMsg );   
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _product.setDefault();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief InventoryDatabase::insertProduct
 */
xpError_t InventoryDatabase::insertProduct(Product &_product)
{
    if( _product.getBarcode() == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid product info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string cmdFormat = "INSERT INTO PRODUCT (BARCODE, NAME, DESC, UNIT, UNIT_PRICE, DISCOUNT_PRICE, DISCOUNT_START, DISCOUNT_END, NUM_INSTOCK, NUM_SOLD, NUM_DISQUALIFIED) " \
                            "VALUES('%s', '%s', '%s', '%s', %f, %f, %ld, %ld, %d, %d, %d);";
    char sqliteCmd[1000];
    double discountPrice = 0;
    time_t discountStart = 0,
           discountEnd = 0;
    _product.getDiscountInfo( &discountPrice, &discountStart, &discountEnd );
    sprintf( sqliteCmd, cmdFormat.c_str(),
             _product.getBarcode().c_str(), _product.getName().c_str(), _product.getDescription().c_str(),
             _product.getUnit().c_str(), _product.getUnitPrice(),
             discountPrice, (uint32_t)discountStart, (uint32_t)discountEnd,
             _product.getNumInstock(), _product.getNumSold(), _product.getNumDisqualified() );
    printf( "====> insert product cmd: %s\n", sqliteCmd );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, nullptr, nullptr, &sqliteMsg );
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
 * @brief InventoryDatabase::deleteProductByBarcode
 */
xpError_t InventoryDatabase::deleteProductByBarcode(const std::string &_barcode)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "DELETE from PRODUCT where BARCODE='" + _barcode + "';";
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
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
 * @brief InventoryDatabase::updateProduct
 */
xpError_t InventoryDatabase::updateProduct( Product &_productInfo , bool _isQuantityOnly )
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }
    std::string sqliteCmdFormat;
    char sqliteCmd[2000];
    if( _isQuantityOnly )
    {
        sqliteCmdFormat =   "UPDATE PRODUCT\n" \
                            "SET    NUM_INSTOCK     = %d,\n" \
                            "       NUM_SOLD        = %d,\n" \
                            "       NUM_DISQUALIFIED= %d\n" \
                            "WHERE\n" \
                            "       BARCODE = '%s';";
        sprintf( sqliteCmd, sqliteCmdFormat.c_str(),
                 _productInfo.getNumInstock(), _productInfo.getNumSold(),
                 _productInfo.getNumDisqualified(), _productInfo.getBarcode().c_str() );
    }
    else
    {
        sqliteCmdFormat =   "UPDATE PRODUCT\n" \
                            "SET    NAME            = '%s',\n" \
                            "       DESC            = '%s',\n" \
                            "       UNIT            = '%s',\n" \
                            "       UNIT_PRICE      = %f,\n" \
                            "       DISCOUNT_PRICE  = %f,\n" \
                            "       DISCOUNT_START  = %ld,\n" \
                            "       DISCOUNT_END    = %ld,\n" \
                            "       NUM_INSTOCK     = %d,\n" \
                            "       NUM_SOLD        = %d,\n" \
                            "       NUM_DISQUALIFIED= %d\n" \
                            "WHERE\n" \
                            "       BARCODE = '%s';";
        double discountPrice = 0.0;
        time_t discountStart = 0,
               discountEnd   = 0;
        _productInfo.getDiscountInfo( &discountPrice, &discountStart, &discountEnd );
        sprintf( sqliteCmd, sqliteCmdFormat.c_str(),
                 _productInfo.getName().c_str(), _productInfo.getDescription().c_str(),
                 _productInfo.getUnit().c_str(), _productInfo.getUnitPrice(),
                 discountPrice, (uint64_t)discountStart, (uint64_t)discountEnd,
                 _productInfo.getNumInstock(), _productInfo.getNumSold(),
                 _productInfo.getNumDisqualified(), _productInfo.getBarcode().c_str() );
    }
    printf( "====> update product cmd: \n\t%s\n\n", sqliteCmd );

    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, nullptr, nullptr, &sqliteMsg );
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
