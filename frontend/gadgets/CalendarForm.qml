import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import ".."

Column {
    id: root
    spacing: titName.height

    property alias name: titName.text
    property alias selectedDate: calendar.selectedDate

    Label {
        id: titName
        width: parent.width
        height: 1.5385 * font.pixelSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        font {
            pixelSize: UIMaterials.fontsizeM
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        color: "black"
        text: ""
    }


    Calendar {
        id: calendar
        width: parent.width
        height: width * 1.2
        maximumDate: new Date(2050, 0, 1)
        minimumDate: new Date(2020, 0, 1)
    }


}
