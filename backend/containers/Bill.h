#ifndef BILL_H
#define BILL_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Customer.h"

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

    void setStaffId( const std::string &_staffId );
    std::string getStaffId();

    void setCustomerId( const std::string &_custmerId );
    std::string getCustomerId();

    void setCreationTime( const time_t _creationTime );
    time_t getCreationTime();

    void setPayment( const double _totalCharging, const double _totalDiscount, const double _totalPayment );
    void getPayment( double *_totalCharging, double *_totalDiscount, double *_totalPayment );

    void setPoints( const double _usedPoint, const double _rewardedPoint );
    double getUsedPoint();
    double getRewardedPoint();

private:
    std::string m_customerId;
    std::string m_staffId;
    time_t m_creationTime;
    double m_totalCharging;
    double m_totalDiscount;
    double m_customerPayment;
    int m_usedPoint;
    int m_rewardedPoint;
};

}

#endif // BILL_H
