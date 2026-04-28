#include "VehicleData.h"
#include <QtMath>

VehicleData::VehicleData(QObject *parent)
    : QObject(parent)
{
    m_simTimer = new QTimer(this);
    m_simTimer->setInterval(50);
    connect(m_simTimer, &QTimer::timeout, this, &VehicleData::onSimTick);

    m_clockTimer = new QTimer(this);
    m_clockTimer->setInterval(1000);
    connect(m_clockTimer, &QTimer::timeout, this, &VehicleData::onClockTick);

    m_signalBlinkTimer = new QTimer(this);
    m_signalBlinkTimer->setInterval(500);
    connect(m_signalBlinkTimer, &QTimer::timeout, this, &VehicleData::onSignalBlink);

    m_clockTimer->start();
}

QString VehicleData::currentTime() const
{
    return QDateTime::currentDateTime().toString("HH:mm");
}

void VehicleData::toggleLeftSignal()
{
    m_leftSignal = !m_leftSignal;
    if (m_leftSignal) {
        m_rightSignal = false;
        if (!m_signalBlinkTimer->isActive())
            m_signalBlinkTimer->start();
    } else {
        if (!m_rightSignal)
            m_signalBlinkTimer->stop();
    }
    emit leftSignalChanged();
    emit rightSignalChanged();
}

void VehicleData::toggleRightSignal()
{
    m_rightSignal = !m_rightSignal;
    if (m_rightSignal) {
        m_leftSignal = false;
        if (!m_signalBlinkTimer->isActive())
            m_signalBlinkTimer->start();
    } else {
        if (!m_leftSignal)
            m_signalBlinkTimer->stop();
    }
    emit leftSignalChanged();
    emit rightSignalChanged();
}

void VehicleData::toggleHighBeam()
{
    m_highBeam = !m_highBeam;
    emit highBeamChanged();
}

void VehicleData::accelerate(double amount)
{
    if (!m_engineRunning) return;
    m_targetSpeed = qMin(m_targetSpeed + amount, 260.0);
}

void VehicleData::decelerate(double amount)
{
    m_targetSpeed = qMax(m_targetSpeed - amount, 0.0);
}

void VehicleData::setTargetSpeed(double target)
{
    m_targetSpeed = qBound(0.0, target, 260.0);
}

void VehicleData::resetTrip()
{
    m_tripA = 0.0;
    emit tripAChanged();
}

void VehicleData::toggleSeatBelt()
{
    m_seatBelt = !m_seatBelt;
    emit seatBeltChanged();
}

void VehicleData::startEngine()
{
    if (m_engineRunning) return;
    m_engineRunning = true;
    m_rpm = 750;
    emit engineRunningChanged();
    emit rpmChanged();
    m_simTimer->start();
}

void VehicleData::stopEngine()
{
    if (!m_engineRunning) return;
    m_engineRunning = false;
    m_rpm = 0;
    m_targetSpeed = 0;
    m_speed = 0;
    m_gear = 0;
    m_engineTemp = 25;
    m_simTimer->stop();
    emit engineRunningChanged();
    emit rpmChanged();
    emit speedChanged();
    emit gearChanged();
    emit engineTempChanged();
}

void VehicleData::updateGearBySpeed()
{
    int newGear = m_gear;
    if (m_speed < 1) {
        newGear = 0;
    } else if (m_speed < 10) {
        newGear = 1;
    } else if (m_speed < 30) {
        newGear = 2;
    } else if (m_speed < 50) {
        newGear = 3;
    } else if (m_speed < 80) {
        newGear = 4;
    } else if (m_speed < 120) {
        newGear = 5;
    } else {
        newGear = 6;
    }
    if (newGear != m_gear) {
        m_gear = newGear;
        emit gearChanged();
    }
}

void VehicleData::onSimTick()
{
    if (qAbs(m_speed - m_targetSpeed) > 0.5) {
        double diff = m_targetSpeed - m_speed;
        m_speed += qBound(-2.0, diff * 0.1, 2.0);
    } else {
        m_speed = m_targetSpeed;
    }

    if (m_speed < 0.1 && m_targetSpeed < 0.1) {
        m_speed = 0;
    }

    updateGearBySpeed();

    if (m_speed < 0.5) {
        m_rpm = 750;
    } else {
        double gearRatio = 4.0 + (6 - m_gear) * 0.8;
        m_rpm = 750 + m_speed * gearRatio;
        m_rpm = qMin(m_rpm, 8000.0);
    }

    if (m_odometer < 99999.9) {
        m_odometer += m_speed * 0.05 / 3600.0;
    }
    if (m_speed > 0.5) {
        m_tripA += m_speed * 0.05 / 3600.0;
    }

    if (m_engineRunning && m_speed > 0) {
        m_fuelLevel = qMax(0.0, m_fuelLevel - 0.002);
    }

    if (m_engineRunning) {
        m_engineTemp = qMin(95.0, m_engineTemp + 0.05);
    }

    m_batteryVoltage = 12.6 - (m_speed > 0 ? m_speed * 0.001 : 0)
                       + (m_highBeam ? -0.2 : 0)
                       + (m_leftSignal || m_rightSignal ? -0.1 : 0);

    emit speedChanged();
    emit rpmChanged();
    emit fuelLevelChanged();
    emit batteryVoltageChanged();
    emit engineTempChanged();
    emit odometerChanged();
    emit tripAChanged();

    if (m_fuelLevel < 10 && !m_checkEngine) {
        m_checkEngine = true;
        emit checkEngineChanged();
    }
}

void VehicleData::onClockTick()
{
    emit currentTimeChanged();
    int sec = QTime::currentTime().second();
    if (sec % 30 == 0) {
        m_outsideTemp = QString("%1\u00B0C").arg(20 + (sec / 30) % 15);
        emit outsideTempChanged();
    }
}

void VehicleData::onSignalBlink()
{
    m_signalBlinkOn = !m_signalBlinkOn;
    emit signalBlinkChanged();
}
