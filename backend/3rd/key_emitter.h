#ifndef KEY_EMITTER_H
#define KEY_EMITTER_H

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QObject>

class KeyEmitter : public QObject
{
	Q_OBJECT

public:
    KeyEmitter( QQmlApplicationEngine *_engine );
	~KeyEmitter();

public slots:
	void emitKey(Qt::Key key);

private:
    QQmlApplicationEngine *m_engine;
};

#endif // KEY_EMITTER_H
