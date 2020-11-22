#include "SellingDatabase.h"


namespace xpos_store {

/**
 * @brief groupBillCallBack
 */
static int groupBillCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    if( data )
    {
        std::list<RetailStatusRecord> *records = (std::list<RetailStatusRecord>*)data;
        RetailStatusRecord record;
        for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
        {
            if( !strcmp(fieldName[fieldId], "YEAR") )
            {
                record.year = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "MONTH") )
            {
                record.month = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "WEEK") )
            {
                record.week = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "WDAY") )
            {
                record.wday = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "HOUR") )
            {
                record.hour = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "SUM(TOTAL_CHARGING)") )
            {
                record.revenue = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "SUM(TOTAL_DISCOUNT)") )
            {
                record.disount = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "SUM(PROFIT)") )
            {
                record.profit = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else
            {
                LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
                return xpErrorProcessFailure;
            }
        }

        records->push_back( record );
    }

    return xpSuccess;
}



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
                            "   ID                  TEXT        PRIMARY KEY,\n" \
                            "   CUSTOMER_ID         TEXT        ,\n" \
                            "   STAFF_ID            TEXT        NOT NULL,\n" \
                            "   CREATION_TIME       INTEGER     NOT NULL,\n" \
                            "   YEAR                INTEGER     NOT NULL,\n" \
                            "   MONTH               INTEGER     NOT NULL,\n" \
                            "   WEEK                INTEGER     NOT NULL,\n" \
                            "   WDAY                INTEGER     NOT NULL,\n" \
                            "   HOUR                INTEGER     NOT NULL,\n" \
                            "   TOTAL_CHARGING      REAL        NOT NULL,\n" \
                            "   TOTAL_DISCOUNT      REAL        NOT NULL,\n" \
                            "   CUSTOMER_PAYMENT    REAL        NOT NULL,\n" \
                            "   PROFIT              REAL        NOT NULL,\n" \
                            "   USED_POINT          INTEGER     NOT NULL,\n" \
                            "   REWARDED_POINT      INTEGER     NOT NULL\n" \
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
                            "   CATEGORY            INTEGER     NOT NULL,\n" \
                            "   CREATION_TIME       INTEGER     NOT NULL,\n" \
                            "   QUANTITY            INTEGER     NOT NULL,\n" \
                            "   TOTAL_PRICE         REAL        NOT NULL,\n" \
                            "   DISCOUNT_PERCENT    REAL,\n" \
                            "   TOTAL_PROFIT         REAL        NOT NULL,\n" \
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
                            "   TOTAL_PROFIT        REAL        NOT NULL,\n" \
                            "   TOTAL_TAX           REAL        NOT NULL,\n" \
                            "   TOTAL_CUSTOMERS     INTEGER     NOT NULL,\n" \
                            "   TOTAL_REWARDED_POINTS INTEGER   NOT NULL,\n" \
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
    if( !_bill.isValid() )
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

    // Get time in year/month/date/hour
    time_t billTime = _bill.getCreationTime();
    struct tm *ltm = localtime( &billTime );


    std::string cmdFormat = "INSERT INTO BILL (ID, CUSTOMER_ID, STAFF_ID, CREATION_TIME, YEAR, MONTH, WEEK, WDAY, HOUR, " \
                                              "TOTAL_CHARGING, TOTAL_DISCOUNT, CUSTOMER_PAYMENT, PROFIT, USED_POINT, REWARDED_POINT) " \
                            "VALUES('%s', '%s', '%s', %ld, %d, %d, %d, %d, %d, %f, %f, %f, %f, %d, %d);";
    char sqliteCmd[1000];
    Payment payment;
    _bill.getPayment( payment );
    sprintf( sqliteCmd, cmdFormat.c_str(), _bill.getId().c_str(),
             _bill.getCustomerId().c_str(), _bill.getStaffId().c_str(), _bill.getCreationTime(),
             ltm->tm_year + 1900, ltm->tm_mon + 1, (ltm->tm_mday - 1) / 7, ltm->tm_wday , ltm->tm_hour,
             payment.getTotalCharging(), payment.getTotalDiscount(), payment.getCustomerPayment(),
             _bill.getProfit(), payment.getUsedPoint(), payment.getRewardedPoint() );
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
 * @brief SellingDatabase::searchBillById
 */
xpError_t SellingDatabase::searchBillById(const std::string &_billId, Bill &_bill)
{
    //! TODO:
    //!     Implement this
    return xpSuccess;
}


