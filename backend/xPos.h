#ifndef XPOS_H
#define XPOS_H

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <ctime>
#include <chrono>
#include <sys/stat.h>
#include <unistd.h>
#include <deque>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <float.h>
#include <time.h>
#include <vector>
#include <list>
#include <numeric>
#include <algorithm>

#include <sqlite3.h>

#include <firebase/app.h>
#include <firebase/auth.h>
#include <firebase/functions.h>
#include <firebase/future.h>
#include <firebase/variant.h>
#include <firebase/log.h>
#include <firebase/util.h>


/***************************************************
 *              Macros
 **************************************************/
#define     __DEBUG__

#ifdef      __DEBUG__
#define     LOG_MSG( ... )      printf( __VA_ARGS__ )
#else
#define     LOG_MSG( ... )
#endif


/***************************************************
 *              Types
 **************************************************/
/**
 * @brief Enumurate of error status
 */
enum xpError_enum
{
    xpSuccess = 0,
    xpErrorInvalidParameters = -1,
    xpErrorInvalidValues = -2,
    xpErrorNotAllocated = -3,
    xpErrorNotCompatible = -4,
    xpErrorProcessFailure = -5,
    xpErrorNotPermited = -6,
    xpErrorNotExist = -7,
    xpErrorTimeout = -8,
    xpErrorUnAuthenticated = -9
};

typedef int xpError_t;


/**
 * @brief The Category_enum enum
 */
enum class Category : int
{
    NONE = 0,
    FOOD,
    DRINK,
    HH_APPLIANCE,
    FASHION,
    ELECTRONICS,
    EDUCATION_OFFICE,
    HEALTH,
    BABY
};

const std::string CATEGORIES_MAJOR_NAME[9] = {"None", "Thực phẩm", "Đồ uống", "Đồ dùng gia đình", "Thời trang",
                                              "Điện tử", "Giáo dục - Văn phòng", "Sức khỏe", "Trẻ em" };


typedef struct _ProductCategory_ {
    int major;
    int minor;
} ProductCategory;


/**
 * @brief Enumurate class of gender types
 */
enum class Gender : int
{
    MALE = 0,
    FEMALE,
    OTHER,
    UNKNOWN
};


/**
 * @brief The Privilege enum
 */
enum class Privilege : int
{
    OWNER = 0,
    CASHIER,
    GUEST
};


/**
 * @brief The PayingMethod enum
 */
enum class PayingMethod : int
{
    CASH = 0,
    CARD
};


/**
 * @brief The Top5Criteria enum
 */
enum class Top5Criteria : int
{
    NONE = 0,
    REVENUE,
    PROFIT,
    QUANTITY
};


/***************************************************
 *              Contants
 **************************************************/
#define SECS_IN_DAY         86400


/***************************************************
 *              Functions
 **************************************************/
/**
 * @brief waitForComplete
 * @param _status
 * @param _waitCondition
 * @param _secWaitTime
 * @return
 */
template <class T>
xpError_t waitForComplete( T *_status, T _waitCondition, const int _secWaitTime );


/**
 * @brief sort_indexes
 * @param v
 * @param _ascending
 * @return
 */
//template <class T>
//std::vector<size_t> sort_indexes(const std::vector<T> &v, const bool _ascending=true);

template <typename T>
std::vector<size_t> sort_indexes(const std::vector<T> &v, const bool _ascending )
{
    // initialize original index locations
    std::vector<size_t> idx(v.size());
    iota(idx.begin(), idx.end(), 0);

    // sort indexes based on comparing values in v
    // using std::stable_sort instead of std::sort
    // to avoid unnecessary index re-orderings
    // when v contains elements of equal values
    if( _ascending )
    {
        stable_sort(idx.begin(), idx.end(),
             [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});
    }
    else
    {
        stable_sort(idx.begin(), idx.end(),
             [&v](size_t i1, size_t i2) {return v[i1] > v[i2];});
    }

    return idx;
}

#endif // XPOS_H
