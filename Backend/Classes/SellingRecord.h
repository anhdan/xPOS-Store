#ifndef SELLINGRECORD_H
#define SELLINGRECORD_H

#include "xPos.h"

namespace xpos_store
{

class SellingRecord
{
protected:
    void setDefault()
    {
        m_billId = 0;
        m_productCode = "";
        m_quantity = 0;
        m_totalPrice = 0;
    }

public:
    SellingRecord()
    {
        setDefault();
    }

    SellingRecord( const uint64_t _billId, const std::string _productCode, const uint32_t _quantity, const double _totalPrice )
        : m_billId(_billId), m_productCode(_productCode), m_quantity(_quantity), m_totalPrice(_totalPrice) {}

    SellingRecord( const SellingRecord _record )
        : m_billId(_record.m_billId), m_productCode(_record.m_productCode),
          m_quantity(_record.m_quantity), m_totalPrice(_record.m_totalPrice) {}

    ~SellingRecord() {}

public:
    inline void setBillId( const uint64_t _billId ) { m_billId = _billId; }
    inline uint64_t getBillId() { return m_billId; }

    inline void setProductCode( const std::string _productCode ) { m_productCode = _productCode; }
    inline void setQuantity( const uint32_t _quantity ) { m_quantity = _quantity; }
    inline void setTotalPrice( const double _totalPrice ) { m_totalPrice = _totalPrice; }

    void setProduct( const std::string _productCode, const uint32_t _quantity, const double _totalPrice );
    void getProduct( std::string *_productCode, uint32_t *_quantity, double *_totalPrice );

private:
    uint64_t m_billId;          /**< Id of the bill to which this selling record belongs to */
    std::string m_productCode;  /**< Barcode/2D code of the product this selling record store */
    uint32_t m_quantity;        /**< Quantity of sold product */
    double m_totalPrice;        /**< Total payment of this selling record */
};

}

#endif // SELLINGRECORD_H
