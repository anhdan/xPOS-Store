#ifndef POINT_H
#define POINT_H

namespace xpos_store
{

// Initialize static member
double Point::point2MoneyRate = 1000.0;

class Point
{
public:
    static double point2MoneyRate;

    Point()
    {
        m_point = 0;
    }

    Point( const int _p )
    {
        m_point = _p;
    }

    Point( const Point &_p )
    {
        m_point = _p.m_point;
    }

    ~Point() {}

public:
    //
    //===== Operator
    //
    /**
     * @brief operator = [point:Point]
     */
    Point operator =( const Point &_point )
    {
        m_point = _point.m_point;
    }

    /**
     * @brief operator = [point:int]
     */
    Point operator =( const int _iPoint )
    {
        m_point = _iPoint;
    }

    /**
     * @brief operator + [_p:Point]
     */
    Point operator +( const Point &_p )
    {
        return Point(m_point + _p.m_point);
    }

    /**
     * @brief operator + [_p:int]
     */
    Point operator +( const int _p )
    {
        return Point( m_point + _p );
    }

    /**
     * @brief operator - [_p:Point]
     */
    Point operator -( const Point &_p )
    {
        return Point(m_point - _p.m_point);
    }

    /**
     * @brief operator - [_p:int]
     */
    Point operator -( const int _p )
    {
        return Point( m_point - _p );
    }


    /**
     * @brief operator > [_p:Point]
     */
    bool operator >( const Point &_p )
    {
        return (m_point > _p.m_point);
    }

    /**
     * @brief operator > [_p:int]
     */
    bool operator >( const int _p )
    {
        return ( m_point > _p );
    }

    /**
     * @brief operator < [_p:Point]
     */
    bool operator <( const Point &_p )
    {
        return (m_point < _p.m_point);
    }

    /**
     * @brief operator < [_p:int]
     */
    bool operator <( const int _p )
    {
        return ( m_point < _p );
    }


    //
    //===== Methods
    //
    /**
     * @brief Convert rewarded point to an amount of money
     */
    inline double toMoney()
    {
        return ((double)m_point * point2MoneyRate);
    }

    /**
     * @brief Convert an amount of money to rewarded point
     */
    static Point toPoint(const double _money)
    {
        return Point((int)(_money / point2MoneyRate));
    }

private:
    int m_point;
};



}

#endif // POINT_H
