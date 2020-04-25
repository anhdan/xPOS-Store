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
    xpErrorNotPermited = -6,
    xpErrorNotExist = -7
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


/**
 * @brief The int enum
 */
enum XP_PRODUCT_UNIT_t
{
    XP_PRODUCT_UNIT_NONE = 0,
    XP_PRODUCT_UNIT_GT,          // Goi, tui
    XP_PRODUCT_UNIT_HT,          // Hop, thung
    XP_PRODUCT_UNIT_CL,          // Chai, lo
    XP_PRODUCT_UNIT_L,           // Lon
};

/**
 * @brief The int enum
 */
enum XP_PRODUCT_CATEGORY_t
{
    XP_PRODUCT_CATEGORY_NONE = 0,
    XP_PRODUCT_CATEGORY_DA,          // Do an
    XP_PRODUCT_CATEGORY_NUBR,        // Nuoc uong, bia ruou
    XP_PRODUCT_CATEGORY_BGNR,        // Bot giat, nuoc rua
    XP_PRODUCT_CATEGORY_STXPDG,      // Sua tam, xa phong, dau goi
    XP_PRODUCT_CATEGORY_MP,          // My Pho
    XP_PRODUCT_CATEGORY_K            // Khac
};

#endif // XPOS_H
