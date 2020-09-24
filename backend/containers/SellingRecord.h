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

    void setCreationTime( const time_t _creationTime );
    time_t getCreationTime();

    void setQuantity( const int _quantity );
    int getQuantity();

    void setTotalProfit( const double _profit );
    double getTotalProfit();

    void setTotalPrice( const double _sellingPrice );
    double getTotalPrice();

    void setDiscountPercent( const double _discountPercent );
    void setDiscountPercent( const double _unitPrice, const double _sellingPrice );
    double getDiscountPercent();

    static SellingRecord fromProduct( Product &_product );

    static xpError_t searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName);
    static xpError_t searchCallBackGroup(void *data, int fieldsNum, char **fieldVal, char **fieldName);

private:
    std::string m_billId;
    std::string m_productBarcode;
    std::string m_desc;
    time_t m_creationTime;
    int m_quantity;
    double m_totalProfit;
    double m_totalPrice;
    double m_discountPercent;
};

}

#endif // SELLINGRECORD_H
