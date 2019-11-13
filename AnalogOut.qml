import QtQuick 2.9
import QtQuick.Controls 2.2
import FileIO 1.0

Page {
    width: 1024
    height: 500

    FileIO {
        id: analogOut
        source: "/analog_outputs/aout1/out_eng_units"
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: analogOut.write(analogDial.value)
    }

    header: Label {
        text: qsTr("SAÍDA ANALÓGICA")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Text {
        text: qsTr("Saída 0 a 10V")
        font.bold: true
        font.pixelSize: 48
        x: 10
    }

    Dial {
        id: analogDial
        live: true
        from: 0
        to: 10000
        stepSize: 1
        snapMode: Dial.SnapAlways
        width: 400
        height: 400
        anchors.centerIn: parent
    }

    Text {
        id: analogValue
        text: Math.round(analogDial.value) + "mV"
        font.bold: true
        font.pixelSize: 64
        anchors.centerIn: parent
    }

}
