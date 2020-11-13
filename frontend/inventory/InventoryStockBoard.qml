import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import ".."
import "../gadgets"

Column {
    id: root
    spacing: 0

    property int instock: 0
    property int sold: 0
    property real disqualifiedRate: 0

    function clear()
    {
        instock = "0"
        sold = "0"
        disqualifiedRate = 0
    }

    //==================== I. Instock quantity
    Row {
        spacing: 0
        Label {
            id: titInstock
            width: root.width / 2
            height: root.height / 3
            font {
                pixelSize: UIMaterials.fontsizeXS
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.grayDark
            text: "Lưu kho"
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: lblInstock
            width: titInstock.width
            height: titInstock.height
            font {
                pixelSize: UIMaterials.fontsizeM
                bold: true
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorTrueBlue
            text: instock.toString()
            verticalAlignment: Text.AlignVCenter
        }
    }

    //==================== II. Sold quantity
    Row {
        spacing: 0
        Label {
            id: titSold
            width: titInstock.width
            height: titInstock.height
            font {
                pixelSize: UIMaterials.fontsizeXS
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.grayDark
            text: "Đã bán"
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: lblSold
            width: lblInstock.width
            height: lblInstock.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "black"
            text: sold.toString()
            verticalAlignment: Text.AlignVCenter
        }
    }

    //==================== III. Disqualified ratio
    Row {
        spacing: 0
        Label {
            id: titDisqualifiedRate
            width: titInstock.width
            height: titInstock.height
            font {
                pixelSize: UIMaterials.fontsizeXS
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.grayDark
            text: "Tỷ lệ thất thoát"
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: lblDisqualifiedRate
            width: lblInstock.width
            height: lblInstock.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "black"
            text: (disqualifiedRate * 100).toFixed(2) + " %"
            verticalAlignment: Text.AlignVCenter
        }
    }
}
