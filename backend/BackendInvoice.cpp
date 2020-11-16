#include "BackendInvoice.h"

/**
 * @brief BackendInvoice::BackendInvoice
 */
BackendInvoice::BackendInvoice(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                     xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB )
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB), m_sellingDB(_sellingDB)
{
    m_fbApp = nullptr;
    m_fbAuth = nullptr;
    m_fbFunc = nullptr;
}


/**
 * @brief BackendInvoice::~BackendInvoice
 */
BackendInvoice::~BackendInvoice()
{
    m_engine = nullptr;
    m_inventoryDB = nullptr;
    m_usersDB = nullptr;
    m_sellingDB = nullptr;

    LOG_MSG("[DEB] %s:%d: Shutting down Firebase App.\n", __FUNCTION__, __LINE__ );
    delete m_fbFunc;
    m_fbFunc = nullptr;
    m_fbAuth->SignOut();
    delete m_fbAuth;
    m_fbAuth = nullptr;
    delete m_fbApp;
}


/**
 * @brief BackendInvoice::init
 * @return
 */
int BackendInvoice::init()
{

    //===== 2. Initialize firebase
    LOG_MSG( "[DEB] %s:%d: Initializing Firebase App.\n", __FUNCTION__, __LINE__ );
    m_fbApp = firebase::App::Create( firebase::AppOptions() );
    if( m_fbApp == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to initialized Firebase app\n",
                 xpErrorNotAllocated, __FILE__, __LINE__ );
        return xpErrorNotAllocated;
    }

    void* initialize_targets[] = {&m_fbAuth, &m_fbFunc};
    const firebase::ModuleInitializer::InitializerFn initializers[] = {
        [](::firebase::App* app, void* data) {
            void** targets = reinterpret_cast<void**>(data);
            ::firebase::InitResult result;
            *reinterpret_cast<::firebase::auth::Auth**>(targets[0]) =
            ::firebase::auth::Auth::GetAuth(app, &result);
            return result;
        },
        [](::firebase::App* app, void* data) {
            void** targets = reinterpret_cast<void**>(data);
            ::firebase::InitResult result;
            *reinterpret_cast<::firebase::functions::Functions**>(targets[1]) =
            ::firebase::functions::Functions::GetInstance(app, "asia-east2", &result);
            return result;
        }};

    firebase::ModuleInitializer initializer;
    initializer.Initialize(m_fbApp, initialize_targets, initializers,
                           sizeof(initializers) / sizeof(initializers[0]));
    float sWaitTime = 0;
    while( initializer.InitializeLastResult().status() == firebase::kFutureStatusPending )
    {
        usleep( 100000 );   // wait for initialization complete
        sWaitTime += 100000.0/1000000.0;
        if( sWaitTime > 5 ) // timeout
        {
            LOG_MSG( "[ERR:%d] %s:%d: Initialization timeout\n",
                     xpErrorTimeout, __FILE__, __LINE__ );
            return xpErrorTimeout;
        }
    }

    if (initializer.InitializeLastResult().error() != 0) {
        LOG_MSG( "[ERR:%d] %s:%d: to initialize Firebase libraries: %s\n",
                 xpErrorNotAllocated, __FILE__, __LINE__,
                 initializer.InitializeLastResult().error_message() );
        delete m_fbApp;
        return xpErrorNotAllocated;
    }


    //===== 3. Authenticate this app with server
    //! TODO:
    //!     - Read encrypt account from local database
    //!     - Decrypt to email and password to authenticate firebase
    std::string email = "anhdan.do@gmail.com";
    std::string pwd = "123456aA@";

    firebase::Future<firebase::auth::User*> result =
            m_fbAuth->SignInWithEmailAndPassword(email.c_str(), pwd.c_str());
    sWaitTime = 0;
    while( result.status() == firebase::kFutureStatusPending )
    {
        usleep( 100000 );   // wait for initialization complete
        sWaitTime += 100000.0/1000000.0;
        if( sWaitTime > 5 ) // timeout
        {
            LOG_MSG( "[ERR:%d] %s:%d: Authentication timeout\n",
                     xpErrorTimeout, __FILE__, __LINE__ );
            return xpErrorTimeout;
        }
    }

    if (result.error() == firebase::auth::kAuthErrorNone) {
        firebase::auth::User* user = *result.result();
        LOG_MSG( "[DEB] %s:%d: User sign-in succeeded for email %s\n",
                 __FUNCTION__, __LINE__, user->email().c_str());
    } else {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to authenticate user\n",
                 xpErrorUnAuthenticated, __FILE__, __LINE__ );
        return xpErrorUnAuthenticated;
    }


    LOG_MSG( "[DEB] %s:%d: An xpos-store backend has been created\n",
             __FUNCTION__, __LINE__ );
    return xpSuccess;
}


