#ifndef ITEM_H
#define ITEM_H

#include "backend/xPos.h"
#include <QObject>
#include <QVariant>
#include <QDateTime>

namespace xpos_store {

class Item
{
public:
    Item(){}
    ~Item(){}

public:
    virtual void setDefault() = 0;
    virtual void copyTo( Item *_item ) = 0;
    virtual void printInfo() = 0;
    virtual QVariant toQVariant( ) = 0;
    virtual xpError_t fromQVariant( const QVariant &_item ) = 0;
    virtual bool isValid() = 0;
};


}

#endif // ITEM_H
