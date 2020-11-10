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

    property real totalValue: 9999999

    InfoCard {
        id: icTotalValue
        anchors.top: parent.top
        anchors.topMargin: 0.0292 * parent.height
        anchors.left: parent.left
        anchors.leftMargin: 0.0146 * parent.width
        width: 0.2924 * parent.width
        titleHeight: 0.0478 * root.height
        infoHeight: 2 * titleHeight
        editable: false
        isCurrency: true

        titleFontSize: UIMaterials.fontsizeS
        titleColor: UIMaterials.colorTrueRed
        infoFontsize: UIMaterials.fontsizeL
        infoColor: "black"

        titleText: "Tổng vốn tồn kho"
        infoText: totalValue
    }

    ChartView {
        id: chart
        width: 0.6369 * parent.width
        height: parent.height / 2.5
        anchors.top: icTotalValue.top
        anchors.right: parent.right
        anchors.rightMargin: icTotalValue.anchors.leftMargin
//        title: "Production costs"
        legend.visible: false
        antialiasing: true

        PieSeries {
            id: pieOuter
            size: 0.8
            holeSize: 0.5
            PieSlice {
                id: slice;
                label: "\ue900";
                labelFont {
                    pixelSize: UIMaterials.fontsizeS
                    weight: Font.Bold
                    family: UIMaterials.fontCategories
                }
                labelColor: color
                value: 19511;
                color: "#99CA53"

                onPressed: {
                    exploded = true
                }

                onReleased: {
                    exploded = false
                }
            }

            PieSlice {
                label: "\ue901";
                labelFont {
                    pixelSize: UIMaterials.fontsizeS
                    weight: Font.Bold
                    family: UIMaterials.fontCategories
                }
                labelColor: color
                value: 11105;
                color: "#209FDF"

                onPressed: {
                    exploded = true
                }

                onReleased: {
                    exploded = false
                }
            }

            PieSlice {
                label: "\ue903";
                labelFont {
                    pixelSize: UIMaterials.fontsizeS
                    weight: Font.Bold
                    family: UIMaterials.fontCategories
                }
                labelColor: color
                value: 9352;
                color: "#F6A625"

                onPressed: {
                    exploded = true
                }

                onReleased: {
                    exploded = false
                }
            }
        }
    }

    Component.onCompleted: {
        // Set the common slice properties dynamically for convenience
        for (var i = 0; i < pieOuter.count; i++) {
            pieOuter.at(i).labelPosition = PieSlice.LabelOutside;
            pieOuter.at(i).labelVisible = true;
            pieOuter.at(i).borderWidth = 3;
        }
    }


    ListView {
        id: lvItemsList
        x: 0
        y: 0.4 * parent.height
        width: root.width / 2
        height: parent.height - lvItemsList.y
        clip: true
        cacheBuffer: 50
        model: itemModel

        ListModel {
            id: itemModel

            ListElement {
                name: "Cafe rang xay moka"
                unit: "Goi"
                barcode: "08342749827349"
                instock_quantity: 30
                import_date: "1/1/2020"
                expired_date: "20/10/2020"
                selling_rate: "30 sp/tháng"
                item_value: 10000000
            }

            ListElement {
                name: "Den led coworking space"
                unit: "Chiec"
                barcode: "09733249879328"
                instock_quantity: 20
                import_date: "19/9/2019"
                expired_date: "22/11/2020"
                selling_rate: "55 sp/tháng"
                item_value: 99999
            }

            ListElement {
                name: "Be ca mini dat ban"
                unit: "Chiec"
                barcode: "05837328743823"
                instock_quantity: 10
                import_date: "23/3/2018"
                expired_date: "24/12/2020"
                selling_rate: "24 sp/tháng"
                item_value: 78787899
            }
        }

        delegate: Rectangle {
            id: itemDelegate
            width: lvItemsList.width
            height: 0.1274 * root.height
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
                color: (lvItemsList.currentIndex === index) ? UIMaterials.colorTrueRed : "black"
                text: name + " @ " + unit
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
                color: (lvItemsList.currentIndex === index) ? UIMaterials.colorTrueRed : "black"
                text: barcode
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
            titleHeight: 0.0478 * root.height
            infoHeight: 1.6667 * titleHeight
            editable: false

            titleFontSize: UIMaterials.fontsizeS
            titleColor: UIMaterials.grayDark
            infoFontsize: UIMaterials.fontsizeL
            infoColor: "black"

            titleText: "Số lượng trong kho"
            infoText: itemModel.get(lvItemsList.currentIndex)["instock_quantity"]
        }

        InfoCard {
            id: icItemValue
            anchors.top: icInstockQuantity.bottom
            anchors.topMargin: 0.0318 * root.height
            anchors.left: icInstockQuantity.left
            width: icInstockQuantity.width
            titleHeight: icInstockQuantity.titleHeight
            infoHeight: icInstockQuantity.infoHeight

            titleFontSize: UIMaterials.fontsizeS
            titleColor: icInstockQuantity.titleColor
            infoFontsize: UIMaterials.fontsizeL
            infoColor: "black"
            editable: false

            titleText: "Tổng giá vốn"
            infoText: itemModel.get(lvItemsList.currentIndex)["item_value"]
        }

        InfoCard {
            id: icSellingRate
            anchors.top: icItemValue.bottom
            anchors.topMargin: 0.0318 * root.height
            anchors.left: icItemValue.left
            width: icItemValue.width
            titleHeight: icItemValue.titleHeight
            infoHeight: icItemValue.infoHeight

            titleFontSize: UIMaterials.fontsizeS
            titleColor: icInstockQuantity.titleColor
            infoFontsize: UIMaterials.fontsizeL
            infoColor: "black"
            editable: false

            titleText: "Tốc độ tiêu thụ"
            infoText: itemModel.get(lvItemsList.currentIndex)["selling_rate"]
        }

        Button {
            id: btnRemove
            width: 0.3509 * parent.width
            height: 0.0955 * root.height
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
                color: UIMaterials.colorTrueRed
                radius: 10
            }

            Text {
                anchors.centerIn: parent
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
                text: "Tạo\nKhuyến Mãi"
                horizontalAlignment: Text.AlignHCenter
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
