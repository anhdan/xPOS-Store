#ifndef PRODUCT_H
#define PRODUCT_H

#include "xPos.h"

namespace xpos_store
{

class Product
{
protected:
    /**
     * @brief setDefault
     */
    void setDefault();

public:
    Product()
    {
        setDefault();
    }

    Product( const std::string _code )
    {
        setDefault();
        m_code = _code;
    }

    ~Product(){}

public:
    //
    //===== Basic info Methods
    //
    inline void setCode( const std::string &_code ) { m_code = _code; }
    inline std::string getCode( ) { return m_code; }

    inline void setName( const std::string &_name ) { m_name = _name; }
    inline std::string getName( ) { return m_name; }

    inline void setCategory( const std::string &_category ) { m_category = _category; }
    inline std::string getCategory( ) { return m_category; }

    inline void setDescription( const std::string &_description ) { m_description = _description; }
    inline std::string getDescription( ) { return m_description; }

    inline void setUnitName( const std::string &_unitName ) { m_unitName = _unitName; }
    inline std::string getUnitName( ) { return m_unitName; }

    inline void setUnitPrice( const double _unitPrice ) { m_unitPrice = _unitPrice; }
    inline double getUnitPrice( ) { return m_unitPrice; }    

    //
    //===== Discount program methods
    //
    xpError_t runDiscountProgram( const double _discountPrice, const time_t _startTime, const time_t _endTime );

    void getDiscountInfo( double *_discountPrice, time_t *_startTime, time_t *_endTime );

    void cancelDiscountProgram();

    bool isInDiscountProgram( );


    //
    //===== Quantity Methods
    //
    xpError_t addToStock( const int _quantity );

    /**
     * @brief This function is used when there is an amount
     * of product is removed from stock not due to being sold,
     * but by other reasons (defect, brocken, etc.)
     */
    xpError_t removeFromStock( const int _quantity );

    inline uint32_t getQuantityInstock( ) { return m_quantityInstock; }
    inline uint32_t getQuantitySold( ) { return m_quantitySold; }

    //
    //===== Selling methods
    //
    xpError_t sell( const int _quantity );

    //TODO: Implement methods to connect, write to and read record from database

private:
    std::string m_code;                 /**< Barcode/2D code string of the product */
    std::string m_name;                 /**< Product name */
    std::string m_category;             /**< Product category */
    std::string m_description;          /**< Product description or notice */
    std::string m_unitName;             /**< Unit of quantity. E.g. pcs/kg/bottle */

    // Price attributes
    double m_unitPrice;                 /**< Unit price */
    double m_discountPrice;             /**< Discount price */
    time_t m_discountStartTime;
    time_t m_discountEndTime;

    // Quantity attributes
    uint32_t m_quantityInstock;         /**< Quantity instock */
    uint32_t m_quantitySold;

    // Vendor attributes
    std::vector<uint64_t> m_vendorIDs;   /**< List of vendors id */
};


}
#endif // PRODUCT_H
