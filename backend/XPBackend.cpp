#include "XPBackend.h"

/**
 * @brief XPBackend::XPBackend
 */
XPBackend::XPBackend(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                     xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB )
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB), m_sellingDB(_sellingDB)
{
    // Initialize network manager
    m_httpManager = new QNetworkAccessManager(this);
//    QObject::connect(m_httpManager, &QNetworkAccessManager::finished,
//                     this, [=](QNetworkReply *reply) {
//        if (reply->error()) {
//            qDebug() << reply->errorString();
//            return;
//        }

//        QString answer = reply->readAll();

//        qDebug() << answer;
//    }
//    );
    QObject::connect(m_httpManager, &QNetworkAccessManager::finished,
                     this, &XPBackend::httpReplyFinished );

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
    delete m_httpManager;
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

    QUrl url("https://asia-east2-xposproject.cloudfunctions.net/addNewBill");
    QNetworkRequest request(url);

//    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("Content-Type: application/json"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
//    request.setHeader(QNetworkRequest::ContentTypeHeader, "text/plain");
    QByteArray jsonData= jsonDoc.toJson();
    m_httpManager->post(request, jsonData);


    return xpSuccess;
}


/**
 * @brief XPBackend::httpRequestCustomer
 */
int XPBackend::httpRequestCustomer(xpos_store::Customer &_customer)
{
    // Set query params
    QUrlQuery query;
    query.addQueryItem( "id", QString::fromStdString(_customer.getId()) );
    query.addQueryItem( "phone", QString::fromStdString(_customer.getPhone()) );

    // Send request
    QUrl url("https://asia-east2-xposproject.cloudfunctions.net/getUserInfo");
    url.setQuery( query );
    QNetworkRequest request(url);
//    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_httpManager->get( request );

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

    xpErr |= product.sellFromStock( product.getItemNum() );
    xpErr |= m_inventoryDB->updateProduct( product, true );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update product info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    // Add selling record to current bill and save it to database
    m_bill.addProduct( (xpos_store::Product&)product );

    if( !m_sellingDB->isOpen() )
    {
        m_sellingDB->open();
    }

    xpErr |= m_sellingDB->insertSellingRecord( product, m_bill.getId() );
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
    xpErr |= payment.fromQVariant( _qPayment );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert variable type\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( m_currCustomer.isValid() )
    {
        xpErr |= m_currCustomer.makePayment( payment );

        if( !m_usersDB->isOpen() )
        {
            m_usersDB->open();
        }

        if( m_currCustomer.getShoppingCount() > 1 )
        {
            xpErr = m_usersDB->updateCustomer( m_currCustomer, true );
        }
        else
        {
            xpErr = m_usersDB->insertCustomer( m_currCustomer );
        }

        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] %s:%d: Failed to update customer info to database\n",
                     xpErr, __FILE__, __LINE__ );
            return xpErr;
        }
    }

    //===== Add payment income to total earning of the current workshift
    xpErr |= m_currWorkshift.increaseEarning( payment.getTotalCharging() );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to add payment to current workshift income\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    //===== Send bill to maintenance server
    // create bill
    m_bill.setCustomerId( m_currCustomer.getId() );
    m_bill.setPayment( payment );

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

    // http post bill
    QString json = m_bill.toJSONString();
    qDebug() << json;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QUrl url("https://asia-east2-xposproject.cloudfunctions.net/addNewBill");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QByteArray jsonData= jsonDoc.toJson();
    m_httpManager->post(request, jsonData);

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
        m_currWorkshift.printInfo();
        xpErr |= m_currWorkshift.start( m_currStaff.getId() );
    }
    else
    {
        emit sigStaffDisapproved();
    }

    return xpErr;
}


/**
 * @brief XPBackend::getPrivilege
 */
int XPBackend::getPrivilege()
{
    return (int)m_currStaff.getPrivilege();
}


/**
 * @brief XPBackend::logout
 */
int XPBackend::logout()
{
    // End workshift and store to database
    xpError_t xpErr = xpSuccess;
    xpErr |= m_currWorkshift.end();
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to end workshift\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    if( !m_sellingDB->isOpen() )
    {
        xpErr |= m_sellingDB->open();
    }
    xpErr |= m_sellingDB->insertWorkShift( m_currWorkshift );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to store workshift to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief XPBackend::searchForCustomer
 */
int XPBackend::searchForCustomer(QString _id)
{    
    //===== Check the existence of this customer in local database
    xpError_t xpErr = xpSuccess;
    if( !m_usersDB->isOpen() )
    {
        m_usersDB->open();
    }

    xpos_store::Customer customer;
    xpErr = m_usersDB->searchCustomer( _id.toStdString(), customer );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to search for customer\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }
    customer.printInfo();

    if( customer.isValid() )
    {
        customer.copyTo( (xpos_store::Item*)&m_currCustomer );
    }

    //===== Request customer info from xPOS Bank
    m_currCustomer.setId( _id.toStdString() );
    httpRequestCustomer( m_currCustomer );

    return xpSuccess;
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


/**
 * @brief XPBackend::httpReplyFinished
 */
void XPBackend::httpReplyFinished(QNetworkReply *_reply )
{
    if (_reply->error()) {
        qDebug() << _reply->errorString();
        _reply->deleteLater();
        return;
    }

    // Json parsing
    QString answer = _reply->readAll();
    QJsonParseError jsonErr;
    QJsonDocument jsonDoc = QJsonDocument::fromJson( answer.toUtf8(), &jsonErr );
    if( jsonErr.error != QJsonParseError::NoError )
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n",
                 xpErrorProcessFailure, __FILE__, __LINE__, jsonErr.errorString().toStdString().c_str() );
        _reply->deleteLater();
        return;
    }

    QVariant jsonVar = jsonDoc.toVariant();
    if( jsonVar.canConvert<QVariantMap>() )
    {
        QVariantMap map = jsonVar.toMap();
        if( !map.empty() )
        {
            m_currCustomer.setName( map["name"].toString().toStdString() );
            m_currCustomer.setPhone( map["phone_number"].toString().toStdString() );
            int ix =0;
            bool ret = true;
            ix = map["point"].toString().toInt( &ret );
            m_currCustomer.setRewardedPoint( ix );
            if( !ret )
            {
                m_currCustomer.setDefault();
                LOG_MSG( "[WAR] %s:%d: Customer not found\n",
                         __FILE__, __LINE__ );
                emit sigCustomerNotFound();
                _reply->deleteLater();
                return;
            }
            m_currCustomer.printInfo();

            emit sigCustomerFound( m_currCustomer.toQVariant() );
        }
        else
        {
            m_currCustomer.setDefault();
            LOG_MSG( "[WAR] %s:%d: Customer not found\n",
                     __FILE__, __LINE__ );
            emit sigCustomerNotFound();
        }
    }
    else
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert QVariant to QVariantMap\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
    }

    _reply->deleteLater();
    return;
}
