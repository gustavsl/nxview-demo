import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    title: qsTr("Tabs")


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Modbus_RHT {
            // TODO: traduzir
            // TODO: adicionar MQTT para Thingsboard
        }

        DigitalIn {
        }

        // TODO: adicionar OPC UA tank

    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        height:40
//        TabButton {
//            text: qsTr("Entrada Analógica")
//            height:60

//        }

        TabButton {
            text: qsTr("ModBus")
            height:40
        }

//        TabButton {
//            text: qsTr("Saída Analógica")
//            height:60
//        }

        TabButton {
            text: qsTr("Digital In")
            height:40
        }
    }

}
