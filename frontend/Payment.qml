import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."

Rectangle {
    id: root
    color: "white"

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

    //=============== Customer info area
    Label {
        id: titCustomerCode
        anchors.left: txtCustomerCode.left
        anchors.top: parent.top
        anchors.topMargin: 20
        text: "Mã khách hàng/SĐT"
        font.pixelSize: UIMaterials.fontSizeMedium
        color: UIMaterials.grayPrimary
    }

    TextField {
        id: txtCustomerCode
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titCustomerCode.bottom
        anchors.topMargin: 5
        width: parent.width * 0.8
        height: UIMaterials.fontSizeMedium * 1.6
        text: ""
        font.pixelSize: UIMaterials.fontSizeMedium

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 5
            border.color: UIMaterials.grayPrimary
        }

        onPressed: {
            text = ""
        }

        onAccepted: {
            var ret = xpBackend.searchForCustomer( text )
            focus = false
        }
    }

    Column {
        id: column
        width: txtCustomerCode.width
        anchors.left: txtCustomerCode.left
        anchors.top: txtCustomerCode.bottom
        anchors.topMargin: 20
        spacing: 5
        visible: false

        Row {
            spacing: 0
            Label {
                id: titCustomerName
                width: column.width / 3
                text: qsTr( "Tên KH: " )
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.grayPrimary // "black"
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
                color: UIMaterials.grayPrimary // "black"
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
                color: UIMaterials.grayPrimary // "black"
            }

            Label {
                id: lblCustomerPoint
                width: column.width / 3
                text: ""
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.goldDark
                horizontalAlignment: Text.AlignRight
            }
        }

    }

    Button {
        id: btnUsePoint
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: column.bottom
        anchors.topMargin: 10
        width: Math.max( parent.width / 4, txtBtnUsePoint.width + 4)
        height: titCustomerCode.height * 2.5
        visible: false
        background: Rectangle {
            color: UIMaterials.goldDark
            radius: 5
            anchors.fill: parent
            Text {
                id: txtBtnUsePoint
                color: UIMaterials.grayDark
                font.pixelSize: UIMaterials.fontSizeMedium
                text: "Dùng điểm"
                anchors.centerIn: parent
            }
        }

        onClicked: {
            //! TODO:
            //! Implement this
        }
    }


    //============ Payment method area
    Label {
        id: titPaymentMethod
        anchors.left: txtCustomerCode.left
        anchors.top: btnUsePoint.bottom
        anchors.topMargin: 30
        text: "Chọn phương thức thanh toán"
        font.pixelSize: UIMaterials.fontSizeMedium
        color: UIMaterials.grayPrimary
    }


    RadioButton {
        id: radioCash
        width: 40
        height: 40
        checked: true
        anchors.verticalCenter: btnCash.verticalCenter
        anchors.left: txtCustomerCode.left
        onClicked: {
            btnCash.clicked()
        }

        onCheckedChanged: {
            if( checked === true )
            {
                titPayingAmount.visible = true
                txtPayingAmount.visible = true
            }
        }
    }


    Button {
        id: btnCash
        width: root.width / 4
        height: 60
        anchors.top: titPaymentMethod.bottom
        anchors.topMargin: 5
        anchors.left: radioCash.right
        background: Rectangle
        {
            id: bgrBtnCash
            anchors.fill: parent
            color: UIMaterials.appBgrColorPrimary
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
            bgrBtnCash.color = UIMaterials.appBgrColorPrimary
            bgrBtnCard.color = UIMaterials.grayPrimary
        }
    }

    RadioButton {
        id: radioCard
        width: 40
        height: 40
        anchors.verticalCenter: btnCard.verticalCenter
        anchors.right: btnCard.left
        onClicked: {
            btnCard.clicked()
        }

        onCheckedChanged: {
            if( checked === true )
            {
                titPayingAmount.visible = false
                txtPayingAmount.visible = false
            }
        }
    }

    Button {
        id: btnCard
        width: root.width / 4
        height: 60
        anchors.top: btnCash.top
        anchors.right: txtCustomerCode.right
        background: Rectangle
        {
            id: bgrBtnCard
            anchors.fill: parent
            color: UIMaterials.grayPrimary
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
            bgrBtnCard.color = UIMaterials.appBgrColorPrimary
            bgrBtnCash.color = UIMaterials.grayPrimary
        }
    }


    //============ Payment amount area
    Label {
        id: titPayingAmount
        anchors.left: txtCustomerCode.left
        anchors.top: btnCash.bottom
        anchors.topMargin: 30
        text: "Nhập số tiền khách trả"
        font.pixelSize: UIMaterials.fontSizeMedium
        color: UIMaterials.grayPrimary
    }

    TextField {

        id: txtPayingAmount
        anchors.left: txtCustomerCode.left
        anchors.top: titPayingAmount.bottom
        anchors.topMargin: 5
        width: txtCustomerCode.width
        height: txtCustomerCode.height
        text: ""
        font.pixelSize: UIMaterials.fontSizeMedium

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 5
            border.color: UIMaterials.grayPrimary
        }

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


    //=========== Payment return and reward points area
    Column {
        id: columnReturn
        width: txtCustomerCode.width
        anchors.left: txtCustomerCode.left
        anchors.top: txtPayingAmount.bottom
        anchors.topMargin: 20
        spacing: 5
        visible: false

        Row {
            spacing: 0
            Label {
                id: titReturnAmount
                width: 2*columnReturn.width / 3
                text: qsTr( "Trả lại KH: " )
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.grayPrimary // "black"
            }

            Label {
                id: lblReturnAmount
                width: columnReturn.width / 3
                text: ""
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.appBgrColorPrimary
                horizontalAlignment: Text.AlignRight
            }
        }

        Row {
            spacing: 0
            Label {
                id: titRewardPoint
                width: 2*columnReturn.width / 3
                text: qsTr( "Điểm thưởng hóa đơn: " )
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.grayPrimary // "black"
            }

            Label {
                id: lblRewardPoint
                width: columnReturn.width / 3
                text: ""
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.appBgrColorPrimary
                horizontalAlignment: Text.AlignRight
            }
        }

    }


    //========= Control buttom
    Button {
        id: btnComplete
        width: parent.width / 3
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        background: Rectangle {
            color:  UIMaterials.goldDark
            radius: 5
            anchors.fill: parent
            Text {
                id: txtBtnComplete
                color: UIMaterials.grayDark
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


    Button {
        id: btnColapse
        width: 50
        height: 50
        z: 10
        anchors.bottom: parent.bottom
        anchors.right: parent.right
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
}
