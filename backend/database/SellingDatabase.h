#ifndef SELLINGDATABASE_H
#define SELLINGDATABASE_H

#include "backend/xPos.h"
#include "backend/database/Database.h"
#include "backend/containers/Bill.h"
#include "backend/containers/SellingRecord.h"
#include "backend/containers/WorkShift.h"

namespace xpos_store {

class SellingDatabase : public Database
{
public:
    SellingDatabase() : Database() {}
    SellingDatabase( const SellingDatabase &_db );
    ~SellingDatabase() {}

private:
    xpError_t createBillTable();
    xpError_t createSellingRecordTable();
    xpError_t createWorkShiftTable();

public:
    xpError_t create(const std::string &_dbPath);

    xpError_t insertBill( Bill &_bill );
    xpError_t insertSellingRecord( SellingRecord &_record );
    xpError_t insertSellingRecord( Product &_product, const std::string &_billId );
    xpError_t insertWorkShift( WorkShift &_workshift );
};

}


#endif // SELLINGDATABASE_H
