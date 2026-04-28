import QtQuick 2.15

Item {
    id: root

    property bool leftSignalOn: false
    property bool rightSignalOn: false
    property bool highBeamOn: false
    property bool checkEngineOn: false
    property bool seatBeltOn: true
    property bool blinkActive: false

    Row {
        anchors.centerIn: parent
        spacing: parent.width * 0.04

        IndicatorLight {
            width: root.height * 0.6
            height: root.height * 0.6
            label: "\u2190"
            active: root.leftSignalOn && root.blinkActive
            colorOn: "#4CAF50"
        }

        IndicatorLight {
            width: root.height * 0.6
            height: root.height * 0.6
            label: "\u2192"
            active: root.rightSignalOn && root.blinkActive
            colorOn: "#4CAF50"
        }

        Rectangle {
            width: 2
            height: root.height * 0.5
            color: "#444"
            anchors.verticalCenter: parent.verticalCenter
        }

        IndicatorLight {
            width: root.height * 0.55
            height: root.height * 0.55
            label: "H"
            active: root.highBeamOn
            colorOn: "#2196F3"
        }

        IndicatorLight {
            width: root.height * 0.55
            height: root.height * 0.55
            label: "\u26A0"
            active: root.checkEngineOn
            colorOn: "#FFC107"
        }

        IndicatorLight {
            width: root.height * 0.55
            height: root.height * 0.55
            label: "\u25A2"
            active: !root.seatBeltOn
            colorOn: "#F44336"
        }
    }

    component IndicatorLight: Item {
        property string label: ""
        property bool active: false
        property color colorOn: "#4CAF50"

        Rectangle {
            anchors.fill: parent
            radius: width * 0.15
            color: parent.active ? parent.colorOn : "#1A1A2E"
            opacity: parent.active ? 1.0 : 0.3
            border.width: 1
            border.color: parent.active ? parent.colorOn : "#333"

            Behavior on color {
                ColorAnimation { duration: 100 }
            }

            Text {
                anchors.centerIn: parent
                text: parent.parent.label
                color: parent.parent.active ? "#FFFFFF" : "#555"
                font.pixelSize: parent.parent.height * 0.5
                font.bold: true

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }
        }
    }
}
