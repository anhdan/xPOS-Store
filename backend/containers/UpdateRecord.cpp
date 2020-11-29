#include "UpdateRecord.h"

namespace xpos_store {


/**
 * @brief UpdateRecord::setBarcode
 */
void UpdateRecord::setDefault()
{
    m_barcode = m_staffId = "";
    m_updateDate = m_expiredDate = 0;
    m_quantity = 0;
}


/**
 * @brief UpdateRecord::copyTo
 */
void UpdateRecord::copyTo(Item *_item)
{
    UpdateRecord* record = (UpdateRecord*)_item;
    record->m_barcode = m_barcode;
    record->m_staffId = m_staffId;
    record->m_updateDate = m_updateDate;
    record->m_expiredDate = m_expiredDate;
    record->m_quantity = m_quantity;
}


/**
 * @brief UpdateRecord::printInfo
 */
void UpdateRecord::printInfo()
{
    LOG_MSG( "\n---------UpdateRecord---------\n" );
    LOG_MSG( ". BARCODE:        %s\n", m_barcode.c_str() );
    LOG_MSG( ". STAFF ID:       %s\n", m_staffId.c_str() );
    LOG_MSG( ". DISCOUNT START: %ld\n", m_updateDate );
    LOG_MSG( ". DISCOUNT END:   %ld\n", m_expiredDate );
    LOG_MSG( ". QUANTITY:       %d\n", m_quantity );
    LOG_MSG( "--------------------------------\n" );
}


/**
 * @brief UpdateRecord::toQVariant
 */
QVariant UpdateRecord::toQVariant()
{
    QVariantMap map;
    map["barcode"] = QString::fromStdString( getBarcode() );
    map["staff_id"] = QString::fromStdString( getStaffId() );
    QDateTime qTime;
    qTime.setTime_t( (uint)getUpdateDate() );
    map["update_date"] = qTime;
    qTime.setTime_t( (uint)getExpiredDate() );
    map["expire_date"] = qTime;
    map["quantity"] = getQuantity();

    return QVariant::fromValue( map );
}


/**
 * @brief UpdateRecord::fromQVariant
 */
xpError_t UpdateRecord::fromQVariant(const QVariant &_item)
{
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        m_barcode = map["barcode"].toString().toStdString();
        m_staffId = map["staff_id"].toString().toStdString();
        m_updateDate = (uint64_t)QDateTime( map["update_date"].toDate() ).toTime_t();
        finalRet &= ret;
        m_expiredDate = (uint64_t)QDateTime( map["expired_date"].toDate() ).toTime_t();
        finalRet &= ret;
        m_quantity = map["quantity"].toInt(&ret);
        finalRet &= ret;
    }
    else
    {
        finalRet = false;
    }

    if( !finalRet )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert from QVariant\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        setDefault();
        return xpErrorProcessFailure;
    }

    return xpSuccess;
}


/**
 * @brief UpdateRecord::isValid
 */
bool UpdateRecord::isValid()
{
    return (m_barcode != "") && (m_staffId != "");
}


/**
 * @brief UpdateRecord::toJSONString
 */
QString UpdateRecord::toJSONString()
{
    return "";
}


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
 * @brief UpdateRecord::setStaffId
 */
void UpdateRecord::setStaffId(const std::string &_staffId)
{
    m_staffId = _staffId;
}


/**
 * @brief UpdateRecord::getStaffId
 */
std::string UpdateRecord::getStaffId()
{
    return m_staffId;
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
