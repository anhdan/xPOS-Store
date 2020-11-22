#ifndef BACKENDANALYTICS_H
#define BACKENDANALYTICS_H

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QDateTime>

#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QSslConfiguration>
#include <QUrl>
#include <QFile>
#include <QJsonArray>
#include <QByteArray>
#include <QJsonDocument>

#include "backend/database/InventoryDatabase.h"
#include "backend/database/UserDatabase.h"
#include "backend/database/SellingDatabase.h"

class BackendAnalytics : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariant kpi READ kpi NOTIFY kpiChanged)

public:
    BackendAnalytics( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
               xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB );
    ~BackendAnalytics();

signals:
    void retailStatusComputed( QVariant _barSeries );
    void barSeriesChanged( QVariant );
    void pieSeriesChanged( QVariant );
    void topNBestSellersChanged( QVariant );
    void kpiChanged( QVariant );

public slots:
    int getRetailStatus( const QDate &_startDate, const QDate &_endDate );
    QVariant kpi();

public:
    int init();

private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;
    xpos_store::UserDatabase *m_usersDB;
    xpos_store::SellingDatabase *m_sellingDB;

    // Analytics time range
    QVariantMap m_kpi;
    std::list<RetailStatusRecord> m_retailStatusRecords;
    std::list<xpos_store::SellingRecord> m_sellingRecords;
    std::list<xpos_store::SellingRecord> m_topNList;
};

#endif // BACKENDANALYTICS_H
