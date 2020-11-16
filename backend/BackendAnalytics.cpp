#include "BackendAnalytics.h"


/**
 * @brief BackendAnalytics::BackendAnalytics
 */
BackendAnalytics::BackendAnalytics(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                                   xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB)
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB), m_sellingDB(_sellingDB)
{
    LOG_MSG( "[DEB] A BackendAnalytics object has been created\n" );
}


/**
 * @brief BackendAnalytics::~BackendAnalytics
 */
BackendAnalytics::~BackendAnalytics()
{
    m_engine = nullptr;
    m_inventoryDB = nullptr;
    m_usersDB = nullptr;
    m_sellingDB = nullptr;
}



/**
 * @brief BackendAnalytics::init
 */
int BackendAnalytics::init()
{
    m_rangeType = RangeType::Day;
    m_startTime = QDateTime();
    m_endTime = QDateTime();
    return xpSuccess;
}


/**
 * @brief BackendAnalytics::rangeType
 */
BackendAnalytics::RangeType BackendAnalytics::rangeType()
{
    return (int)m_rangeType;
}


/**
 * @brief BackendAnalytics::setRangeType
 */
void BackendAnalytics::setRangeType(RangeType _rangeType)
{
    m_rangeType = (RangeType)_rangeType;
}
