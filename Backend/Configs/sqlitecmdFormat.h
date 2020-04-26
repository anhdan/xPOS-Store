#ifndef SQLITECMDFORMAT_H
#define SQLITECMDFORMAT_H

#include "xPos.h"


#define FMT_PRODUCT_INSERT          "INSERT INTO %s (CODE, NAME, CATEGORY, DESCRIPTION, UNIT_NAME, UNIT_PRICE, DISCOUNT_PRICE, DISCOUNT_START, DISCOUNT_END, QUANTITY_INSTOCK, QUANTITY_SOLD, VENDOR_IDS) " \
                                    "VALUES('%s', '%s', '%s', '%s', '%s', %f, %f, %d, %d, %d, %d, '%s');"

#define FMT_PRODUCT_DELETE          "DELETE FROM %s WHERE CODE = '%s'"

#define FMT_PRODUCT_UPDATE_BASIC    "UPDATE %s\n" \
                                    "SET NAME = '%s',\n" \
                                    "    CATEGORY = '%s',\n" \
                                    "    DESCRIPTION = '%s',\n" \
                                    "    UNIT_NAME = '%s'\n" \
                                    "WHERE\n" \
                                    "    CODE = '%s';"

#define FMT_PRODUCT_UPDATE_PRICE    "UPDATE %s\n" \
                                    "SET UNIT_PRICE = %s,\n" \
                                    "    DISCOUNT_PRICE = %s,\n" \
                                    "    DISCOUNT_START = %s,\n" \
                                    "    DISCOUNT_END = %s\n" \
                                    "WHERE\n" \
                                    "    CODE = '%s';"

#define FMT_PRODUCT_UPDATE_QUANTITY "UPDATE %s\n" \
                                    "SET QUANTITY_INSTOCK = %s,\n" \
                                    "    QUANTITY_SOLD = %s,\n" \
                                    "WHERE\n" \
                                    "    CODE = '%s';"

#define FMT_PRODUCT_UPDATE_VENDORS  "UPDATE %s\n" \
                                    "SET VENDOR_IDS = '%s',\n" \
                                    "WHERE\n" \
                                    "    CODE = '%s';"

#endif // SQLITECMDFORMAT_H
