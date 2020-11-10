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
    color: "transparent"

    property real discountPrice: 0
    property date startDate
    property date endDate

    //====================== I. Signal
    signal activated( var discountPrice, var startDate, var endDate )
    signal changesCanceled()

    function clear()
    {
        icDiscountPrice.infoText = ""
        icDiscountStart.infoText = ""
        icDiscountEnd.infoText = ""
    }


    //====================== II. Discount program info
    Label {
        id: titDiscountPrg
        height: 0.0565 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.0565 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeL
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayDark
        text: "Tạo Chương Trình Khuyến Mãi"
    }

    InfoCard {
        id: icDiscountPrice
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.2684 * parent.height
        width: 0.7310 * parent.width

        titleHeight: 0.0424 * parent.height
        titleFontSize: UIMaterials.fontsizeM
        titleColor: UIMaterials.grayDark

        infoHeight: 2.3333 * titleHeight
        infoFontsize: UIMaterials.fontsizeXL
        infoColor: "black"
        editable: true
        isCurrency: true

        titleText: "Đơn giá khuyến mãi"
        placeholderText: "..."
        underline: true

        onEditFinished: {
            discountPrice = Helper.currencyToNumber( infoText )
            inputPanel.active = false
            focus = false
            icDiscountStart.editStarted()
        }

        onEditStarted: {
            inputPanel.active = true
        }
    }


    InfoCard {
        id: icDiscountStart
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.4520 * parent.height
        width: icDiscountPrice.width

        titleHeight: icDiscountPrice.titleHeight
        titleFontSize: UIMaterials.fontsizeM
        titleColor: UIMaterials.grayDark

        infoHeight: icDiscountPrice.infoHeight
        infoFontsize: UIMaterials.fontsizeXL
        infoColor: "black"
        editable: true
        isCalendar: true

        titleText: "Ngày bắt đầu"
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
                                                        anchors.verticalCenter: icDiscountStart.verticalCenter; \
                                                        z: 20\
                                                    }",
                                              root, "calendarErr" )
            calendar.clicked.connect(function( date ) {
                startDate = date
                infoText = date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                calendar.destroy()
                focus = false
                icDiscountStart.editFinished()
                if( icDiscountEnd.infoText === "" )
                {
                    icDiscountEnd.editStarted()
                }
            })
            calendar.focusChanged.connect(function() {
                if( calendar.focus === false )
                {
                    icDiscountStart.editFinished()
                    calendar.destroy()
                }
            })
            calendar.focus = true
        }
    }

    InfoCard {
        id: icDiscountEnd
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.6356 * parent.height
        width: icDiscountPrice.width

        titleHeight: icDiscountPrice.titleHeight
        titleFontSize: UIMaterials.fontsizeM
        titleColor: UIMaterials.grayDark

        infoHeight: icDiscountPrice.infoHeight
        infoFontsize: UIMaterials.fontsizeXL
        infoColor: "black"
        editable: true
        isCalendar: true

        titleText: "Ngày kết thúc"
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
                                                        selectedDate: (startDate !== undefined) ? startDate : selectedDate; \
                                                        anchors.horizontalCenter: root.horizontalCenter; \
                                                        anchors.verticalCenter: icDiscountEnd.verticalCenter; \
                                                        z: 20\
                                                    }",
                                              root, "calendarErr" )
            calendar.clicked.connect(function( date ) {
                endDate = date
                infoText = date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                calendar.destroy()
                focus = false
                icDiscountEnd.editFinished()
            })
            calendar.focusChanged.connect(function() {
                if( calendar.focus === false )
                {
                    icDiscountEnd.editFinished()
                    calendar.destroy()
                }
            })
            calendar.focus = true
        }
    }


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
