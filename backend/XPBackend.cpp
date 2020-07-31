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
        emit sigProductNotFound();
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
 * @brief XPBackend::initializePayment
 */
int XPBackend::initializePayment()
{
    m_currCustomer.setDefault();
    m_bill.setDefault();
    time_t now = time(NULL);
    m_bill.setCreationTime( now );
    m_bill.setStaffId( m_currStaff.getId() );

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
    QString test = QString("\n\n\n this is test string" ) + QString( ": test ok\n\n\n" );
    qWarning() << test;
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
 * @brief XPBackend::sellProduct
 */
int XPBackend::sellProduct(const QVariant &_qProduct, const int _numSold)
{
    xpos_store::Product product;
    xpError_t xpErr = product.fromQVariant( _qProduct );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert Qvariant parameter to backend object\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    // Update product quantity instock
    if( !m_inventoryDB->isOpen() )
    {
        m_inventoryDB->open();
    }

    xpErr |= product.sellFromStock( _numSold );
    xpErr |= m_inventoryDB->updateProduct( product, true );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update product info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    // Add selling record to current bill and save it to database
    xpos_store::SellingRecord record;
    record.setBillId( m_bill.getId() );
    record.setProductBarcode( product.getBarcode() );
    record.setQuantity( _numSold );
    record.setTotalPrice( (double)_numSold * product.getSellingPrice() );
    m_bill.addSellingRecord( (xpos_store::SellingRecord&)record );

    if( !m_sellingDB->isOpen() )
    {
        m_sellingDB->open();
    }

    xpErr |= m_sellingDB->insertSellingRecord( record );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update selling record info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief XPBackend::completePayment
 */
int XPBackend::completePayment( const QVariant &_qCustomer, const QVariant &_qPayment )
{
    xpError_t xpErr = xpSuccess;

    //===== Update customer in database
    xpos_store::Payment payment;
    xpos_store::Customer customer;
    xpErr |= customer.fromQVariant( _qCustomer );
    xpErr |= payment.fromQVariant( _qPayment );

    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert variable type\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    xpErr |= customer.makePayment( payment );
    if( customer.isValid() )
    {
        if( !m_usersDB->isOpen() )
        {
            m_usersDB->open();
        }

        if( m_currCustomer.getId() == customer.getId() )
        {
            xpErr = m_usersDB->updateCustomer( customer, true );
        }
        else
        {
            xpErr = m_usersDB->insertCustomer( customer );
        }

        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] %s:%d: Failed to update customer info to database\n",
                     xpErr, __FILE__, __LINE__ );
            return xpErr;
        }
    }


    //===== Send bill to maintenance server
    // create bill
    m_bill.setCustomerId( customer.getId() );
    m_bill.setPayment( payment );
    QString json = m_bill.toJSONString();

    // save bill to database
    if( !m_sellingDB->isOpen() )
    {
        m_sellingDB->open();
    }

    xpErr |= m_sellingDB->insertBill( m_bill );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to save bill to database\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    // http post
    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QNetworkAccessManager * manager = new QNetworkAccessManager(this);
    QUrl url("https://asia-east2-xposproject.cloudfunctions.net/addNewBill");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QByteArray jsonData= jsonDoc.toJson();
    manager->post(request, jsonData);

    return xpErr;
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
