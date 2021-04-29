import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

ApplicationWindow {
    id: root
    minimumWidth: 1200 + 90
    maximumWidth: 1200 + 90
    height: 700 + 20
    visible: true
    title: qsTr("Simulator")


    Rectangle{
        id: rec_1
        width: parent.width
        height: parent.height * 0.06
        color: "#e3fde3"


        Row {
            id: row_1
            width: parent.width * 0.53
            height: parent.height - 6
            anchors.centerIn: parent
            spacing: 5



            ComboBox {
                id: combobox
                height: parent.height
                visible: true
                width: parent.width*0.65
                font.pixelSize: 15
                clip: false
                font.weight: Font.Normal
                topPadding: 0
                currentIndex: 0

                model: ListModel{
                    id: combobox_items
                }
            }



            Button {
                text: qsTr("Add")
                topPadding: 10
                width: parent.width*0.3
                height: parent.height
                onClicked: {
                    if (combobox_items.count !== 0){
                        var cbb_txt_tokens = combobox.currentText.split(" ").join('').split("|")
                        model.append({
                                         full_uuid: cbb_txt_tokens[2],
                                         uuid: cbb_txt_tokens[2].slice(0,3),
                                         type: cbb_txt_tokens[0]
                                     })
                        combobox_items.remove(combobox.currentIndex)
                    }
                }
            }



        }
    }



    Rectangle{
        id: grid_rect
        width: parent.width
        height: parent.height - rec_1.height
        anchors.top: rec_1.bottom


        ListModel{
            id: model
        }



        Component {
            id: delegate

            Rectangle {
                width: 110
                height: 100
                border.color: "transparent"
                border.width: 2
                radius: 3


                Column{
                    anchors.fill: parent



                    Rectangle{
                        width: parent.width
                        height: parent.height * 0.3
                        color: "red"
                        Text {
                            font.pointSize: 15
                            text: qsTr("uuid: " + uuid)
                            anchors.centerIn: parent
                        }

                        radius: 3
                    }



                    Rectangle{
                        width: parent.width
                        height: parent.height * 0.7
                        color: "#add8e6"


                        Column{
                            anchors.fill: parent
                            spacing: 10

                            Text {
                                text: qsTr("type: " + type)
                                font.pointSize: 15
                                anchors.centerIn: parent
                            }
                        }


                        radius: 3
                    }
                }



                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var component = Qt.createComponent("sim_viewer.qml")
                        var window    = component.createObject(root, {
                                                                   "device_uuid": full_uuid,
                                                                   "device_type": type,
                                                               })
                        window.show()
                    }
                }



            }
        }


        GridView{
            id: grid_view
            anchors.fill: parent
            anchors.topMargin: 50
            anchors.leftMargin: 50
            cellHeight: 120
            cellWidth:120
            model: model
            delegate: delegate
        }


    }



    Component.onCompleted: {
        simulator.device_uuid_list_slot()
        var values = simulator.simulator_uuid_list
        var uuid_s = values[0]
        var type_s = values[1]
        for(var i=0; i<uuid_s.length; i++){
            combobox_items.append({"uuid":type_s[i]  + "       ||      " +  uuid_s[i]});
        }
    }
}
