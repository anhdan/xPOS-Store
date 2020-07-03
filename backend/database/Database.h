#ifndef DATABASE_H
#define DATABASE_H

#include <sqlite3.h>
#include "backend/xPos.h"
#include "backend/containers/Item.h"


namespace xpos_store {

class Database
{
public:
    Database();
    Database( const Database &_db );
    ~Database();

public:
    static Database* createByConfig( const std::string &_dbPath, const std::string &_configPath );
    virtual xpError_t create( const std::string &_dbPath ) = 0;
    xpError_t connect( const std::string &_dbPath );
    xpError_t open();
    xpError_t close();
    bool isOpen();

    void printInfo();

protected:
    sqlite3 *m_dbPtr;
    bool m_isOpen;
    std::string m_dbPath;
};

}

#endif // DATABASE_H
