QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    Backend/Containers/Customer.cpp \
    Backend/Containers/Product.cpp \
    Backend/Containers/SellingRecord.cpp \
    Backend/Containers/Invoice.cpp \
    Backend/Containers/WorkShift.cpp \
    Backend/Containers/Point.cpp \
    Backend/Containers/Database.cpp \
    Backend/3rd/tinyxml2.cpp \
    Backend/Processes/InventoryProcess.cpp \
    Backend/Processes/WorkShitProcess.cpp \
    Backend/Containers/Staff.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Backend/Containers/Product.h \
    xPos.h \
    Backend/Containers/Customer.h \
    Backend/Containers/Point.h \
    Backend/Containers/Person.h \
    Backend/Containers/Staff.h \
    Backend/Containers/SellingRecord.h \
    Backend/Containers/Invoice.h \
    Backend/Containers/WorkShift.h \
    Backend/Containers/Database.h \
    Backend/3rd/tinyxml2.h \
    Backend/Configs/sqlitecmdFormat.h \
    Backend/Processes/InventoryProcess.h \
    Backend/Processes/WorkShiftProcess.h


#======== SQLite Database Lib
LIBS += -lsqlite3

DISTFILES += \
    Backend/Configs/invoice_data.xml \
    Backend/Configs/store_data.xml
