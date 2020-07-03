#ifndef INVENTORYDATABASE_H
#define INVENTORYDATABASE_H

#include "backend/xPos.h"
#include "backend/database/Database.h"
#include "backend/containers/Product.h"

namespace xpos_store {

class InventoryDatabase : public Database
{
public:
    InventoryDatabase() : Database() {}
    InventoryDatabase( const InventoryDatabase &_db );
    ~InventoryDatabase() {}

public:
    xpError_t create(const std::string &_dbPath);

    xpError_t searchProductByBarcode( const std::string &_barcode,  Product &_product );
    xpError_t insertProduct( Product &_product );
    xpError_t deleteProductByBarcode( const std::string &_barcode );
    xpError_t updateProduct( Product &_productInfo, bool _isQuantityOnly=true );
};

}

#endif // INVENTORYDATABASE_H
