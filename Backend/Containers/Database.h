#ifndef DATABASE_H
#define DATABASE_H

#include "xPos.h"
#include "Backend/3rd/tinyxml2.h"

namespace xpos_store
{

/**
 * @brief The Table class
 */
class Table
{
public:
    Table(){
        name = "";
        db = nullptr;
    }

    Table( const sqlite3 * _db, const std::string &_name )
    {
        name = _name;
        db = (sqlite3*)_db;
    }

public:
    std::string name;
    sqlite3 *db;
};




/**
 * @brief The Database class
 */
class Database
{
public:
    Database();
    Database( const Database &_db );
    ~Database();

public:
    static Database* createByTemplate( const std::string &_dbPath, const std::string &_tmplPath );
    static Database* connect( const std::string &_dbPath );

    xpError_t open();
    xpError_t close();
    Table* getTableByName( const std::string &_tableName );

    inline bool isOpen() { return m_isOpen; }

private:
    xpError_t getTableCallback( void *data, int argc, char **fieldNames, char **fieldValues );

private:
    std::string m_dbPath;
    sqlite3 *m_dbPtr;
    bool m_isOpen;
};


}



#endif // DATABASE_H
