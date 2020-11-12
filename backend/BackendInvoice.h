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

class BackendInvoice : public QObject
{
    Q_OBJECT

public:
    BackendInvoice( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB,
               xpos_store::UserDatabase *_usersDB, xpos_store::SellingDatabase *_sellingDB );
    ~BackendInvoice();    

signals:
    void sigProductFound( QVariant _product );
    void sigProductNotFound();

    void sigStaffApproved();
    void sigStaffDisapproved();

    void sigCustomerFound( QVariant _customer );
    void sigCustomerNotFound();

public slots:
    // Inventory methods
    int searchForProduct( QString _code );

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

    // Firebase objects
    firebase::App *m_fbApp;
    firebase::auth::Auth *m_fbAuth;
    firebase::functions::Functions *m_fbFunc;
};

#endif // XPBACKEND_H
