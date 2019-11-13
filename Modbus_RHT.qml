import QtQuick 2.9
import QtQuick.Controls 2.2
import Modbus 1.0

Page {
    width: 1024
    height: 500

    header: Label {
        text: qsTr("MODBUS")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Text {
        text: qsTr("NOVUS RHT Climate")
        font.bold: true
        font.pixelSize: 48
        x: 10
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
            width: 180; height: 100;
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
                    height: 90
                    width: 500
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 15
                        text: if (index===0) {
                                  '<b>Umidade relativa</b><br />' + display/10 + '%'
                              }
                              else if (index===1){
                                  '<b>Temperatura</b><br />' + display/10 + '°C'
                              }
                              else if (index===2){
                                  '<b>Temperatura bulbo úmido</b><br />' + display/10 + '°C'
                              }
                              else if (index===3){
                                  '<b>Ponto de orvalho</b><br />' + display/10 + '°C'
                              }

                        font.pixelSize: 32

                    }
                }
            }
        }
    }


    ListView {
        id: modbusRegisterListView
        x: 10
        y: 80
        height: 400
        model: registerListModel
        delegate: registerDelegate
    }


    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: registerListModel.readRegisters();
    }

    Image {
        id: rhtClimate
        source: "img/rht-climate.jpg"
        fillMode: Image.PreserveAspectFit
        width: 400
        anchors.right: parent.right
    }

    Component.onCompleted: {
        registerListModel.connectToSerial();
        console.log("Serial connected!");
    }
}
