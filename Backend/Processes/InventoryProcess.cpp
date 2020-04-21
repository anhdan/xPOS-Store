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
    return xpSuccess;
}


/**
 * @brief InventoryProcess::invockUpdate
 */
xpError_t InventoryProcess::invockUpdate()
{
    return xpSuccess;
}
