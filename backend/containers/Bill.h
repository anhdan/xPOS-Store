#ifndef BILL_H
#define BILL_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Staff.h"
#include "backend/containers/Customer.h"
#include "backend/containers/Product.h"
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

    void setStaffId( const std::string &_staffId );
    std::string getStaffId();

    void setCustomerId( const std::string &_custmerId );
    std::string getCustomerId();

    void setCreationTime( const time_t _creationTime );
    time_t getCreationTime();

    void setPayment( const Payment &_payment );
    void getPayment( Payment &_payment );

    xpError_t compose( const Staff &_staff, const Customer &_customer,
                       const Payment &_payment, const std::vector<Product> &_products );
    std::string getJSONString();

private:
    std::string m_customerId;
    std::string m_staffId;
    time_t m_creationTime;
    Payment m_payment;
};

}

#endif // BILL_H
