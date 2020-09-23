#include "Bill.h"

namespace xpos_store {

/**
 * @brief Bill::setDefault
 */
void Bill::setDefault()
{
    m_staffId = m_customerId = "";
    m_creationTime = 0;
    m_products.clear();
    m_payment.setDefault();
    m_profit = 0;
}


/**
 * @brief Bill::copyTo
 */
void Bill::copyTo(Item *_item)
{
    if( _item )
    {
        Bill* bill = (Bill*)_item;
        bill->m_id = m_id;
        bill->m_staffId = m_staffId;
        bill->m_customerId = m_customerId;
        bill->m_creationTime = m_creationTime;
        m_payment.copyTo( &(bill->m_payment) );
        bill->m_profit = m_profit;
        bill->m_products = m_products;
    }
}


/**
 * @brief Bill::printInfo
 */
void Bill::printInfo()
{    
    LOG_MSG( "\n---------Bill---------\n" );
    LOG_MSG( ". ID:                 %s\n", m_id.c_str() );
    LOG_MSG( ". STAFF ID:           %s\n", m_staffId.c_str() );
    LOG_MSG( ". CUSTOMER ID:        %s\n", m_customerId.c_str() );
    LOG_MSG( ". CREATION TIME:      %ld\n", (unsigned long)m_creationTime );    
    m_payment.printInfo();
    LOG_MSG( ". PROFIT:             %f\n", m_profit );
    std::list<Product>::iterator it = m_products.begin();
    for( int id = 0; id < (int)m_products.size(); id++ )
    {
        it->printInfo();
    }
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Bill::toQVariant
 */
QVariant Bill::toQVariant( )
{
//    return QVariant::fromValue("");
}


/**
 * @brief Bill::fromQVariant
 */
xpError_t Bill::fromQVariant( const QVariant &_item )
{
    return xpSuccess;
}


/**
 * @brief Bill::isValid
 */
bool Bill::isValid()
{
    return (m_id != "");
}


/**
 * @brief Bill::setId
 */
void Bill::setId(const std::string &_id)
{
    m_id = _id;
}


/**
 * @brief Bill::getId
 */
std::string Bill::getId()
{
    return m_id;
}


/**
 * @brief Bill::setStaffId
 */
void Bill::setStaffId( const std::string &_staffId )
{
    m_staffId = _staffId;
    if( m_creationTime > 0 )
    {
        m_id = m_staffId + std::to_string( m_creationTime );
    }
}


/**
 * @brief Bill::getStaffId
 */
std::string Bill::getStaffId()
{
    return m_staffId;
}


/**
 * @brief Bill::setCustomerId
 */
void Bill::setCustomerId( const std::string &_custmerId )
{
    m_customerId = _custmerId;
}

/**
 * @brief Bill::getCustomerId
 */
std::string Bill::getCustomerId()
{
    return m_customerId;
}


/**
 * @brief Bill::setCreationTime
 */
void Bill::setCreationTime( const time_t _creationTime )
{
    m_creationTime = _creationTime;
    if( m_staffId != "" )
    {
        m_id = m_staffId + std::to_string( m_creationTime );
    }
}


/**
 * @brief Bill::getCreationTime
 */
time_t Bill::getCreationTime()
{
    return m_creationTime;
}


/**
 * @brief Bill::setPayment
 */
void Bill::setPayment( const Payment &_payment )
{
    ((Payment)_payment).copyTo( &m_payment );
}


/**
 * @brief Bill::getPayment
 */
void Bill::getPayment( Payment &_payment )
{
    m_payment.copyTo( &_payment );
}


/**
 * @brief Bill::addProduct
 */
xpError_t Bill::addProduct( Product &_product)
{
    m_products.push_back( _product );
    m_profit += _product.getItemNum() * (_product.getSellingPrice() - _product.getInputPrice());
    return xpSuccess;
}


/**
 * @brief Bill::getSellingRecords
 */
std::vector<SellingRecord> Bill::getSellingRecords()
{
    std::vector<SellingRecord> records;
    SellingRecord record;
    std::list<xpos_store::Product>::iterator it = m_products.begin();
    record.setBillId( m_id );
    record.setCreationTime( m_creationTime );
    for( int id = 0; id < (int)m_products.size(); id++ )
    {
        record.setProductBarcode( it->getBarcode() );
        record.setDescription( it->getName() );
        record.setTotalProfit( it->getItemNum() * (it->getSellingPrice() - it->getInputPrice()) );
        record.setTotalPrice( it->getSellingPrice() * it->getItemNum() );
        record.setDiscountPercent( it->getDiscountPercent() );
        records.push_back( record );
        std::advance( it, 1 );
    }

    return records;
}


/**
 * @brief Bill::getProfit
 */
double Bill::getProfit()
{
    return m_profit;
}

/**
 * @brief Bill::getJSONString
 */
QString Bill::toJSONString()
{
    std::cout << "print from inside\n";
    m_payment.printInfo();
    char cJSONStr[1000];
    sprintf( cJSONStr,  "{\n" \
                        "\"time\": %ld,\n" \
                        "\"store_id\": \"%s\",\n" \
                        "\"bill_id\": \"%s\",\n" \
                        "\"customer_id\": \"%s\",\n" \
                        "\"total_charging\": %f,\n" \
                        "\"tax\": %f,\n" \
                        "\"discount\": %f,\n" \
                        "\"used_point\": %d,\n" \
                        "\"rewarded_point\": %d,\n" \
                        "\"paying_method\": %d,\n" \
                        "\"paying_amount\": %f,\n" \
                        "\"products\":\n" \
                        "[\n", (uint64_t)m_creationTime, "65KWa1nJ5D6WhSMmQFqY", m_id.c_str(),
                        m_customerId.c_str(), m_payment.getTotalCharging(), m_payment.getTax(),
                        m_payment.getTotalDiscount(), m_payment.getUsedPoint(), m_payment.getRewardedPoint(),
                        (int)m_payment.getPayingMethod(), m_payment.getCustomerPayment() );
    QString qBillJSON = QString::fromStdString( std::string(cJSONStr) );

    std::list<xpos_store::Product>::iterator it = m_products.begin();
    for( int id = 0; id < (int)m_products.size()-1; id++ )
    {
        qBillJSON = qBillJSON + it->toJSONString() + QString(",\n");
        std::advance( it, 1 );
    }
    if( m_products.size() > 0 )
    {
        qBillJSON = qBillJSON + it->toJSONString() + QString("\n]\n}");
    }

    std::cout << qBillJSON.toStdString() << std::endl << std::endl;

    return qBillJSON;
}


/**
 * @brief Bill::toFirebaseVar
 * @return
 */
firebase::Variant Bill::toFirebaseVar()
{
    std::map<std::string, firebase::Variant> bill;
    bill["time"] = firebase::Variant( (long)m_creationTime );
    bill["store_id"] = firebase::Variant("6EGdPlfu70PvbnE6fHRk");
    bill["bill_id"] = firebase::Variant( m_id );
    bill["staff_name"] = firebase::Variant( "D.A Dan" );
    bill["customer_id"] = firebase::Variant( m_customerId );
    bill["total_charging"] = firebase::Variant( m_payment.getTotalCharging() );
    bill["tax"] = firebase::Variant( m_payment.getTax() );
    bill["discount"] = firebase::Variant( m_payment.getTotalDiscount() );
    bill["used_point"] = firebase::Variant( m_payment.getUsedPoint() );
    bill["rewarded_point"] = firebase::Variant( m_payment.getRewardedPoint() );
    bill["paying_method"] = firebase::Variant( (int)m_payment.getPayingMethod() );
    bill["paying_amount"] = firebase::Variant( m_payment.getCustomerPayment() );

    std::vector<firebase::Variant> fbProducts;
    std::map<std::string, firebase::Variant> fbProduct;
    std::list<xpos_store::Product>::iterator it = m_products.begin();
    for( int id = 0; id < (int)m_products.size()-1; id++ )
    {
        fbProduct["code"] = firebase::Variant( it->getBarcode() );
        fbProduct["name"] = firebase::Variant( it->getName() + " @ " + it->getUnit() );
        fbProduct["selling_price"] = firebase::Variant( it->getSellingPrice() );
        fbProduct["discount_percent"] = firebase::Variant( it->getDiscountPercent() );
        fbProduct["quantity"] = firebase::Variant( (int)it->getItemNum() );
        std::advance( it, 1 );
    }
    fbProducts.push_back( firebase::Variant( fbProduct ) );
    bill["products"] = firebase::Variant( fbProducts );

    return firebase::Variant( bill );
}


}
