#include "Bill.h"

namespace xpos_store {

/**
 * @brief Bill::setDefault
 */
void Bill::setDefault()
{
    m_staffId = m_customerId = "";
    m_creationTime = 0;

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
    return ((m_staffId != "") && (m_creationTime > 0));
}


/**
 * @brief Bill::setStaffId
 */
void Bill::setStaffId( const std::string &_staffId )
{
    m_staffId = _staffId;
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
 * @brief Bill::compose
 */
xpError_t Bill::compose( const Staff &_staff, const Customer &_customer,
                   const Payment &_payment, const std::vector<Product> &_products )
{

    return xpSuccess;
}


/**
 * @brief Bill::getJSONString
 */
std::string Bill::getJSONString()
{

    return "Implement this";
}

}
