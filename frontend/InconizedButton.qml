import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Button {
    id: root

    property alias iconSource: imgIcon.source
    property alias name: txtName.text
    property alias bgrColor: rectBgr.color
    property alias fgrColor: txtName.color
    property alias radius: rectBgr.radius

    background: Rectangle {
        id: rectBgr
        anchors.fill: parent
    }

//    Text {
//        id: txtIcon
//        width: parent.width
//        height: parent.height / 2
//        anchors.top: parent.top
//        anchors.left: parent.left
//        font {
//            pixelSize: Math.min( 0.8*height, UIMaterials.fontsizeM )
//            weight: Font.Bold
//            family: UIMaterials.solidFont
//        }
//        color: UIMaterials.grayDark
//        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter
//        text: "\uf00c"
//    }

    Image {
        id: imgIcon
        width: height
        height: 0.4 * root.height
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height/4 - height/2
        mipmap: true

        ColorOverlay {
            id: overlay
            anchors.fill: parent
            source: parent
            color: txtName.color
        }
    }

    Text {
        id: txtName
        width: parent.width
        height: parent.height / 2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        font {
            pixelSize: Math.min( 0.4 * root.height, UIMaterials.fontsizeS )
            family: UIMaterials.fontRobotoLight
        }
        color: overlay.color
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: ""
    }

}