/**
 * @brief SellingDatabase::searchBillByTime
 */
xpError_t SellingDatabase::searchBillByTime(const time_t _start, const time_t _stop, std::vector<Bill> &_bills)
{
    //! TODO:
    //!     Implement this
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

    std::string cmdFormat = "INSERT INTO SELLING_RECORD (BILL_ID, PRODUCT_BARCODE, CATEGORY, CREATION_TIME, QUANTITY, TOTAL_PRICE, DISCOUNT_PERCENT, TOTAL_PROFIT) " \
                            "VALUES('%s', '%s', %d, %ld, %d, %f, %f, %f);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),
             _record.getBillId().c_str(), _record.getProductBarcode().c_str(),
             (int)_record.getCategory(), _record.getCreationTime(), _record.getQuantity(),
             _record.getTotalPrice(), _record.getDiscountPercent(),
             _record.getTotalProfit() );
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
 * @brief SellingDatabase::insertSellingRecord
 */
xpError_t SellingDatabase::insertSellingRecord(Product &_product, const std::string &_billId, const time_t _creationTime)
{
    if( !_product.isValid() || _product.getItemNum() <= 0 )
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


    double discountPercent = (_product.getUnitPrice() - _product.getSellingPrice()) / _product.getUnitPrice() * 100;
    std::string cmdFormat = "INSERT INTO SELLING_RECORD (BILL_ID, PRODUCT_BARCODE, CATEGORY, CREATION_TIME, QUANTITY, TOTAL_PRICE, DISCOUNT_PERCENT, TOTAL_PROFIT) " \
                            "VALUES('%s', '%s', %d, %ld, %d, %f, %f, %f);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),
             _billId.c_str(), _product.getBarcode().c_str(), (int)_product.getCategory(), _creationTime, _product.getItemNum(),
             _product.getSellingPrice() * _product.getItemNum(), discountPercent,
             (_product.getSellingPrice()-_product.getInputPrice())*_product.getItemNum() );
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
 * @brief SellingDatabase::searchSellingRecord
 */
xpError_t SellingDatabase::searchSellingRecord( std::vector<SellingRecord> &_records, const std::string &_billId, const std::string &_barcode )
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "";
    if( _billId != "" )
    {
        if( _barcode != "" )
        {
            sqliteCmd = "SELECT * FROM SELLING_RECORD WHERE BILL_ID='" + _billId + "' AND "
                                                         + "PRODUCT_PARCODE=" + _barcode + ";";
        }
        else
        {
            sqliteCmd = "SELECT * FROM SELLING_RECORD WHERE BILL_ID='" + _billId + ";";
        }
    }
    else
    {
        if( _barcode != "" )
        {
            sqliteCmd = "SELECT * FROM SELLING_RECORD WHERE PRODUCT_PARCODE=" + _barcode + ";";
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameters\n",
                     xpErrorInvalidParameters, __FILE__, __LINE__ );
            return xpErrorInvalidParameters;
        }
    }
    LOG_MSG( "[DEB] %s:%d: ===> searchSellingRecord cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd.c_str() );


    _records.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), SellingRecord::searchCallBack, (void*)&_records, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _records.clear();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::searchSellingRecord
 */
