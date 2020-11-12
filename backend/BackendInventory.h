#ifndef BACKENDINVENTORY_H
#define BACKENDINVENTORY_H

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QDateTime>

#include "backend/database/InventoryDatabase.h"

class BackendInventory : public QObject
{
    Q_OBJECT
public:
    explicit BackendInventory(QObject *parent = nullptr);
    BackendInventory( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB );
    ~BackendInventory();

signals:
    void sigProductFound( QVariant _product );
    void sigProductNotFound( QString _code );

public slots:
    int searchForProduct( QString _code );
    int updateProduct( const QVariant &_product );

public:
    int init();
private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;
    xpos_store::Product m_currProduct;
};

#endif // BACKENDINVENTORY_H
