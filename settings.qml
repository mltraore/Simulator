import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

ApplicationWindow {
    id: root
    width: 460
    height: 960
    visible: true
    title: qsTr("Device Settings")

    property string device_uuid;
    property string device_type;
    property var device_settings;

    property string last_update_date: Qt.formatDateTime(new Date(), "dd-MM-yyyy")
    property string last_update_time: Qt.formatDateTime(new Date(), "hh:mm:ss")



    Timer{
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            update_settings()
        }
    }



    Rectangle{
        id: rec1
        width: parent.width
        height: parent.height*0.07
        color: "#dafddf"



        Row {
            anchors.fill: parent
            spacing: 20


            Label {
                text: device_uuid
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 20
                font.pixelSize: 17
            }


            Label {
                id: type
                text: qsTr("|  " + device_type)
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 17
                anchors.right: parent.right
                rightPadding: 20
            }
        }
    }

    Column {
        id: column
        x: 0
        y: 79
        anchors.fill: parent
        topPadding: rec1.height + 20
        spacing: 25


        Row {
            id: row
            width: parent.width
            height: parent.height*0.07 + 10


            Label {
                text: qsTr("Last Update : ")
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 15
                font.pointSize: 16
                anchors.left: parent.left
                anchors.leftMargin: 10
            }



            Label {
                text: last_update_date
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 15
                font.pointSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Label {
                text: last_update_time
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 16
                anchors.right: parent.right
                anchors.rightMargin: 25
            }
        }



        Rectangle {
            id: rectangle
            width: parent.width - 40
            height: parent.height*0.7
            color: "lightgrey"
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 10



            ScrollView {
                id: view
                anchors.fill: parent
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn



                Label {
                    id: label2
                    text: "\n" + device_settings
                }
            }
        }



        Rectangle{
            id: btn_main_page
            width: 150
            height: 50
            color: Qt.rgba(0.1, 0.1, 0.1, 0.45)
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter



            MouseArea {
                anchors.fill: parent

                onClicked: {
                    root.close()

                    // update sim_viewer infos
                    simulator.device_settings_slot(device_uuid)
                    var m_data = simulator.simulator_settings
                    stgs.card_type_1 =  m_data.types[0].type
                    stgs.card_type_2 =  m_data.types[1].type
                    stgs.card_fee_1 =  m_data.types[0].fee + "  TL"
                    stgs.card_fee_2 =  m_data.types[1].fee + "  TL"
                }



                onPressed: {
                    btn_main_page.color = Qt.rgba(0.1, 0.1, 0.1, 0.25)
                }


                onReleased: {
                    btn_main_page.color = Qt.rgba(0.1, 0.1, 0.1, 0.45)
                }
            }
        }
    }

    function update_settings(){
        simulator.device_settings_slot(device_uuid)
        var m_data = simulator.simulator_settings
        if (device_settings !== JSON.stringify(m_data)){
            device_settings = JSON.stringify(m_data)
            last_update_date = Qt.formatDateTime(new Date(), "dd-MM-yyyy")
            last_update_time = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
    }
}
