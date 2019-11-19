import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import MqttClient 1.0

Page {
    property var relHum
    property var temp
    property var wetBulbTemp
    property var dewPoint
    property var mqttPort: "1883"

    MqttClient {
        id: client
        hostname: "18.231.72.4"
        port: mqttPort
        username: "0LaQ0yevPDoHySsdyUCi"
    }

    width: 800
    height: 380

    header: Label {
        text: qsTr("MODBUS")
        font.pixelSize: Qt.application.font.pixelSize
        padding: 10
    }

    Text {
        text: qsTr("Simulated Modbus Device")
        font.bold: true
        font.pixelSize: 24
        x: 10
    }

    Button {
        id: connectButton
        x: 370
        y: -5
        text: client.state === MqttClient.Connected ? "Disconnect" : "Connect"
        onClicked: {
            if (client.state === MqttClient.Connected) {
                client.disconnectFromHost()
                messageModel.clear()
                tempSubscription.destroy()
                tempSubscription = 0
            } else
                client.connectToHost()
        }
    }

    ListModel {
        id: registerListModel
        ListElement {

        }
        ListElement {

        }
        ListElement {

        }
        ListElement {

        }
    }

    function getRandomArbitrary(min, max) {
      return Math.random() * (max - min) + min;
    }

    Component {
        id: registerDelegate
        Item {
            width: 180; height: 80;
            Column {
                Rectangle {
                    id: registerName
                    gradient:
                        Gradient {
                        GradientStop { position: 0.0; color:
                                if (index===0) {
                                    "#3066BE"
                                }
                                else if (index===1) {
                                    "#00FFC5"
                                }
                                else if (index===2) {
                                    "#8CC7A1"
                                }
                                else if (index===3) {
                                    "#F19953"
                                }
                        }
                        GradientStop { position: 1.0; color:
                                if (index===0) {
                                    "#688FCF"
                                }
                                else if (index===1) {
                                    "#5CFFDA"
                                }
                                else if (index===2) {
                                    "#B5DBC3"
                                }
                                else if (index===3) {
                                    "#F6BE91"
                                }
                        }
                    }
                    radius: 10
                    height: 70
                    width: 500
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 15
                        text: if (index===0) {
                                  '<b>Relative humidity</b><br />' + relHum + '%'
                              }
                              else if (index===1){
                                  '<b>Temperature</b><br />' + temp + '°C'
                              }
                              else if (index===2){
                                  '<b>Wet bulb temperature</b><br />' + wetBulbTemp + '°C'
                              }
                              else if (index===3){
                                  '<b>Dew point</b><br />' + dewPoint + '°C'
                              }

                        font.pixelSize: 24

                    }
                }
            }
        }
    }


    ListView {
        id: modbusRegisterListView
        x: 10
        y: 50
        height: 400
        model: registerListModel
        delegate: registerDelegate
    }


    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            relHum = getRandomArbitrary(2,80).toFixed(2)
            temp = getRandomArbitrary(-10,35).toFixed(2)
            wetBulbTemp = (temp - getRandomArbitrary(2,10)).toFixed(2)
            dewPoint = getRandomArbitrary(0,temp).toFixed(2)
            if (client.state === MqttClient.Connected) {
                client.publish("v1/devices/me/telemetry", "{\"relHum\":\"" + relHum + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"temp\":\"" + temp + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"wetBulbTemp\":\"" + wetBulbTemp + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"dewPoint\":\"" + dewPoint + "\"}")
            }
        }
    }

//    Image {
//        id: rhtClimate
//        source: "img/rht-climate.jpg"
//        fillMode: Image.PreserveAspectFit
//        width: 400
//        anchors.right: parent.right
//    }

//    Component.onCompleted: {
//        registerListModel.connectToSerial();
//        console.log("Serial connected!");
//    }
}
