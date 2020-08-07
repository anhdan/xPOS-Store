#include "Bill.h"

namespace xpos_store {

/**
 * @brief Bill::setDefault
 */
void Bill::setDefault()
{
    m_staffId = m_customerId = "";
    m_creationTime = 0;
    m_sellingRecords.clear();
    m_payment.setDefault();
}


/**
 * @brief Bill::copyTo
 */
void Bill::copyTo(Item *_item)
{
    if( _item )
    {
        Bill* bill = (Bill*)_item;
        bill->m_staffId = m_staffId;
        bill->m_customerId = m_customerId;
        bill->m_creationTime = m_creationTime;
    }
}


/**
 * @brief Bill::printInfo
 */
void Bill::printInfo()
{    
    LOG_MSG( "\n---------Bill---------\n" );
    LOG_MSG( ". STAFF ID:           %s\n", m_staffId.c_str() );
    LOG_MSG( ". CUSTOMER ID:        %s\n", m_customerId.c_str() );
    LOG_MSG( ". CREATION TIME:      %ld\n", (unsigned long)m_creationTime );
    m_payment.printInfo();
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief Bill::toQVariant
 */
QVariant Bill::toQVariant( )
{

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
 * @brief Bill::addSellingRecord
 */
xpError_t Bill::addSellingRecord( SellingRecord &_record)
{
    _record.setBillId( m_id );
    m_sellingRecords.push_back( _record );
    return xpSuccess;
}


/**
 * @brief Bill::compose
 */
xpError_t Bill::compose( const Staff &_staff, const Customer &_customer,
                   const Payment &_payment, const std::vector<SellingRecord> &_records )
{

    return xpSuccess;
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
                        "\"store_id\": %s,\n" \
                        "\"bill_id\": %s,\n" \
                        "\"staff_id\": %s,\n" \
                        "\"time\": %ld,\n" \
                        "\"post\": %d,\n" \
                        "\"customer_id\": %s,\n" \
                        "\"total_charging\": %f,\n" \
                        "\"discount\": %f,\n" \
                        "\"used_point\": %d,\n" \
                        "\"rewarded_point\": %d,\n" \
                        "\"products\":\n" \
                        "[\n", "1111", m_id.c_str(), m_staffId.c_str(), (uint64_t)m_creationTime,
                        1, m_customerId.c_str(), m_payment.getTotalCharging(), m_payment.getTotalDiscount(),
                        m_payment.getUsedPoint(), m_payment.getRewardedPoint() );
    QString qBillJSON = QString::fromStdString( std::string(cJSONStr) );

    std::list<xpos_store::SellingRecord>::iterator it = m_sellingRecords.begin();
    for( int id = 0; id < (int)m_sellingRecords.size()-1; id++ )
    {
        qBillJSON = qBillJSON + it->toJSONString() + QString(",\n");
        std::advance( it, 1 );
    }
    if( m_sellingRecords.size() > 0 )
    {
        qBillJSON = qBillJSON + it->toJSONString() + QString("\n]\n}");
    }

    std::cout << qBillJSON.toStdString() << std::endl << std::endl;

    return qBillJSON;
}


}
