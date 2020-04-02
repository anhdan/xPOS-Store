#ifndef INVOICE_H
#define INVOICE_H

#include "SellingRecord.h"
#include "Product.h"
#include "Point.h"

namespace xpos_store
{

class Invoice
{
public:
    Invoice();
    Invoice( const Invoice &_invoice );
    ~Invoice() {}

protected:
    void setDefault();

public:
    xpError_t addProduct( const Product &_product );
    xpError_t deleteProduct( const int _idxInList );
    xpError_t increaseProductQuantity( const int _idxInList );
    xpError_t decreaseProductQuantity( const int _idxInList );
    xpError_t setProductQuantity( const int _idxInList, const uint32_t _quantity );

    xpError_t pay();
    xpError_t printInvoice();

private:
    uint64_t m_billId;
    uint64_t m_staffId;
    uint64_t m_customerId;
    time_t m_creationTime;
    Point m_usedPoints;
    Point m_rewardedPoints;
    std::list<std::pair<Product,uint32_t>> m_productList;     /**< List of item in the invoice */
    double m_totalDiscount;
    double m_totalExpense;
};

}

#endif // INVOICE_H
