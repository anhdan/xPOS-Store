#ifndef PRODUCT_H
#define PRODUCT_H

#include "xPos.h"
#include "Database.h"
#include "Backend/Configs/sqlitecmdFormat.h"

namespace xpos_store
{

class Product
{

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
    /**
     * @brief setDefault
     */
    void setDefault();
    void copyTo( Product &_product );
    void printInfo();


    //
    //===== Basic info Methods
    //
    inline void setCode( const std::string &_code ) { m_code = _code; }
    inline std::string getCode( ) { return m_code; }

    inline void setName( const std::string &_name ) { m_name = _name; }
    inline std::string getName( ) { return m_name; }

    inline void setCategory( const int _category ) { m_category = _category; }
    inline int getCategory( ) { return m_category; }

    inline void setDescription( const std::string &_description ) { m_description = _description; }
    inline std::string getDescription( ) { return m_description; }

    inline void setUnit( const int _unitName ) { m_unit = _unitName; }
    inline int getUnit( ) { return m_unit; }

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

    xpError_t sell( const int _quantity );


    //
    //===== Database interface
    //
    static Product* searchInDatabase( const Table* _productTable, const std::string &_productCode );
    xpError_t insertToDatabase( const Table* _productTable );
    xpError_t deleteFromDatabase( const Table* _productTable );
    xpError_t updateBasicInfoInDB( const Table* _productTable );
    xpError_t updatePriceInDB( const Table* _productTable );
    xpError_t updateQuantityInDB( const Table* _productTable );
    xpError_t updateVendorsInDB( const Table* _productTable );

private:
    static xpError_t searchCallBack( void* data, int fieldsNum, char** fieldName, char **fieldVal );

private:
    std::string m_code;                 /**< Barcode/2D code string of the product */
    std::string m_name;                 /**< Product name */
    int m_category;         /**< Product category */
    std::string m_description;          /**< Product description or notice */
    int m_unit;                 /**< Unit of quantity. E.g. pcs/kg/bottle */

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
