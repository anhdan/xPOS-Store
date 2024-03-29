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

SOURCES += main.cpp \
    backend/containers/Product.cpp \
    backend/containers/Customer.cpp \
    backend/containers/Staff.cpp \
    backend/containers/Person.cpp \
    backend/database/Database.cpp \
    backend/database/InventoryDatabase.cpp \
    backend/XPBackend.cpp \
    backend/3rd/key_emitter.cpp \
    backend/database/UserDatabase.cpp \
    backend/database/SellingDatabase.cpp \
    backend/containers/SellingRecord.cpp \
    backend/containers/Bill.cpp \
    backend/containers/WorkShift.cpp \
    backend/containers/Payment.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

LIBS += -lsqlite3

HEADERS += \
    backend/containers/Product.h \
    backend/xPos.h \
    backend/containers/Item.h \
    backend/containers/Customer.h \
    backend/containers/Staff.h \
    backend/containers/Person.h \
    backend/database/Database.h \
    backend/database/InventoryDatabase.h \
    backend/XPBackend.h \
    backend/3rd/key_emitter.h \
    backend/database/UserDatabase.h \
    backend/database/SellingDatabase.h \
    backend/containers/SellingRecord.h \
    backend/containers/Bill.h \
    backend/containers/WorkShift.h \
    backend/containers/Payment.h
