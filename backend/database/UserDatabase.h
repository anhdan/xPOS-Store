#ifndef USERDATABASE_H
#define USERDATABASE_H

#include "backend/xPos.h"
#include "backend/database/Database.h"
#include "backend/containers/Staff.h"
#include "backend/containers/Customer.h"

namespace xpos_store {

class UserDatabase : public Database
{
public:
    UserDatabase() {}
    UserDatabase( const UserDatabase &_db );
    ~UserDatabase() {}

private:
    xpError_t createCustomerTable();
    xpError_t createStaffTable();

public:
    xpError_t create(const std::string &_dbPath);

    xpError_t searchStaff( const std::string &_id, Staff &_staff );
    xpError_t verifyStaff( Staff &_staff, bool *_authenticated );
    xpError_t registerStaff( Staff &_staff );

    xpError_t searchCustomer( const std::string &_id, Customer &_customer );
    xpError_t insertCustomer( Customer &_customer );
    xpError_t updateCustomer( Customer &_customer, const bool _isShoppingPropertyOnly=true );
};

}

#endif // USERDATABASE_H
