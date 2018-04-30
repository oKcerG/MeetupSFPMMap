#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext* rootContext = engine.rootContext();

    if (!qEnvironmentVariableIsSet("JCDECAUX_API_KEY"))
        qFatal("No JCDECAUX_API_KEY environment variable set, go to https://developer.jcdecaux.com to get one");

    rootContext->setContextProperty("jcdecaux_api_key", qEnvironmentVariable("JCDECAUX_API_KEY"));

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
