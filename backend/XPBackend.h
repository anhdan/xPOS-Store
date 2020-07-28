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
    int searchForProduct( QString _code );
    int updateProductFromInventory( const QVariant &_product );
    int updateProductFromInvoice( const QVariant &_product );
    int httpPostInvoice();
    int completePayment( const QVariant &_qSellingRecords, const QVariant &_qCustomer, const QVariant &_qPayment );

    int login( QString _name, QString _pwd );
    int getPrivilege();

    int searchForCustomer( QString _id );
    int updateCustomerFromInvoice( const QVariant &_customer );

    double getPoint2MoneyRate();

public:

private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;  
    xpos_store::UserDatabase *m_usersDB;
    xpos_store::SellingDatabase *m_sellingDB;
    xpos_store::Product m_currProduct;
    xpos_store::Staff m_currStaff;
    xpos_store::Customer m_currCustomer;
};

#endif // XPBACKEND_H
