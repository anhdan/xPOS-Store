#include "XPBackend.h"

/**
 * @brief XPBackend::XPBackend
 */
XPBackend::XPBackend(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                     xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB )
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB), m_sellingDB(_sellingDB)
{
    LOG_MSG( "[DEB]: an xpos-store backend has been created\n" );
}


/**
 * @brief XPBackend::~XPBackend
 */
XPBackend::~XPBackend()
{
    m_engine = nullptr;
    m_inventoryDB = nullptr;
    m_usersDB = nullptr;
    m_sellingDB = nullptr;
}


/**
 * @brief XPBackend::searchForProduct
 */
int XPBackend::searchForProduct(QString _code)
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

    if( m_currProduct.getBarcode() == "" )
    {
        LOG_MSG( "[WAR] %s:%d: Product not found\n",
                 __FILE__, __LINE__ );
        emit sigProductNotFound();
    }
    else
    {
        m_currProduct.printInfo();
        emit sigProductFound( m_currProduct.toQVariant() );
    }

    return xpErr;
}


/**
 * @brief XPBackend::updateProductFromInventory
 */
int XPBackend::updateProductFromInventory( const QVariant &_product)
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
        return xpErr;
    }

    return xpSuccess;
}


/**
 * @brief XPBackend::updateProductFromInvoice
 */
int XPBackend::updateProductFromInvoice(const QVariant &_product)
{
    xpos_store::Product beProduct;
    xpError_t xpErr = beProduct.fromQVariant( _product );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert Qvariant parameter to backend object\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    QVariantMap map = _product.toMap();
    bool ret = true;
    int itemNum = map["item_num"].toInt( &ret );
    LOG_MSG( "item_num = %d\n", itemNum );
    if( ret == false )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to get object property\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    if( !m_inventoryDB->isOpen() )
    {
        m_inventoryDB->open();
    }

    xpErr |= beProduct.sellFromStock( itemNum );
    xpErr |= m_inventoryDB->updateProduct( beProduct, true );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update product info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief XPBackend::httpPostInvoice
 */
int XPBackend::httpPostInvoice()
{
    QString val;
    QFile file;
    file.setFileName("bill.json");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    val = file.readAll();
    file.close();
    qWarning() << val;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(val.toUtf8());


    QNetworkAccessManager * manager = new QNetworkAccessManager(this);

    QUrl url("https://asia-east2-xposproject.cloudfunctions.net/addNewBill");
    QNetworkRequest request(url);

//    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("Content-Type: application/json"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
//    request.setHeader(QNetworkRequest::ContentTypeHeader, "text/plain");
    QByteArray jsonData= jsonDoc.toJson();
//    manager->post(request, "{\"item\":\"dando\"}");
    manager->post(request, jsonData);


    return xpSuccess;
}


/**
 * @brief XPBackend::login
 */
int XPBackend::login(QString _name, QString _pwd)
{
    bool authenticated = false;
    m_currStaff.setLoginName( _name.toStdString() );
    m_currStaff.setLoginPwd( _pwd.toStdString() );
    xpError_t xpErr = m_usersDB->verifyStaff( m_currStaff, &authenticated );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to verify staff\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( authenticated )
    {
        emit sigStaffApproved();
    }
    else
    {
        emit sigStaffDisapproved();
    }

    return xpSuccess;
}


/**
 * @brief XPBackend::getPrivilege
 */
int XPBackend::getPrivilege()
{
    return (int)m_currStaff.getPrivilege();
}


/**
 * @brief XPBackend::searchForCustomer
 */
int XPBackend::searchForCustomer(QString _id)
{
    xpError_t xpErr = xpSuccess;
    if( !m_usersDB->isOpen() )
    {
        m_usersDB->open();
    }

    m_currCustomer.setDefault();
    xpErr = m_usersDB->searchCustomer( _id.toStdString(), m_currCustomer );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to search for customer\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( m_currCustomer.getId() == "" )
    {
        LOG_MSG( "[WAR] %s:%d: Customer not found\n",
                 __FILE__, __LINE__ );
        emit sigCustomerNotFound();
    }
    else
    {
        m_currCustomer.printInfo();
        emit sigCustomerFound( m_currCustomer.toQVariant() );
    }

    return xpErr;
}


/**
 * @brief XPBackend::updateCustomerFromInvoice
 */
int XPBackend::updateCustomerFromInvoice(const QVariant &_customer)
{
    //! TODO:
    //! Implement this
    xpos_store::Customer beCustomer;
    xpError_t xpErr = beCustomer.fromQVariant( _customer );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert Qvariant parameter to backend object\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( !m_usersDB->isOpen() )
    {
        m_usersDB->open();
    }

    if( beCustomer.getId() != "" )
    {
        if( m_currCustomer.getId() == beCustomer.getId() )
        {
            xpErr = m_usersDB->updateCustomer( beCustomer, true );
        }
        else
        {
            xpErr = m_usersDB->insertCustomer( beCustomer );
        }
    }

    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update customer info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief XPBackend::getPoint2MoneyRate
 */
double XPBackend::getPoint2MoneyRate()
{
    //! TODO:
    //! Use a CURRENCY table to store conversion rate of many currency
    return 1000.0;
}
