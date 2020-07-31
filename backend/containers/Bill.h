#ifndef BILL_H
#define BILL_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Staff.h"
#include "backend/containers/Customer.h"
#include "backend/containers/Product.h"
#include "backend/containers/SellingRecord.h"
#include "backend/containers/Payment.h"

namespace xpos_store {

class Bill : public Item
{
public:
    Bill() : Item() {}
    ~Bill() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();

    void setId( const std::string &_id );
    std::string getId();

    void setStaffId( const std::string &_staffId );
    std::string getStaffId();

    void setCustomerId( const std::string &_custmerId );
    std::string getCustomerId();

    void setCreationTime( const time_t _creationTime );
    time_t getCreationTime();

    void setPayment( const Payment &_payment );
    void getPayment( Payment &_payment );

    xpError_t addSellingRecord( SellingRecord &_record );
    xpError_t compose( const Staff &_staff, const Customer &_customer,
                       const Payment &_payment, const std::vector<SellingRecord> &_records );
    QString toJSONString();

private:
    std::string m_id;
    std::string m_customerId;
    std::string m_staffId;
    time_t m_creationTime;
    Payment m_payment;
    std::list<SellingRecord> m_sellingRecords;
};

}

#endif // BILL_H
