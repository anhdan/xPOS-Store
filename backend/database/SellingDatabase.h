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
    xpError_t searchBillById( const std::string &_billId, Bill &_bill );
    xpError_t searchBillByTime( const time_t _start, const time_t _stop, std::vector<Bill> &_bills );

    xpError_t insertSellingRecord( SellingRecord &_record );
    xpError_t insertSellingRecord( Product &_product, const std::string &_billId, const time_t _creationTime );
    xpError_t searchSellingRecord( std::vector<SellingRecord> &_records, const std::string &_billId="", const std::string &_barcode="" );    
    xpError_t searchSellingRecord( std::vector<SellingRecord> &_records, const time_t _start, const time_t _stop );
    xpError_t groupHistoryRecordByBarcode( std::vector<SellingRecord> &records, const time_t _start, const time_t _stop );

    xpError_t insertWorkShift( WorkShift &_workshift );
    xpError_t searchWorkShift( std::vector<WorkShift> &_workshifts, const time_t _start,
                               const time_t _stop, const std::string &_staffId="" );
};

}


#endif // SELLINGDATABASE_H