/**
 * @brief BackendInvoice::searchForProduct
 */
int BackendInvoice::searchForProduct(QString _code)
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
 * @brief BackendInvoice::initializePayment
 */
int BackendInvoice::initializePayment()
{
    m_currCustomer.setDefault();
    m_bill.setDefault();
    time_t now = time(NULL);
    m_bill.setCreationTime( now );
    m_bill.setStaffId( m_currStaff.getId() );

    return xpSuccess;
}


/**
 * @brief BackendInvoice::sellProduct
 */
int BackendInvoice::sellProduct(const QVariant &_qProduct, const int _numSold)
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

    xpErr |= m_sellingDB->insertSellingRecord( product, m_bill.getId(), m_bill.getCreationTime() );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to update selling record info to database\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief BackendInvoice::completePayment
 */
int BackendInvoice::completePayment( const QVariant &_qCustomer, const QVariant &_qPayment )
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

    //===== Send bill to maintenance server
    // create bill
    m_bill.setCustomerId( m_currCustomer.getId() );
    m_bill.setPayment( payment );
    // Add payment income to total earning of the current workshift and today shift
    xpErr |= m_currWorkshift.recordBill( m_bill );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to add payment to current workshift income\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

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

    // add bill using firebase functions
//    m_bill.toJSONString();
//    firebase::functions::HttpsCallableReference fbFunction
//            = m_fbFunc->GetHttpsCallable( "addNewBillCall" );
//    firebase::Future<firebase::functions::HttpsCallableResult> future
//            = fbFunction.Call( m_bill.toFirebaseVar() );
//    float sWaitTime = 0;
//    while( future.status() == firebase::kFutureStatusPending )
//    {
//        usleep( 100000 );   // wait for initialization complete
//        sWaitTime += 0.1;
//        if( sWaitTime > 5 ) // timeout
//        {
//            LOG_MSG( "[ERR:%d] %s:%d: Function invoking timeout\n",
//                     xpErrorTimeout, __FILE__, __LINE__ );
//            return xpErrorTimeout;
//        }
//    }

//    if (future.error() != firebase::functions::kErrorNone) {
//        LOG_MSG("[Err:%d] %s:%d: %s\n", xpErrorProcessFailure,
//               __FILE__, __LINE__, future.error_message());
//        return xpErrorProcessFailure;
//    } else {
//        firebase::Variant result = future.result()->data();
//        if( result.is_map() )
//        {
//            std::map<firebase::Variant, firebase::Variant> retMap = result.map();
//            if( retMap[firebase::Variant("status")].is_string() )
//            {
//                std::string retStatus = retMap[firebase::Variant("status")].string_value();
//                if( retStatus != "200" )
//                {
//                    LOG_MSG("[Err:%d] %s:%d: Server error response status %s\n",
//                           xpErrorProcessFailure, __FILE__, __LINE__, retStatus.c_str());
//                    return xpErrorProcessFailure;
//                }
//            }
//            else
//            {
//                LOG_MSG("[Err:%d] %s:%d: Invalid server response\n",
//                       xpErrorInvalidParameters, __FILE__, __LINE__ );
//                return xpErrorInvalidParameters;
//            }
//        }
//        else
//        {
//            LOG_MSG("[Err:%d] %s:%d: Invalid server response\n",
//                   xpErrorInvalidParameters, __FILE__, __LINE__ );
//            return xpErrorInvalidParameters;
//        }
//    }

    return xpErr;
}


/**
 * @brief BackendInvoice::login
 */
