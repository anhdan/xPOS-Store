import QtQuick 2.0
import QtQuick.Controls 2.4

import ".."

Column {
    id: root
    spacing: barHeight / 5

    property alias barHeight: rectBar.height
    property alias barLenght: rectBar.width
    property alias barColor: rectBar.color
    property alias fontSize: lblLabel.font.pixelSize
    property alias label: lblLabel.text
    property alias labelColor: lblLabel.color
    property alias value: lblValue.text
    property alias valueColor: lblValue.color

    Label {
        id: lblLabel
        height: barHeight
        verticalAlignment: Text.AlignHCenter
        font {
            family: UIMaterials.fontRobotoLight
        }
    }

    Rectangle {
        id: rectBar


        Label {
            id: lblValue
            height: barHeight
            anchors.top: parent.top
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter

            font {
                pixelSize: fontSize
                family: UIMaterials.fontRobotoLight
            }
        }
    }

}
