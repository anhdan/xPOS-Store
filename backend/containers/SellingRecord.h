#ifndef SELLINGRECORD_H
#define SELLINGRECORD_H


#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Product.h"

namespace xpos_store {

class SellingRecord : public Item
{
public:
    SellingRecord() : Item()
    {
        setDefault();
    }
    ~SellingRecord() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();
    QString toJSONString();

    void setBillId( const std::string &_billId );
    std::string getBillId();

    void setProductBarcode( const std::string &_barcode );
    std::string getProductBarcode();

    void setDescription( const std::string &_desc );
    std::string getDescription();

    void setQuantity( const int _quantity );
    int getQuantity();

    void setSellingPrice( const double _sellingPrice );
    double getSellingPrice();

    void setDiscountPercent( const double _discountPercent );
    void setDiscountPercent( const double _unitPrice, const double _sellingPrice );
    double getDiscountPercent();


private:
    std::string m_billId;
    std::string m_productBarcode;
    std::string m_desc;
    int m_quantity;
    double m_sellingPrice;
    double m_discountPercent;
};

}

#endif // SELLINGRECORD_H
