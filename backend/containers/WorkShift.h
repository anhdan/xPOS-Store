#ifndef WORKSHIFT_H
#define WORKSHIFT_H

#include "backend/xPos.h"
#include "backend/containers/Bill.h"

namespace  xpos_store {

class WorkShift : public Item
{
public:
    WorkShift() : Item()
    {
        setDefault();
    }
    ~WorkShift() {}

public:
    void setDefault();
    void copyTo( Item *_item );
    void printInfo();
    QVariant toQVariant( );
    xpError_t fromQVariant( const QVariant &_item );
    bool isValid();
    QString toJSONString();

    void setStaffId( const std::string &_staffId );
    std::string getStaffId();

    void setStartTime( const time_t _startTime );
    time_t getStartTime();
    void setEndTime( const time_t _endTime );
    time_t getEndTime();

    void setTotalEarning( const double _totalEarning );
    xpError_t increaseEarning( const double _newEarning );
    double getTotalEarning();
    void setTotalProfit( const double _totalProfit );
    double getTotalProfit();
    void setTotalTax( const double _totalTax );
    double getTotalTax();
    void setTotalRewardedPoints( const int _totalRewardedPoints );
    int getTotalRewardPoints();
    void setTotalCustomers( const int _totalCustomers );
    int getTotalCustomers();


    xpError_t start();
    xpError_t start( const std::string &_staffId );
    xpError_t recordBill( Bill &_bill );
    xpError_t end();
    bool isStarted();
    bool isEnded();

    xpError_t combine( WorkShift &_ws );
    xpError_t combine( std::vector<WorkShift> &_workshifts );

    static xpError_t searchCallBack(void *data, int fieldsNum, char **fieldVal, char **fieldName);

private:
    std::string m_staffId;
    time_t m_startTime;
    time_t m_endTime;
    bool m_isStarted;
    double m_totalEarning;
    double m_totalProfit;
    double m_totalTax;
    int m_totalCustomers;
    int m_totalRewardedPoints;
};


}

#endif // WORKSHIFT_H
