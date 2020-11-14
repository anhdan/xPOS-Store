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

    Q_PROPERTY(QVariant kpi READ kpi NOTIFY kpiChanged)

public:
    explicit BackendInventory(QObject *parent = nullptr);
    BackendInventory( QQmlApplicationEngine *engine, xpos_store::InventoryDatabase *_inventoryDB );
    ~BackendInventory();

signals:
    void sigProductFound( QVariant _product );
    void sigProductNotFound( QString _code );
    void sigUpdateSucceeded();
    void sigUpdateFailed();
    void kpiChanged( QVariant );

public slots:
    int searchForProduct( QString _code );
    int updateProduct( const QVariant &_product );

    QVariant kpi();


public:
    int init();


private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;
    xpos_store::Product m_currProduct;

    // For inventory status report
    xpos_store::InventoryKPI m_kpi;
};

#endif // BACKENDINVENTORY_H
