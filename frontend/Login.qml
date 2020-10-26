import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.2

import "."

Rectangle {
    id: root
    implicitWidth: 1024
    implicitHeight: 768
    color: UIMaterials.colorNearWhite

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
    Image {
        id: imgLogo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        source: "qrc:/resource/imgs/Logo_only_trans.png"
        width: 160
        height: 160
        smooth: true
    }

    Label {
        id: titAppName
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: imgLogo.bottom
        anchors.topMargin: 20
        color: UIMaterials.colorConcrete
        text: "ANT THU NGÂN"
        font {
            pixelSize: 36
//            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
    }

    TextField {
        id: txtId
        width: 400
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titAppName.bottom
        anchors.topMargin: 20

        background: Rectangle {
            id: rectTxtId
            anchors.fill: parent
            radius: 30
            color: "white"
        }

        placeholderText: "Tên đăng nhập ..."
//        placeholderTextColor: UIMaterials.colorTrueGray
        font {
            pixelSize: UIMaterials.fontSizeLarge
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorConcrete
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
        width: 400
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: txtId.bottom
        anchors.topMargin: 20
        echoMode: TextInput.Password
        passwordMaskDelay: 200

        background: Rectangle {
            id: rectTxtPwd
            anchors.fill: parent
            radius: 30
            color: "white"
        }        

        placeholderText: "Mật khẩu ... "
//        placeholderTextColor: UI/Materials.colorTrueGray
        font {
            pixelSize: UIMaterials.fontSizeLarge
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorConcrete
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
        width: 200
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: txtPwd.bottom
        anchors.topMargin: 30

        background: Rectangle {
            id: rectBtnLogin
            anchors.fill: parent
            radius: 30
            color: UIMaterials.colorAntLogo
        }

        Text {
            id: txtBtnLogin
            anchors.centerIn: parent
            text: qsTr("Đăng nhập")
            font {
                pixelSize: UIMaterials.fontSizeLarge
                family: UIMaterials.fontRobotoLight
            }
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

    Button {
        id: btnForgotPwd
        width: 200
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: btnLogin.bottom
        anchors.topMargin: 10

        background: Rectangle {
            id: rectBtnForgotPwd
            anchors.fill: parent
            color: "transparent"
        }

        Text {
            id: txtBtnForgotPwd
            anchors.centerIn: parent
            text: qsTr("Quên mật khẩu?")
            font {
                pixelSize: UIMaterials.fontSizeMedium
                family: UIMaterials.fontRobotoLight
            }

            color: UIMaterials.grayPrimary
        }

        onPressed: {
        }

        onReleased: {
        }
    }

    Label {
        id: titSlogan
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        text: "Đơn Giản . Hiệu Quả . Chuyên Nghiệp"
        color: UIMaterials.colorTrueGray
        font {
            pixelSize: UIMaterials.fontSizeMedium
//            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
    }

}
