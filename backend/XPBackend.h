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

    // Http methods
    int httpPostInvoice();
    int httpRequestCustomer( xpos_store::Customer &_customer );

public:
    static void httpReplyFinished( QNetworkReply *_reply );
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

    // HTTP objects
    QNetworkAccessManager *m_httpManager;
};

#endif // XPBACKEND_H
