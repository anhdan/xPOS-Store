#include "Invoice.h"


namespace xpos_store
{

/**
 * @brief Invoice::Invoice
 */
Invoice::Invoice()
{
    setDefault();
}


/**
 * @brief Invoice::Invoice
 */
Invoice::Invoice(const Invoice &_invoice)
    : m_customer(_invoice.m_customer), m_productList(_invoice.m_productList)
{
    m_billId = _invoice.m_billId;
    m_staffId = _invoice.m_staffId;
    m_creationTime = _invoice.m_creationTime;
    m_usedPoints = _invoice.m_usedPoints;
    m_rewardedPoints = _invoice.m_rewardedPoints;
    m_totalDiscount = _invoice.m_totalDiscount;
    m_totalExpense = _invoice.m_totalExpense;
}


/**
 * @brief Invoice::setDefault
 */
void Invoice::setDefault()
{
    m_billId = 0;
    m_staffId = 0;
    m_creationTime = 0;
    m_usedPoints = 0;
    m_rewardedPoints = 0;
    m_productList.clear();
    m_totalDiscount = 0.0;
    m_totalExpense = 0.0;
}


/**
 * @brief Invoice::addProduct
 */
xpError_t Invoice::addProduct(const Product &_product)
{
    Product copyProd(_product);
    // Check if the product is already in the list
    for( int i = 0; i < m_productList.size(); i++ )
    {
        if( copyProd.getCode() == m_productList[i].first.getCode() )
        {
            m_productList[i].second++;
            return xpSuccess;
        }
    }

    // Add new product to the list
    std::pair<Product, uint32_t> newItem( _product, 1 );
    m_productList.push_back( newItem );
    return xpSuccess;
}


/**
 * @brief Invoice::deleteProduct
 */
xpError_t Invoice::deleteProduct(const int _idxInList)
{
    if( (_idxInList < 0) || (_idxInList >= m_productList.size()) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid index value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_productList.erase( m_productList.begin() + _idxInList );
    return xpSuccess;
}


/**
 * @brief Invoice::increaseProductQuantity
 */
xpError_t Invoice::increaseProductQuantity(const int _idxInList)
{
    if( (_idxInList < 0) || (_idxInList >= m_productList.size()) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid index value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    uint32_t newQuantity = m_productList[_idxInList].second + 1;
    if( newQuantity > m_productList[_idxInList].first.getQuantityInstock() )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The quantity of this product in stock is not enough\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_productList[_idxInList].second = newQuantity;
    return xpSuccess;
}


/**
 * @brief Invoice::decreaseProductQuantity
 */
xpError_t Invoice::decreaseProductQuantity(const int _idxInList)
{
    if( (_idxInList < 0) || (_idxInList >= m_productList.size()) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid index value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    if( m_productList[_idxInList].second > 0 )
    {
        m_productList[_idxInList].second--;
    }
    return xpSuccess;
}


/**
 * @brief Invoice::setProductQuantity
 */
xpError_t Invoice::setProductQuantity(const int _idxInList, const uint32_t _quantity)
{
    if( (_idxInList < 0) || (_idxInList >= m_productList.size()) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid index value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    if( (_quantity < 0) || (_quantity > m_productList[_idxInList].first.getQuantityInstock()) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The quantity of this product in stock is not enough\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_productList[_idxInList].second = _quantity;
    return xpSuccess;
}


/**
 * @brief Invoice::addCustomer
 */
xpError_t Invoice::addCustomer(const uint64_t _customerId)
{
    //TODO: Implement this methods
    //      - Get customer info from database
    return xpSuccess;
}


/**
 * @brief Invoice::useCustomerPoint
 */
xpError_t Invoice::useCustomerPoint(const Point &_point)
{
    if( ((Point)_point < 0) || ((Point)_point > m_customer.getPoint() ) )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid point value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_usedPoints = _point;
    m_totalDiscount = ((Point)_point).toMoney();
    m_totalExpense -= m_totalDiscount;
    return m_customer.usePoint( _point );
}


/**
 * @brief Invoice::pay
 */
xpError_t Invoice::pay()
{
    //TODO: Implement this methods
    //      - Update quantity of products in database

    // Creation time
    m_creationTime = time( NULL );

    return xpSuccess;
}


/**
 * @brief Invoice::printInvoice
 */
xpError_t Invoice::sendInvoice()
{
    //TODO: Implement this methods
    //      - Send the invoice to maintenance server
    return xpSuccess;
}


/**
 * @brief Invoice::createSellingrecord
 */
std::vector<SellingRecord> Invoice::createSellingrecord()
{
    std::vector<SellingRecord> _sellingRecord(m_productList.size());
    std::string productCode;
    uint32_t quantity;
    double totalPrice;
    for( int idx = 0; idx < m_productList.size(); idx++ )
    {
        productCode = m_productList[idx].first.getCode();
        quantity = m_productList[idx].second;
        if( m_productList[idx].first.isInDiscountProgram() )
        {
            m_productList[idx].first.getDiscountInfo( &totalPrice, NULL, NULL );
            totalPrice = (double)quantity * totalPrice;
        }
        else
        {
            totalPrice = (double)quantity * m_productList[idx].first.getUnitPrice();
        }
        SellingRecord record( m_billId, productCode, quantity, totalPrice );
        _sellingRecord.push_back( record );
    }

    return _sellingRecord;
}


}
