#ifndef INVOICE_H
#define INVOICE_H

#include "SellingRecord.h"
#include "Product.h"
#include "Customer.h"
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

    inline double getTotalExpense() { return m_totalExpense; }
    inline double getTotalDiscount() { return m_totalDiscount; }
    inline Point getUsedPoints() { return m_usedPoints; }
    inline Point getRewardPoints() {return m_rewardedPoints; }

    xpError_t addCustomer( const uint64_t _customerId );
    xpError_t useCustomerPoint( const Point &_point );
    xpError_t pay();
    xpError_t sendInvoice();
    std::vector<SellingRecord> createSellingrecord( );

private:
    uint64_t m_billId;
    uint64_t m_staffId;
    Customer m_customer;
    time_t m_creationTime;
    Point m_usedPoints;
    Point m_rewardedPoints;
    std::vector<std::pair<Product,uint32_t>> m_productList;     /**< List of item in the invoice */
    double m_totalDiscount;
    double m_totalExpense;
};

}

#endif // INVOICE_H
