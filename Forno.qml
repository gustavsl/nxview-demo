import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import CustomPlot 1.0
import FileIO 1.0


Page {
    width: 1024
    height: 500
    property var kp: 0.2
    property var ki: 0.005
    property var kd: 0
    property var error: 0
    property var prevError: 0
    property var integral: 0
    property var derivative: 0
    property var output: 0
    property var count: 0

    header: Label {
        text: qsTr("ENTRADA ANALÓGICA")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Text {
        text: qsTr("Termopar tipo T")
        font.bold: true
        font.pixelSize: 48
        x: 10
    }


//    Slider {
//        id: setPointSlider
//        x: 6*parent.width/7
//        y: 0
//        stepSize: 1
//        from: 0
//        to: 120
//        orientation: Qt.Vertical
//        height: 350
//    }

//    Gauge {
//        id: setPointGauge
//        height:350
//        minimumValue: 0
//        maximumValue: 120
//        anchors.verticalCenter: setPointSlider.verticalCenter
//        anchors.right: setPointSlider.left
//        value: setPointSlider.value
//        Behavior on value {
//            NumberAnimation {
//                duration: 500
//            }
//        }

//        style: GaugeStyle {
//            valueBar: Rectangle {
//                implicitWidth: 16
//                color: Qt.rgba(setPointGauge.value / setPointGauge.maximumValue, 0, 1 - setPointGauge.value / setPointGauge.maximumValue, 1)
//            }
//        }
//    }

    Gauge {
        id: tempGauge
        height:350
        minimumValue: 0
        maximumValue: 120
        anchors.verticalCenter: setPointSlider.verticalCenter
        x: 7*parent.width/9
        value: 0
        Behavior on value {
            NumberAnimation {
                duration: 500
            }
        }

        style: GaugeStyle {
            valueBar: Rectangle {
                implicitWidth: 28
                color: Qt.rgba(tempGauge.value / tempGauge.maximumValue, 0, 1 - tempGauge.value / tempGauge.maximumValue, 1)
            }
        }
    }
    
    FileIO {
        id: analogIn
        source: "/analog_ios/ain1/input"
    }

//    FileIO {
//        id: digitalOut
//        source: "/digital_ios/dout1/value"
//    }

//    Timer {
//        interval: 1000
//        running: true
//        repeat: true
//        onTriggered: {
//            error = setPointSlider.value - analogIn.read()/10
//           // console.log("Error: " + error)
//            integral = integral + error * 1
//            derivative = (error - prevError) / 1
//            output = kp*error+ki*integral+kd*derivative
//           // console.log("Output: " + output)
//            prevError = error
//            if (count < output)
//            {
//                digitalOut.write("1")
//            }
//            else {
//                digitalOut.write("0")
//            }
//            if (count == 10) {
//                count = 0
//            }
//            else {
//                count++
//            }

//        }
//    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            tempGauge.value = analogIn.read()/10;
            tempGaugeDisplay.text = Math.round(tempGauge.value*10)/10 + "°C";

        }
    }
//    Text {
//        text: "<b>Set point<b>"
//        anchors.top: setPointSlider.bottom
//        font.pixelSize: 30
//        anchors.horizontalCenter: setPointSlider.horizontalCenter
//    }

//    Rectangle {
//        Text {
//            text: setPointSlider.value + "°C"
//            font.pixelSize: 30
//            color: "white"
//            anchors.centerIn: parent
//        }
//        anchors.horizontalCenter: setPointSlider.horizontalCenter
//        y: 390
//        radius: 10
//        width: 120
//        height: 60
//        color: "green"
//    }

    Text {
        text: "<b>Temperatura<b>"
        anchors.top: tempGauge.bottom
        font.pixelSize: 30
        anchors.horizontalCenter: tempGauge.horizontalCenter
    }

    Rectangle {
        Text {
            id: tempGaugeDisplay
            text: ""
            font.pixelSize: 30
            color: "white"
            anchors.centerIn: parent
        }
        anchors.horizontalCenter: tempGauge.horizontalCenter
        y: 390
        radius: 10
        width: 120
        height: 60
        color: "green"
    }


    Item {
        id: plotForm


        CustomPlotItem {
            id: customPlot
            height:360
            width:600
            y: 70

            Component.onCompleted: initCustomPlot()
        }
    }

}

