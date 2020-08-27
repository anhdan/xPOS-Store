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
    Bill() : Item()
    {
        setDefault();
    }
    ~Bill() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();
    QString toJSONString();

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

    xpError_t addProduct( Product &_product );

private:
    std::string m_id;
    std::string m_customerId;
    std::string m_staffId;
    time_t m_creationTime;
    Payment m_payment;
    std::list<Product> m_products;
};

}

#endif // BILL_H
