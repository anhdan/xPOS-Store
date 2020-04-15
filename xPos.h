#ifndef XPOS_H
#define XPOS_H


#include <string>
#include <fstream>
#include <ctime>
#include <chrono>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <time.h>
#include <vector>
#include <list>

#include <sqlite3.h>


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
    xpErrorNotPermited = -6
};

typedef int xpError_t;


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

#endif // XPOS_H
