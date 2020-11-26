#ifndef UPDATERECORD_H
#define UPDATERECORD_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"

namespace xpos_store {

class UpdateRecord : public Item
{
public:
    UpdateRecord() : Item()
    {
        setDefault();
    }
    ~UpdateRecord(){}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();
    QString toJSONString();

public:
    void setBarcode( const std::string &_barcode );
    std::string getBarcode();
    void setUpdateDate( const uint64_t _updateDate );
    uint64_t getUpdateDate();
    void setExpiredDate( const uint64_t _expiredDate );
    uint64_t getExpiredDate();
    void setQuantity( const int _quantity );
    int getQuantity();

private:
    std::string m_barcode;
    uint64_t m_updateDate;
    uint64_t m_expiredDate;
    int m_quantity;
};
	
}

#endif
