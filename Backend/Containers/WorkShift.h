#ifndef WORKSHIFT_H
#define WORKSHIFT_H

#include "xPos.h"
#include "Invoice.h"

namespace xpos_store
{

class WorkShift
{
public:
    WorkShift();
    ~WorkShift() {}

public:
    inline void setStaffId( const uint64_t _staffId ) { m_staffId = _staffId; }
    inline uint64_t getStaffId( ) { return m_staffId; }

    xpError_t start();
    xpError_t end();
    xpError_t updateIncome( const Invoice &_invoice );

private:
    uint64_t m_staffId;
    time_t m_startTime;
    time_t m_endTime;
    bool m_hasBeenStarted;
    bool m_hasBeenEnded;
    double m_totalEarning;

    //TODO: Implement methods to connect, write to and read record from database
};

}

#endif // WORKSHIFT_H
