#include "BackendInventory.h"

/**
 * @brief BackendInventory::BackendInventory
 */
BackendInventory::BackendInventory(QObject *parent) : QObject(parent)
{

}


/**
 * @brief BackendInventory::BackendInventory
 */
BackendInventory::BackendInventory(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB)
    : m_engine(engine), m_inventoryDB(_inventoryDB)
{
    LOG_MSG( "An Inventory backend has been created\n" );
}


/**
 * @brief BackendInventory::~BackendInventory
 */
BackendInventory::~BackendInventory()
{
    m_engine = nullptr;
    m_inventoryDB = nullptr;
}



/**
 * @brief BackendInventory::init
 */
int BackendInventory::init()
{
    //! TODO: Compute inventory status
    //!
    //===== I. Compute KPIs of the inventory
    xpError_t xpErr = m_inventoryDB->summaryInventory( m_kpi );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to summary inventory database\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    LOG_MSG( "TOTAL TYPES = %d\nTOTAL_VALUE = %f\nTOTAL_PROFIT=%f\n",
             m_kpi.typesNum, m_kpi.totalValue, m_kpi.totalProfit );
    for( int i = 0; i < m_kpi.categories.size(); i++ )
    {
        printf( "\tcategory = %d  - value = %10f  -  profit = %10f\n",
                m_kpi.categories[i], m_kpi.values[i], m_kpi.profits[i] );
    }




    return xpSuccess;
}

/**
 * @brief BackendInvoice::searchForProduct
 */
int BackendInventory::searchForProduct(QString _code)
{
    xpError_t xpErr = xpSuccess;
    if( !m_inventoryDB->isOpen() )
    {
        m_inventoryDB->open();
    }

    m_currProduct.setDefault();
    xpErr = m_inventoryDB->searchProductByBarcode( _code.toStdString(), m_currProduct );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to search for product\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( m_currProduct.isValid())
    {
        m_currProduct.printInfo();
        if( m_currProduct.isDiscountExpired() )
        {
            m_currProduct.cancelDiscount();
            xpErr |= m_inventoryDB->updateProduct( m_currProduct, false );
        }
        emit sigProductFound( m_currProduct.toQVariant() );
    }
    else
    {
        LOG_MSG( "[WAR] %s:%d: Product not found\n",
                 __FILE__, __LINE__ );
        emit sigProductNotFound( _code );
    }

    return xpErr;
}


/**
 * @brief BackendInvoice::updateProduct
 */
int BackendInventory::updateProduct( const QVariant &_product)
{
    xpos_store::Product beProduct;
    xpError_t xpErr = beProduct.fromQVariant( _product );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert Qvariant parameter to backend object\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( !m_inventoryDB->isOpen() )
    {
        m_inventoryDB->open();
    }

    if( m_currProduct.getBarcode() == "" ) // Product is not in database
    {
        xpErr = m_inventoryDB->insertProduct( beProduct );
    }
    else if( !beProduct.isIdenticalTo(m_currProduct) )
    {
        // Update info to already exist product
        xpErr = m_inventoryDB->updateProduct( beProduct, false );
    }

    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update product info to database\n",
                 xpErr, __FILE__, __LINE__ );
        emit sigUpdateFailed();
        return xpErr;
    }

    emit sigUpdateSucceeded();
    return xpSuccess;
}


/**
 * @brief BackendInventory::kpi
 */
QVariant BackendInventory::kpi()
{
    QVariantMap map;
    map["types_num"] = m_kpi.typesNum;
    map["total_values"] = m_kpi.totalValue;
    map["total_profit"] = m_kpi.totalProfit;
    map["total_lost"] = 0.0;

    QVariantList categories, values, profits, categoryNames;
    for( int i = 0; i < (int)m_kpi.values.size(); i++ )
    {
        categories << m_kpi.categories[i];
        values << m_kpi.values[i];
        profits << m_kpi.profits[i];
        if(  m_kpi.categories[i] != -1 )
        {
            categoryNames << QString::fromStdString(CATEGORIES_MAJOR_NAME[m_kpi.categories[i]]);
        }
        else
        {
            categoryNames << QString::fromStdString("None");
        }
    }
    map["categories"] = QVariant::fromValue(categories);
    map["category_names"] = QVariant::fromValue(categoryNames);
    map["values"] = QVariant::fromValue(values);
    map["profits"] = QVariant::fromValue(profits);

    return QVariant::fromValue(map);
}
