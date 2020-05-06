#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "xPos.h"
#include "Backend/Containers/Database.h"
#include "Backend/Processes/InventoryProcess.h"
#include "Backend/Processes/WorkShiftProcess.h"


xpos_store::Database *glbProductDB = nullptr;


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    // Multi resolution
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //
    //===== Register a QObject-inherited C++ class to the interface
    //
    qmlRegisterType<InventoryProcess>( "xpos.store.inventory", 1, 0, "InventoryProcess" );
    qmlRegisterType<WorkShiftProcess>( "xpos.store.workshift", 1, 0, "WorkShiftProcess" );

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    glbProductDB = xpos_store::Database::connect( "200423_product.db" );
    if( (glbProductDB && glbProductDB->getTableByName( "PRODUCT" )->db == nullptr) || (glbProductDB == nullptr) )
    {
        glbProductDB = xpos_store::Database::createByTemplate( "200423_product.db", "../Backend/Configs/store_data.xml" );
    }

    if( glbProductDB == nullptr )
    {
        LOG_MSG( "[ERR:%d] %s:%d: Failed to connect to database\n", xpErrorProcessFailure, __FILE__, __LINE__);
        exit( xpErrorProcessFailure );
    }

    glbProductDB->close();

    return app.exec();
}
