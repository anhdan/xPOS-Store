#include "WorkShift.h"

namespace xpos_store {

/**
 * @brief setDefault
 */
void WorkShift::setDefault()
{
    m_staffId = "";
    m_startTime = m_endTime = 0;
    m_isStarted = false;
    m_totalEarning = 0;
    m_totalProfit = 0;
    m_totalTax = 0;
    m_totalCustomers = 0;
    m_totalRewardedPoints = 0;
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
        ws->m_totalProfit = m_totalProfit;
        ws->m_totalTax = m_totalTax;
        ws->m_totalCustomers = m_totalCustomers;
        ws->m_totalRewardedPoints = m_totalRewardedPoints;
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
    LOG_MSG( ". TOTAL PROFIT:   %f\n", m_totalProfit);
    LOG_MSG( ". TOTAL TAX:      %f\n", m_totalTax);
    LOG_MSG( ". TOTAL REWARDED POINT: %d\n", m_totalRewardedPoints );
    LOG_MSG( ". IS RUNNING:     %s\n", m_isStarted ? "true" : "false" );
    LOG_MSG( "-------------------------\n" );
}


/**
 * @brief WorkShift::toQVariant
 */
QVariant WorkShift::toQVariant( )
{
    QVariantMap map;
    map["staff_id"] = QString::fromStdString( m_staffId );
    map["start_time"] = (uint)m_startTime;
    map["end_time"] = (uint)m_endTime;
    map["total_earning"] = m_totalEarning;
    map["total_profit"] = m_totalProfit;
    map["total_tax"] = m_totalTax;
    map["total_customers"] = m_totalCustomers;
    map["total_rewarded_points"] = m_totalRewardedPoints;
    map["is_started"] = m_isStarted;

    return QVariant::fromValue( map );
}


/**
 * @brief WorkShift::fromQVariant
 */
xpError_t WorkShift::fromQVariant( const QVariant &_item )
{
    bool finalRet = true;
    if( _item.canConvert<QVariantMap>() )
    {
        bool ret = true;
        QVariantMap map = _item.toMap();
        m_staffId = map["staff_id"].toString().toStdString();
        m_startTime = (time_t)map["start_time"].toUInt(&ret);
        finalRet &= ret;
        m_endTime = (time_t)map["end_time"].toUInt(&ret);
        finalRet &= ret;
        m_totalEarning = map["total_earning"].toDouble(&ret);
        finalRet &= ret;
        m_totalProfit = map["total_profit"].toDouble(&ret);
        finalRet &= ret;
        m_totalTax = map["total_tax"].toDouble(&ret);
        finalRet &= ret;
        m_totalCustomers = map["total_customers"].toInt(&ret);
        finalRet &= ret;
        m_totalRewardedPoints = map["total_rewarded_points"].toInt(&ret);
        finalRet &= ret;
        if( map.contains( "is_started" ) )
        {
            m_isStarted = map["is_started"].toBool();
        }
    }

    if( !finalRet )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to convert from QVariant\n",
                 xpErrorProcessFailure, __FILE__, __LINE__ );
        setDefault();
        return xpErrorProcessFailure;
    }

    return  xpSuccess;
}


/**
 * @brief WorkShift::isValid
 */
bool WorkShift::isValid()
{
    return ((m_staffId != "") && (m_startTime >0) && (m_endTime > m_startTime));
}


/**
 * @brief WorkShift::toJSONString
 */
