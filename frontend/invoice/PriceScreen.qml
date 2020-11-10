import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import ".."
import "../gadgets"

Rectangle {
    id: root
    implicitWidth: 340
    implicitHeight: 180
    color: UIMaterials.colorTaskBar

    property alias orgPriceStr: lblOrgPrice.text
    property alias taxStr: lblTax.text
    property alias discountStr: lblDiscount.text
    property alias totalChargeStr: lblTotalCharge.text

    Column{
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        spacing: 0.1 * titOrgPrice.height

        //===== Original total price display
        Row {
            spacing: 0
            Label {
                id: titOrgPrice
                width: 0.412 * root.width
                height: 0.222 * root.height
                text: "Giá gốc:"
                horizontalAlignment: Text.AlignLeft
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorTrueGray
            }

            Label {
                id: lblOrgPrice
                width: root.width - titOrgPrice.width
                height: titOrgPrice.height
                text: "0 vnd"
                horizontalAlignment: Text.AlignRight
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: "White"
            }
        }


        //===== Total tax display
        Row {
            spacing: 0
            Label {
                id: titTax
                width: titOrgPrice.width
                height: titOrgPrice.height
                text: "Thuế:"
                horizontalAlignment: Text.AlignLeft
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorTrueGray
            }

            Label {
                id: lblTax
                width: lblOrgPrice.width
                height: lblOrgPrice.height
                text: "0 vnd"
                horizontalAlignment: Text.AlignRight
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: "White"
            }
        }

        //===== Total tax display
        Row {
            spacing: 0
            Label {
                id: titDiscount
                width: titOrgPrice.width
                height: titOrgPrice.height
                text: "Chiết khấu:"
                horizontalAlignment: Text.AlignLeft
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorTrueGray
            }

            Label {
                id: lblDiscount
                width: lblOrgPrice.width
                height: lblOrgPrice.height
                text: "0 vnd"
                horizontalAlignment: Text.AlignRight
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: "White"
            }
        }

        //===== Total charging display
        Row {
            spacing: 0
            Label {
                id: titTotalCharge
                width: titOrgPrice.width
                height: titOrgPrice.height
                text: "Tổng:"
                horizontalAlignment: Text.AlignLeft
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorTrueGray
            }

            Label {
                id: lblTotalCharge
                width: lblOrgPrice.width
                height: lblOrgPrice.height
                text: "0 vnd"
                horizontalAlignment: Text.AlignRight
                font {
                    pixelSize: UIMaterials.fontSizeLarge
                    weight: Font.Bold
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorAntLogo
            }
        }
    }

}
