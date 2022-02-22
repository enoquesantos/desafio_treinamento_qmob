#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "backend.h"
#include "materialicons.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QFontDatabase::addApplicationFont(u":/materialdesignicons-webfont.ttf"_qs);
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/desafio_treinamento_qmob/main.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](const QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("MaterialIcons", new MaterialIcons());
    engine.load(url);

    return app.exec();
}
