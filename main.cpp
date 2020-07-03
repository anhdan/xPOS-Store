#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "backend/database/InventoryDatabase.h"
#include "backend/XPBackend.h"
#include "backend/3rd/key_emitter.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //
    //============ I. Backend context initialization
    //
    xpError_t xpErr;
    xpos_store::InventoryDatabase inventoryDB;
    if( inventoryDB.connect( "inventory.db" ) != xpSuccess )
    {
        xpErr = inventoryDB.create( "inventory.db" );
        if( xpErr != xpSuccess )
        {
            LOG_MSG( "[ERR:%d] :%s:%d: Failed to either create or connect to database\n",
                     xpErr, __FILE__, __LINE__ );
            exit( xpErr );
        }
    }

    XPBackend xpBackend( &engine, &inventoryDB );
    KeyEmitter keyEmitter( &engine );
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty( "xpBackend", &xpBackend );
    ctx->setContextProperty( "keyEmitter", &keyEmitter );

    //
    //============ II. Load application engine and excute
    //
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
