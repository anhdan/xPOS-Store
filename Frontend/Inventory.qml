import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    width: 1280
    height: 720
    color: "#3f444d"
    border.color: "#00000000"
    property alias lbProdName2: lbProdName2

    Label {
        id: label
        x: 407
        color: "#7abd6f"
        text: qsTr("xPOS - Quản lý xuất nhập kho ")
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pixelSize: 32
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: rectangle
        y: 170
        width: 356
        height: 624
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 15

        ComboBox {
            id: cbxSearchCode
            x: 108
            y: 0
            width: 250
            height: 50
            anchors.right: parent.right
            anchors.rightMargin: 0
            editable: true
            font.pixelSize: 20
        }

        Button {
            id: btnSearch
            height: 50
            text: qsTr("Tìm kiếm")
            font.pixelSize: 20
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        Label {
            id: lbProdName
            x: 0
            y: 104
            width: 356
            height: 22
            color: "#2c93f2"
            text: qsTr("Tên sản phẩm")
            font.pixelSize: 20
        }

        Label {
            y: 222
            width: 120
            height: 22
            color: "#2c93f2"
            text: qsTr("Đơn vị")
            anchors.left: parent.left
            anchors.leftMargin: 0
            font.pixelSize: 20
        }

        Label {
            id: lblUnit
            y: 250
            width: 120
            height: 40
            text: qsTr("")
            anchors.left: parent.left
            anchors.leftMargin: 0
            background: Rectangle {
                color: "#337798"
            }
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            x: 156
            y: 222
            width: 200
            height: 22
            color: "#2c93f2"
            text: qsTr("Nhóm sản phẩm")
            anchors.right: parent.right
            anchors.rightMargin: 0
            font.pixelSize: 20
        }

        ComboBox {
            id: cbxCategory
            x: 156
            y: 250
            width: 200
            height: 40
            anchors.right: parent.right
            anchors.rightMargin: 0
            font.pixelSize: 20
            background: Rectangle {
                color: "#337798"
            }
        }

        Label {
            id: lbProdName1
            x: 0
            y: 333
            width: 356
            height: 22
            color: "#2c93f2"
            text: qsTr("Mô tả/Lưu ý")
            font.pixelSize: 20
        }

        Label {
            id: lblDescription
            y: 361
            width: 356
            height: 100
            text: qsTr("")
            anchors.left: parent.left
            anchors.leftMargin: 0
            background: Rectangle {
                color: "#337798"
            }
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: lblName
            x: 0
            y: 132
            width: 356
            height: 40
            background: Rectangle {
                color: "#337798"
            }

            text: qsTr("")
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: btnAddProvider
            x: 0
            y: 503
            width: 140
            height: 60
            text: qsTr("Thêm nhà \n cung cấp")
            font.pixelSize: 20
            background: Rectangle {
                radius: 10
                color: "#d4cb05"
            }
        }

        Button {
            id: btnDeleteProvider
            x: 216
            y: 503
            width: 140
            height: 60
            text: qsTr("Xóa nhà \n cung cấp")
            background: Rectangle {
                color: "#ff6868"
                radius: 10
            }
            font.pixelSize: 20
        }
    }

    Rectangle {
        id: rectangle1
        x: 112
        y: 96
        width: 356
        height: 624
        color: "#00000000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom

        Button {
            id: btnRunDiscount
            x: 216
            width: 140
            height: 68
            text: qsTr("Chạy\nkhuyến mãi")
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            background: Rectangle {
                color: "#7abd6f"
                radius: 10
            }
            font.pixelSize: 20
        }

        Label {
            x: 4
            width: 200
            height: 22
            color: "#2c93f2"
            text: qsTr("Đơn giá")
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.leftMargin: 0
            font.pixelSize: 20
            anchors.left: parent.left
        }

        Label {
            id: lblUnit1
            x: 4
            y: 28
            width: 200
            height: 40
            text: qsTr("")
            anchors.leftMargin: 0
            background: Rectangle {
                color: "#337798"
            }
            font.pixelSize: 20
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: rectangle3
            x: 0
            y: 132
            width: 356
            height: 100
            color: "#3d7798"

            Column {
                id: column
                width: 130
                anchors.rightMargin: 199
                anchors.fill: parent

                Label {
                    width: 130
                    height: parent.height/3
                    color: "#ffffff"
                    text: qsTr("Giá KM:")
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                Label {
                    width: 130
                    height: parent.height/3
                    color: "#ffffff"
                    text: qsTr("Ngày bắt đầu:")
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                Label {
                    width: 130
                    height: parent.height/3
                    color: "#ffffff"
                    text: qsTr("Ngày kết thúc:")
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Column {
                id: column1
                x: 163
                width: 190
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                Label {
                    id: lblDiscountPrice
                    width: 190
                    height: parent.height/3
                    color: "#ffffff"
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    id: lblStartDate
                    width: 190
                    height: parent.height/3
                    color: "#ffffff"
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    id: lblEndDate
                    width: 190
                    height: parent.height/3
                    color: "#ffffff"
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                }
            }

        }

        Label {
            x: 0
            y: 104
            width: 356
            height: 22
            color: "#2c93f2"
            text: qsTr("Chương trình khuyến mãi")
            font.pixelSize: 20
        }

        Label {
            id: lbProdName2
            x: 0
            y: 278
            width: 356
            height: 22
            color: "#2c93f2"
            text: qsTr("Danh sách nhà cung cấp")
            font.pixelSize: 20
        }

        Rectangle {
            id: recProvidersList
            y: 306
            height: 318
            color: "#3d7798"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            ListView {
                id: lvProviders
                anchors.fill: parent
                model: ListModel {
                    ListElement {
                        name: "Test company 1"
                    }

                    ListElement {
                        name: "Test company 2"
                    }
                }
                spacing: 5
                delegate: Button {
                    width: parent.width
                    height: 25
                    contentItem: Text {
                        text: name
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                    }

                    background: Rectangle {
                        color: "#00000000"
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangle2
        x: 116
        y: 96
        width: 356
        height: 624
        color: "#00000000"
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom

        Label {
            width: 356
            height: 22
            color: "#2c93f2"
            text: "Số lượng sản phâm trong kho"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            font.pixelSize: 20
        }

        Label {
            id: lblQuantityInStock
            x: 0
            y: 28
            width: 356
            height: 40
            text: qsTr("")
            anchors.top: lblTest.bottom
            anchors.topMargin: 5
            font.pixelSize: 20
            background: Rectangle {
                color: "#337798"
            }
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: btnAddProvider1
            x: 0
            y: 100
            width: 140
            height: 60
            text: qsTr("Nhập hàng")
            font.pixelSize: 20
            background: Rectangle {
                color: "#d4cb05"
                radius: 10
            }
        }

        Button {
            id: btnDeleteProvider1
            x: 216
            y: 100
            width: 140
            height: 60
            text: qsTr("Thải loại/\nThất thoát")
            font.pixelSize: 20
            background: Rectangle {
                color: "#ff6868"
                radius: 10
            }
        }

        Label {
            x: -8
            y: -8
            width: 356
            height: 22
            color: "#2c93f2"
            text: "Lịch sử cập nhật số lượng"
            font.pixelSize: 20
            anchors.leftMargin: 0
            anchors.topMargin: 208
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Rectangle {
            id: recProvidersList1
            y: 236
            height: 388
            color: "#3d7798"
            anchors.leftMargin: 0
            ListView {
                id: lvUpdateHistory
                model: ListModel {
                    ListElement {
                        name: "Test update history 1"
                    }

                    ListElement {
                        name: "Test update history 2"
                    }
                }
                delegate: Button {
                    width: parent.width
                    height: 25
                    background: Rectangle {
                        color: "#00000000"
                    }
                    contentItem: Text {
                        color: "#ffffff"
                        text: name
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                anchors.fill: parent
                spacing: 5
            }
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 0
        }
    }


}

/*##^## Designer {
    D{i:5;anchors_y:21}D{i:8;anchors_x:112;anchors_y:170}D{i:9;anchors_x:112;anchors_y:170}
D{i:40;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}D{i:38;anchors_width:356;anchors_x:0}
D{i:60;anchors_x:0;anchors_y:8}D{i:61;anchors_y:30}D{i:67;anchors_x:0;anchors_y:8}
D{i:80;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}D{i:79;anchors_width:356;anchors_x:0}
}
 ##^##*/
