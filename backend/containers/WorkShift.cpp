#include "WorkShift.h"

namespace xpos_store {

/**
 * @brief setDefault
 */
void WorkShift::setDefault()
{
    m_staffId = "";
    m_startTime = m_endTime = 0;
    m_totalEarning = 0;
}

/**
 * @brief WorkShift::copyTo
 */
void WorkShift::copyTo( Item *_item )
{
    if( _item )
    {
        WorkShift* ws = (WorkShift*)_item;
        ws->m_staffId = m_staffId;
        ws->m_startTime = m_startTime;
        ws->m_endTime = m_endTime;
        ws->m_totalEarning = m_totalEarning;
    }
}


/**
 * @brief WorkShift::printInfo
 */
void WorkShift::printInfo()
{
    LOG_MSG( "\n---------WorkShift---------\n" );
    LOG_MSG( ". STAFF ID:       %s\n", m_staffId.c_str() );
    LOG_MSG( ". START TIME:     %ld\n", (uint64_t)m_startTime );
    LOG_MSG( ". END TIME:       %ld\n", (uint64_t)m_endTime );
    LOG_MSG( ". TOTAL EARNING:  %f\n", m_totalEarning);
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief WorkShift::toQVariant
 */
QVariant WorkShift::toQVariant( )
{

}


/**
 * @brief WorkShift::fromQVariant
 */
xpError_t WorkShift::fromQVariant( const QVariant &_item )
{
    return  xpSuccess;
}


/**
 * @brief WorkShift::setStaffId
 */
void WorkShift::setStaffId( const std::string &_staffId )
{
    m_staffId = _staffId;
}


/**
 * @brief WorkShift::getStaffId
 */
std::string WorkShift::getStaffId()
{
    return  m_staffId;
}


/**
 * @brief WorkShift::setStartTime
 */
void WorkShift::setStartTime( const time_t _startTime )
{
    m_startTime = _startTime;
}


/**
 * @brief WorkShift::getStartTime
 */
time_t WorkShift::getStartTime()
{
    return  m_startTime;
}


/**
 * @brief WorkShift::setEndTime
 */
void WorkShift::setEndTime( const time_t _endTime )
{
    m_endTime = _endTime;
}


/**
 * @brief WorkShift::getEndTime
 */
time_t WorkShift::getEndTime()
{
    return  m_endTime;
}


/**
 * @brief WorkShift::setTotalEarning
 */
void WorkShift::setTotalEarning( const double _totalEarning )
{
    if( _totalEarning >= 0 )
    {
        m_totalEarning = _totalEarning;
    }
}

/**
 * @brief WorkShift::increaseEarning
 */
xpError_t WorkShift::increaseEarning( const double _newEarning )
{
    if( _newEarning < 0 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: invalid input value\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return  xpErrorInvalidValues;
    }

    m_totalEarning += _newEarning;
    return  xpSuccess;
}


/**
 * @brief WorkShift::getTotalEarning
 */
double WorkShift::getTotalEarning()
{
    return  m_totalEarning;
}


}
