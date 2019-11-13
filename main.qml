import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: qsTr("Tabs")


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Forno {
            // TODO: tirar
        }

        Modbus_RHT {
            // TODO: traduzir
            // TODO: adicionar MQTT para Thingsboard
        }

        AnalogOut {
            // TODO: tirar
        }

        DigitalIn {
        }

        // TODO: adicionar OPC UA tank

    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        height:60
        TabButton {
            text: qsTr("Entrada Analógica")
            height:60

        }

        TabButton {
            text: qsTr("ModBus")
            height:60
        }

        TabButton {
            text: qsTr("Saída Analógica")
            height:60
        }

        TabButton {
            text: qsTr("Entrada Digital")
            height:60
        }
    }

}
