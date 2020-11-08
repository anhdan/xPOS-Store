#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>

#include "backend/database/InventoryDatabase.h"
#include "backend/database/UserDatabase.h"
#include "backend/database/SellingDatabase.h"
#include "backend/XPBackend.h"
#include "backend/3rd/key_emitter.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //
    //============ I. Backend context initialization
    //
    xpError_t xpErr;
    xpos_store::InventoryDatabase inventoryDB;
    if( inventoryDB.connect( "../resource/dbs/inventory.db" ) != xpSuccess )
    {
        xpErr = inventoryDB.create( "../resource/dbs/inventory.db" );
        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] :%s:%d: Failed to either create or connect to database\n",
                     xpErr, __FILE__, __LINE__ );
            exit( xpErr );
        }
    }

    xpos_store::UserDatabase usersDB;
    if( usersDB.connect( "../resource/dbs/users.db" ) != xpSuccess )
    {
        xpErr = usersDB.create( "../resource/dbs/users.db" );
        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] :%s:%d: Failed to either create or connect to database\n",
                     xpErr, __FILE__, __LINE__ );
            exit( xpErr );
        }
    }

    xpos_store::SellingDatabase sellingDB;
    if( sellingDB.connect( "../resource/dbs/selling.db" ) != xpSuccess )
    {
        xpErr = sellingDB.create( "../resource/dbs/selling.db" );
        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] :%s:%d: Failed to either create or connect to database\n",
                     xpErr, __FILE__, __LINE__ );
            exit( xpErr );
        }
    }

    XPBackend xpBackend( &engine, &inventoryDB, &usersDB, &sellingDB );
    xpErr = xpBackend.init();
    if( xpErr != xpSuccess )
    {
        LOG_MSG( "[ERR:%d] :%s:%d: Failed to initialize xPOS backend processor\n",
                 xpErr, __FILE__, __LINE__ );
        exit( xpErr );
    }
    KeyEmitter keyEmitter( &engine );
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty( "xpBackend", &xpBackend );
    ctx->setContextProperty( "keyEmitter", &keyEmitter );
//    ctx->setContextProperty( "top5Model", QVariant::fromValue(xpBackend.top5Model()) );

    //
    //============ II. Load application engine and excute
    //
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
