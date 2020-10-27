import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."


Row {
    id: root
    spacing: 0
    property string textColor: UIMaterials.colorTaskBar
    property alias customerName: lblCustomerName.text
    property alias customerPhone: lblCustomerPhone.text
    property alias shoppingCount: lblShoppingTime.text
    property alias totalPayment: lblTotalPayment.text
    property alias receivedDiscount: lblTotalDiscount.text

    //================ I. Basic info
    Column {
        spacing: 0

        Label {
            id: lblCustomerName
            width: root.width / 2
            height: 1.538 * UIMaterials.fontsizeM
            font {
                pixelSize: UIMaterials.fontsizeM
                weight: Font.Bold
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            text: ""
        }

        Label {
            id: lblCustomerPhone
            width: lblCustomerName.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            text: ""
        }
    }

    //================ II. Shopping Info
    Column {
        spacing: 0

        Row {
            spacing: 0

            Label {
                id: titShoppingTime
                width: 0.106 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                opacity: 0.6
                text: "Lần mua:"
            }

            Label {
                id: lblShoppingTime
                width: 0.1376 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                text: ""
            }
        }

        Row {
            spacing: 0

            Label {
                id: titTotalPayment
                width: 0.106 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                opacity: 0.6
                text: "Đã chi:"
            }

            Label {
                id: lblTotalPayment
                width: 0.1376 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                text: ""
            }
        }

        Row {
            spacing: 0

            Label {
                id: titTotalDiscount
                width: 0.106 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                opacity: 0.6
                text: "Nhận ưu đãi:"
            }

            Label {
                id: lblTotalDiscount
                width: 0.1376 * root.width
                height: lblCustomerName.height
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: textColor
                text: ""
            }
        }
    }
}

