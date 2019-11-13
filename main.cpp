
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtPrintSupport/QPrinter>

#include "modbusregisterlistmodel.h"
#include "fileio.h"
#include "qmlplot.h"
#include <QtQuick>

int main(int argc, char *argv[])
{
    system("/usr/bin/config_analog_inputs.sh");
    system("/usr/bin/config_analog_outputs.sh");
    system("/usr/bin/config_digital_ios.sh");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QFont font("Frutiger", 16);
    QApplication app(argc, argv);
    app.setFont(font);
    qmlRegisterType<ModbusRegisterListModel>("Modbus", 1, 0, "ModbusRegisterListModel");
    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");
    qmlRegisterType<CustomPlotItem>("CustomPlot", 1, 0, "CustomPlotItem");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
