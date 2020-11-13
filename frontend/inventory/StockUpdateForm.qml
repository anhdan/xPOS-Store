import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root
    clip: true
    color: "transparent"

    property int currStock: 0
    property int stockChange: 0
    property var currDate
    property var exprDate
    property bool validQuantity: false
    property bool validExprDate: true

    //====================== I. Signal
    signal updated( var quantityChange, var expDate )
    signal changesCanceled()
    signal invalidInput( var msg )

    function clear()
    {
        swUpdateType.position = 1
        icUpdateQuantity.infoText = ""
        icExprDate.infoText = ""
    }

    function init( _currStock, _currDate )
    {
        currStock = _currStock
        currDate = _currDate
        validQuantity = false
        validExprDate = true
        clear()
    }

    function getDateString()
    {
        return (txtDayInMonth.text + "/" + txtMonthInYear.text + "/" + txtYear.text )
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
            if( (Number(infoText) > currStock) && (swUpdateType.position === 2) )
            {
                validQuantity = false
                invalidInput( "Lượng xả hàng vượt quá số lượng trong kho" )
            }
            else
            {
                stockChange = (swUpdateType.position === 1) ? Number(infoText) : -Number(infoText)
                validQuantity = true
                inputPanel.active = false
            }
        }
    }

    InfoCard {
        id: icExprDate
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: icUpdateQuantity.bottom
        anchors.topMargin: icUpdateQuantity.anchors.topMargin
        width: icUpdateQuantity.width

        titleHeight: icUpdateQuantity.titleHeight
        titleFontSize: UIMaterials.fontsizeM
        titleColor: UIMaterials.grayDark

        infoHeight: icUpdateQuantity.infoHeight
        infoFontsize: UIMaterials.fontsizeXL
        infoColor: "black"
        editable: true
        isCalendar: true

        titleText: "Hạn sử dụng"
        placeholderText: "..."
        underline: true

        onEditStarted: {
            if( inputPanel.active )
            {
                inputPanel.active = false
            }

            var calendar = Qt.createQmlObject( "import QtQuick.Controls 1.4; \
                                                    Calendar {\
                                                        id: calendar; \
                                                        locale: Qt.locale(); \
                                                        width: root.width / 2; \
                                                        height: root.height / 2; \
                                                        maximumDate: new Date(2050, 0, 1); \
                                                        minimumDate: new Date(2020, 0, 1); \
                                                        anchors.horizontalCenter: root.horizontalCenter; \
                                                        anchors.verticalCenter: icExprDate.verticalCenter; \
                                                        z: 20\
                                                    }",
                                              root, "calendarErr" )
            calendar.clicked.connect(function( date ) {
                if( date < currDate )
                {
                    validExprDate = false
                    invalidInput( "Hạn sử dụng không hợp lệ" )
                }
                else
                {
                    validExprDate = true
                    exprDate = date
                    infoText = date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                    calendar.destroy()
                    focus = false
                    icExprDate.editFinished()
                }
            })
            calendar.focusChanged.connect(function() {
                if( calendar.focus === false )
                {
                    icExprDate.editFinished()
                    calendar.destroy()
                }
            })
            calendar.focus = true
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
        visible: (validQuantity & validExprDate)

        background: Rectangle {
            id: rectBtnConfirm
            anchors.fill: parent
            color: UIMaterials.colorTaskBar
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
            console.log( "stock change: " + stockChange )
            updated( stockChange, exprDate )
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
