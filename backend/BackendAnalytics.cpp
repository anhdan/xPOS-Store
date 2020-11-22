#include "BackendAnalytics.h"


/**
 * @brief BackendAnalytics::BackendAnalytics
 */
BackendAnalytics::BackendAnalytics(QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
                                   xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB)
    : m_engine(engine), m_inventoryDB( _inventoryDB ), m_usersDB(_usersDB), m_sellingDB(_sellingDB)
{
    LOG_MSG( "[DEB] A BackendAnalytics object has been created\n" );
}


/**
 * @brief BackendAnalytics::~BackendAnalytics
 */
BackendAnalytics::~BackendAnalytics()
{
    m_engine = nullptr;
    m_inventoryDB = nullptr;
    m_usersDB = nullptr;
    m_sellingDB = nullptr;
}



/**
 * @brief BackendAnalytics::init
 */
int BackendAnalytics::init()
{
    return xpSuccess;
}


/**
 * @brief BackendAnalytics::performStatistic
 */
int BackendAnalytics::getRetailStatus( const QDate &_startDate, const QDate &_endDate )
{
    //===== Compute data for bar chart
    long days = _startDate.daysTo( _endDate );
    xpError_t xpErr = xpSuccess;
    if( days == 1 )
    {
        xpErr |= m_sellingDB->groupBillsByDayHours(QDateTime(_startDate).toSecsSinceEpoch(),
                                                   QDateTime(_endDate).toSecsSinceEpoch(), m_retailStatusRecords);
    }
    else if( days <= 14 )
    {
        xpErr |= m_sellingDB->groupBillsByWeekDays( QDateTime(_startDate).toSecsSinceEpoch(),
                                                    QDateTime(_endDate).toSecsSinceEpoch(), m_retailStatusRecords );
    }
    else if( days <= 60 )
    {
        xpErr |= m_sellingDB->groupBillsByMonthWeeks( QDateTime(_startDate).toSecsSinceEpoch(),
                                                      QDateTime(_endDate).toSecsSinceEpoch(), m_retailStatusRecords );
    }
    else
    {
        xpErr |= m_sellingDB->groupBillsByMonths( QDateTime(_startDate).toSecsSinceEpoch(),
                                                  QDateTime(_endDate).toSecsSinceEpoch(), m_retailStatusRecords );
    }

    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to create bar chart data\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    QVariantList barSeries;
    std::list<RetailStatusRecord>::iterator it = m_retailStatusRecords.begin();
    m_kpi["revenue"] = 0;
    m_kpi["discount"] = 0;
    m_kpi["profit"] = 0;
    m_kpi["lost"] = 0;
    for( int id = 0; id < (int)m_retailStatusRecords.size(); id++ )
    {
        QVariantMap bar;
        bar["label"] = QString::fromStdString(it->timeStr);
        bar["revenue"] = it->revenue;
        bar["profit"] = it->profit;
        bar["disount"] = it->disount;
        bar["lost"] = it->lost;
        barSeries << QVariant::fromValue(bar);

        m_kpi["revenue"] = m_kpi["revenue"].toDouble() + it->revenue;
        m_kpi["discount"] = m_kpi["discount"].toDouble() + it->disount;
        m_kpi["profit"] = m_kpi["profit"].toDouble() + it->profit;
        m_kpi["lost"] = m_kpi["lost"].toDouble() + it->lost;

        LOG_MSG( "y = %4d | m = %2d | w = %d | wd = %d | h = %d | revenue = %.3f | discount = %.3f | profit = %.3f\n",
                 it->year, it->month, it->week, it->wday, it->hour, it->revenue, it->disount, it->profit );
        std::advance( it, 1 );
    }
    emit barSeriesChanged( QVariant::fromValue(barSeries) );
    emit kpiChanged( QVariant::fromValue(m_kpi) );


    //===== Compute data for pie chart
    xpErr |= m_sellingDB->groupSellingRecordsByCategory( QDateTime(_startDate).toSecsSinceEpoch(),
                                                         QDateTime(_endDate).toSecsSinceEpoch(), m_sellingRecords );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to create pie char data\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    QVariantList pieSeries;
    std::list<xpos_store::SellingRecord>::iterator it1 = m_sellingRecords.begin();
    for( int id = 0; id < (int)m_sellingRecords.size(); id++ )
    {
        QVariantMap pie;
        pie["label"] =( it1->getCategory() != Category::NONE )  ? QString::fromStdString(CATEGORIES_MAJOR_NAME[(int)it1->getCategory()])
                                                                : QString::fromStdString("None");
        pie["revenue"] = it1->getTotalPrice();
        pie["profit"] = it1->getTotalProfit();
        pieSeries << QVariant::fromValue( pie );

        LOG_MSG( "category = %s | revenue = %.3f | discount = %.3f | profit = %.3f\n",
                 pie["label"].toString().toStdString().c_str(), it->revenue,
                it1->getTotalPrice(), it1->getTotalProfit() );
        std::advance( it1, 1 );
    }
    emit pieSeriesChanged( QVariant::fromValue(pieSeries) );

    //===== Compute data for top N bestsellers
    xpErr |= m_sellingDB->groupSellingRecordsByBarcode( QDateTime(_startDate).toSecsSinceEpoch(),
                                                        QDateTime(_endDate).toSecsSinceEpoch(), m_topNList );
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to create top N bestsellers data\n",
                 xpErr, __FILE__, __LINE__ );
        return xpErr;
    }

    QVariantList topNList;
    std::list<xpos_store::SellingRecord>::iterator it2 = m_topNList.begin();
    for( int id = 0; id < (int)m_sellingRecords.size(); id++ )
    {
        xpos_store::Product product;
        xpErr |= m_inventoryDB->searchProductByBarcode( it2->getProductBarcode(), product );
        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] %s:%d: Failed to search for product name\n",
                     xpErr, __FILE__, __LINE__ );
            return xpErr;
        }

        QVariantMap map;
        map["barcode"] = QString::fromStdString( it2->getProductBarcode() );
        map["name"] = QString::fromStdString( product.getName() );
        map["quantity"] = it2->getQuantity();
        map["revenue"] = it2->getTotalPrice();
        map["profit"] = it2->getTotalProfit();
        topNList << QVariant::fromValue( map );

        LOG_MSG( "barcode = %s |  name = %s  | quantity = %d  |  revenue = %.3f | profit = %.3f\n",
                 map["barcode"].toString().toStdString().c_str(), map["name"].toString().toStdString().c_str(),
                it2->getQuantity(), it2->getTotalPrice(), it2->getTotalProfit() );
        std::advance( it2, 1 );
    }
    std::cout << "====> length " << topNList.length() << std::endl;
    emit topNBestSellersChanged( QVariant::fromValue(topNList) );

    return xpSuccess;
}


/**
 * @brief BackendAnalytics::kpi
 */
QVariant BackendAnalytics::kpi()
{
    return QVariant::fromValue( m_kpi );
}
