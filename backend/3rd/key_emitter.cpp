#include <QCoreApplication>
#include <QGuiApplication>
#include <QKeyEvent>
#include <QQuickItem>
#include "key_emitter.h"

#include <iostream>

KeyEmitter::KeyEmitter( QQmlApplicationEngine *_engine )
    : m_engine( _engine )
{
    printf( "[DEB] %s:%d: A key emitter has been created\n", __FUNCTION__, __LINE__ );
}

KeyEmitter::~KeyEmitter()
{
}

void KeyEmitter::emitKey(Qt::Key key)
{
    QQuickItem* receiver = qobject_cast<QQuickItem*>(QGuiApplication::focusObject());
    if(!receiver) {
        printf( "No focused object found\n" );
        return;
    }

	QKeyEvent pressEvent = QKeyEvent(QEvent::KeyPress, key, Qt::NoModifier, QKeySequence(key).toString());
	QKeyEvent releaseEvent = QKeyEvent(QEvent::KeyRelease, key, Qt::NoModifier);
    QCoreApplication::sendEvent(receiver, &pressEvent);
    QCoreApplication::sendEvent(receiver, &releaseEvent);
}
