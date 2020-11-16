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

    Q_PROPERTY(RangeType rangeType READ rangeType WRITE setRangeType NOTIFY rangeTypeChanged)

public:
    BackendAnalytics( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
               xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB );
    ~BackendAnalytics();

signals:
    void rangeTypeChanged();

public slots:


public:
    enum class RangeType : int {
        Day,
        Week,
        Month,
        Quater,
        Year
    };
    Q_ENUM(RangeType)

    RangeType rangeType();
    void setRangeType( RangeType _rangeType );

    int init();
private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;
    xpos_store::UserDatabase *m_usersDB;
    xpos_store::SellingDatabase *m_sellingDB;

    // Analytics time range
    RangeType m_rangeType;
    QDateTime m_startTime;
    QDateTime m_endTime;
};

#endif // BACKENDANALYTICS_H
