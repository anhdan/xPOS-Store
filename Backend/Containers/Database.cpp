#include "Database.h"


namespace xpos_store
{

using namespace tinyxml2;

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
Database* Database::createByTemplate(const std::string &_dbPath, const std::string &_tmplPath)
{
    Database *db = new Database;
    char *sqliteMsg = nullptr;
    int sqliteErr = 0;
    db->m_dbPath = _dbPath;

    // Read config file by xml format
    XMLDocument xmlDoc;
    XMLError xmlErr;
    xmlErr = xmlDoc.LoadFile( _tmplPath.c_str() );
    if( xmlErr != XML_SUCCESS )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to load template config file\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        delete db;
        return nullptr;
    }

    XMLElement* root = xmlDoc.FirstChildElement();
    if( (root == nullptr) || strcmp( root->Value(), "DATABASE" ) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid template configuration format file\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        delete db;
        return nullptr;
    }

    // Try to open database
    sqliteErr = sqlite3_open( _dbPath.c_str(), &db->m_dbPtr );
    if( sqliteErr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to open database file by given path\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        delete db;
        return nullptr;
    }

    // Create sqlite command following the instruction of template file
    for( XMLElement* ele = root->FirstChildElement(); ele != nullptr; ele = ele->NextSiblingElement() )
    {
        std::string tableCreateCmd = "CREATE TABLE ";
        if( !strcmp(ele->Value(), "TABLE") )
        {
            XMLElement *subEle = ele->FirstChildElement("NAME");
            tableCreateCmd += std::string(subEle->GetText()) + "(\n";

            subEle = subEle->NextSiblingElement();
            std::string pk = "\tPRIMARY KEY(";
            while( subEle != nullptr )
            {
                if( !strcmp(subEle->Value(), "FIELD") )
                {
                    tableCreateCmd += "\t" + std::string(subEle->FirstChildElement("NAME")->GetText() ) + "\t" +
                            subEle->FirstChildElement("TYPE")->GetText();

                    if( !strcmp(subEle->FirstChildElement("PRIMARYKEY")->GetText(), "YES") )
                    {
                        pk += std::string(subEle->FirstChildElement("NAME")->GetText()) +",";
                    }

                    if( !strcmp(subEle->FirstChildElement("NOTNULL")->GetText(), "YES") )
                    {
                        tableCreateCmd += "\tNOT NULL";
                    }

                    if( !strcmp(subEle->FirstChildElement("AUTOINCREMENT")->GetText(), "YES") )
                    {
                        tableCreateCmd += "\tAUTOINCREMENT";
                    }

                    if( !strcmp(subEle->FirstChildElement("UNIQUE")->GetText(), "YES") && strcmp(subEle->FirstChildElement("PRIMARYKEY")->GetText(), "YES") )
                    {
                        tableCreateCmd += "\tUNIQUE";
                    }

                    tableCreateCmd += ",\n";
                }

                subEle = subEle->NextSiblingElement();
            }
            pk.erase( pk.end()-1 );
            tableCreateCmd += pk + ")\n);";

            std::cout << tableCreateCmd << std::endl << std::endl;
            if( sqliteMsg )
            {
                sqlite3_free( sqliteMsg );
            }
            sqliteErr =sqlite3_exec( db->m_dbPtr, tableCreateCmd.c_str(), nullptr, nullptr, &sqliteMsg );
            if( sqliteErr )
            {
                LOG_MSG( "[ERR:%d] %s:%d: Failed to excute SQLite command\n",
                         xpErrorProcessFailure, __FILE__, __LINE__ );
                sqlite3_close( db->m_dbPtr );
                sqlite3_free( sqliteMsg );
                delete db;
                return nullptr;
            }
            else {
                printf( "Created table successfully\n" );
            }
        }
    }

    if( sqliteMsg )
    {
        sqlite3_free( sqliteMsg );
    }
    sqlite3_close( db->m_dbPtr );
    db->m_isOpen = false;

    return db;
}


/**
 * @brief Database::connect
 */
Database* Database::connect(const std::string &_dbPath)
{
    // Check the existance
    if( access(_dbPath.c_str(), F_OK) == -1 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database file is not exist\n",
                 xpErrorNotExist, __FILE__, __LINE__ );
        return nullptr;
    }
    Database *db = new Database;
    db->m_dbPath = _dbPath;

    // Try opening the database
    int rc = sqlite3_open( _dbPath.c_str(), &db->m_dbPtr );
    if( rc )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Attemp to open the database failed\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        delete db;
    }
    else {
        sqlite3_close( db->m_dbPtr );
    }

    return db;

}


/**
 * @brief Database::open
 */
xpError_t Database::open()
{
    if( m_isOpen )
    {
        LOG_MSG( "[WAR] %s:%d: The database is already opened\n",
                  __FILE__, __LINE__ );
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
 * @brief Database::getTableByName
 */
Table* Database::getTableByName(const std::string &_tableName)
{
    if( !m_isOpen )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The database is being closed\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return nullptr;
    }

    Table *table = new Table;
    std::string sqliteCmd = "SELECT name FROM sqlite_master WHERE type='table' AND name='" + _tableName + "'";
    char *sqliteMsg = nullptr;
    xpError_t sqliteErr = sqlite3_exec( m_dbPtr, sqliteCmd.c_str(), nullptr, nullptr, &sqliteMsg );
    if( sqliteErr != SQLITE_OK )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, sqliteMsg );
        delete table;
    }
    else
    {
        table->db = m_dbPtr;
        table->name = _tableName;
    }
    sqlite3_free( sqliteMsg );

    return table;
}


}
