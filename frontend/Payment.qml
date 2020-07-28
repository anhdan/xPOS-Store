import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."

Rectangle {
    id: root
    color: "white"

    property var currItemList
    property var currCustomer
    property var currPayment
    property real totalCharge: 0

    //=============== Functions
    function setDefaultDisplay()
    {
        currPayment = Helper.setDefaultPayment( currPayment )
        currCustomer = Helper.setDefaultCustomer( currCustomer )

        txtCustomerCode.text = ""
        column.visible = false
        btnUsePoint.enabled = true
        radioCash.checked = true
        txtPayingAmount.text = ""
        lblReturnAmount.text = ""
        columnReturn.visible = false
        btnComplete.visible = false
    }

    function initialize( latestCost, latesTax, latestDiscount, itemList )
    {
        currPayment = Helper.setDefaultPayment( currPayment )
        currCustomer = Helper.setDefaultCustomer( currCustomer )
        currPayment["total_discount"] = Number(latestDiscount)
        currPayment["total_charging"] = Number(latestCost) + Number(latesTax) - Number(latestDiscount)
        currItemList = itemList
    }

    function item2SellingRecord( item )
    {
        var sellingRecord = {}
        sellingRecord["bill_id"] = ""
        sellingRecord["product_barcode"] = item["barcode"]
        sellingRecord["quantity"] = item["item_num"]
        sellingRecord["total_price"] = Number(item["item_num"]) * Number(item["unit_price"])

        return sellingRecord
    }


    //=============== Signals
    signal colapse()
    signal pointUsed( var pointDiscount )
    signal payCompleted()
    signal needMorePayingAmount()

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
        currCustomer = customer//Helper.deepCopy( customer )
        lblCustomerName.text = customer["name"]
        lblCustomerShoppingCnt.text = customer["shopping_count"]
        lblCustomerPoint.text = customer["point"]
        column.visible = true
        btnUsePoint.visible = true
    }

    onCustomerNotFound:
    {
        currCustomer = Helper.setDefaultCustomer( currCustomer )
        currCustomer["id"] = txtCustomerCode.text
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
        anchors.right: txtCustomerCode.right
        anchors.top: column.bottom
        anchors.topMargin: 10
        width: Math.max( parent.width / 4, txtBtnUsePoint.width + 4)
        height: 50
        visible: false
        background: Rectangle {
            id: rectBtnUsePoint
            color: "transparent" //UIMaterials.goldDark
            border.color: UIMaterials.goldDark
            radius: 5
            anchors.fill: parent
            Text {
                id: txtBtnUsePoint
                color: UIMaterials.goldDark
                font.pixelSize: UIMaterials.fontSizeSmall
                text: "Dùng điểm"
//                anchors.right: parent.right
//                anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent
            }
        }

        onPressed: {
            rectBtnUsePoint.color = UIMaterials.grayPrimary
        }

        onReleased: {
            rectBtnUsePoint.color = "transparent"
            var convertRate = xpBackend.getPoint2MoneyRate()
            var discount = 0
            if( (currCustomer["point"] * convertRate) > currPayment["total_charging"] )
            {
                currPayment["used_point"] = ((currPayment["total_charging"] / convertRate) | 0)
                currPayment["total_discount"] += currPayment["total_charging"]
                currPayment["total_charging"] = 0
                txtPayingAmount.text = "0 vnd"
                txtPayingAmount.accepted()
            }
            else
            {
                currPayment["used_point"] = currCustomer["point"]
                currPayment["total_discount"] += currCustomer["point"] * convertRate
                currPayment["total_charging"] = currPayment["total_charging"] - currCustomer["point"] * convertRate
                if( radioCash.checked === true )
                {
                    txtPayingAmount.focus = true
                }
            }

            lblCustomerPoint.text = currCustomer["point"] - currPayment["used_point"]
            enabled = false
            pointUsed( discount )
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
                txtPayingAmount.focus = true
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
                txtPayingAmount.focus = false
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
            if( payingAmount >= currPayment["total_charging"] )
            {
                var vietnam = Qt.locale( )
                currPayment["customer_payment"] = payingAmount
                lblReturnAmount.text = Number(payingAmount-currPayment["total_charging"]).toLocaleString( vietnam, "f", 0 ) + " vnd"
                columnReturn.visible = true
                focus = false
                btnComplete.visible = true
            }
            else
            {
                needMorePayingAmount()
            }

        }
    }


    //=========== Payment return and reward points area
    Column {
        id: columnReturn
        width: txtCustomerCode.width
        anchors.left: txtCustomerCode.left
        anchors.top: txtPayingAmount.bottom
        anchors.topMargin: 30
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
        visible: false

        background: Rectangle {
            id: rectBtnComplete
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

        onPressed: {
            rectBtnComplete.color = UIMaterials.goldPrimary
        }

        onReleased:
        {
            rectBtnComplete.color = UIMaterials.goldDark

            //===== Payment post processing
            var sellingRecords = []
            for( var id = 0; id < currItemList.count; id++ )
            {
//                var cpItem = JSON.parse(JSON.stringify(currItemList.get(id)))
                sellingRecords.push( item2SellingRecord(currItemList.get(id)) )
                var cpItem = Helper.deepCopy( currItemList.get( id ) )
                xpBackend.updateProductFromInvoice( cpItem )
            }            
            xpBackend.completePayment( sellingRecords, currCustomer, currPayment )

            var ret = xpBackend.httpPostInvoice();
            payCompleted()
            colapse()
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
