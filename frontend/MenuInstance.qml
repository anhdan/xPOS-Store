import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2


Rectangle {
    id: root
    state: "deselected"

    property alias icon: lblIcon.text
    property alias content: lblContent.text

    signal selected()

    Label {
        id: lblIcon
        width: UIMaterials.fontsizeL
        height: width
        anchors.verticalCenter: parent.verticalCenter
        x: 0.0412 * parent.width
        font {
            pixelSize: UIMaterials.fontsizeS
            weight: Font.Bold
            family: UIMaterials.solidFont
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: ""
    }

    Label {
        id: lblContent
        anchors.verticalCenter: parent.verticalCenter
        x: 0.1648 * parent.width
        font {
            pixelSize: UIMaterials.fontsizeM
            family: UIMaterials.fontRobotoLight
        }
        text: ""
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            selected()
        }
    }

    states: [
        State {
            name: "selected"
            PropertyChanges {
                target: root
                color: UIMaterials.colorTrueGray
            }

            PropertyChanges {
                target: lblIcon
                color: "white"
            }

            PropertyChanges {
                target: lblContent
                color: "white"
            }
        },

        State {
            name: "deselected"
            PropertyChanges {
                target: root
                color: "white"
            }

            PropertyChanges {
                target: lblIcon
                color: UIMaterials.grayDark
            }

            PropertyChanges {
                target: lblContent
                color: UIMaterials.grayDark
            }
        }
    ]
}
