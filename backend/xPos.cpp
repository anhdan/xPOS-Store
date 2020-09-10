#include "xPos.h"


/**
 * @brief waitForComplete
 */
template <class T>
xpError_t waitForComplete( T *_status, T _waitCondition, const double _secWaitTime )
{
    uint64_t uWaitPeriod = 100000;
    double sWaitTotal = 0;
    while ( *_status == _waitCondition ) {
        usleep( uWaitPeriod );
        sWaitTotal += (double)uWaitPeriod / 1000000.0;
        if( sWaitTotal > _secWaitTime )
        {
            LOG_MSG( "[ERR:%d] %s:%d: Process timeout\n",
                     xpErrorTimeout, __FILE__, __LINE__ );
            return xpErrorTimeout;
        }
    }

    return xpSuccess;
}
