import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.2

import "."

Rectangle {
    id: root
    implicitWidth: 1280
    implicitHeight: 720
    color: UIMaterials.appBgrColorPrimary

    //====================== Signal and slot definition
    signal approved()
    signal disapproved()

    //====================== Signal & slot connections
    Component.onCompleted: {
        xpBackend.sigStaffApproved.connect( root.approved )
        xpBackend.sigStaffDisapproved.connect( root.disapproved )
    }

    //=================== Input panel
    InputPanel {
        id: inputPanel
        z: 99
        x: root.width / 2 - width / 2
        y: root.height
        width: root.width * 7 / 8
        active: false


        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: root.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    //============== Account input area
    Label {
        id: titXPOS
        anchors.horizontalCenter: txtId.horizontalCenter
        anchors.bottom: txtId.top
        anchors.bottomMargin: UIMaterials.fontSizeMedium
        color: UIMaterials.goldPrimary
        font.pixelSize: 72
        text: "xPOS"
        enabled: false
    }

    TextField {
        id: txtId
        width: 350
        height: 2 * UIMaterials.fontSizeMedium
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: txtPwd.top
        anchors.bottomMargin: 15

        background: Rectangle {
            id: rectTxtId
            anchors.fill: parent
            radius: 15
            color: "transparent"
            border.color: UIMaterials.textBorderColorPrimary
            border.width: 1
        }

        placeholderText: "Tên đăng nhập"
        font.pixelSize: UIMaterials.fontSizeMedium
        color: "white"
        inputMethodHints: Qt.ImhNoAutoUppercase

        onPressed: {
            inputPanel.active = true
            text = ""
        }

        onFocusChanged: {
            if( focus == true )
            {
                inputPanel.active = true
                text = ""
            }
        }

        onAccepted: {
            inputPanel.active = false
            txtPwd.focus = true
        }
    }

    TextField {
        id: txtPwd
        width: 350
        height: 2 * UIMaterials.fontSizeMedium
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: UIMaterials.fontSizeMedium
        echoMode: TextInput.Password
        passwordMaskDelay: 200

        background: Rectangle {
            id: rectTxtPwd
            anchors.fill: parent
            radius: 15
            color: "transparent"
            border.color: UIMaterials.textBorderColorPrimary
            border.width: 1
        }

        placeholderText: "Mật khẩu"
        font.pixelSize: UIMaterials.fontSizeMedium
        color: "white"
//        inputMethodHints: Qt.ImhDialableCharactersOnly

        onPressed: {
            inputPanel.active = true
        }

        onFocusChanged: {
            if( focus == true )
            {
                inputPanel.active = true
                text = ""
            }
        }

        onAccepted: {
            inputPanel.active = false
        }

        Keys.onReleased: {
            if( event.key === Qt.Key_Return )
            {
                inputPanel.active = false
                btnLogin.released()
            }
        }
    }


    Button {
        id: btnLogin
        width: 120
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: UIMaterials.fontSizeMedium

        background: Rectangle {
            id: rectBtnLogin
            anchors.fill: parent
            radius: 10
            color: UIMaterials.appBgrColorLight
        }

        Text {
            id: txtBtnLogin
            anchors.centerIn: parent
            text: qsTr("Đăng nhập")
            font.pixelSize: UIMaterials.fontSizeMedium
            color: "white"
        }

        onPressed: {
            rectBtnLogin.color = UIMaterials.appBgrColorDark
        }

        onReleased: {
            rectBtnLogin.color = UIMaterials.appBgrColorLight
            var ret = xpBackend.login( txtId.text, txtPwd.text )
        }
    }



}
