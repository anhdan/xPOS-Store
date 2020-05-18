import QtQuick 2.0
import QtQuick.Controls 2.2

import xpos.store.workshift 1.0

Rectangle {
    id: root
    width: 1280
    height: 720
    color: grayNeutral
    border.color: "#00000000"

    signal sigAuthenticated()

    property string greenInvoice: "#7abd6f"
    property string blueDark: "#003c8f"
    property string blueNeutral: "#1565c0"
    property string blueLight: "#5e92f3"

    property string grayDark: "#aeaeae"
    property string grayNeutral: "#e0e0e0"
    property string grayLight: "#ffffff"

    WorkShiftProcess
    {
        id: workshift
    }

    Label {
        id: titXpos
        width: 193
        height: 56
        color: blueNeutral
        text: qsTr("xPOS")
        anchors.top: parent.top
        anchors.topMargin: 133
        anchors.left: parent.left
        anchors.leftMargin: 80
        font.pixelSize: 72
    }

    TextField {
        id: txtUserName
        width: 350
        height: 52
        placeholderText: qsTr("Tên người dùng")
        opacity: 1
        anchors.top: titXpos.bottom
        anchors.topMargin: 51
        anchors.left: parent.left
        anchors.leftMargin: 80
        font.pixelSize: 24

        background: Rectangle {
            color: "#00000000"
            border.color: blueLight
            border.width: 2
            radius: 9
        }

    }

    TextField {
        id: txtUserPwd
        width: 350
        height: 52
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.top: txtUserName.bottom
        anchors.topMargin: 28
        font.pixelSize: 24
        placeholderText: qsTr("Mật khẩu")
        opacity: 1

        background: Rectangle {
            color: "#00000000"
            radius: 9
            border.color: blueLight
            border.width: 2
        }
    }

    Label {
        id: titSlogan
        x: 553
        y: 143
        width: 673
        height: 113
        color: blueNeutral
        text: qsTr("Quản lý bán hàng thật dễ dàng và thuận tiện ")
        wrapMode: Text.WordWrap
        textFormat: Text.AutoText
        font.pixelSize: 42
    }

    Button {
        id: btnLogin
        width: 140
        height: 55
        Text {
            text: qsTr("Đăng nhập")
            color: "#ffffff"
            font.pixelSize: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
        }
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.top: txtUserPwd.bottom
        anchors.topMargin: 52
        background: Rectangle {
            radius: 9
            color: blueLight
        }

        onClicked:
        {
            var ret = workshift.invokLogin( txtUserName.text, txtUserPwd.text );
            if( ret === 0 )
            {
                console.log( "Login successfully" );
                root.sigAuthenticated();
            }
        }
    }

}