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
    Q_PROPERTY(QVariant oosModel READ oosModel NOTIFY oosModelChanged)
    Q_PROPERTY(QVariant outDateModel READ outDateModel NOTIFY outDateModelChanged)
    Q_PROPERTY(QVariant slowSellingModel READ slowSellingModel NOTIFY slowSellingModelChanged)

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
    void oosModelChanged( QVariant );
    void outDateModelChanged( QVariant );
    void slowSellingModelChanged( QVariant );

public slots:
    int searchForProduct( QString _code );
    int updateProduct( const QVariant &_product );

    QVariant kpi();
    QVariant oosModel();
    QVariant outDateModel();
    QVariant slowSellingModel();

    int getOOSProducts();
    int getOutDateProducts();
    int getSlowSellingProducts();

public:
    int init();


private:
    QQmlApplicationEngine *m_engine;
    xpos_store::InventoryDatabase *m_inventoryDB;
    xpos_store::Product m_currProduct;

    QVariantList m_oosModel;
    QVariantList m_outDateModel;
    QVariantList m_slowSellingModel;

    // For inventory status report
    xpos_store::InventoryKPI m_kpi;
    std::list<xpos_store::Product> m_oosLists;
    std::list<xpos_store::Product> m_outDateLists;
    std::list<xpos_store::Product> m_slowSellingLists;
};

#endif // BACKENDINVENTORY_H
