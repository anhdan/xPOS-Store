import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2

import "."

Item {
    id: root


    //========================= I. Control panel
    Rectangle {
        id: pnControl
        width: 0.332 * parent.width
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.colorNearWhite

        //----- I.1. Product search box
        SearchBox {
            id: searchBox
            width: 0.9412 * parent.width
            height: 0.0847 * parent.height
            y: 0.0282 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColor: "white"
            textColor: UIMaterials.colorTaskBar
            placeholderText: "Mã vạch/Tên viết tắt ..."
        }

        //----- I.2. Number of products in process
        Column {
            spacing: 0
            width: parent.width
            x: 0
            y: 0.1554 * parent.height

            Label {
                id: titItemsNumber
                width: parent.width
                height: 0.0565 * parent.height
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.grayDark
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "Danh sách chờ xử lý"
            }

//            Label {
//                property int itemsNum: 0

//                id: lblItemsNumber
//                width: parent.width
//                height: titItemsNumber.height
//                font {
//                    pixelSize: UIMaterials.fontsizeM
//                    weight: Font.Bold
//                    family: UIMaterials.fontRobotoLight
//                }
//                color: UIMaterials.colorTrueBlue
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                text: lblItemsNumber.itemsNum.toString() + " sản phẩm"
//            }
        }
    }

    //========================= I. Product info panel
    Rectangle {
        id: pnInfo
        width: 0.668 * parent.width
        height: parent.height
        x: pnControl.width
        y: 0
        color: "white"
    }
}
