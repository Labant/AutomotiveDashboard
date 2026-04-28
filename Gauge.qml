import QtQuick 2.15

Item {
    id: root

    property double value: 0
    property double maxValue: 260
    property int tickInterval: 20
    property string title: "km/h"
    property color arcColor: "#00E5FF"
    property color warningColor: "#FFC107"
    property color dangerColor: "#F44336"
    property double warningThreshold: 0.65
    property double dangerThreshold: 0.85

    readonly property double startDeg: 140
    readonly property double sweepDeg: 260
    readonly property double endDeg: startDeg + sweepDeg
    readonly property double ratio: maxValue > 0 ? Math.min(value / maxValue, 1.0) : 0

    property double animatedRatio: ratio

    Behavior on animatedRatio {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    onRatioChanged: animatedRatio = ratio
    onAnimatedRatioChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            var w = width;
            var h = height;
            ctx.clearRect(0, 0, w, h);

            var cx = w / 2;
            var cy = h / 2;
            var r = Math.min(cx, cy) - 15;
            if (r <= 10) return;
            var arcWidth = r * 0.12;

            var sa = root.startDeg * Math.PI / 180;
            var ea = root.endDeg * Math.PI / 180;
            var sweep = (root.endDeg - root.startDeg) * Math.PI / 180;

            var fillEnd = sa + root.animatedRatio * sweep;

            ctx.lineCap = "round";

            ctx.beginPath();
            ctx.arc(cx, cy, r, sa, ea);
            ctx.lineWidth = arcWidth;
            ctx.strokeStyle = "#2A2A3A";
            ctx.stroke();

            if (root.animatedRatio > 0.01) {
                var fillColor;
                if (root.animatedRatio < root.warningThreshold)
                    fillColor = root.arcColor;
                else if (root.animatedRatio < root.dangerThreshold)
                    fillColor = root.warningColor;
                else
                    fillColor = root.dangerColor;

                ctx.beginPath();
                ctx.arc(cx, cy, r, sa, fillEnd);
                ctx.lineWidth = arcWidth;
                ctx.strokeStyle = fillColor;
                ctx.stroke();
            }

            var numMajor = Math.floor(root.maxValue / root.tickInterval);
            for (var i = 0; i <= numMajor; i++) {
                var val = i * root.tickInterval;
                var ang = sa + (val / root.maxValue) * sweep;
                var isMajor = (i % 2 === 0);
                var innerR = isMajor ? r - r * 0.11 : r - r * 0.07;
                var outerR = r - arcWidth / 2;

                ctx.beginPath();
                ctx.moveTo(cx + innerR * Math.cos(ang), cy + innerR * Math.sin(ang));
                ctx.lineTo(cx + outerR * Math.cos(ang), cy + outerR * Math.sin(ang));
                ctx.lineWidth = isMajor ? 2 : 1;
                ctx.strokeStyle = isMajor ? "#C0C0C0" : "#666666";
                ctx.stroke();

                if (isMajor) {
                    var labelR = r - r * 0.2;
                    ctx.fillStyle = "#A0A0A0";
                    ctx.font = "bold " + Math.round(r * 0.08) + "px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText(val.toString(),
                        cx + labelR * Math.cos(ang),
                        cy + labelR * Math.sin(ang));
                }
            }

            ctx.beginPath();
            ctx.arc(cx, cy, r * 0.12, 0, 2 * Math.PI);
            ctx.fillStyle = "#0D0D1A";
            ctx.fill();

            var needleLen = r * 0.78;
            var needleAng = sa + root.animatedRatio * sweep + Math.PI / 2;
            ctx.save();
            ctx.translate(cx, cy);
            ctx.rotate(needleAng);

            ctx.beginPath();
            ctx.moveTo(0, -needleLen);
            ctx.lineTo(-r * 0.02, r * 0.06);
            ctx.lineTo(r * 0.02, r * 0.06);
            ctx.closePath();

            var needleColor;
            if (root.animatedRatio < root.warningThreshold)
                needleColor = "#FF3D00";
            else if (root.animatedRatio < root.dangerThreshold)
                needleColor = "#FF9800";
            else
                needleColor = root.dangerColor;

            ctx.fillStyle = needleColor;
            ctx.fill();
            ctx.restore();

            ctx.beginPath();
            ctx.arc(cx, cy, r * 0.035, 0, 2 * Math.PI);
            ctx.fillStyle = "#FF3D00";
            ctx.fill();

            ctx.beginPath();
            ctx.arc(cx, cy, r * 0.018, 0, 2 * Math.PI);
            ctx.fillStyle = "#333";
            ctx.fill();
        }

        Component.onCompleted: requestPaint()
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.40
        text: root.value.toFixed(0)
        color: "#FFFFFF"
        font.pixelSize: parent.height * 0.13
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.52
        text: root.title
        color: "#888888"
        font.pixelSize: parent.height * 0.045
    }
}
