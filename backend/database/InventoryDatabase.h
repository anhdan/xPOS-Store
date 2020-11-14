#ifndef INVENTORYDATABASE_H
#define INVENTORYDATABASE_H

#include "backend/xPos.h"
#include "backend/database/Database.h"
#include "backend/containers/Product.h"

namespace xpos_store {

/**
 * @brief The InventoryKPI class
 */
class InventoryKPI {
public:
    int typesNum = 0;
    double totalValue = 0;
    double totalProfit = 0;
    double totalLost = 0;

    std::vector<double> values;
    std::vector<double> profits;
    std::vector<int> categories;

    void setDefault()
    {
        typesNum = 0;
        totalValue = 0;
        totalProfit = 0;
        totalLost = 0;
        values.clear();
        profits.clear();
        categories.clear();
    }
};


/**
 * @brief The InventoryDatabase class
 */
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

    xpError_t summaryInventory( InventoryKPI &kpi );
};

}

#endif // INVENTORYDATABASE_H
