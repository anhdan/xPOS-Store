import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2

import "."


Rectangle {
    id: root
    clip: true
    color: "transparent"

    //====================== I. Signal
    signal updated( var quantity, var isImport, var expDate )
    signal changesCanceled()

    function clear()
    {
    }


    //===================== II. Update quantity info
    Label {
        id: titUpdateStock
        height: 0.0565 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.0565 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeL
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayDark
        text: "Cập Nhật Số Lượng"

        states: State {
            name: "exprDateInputing"
            when: (rowExprDate.visible && rowExprDate.inputing)
            PropertyChanges {
                target: titUpdateStock
                y: -root.height / 5
            }
        }

        transitions: Transition {
            from: ""
            to: "exprDateInputing"
            reversible: true
            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }

    //----- Update type
    SwitchButton {
        id: swUpdateType
        anchors.top: titUpdateStock.bottom
        anchors.topMargin: 0.0565 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        width: 0.4678 * parent.width
        height: 0.0847 * parent.height
        switchName1: "Nhập Kho"
        switchName2: "Thất Thoát"
    }

    //----- Update quantity
    InfoCard {
        id: icUpdateQuantity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: swUpdateType.bottom
        anchors.topMargin: 0.0847 * parent.height
        width: 0.7310 * parent.width

        titleHeight: 0.0424 * parent.height
        titleFontSize: UIMaterials.fontsizeM
        titleColor: UIMaterials.grayDark

        infoHeight: 2.3333 * titleHeight
        infoFontsize: UIMaterials.fontsizeXL
        infoColor: "black"
        editable: true
        isNumber: true

        titleText: "Số lượng cập nhật"
        placeholderText: "..."
        underline: true

        onEditStarted: {
            if( inputPanel.active === false )
            {
                inputPanel.active = true
            }
        }

        onEditFinished: {
            if( txtDayInMonth.text === "" )
            {
                txtDayInMonth.focus = true
            }
            else {
                inputPanel.active = false
            }
        }
    }

    //----- Expiration date
    Label {
        id: titExprDate
        width: icUpdateQuantity.width
        height: icUpdateQuantity.titleHeight
        anchors.left: icUpdateQuantity.left
        anchors.top: icUpdateQuantity.bottom
        anchors.topMargin: icUpdateQuantity.anchors.topMargin
        visible: (swUpdateType.position === 1)
        font {
            pixelSize: icUpdateQuantity.titleFontSize
            family: UIMaterials.fontRobotoLight
        }
        color: icUpdateQuantity.titleColor
        opacity: 0.6
        text: "Hạn sử dụng"
    }

    Row {
        property bool inputing: (txtDayInMonth.focus | txtMonthInYear.focus | txtYear.focus)

        id: rowExprDate
        spacing: 0
        anchors.top: titExprDate.bottom
        anchors.topMargin: 0.0141 * parent.height
        anchors.left: titExprDate.left
        visible: (swUpdateType.position === 1)

        TextField {
            id: txtDayInMonth
            width: 0.28 * titExprDate.width
            height: icUpdateQuantity.infoHeight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            placeholderText: "Ngày"
//            placeholderTextColor: UIMaterials.colorTrueGray
            background: Rectangle {
                anchors.fill: parent
                color: UIMaterials.colorNearWhite
            }

            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            inputMethodHints: Qt.ImhDialableCharactersOnly

            onAccepted: {
                focus = false
            }

            onFocusChanged: {
                if( focus === true )
                {
                    if( inputPanel.active === false )
                    {
                        inputPanel.active = true
                    }
                }
                else
                {
                    if( txtMonthInYear.text === "" )
                    {
                        txtMonthInYear.focus = true
                    }
                    else if( txtYear.text === "" )
                    {
                        txtYear.focus = true
                    }
                    else
                    {
                        inputPanel.active = false
                    }
                    txtDayInMonth.focus = false
                }
            }
        }

        Label {
            width: 0.08 * titExprDate.width
            height: txtDayInMonth.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            text: "-"
            color: UIMaterials.grayDark
        }

        TextField {
            id: txtMonthInYear
            width: txtDayInMonth.width
            height: txtDayInMonth.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            placeholderText: "Tháng"
//            placeholderTextColor: UIMaterials.colorTrueGray
            background: Rectangle {
                anchors.fill: parent
                color: UIMaterials.colorNearWhite
            }

            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            inputMethodHints: Qt.ImhDialableCharactersOnly

            onAccepted: {
                focus = false
            }

            onFocusChanged: {
                if( focus === true )
                {
                    if( inputPanel.active === false )
                    {
                        inputPanel.active = true
                    }
                }
                else
                {
                    if( txtYear.text === "" )
                    {
                        txtYear.focus = true
                    }
                    else if( txtDayInMonth.text === "" )
                    {
                        txtDayInMonth.focus = true
                    }
                    else
                    {
                        inputPanel.active = false
                    }
                    txtDayInMonth.focus = false
                }
            }
        }

        Label {
            width: 0.08 * titExprDate.width
            height: txtDayInMonth.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            text: "-"
            color: UIMaterials.grayDark
        }

        TextField {
            id: txtYear
            width: txtDayInMonth.width
            height: txtDayInMonth.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            placeholderText: "Năm"
//            placeholderTextColor: UIMaterials.colorTrueGray
            background: Rectangle {
                anchors.fill: parent
                color: UIMaterials.colorNearWhite
            }

            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            inputMethodHints: Qt.ImhDialableCharactersOnly

            onAccepted: {
                focus = false
            }

            onFocusChanged: {
                if( focus === true )
                {
                    if( inputPanel.active === false )
                    {
                        inputPanel.active = true
                    }
                }
                else
                {
                    if( txtDayInMonth.text === "" )
                    {
                        txtDayInMonth.focus = true
                    }
                    else if( txtMonthInYear.text === "" )
                    {
                        txtMonthInYear.focus = true
                    }
                    else
                    {
                        inputPanel.active = false
                    }
                    txtDayInMonth.focus = false
                }
            }
        }
    }


    //----- Control buttons
    Button {
        id: btnConfirm
        width: 0.2047 * parent.width
        height: 0.0847 * parent.height
        y: 0.8969 * parent.height
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 20

        background: Rectangle {
            id: rectBtnConfirm
            anchors.fill: parent
            color: UIMaterials.colorTrueBlue
            radius: 10
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "white"
            text: "Xác Nhận"
        }

        onPressed: {
            rectBtnConfirm.opacity = 0.6
        }

        onReleased: {
            rectBtnConfirm.opacity = 1
        }
    }

    Button {
        id: btnCancel
        width: btnConfirm.width
        height: btnConfirm.height
        anchors.top: btnConfirm.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 20

        background: Rectangle {
            id: rectBtnCancel
            anchors.fill: parent
            color: UIMaterials.colorTrueRed
            radius: 10
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "white"
            text: "Hủy"
        }

        onPressed: {
            rectBtnCancel.opacity = 0.6
        }

        onReleased: {
            rectBtnCancel.opacity = 1
            changesCanceled()
        }
    }


    //----- Input panel
    InputPanel {
        id: inputPanel
        z: 99
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height
        width: root.width
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

            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
}
