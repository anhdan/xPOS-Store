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



/**
 * @brief sort_indexes
 */
//template <class T>
//std::vector<size_t> sort_indexes(const std::vector<T> &v, const bool _ascending )
//{
//    // initialize original index locations
//    std::vector<size_t> idx(v.size());
//    iota(idx.begin(), idx.end(), 0);

//    // sort indexes based on comparing values in v
//    // using std::stable_sort instead of std::sort
//    // to avoid unnecessary index re-orderings
//    // when v contains elements of equal values
//    if( _ascending )
//    {
//        stable_sort(idx.begin(), idx.end(),
//             [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});
//    }
//    else
//    {
//        stable_sort(idx.begin(), idx.end(),
//             [&v](size_t i1, size_t i2) {return v[i1] > v[i2];});
//    }

//    return idx;
//}
