import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14


ApplicationWindow{
    id: stgs
    width: 460
    height: 800
    visible: true
    title: qsTr("Simulator Viewer")

    property string current_date;
    property string current_time;

    property string device_uuid;
    property string device_type;

    property string card_type_1;
    property string card_type_2;

    property string card_fee_1;
    property string card_fee_2;


    Timer{
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            update_time()
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
                id: uuid
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
        width: parent.width
        height: parent.height - rec1.height*5
        anchors.fill: parent
        topPadding: rec1.height
        spacing: height*.15  //0.05


        Column {
            id: col1
            width: parent.width / 2.0
            height: parent.height*0.30  // 0.40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: height*0.04


            Label{
                id: date
                text: current_date
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 18
                topPadding: parent.height*0.50 // 0.40
            }



            Label{
                id: time
                text: current_time
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 32
            }
        }



        Row {
            width: parent.width*0.80
            height: parent.height*0.18
            spacing: parent.width*0.10
            anchors.horizontalCenter: parent.horizontalCenter


            Rectangle {
                id: rec_1
                width: parent.height
                height: parent.height
                color: "red"
                radius: width


                Column{
                    anchors.centerIn: parent
                    spacing: 2


                    Text {
                        text: card_type_1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }


                    Text {
                        text: card_fee_1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }



                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        simulator.card_info_slot(device_uuid, card_type_1, card_fee_1.replace(/[^0-9|.]/g,''))
                    }
                }
            }

            Rectangle {
                width: parent.height
                height: parent.height
                color: "red"
                radius: width
                anchors.right: parent.right



                Column{
                    anchors.centerIn: parent
                    spacing: 2


                    Text {
                        text: card_type_2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }


                    Text {
                        text: card_fee_2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }


        Rectangle {
            width: parent.width * 0.50
            height: parent.height * 0.06
            color: "#696969"
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 2


            Text {
                text: qsTr("settings")
                anchors.centerIn: parent
            }


            MouseArea {
                anchors.fill: parent


                onClicked: {
                    simulator.device_settings_slot(full_uuid)
                    var settings = simulator.simulator_settings
                    var component = Qt.createComponent("settings.qml")
                    var window    = component.createObject(stgs, {
                                                               "device_uuid": device_uuid,
                                                               "device_type": device_type,
                                                               "device_settings": settings
                                                           })
                    window.show()
                    card_type_1 =  settings.types[0].type
                    card_type_2 =  settings.types[1].type

                    card_fee_1 =  settings.types[0].fee + "  TL"
                    card_fee_2=  settings.types[1].fee + "  TL"
                }
            }
        }
    }



    function update_time(){
        if(current_date !== Qt.formatDateTime(new Date(), "dd-MM-yyyy"))
            current_date = Qt.formatDateTime(new Date(), "dd-MM-yyyy")
        if(current_time !== Qt.formatDateTime(new Date(), "hh:mm:ss"))
            current_time = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }
}
