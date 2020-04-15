#include "Database.h"

namespace xpos_store
{

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
    sqlite3_close(m_dbPtr);
}


/**
 * @brief Database::createByTemplate
 */
static Database* Database::createByTemplate(const std::string &_dbPath, const std::string &_tmplPath)
{
    m_dbPath = _dbPath;
}

}
