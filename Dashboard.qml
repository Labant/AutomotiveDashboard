import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 600
    title: "车载仪表盘 - QML + C++ 示例"
    color: "#0D0D1A"
    minimumWidth: 800
    minimumHeight: 500

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#0D0D1A"
        focus: true
        Keys.onPressed: function(event) {
            switch (event.key) {
                case Qt.Key_Up: vehicle.accelerate(); break;
                case Qt.Key_Down: vehicle.decelerate(); break;
                case Qt.Key_Left: vehicle.toggleLeftSignal(); break;
                case Qt.Key_Right: vehicle.toggleRightSignal(); break;
                case Qt.Key_H: vehicle.toggleHighBeam(); break;
                case Qt.Key_E:
                    if (vehicle.engineRunning) vehicle.stopEngine();
                    else vehicle.startEngine();
                    break;
                case Qt.Key_Space: vehicle.toggleSeatBelt(); break;
                case Qt.Key_R: vehicle.resetTrip(); break;
            }
        }

        Item {
            id: topBar
            x: 30
            y: bg.height * 0.04
            width: parent.width - 60
            height: bg.height * 0.06

            Text {
                text: vehicle.currentTime
                color: "#FFFFFF"
                font.pixelSize: parent.height * 0.45
                font.bold: true
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: vehicle.outsideTemp
                    color: "#AAAAAA"
                    font.pixelSize: parent.height * 0.35
                }
                Text { text: "|"; color: "#555"; font.pixelSize: parent.height * 0.35 }
                Text {
                    text: vehicle.engineRunning ? "\u25B6" : "\u25A0"
                    color: vehicle.engineRunning ? "#4CAF50" : "#F44336"
                    font.pixelSize: parent.height * 0.4
                    font.bold: true
                }
                Text {
                    text: vehicle.engineRunning ? "ENGINE ON" : "ENGINE OFF"
                    color: vehicle.engineRunning ? "#4CAF50" : "#888"
                    font.pixelSize: parent.height * 0.25
                    font.bold: true
                }
                Text {
                    text: Math.floor(vehicle.odometer).toFixed(0) + " km"
                    color: "#AAAAAA"
                    font.pixelSize: parent.height * 0.3
                }
            }
        }

        Row {
            id: mainArea
            x: 20
            y: topBar.y + topBar.height + bg.height * 0.02
            width: parent.width - 40
            height: parent.height * 0.65

            Gauge {
                id: speedometer
                width: parent.width * 0.38
                height: parent.height
                value: vehicle.speed
                maxValue: 260
                tickInterval: 20
                title: "km/h"
                arcColor: "#00E5FF"
            }

            Item {
                width: parent.width * 0.04
                height: parent.height
            }

            Column {
                id: centerPanel
                width: parent.width * 0.16
                height: parent.height
                spacing: parent.height * 0.03
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.40
                    color: "#1A1A2E"
                    radius: 10
                    border.width: 1
                    border.color: "#333"

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text { text: "GEAR"; color: "#666"; font.pixelSize: parent.parent.width * 0.08; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        Text {
                            text: {
                                var g = ["P","R","N","1","2","3","4","5","6"];
                                var i = vehicle.gear;
                                return i >= 0 && i < g.length ? g[i] : "N";
                            }
                            color: vehicle.engineRunning ? "#00E5FF" : "#555"
                            font.pixelSize: parent.parent.width * 0.28
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text { text: "ODOMETER"; color: "#555"; font.pixelSize: parent.parent.width * 0.06; anchors.horizontalCenter: parent.horizontalCenter; topPadding: 5 }
                        Text { text: vehicle.odometer.toFixed(1) + " km"; color: "#AAA"; font.pixelSize: parent.parent.width * 0.09; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                Item { width: 1; height: parent.height * 0.03 }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.30
                    color: "#1A1A2E"
                    radius: 10
                    border.width: 1
                    border.color: "#333"

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "\u26FD"
                            color: vehicle.fuelLevel > 20 ? "#4CAF50" : (vehicle.fuelLevel > 10 ? "#FFC107" : "#F44336")
                            font.pixelSize: parent.parent.width * 0.15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle {
                            width: parent.parent.width * 0.7
                            height: parent.parent.height * 0.2
                            color: "#2A2A3A"
                            radius: 4
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                anchors.left: parent.left; anchors.leftMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height * 0.7
                                width: parent.width * Math.max(0.02, vehicle.fuelLevel / 100) - 4
                                radius: 3
                                color: vehicle.fuelLevel > 20 ? "#4CAF50" : (vehicle.fuelLevel > 10 ? "#FFC107" : "#F44336")
                            }
                        }

                        Text { text: vehicle.fuelLevel.toFixed(0) + "%"; color: "#AAA"; font.pixelSize: parent.parent.width * 0.1; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                Item { width: 1; height: parent.height * 0.03 }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.18
                    color: "#1A1A2E"
                    radius: 10
                    border.width: 1
                    border.color: "#333"

                    Row {
                        anchors.centerIn: parent
                        spacing: 6

                        Text { text: "\u26A1"; font.pixelSize: parent.parent.width * 0.08; anchors.verticalCenter: parent.verticalCenter }
                        Column {
                            spacing: 1
                            Text { text: "BAT"; color: "#666"; font.pixelSize: parent.parent.width * 0.04; font.bold: true }
                            Text { text: vehicle.batteryVoltage.toFixed(1) + "V"; color: "#AAA"; font.pixelSize: parent.parent.width * 0.07; font.bold: true }
                        }
                    }
                }
            }

            Item {
                width: parent.width * 0.04
                height: parent.height
            }

            Gauge {
                id: tachometer
                width: parent.width * 0.38
                height: parent.height
                value: vehicle.rpm
                maxValue: 8000
                tickInterval: 1000
                title: "RPM"
                arcColor: "#FF3D00"
                warningThreshold: 0.7
                dangerThreshold: 0.88
            }
        }

        IndicatorPanel {
            id: indicatorPanel
            x: 40
            y: mainArea.y + mainArea.height + bg.height * 0.02
            width: parent.width - 80
            height: bg.height * 0.07

            leftSignalOn: vehicle.leftSignal
            rightSignalOn: vehicle.rightSignal
            highBeamOn: vehicle.highBeam
            checkEngineOn: vehicle.checkEngine
            seatBeltOn: vehicle.seatBelt
            blinkActive: vehicle.engineRunning && vehicle.signalBlink
        }

        Rectangle {
            id: helpBar
            x: 30
            y: indicatorPanel.y + indicatorPanel.height + bg.height * 0.02
            width: parent.width - 60
            height: bg.height * 0.08
            color: "#1A1A2E"
            radius: 8
            border.width: 1
            border.color: "#333"

            Row {
                anchors.centerIn: parent
                spacing: 30

                Column {
                    spacing: 2
                    Text { text: "\u2191 ACCEL"; color: "#888"; font.pixelSize: 13; font.bold: true }
                    Text { text: "\u2193 BRAKE"; color: "#888"; font.pixelSize: 13; font.bold: true }
                }
                Text { text: "|"; color: "#444"; anchors.verticalCenter: parent.verticalCenter }

                Column {
                    spacing: 2
                    Text { text: "\u2190 L SIG"; color: "#888"; font.pixelSize: 13; font.bold: true }
                    Text { text: "\u2192 R SIG"; color: "#888"; font.pixelSize: 13; font.bold: true }
                }
                Text { text: "|"; color: "#444"; anchors.verticalCenter: parent.verticalCenter }

                Column {
                    spacing: 2
                    Text { text: "E Engine"; color: "#888"; font.pixelSize: 13; font.bold: true }
                    Text { text: "H High Beam"; color: "#888"; font.pixelSize: 13; font.bold: true }
                }
                Text { text: "|"; color: "#444"; anchors.verticalCenter: parent.verticalCenter }

                Column {
                    spacing: 2
                    Text { text: "Space Seatbelt"; color: "#888"; font.pixelSize: 13; font.bold: true }
                    Text { text: "R Reset Trip"; color: "#888"; font.pixelSize: 13; font.bold: true }
                }
            }
        }
    }
}
