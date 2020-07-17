import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."

Item {
    id: root
    property string titleColor: "#9e9e9e"
    property string buttonColor1: "#ffc107"

    property var currCustomer
    property var updateCustomer
    property real totalCharge: 0
    property int finalPoint: 0

    //=============== Functions
    function updatePoint( newPoint )
    {
        lblCustomerPoint.text = "Điểm: " + newPoint
        finalPoint = newPoint
    }

    //=============== Signals
    signal colapse()
    signal usePoint( var point, var convertRate )
    signal payCompleted()

    signal customerFound( var customer )
    signal customerNotFound()

    //============== Signals & Slots connection
    Component.onCompleted:
    {
        xpBackend.sigCustomerFound.connect( customerFound )
        xpBackend.sigCustomerNotFound.connect( customerNotFound )
    }


    //============== Signals handling
    onCustomerFound:
    {
        updateCustomer = Helper.deepCopy( customer )
        currCustomer = Helper.deepCopy( customer )
        lblCustomerName.text = customer["name"]
        lblCustomerShoppingCnt.text = customer["shopping_count"]
        lblCustomerPoint.text = customer["point"]
        column.visible = true
        btnUsePoint.visible = true
    }

    onCustomerNotFound:
    {
        //! TODO:
        //! Display noti
    }

    //=============== Colapse button
    Button {
        id: btnColapse
        width: 50
        height: 50
        z: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle
        {
            id: bgrBtnColapse
            anchors.fill: parent
            color: "transparent"
            radius: 5            
        }

        Text {
            id: txtBtnColpase
            text: "\uf078"
            anchors.centerIn: parent
            color: UIMaterials.grayPrimary
            font {
                pixelSize: 40;
                weight: Font.Bold
                family: UIMaterials.solidFont
            }
            horizontalAlignment: Text.AlignHCenter
        }

        onClicked: {
            colapse()
        }
    }

    Row {
        anchors.fill: parent
        spacing: 0
        Rectangle {
            id: pnCustomerInfo
            width: root.width / 2
            height: root.height

            Label {
                id: titCustomerCode
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 10
                text: "Mã khách hàng/SĐT"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: UIMaterials.grayPrimary
            }

            TextField {
                id: txtCustomerCode
                anchors.left: titCustomerCode.left
                anchors.top: titCustomerCode.bottom
                anchors.topMargin: 5
                width: parent.width * 0.8
                height: UIMaterials.fontSizeMedium * 1.6
                text: ""
                font.pixelSize: UIMaterials.fontSizeMedium

                onPressed: {
                    text = ""
                }

                onAccepted: {
                    var ret = xpBackend.searchForCustomer( text )
                    focus = false
                }
            }

            Label {
                id: titCustomerInfo
                anchors.left: titCustomerCode.left
                anchors.top: txtCustomerCode.bottom
                anchors.topMargin: 15
                text: "Thông tin khách hàng"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: UIMaterials.grayPrimary
            }

            Column {
                id: column
                width: txtCustomerCode.width
                anchors.left: txtCustomerCode.left
                anchors.top: titCustomerInfo.bottom
                anchors.topMargin: 5
                spacing: 5
                visible: false

                Row {
                    spacing: 0
                    Label {
                        id: titCustomerName
                        width: column.width / 3
                        text: qsTr( "Tên KH: " )
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                    }

                    Label {
                        id: lblCustomerName
                        width: 2*column.width / 3
                        text: ""
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Row {
                    spacing: 0
                    Label {
                        id: titCustomerShoppingCnt
                        width: 2*column.width / 3
                        text: qsTr( "Số lần mua sắm: " )
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                    }

                    Label {
                        id: lblCustomerShoppingCnt
                        width: column.width / 3
                        text: ""
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Row {
                    spacing: 0
                    Label {
                        id: titCustomerPoint
                        width: 2*column.width / 3
                        text: qsTr( "Điểm tích lũy: " )
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                    }

                    Label {
                        id: lblCustomerPoint
                        width: column.width / 3
                        text: ""
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        horizontalAlignment: Text.AlignRight
                    }
                }

            }

            Button {
                id: btnUsePoint
                anchors.right: txtCustomerCode.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                width: Math.max( parent.width / 4, txtBtnUsePoint.width + 4)
                height: titCustomerCode.height * 2.5
                visible: false
                background: Rectangle {
                    color: titleColor
                    radius: 5
                    anchors.fill: parent
                    Text {
                        id: txtBtnUsePoint
                        color: "white"
                        font.pixelSize: UIMaterials.fontSizeSmall
                        text: "Dùng điểm"
                        anchors.centerIn: parent
                    }
                }

                onClicked: {
                    if( lastCustomer !== undefined )
                    {

                    }
                }
            }

        }                

        Rectangle {
            id: pnPaying
            width: root.width / 2
            height: root.height

            //============= Section for selecting paying method

            RadioButton {
                id: radioCash
                width: 40
                height: btnCash.height
                checked: true
                anchors.verticalCenter: btnCash.verticalCenter
                anchors.right: btnCash.left
                onClicked: {
                    btnCash.clicked()
                }

                onCheckedChanged: {
                    if( checked === true )
                    {
                        titPayingAmount.visible = true
                        titReturnAmount.visible = true
                        txtPayingAmount.visible = true
                        txtReturnAmount.visible = true
                    }
                }
            }

            Button {
                id: btnCash
                width: pnPaying.width / 4
                height: 60
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.horizontalCenter
                background: Rectangle
                {
                    id: bgrBtnCash
                    anchors.fill: parent
                    color: buttonColor1
                    radius: 5

                    Text {
                        id: txtBtnCash
                        text: "Tiền mặt"
                        font.pixelSize: UIMaterials.fontSizeSmall
                        color: "white"
                        anchors.centerIn: parent
                        anchors.topMargin: 5
                    }
                }
                onClicked: {
                    radioCash.checked = true
                    bgrBtnCash.color = buttonColor1
                    bgrBtnCard.color = titleColor
                }



            }

            RadioButton {
                id: radioCard
                width: 40
                height: btnCard.height
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: btnCard.left
                onClicked: {
                    btnCard.clicked()
                }

                onCheckedChanged: {
                    if( checked === true )
                    {
                        titPayingAmount.visible = false
                        titReturnAmount.visible = false
                        txtPayingAmount.visible = false
                        txtReturnAmount.visible = false
                    }
                }
            }

            Button {
                id: btnCard
                width: pnPaying.width / 4
                height: 60
                anchors.verticalCenter: radioCard.verticalCenter
                anchors.right: pnPaying.right
                anchors.rightMargin: 20
                background: Rectangle
                {
                    id: bgrBtnCard
                    anchors.fill: parent
                    color: titleColor
                    radius: 5

                    Text {
                        id: txtBtnCard
                        text: "Thẻ"
                        color: "white"
                        font.pixelSize: UIMaterials.fontSizeSmall
                        anchors.centerIn: parent
                        anchors.topMargin: 5
                    }
                }

                onClicked: {
                    radioCard.checked = true
                    bgrBtnCard.color = buttonColor1
                    bgrBtnCash.color = titleColor
                }
            }

            //================== Section for inputing customer paying amount
            Label {
                id: titPayingAmount
                anchors.left: txtPayingAmount.left
                anchors.top: btnCard.bottom
                anchors.topMargin: 15
                text: "Nhập số tiền khách trả"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: titleColor
            }

            TextField {                

                id: txtPayingAmount
                anchors.right: btnCard.right
                anchors.top: titPayingAmount.bottom
                anchors.topMargin: 5
                width: txtCustomerCode.width
                height: UIMaterials.fontSizeMedium * 1.6
                text: ""
                font.pixelSize: UIMaterials.fontSizeMedium

                onPressed:  {
                    text = ""
                }

                onTextEdited: {
                    var orgText = text.replace( /,/g, "" )
                    orgText = orgText.replace( "vnd", "" )
                    var num = parseInt(orgText, 10)
                    if( isNaN(num) === false )
                    {
                        var vietnam = Qt.locale( )
                        text = Number(num).toLocaleString( vietnam, "f", 0 ) + " vnd"
                        cursorPosition = length - 4
                    }
                    else
                    {
                        text = ""
                    }

                }

                onAccepted: {
                    var orgText = text.replace( /,/g, "" )
                    orgText = orgText.replace( "vnd", "" )
                    var payingAmount = parseFloat(orgText, 10)
                    var vietnam = Qt.locale( )
                    txtReturnAmount.text = Number(payingAmount-totalCharge).toLocaleString( vietnam, "f", 0 ) + " vnd"
                    focus = false
                }
            }

            Label {
                id: titReturnAmount
                anchors.left: txtPayingAmount.left
                anchors.top: txtPayingAmount.bottom
                anchors.topMargin: 15
                text: "Tiền trả lại khách"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: titleColor
            }

            Label {
                id: txtReturnAmount
                anchors.left: titReturnAmount.left
                anchors.top: titReturnAmount.bottom
                anchors.topMargin: 5
                width: parent.width / 3
                height: UIMaterials.fontSizeMedium * 1.6
                text: ",000 vnd"
                font.pixelSize: UIMaterials.fontSizeMedium
            }

            Button {
                id: btnComplete
                width: parent.width / 3
                height: 70
                anchors.right: txtPayingAmount.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height - (btnUsePoint.y + btnUsePoint.height)

                background: Rectangle {
                    color:  "#607d8b"
                    radius: 5
                    anchors.fill: parent
                    Text {
                        id: txtBtnComplete
                        color: "white"
                        font.pixelSize: UIMaterials.fontSizeMedium
                        text: "Hoàn thành\nđơn hàng"
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                onClicked:
                {
                    var ret = xpBackend.httpPostInvoice();
                }
            }
        }
    }
}
