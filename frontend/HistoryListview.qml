import QtQuick 2.9
import QtQuick.Controls 2.2

import "."

ListView {
    id: root
    model: historyModel
    cacheBuffer: 10
    x: 0
    y: 0
    spacing: 5

    //========== Model
    ListModel {
        id: historyModel

        ListElement{
            date: "15/06/20"
            time: "10:00"
            action: "Nhập hàng"
            quantity: 100
        }

        ListElement{
            date: "10/01/20"
            time: "07:00"
            action: "Trả hàng"
            quantity: 1
        }
    }


    //========== Delegate
    delegate: Rectangle {
        id: historyDelegate
        width: parent.width
        height: 2.5 * UIMaterials.fontSizeSmall
        color: "transparent"

        Row {
            anchors.fill: parent
            Label {
                id: lblDateTime
                width: historyDelegate.width / 2
                height: historyDelegate.height
                text: date + "\n" + time
                font.pixelSize: UIMaterials.fontSizeSmall
                color: UIMaterials.grayPrimary
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lblAction
                width: historyDelegate.width / 2
                height: historyDelegate.height
                text: action + "\n" + "Số lượng: " + quantity
                font.pixelSize: UIMaterials.fontSizeSmall
                color: UIMaterials.grayPrimary
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

    }

}