xpError_t SellingDatabase::searchSellingRecord(std::vector<SellingRecord> &_records, const time_t _start, const time_t _stop)
{
    if( _start < 0 || _stop <= _start )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameters\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "SELECT * FROM SELLING_RECORD WHERE CREATION_TIME>=" + std::to_string((uint64_t)_start) + " AND "
                                                       + "CREATION_TIME<" + std::to_string((uint64_t)_stop) + ";";
    LOG_MSG( "[DEB] %s:%d: ===> searchSellingRecord cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd.c_str() );

    _records.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), SellingRecord::searchCallBack, (void*)&_records, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _records.clear();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupHistoryRecordByBarcode
 */
xpError_t SellingDatabase::groupHistoryRecordByBarcode(std::vector<SellingRecord> &_records, const time_t _start, const time_t _stop)
{
    if( _start < 0 || _stop <= _start )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameters\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT PRODUCT_BARCODE, SUM(QUANTITY), SUM(TOTAL_PRICE), SUM(TOTAL_PROFIT)\n" \
                                    "FROM SELLING_RECORD\n" \
                                    "WHERE CREATION_TIME>=%ld AND CREATION_TIME<%ld\n" \
                                    "GROUP BY PRODUCT_BARCODE\n" \
                                    "ORDER BY SUM(TOTAL_PRICE) DESC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), (uint64_t)_start, (uint64_t)_stop );
    LOG_MSG( "[DEB] %s:%d: ===> groupHistoryRecordByBarcode cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _records.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, SellingRecord::searchCallBackGroup, (void*)&_records, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _records.clear();
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

    std::string cmdFormat = "INSERT INTO WORKSHIFT (STAFF_ID, START_TIME, END_TIME, TOTAL_EARNING, TOTAL_PROFIT, TOTAL_TAX, TOTAL_CUSTOMERS, TOTAL_REWARDED_POINTS) " \
                            "VALUES('%s', %ld, %ld, %f, %f, %f, %d, %d);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(),_workshift.getStaffId().c_str(),
             _workshift.getStartTime(), _workshift.getEndTime(), _workshift.getTotalEarning(),
             _workshift.getTotalProfit(), _workshift.getTotalTax(), _workshift.getTotalCustomers(),
             _workshift.getTotalRewardPoints() );
    LOG_MSG( "====> insert workshift cmd: %s\n", sqliteCmd );

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
 * @brief SellingDatabase::searchWorkShift
 */
xpError_t SellingDatabase::searchWorkShift(std::vector<WorkShift> &_workshifts, const time_t _start, const time_t _stop, const std::string &_staffId)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "";
    if( _start > 0 && _stop > _start )
    {
        if( _staffId != "" )
        {
            sqliteCmd = "SELECT * FROM WORKSHIFT WHERE STAFF_ID='" + _staffId + "' AND "
                                                    + "START_TIME>=" + std::to_string((uint64_t)_start) + " AND "
                                                    + "END_TIME<" + std::to_string((uint64_t)_stop) + ";";
        }
        else
        {
            sqliteCmd = "SELECT * FROM WORKSHIFT WHERE START_TIME>=" + std::to_string((uint64_t)_start) + " AND "
                                                    + "END_TIME<" + std::to_string((uint64_t)_stop) + ";";
        }
    }
    else
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid time range to search\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }
    LOG_MSG( "[DEB] %s:%d: ===> searchWorkShift cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd.c_str() );

    _workshifts.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), WorkShift::searchCallBack, (void*)&_workshifts, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _workshifts.clear();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupBillsByDayHours
 */
