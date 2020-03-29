#ifndef PRODUCT_H
#define PRODUCT_H

#include "xPos.h"

namespace xpos_store
{

class Product
{
private:
    /**
     * @brief setDefault
     */
    void setDefault( )
    {
        m_code = "";
        m_name = "";
        m_category ="";
        m_description ="";
        m_unitName ="";

        m_unitPrice = 0.0;
        m_discountPrice = 0.0;
        m_discountStartTime = 0;
        m_discountEndTime = 0;

        m_quantityInstock = 0;
        m_vendorIDs.clear();
    }

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

    //
    //===== Price Methods
    //
    inline void setUnitPrice( const double _unitPrice ) { m_unitPrice = _unitPrice; }
    inline double getUnitPrice( ) { return m_unitPrice; }

    inline void setDiscountPrice( const double _discountPrice ) { m_discountPrice = _discountPrice; }
    inline double getUnitPrice( ) { return m_discountPrice; }

    /**
     * @brief setDiscountStartTime
     * @param _discountStartTime
     * @return
     */
    inline xpError_t setDiscountStartTime( const time_t _discountStartTime )
    {
        if( _discountStartTime > m_discountEndTime )
            return xpErrorInvalidValues;
        m_discountStartTime = _discountStartTime;
        return xpSuccess;
    }

    /**
     * @brief getDiscountStartTime
     * @return
     */
    inline time_t getDiscountStartTime( ) { return m_discountStartTime; }

    /**
     * @brief setDiscountEndTime
     * @param _discountEndTime
     * @return
     */
    inline xpError_t setDiscountEndTime( const time_t _discountEndTime )
    {
        if( _discountEndTime < m_discountStartTime )
            return xpErrorInvalidValues;
        m_discountEndTime = _discountEndTime;
        return xpSuccess;
    }

    /**
     * @brief getDiscountEndTime
     * @return
     */
    inline time_t getDiscountEndTime( ) { return m_discountEndTime; }

    /**
     * @brief cancelDiscountProgram
     */
    inline void cancelDiscountProgram( )
    {
        m_discountPrice = 0.0;
        m_discountStartTime = m_discountEndTime = 0;
    }

    /**
     * @brief isInDiscountProgram
     * @return
     */
    bool isInDiscountProgram( )
    {
        time_t currTime = time( NULL );
        if( (m_discountPrice >= m_unitPrice) || (currTime > m_discountEndTime) || (m_discountStartTime > m_discountEndTime) )
            return false;
        return true;
    }


    //
    //===== Quantity Methods
    //
    /**
     * @brief setQuantityInstock
     * @param _quantityInstock
     * @return
     */
    inline xpError_t setQuantityInstock( const int _quantityInstock )
    {
        if( _quantityInstock < 0 )
            return xpErrorInvalidValues;
        m_quantityInstock = _quantityInstock;
        return xpSuccess;
    }

    /**
     * @brief addQuantityInstock
     * @param _addQuantity
     * @return
     */
    inline xpError_t addQuantityInstock( const int _addQuantity )
    {
        if( _addQuantity < 0 )
            return xpErrorInvalidValues;
        m_quantityInstock += _addQuantity;
        return xpSuccess;
    }

    /**
     * @brief subtractQuantityInstock
     * @param _subtractQuantity
     * @return
     */
    inline xpError_t subtractQuantityInstock( const int _subtractQuantity )
    {
        if( _subtractQuantity < 0 || (m_quantityInstock - _subtractQuantity < 0) )
            return xpErrorInvalidValues;
        m_quantityInstock -= _subtractQuantity;
        return xpSuccess;
    }

    /**
     * @brief getQuantityInstock
     * @return
     */
    inline int getQuantityInstock( ) { return m_quantityInstock; }

private:
    std::string m_code;             /**< Barcode/2D code string of the product */
    std::string m_name;             /**< Product name */
    std::string m_category;         /**< Product category */
    std::string m_description;      /**< Product description or notice */
    std::string m_unitName;         /**< Unit of quantity. E.g. pcs/kg/bottle */

    // Price attributes
    double m_unitPrice;             /**< Unit price */
    double m_discountPrice;         /**< Discount price */
    time_t m_discountStartTime;
    time_t m_discountEndTime;

    // Quantity attributes
    int m_quantityInstock;          /**< Quantity instock */

    // Vendor attributes
    std::vector<int> m_vendorIDs;   /**< List of vendors id */
};


}
#endif // PRODUCT_H
