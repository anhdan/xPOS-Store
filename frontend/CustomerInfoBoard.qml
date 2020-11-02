import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."


Column {
    spacing: 0

    property string textColor: UIMaterials.colorTaskBar
    property alias customerName: lblCustomerName.text
    property alias shoppingCount: lblShoppingTime.text
    property alias customerPoint: lblShoppingPoint.text
    property alias totalPayment: lblTotalPayment.text
    property alias receivedDiscount: lblTotalDiscount.text

    function clear()
    {
        lblCustomerName.text = ""
        lblShoppingPoint.text = ""
        lblShoppingTime.text = ""
        lblTotalPayment.text = ""
        lblTotalDiscount.text = ""
    }

    //============== Name
    Label {
        id: lblCustomerName
        width: parent.width
        height: 1.538 * UIMaterials.fontsizeM
        font {
            pixelSize: UIMaterials.fontsizeM
            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
        color: textColor
        text: ""
    }

    //============== Shopping info row 1
    Row {
        spacing: 0
        width: parent.width

        Label {
            id: titShoppingTime
            width: 0.1846 * parent.width
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
            width: 0.3154 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            text: ""
        }


        Label {
            id: titTotalPayment
            width: 0.1846 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeS
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            opacity: 0.6
            text: "Tổng chi:"
        }

        Label {
            id: lblTotalPayment
            width: 0.3154 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            text: ""
        }
    }

    //================= Shopping info row 2
    Row
    {
        spacing: 0
        width: parent.width

        Label {
            id: titShoppingPoint
            width: 0.1846 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeS
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            opacity: 0.6
            text: "Điểm:"
        }

        Label {
            id: lblShoppingPoint
            width: 0.3154 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorAntLogo
            text: ""
        }


        Label {
            id: titTotalDiscount
            width: 0.1846 * parent.width
            height: lblCustomerName.height
            font {
                pixelSize: UIMaterials.fontsizeS
                family: UIMaterials.fontRobotoLight
            }
            color: textColor
            opacity: 0.6
            text: "Chiết khấu:"
        }

        Label {
            id: lblTotalDiscount
            width: 0.3154 * parent.width
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
