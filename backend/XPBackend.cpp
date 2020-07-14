#include "XPBackend.h"

/**
 * @brief XPBackend::XPBackend
 */
XPBackend::XPBackend(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                     xpos_store::UserDatabase *_usersDB)
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB)
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

    std::cout << "--------> input code = " << _code.toStdString() << std::endl;

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