xpError_t SellingDatabase::groupBillsByDayHours(const uint64_t &_startTime, const uint64_t &_endTime, std::list<RetailStatusRecord> &_retailRecords)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT HOUR, SUM(TOTAL_CHARGING), SUM(TOTAL_DISCOUNT), SUM(PROFIT)\n" \
                                    "FROM BILL\n" \
                                    "WHERE CREATION_TIME > %ld AND CREATION_TIME <%ld\n" \
                                    "GROUP BY HOUR\n" \
                                    "ORDER BY CREATION_TIME ASC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupBillsByDayHour cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _retailRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, groupBillCallBack, (void*)&_retailRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _retailRecords.clear();
        return xpErrorProcessFailure;
    }

    std::list<RetailStatusRecord>::iterator it = _retailRecords.begin();
    for( int id = 0; id < (int)_retailRecords.size(); id++ )
    {
        it->timeStr = std::to_string( it->hour ) + ":00";
        std::advance( it, 1 );
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupBillsByWeekDays
 */
xpError_t SellingDatabase::groupBillsByWeekDays( const uint64_t &_startTime, const uint64_t &_endTime, std::list<RetailStatusRecord> &_retailRecords )
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT MONTH, WEEK, WDAY, SUM(TOTAL_CHARGING), SUM(TOTAL_DISCOUNT), SUM(PROFIT)\n" \
                                    "FROM BILL\n" \
                                    "WHERE CREATION_TIME > %ld AND CREATION_TIME <%ld\n" \
                                    "GROUP BY WEEK, WDAY\n" \
                                    "ORDER BY CREATION_TIME ASC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupBillsByWeekDay cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _retailRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, groupBillCallBack, (void*)&_retailRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _retailRecords.clear();
        return xpErrorProcessFailure;
    }

    std::list<RetailStatusRecord>::iterator it = _retailRecords.begin();
    for( int id = 0; id < (int)_retailRecords.size(); id++ )
    {
        it->timeStr = DATE[it->wday] + ", " + std::to_string(it->week*7 + it->wday) + "/" + std::to_string(it->month);
        std::advance( it, 1 );
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupBillsByMonthWeeks
 */
xpError_t SellingDatabase::groupBillsByMonthWeeks(const uint64_t &_startTime, const uint64_t &_endTime, std::list<RetailStatusRecord> &_retailRecords)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT YEAR, MONTH, WEEK, SUM(TOTAL_CHARGING), SUM(TOTAL_DISCOUNT), SUM(PROFIT)\n" \
                                    "FROM BILL\n" \
                                    "WHERE CREATION_TIME > %ld AND CREATION_TIME <%ld\n" \
                                    "GROUP BY MONTH, WEEK\n" \
                                    "ORDER BY CREATION_TIME ASC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupBillsByMonthWeeks cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _retailRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, groupBillCallBack, (void*)&_retailRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _retailRecords.clear();
        return xpErrorProcessFailure;
    }

    std::list<RetailStatusRecord>::iterator it = _retailRecords.begin();
    for( int id = 0; id < (int)_retailRecords.size(); id++ )
    {
        QDate startDate( it->year, it->month, it->week );
        QDate endDate( it->year, it->month, it->week * 7 + 6 );
        it->timeStr = std::to_string( startDate.day() ) + "/" + std::to_string( startDate.month()+1 ) + " - "
                + std::to_string( endDate.day() ) + "/" + std::to_string( endDate.month()+1 );
        std::advance( it, 1 );
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupBillsByMonths
 */
xpError_t SellingDatabase::groupBillsByMonths(const uint64_t &_startTime, const uint64_t &_endTime, std::list<RetailStatusRecord> &_retailRecords)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT YEAR, MONTH, SUM(TOTAL_CHARGING), SUM(TOTAL_DISCOUNT), SUM(PROFIT)\n" \
                                    "FROM BILL\n" \
                                    "WHERE CREATION_TIME > %ld AND CREATION_TIME <%ld\n" \
                                    "GROUP BY YEAR, MONTH\n" \
                                    "ORDER BY CREATION_TIME ASC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupBillsByMonths cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _retailRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, groupBillCallBack, (void*)&_retailRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _retailRecords.clear();
        return xpErrorProcessFailure;
    }

    std::list<RetailStatusRecord>::iterator it = _retailRecords.begin();
    for( int id = 0; id < (int)_retailRecords.size(); id++ )
    {
        it->timeStr = "Th " + std::to_string( it->month ) + "/" + std::to_string( it->year );
        std::advance( it, 1 );
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupSellingRecordsByCategory
 */
xpError_t SellingDatabase::groupSellingRecordsByCategory(const uint64_t &_startTime, const uint64_t &_endTime, std::list<SellingRecord> &_sellingRecords)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT CATEGORY, SUM(TOTAL_PRICE), SUM(TOTAL_PROFIT)\n" \
                                    "FROM SELLING_RECORD\n" \
                                    "WHERE CREATION_TIME>=%ld AND CREATION_TIME<%ld\n" \
                                    "GROUP BY CATEGORY\n" \
                                    "ORDER BY SUM(TOTAL_PRICE) DESC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupHistoryRecordByBarcode cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _sellingRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, SellingRecord::searchCallBackGroup, (void*)&_sellingRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _sellingRecords.clear();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief SellingDatabase::groupSellingRecordsByBarcode
 */
xpError_t SellingDatabase::groupSellingRecordsByBarcode(const uint64_t &_startTime, const uint64_t &_endTime, std::list<SellingRecord> &_sellingRecords)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmdFormat =   "SELECT PRODUCT_BARCODE, SUM(QUANTITY), SUM(TOTAL_PRICE), SUM(TOTAL_PROFIT)\n" \
                                    "FROM SELLING_RECORD\n" \
                                    "WHERE CREATION_TIME>=%ld AND CREATION_TIME<%ld\n" \
                                    "GROUP BY PRODUCT_BARCODE\n" \
                                    "ORDER BY SUM(TOTAL_PRICE) DESC;";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _startTime, _endTime );
    LOG_MSG( "[DEB] %s:%d: ===> groupHistoryRecordByBarcode cmd:\n\t%s\n",
             __FUNCTION__, __LINE__, sqliteCmd );

    _sellingRecords.clear();
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd, SellingRecord::searchCallBackGroup, (void*)&_sellingRecords, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _sellingRecords.clear();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


}
