#ifndef WORKSHIFT_H
#define WORKSHIFT_H

#include "backend/xPos.h"
#include "backend/containers/Item.h"
#include "backend/containers/Customer.h"
#include "backend/containers/Staff.h"

namespace  xpos_store {

class WorkShift : public Item
{
public:
    WorkShift() : Item() {}
    ~WorkShift() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();

    void setStaffId( const std::string &_staffId );
    std::string getStaffId();

    void setStartTime( const time_t _startTime );
    time_t getStartTime();
    void setEndTime( const time_t _endTime );
    time_t getEndTime();

    void setTotalEarning( const double _totalEarning );
    xpError_t increaseEarning( const double _newEarning );
    double getTotalEarning();

private:
    std::string m_staffId;
    time_t m_startTime;
    time_t m_endTime;
    double m_totalEarning;
};


}

#endif // WORKSHIFT_H
