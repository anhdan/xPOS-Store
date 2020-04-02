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
{
    m_billId = _invoice.m_billId;
    m_staffId = _invoice.m_staffId;
    m_customerId = _invoice.m_customerId;
    m_creationTime = _invoice.m_creationTime;
    m_usedPoints = _invoice.m_usedPoints;
    m_rewardedPoints = _invoice.m_rewardedPoints;
    m_productList = _invoice.m_productList;
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
    m_customerId = 0;
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
    // Check if the product is already in the list
    for( int i = 0; i < m_productList.size(); i++ )
    {
        if( _product.getCode() == m_productList[i].first.getCode() )
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

}
