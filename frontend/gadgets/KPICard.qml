import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import ".."

Rectangle {
    id: root
    color: "white"
    property alias nameFontsize: lblKPIName.font.pixelSize
    property alias nameFontColor: lblKPIName.color
    property alias kpiName: lblKPIName.text
    property alias valueFontsize: lblKPIValue.font.pixelSize
    property alias valueFontColor: lblKPIValue.color
    property alias kpiValue: lblKPIValue.text
    property int kpiTrend: 0
    property alias trendColor: lblKPITrend.color

    Label {
        id: lblKPIName
        height: parent.height / 3
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        font {
            pixelSize: UIMaterials.fontsizeM
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayDark
        text: ""
    }

    Label {
        id: lblKPIValue
        height: parent.height / 2
        anchors.top: lblKPIName.bottom
        anchors.left: lblKPIName.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        font {
            pixelSize: UIMaterials.fontsizeXL
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorTaskBar
        text: ""
    }

    Label {
        id: lblKPITrend
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0.0417 * parent.height
        anchors.right: parent.right
        anchors.rightMargin: 0.0185 * parent.width
        font {
            pixelSize: UIMaterials.fontsizeL
            weight: Font.Bold
            family: UIMaterials.solidFont
        }
        color: "transparent"
        text: (kpiTrend === 0) ? "\uf061" : ((kpiTrend === 1) ? "\uf062" : "\uf063")
    }
}
