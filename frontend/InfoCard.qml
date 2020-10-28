import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Column {
    spacing: 0

    property int titleFontSize: UIMaterials.fontsizeS
    property alias titleHeight: lblTitle.height
    property string titleColor: UIMaterials.colorTaskBar
    property alias titleText: lblTitle.text
    property int infoFontsize: UIMaterials.fontsizeM
    property int infoHeight: lblInfo.height
    property string infoColor: UIMaterials.colorTaskBar
    property alias infoText: lblInfo.text

    property alias cardWidth: lblTitle.width
    property bool isBold: false


    Label {
        id: lblTitle
        font {
            pixelSize: titleFontSize
            family: UIMaterials.fontRobotoLight
        }
        color: titleColor
        opacity: 0.6
        text: ""
    }


    Label {
        id: lblInfo
        font {
            pixelSize: infoFontsize
            bold: isBold
            family: UIMaterials.fontRobotoLight
        }
        color: infoColor
        text: ""
    }

}
