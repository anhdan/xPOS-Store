#include "InventoryProcess.h"

/**
 * @brief InventoryProcess::InventoryProcess
 */
InventoryProcess::InventoryProcess(QObject *parent) : QObject(parent)
{

}


/**
 * @brief InventoryProcess::invockSearch
 */
xpError_t InventoryProcess::invockSearch(QString _code)
{
    xpos_store::Table *table = glbProductDB->getTableByName( "PRODUCT" );
    if( table == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to connect to database\n", xpErrorNotExist, __FILE__, __LINE__);
        return xpErrorNotExist;
    }

    xpos_store::Product *prod = xpos_store::Product::searchInDatabase( table, _code.toStdString() );
    if( prod == nullptr )
    {
        m_currProduct.setDefault();
        m_currProduct.setCode( _code.toStdString() );
    }
    else
    {
        prod->copyTo( m_currProduct );
        delete prod;
    }

    emit sigSearchCompleted();

    return xpSuccess;
}


/**
 * @brief InventoryProcess::invockUpdate
 */
xpError_t InventoryProcess::invockUpdate()
{
    return xpSuccess;
}
