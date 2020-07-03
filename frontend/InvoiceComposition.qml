import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2

import "."

Rectangle {
    id: root
    implicitWidth: 1280
    implicitHeight: 720

    readonly property string priceTxtColor: UIMaterials.goldDark//"white"
    readonly property string priceTxtFontSize: UIMaterials.fontSizeLarge


    //===================== Signal - Slot definition
    function showCost( cost, tax, discount )
    {
        var vietnam = Qt.locale( )
        lblSumBeforeTax.text = Number(cost).toLocaleString( vietnam, "f", 0 ) + " vnd"
        lblTax.text = Number(tax).toLocaleString( vietnam, "f", 0 ) + " vnd"
        lblDiscount.text = Number(discount).toLocaleString( vietnam, "f", 0 ) + " vnd"
        lblSumFinal.text = Number(cost + tax - discount).toLocaleString( vietnam, "f", 0 ) + " vnd"
    }

    signal toInventoryBoard()
    signal toCustomerBoard()
    signal toAnalyticsBoard()
    signal toSetupBoard()
    signal toLoginBoard()


    //===================== 1. Panel of control buttons and price screen
    Rectangle {
        id: pnControl
        width: 3*parent.width / 8
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.appBgrColorPrimary

        //========= 1.1. Price screen panel
        Rectangle {
            id: pnPriceScreen
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            height: 7 * priceTxtFontSize
            color: UIMaterials.appBgrColorDark

            Column {
                id: column
                spacing: 10
                anchors.centerIn: parent
                width: parent.width - 20

                Row {
                    spacing: 0
                    Label {
                        id: titSumBeforeTax
                        width: column.width / 2
                        text: qsTr( "Tổng chưa thuế: " )
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }

                    Label {
                        id: lblSumBeforeTax
                        width: column.width / 2
                        text: qsTr( "0 vnd" )
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }
                }

                Row {
                    spacing: 0
                    Label {
                        id: titTax
                        width: column.width / 2
                        text: qsTr( "Thuế: " )
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }

                    Label {
                        id: lblTax
                        width: column.width / 2
                        text: qsTr( "0 vnd" )
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }
                }

                Row {
                    spacing: 0
                    Label {
                        id: titDiscount
                        width: column.width / 2
                        text: qsTr( "Khuyến mãi: " )
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }

                    Label {
                        id: lblDiscount
                        width: column.width / 2
                        text: qsTr( "0 vnd" )
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }
                }

                Row {
                    spacing: 0
                    Label {
                        id: titSumFinal
                        width: column.width / 2
                        text: qsTr( "Tổng tiền: " )
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }

                    Label {
                        id: lblSumFinal
                        width: column.width / 2
                        text: qsTr( "0.00 vnd" )
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: priceTxtFontSize
                        color: priceTxtColor
                    }
                }
            }

        }

        //========= 1.2. Numpad panel
        NumPad {
            id: pnNumpad
            anchors.top: pnPriceScreen.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: Math.min(2*parent.width/3, 300)
        }

        //======== 1.3. Control key panel
        Column {
            id: columnControl
            height: pnNumpad.height
            anchors.top: pnNumpad.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 15

            Button {
                id: btnIncrease
                width: pnNumpad.keySize * 1.2
                height: pnNumpad.keySize
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnIncrease
                    anchors.fill: parent
                    color: UIMaterials.appBgrColorLight
                    radius: 5
                }

                Text {
                    text: qsTr("+")
                    anchors.centerIn: parent
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: UIMaterials.fontSizeLargeLarge
                    font.bold: true
                }

                onPressed: {
                    rectBtnIncrease.color = UIMaterials.appBgrColorDark
                }

                onReleased: {
                    rectBtnIncrease.color = UIMaterials.appBgrColorLight
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    var currItemQuant = tab.item.getCurrItemQuantity()
                    currItemQuant++
                    tab.item.updateCurrItemQuantity( currItemQuant )
                }
            }

            Button {
                id: btnDecrease
                width: pnNumpad.keySize * 1.2
                height: pnNumpad.keySize
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnDecrease
                    anchors.fill: parent
                    color: UIMaterials.appBgrColorLight
                    radius: 5
                }

                Text {
                    text: qsTr("-")
                    anchors.centerIn: parent
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: UIMaterials.fontSizeLargeLarge
                    font.bold: true
                }

                onPressed: {
                    rectBtnDecrease.color = UIMaterials.appBgrColorDark
                }

                onReleased: {
                    rectBtnDecrease.color = UIMaterials.appBgrColorLight
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    var currItemQuant = tab.item.getCurrItemQuantity()
                    if( currItemQuant > 1 )
                    {
                        currItemQuant--
                        tab.item.updateCurrItemQuantity( currItemQuant )
                    }
                    else
                    {
                        tab.item.removeCurrItem()
                    }
                }
            }

            Button {
                id: btnMakePayment
                width: pnNumpad.keySize * 1.2
                height: pnNumpad.keySize * 2 + 15
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnMskePayment
                    anchors.fill: parent
                    color: UIMaterials.goldDark
                    radius: 5
                }

                Text {
                    text: qsTr("Thanh\nToán")
                    anchors.centerIn: parent
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: UIMaterials.fontSizeLarge
                    font.bold: true
                }

                onPressed: {
                    rectBtnMskePayment.color = UIMaterials.goldPrimary
                }

                onReleased: {
                    rectBtnMskePayment.color = UIMaterials.goldDark
                    payTransitionOnY.start()
                }
            }
        }

        //========= Task bar sector
        Button {
            id: btnMenu
            width: 60
            height: 60
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }

            Text {
                id: txtBtnMenu
                text: "\uf0c9"
                anchors.centerIn: parent
                color: UIMaterials.grayPrimary
                font {
                    pixelSize: 40;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onPressed: {
                txtBtnMenu.color = UIMaterials.grayLight
            }

            onReleased: {
                txtBtnMenu.color = UIMaterials.grayPrimary
                menu.open()
            }
        }


        Menu {
            id: menu
            x: btnMenu.x
            y: btnMenu.y

            MenuItem {
                text: "Quản lý kho"
                onTriggered: {
                    toInventoryBoard()
                }
            }

            MenuItem {
                text: "Quản lý khách hàng"
                onTriggered: {
                    toCustomerBoard()
                }
            }

            MenuItem {
                text: "Phân tích kinh doanh"
                onTriggered: {
                    toAnalyticsBoard()
                }
            }

            MenuItem {
                text: "Cài đặt"
                onTriggered: {
                    toSetupBoard()
                }
            }

            MenuSeparator{}

            MenuItem {
                text: "Đăng xuất"
                onTriggered: {
                    toLoginBoard()
                }
            }

        }

        //======= Account infomation
        Label {
            id: lblAccSign
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            text: "\uf007"
            color: "white"
            font {
                pixelSize: 40;
                weight: Font.Bold;
                family: UIMaterials.solidFont
            }
        }

        Label {
            id: lblAccText
            anchors.right: lblAccSign.left
            anchors.rightMargin: 10
            anchors.bottom: lblAccSign.bottom
            text: "Do Anh Dan"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: "white"
        }
    }


    Rectangle {
        id: pnInvoiceTabs
        width: 5*parent.width / 8
        height: parent.height
        y: 0
        anchors.left: pnControl.right
        color: "#dcdcdc"

        //================= Invoice items tabview panel
        TabView {
            id: tabviewInvoice
            x: 0
            y: 0
            width: parent.width
            height: parent.height

            Tab {
                id: tab1
                title: "Hóa Đơn 1"
                source: "ItemsListView.qml"
                onLoaded: {
                    item.costCalculated.connect( root.showCost )
                }
            }

            Tab {
                id: tab2
                title: "Hóa Đơn 2"
                source: "ItemsListView.qml"
                onLoaded: {
                    item.costCalculated.connect( root.showCost )
                }
            }

            style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? UIMaterials.appBgrColorLight : "#dcdcdc"
                    implicitWidth: Math.max(text.width + 4, 200)
                    implicitHeight: 60
                    border.color: "white"
                    border.width: 1

                    Rectangle {
                        width: parent.width
                        height: 5
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        color: styleData.selected ? UIMaterials.goldPrimary : "transparent"
                    }

                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        color: styleData.selected ? "white" : "black"
                        font.pixelSize: UIMaterials.fontSizeMedium
                    }
                }
            }
        }


        Button {
            id: btnAddItem
            width: 60
            height: 60
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            background: Rectangle {
                id: rectBtnAddItem
                anchors.fill: parent
                color: "transparent"
                radius: 10
            }

            Text {
                id: txtBtnAddItem
                text: "\uf11c"
                anchors.centerIn: parent
                color: UIMaterials.appBgrColorLight
                font {
                    pixelSize: 45;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onPressed: {
                txtBtnAddItem.color = UIMaterials.appBgrColorDark
            }

            onReleased: {
                txtBarcodeInput.focus = true
                txtBarcodeInput.text = ""
                pnBarcodeInput.visible = true
            }
        }


        Button {
            id: btnDeleteItem
            width: 60
            height: 60
            anchors.left: btnAddItem.right
            anchors.leftMargin: 15
            anchors.bottom: parent.bottom

            background: Rectangle {
                id: rectBtnDeleteItem
                anchors.fill: parent
                color: "transparent"
                radius: 10
            }

            Text {
                id: txtBtnDeleteItem
                text: "\uf2ed"
                anchors.centerIn: parent
                color: UIMaterials.grayPrimary
                font {
                    pixelSize: 40;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onPressed: {
                txtBtnDeleteItem.color = UIMaterials.grayDark
            }

            onReleased: {
                txtBtnDeleteItem.color = UIMaterials.grayPrimary
                var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                tab.item.removeCurrItem()
            }
        }


        //================== Barcode typing panel
        Rectangle {
            id: pnBarcodeInput
            width: Math.max( parent.width /2, 150 )
            height: width / 3
            z: tabviewInvoice.z + 10
            anchors.centerIn: parent
            color: UIMaterials.appBgrColorLight
            visible: false

            Label {
                id: titBarcodeInput
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: txtBarcodeInput.top
                anchors.bottomMargin: 10
                text: "Nhập mã sản phẩm"
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: txtBarcodeInput
                width: parent.width * 2 / 3
                height: 2 * UIMaterials.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "black"

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
                }

                onAccepted: {
                    txtBtnAddItem.color = UIMaterials.appBgrColorLight
                    // Search for product with given code
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    tab.item.addItem( text )
                    txtBarcodeInput.focus = false
                    pnBarcodeInput.visible = false
                }
            }

        }


        //================== Payment panel
        Payment {
            id: pnPayment
            width: parent.width
            height: parent.height / 2
            x: 0
            y: parent.height
            z: 20
            clip: true

            //================== Signal handling
            onColapse: {
                payTransitionOnYRev.start()
            }

            //================== Animation
            NumberAnimation {
                id: payTransitionOnY
                target: pnPayment
                property: "y"
                from: parent.height
                to: parent.height/2
                duration: 250
            }

            NumberAnimation {
                id: payTransitionOnYRev
                target: pnPayment
                property: "y"
                from: parent.height / 2
                to: parent.height
                duration: 250
            }
        }
    }


}
