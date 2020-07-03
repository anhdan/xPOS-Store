#include "Database.h"

namespace xpos_store {

/**
 * @brief Database::Database
 */
Database::Database()
{
    m_dbPath = "";
    m_dbPtr = nullptr;
    m_isOpen = false;
}


/**
 * @brief Database::Database
 * @param _db
 */
Database::Database(const Database &_db)
{
    m_dbPath = _db.m_dbPath;
    m_dbPtr = _db.m_dbPtr;
    m_isOpen = _db.m_isOpen;
}


/**
 * @brief Database::~Database
 */
Database::~Database()
{
    if(m_isOpen)
        close();
}


/**
 * @brief Database::printInfo
 */
void Database::printInfo()
{
    LOG_MSG( "\n---------Database---------\n" );
    LOG_MSG( ".PATH:        %s\n", m_dbPath.c_str() );
    LOG_MSG( ".STATUS:      %s\n", m_isOpen ? "Open" : "Close" );
    //! TODO
    //! 1. print tables' name
    LOG_MSG( "----------------------------\n" );
}


/**
 * @brief Database::createByConfig
 */
Database* Database::createByConfig(const std::string &_dbPath, const std::string &_configPath)
{
    return nullptr;
}


/**
 * @brief Database::connect
 */
xpError_t Database::connect(const std::string &_dbPath)
{
    if( m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database is being opened\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    // Check the existance
    if( access(_dbPath.c_str(), F_OK) == -1 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database file is not exist\n",
                 xpErrorNotExist, __FILE__, __LINE__ );
        return xpErrorNotExist;
    }
    m_dbPath = _dbPath;

    // Try opening the database
    int rc = sqlite3_open( _dbPath.c_str(), &m_dbPtr );
    if( rc )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Attemp to open the database failed\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        m_dbPath = "";
        m_isOpen = false;
        return xpErrorProcessFailure;
    }
    m_isOpen = true;

    return xpSuccess;
}


/**
 * @brief Database::open
 */
xpError_t Database::open()
{
    if( m_isOpen )
    {        
        return xpSuccess;
    }
    int rc = sqlite3_open( m_dbPath.c_str(), &m_dbPtr );
    if( rc )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to open database file by given path\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        return xpErrorProcessFailure;
    }

    m_isOpen = true;
    return xpSuccess;
}


/**
 * @brief Database::close
 */
xpError_t Database::close()
{
    if( !m_isOpen )
    {
        LOG_MSG( "[WAR] %s:%d: The database is already closed\n",
                 __FILE__, __LINE__ );
        return xpSuccess;
    }
    int rc = sqlite3_close( m_dbPtr );
    if( rc )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to close database\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        return xpErrorProcessFailure;
    }

    m_isOpen = false;
    return xpSuccess;
}


/**
 * @brief Database::isOpen
 */
bool Database::isOpen()
{
    return m_isOpen;
}

}