int BackendInvoice::login(QString _name, QString _pwd)
{
    //===== 1. Authenticate staff
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
 * @brief BackendInvoice::getPrivilege
 */
int BackendInvoice::getPrivilege()
{
    return (int)m_currStaff.getPrivilege();
}


/**
 * @brief BackendInvoice::logout
 */
int BackendInvoice::logout()
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
 * @brief BackendInvoice::searchForCustomer
 */
int BackendInvoice::searchForCustomer(QString _id)
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

    //===== Firebase request customer info
    std::map<std::string, firebase::Variant> userKeys;
    if(_id[0] == '0' || (_id[0] == '8' && _id[1] == '4'))
    {
        userKeys["phone"] = firebase::Variant( _id.toStdString() );
        userKeys["id"] = firebase::Variant( "" );
    }
    else
    {
        userKeys["phone"] = firebase::Variant( "" );
        userKeys["id"] = firebase::Variant( _id.toStdString() );
    }

    firebase::functions::HttpsCallableReference fbFuncGetUser
            = m_fbFunc->GetHttpsCallable( "getUserInfoCall" );
    firebase::Future<firebase::functions::HttpsCallableResult> future
            = fbFuncGetUser.Call( firebase::Variant( userKeys ) );
    float sWaitTime = 0;
    while( future.status() == firebase::kFutureStatusPending )
    {
        usleep( 100000 );   // wait for initialization complete
        sWaitTime += 0.1;
        if( sWaitTime > 5 ) // timeout
        {
            LOG_MSG( "[ERR:%d] %s:%d: Function invoking timeout\n",
                     xpErrorTimeout, __FILE__, __LINE__ );
            return xpErrorTimeout;
        }
    }

    if (future.error() != firebase::functions::kErrorNone)
    {
        LOG_MSG( "[ERR:%d] %s:%d: %s\n", xpErrorProcessFailure,
                 __FILE__, __LINE__, future.error_message() );
        return xpErrorProcessFailure;
    } else {
        firebase::Variant result = future.result()->data();
        std::map<firebase::Variant, firebase::Variant> retMap = result.map();
        if( retMap.count( firebase::Variant("status") ) > 0 )
        {
            std::string retStatus = retMap[firebase::Variant("status")].string_value();
            if( retStatus != "200" )
            {
                LOG_MSG( "[ERR:%d] %s:%d: Server response error %s\n",
                         xpErrorProcessFailure, __FILE__, __LINE__, retStatus.c_str() );
                return xpErrorProcessFailure;
            }

            if( retMap.count( firebase::Variant("info") ) > 0
                    && retMap[firebase::Variant("info")].is_map() )
            {
                // Parse return data for customer info
                std::map<firebase::Variant, firebase::Variant> infoMap
                        = retMap[firebase::Variant("info")].map();

                bool isInfoValid = true;
                if( isInfoValid &= infoMap[firebase::Variant("code")].is_string() )
                {
                    m_currCustomer.setId( infoMap[firebase::Variant("code")].string_value() );
                }

                if( isInfoValid &= infoMap[firebase::Variant("name")].is_string() )
                {
                    m_currCustomer.setName( infoMap[firebase::Variant("name")].string_value() );
                }

                if( isInfoValid &= infoMap[firebase::Variant("phone_number")].is_string() )
                {
                    m_currCustomer.setPhone( infoMap[firebase::Variant("phone_number")].string_value() );
                }

                if( isInfoValid &= infoMap[firebase::Variant("point")].is_int64() )
                {
                    m_currCustomer.setRewardedPoint( (int)infoMap[firebase::Variant("point")].int64_value() );
                }

                // Emit customer found signal
                if( isInfoValid )
                {
                    emit sigCustomerFound( m_currCustomer.toQVariant() );
                }
                else
                {
                    LOG_MSG( "[ERR:%d] %s:%d: Invalid return data\n",
                             xpErrorInvalidParameters, __FILE__, __LINE__);
                    return xpErrorInvalidParameters;
                }
            }
            else
            {
                LOG_MSG( "[ERR:%d] %s:%d: Invalid return data\n",
                         xpErrorInvalidParameters, __FILE__, __LINE__);
                return xpErrorInvalidParameters;
            }
        }
        else
        {
            LOG_MSG( "[ERR:%d] %s:%d: Invalid return data\n",
                     xpErrorInvalidParameters, __FILE__, __LINE__);
            return xpErrorInvalidParameters;
        }
    }


    return xpSuccess;
}

/**
 * @brief BackendInvoice::getPoint2MoneyRate
 */
double BackendInvoice::getPoint2MoneyRate()
{
    //! TODO:
    //! Use a CURRENCY table to store conversion rate of many currency
    return 1000.0;
}
