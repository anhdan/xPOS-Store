#ifndef CUSTOMER_H
#define CUSTOMER_H

#include "backend/xPos.h"
#include "backend/containers/Person.h"
#include "backend/containers/Payment.h"

namespace xpos_store {

    class Customer : public Person
    {
    public:
        Customer() : Person()
        {
            setDefault();
        }
        ~Customer() { }

    public:
        void setDefault();
        void copyTo( Item *_item );
        void printInfo();
        QVariant toQVariant( );
        xpError_t fromQVariant( const QVariant &_item );
        bool isValid();


        void setShoppingCount( const int _shoppingCnt );
        int getShoppingCount();
        void setTotalPayment(const double _total );
        double getTotalPayment();
        void setPoint( const int _point );
        int getPoint();

        xpError_t makePayment( const double _payment, const int _usedPoint, const int _rewardedPoint );
        xpError_t makePayment( Payment &_payment );

        static xpError_t searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName);

    private:
        int m_shoppingCnt;
        double m_totalPayment;
        int m_point;
    };

}

#endif // CUSTOMER_H
