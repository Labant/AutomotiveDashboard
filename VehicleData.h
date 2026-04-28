#ifndef VEHICLEDATA_H
#define VEHICLEDATA_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

class VehicleData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(double rpm READ rpm NOTIFY rpmChanged)
    Q_PROPERTY(double fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(double batteryVoltage READ batteryVoltage NOTIFY batteryVoltageChanged)
    Q_PROPERTY(double engineTemp READ engineTemp NOTIFY engineTempChanged)
    Q_PROPERTY(int gear READ gear NOTIFY gearChanged)
    Q_PROPERTY(bool leftSignal READ leftSignal NOTIFY leftSignalChanged)
    Q_PROPERTY(bool rightSignal READ rightSignal NOTIFY rightSignalChanged)
    Q_PROPERTY(bool highBeam READ highBeam NOTIFY highBeamChanged)
    Q_PROPERTY(bool checkEngine READ checkEngine NOTIFY checkEngineChanged)
    Q_PROPERTY(double odometer READ odometer NOTIFY odometerChanged)
    Q_PROPERTY(double tripA READ tripA NOTIFY tripAChanged)
    Q_PROPERTY(QString currentTime READ currentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(QString outsideTemp READ outsideTemp NOTIFY outsideTempChanged)
    Q_PROPERTY(bool seatBelt READ seatBelt NOTIFY seatBeltChanged)
    Q_PROPERTY(bool engineRunning READ engineRunning NOTIFY engineRunningChanged)
    Q_PROPERTY(bool signalBlink READ signalBlink NOTIFY signalBlinkChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);

    double speed() const { return m_speed; }
    double rpm() const { return m_rpm; }
    double fuelLevel() const { return m_fuelLevel; }
    double batteryVoltage() const { return m_batteryVoltage; }
    double engineTemp() const { return m_engineTemp; }
    int gear() const { return m_gear; }
    bool leftSignal() const { return m_leftSignal; }
    bool rightSignal() const { return m_rightSignal; }
    bool highBeam() const { return m_highBeam; }
    bool checkEngine() const { return m_checkEngine; }
    double odometer() const { return m_odometer; }
    double tripA() const { return m_tripA; }
    QString currentTime() const;
    QString outsideTemp() const { return m_outsideTemp; }
    bool seatBelt() const { return m_seatBelt; }
    bool engineRunning() const { return m_engineRunning; }
    bool signalBlink() const { return m_signalBlinkOn; }

    Q_INVOKABLE void toggleLeftSignal();
    Q_INVOKABLE void toggleRightSignal();
    Q_INVOKABLE void toggleHighBeam();
    Q_INVOKABLE void accelerate(double amount = 10);
    Q_INVOKABLE void decelerate(double amount = 10);
    Q_INVOKABLE void setTargetSpeed(double target);
    Q_INVOKABLE void resetTrip();
    Q_INVOKABLE void toggleSeatBelt();
    Q_INVOKABLE void startEngine();
    Q_INVOKABLE void stopEngine();

signals:
    void speedChanged();
    void rpmChanged();
    void fuelLevelChanged();
    void batteryVoltageChanged();
    void engineTempChanged();
    void gearChanged();
    void leftSignalChanged();
    void rightSignalChanged();
    void highBeamChanged();
    void checkEngineChanged();
    void odometerChanged();
    void tripAChanged();
    void currentTimeChanged();
    void outsideTempChanged();
    void seatBeltChanged();
    void engineRunningChanged();
    void signalBlinkChanged();

private slots:
    void onSimTick();
    void onClockTick();
    void onSignalBlink();

private:
    void updateGearBySpeed();

    double m_speed = 0.0;
    double m_targetSpeed = 0.0;
    double m_rpm = 0.0;
    double m_fuelLevel = 75.0;
    double m_batteryVoltage = 12.6;
    double m_engineTemp = 25.0;
    int m_gear = 0;
    bool m_leftSignal = false;
    bool m_rightSignal = false;
    bool m_highBeam = false;
    bool m_checkEngine = false;
    double m_odometer = 12345.6;
    double m_tripA = 0.0;
    QString m_outsideTemp = QStringLiteral("22\u00B0C");
    bool m_seatBelt = true;
    bool m_engineRunning = false;

    QTimer *m_simTimer;
    QTimer *m_clockTimer;
    QTimer *m_signalBlinkTimer;
    bool m_signalBlinkOn = false;
};

#endif
