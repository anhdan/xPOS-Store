import QtQuick 2.9
import QtQuick.Controls 2.2

import "."

ListView {
    id: root
    model: providerModel
    cacheBuffer: 10
    spacing: 3
    x: 0
    y: 0

    //========== Model
    ListModel {
        id: providerModel
        ListElement {
            order: 1
            name: "Alpha Book"
            address: "Thai Ha"
            phone: "0389772645"
            price: "60,000 vnđ"
        }

        ListElement {
            order: 2
            name: "Nha sach tuoi tre"
            address: "Thai Ha"
            phone: "0389772645"
            price: "6000,000 vnđ"
        }
    }

    //========== Delegate
    delegate: Rectangle {
        id: providerDelegate
        width: parent.width
        height: 2.5 * UIMaterials.fontSizeSmall
        color: "transparent"

        Row {
            anchors.fill: parent
            Label{
                id: lblOrder
                width: 2 * UIMaterials.fontSizeSmall
                height: providerDelegate.height
                text: order
                font.pixelSize: UIMaterials.fontSizeSmall
                color: "black"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Label{
                id: lblInfo
                width: 2*providerDelegate.width / 3
                text: name + "\n" + address
                font.pixelSize: UIMaterials.fontSizeSmall
                color: "black"
            }

            Label{
                id: lblPrice
                width: providerDelegate.width - lblOrder.width - lblInfo.width
                height: providerDelegate.height
                text: price
                font.pixelSize: UIMaterials.fontSizeSmall
                color: "black"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
        }
    }

}
