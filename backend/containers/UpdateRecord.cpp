#include "UpdateRecord.h"

namespace xpos_store {


/**
 * @brief UpdateRecord::setBarcode
 */
void UpdateRecord::setBarcode(const std::string &_barcode)
{
    m_barcode = _barcode;
}


/**
 * @brief UpdateRecord::getBarcode
 */
std::string UpdateRecord::getBarcode()
{
    return m_barcode;
}


/**
 * @brief UpdateRecord::setUpdateDate
 */
void UpdateRecord::setUpdateDate(const uint64_t _updateDate)
{
    m_updateDate = _updateDate;
}


/**
 * @brief UpdateRecord::getUpdateDate
 */
uint64_t UpdateRecord::getUpdateDate()
{
    return m_updateDate;
}


/**
 * @brief UpdateRecord::setExpiredDate
 */
void UpdateRecord::setExpiredDate(const uint64_t _expiredDate)
{
    m_expiredDate = _expiredDate;
}


/**
 * @brief UpdateRecord::getExpiredDate
 */
uint64_t UpdateRecord::getExpiredDate()
{
    return m_expiredDate;
}


/**
 * @brief UpdateRecord::setQuantity
 */
void UpdateRecord::setQuantity(const int _quantity)
{
    m_quantity = _quantity;
}


/**
 * @brief UpdateRecord::getQuantity
 */
int UpdateRecord::getQuantity()
{
    return m_quantity;
}

	
}
