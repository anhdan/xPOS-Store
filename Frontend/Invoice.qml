import QtQml 2.2
import QtQuick 2.4
//import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4



Rectangle {

    id: root
    width:  1280
    height: 720
    color: "#BDBDBD"
    border.width: 0

    property string veryGreen: "#00d315"
    property string mileGray: "#c9c9c9"
    property string numKeyColor: "#607d8b"
    property string borderColor: "white"
    property int keySize: 95
    property int zLayer2: 10

    signal sigEnableInterface()
    function enabelInteface()
    {
        root.sigEnableInterface()
    }

    function showCost( cost )
    {
        console.log( "=====> showCost" )
        var vietnam = Qt.locale( )
        lblSumBeforeTax.text = Number(cost).toLocaleString( vietnam, "f", 0 ) + " vnd"
        lblSumFinal.text = lblSumBeforeTax.text
    }

    //=============== ITEM LIST TAB VIEW ====================
    TabView {
        id: invoiceFrame
        width: 760
        height: 720
        anchors.left: parent.left
        anchors.top: parent.top

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
                color: styleData.selected ? mileGray : "#00000000"
                border.color:  borderColor
                border.width: 0.5
                implicitWidth: Math.max(text.width + 4, 200)
                implicitHeight: 60

                Rectangle {
                    width: parent.width
                    height: 5
                    anchors.top: parent.top
                    anchors.left: parent.left
                    color: styleData.selected ? "#ff9800" : "#00000000"
                }

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "black" : mileGray
                    font.pixelSize: 22
                }
            }
        }

        onCurrentIndexChanged: {
            var tab = invoiceFrame.getTab( invoiceFrame.currentIndex )
            showCost( tab.item.latestCost )
        }
    }


    //=================== PRICE SCREEN =======================
    Rectangle {
        id: pnPriceScreen
        x: 760
        width: 520
        height: 170
        color: "#000000"
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Column {
            spacing: 14
            anchors.fill: parent
            Row {
                spacing: 0
                Label {
                    id: titSumBeforeTax
                    width: pnPriceScreen.width / 2
                    text: qsTr( "Tổng chưa thuế: " )
                    font.pixelSize: 26
                    color: veryGreen
                }

                Label {
                    id: lblSumBeforeTax
                    width: pnPriceScreen.width / 2
                    text: qsTr( "0 vnd" )
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 26
                    color: veryGreen
                }
            }

            Row {
                spacing: 0
                Label {
                    id: titTax
                    width: pnPriceScreen.width / 2
                    text: qsTr( "Thuế: " )
                    font.pixelSize: 26
                    color: veryGreen
                }

                Label {
                    id: lblTax
                    width: pnPriceScreen.width / 2
                    text: qsTr( "0 vnd" )
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 26
                    color: veryGreen
                }
            }

            Row {
                spacing: 0
                Label {
                    id: titDiscount
                    width: pnPriceScreen.width / 2
                    text: qsTr( "Khuyến mãi: " )
                    font.pixelSize: 26
                    color: veryGreen
                }

                Label {
                    id: lblDiscount
                    width: pnPriceScreen.width / 2
                    text: qsTr( "0 vnd" )
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 26
                    color: veryGreen
                }
            }

            Row {
                spacing: 0
                Label {
                    id: titSumFinal
                    width: pnPriceScreen.width / 2
                    text: qsTr( "Tổng tiền: " )
                    font.pixelSize: 26
                    color: veryGreen
                }

                Label {
                    id: lblSumFinal
                    width: pnPriceScreen.width / 2
                    text: qsTr( "0.00 vnd" )
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 26
                    color: veryGreen
                }
            }
        }

    }


    //=============== Invoice Edit Buttons Panel =============
    Item {
        id: pnInvoiceButtons
        width: 120
        anchors.top: pnPriceScreen.bottom
        anchors.topMargin: 5
        anchors.left: pnPriceScreen.left
        anchors.bottom: parent.bottom

        Column {
            spacing: 5
            anchors.fill: parent
            Button {
                id: btnAddQuant
                anchors.left: parent.left
                anchors.right:  parent.right
                height: 95

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#2C93F2"
                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 42
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                onClicked: {
                    var tab = invoiceFrame.getTab( invoiceFrame.currentIndex )
                    var currItemQuant = tab.item.getCurrItemQuantity()
                    currItemQuant++
                    tab.item.updateCurrItemQuantity( currItemQuant )
                }
            }

            Button {
                id: btnSubQuant
                anchors.left: parent.left
                anchors.right:  parent.right
                height: 95

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#2C93F2"
                    Text {
                        anchors.centerIn: parent
                        text: "-"
                        font.pixelSize: 42
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                onClicked: {
                    var tab = invoiceFrame.getTab( invoiceFrame.currentIndex )
                    var currItemQuant = tab.item.getCurrItemQuantity()
                    if( currItemQuant > 0 )
                    {
                        currItemQuant--
                    }
                    tab.item.updateCurrItemQuantity( currItemQuant )
                }
            }

            Button {
                id: btnAddProduct
                anchors.left: parent.left
                anchors.right:  parent.right
                height: 95

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#7ABD6F"
                    Text {
                        anchors.centerIn: parent
                        text: "Thêm\nsản phẩm"
                        font.pixelSize: 22
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }                

                onClicked: {
                    frameCodeInput.visible = true
                    frameCodeInput.txtFocus = true
                    var tab = invoiceFrame.getTab( invoiceFrame.currentIndex )
                    var item = {'_itemInfo': "test 3", '_itemNum': 5, '_itemPrice': 50000}
                    tab.item.addItem( item )
                }
            }

            Button {
                id: btnDelItem
                anchors.left: parent.left
                anchors.right:  parent.right
                height: 95

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#FF6868"
                    Text {
                        anchors.centerIn: parent
                        text: "Xóa\nsản phẩm"
                        font.pixelSize: 22
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                onClicked:
                {
                    var tab = invoiceFrame.getTab( invoiceFrame.currentIndex )
                    tab.item.removeCurrItem()
                }
            }

            Button {
                id: btnPayment
                anchors.left: parent.left
                anchors.right:  parent.right
                height: 145

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#D4CB05"
                    Text {
                        anchors.centerIn: parent
                        text: "Thanh toán"
                        font.pixelSize: 22
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }       

    // Edit text for typing in product code
    Item {
        property alias txtFocus: txtCodeInput.focus
        id: frameCodeInput
        x: 0
        y: 0
        z: zLayer2
        width: invoiceFrame.width + pnInvoiceButtons.width
        height: parent.height
        visible: false

        MouseArea {
            id: maCodeInput
            anchors.fill: parent
            onClicked: {
                frameCodeInput.visible = false
                focus = false
            }
        }

        TextField {
            id: txtCodeInput
            anchors.verticalCenter: parent.verticalCenter
            x: 380 - width / 2
            z: zLayer2 + 1
            width: 400
            height: 60
            placeholderText: "Nhap ma san pham"
            font.pixelSize: 26
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            focus: true

            background: Rectangle {
                anchors.fill: parent
                radius: 20
                border.width: 3
                border.color: numKeyColor
                color: "white"
            }

            Keys.onPressed: {
                console.log(event.key)
                if( event.key === Qt.Key_B )
                {
                    console.log( txtCodeInput.text )
                }

            }
        }

    }

    //
    //===== Keyboard
    //
    Item {
        id: pnKeyboard
        anchors.right: parent.right
        anchors.rightMargin: 35
        anchors.top: pnPriceScreen.bottom
        anchors.topMargin: 5
        width: 320
        height: 420

        Column {
            spacing: 5
            Row {
                spacing: 15
                Button {
                    id: btnOne
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("1")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnTwo
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("2")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnThree
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("3")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }
            }


            Row {
                spacing: 15
                Button {
                    id: btnFour
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("4")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnFive
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("5")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnSix
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("6")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }
            }

            Row {
                spacing: 15
                Button {
                    id: btnSeven
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("7")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnEight
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("8")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnNine
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("9")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }
            }

            Row {
                spacing: 15
                Button {
                    id: btnClear
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("C")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnZero
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("0")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 42
                        }
                    }
                }

                Button {
                    id: btnEnter
                    width: keySize
                    height: keySize
                    Rectangle {
                        anchors.fill: parent
                        color: numKeyColor
                        radius: 5
                        Text {
                            text: qsTr("Nhập")
                            anchors.centerIn: parent
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 30
                        }
                    }
                }
            }
        }
    }

}
