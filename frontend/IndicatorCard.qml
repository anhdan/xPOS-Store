import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2
import QtGraphicalEffects 1.0

import "."

Rectangle {
    id: root

    property alias name: lblName.text
    property var value: 0
    property bool isCurrency: true
    property alias compareSign: lblCompareSign.text
    property var compareValue: 0
    property alias compareSuffix: lblCompareSuffix.text
    property bool showColorIndicator: true


    Label {
        id: lblName
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        font.pixelSize: UIMaterials.fontSizeMedium
        color: UIMaterials.grayDark
        text: ""
    }


    Label {
        id: lblValue
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: lblName.left
        font.pixelSize: UIMaterials.fontSizeMedium
        color: UIMaterials.goldDark
        text: isCurrency ? (value.toLocaleString( Qt.locale(), "f", 0 ) + " vnd")
                         : value
    }

    Label {
        id: lblCompareSign
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: lblName.left
        color: UIMaterials.grayPrimary
        font {
            pixelSize: UIMaterials.fontSizeSmall
            weight: Font.Bold
            family: UIMaterials.solidFont
        }
        text: ""
    }

    Label {
        id: lblCompareValue
        anchors.verticalCenter: lblCompareSign.verticalCenter
        anchors.left: lblCompareSign.right
        anchors.leftMargin: 5
        font.pixelSize: UIMaterials.fontSizeSmall
        color: (showColorIndicator === false) ? UIMaterials.greenPrimary :
                                                (Number(text) < 30) ? UIMaterials.redPrimary :
                                                                      (Number(text) < 80) ? UIMaterials.goldDark :
                                                                                            UIMaterials.greenPrimary
        text: Math.round(compareValue * 100) / 100
    }

    Label {
        id: lblCompareSuffix
        anchors.verticalCenter: lblCompareSign.verticalCenter
        anchors.left: lblCompareValue.right
        font.pixelSize: UIMaterials.fontSizeSmall
        color: lblCompareValue.color
        text: "%"
    }
}