QString WorkShift::toJSONString()
{
    //! TODO:
    //!     Implement this
    return QString("");
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


/**
 * @brief WorkShift::setTotalProfit
 */
void WorkShift::setTotalProfit(const double _totalProfit)
{
    m_totalProfit = _totalProfit;
}


/**
 * @brief WorkShift::getTotalProfit
 */
double WorkShift::getTotalProfit()
{
    return m_totalProfit;
}


/**
 * @brief WorkShift::setTotalTax
 */
void WorkShift::setTotalTax(const double _totalTax)
{
    m_totalTax = _totalTax;
}


/**
 * @brief WorkShift::getTotalTax
 */
double WorkShift::getTotalTax()
{
    return m_totalTax;
}


/**
 * @brief WorkShift::setTotalRewardedPoints
 */
void WorkShift::setTotalRewardedPoints(const int _totalRewardedPoints)
{
    m_totalRewardedPoints = _totalRewardedPoints;
}


/**
 * @brief WorkShift::getTotalRewardPoints
 */
int WorkShift::getTotalRewardPoints()
{
    return m_totalRewardedPoints;
}


/**
 * @brief WorkShift::setTotalCustomers
 */
void WorkShift::setTotalCustomers(const int _totalCustomers)
{
    m_totalCustomers = _totalCustomers;
}


/**
 * @brief WorkShift::getTotalCustomers
 */
int WorkShift::getTotalCustomers()
{
    return m_totalCustomers;
}


/**
 * @brief WorkShift::start
 */
xpError_t WorkShift::start()
{
    if( m_isStarted )
    {
        LOG_MSG( "[ERR:%d] %s:%d: A workshift is running\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_startTime = time( NULL );
    m_endTime = 0;
    m_totalEarning = 0;
    m_totalProfit = 0;
    m_totalTax = 0;
    m_totalCustomers = 0;
    m_totalRewardedPoints = 0;
    m_isStarted = true;
    return xpSuccess;
}


/**
 * @brief WorkShift::start
 */
xpError_t WorkShift::start( const std::string &_staffId )
{
    if( m_isStarted )
    {
        LOG_MSG( "[ERR:%d] %s:%d: A workshift is running\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_staffId = _staffId;
    m_startTime = time( NULL );
    m_endTime = 0;
    m_totalEarning = 0;
    m_totalProfit = 0;
    m_totalTax = 0;
    m_totalCustomers = 0;
    m_totalRewardedPoints = 0;
    m_isStarted = true;
    return xpSuccess;
}


/**
 * @brief WorkShift::recordBill
 */
xpError_t WorkShift::recordBill( Bill &_bill )
{
    if( !_bill.isValid() )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid input parameter\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    Payment payment;
    _bill.getPayment(payment);
    m_totalEarning += payment.getTotalCharging();
    m_totalTax += payment.getTax();
    m_totalProfit += _bill.getProfit();
    m_totalCustomers++;
    m_totalRewardedPoints += payment.getRewardedPoint();

    return xpSuccess;
}

/**
 * @brief WorkShift::end
 */
xpError_t WorkShift::end()
{
    if( !m_isStarted )
    {
        LOG_MSG( "[ERR:%d] %s:%d: None workshift is running\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_endTime = time( NULL );
    if( m_endTime < m_startTime )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid workshift timing\n",
                 xpErrorInvalidValues, __FILE__, __LINE__ );
        return xpErrorInvalidValues;
    }

    m_isStarted = false;
    return xpSuccess;
}


/**
 * @brief WorkShift::isStarted
 */
bool WorkShift::isStarted()
{
    return m_isStarted;
}


/**
 * @brief WorkShift::isEnded
 */
bool WorkShift::isEnded()
{
    return (!m_isStarted);
}


/**
 * @brief WorkShift::combine
 */
xpError_t WorkShift::combine( WorkShift &_ws)
{
    if( !_ws.isValid() )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid parameter\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    m_staffId = (m_staffId == _ws.m_staffId) ? m_staffId : "COMBINED";
    m_startTime = (m_startTime < _ws.m_startTime) ? m_startTime : _ws.m_startTime;
    m_endTime = (m_endTime > _ws.m_endTime) ? m_endTime : _ws.m_endTime;
    m_totalEarning += _ws.m_totalEarning;
    m_totalProfit += _ws.m_totalProfit;
    m_totalTax += _ws.m_totalTax;
    m_totalCustomers += _ws.m_totalCustomers;
    m_totalRewardedPoints += _ws.m_totalRewardedPoints;
    m_isStarted &= _ws.m_isStarted;

    return xpSuccess;
}


/**
 * @brief WorkShift::combine
 */
xpError_t WorkShift::combine( std::vector<WorkShift> &_workshifts )
{
    xpError_t xpErr = xpSuccess;
    for( int id = 0; id < (int)_workshifts.size(); id++ )
    {
        xpErr |= this->combine( _workshifts[id] );
    }

    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to combine workshifts\n",
                 xpErr, __FILE__, __LINE__ );
    }

    return xpErr;
}


/**
 * @brief WorkShift::searchCallBack
 */
xpError_t WorkShift::searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName)
{
    if( data )
    {
        std::vector<WorkShift> *workshifts = (std::vector<WorkShift>*)data;
        WorkShift ws;
        for( int fieldId = 0; fieldId < fieldsNum; fieldId++ )
        {
            if( !strcmp(fieldName[fieldId], "STAFF_ID") )
            {
                ws.m_staffId = fieldVal[fieldId] ? fieldVal[fieldId] : "";
            }
            else if( !strcmp(fieldName[fieldId], "START_TIME") )
            {
                ws.m_startTime = fieldVal[fieldId] ? (time_t)atol(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "END_TIME") )
            {
                ws.m_endTime = fieldVal[fieldId] ? (time_t)atol(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_EARNING") )
            {
                ws.m_totalEarning = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_PROFIT") )
            {
                ws.m_totalProfit = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_TAX") )
            {
                ws.m_totalTax = fieldVal[fieldId] ? atof(fieldVal[fieldId]) : 0.0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_CUSTOMERS") )
            {
                ws.m_totalCustomers = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else if( !strcmp(fieldName[fieldId], "TOTAL_REWARDED_POINTS") )
            {
                ws.m_totalRewardedPoints = fieldVal[fieldId] ? atoi(fieldVal[fieldId]) : 0;
            }
            else
            {
                LOG_MSG( "[ERR:%d] %s:%d: Invalid field name\n", xpErrorProcessFailure, __FILE__, __LINE__ );
                ws.setDefault();
                return xpErrorProcessFailure;
            }
        }
        workshifts->push_back( ws );
    }

    return xpSuccess;
}


}
