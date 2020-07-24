#include "UserDatabase.h"


namespace xpos_store {

/**
 * @brief UserDatabase::UserDatabase
 */
UserDatabase::UserDatabase(const UserDatabase &_db) : Database(_db)
{

}


/**
 * @brief UserDatabase::createCustomerTable
 */
xpError_t UserDatabase::createCustomerTable()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS CUSTOMER (\n" \
                            "   ID                  TEXT        PRIMARY KEY,\n" \
                            "   NAME                TEXT        NOT NULL,\n" \
                            "   PHONE               TEXT        NOT NULL,\n" \
                            "   EMAIL               TEXT        NOT NULL,\n" \
                            "   TOTAL_PAYMENT       REAL        NOT NULL,\n" \
                            "   POINT               INTEGER     NOT NULL,\n" \
                            "   SHOPPING_COUNT      INTEGER     NOT NULL) WITHOUT ROWID;";
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

    LOG_MSG( "Created CUSTOMER table successfully\n" );
    return xpSuccess;
}


/**
 * @brief UserDatabase::createStaffTable
 */
xpError_t UserDatabase::createStaffTable()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "CREATE TABLE IF NOT EXISTS STAFF (\n" \
                            "   ID                  TEXT        PRIMARY KEY,\n" \
                            "   NAME                TEXT        NOT NULL,\n" \
                            "   PHONE               TEXT        NOT NULL,\n" \
                            "   EMAIL               TEXT        NOT NULL,\n" \
                            "   PRIVILEGE           INTEGER     NOT NULL,\n" \
                            "   LOGIN_NAME          TEXT        NOT NULL,\n" \
                            "   LOGIN_PWD           TEXT        NOT NULL) WITHOUT ROWID;";
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

    LOG_MSG( "Created STAFF table successfully\n" );
    return xpSuccess;
}


/**
 * @brief UserDatabase::create
 */
xpError_t UserDatabase::create(const std::string &_dbPath)
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

    xpError_t xpErr = createCustomerTable();
    xpErr |= createStaffTable();
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to create a tableh\n",
                 xpErr, __FILE__, __LINE__ );
        close();
        return xpErr;
    }

    return xpSuccess;
}


/**
 * @brief UserDatabase::searchCustomer
 */
xpError_t UserDatabase::searchCustomer(const std::string &_id, Customer &_customer)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "SELECT * from CUSTOMER where ID='" + _id + "';";
    char *sqliteMsg;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), Customer::searchCallBack, (void*)&_customer, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _customer.setDefault();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief UserDatabase::insertCustomer
 */
xpError_t UserDatabase::insertCustomer(Customer &_customer)
{
    if( _customer.getId() == "" )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid customer info\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    std::string cmdFormat = "INSERT INTO CUSTOMER (ID, NAME, PHONE, EMAIL, TOTAL_PAYMENT, POINT, SHOPPING_COUNT) " \
                            "VALUES('%s', '%s', '%s', '%s', %f, %d, %d);";
    char sqliteCmd[1000];
    sprintf( sqliteCmd, cmdFormat.c_str(), _customer.getId().c_str(),
             _customer.getName().c_str(), _customer.getPhone().c_str(), _customer.getEmail().c_str(),
             _customer.getTotalPayment(), _customer.getPoint(), _customer.getShoppingCount() );
    printf( "====> insert customer cmd: %s\n", sqliteCmd );

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
 * @brief UserDatabase::updateCustomer
 */
xpError_t UserDatabase::updateCustomer(Customer &_customer, const bool _isShoppingPropertyOnly )
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }
    std::string sqliteCmdFormat;
    char sqliteCmd[2000];
    if( _isShoppingPropertyOnly )
    {
        sqliteCmdFormat =   "UPDATE CUSTOMER\n" \
                            "SET    TOTAL_PAYMENT   = %f,\n" \
                            "       POINT           = %d,\n" \
                            "       SHOPPING_COUNT  = %d\n" \
                            "WHERE\n" \
                            "       ID = '%s';";
        sprintf( sqliteCmd, sqliteCmdFormat.c_str(), _customer.getTotalPayment(),
                 _customer.getPoint(), _customer.getShoppingCount(), _customer.getId().c_str() );
    }
    else
    {
        sqliteCmdFormat =   "UPDATE CUSTOMER\n" \
                            "SET    NAME            = '%s',\n" \
                            "       PHONE           = '%s',\n" \
                            "       EMAIL           = '%s',\n" \
                            "       TOTAL_PAYMENT   = %f,\n" \
                            "       POINT           = %d,\n" \
                            "       SHOPPING_COUNT  = %d\n" \
                            "WHERE\n" \
                            "       ID = '%s';";
        sprintf( sqliteCmd, sqliteCmdFormat.c_str(),
                 _customer.getName().c_str(), _customer.getEmail().c_str(), _customer.getTotalPayment(),
                 _customer.getPoint(), _customer.getShoppingCount(), _customer.getId().c_str() );
    }
    printf( "====> update customer cmd: \n\t%s\n\n", sqliteCmd );

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
 * @brief UserDatabase::searchStaff
 */
xpError_t UserDatabase::searchStaff(const std::string &_id, Staff &_staff)
{
//    if( !m_isOpen )
//    {
//        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
//                 xpErrorNotPermited, __FILE__, __LINE__ );
//        return xpErrorNotPermited;
//    }

//    std::string sqliteCmd = "SELECT * from STAFF where ID='" + _id + "';";
//    char *sqliteMsg;
//    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), Customer::searchCallBack, (void*)&_customer, &sqliteMsg );
//    if( sqliteErr != SQLITE_OK )
//    {
//        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
//                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
//        sqlite3_free( sqliteMsg );
//        _customer.setDefault();
//        return xpErrorProcessFailure;
//    }

    return xpSuccess;
}

/**
 * @brief UserDatabase::verifyStaff
 */
xpError_t UserDatabase::verifyStaff( Staff &_staff, bool *_authenticated )
{
    if( _authenticated == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Null pointer\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database has not been opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        _staff.setDefault();
        *_authenticated = false;
        return xpErrorNotPermited;
    }

    std::string sqliteCmd = "SELECT * from STAFF where LOGIN_NAME='" + _staff.getLoginName() + "' AND LOGIN_PWD='" + _staff.getLoginPwd() + "';";
    std::cout << ". verify staff cmd: " << sqliteCmd << std::endl;
    char *sqliteMsg;
    Staff staff;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), Staff::searchCallBack, (void*)&staff, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        sqlite3_free( sqliteMsg );
        _staff.setDefault();
        *_authenticated = false;
        return xpErrorProcessFailure;
    }

    if( staff.getId() == "" )
    {
        *_authenticated = false;
    }
    else {
        *_authenticated = true;
    }
    staff.copyTo( (Item*)&_staff );
    _staff.setLoginPwd( "" );

    return xpSuccess;
}


/**
 * @brief UserDatabase::registerStaff
 */
xpError_t UserDatabase::registerStaff(Staff &_staff)
{

}

}
