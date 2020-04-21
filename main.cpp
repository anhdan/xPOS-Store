#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Backend/Processes/InventoryProcess.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    // Multi resolution
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //
    //===== Register a QObject-inherited C++ class to the interface
    //
    qmlRegisterType<InventoryProcess>( "xpos.store.inventory", 1, 0, "InventoryProcess" );

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
