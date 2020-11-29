import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root
    color: "white"

//    property alias oosNum: lvItemsList.model.count

    Component.onCompleted: {
        beInventory.getOOSProducts();
    }

//    Label {
//        id: title
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 0.0211 * parent.height
//        font {
//            pixelSize: UIMaterials.fontsizeM
//            bold: true
//            family: UIMaterials.fontRobotoLight
//        }
//        color: UIMaterials.greenPrimary
//        text: "Danh sách sản phẩm sắp hết hàng"
//    }

    ListView {
        id: lvItemsList
        x: 0
        anchors.top: parent.top
        anchors.topMargin: 0.0422 * root.height
        width: root.width / 2
        height: parent.height - lvItemsList.y
        clip: true
        cacheBuffer: 50
        model: beInventory.oosModel

        delegate: Rectangle {
            id: itemDelegate
            width: lvItemsList.width
            height: 0.1483 * root.height
            color: (lvItemsList.currentIndex === index) ? UIMaterials.colorNearWhite : "white"

            Label {
                id: lblItemName
                width: parent.width
                height: parent.height / 2
                anchors.top: parent.top
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font {
                    pixelSize: UIMaterials.fontsizeS
                    bold: (lvItemsList.currentIndex === index) ? true : false
                    family: UIMaterials.fontRobotoLight
                }
                color: (lvItemsList.currentIndex === index) ? UIMaterials.greenPrimary : "black"
                text: lvItemsList.model[index].name + " @ " + lvItemsList.model[index].unit
            }

            Label {
                id: lblItemBarcode
                width: parent.width
                height: parent.height / 2
                anchors.top: lblItemName.bottom
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: (lvItemsList.currentIndex === index) ? UIMaterials.greenPrimary : "black"
                text: lvItemsList.model[index].barcode
            }

            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: UIMaterials.colorTrueGray
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    lvItemsList.currentIndex = index
                }
            }
        }
    }

    Rectangle {
        id: pnItemDetail
        width: root.width/2
        height: lvItemsList.height
        anchors.top: lvItemsList.top
        anchors.right: parent.right
        color: UIMaterials.colorNearWhite

        InfoCard {
            id: icInstockQuantity
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 0.0585 * parent.width
            width: parent.width - anchors.leftMargin
            titleHeight: 0.0636 * root.height
            infoHeight: 1.5 * titleHeight
            editable: false

            titleFontSize: UIMaterials.fontsizeS
            titleColor: UIMaterials.grayDark
            infoFontsize: UIMaterials.fontsizeM
            infoColor: "black"

            titleText: "Số lượng trong kho"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["quantity"]
        }

        InfoCard {
            id: icSellingRate
            anchors.top: icInstockQuantity.bottom
            anchors.topMargin: 0.0423 * root.height
            anchors.left: icInstockQuantity.left
            width: icInstockQuantity.width
            titleHeight: icInstockQuantity.titleHeight
            infoHeight: icInstockQuantity.infoHeight
            editable: false

            titleFontSize: UIMaterials.fontsizeS
            titleColor: UIMaterials.grayDark
            infoFontsize: UIMaterials.fontsizeM
            infoColor: "black"

            titleText: "Tốc độ tiêu thụ"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["selling_rate"]
        }

        InfoCard {
            id: icOOSDate
            anchors.top: icSellingRate.bottom
            anchors.topMargin: 0.0423 * root.height
            anchors.left: icSellingRate.left
            width: icSellingRate.width
            titleHeight: icSellingRate.titleHeight
            infoHeight: icSellingRate.infoHeight
            editable: false

            titleFontSize: UIMaterials.fontsizeS
            titleColor: UIMaterials.grayDark
            infoFontsize: UIMaterials.fontsizeM
            infoColor: "black"

            titleText: "Ngày hết hàng dự kiến"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["oos_date"]
        }

        Button {
            id: btnRemove
            width: 0.3509 * parent.width
            height: 0.1271 * root.height
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height / 5
            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.right: parent.horizontalCenter
//            anchors.rightMargin: 20

            background: Rectangle {
                id: rectBtnRemove
                anchors.fill: parent
                color: UIMaterials.grayPrimary
                radius: 10
            }

            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
                text: "Gỡ\nThông Báo"
            }

            onPressed: {
                rectBtnRemove.opacity = 0.6
            }

            onReleased: {
                rectBtnRemove.opacity = 1
            }
        }

//        Button {
//            id: btnBuy
//            width: btnRemove.width
//            height: btnRemove.height
//            anchors.top: btnRemove.top
//            anchors.left: parent.horizontalCenter
//            anchors.leftMargin: 20

//            background: Rectangle {
//                id: rectBtnBuy
//                anchors.fill: parent
//                color: UIMaterials.greenPrimary
//                radius: 10
//            }

//            Text {
//                anchors.centerIn: parent
//                font {
//                    pixelSize: UIMaterials.fontsizeS
//                    family: UIMaterials.fontRobotoLight
//                }
//                color: "white"
//                text: "Đặt Hàng"
//            }

//            onPressed: {
//                rectBtnBuy.opacity = 0.6
//            }

//            onReleased: {
//                rectBtnBuy.opacity = 1
//            }
//        }
    }
}
