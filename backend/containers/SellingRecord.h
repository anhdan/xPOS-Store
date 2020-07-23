#ifndef SELLINGRECORD_H
#define SELLINGRECORD_H


#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Product.h"

namespace xpos_store {

class SellingRecord : public Item
{
public:
    SellingRecord() : Item() {}
    ~SellingRecord() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );

    void setBillId( const uint64_t _billId );
    uint64_t getBillId();

    void setProductBarcode( const std::string &_barcode );
    std::string getProductBarcode();

    void setQuantity( const int _quantity );
    int getQuantity();

    void setTotalPrice( const double _totalPrice );
    double getTotalPrice();

private:
    unsigned long m_billId;
    std::string m_productBarcode;
    int m_quantity;
    double m_totalPrice;
};

}

#endif // SELLINGRECORD_H
