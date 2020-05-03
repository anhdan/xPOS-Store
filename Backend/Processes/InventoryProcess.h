#ifndef INVENTORYPROCESS_H
#define INVENTORYPROCESS_H

#include <QObject>
#include <QDateTime>

#include "xPos.h"
#include "Backend/Containers/Product.h"
#include "Backend/Containers/Database.h"

class InventoryProcess : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString code READ code WRITE setCode NOTIFY codeChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(int unitName READ unitName WRITE setUnitName NOTIFY unitNameChanged)
    Q_PROPERTY(double unitPrice READ unitPrice WRITE setUnitPrice NOTIFY unitPriceChanged)
    Q_PROPERTY(QString discountPrice READ discountPrice NOTIFY discountPriceChanged)
    Q_PROPERTY(QString discountStart READ discountStart NOTIFY discountStartChanged)
    Q_PROPERTY(QString discountEnd READ discountEnd NOTIFY discountEndChanged)
    Q_PROPERTY(QString quantityInstock READ quantityInstock NOTIFY quantityInstockChanged)
    Q_PROPERTY(QString quantitySold READ quantitySold NOTIFY quantitySoldChanged)
public:
    explicit InventoryProcess(QObject *parent = nullptr);    

    //
    //===== Declare properties methods
    //
    QString code();
    void setCode( const QString _code );
    QString name();
    void setName( const QString _name );
    int category();
    void setCategory( const int _category );
    QString description();
    void setDescription( const QString _desc );
    int unitName();
    void setUnitName( const int _unitName );
    double unitPrice();
    void setUnitPrice( const double _unitPrice );
    QString discountPrice();
    QString discountStart();
    QString discountEnd();
    QString quantityInstock();
    QString quantitySold();

    //
    //===== Declare invokable callbacks to process signals from Inventory GUI
    //
    Q_INVOKABLE int invokSearch( QString _code );
    Q_INVOKABLE int invokUpdate( );

    //
    //===== Declare signals to interface when a processing task has been completed
    //
signals:
    void sigSearchCompleted();
    void sigUpdateCompleted();
    void codeChanged();
    void nameChanged();
    void categoryChanged();
    void descriptionChanged();
    void unitNameChanged();
    void unitPriceChanged();
    void discountPriceChanged();
    void discountStartChanged();
    void discountEndChanged();
    void quantityInstockChanged();
    void quantitySoldChanged();


public slots:

private:
    xpos_store::Product m_currProduct;
    bool m_found = false;
    std::deque<xpos_store::Product> m_recentProducts;
};

#endif // INVENTORYPROCESS_H
