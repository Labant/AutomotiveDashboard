#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "VehicleData.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("\u8F66\u8F7D\u4EEA\u8868\u76D8"));

    QQmlApplicationEngine engine;

    VehicleData vehicleData;
    engine.rootContext()->setContextProperty("vehicle", &vehicleData);

    engine.loadFromModule("Dashboard", "Dashboard");

    return app.exec();
}
