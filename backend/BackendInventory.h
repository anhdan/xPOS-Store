#ifndef BACKENDINVENTORY_H
#define BACKENDINVENTORY_H

#include <QObject>

class BackendInventory : public QObject
{
    Q_OBJECT
public:
    explicit BackendInventory(QObject *parent = nullptr);

signals:

};

#endif // BACKENDINVENTORY_H
