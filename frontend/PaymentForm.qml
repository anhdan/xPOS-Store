import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "."


Rectangle {
    id: root
    implicitWidth: 684
    implicitHeight: 768
    color: "white"

    property var currItemList
    property var currCustomer
    property var currPayment
    property real totalCharge: 0

    property alias discountStr: txtDiscountAmount.text
    property alias payingStr: txtPayingAmount.text
    property alias returnStr: icReturnAmount.infoText

    function initialize( latestCost, latesTax, latestDiscount, itemList )
    {
        currPayment = Helper.setDefaultPayment( currPayment )
        currCustomer = Helper.setDefaultCustomer( currCustomer )
        currPayment["total_discount"] = Number(latestDiscount)
        currPayment["total_charging"] = Number(latestCost) + Number(latesTax) - Number(latestDiscount)
        currItemList = itemList
        xpBackend.initializePayment()
    }


    //=============== Signals
    signal colapse()
    signal pointUsed( var newDiscount )
    signal payCompleted()
    signal needMorePayingAmount()

    signal customerFound( var customer )
    signal customerNotFound()


    //=============== I. Customer info sector
    Label {
        id: titCustomerInfo
        x: 0.0146 * parent.width
        y: 0.1823 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeS
            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayPrimary
        text: "Thông tin khách hàng"
    }

    SearchBox {
        id: searchBox
        width: 0.9561 * parent.width
        height: 0.0781 * parent.height
        anchors.left: titCustomerInfo.left
        anchors.top: titCustomerInfo.bottom
        anchors.topMargin: 0.0130*root.height
        backgroundColor: UIMaterials.colorNearWhite
        radius: 10
        placeholderText: "Nhập mã hoặc sđt khách hàng ..."
    }

    CustomerInfoBoard {
        id: boardCustomerInfo
        width: searchBox.width
        anchors.left: titCustomerInfo.left
        y: 0.1953 * parent.height
        visible: false
    }

    //======== II. Discount sector
    Label {
        id: titDiscountInfo
        anchors.left: titCustomerInfo.left
        y: 0.3906 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeS
            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayPrimary
        text: "Chiết khấu/Ưu đãi"
    }

    TextField {
        id: txtDiscountAmount
        anchors.top: titDiscountInfo.bottom
        anchors.topMargin: 0.0130 * parent.height
        anchors.left: titDiscountInfo.left
        width: 0.4678 * parent.width
        height: 0.0781 * parent.height

        background: Rectangle {
            anchors.fill: parent
            radius: 10
            color: UIMaterials.colorNearWhite
        }

        font {
            pixelSize: UIMaterials.fontsizeL
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorTaskBar
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "0 vnd"
    }

    Button {
        id: btnUsePoint
        width: btnComplete.width
        height: txtDiscountAmount.height
        anchors.verticalCenter: txtDiscountAmount.verticalCenter
        anchors.right: searchBox.right

        background: Rectangle{
            id: rectBtnUsePoint
            anchors.fill: parent
            color: UIMaterials.colorAntLogo
            radius: 10
        }

        Text {
            id: txtBtnUsePoint
            anchors.centerIn: parent
            text: "Dùng Điểm"
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            horizontalAlignment: Text.AlignHCenter
            color: "white"
        }

        onClicked: {
            if( rectBtnUsePoint.color === UIMaterials.colorTrueGray )
            {
                rectBtnUsePoint.color = UIMaterials.colorAntLogo
                txtBtnUsePoint.text = "Dùng Điểm"
            }
            else
            {
                rectBtnUsePoint.color = UIMaterials.colorTrueGray
                txtBtnUsePoint.text = "Hủy Dùng Điểm"
            }
        }
    }

    //=========== III. Paying info
    Label {
        id: titPayingInfo
        anchors.left: titCustomerInfo.left
        y: 0.5990 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeS
            weight: Font.Bold
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayPrimary
        text: "Khách thanh toán"
    }

    TextField {
        id: txtPayingAmount
        anchors.top: titPayingInfo.bottom
        anchors.topMargin: 0.0130 * parent.height
        anchors.left: titDiscountInfo.left
        width: 0.4678 * parent.width
        height: 0.0781 * parent.height

        background: Rectangle {
            anchors.fill: parent
            radius: 10
            color: UIMaterials.colorNearWhite
        }

        font {
            pixelSize: UIMaterials.fontsizeL
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorTaskBar
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: ""
    }

    // Radio button for selecting paying method
    RadioButton {
        id: radioCash
        width: UIMaterials.fontsizeXL
        height: UIMaterials.fontsizeXL
        checked: true
        anchors.verticalCenter: txtPayingAmount.verticalCenter
        anchors.left: root.horizontalCenter
        anchors.leftMargin: width
        onClicked: {
            btnCash.clicked()
        }
    }

    Button {
        id: btnCash
        width: 1.2 * txtBtnCash.width
        height: txtPayingAmount.height
        anchors.verticalCenter: txtPayingAmount.verticalCenter
        anchors.left: radioCash.right
        background: Rectangle
        {
            id: bgrBtnCash
            anchors.fill: parent
            color: "transparent"
            radius: 10
        }

        Text {
            id: txtBtnCash
            text: "Tiền mặt"
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorTaskBar
            anchors.centerIn: parent
        }

        onClicked: {
            radioCash.checked = true
            txtBtnCash.color = UIMaterials.colorTaskBar
            txtBtnCard.color = UIMaterials.colorTrueGray
        }
    }

    RadioButton {
        id: radioCard
        width: UIMaterials.fontsizeXL
        height: UIMaterials.fontsizeXL
        anchors.verticalCenter: txtPayingAmount.verticalCenter
        anchors.left: btnCash.right
        anchors.leftMargin: width

        onClicked: {
            btnCard.clicked()
        }
    }

    Button {
        id: btnCard
        width: 1.2 * txtBtnCard.width
        height: txtPayingAmount.height
        anchors.verticalCenter: txtPayingAmount.verticalCenter
        anchors.left: radioCard.right
        background: Rectangle
        {
            id: bgrBtnCard
            anchors.fill: parent
            color: "transparent"
            radius: 10
        }

        Text {
            id: txtBtnCard
            text: "Thẻ"
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorTrueGray
            anchors.centerIn: parent
        }

        onClicked: {
            radioCard.checked = true
            txtBtnCash.color = UIMaterials.colorTrueGray
            txtBtnCard.color = UIMaterials.colorTaskBar
        }
    }

    // Return amount text
    InfoCard {
        id: icReturnAmount
        cardWidth: txtPayingAmount.width
        titleHeight: 1.5385 * UIMaterials.fontsizeM
        infoHeight: titleHeight
        isBold: true
        anchors.top: txtPayingAmount.bottom
        anchors.topMargin: 0.0195 * parent.height
        anchors.left: txtPayingAmount.left
        titleText: "Trả lại khách"
        infoText: "0 vnd"
    }


    //============== IV. Control buttons
    Row {
        spacing: 20
        y: 0.9049 * root.height
        anchors.right: searchBox.right

        Button {
            id: btnDept
            width: 0.1462 * root.width
            height: 0.0781 * root.height

            background: Rectangle{
                id: rectBtnDept
                anchors.fill: parent
                color: UIMaterials.colorTrueGray
                radius: 10
            }

            Text {
                anchors.centerIn: parent
                text: "Nợ"
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
            }

            onPressed: {
                rectBtnDept.opacity = 0.6
            }

            onReleased: {
                rectBtnDept.opacity = 1
            }
        }

        Button {
            id: btnComplete
            width: 1.9 * btnDept.width
            height: btnDept.height

            background: Rectangle{
                id: rectBtnComplete
                anchors.fill: parent
                color: UIMaterials.colorTrueBlue
                radius: 10
            }

            Text {
                anchors.centerIn: parent
                text: "Đã Thanh Toán"
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignHCenter
                color: "white"
            }

            onPressed: {
                rectBtnComplete.opacity = 0.6
            }

            onReleased: {
                rectBtnComplete.opacity = 1
            }
        }
    }

    Button {
        id: btnColapse
        width: height
        height: 0.0781 * parent.height
        anchors.top: parent.top
        anchors.right: parent.right

        background: Rectangle{
            anchors.fill: parent
            color: "transparent"
            radius: 10
        }

        Text {
            anchors.centerIn: parent
            text: "\uf00d"
            font {
                pixelSize: UIMaterials.fontsizeL
                weight: Font.Bold
                family: UIMaterials.solidFont
            }
            color: UIMaterials.grayPrimary
        }

        onClicked: {
            colapse()
        }
    }
}
