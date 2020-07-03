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

class XPBackend : public QObject
{
    Q_OBJECT
public:
    XPBackend( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB );
    ~XPBackend();

signals:
    void sigProductFound( QVariant _product );
    void sigProductNotFound();

public slots:
    int searchForProduct( QString _code );
    int updateProductFromInventory( const QVariant &_product );
    int httpPostInvoice();

public:

private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;  
    xpos_store::Product m_currProduct;
};

#endif // XPBACKEND_H
