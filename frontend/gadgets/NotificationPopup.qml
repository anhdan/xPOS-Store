import QtQuick 2.9
import QtQuick.Controls 2.2

import "."
import ".."

Rectangle {
    id: root
    color: UIMaterials.textBorderColorPrimary
    opacity: 0.9

    property alias text: txtNoti.text
    property alias sign: txtSign.text

    signal colapse()

    // Function
    function showNoti( notiText, notiType )
    {
        if( notiType === "success" )
        {
            color = UIMaterials.greenPrimary
            txtSign.text = UIMaterials.iconSuccess
        }
        else
        {
            color = UIMaterials.textBorderColorPrimary
            txtSign.text = UIMaterials.iconError
        }
        txtNoti.text = notiText
    }

    // Notification sign
    Text {
        id: txtSign
        anchors.verticalCenter: txtNoti.verticalCenter
        anchors.right: txtNoti.left
        anchors.rightMargin: 5
        text: UIMaterials.iconError
        font {
            pixelSize: 30
            weight: Font.Bold
            family: UIMaterials.solidFont
        }
        color: "white"
        horizontalAlignment: Text.AlignHCenter
    }

    // Notification text
    Text {
        id: txtNoti
        text: "This is for testing"
        anchors.centerIn: parent
        width: Math.min(root.width*2/3, root.width-txtSign.width-50)
        font.pixelSize: UIMaterials.fontSizeSmall
        color: "white"
        wrapMode: Text.Wrap
    }

    // Colapse button
    Button {
        id: btnColapse
        width: 40
        height: 40
        anchors.top: parent.top
        anchors.right: parent.right

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }

        Text {
            id: txtBtnColapse
            text: "\uf060"
            anchors.centerIn: parent
            color: UIMaterials.grayLight
            font.pixelSize: 30
            font.weight: Font.Bold
            font.family: UIMaterials.regularFont
            horizontalAlignment: Text.AlignHCenter
        }

        onClicked: {
            colapse()
        }
    }    
}
