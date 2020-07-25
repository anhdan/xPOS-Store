#ifndef PAYMENT_H
#define PAYMENT_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"

namespace xpos_store {

class Payment : public Item
{
public:
    Payment() : Item(){}
    ~Payment(){}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();

    void setTotalCharging( const double _totalCharing );
    double getTotalCharging();
    void setTotalDiscount( const double _totalDiscount );
    double getTotalDiscount();
    void setCustmomerPayment( const double _customerPayment );
    double getCustomerPayment();
    double getReturnToCustomer();

    void setUsedPoints( const double _usedPoint );
    double getUsedPoint();
    void setRewardedPoints( const double _rewardedPoint );
    double getRewardedPoint();

private:
    double m_totalCharging;
    double m_totalDiscount;
    double m_customerPayment;
    int m_usedPoint;
    int m_rewardedPoint;
};

}

#endif // PAYMENT_H
