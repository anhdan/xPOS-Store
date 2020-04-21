#ifndef INVENTORYPROCESS_H
#define INVENTORYPROCESS_H

#include <QObject>

#include "xPos.h"
#include "Backend/Containers/Product.h"

class InventoryProcess : public QObject
{
    Q_OBJECT
public:
    explicit InventoryProcess(QObject *parent = nullptr);

    //
    //===== Declare invokable callbacks to process signals from Inventory GUI
    //
    Q_INVOKABLE xpError_t invockSearch( QString _code );
    Q_INVOKABLE xpError_t invockUpdate( );

    //
    //===== Declare signals to interface when a processing task has been completed
    //
signals:
    void sigSearchCompleted();
    void sigUpdateCompleted();

public slots:

private:
    xpos_store::Product m_currProduct;
    std::deque<xpos_store::Product> m_recentProducts;
};

#endif // INVENTORYPROCESS_H
