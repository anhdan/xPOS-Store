#include "WorkShift.h"

namespace xpos_store
{

/**
 * @brief WorkShift::WorkShift
 */
WorkShift::WorkShift()
{
    m_staffId = 0;
    m_startTime = 0;
    m_endTime = 0;
    m_totalEarning = 0;
    m_hasBeenStarted = false;
    m_hasBeenEnded = false;
}


/**
 * @brief WorkShift::start
 */
xpError_t WorkShift::start()
{
    if( m_hasBeenStarted )
    {
        LOG_MSG( "[ERR:%d] %s:%d: This workshift has been already started\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    m_startTime = time( NULL );
    m_hasBeenStarted = true;

    return xpSuccess;
}


/**
 * @brief WorkShift::end
 */
xpError_t WorkShift::end()
{
    if( !m_hasBeenStarted )
    {
        LOG_MSG( "[ERR:%d] %s:%d: This workshift has not been started yet\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    if( !m_hasBeenEnded )
    {
        m_endTime = time( NULL );
        m_hasBeenEnded = true;
    }

    return xpSuccess;
}


/**
 * @brief WorkShift::updateIncome
 */
xpError_t WorkShift::updateIncome(const Invoice &_invoice)
{
    Invoice copyInvoice(_invoice);
    if( m_hasBeenEnded )
    {
        LOG_MSG( "[ERR:%d] %s:%d: The workshift has been ended\n",
                 xpErrorNotPermited, __FILE__, __LINE__ );
        return xpErrorNotPermited;
    }

    if( copyInvoice.getTotalExpense() < 0 )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Invalid invoice\n",
                 xpErrorInvalidParameters, __FILE__, __LINE__ );
        return xpErrorInvalidParameters;
    }

    m_totalEarning += copyInvoice.getTotalExpense();
    return xpSuccess;
}


}
