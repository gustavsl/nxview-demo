import QtQuick 2.9
import QtQuick.Controls 2.2
import FileIO 1.0
import QtQuick.Extras 1.4

Page {
    width: 800
    height: 380

    FileIO {
        id: digitalIn1
        source: "/digital_ios/din4/value"
    }

    FileIO {
        id: digitalIn2
        source: "/digital_ios/din3/value"
    }

    FileIO {
        id: digitalIn3
        source: "/digital_ios/din2/value"
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered:
        {
            statusIndicator1.active = Number(digitalIn1.read());
            statusIndicator2.active = Number(digitalIn2.read());
            statusIndicator3.active = Number(digitalIn3.read());
        }
    }

    header: Label {
        text: qsTr("DIGITAL IN")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    Text {
        text: qsTr("GPIO read")
        font.bold: true
        font.pixelSize: 48
        x: 10
    }


    StatusIndicator {
        id: statusIndicator1
        width: 100
        height:100
        color: "red"
        x: parent.width/3 - width/2
        anchors.verticalCenter: parent.verticalCenter
    }

    StatusIndicator {
        id: statusIndicator2
        width: 100
        height:100
        color: "yellow"
        anchors.centerIn: parent
    }

    StatusIndicator {
        id: statusIndicator3
        width: 100
        height:100
        color: "green"
        x: 2*parent.width/3 - width/2
        anchors.verticalCenter: parent.verticalCenter
    }

}
