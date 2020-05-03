import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: diaErr
    width: 400
    height: 150
    color: "#ffffff"
    radius: 20
    border.width: 3
    border.color: "#cca725"

    signal sigOKClicked()

    function showMsg( msg )
    {
        lblDialog.text = msg
    }

    Label {
        id: lblDialog
        y: 20
        height: 46
        text: qsTr("Label")
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 14
    }

    Button {
        id: btnOK
        x: 150
        y: 93
        width: 80
        height: 40
        text: qsTr("OK")
        clip: false
        font.weight: Font.Normal
        font.pixelSize: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            radius: 14
            color: "#ff6868"
        }

        onClicked: {
            diaErr.sigOKClicked();
        }
    }


}
