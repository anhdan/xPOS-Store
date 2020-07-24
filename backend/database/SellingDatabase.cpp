#include "SellingDatabase.h"


namespace xpos_store {

/**
 * @brief SellingDatabase::SellingDatabase
 */
SellingDatabase::SellingDatabase(const SellingDatabase &_db) : Database(_db)
{

}


/**
 * @brief SellingDatabase::createBillTable
 */
xpError_t SellingDatabase::createBillTable()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS BILL (\n" \
                            "   CUSTOMER_ID         TEXT        ,\n" \
                            "   STAFF_ID            TEXT        NOT NULL,\n" \
                            "   CREATION_TIME       INTEGER     NOT NULL,\n" \
                            "   TOTAL_CHARGING      REAL        NOT NULL,\n" \
                            "   TOTAL_DISCOUNT      REAL        NOT NULL,\n" \
                            "   CUSTOMER_PAYMENT    REAL        NOT NULL,\n" \
                            "   USED_POINT          INTEGER     NOT NULL,\n" \
                            "   REWARDED_POINT      INTEGER     NOT NULL,\n" \
                            "   PRIMARY KEY(STAFF_ID, CREATION_TIME)\n" \
                            ") WITHOUT ROWID;";
    char* sqliteMsg = nullptr;
    int sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to excute SQLite command\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        close();
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    LOG_MSG( "Created BILL table successfully\n" );
    return xpSuccess;
}


/**
 * @brief SellingDatabase::createSellingRecordTable
 */
xpError_t SellingDatabase::createSellingRecordTable()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS SELLING_RECORD (\n" \
                            "   BILL_ID             TEXT        NOT NULL,\n" \
                            "   PRODUCT_BARCODE     TEXT        NOT NULL,\n" \
                            "   QUANTITY            INTEGER     NOT NULL,\n" \
                            "   TOTAL_PRICE         REAL        NOT NULL,\n" \
                            "   PRIMARY KEY(BILL_ID, PRODUCT_BARCODE)\n" \
                            ") WITHOUT ROWID;";
    char* sqliteMsg = nullptr;
    int sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to excute SQLite command\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        close();
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    LOG_MSG( "Created SELLING_RECORD table successfully\n" );
    return xpSuccess;
}


/**
 * @brief SellingDatabase::createWorkShiftTable
 */
xpError_t SellingDatabase::createWorkShiftTable()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS WORKSHIFT (\n" \
                            "   STAFF_ID            TEXT        NOT NULL,\n" \
                            "   START_TIME          INTEGER     NOT NULL,\n" \
                            "   END_TIME            INTEGER     NOT NULL,\n" \
                            "   TOTAL_EARNING       REAL        NOT NULL,\n" \
                            "   PRIMARY KEY(STAFF_ID, START_TIME)\n" \
                            ") WITHOUT ROWID;";
    char* sqliteMsg = nullptr;
    int sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to excute SQLite command\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        close();
        sqlite3_free( sqliteMsg );
        return xpErrorProcessFailure;
    }

    LOG_MSG( "Created WORKSHIFT table successfully\n" );
    return xpSuccess;
}


/**
 * @brief SellingDatabase::create
 */
xpError_t SellingDatabase::create(const std::string &_dbPath)
{
    if( m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database is being opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }
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

    xpError_t xpErr = createBillTable();
    xpErr |= createSellingRecordTable();
    xpErr |= createWorkShiftTable();
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to create a tableh\n",
                 xpErr, __FILE__, __LINE__ );
        close();
    }

    return xpErr;
}


/**
 * @brief SellingDatabase::insertBill
 */
xpError_t SellingDatabase::insertBill( Bill &_bill)
{
    if( _bill.getStaffId() == "" || _bill.getCreationTime() <= 0 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid bill info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string cmdFormat = "INSERT INTO BILL (CUSTOMER_ID, STAFF_ID, CREATION_TIME, TOTAL_CHARGING, TOTAL_DISCOUNT, CUSTOMER_PAYMENT, USED_POINT, REWARDED_POINT) " \
                            "VALUES('%s', '%s', %ld, %f, %f, %f, %d, %d);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),
             _bill.getCustomerId().c_str(), _bill.getStaffId().c_str(), _bill.getCreationTime(),
             _bill.getTotalCharging(), _bill.getTotalDiscount(), _bill.getCustomerPayment(),
             _bill.getUsedPoint(), _bill.getRewardedPoint() );
    printf( "====> insert bill cmd: %s\n", sqliteCmd );

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
 * @brief SellingDatabase::insertSellingRecord
 */
xpError_t SellingDatabase::insertSellingRecord( SellingRecord &_record)
{
    if( _record.getBillId() == "" || _record.getProductBarcode() == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid selling record info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string cmdFormat = "INSERT INTO SELLING_RECORD (BILL_ID, PRODUCT_BARCODE, QUANTITY, TOTAL_PRICE) " \
                            "VALUES('%s', '%s', %d, %f);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),
             _record.getBillId().c_str(), _record.getProductBarcode().c_str(),
             _record.getQuantity(), _record.getTotalPrice() );
    printf( "====> insert selling record cmd: %s\n", sqliteCmd );

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
 * @brief SellingDatabase::insertWorkShift
 */
xpError_t SellingDatabase::insertWorkShift( WorkShift &_workshift)
{
    if( _workshift.getStaffId() == "" || _workshift.getStartTime() <= 0 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid workshift info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string cmdFormat = "INSERT INTO WORKSHIFT (STAFF_ID, START_TIME, END_TIME, TOTAL_EARNING) " \
                            "VALUES('%s', %ld, %ld, %f);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),_workshift.getStaffId().c_str(),
             _workshift.getStartTime(), _workshift.getEndTime(), _workshift.getTotalEarning() );
    printf( "====> insert workshift cmd: %s\n", sqliteCmd );

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
