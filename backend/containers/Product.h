#ifndef PRODUCT_H
#define PRODUCT_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"

namespace xpos_store {

class Product : public Item
{

public:
    Product() : Item()
    {
        setDefault();
    }
    ~Product(){}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();
    QString toJSONString();
    bool isIdenticalTo( const Product &_product );

public:
    void setBarcode( const std::string &_barcode );
    std::string getBarcode();
    void setName( const std::string &_name );
    std::string getName();
    void setDescription( const std::string &_des );
    std::string getDescription();
    void setUnit( const std::string &_unit );
    std::string getUnit();

    void setUnitPrice( const double _price );
    double getUnitPrice();
    xpError_t runDiscount( const double _discountPrice, const time_t _start, const time_t _end );
    void getDiscountInfo(  double *_discountPrice, time_t *_start, time_t *_end );
    void cancelDiscount();
    bool isDiscountExpired();
    bool isDiscountActive();
    double getSellingPrice();

    void setItemNum( const uint32_t _itemNum );
    uint32_t getItemNum();
    void setNumInstock( const uint32_t _numInstock );
    uint32_t getNumInstock();
    xpError_t addToStock( const uint32_t _add );
    xpError_t disqualifyFromStock( const uint32_t _sub );
    uint32_t getNumDisqualified();
    xpError_t sellFromStock( const uint32_t _sub );
    uint32_t getNumSold();


    static xpError_t searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName);    

private:
    std::string m_barcode;
    std::string m_name;
    std::string m_description;
    std::string m_unit;

    double m_unitPrice;
    double m_discountPrice;
    time_t m_discountStart;
    time_t m_discountEnd;

    uint32_t m_itemNum;
    uint32_t m_numInstock;
    uint32_t m_numSold;
    uint32_t m_numDisqualified;
};


}

#endif // PRODUCT_H
