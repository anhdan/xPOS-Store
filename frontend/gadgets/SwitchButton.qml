import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import ".."

Row {
    id: root
    spacing: 0

    property string color1: UIMaterials.colorTrueBlue
    property string color2: UIMaterials.colorTrueRed
    property string bgrColor: "white"
    property int position: 1

    property alias switchName1: txtBtn1.text
    property alias switchName2: txtBtn2.text

    signal switched( )

    Button {
        id: btn1
        width: root.width / 2
        height: root.height
        background: Rectangle {
            id: rectBtn1
            anchors.fill: parent
            color: (position === 1) ? color1 : bgrColor
            border.width: 2
            border.color: color1
        }

        Text {
            id: txtBtn1
            anchors.centerIn: parent
            font {
                pixelSize: Math.min( 0.6 * parent.height, UIMaterials.fontsizeM )
                family: UIMaterials.fontRobotoLight
            }
            color: (position === 1) ? bgrColor : color1
        }

        onPressed: {
            opacity = 0.6
        }

        onReleased: {
            opacity = 1
            if( position === 2 )
            {
                position = 1
                switched()
            }
        }
    }

    Button {
        id: btn2
        width: root.width / 2
        height: root.height
        background: Rectangle {
            id: rectBtn2
            anchors.fill: parent
            color: (position === 2) ? color2 : bgrColor
            border.width: 2
            border.color: color2
        }

        Text {
            id: txtBtn2
            anchors.centerIn: parent
            font {
                pixelSize: Math.min( 0.6 * parent.height, UIMaterials.fontsizeM )
                family: UIMaterials.fontRobotoLight
            }
            color: (position === 2) ? bgrColor : color2
        }

        onPressed: {
            opacity = 0.6
        }

        onReleased: {
            opacity = 1
            if( position === 1 )
            {
                position = 2
                switched()
            }
        }
    }
}
