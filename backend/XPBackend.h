#ifndef XPBACKEND_H
#define XPBACKEND_H

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

class XPBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant qTodayShift READ qTodayShift WRITE setQTodayShift NOTIFY qTodayShiftChanged)
    Q_PROPERTY(QVariant qYesterdayShift READ qYesterdayShift WRITE setQYesterdayShift NOTIFY qYesterdayShiftChanged)
    Q_PROPERTY(QVariantList top5Model READ top5Model NOTIFY top5ModelChanged)

public:
    XPBackend( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
               xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB );
    ~XPBackend();    

signals:
    void sigProductFound( QVariant _product );
    void sigProductNotFound();

    void sigStaffApproved();
    void sigStaffDisapproved();

    void sigCustomerFound( QVariant _customer );
    void sigCustomerNotFound();

    // Properties signal
    void qTodayShiftChanged(QVariant);
    void qYesterdayShiftChanged(QVariant);
    void top5ModelChanged(QVariant);

public:
    // Properties get set function
    QVariant qTodayShift();
    void setQTodayShift(QVariant _qTodayShift );
    QVariant qYesterdayShift();
    void setQYesterdayShift( QVariant _qYesterdayShift );
    QVariantList top5Model();

public slots:
    // Inventory methods
    int searchForProduct( QString _code );
    int updateProductFromInventory( const QVariant &_product );

    // Invoice methods
    int initializePayment();
    double getPoint2MoneyRate();
    int sellProduct( const QVariant &_qProduct, const int _numSold );
    int completePayment( const QVariant &_qCustomer, const QVariant &_qPayment );    

    // Users methods
    int searchForCustomer( QString _id );

    // Authentication methods
    int login( QString _name, QString _pwd );
    int getPrivilege();
    int logout();

    // Analytics functions
    int sortTop5( int _criteria );

public:
    int init();
private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;  
    xpos_store::UserDatabase *m_usersDB;
    xpos_store::SellingDatabase *m_sellingDB;
    xpos_store::Product m_currProduct;
    xpos_store::Staff m_currStaff;
    xpos_store::WorkShift m_currWorkshift;
    xpos_store::Customer m_currCustomer;
    xpos_store::Bill m_bill;

    // For realtime analytics
    xpos_store::WorkShift m_todayShift;
    xpos_store::WorkShift m_yesterdayShift;
    QVariantList m_top5Model;
    std::list<xpos_store::SellingRecord> m_recordGroups;
    Top5Criteria m_top5Criteria;

    // Firebase objects
    firebase::App *m_fbApp;
    firebase::auth::Auth *m_fbAuth;
    firebase::functions::Functions *m_fbFunc;
};

#endif // XPBACKEND_H
