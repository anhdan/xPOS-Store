import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtCharts 2.0

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root
    color: "white"

//    Label {
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 0.0478 * parent.height
//        font {
//            pixelSize: UIMaterials.fontsizeM
//            bold: true
//            family: UIMaterials.fontRobotoLight
//        }
//        color: UIMaterials.colorAntLogo
//        text: "Danh sách sản phẩm sắp hết hạn sử dụng"
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
        model: beInventory.outDateModel

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
                color: (lvItemsList.currentIndex === index) ? UIMaterials.colorAntLogo : "black"
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
                color: (lvItemsList.currentIndex === index) ? UIMaterials.colorAntLogo : "black"
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

            titleText: "Ngày nhập kho"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["import_date"]
        }

        InfoCard {
            id: icSellingRate
            anchors.top: icInstockQuantity.bottom
            anchors.topMargin: 0.0423 * root.height
            anchors.left: icInstockQuantity.left
            width: icInstockQuantity.width
            titleHeight: icInstockQuantity.titleHeight
            infoHeight: icInstockQuantity.infoHeight

            titleFontSize: UIMaterials.fontsizeS
            titleColor: icInstockQuantity.titleColor
            infoFontsize: UIMaterials.fontsizeM
            infoColor: "black"
            editable: false

            titleText: "Số lượng nhập"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["import_quantity"]
        }

        InfoCard {
            id: icOOSDate
            anchors.top: icSellingRate.bottom
            anchors.topMargin: 0.0423 * root.height
            anchors.left: icSellingRate.left
            width: icSellingRate.width
            titleHeight: icSellingRate.titleHeight
            infoHeight: icSellingRate.infoHeight

            titleFontSize: UIMaterials.fontsizeS
            titleColor: icInstockQuantity.titleColor
            infoFontsize: UIMaterials.fontsizeM
            infoColor: "black"
            editable: false

            titleText: "Ngày hết hạn"
            infoText: lvItemsList.model[lvItemsList.currentIndex]["expired_date"]
        }

        Button {
            id: btnRemove
            width: 0.3509 * parent.width
            height: 0.1271 * root.height
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height / 5
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 20

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

        Button {
            id: btnCreateDiscount
            width: btnRemove.width
            height: btnRemove.height
            anchors.top: btnRemove.top
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 20

            background: Rectangle {
                id: rectBtnCreateDiscount
                anchors.fill: parent
                color: UIMaterials.colorAntLogo
                radius: 10
            }

            Text {
                anchors.centerIn: parent
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: "Tạo\nKhuyến Mãi"
            }

            onPressed: {
                rectBtnCreateDiscount.opacity = 0.6
            }

            onReleased: {
                rectBtnCreateDiscount.opacity = 1
            }
        }
    }
}
