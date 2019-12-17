import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import MqttClient 1.0
import Modbus 1.0


Page {
    property var relHum
    property var temp
    property var wetBulbTemp
    property var dewPoint
    property var mqttPort: "1883"

    MqttClient {
        id: client
        hostname: "52.67.201.215"
        port: mqttPort
        username: "cox2hTvqVWTlTAqeCO89"
    }

    width: 800
    height: 380

    header: Label {
        text: qsTr("MODBUS")
        font.pixelSize: Qt.application.font.pixelSize
        padding: 10
    }

    Text {
        text: qsTr("NOVUS RHT Climate")
        font.bold: true
        font.pixelSize: 24
        x: 10
    }

    Button {
        id: connectButton
        x: 300
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

    ModbusRegisterListModel {
        id: registerListModel
        modbusRegisterType: ModbusRegisterListModel.Register
        outputType: ModbusRegisterListModel.Integer32
        registerReadAddr: 0
        registerReadSize: 8
    }

    Component {
        id: registerDelegate
        Item {
            width: 180; height: 80;
            Column {
                Rectangle {
                    id: registerName
                    color: if (index===0) {
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
//                    gradient:
//                        Gradient {
//                        GradientStop { position: 0.0; color:
//                                if (index===0) {
//                                    "#3066BE"
//                                }
//                                else if (index===1) {
//                                    "#00FFC5"
//                                }
//                                else if (index===2) {
//                                    "#8CC7A1"
//                                }
//                                else if (index===3) {
//                                    "#F19953"
//                                }
//                        }
//                        GradientStop { position: 1.0; color:
//                                if (index===0) {
//                                    "#688FCF"
//                                }
//                                else if (index===1) {
//                                    "#5CFFDA"
//                                }
//                                else if (index===2) {
//                                    "#B5DBC3"
//                                }
//                                else if (index===3) {
//                                    "#F6BE91"
//                                }
//                        }
//                    }
                    radius: 10
                    height: 70
                    width: 500
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 15
                        text: if (index===0) {
                                  relHum = display/10
                                  '<b>Relative Humidity</b><br />' + relHum + '%'
                              }
                              else if (index===1){
                                  temp = display/10
                                  '<b>Temperature</b><br />' + temp + '°C'
                              }
                              else if (index===2){
                                  wetBulbTemp = display/10
                                  '<b>Wet Bulb Temperature</b><br />' + wetBulbTemp + '°C'
                              }
                              else if (index===3){
                                  dewPoint = display/10
                                  '<b>Dew Point</b><br />' + dewPoint + '°C'
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
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            onTriggered: registerListModel.readRegisters()
            if (client.state === MqttClient.Connected) {
                client.publish("v1/devices/me/telemetry", "{\"relHum\":\"" + relHum + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"temp\":\"" + temp + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"wetBulbTemp\":\"" + wetBulbTemp + "\"}")
                client.publish("v1/devices/me/telemetry", "{\"dewPoint\":\"" + dewPoint + "\"}")
            }
        }
    }

    Image {
        id: rhtClimate
        source: "img/rht-climate.jpg"
        fillMode: Image.PreserveAspectFit
        width: 280
        anchors.right: parent.right
    }

    Component.onCompleted: {
        registerListModel.connectToSerial();
        console.log("Serial connected!");
    }
}
