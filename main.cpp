
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtPrintSupport/QPrinter>

//#include "modbusregisterlistmodel.h"
#include "fileio.h"
#include <QtQuick>
#include "qmlmqttclient.h"

int main(int argc, char *argv[])
{
//    system("/usr/bin/config_analog_inputs.sh");
//    system("/usr/bin/config_analog_outputs.sh");
//    system("/usr/bin/config_digital_ios.sh");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QFont font("Frutiger", 16);
    QApplication app(argc, argv);
    app.setFont(font);
//    qmlRegisterType<ModbusRegisterListModel>("Modbus", 1, 0, "ModbusRegisterListModel");
    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");

    QQmlApplicationEngine engine;


    qmlRegisterType<QmlMqttClient>("MqttClient", 1, 0, "MqttClient");
    qmlRegisterUncreatableType<QmlMqttSubscription>("MqttClient", 1, 0, "MqttSubscription", QLatin1String("Subscriptions are read-only"));

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
