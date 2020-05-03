#include "InventoryProcess.h"

/**
 * @brief InventoryProcess::InventoryProcess
 */
InventoryProcess::InventoryProcess(QObject *parent) : QObject(parent)
{

}


/** ================================================================
 *
 * Define properties methods
 *
 *=================================================================*/
/**
 * @brief InventoryProcess::code
 */
QString InventoryProcess::code()
{
    return QString::fromStdString( m_currProduct.getCode() );
}

/**
 * @brief InventoryProcess::setCode
 */
void InventoryProcess::setCode(const QString _code)
{
    m_currProduct.setCode( _code.toStdString() );
    emit codeChanged();
}


/**
 * @brief InventoryProcess::name
 */
QString InventoryProcess::name()
{
    return QString::fromStdString( m_currProduct.getName() );
}


/**
 * @brief InventoryProcess::setName
 */
void InventoryProcess::setName(const QString _name)
{
    m_currProduct.setName( _name.toStdString() );
    emit nameChanged();
}


/**
 * @brief InventoryProcess::category
 */
int InventoryProcess::category()
{
    return (int)m_currProduct.getCategory();
}


/**
 * @brief InventoryProcess::setCategory
 */
void InventoryProcess::setCategory(const int _category)
{
    m_currProduct.setCategory( _category );
    emit categoryChanged();
}


/**
 * @brief InventoryProcess::description
 */
QString InventoryProcess::description()
{
    return QString::fromStdString( m_currProduct.getDescription() );
}


/**
 * @brief InventoryProcess::setDescription
 */
void InventoryProcess::setDescription(const QString _desc)
{
    m_currProduct.setDescription( _desc.toStdString() );
    emit descriptionChanged();
}


/**
 * @brief InventoryProcess::unitName
 */
int InventoryProcess::unitName()
{
    return (int)m_currProduct.getUnit();
}


/**
 * @brief InventoryProcess::setUnitName
 */
void InventoryProcess::setUnitName(const int _unitName)
{
    m_currProduct.setUnit( _unitName );
    emit unitNameChanged();
}


/**
 * @brief InventoryProcess::unitPrice
 */
double InventoryProcess::unitPrice()
{
    return m_currProduct.getUnitPrice();
}


/**
 * @brief InventoryProcess::setUnitPrice
 */
void InventoryProcess::setUnitPrice(const double _unitPrice)
{
    m_currProduct.setUnitPrice( _unitPrice );
}


/**
 * @brief InventoryProcess::discountPrice
 */
QString InventoryProcess::discountPrice()
{
    if( m_currProduct.isInDiscountProgram() )
    {
        double price;
        m_currProduct.getDiscountInfo( &price, nullptr, nullptr );
        return QString::fromStdString( std::to_string(price) );
    }
    else
    {
        return "";
    }
}


/**
 * @brief InventoryProcess::discountStart
 */
QString InventoryProcess::discountStart()
{
    if( m_currProduct.isInDiscountProgram() )
    {
        time_t start_t;
        m_currProduct.getDiscountInfo( nullptr, &start_t, nullptr );
        std::tm *ptm = std::localtime(&start_t);
        char buffer[32];
        std::strftime(buffer, 32, "%Y-%m-%d %H:%M:%S", ptm);
        return QString::fromStdString( std::string(buffer) );
    }
    else
    {
        return "";
    }
}


/**
 * @brief InventoryProcess::discountEnd
 */
QString InventoryProcess::discountEnd()
{
    if( m_currProduct.isInDiscountProgram() )
    {
        time_t end_t = 0;
        m_currProduct.getDiscountInfo( nullptr, &end_t, nullptr );
        std::tm *ptm = std::localtime(&end_t);
        char buffer[32];
        std::strftime(buffer, 32, "%Y-%m-%d %H:%M:%S", ptm);
        return QString::fromStdString( std::string(buffer) );
    }
    else
    {
        return "";
    }
}


/**
 * @brief InventoryProcess::quantityInstock
 */
QString InventoryProcess::quantityInstock()
{
    return QString::fromStdString( std::to_string( m_currProduct.getQuantityInstock() ) );
}


/**
 * @brief InventoryProcess::quantitySold
 */
QString InventoryProcess::quantitySold()
{
    return QString::fromStdString( std::to_string( m_currProduct.getQuantitySold() ) );
}



/** ================================================================
 *
 * Define invokable callbacks to process signals from Inventory GUI
 *
 *=================================================================*/

/**
 * @brief InventoryProcess::invockSearch
 */
int InventoryProcess::invokSearch(QString _code)
{
    if( !glbProductDB->isOpen() )
    {
        glbProductDB->open();
    }
    xpos_store::Table *table = glbProductDB->getTableByName( "PRODUCT" );
    if( table == nullptr )
    {
        glbProductDB->close();
        LOG_MSG( "[ERR:%d] %s:%d: Failed to connect to database\n", xpErrorNotExist, __FILE__, __LINE__);
        return xpErrorNotExist;
    }

    xpos_store::Product *prod = xpos_store::Product::searchInDatabase( table, _code.toStdString() );
    if( prod == nullptr )
    {
        m_found = false;
        m_currProduct.setDefault();
        m_currProduct.setCode( _code.toStdString() );
    }
    else
    {
        m_found = true;
        prod->copyTo( m_currProduct );
        delete prod;
    }

    LOG_MSG( "In Search\n" );
    m_currProduct.printInfo();

    glbProductDB->close();
    emit sigSearchCompleted();

    return xpSuccess;
}


/**
 * @brief InventoryProcess::invockUpdate
 */
int InventoryProcess::invokUpdate()
{
    if( !glbProductDB->isOpen() )
    {
        glbProductDB->open();
    }
    xpos_store::Table *table = glbProductDB->getTableByName( "PRODUCT" );
    if( table == nullptr )
    {
        glbProductDB->close();
        LOG_MSG( "[ERR:%d] %s:%d: Failed to connect to database\n", xpErrorNotExist, __FILE__, __LINE__);
        return xpErrorNotExist;
    }

    LOG_MSG( " In InvokUpdate\n" );
    m_currProduct.printInfo();

    xpError_t err = xpSuccess;
    if( m_found )
    {
        // Update info
        err |= m_currProduct.updateBasicInfoInDB( table );
        err |= m_currProduct.updatePriceInDB( table );
        err |= m_currProduct.updateQuantityInDB( table );
        err |= m_currProduct.updateVendorsInDB( table );
    }
    else
    {
        err |= m_currProduct.insertToDatabase( table );
    }

    if( err != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update info of product to database\n", xpErrorProcessFailure, __FILE__, __LINE__);
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}
