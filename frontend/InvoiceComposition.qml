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
    implicitWidth: UIMaterials.windowWidth
    implicitHeight: UIMaterials.windowHeight

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

    function showNotFoundNoti()
    {
        // notification
        if( noti.state === "visible" )
        {
            noti.state = "invisible"
        }
        noti.showNoti( "Không tìm thấy trong cơ sở dữ liệu!", "error" )
        noti.state = "visible"
        noti.focus = true
    }

    Component.onCompleted: {
        xpBackend.sigProductNotFound.connect( showNotFoundNoti )
    }

    onOpacityChanged: {
        var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
        if( opacity === 1 )
        {
            enabled = true
            xpBackend.sigProductNotFound.connect( showNotFoundNoti )
        }
        else
        {
            enabled = false
            xpBackend.sigProductNotFound.disconnect( showNotFoundNoti )
        }
    }

    signal toInventoryBoard()
    signal toCustomerBoard()
    signal toAnalyticsBoard()
    signal toSetupBoard()
    signal toLoginBoard()


    //===================== 1. Panel of control buttons and price screen
    Rectangle {
        id: pnControl
        width: parent.width / 3
        height: parent.height
        x: 0
        y: 0
        color: "white"

        //========= 1.1. Price screen panel
        PriceScreen {
            id: priceScreen
            width: parent.width
            height: 0.2344 * parent.height
            anchors.top: parent.top
            anchors.left: parent.left
        }

        //========= 1.2. Numpad and control keys panel

        Row {
            y: 0.2604 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0.05 * btnIncrease.width

            Button {
                id: btnDelete
                width: 0.3226 * pnNumpad.width
                height: 0.2188 * pnNumpad.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnDelete
                    anchors.fill: parent
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    text: "\uf1f8"
                    anchors.centerIn: parent
                    color: UIMaterials.colorTrueRed
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.3 * rectBtnIncrease.width )
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                onPressed: {
                    rectBtnDelete.color = "white"
                }

                onReleased: {
                    rectBtnDelete.color = UIMaterials.colorNearWhite
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    tab.item.removeCurrItem()
                }
            }

            Button {
                id: btnDecrease
                width: 0.3226 * pnNumpad.width
                height: 0.2188 * pnNumpad.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnDecrease
                    anchors.fill: parent
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    text: "-"
                    anchors.centerIn: parent
                    color: UIMaterials.colorTrueBlue
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: Math.floor( 0.6 * rectBtnIncrease.width )
                        weight: Font.Bold
                    }
                }

                onPressed: {
                    rectBtnDecrease.color = "white"
                }

                onReleased: {
                    rectBtnDecrease.color = UIMaterials.colorNearWhite
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
                id: btnIncrease
                width: 0.3226 * pnNumpad.width
                height: 0.2188 * pnNumpad.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnIncrease
                    anchors.fill: parent
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    text: "\uf067"
                    anchors.centerIn: parent
                    color: UIMaterials.colorTrueBlue
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.3 * rectBtnIncrease.width )
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                onPressed: {
                    rectBtnIncrease.color = "white"
                }

                onReleased: {
                    rectBtnIncrease.color = UIMaterials.colorNearWhite
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    var currItemQuant = tab.item.getCurrItemQuantity()
                    var currItemInstock = tab.item.getCurrItemInstock()
                    if( currItemInstock > currItemQuant )
                    {
                        currItemQuant++
                    }
                    tab.item.updateCurrItemQuantity( currItemQuant )
                }
            }
        }

        NumPad {
            id: pnNumpad
            y: 0.3776 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            width: 0.9118 * parent.width
            height: 0.4167 * parent.height
        }

        Row {
            y: 0.8594 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0.0645 * pnNumpad.width

            Button {
                id: btnQuickFinish
                width: 0.3326 * pnNumpad.width
                height: btnDelete.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnQuickFinish
                    anchors.fill: parent
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    text: qsTr("Xuất\nNhanh")
                    anchors.centerIn: parent
                    color: UIMaterials.colorTaskBar
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: 0.26 * btnQuickFinish.width
                        family: UIMaterials.fontRobotoLight
                    }

                }

                onPressed: {
                    rectBtnQuickFinish.color = "white"
                }

                onReleased: {
                    rectBtnQuickFinish.color = UIMaterials.colorNearWhite
                }
            }

            Button {
                id: btnMakePayment
                width: 0.6129 * pnNumpad.width
                height: btnQuickFinish.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnMakePayment
                    anchors.fill: parent
                    color: UIMaterials.colorAntLogo
                }

                Text {
                    text: qsTr("Thanh Toán")
                    anchors.centerIn: parent
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: 0.26 * btnQuickFinish.width
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnMakePayment.color = UIMaterials.goldPrimary
                }

                onReleased: {
                    rectBtnMakePayment.color = UIMaterials.colorAntLogo
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    if( tab.item.count > 0 )
                    {
                        pnPayment.initialize(tab.item.latestCost, tab.item.latestTax, tab.item.latestDiscount, tab.item.model)

                        if( pnPayment.opacity === 0 )
                        {
                            payTransitionOnY.start()
                            tabviewInvoice.enabled = false
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: pnInvoiceTabs
        width: 2*parent.width / 3
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
                    xpBackend.sigProductFound.connect( item.productFound )
                    xpBackend.sigProductNotFound.connect( item.productNotFound )                    
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

            onCurrentIndexChanged: {
                var prevTab = tabviewInvoice.getTab( 1- tabviewInvoice.currentIndex )
                xpBackend.sigProductFound.disconnect( prevTab.item.productFound )
                xpBackend.sigProductNotFound.disconnect( prevTab.item.productNotFound )

                var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                xpBackend.sigProductFound.connect( tab.item.productFound )
                xpBackend.sigProductNotFound.connect( tab.item.productNotFound )
                showCost( tab.item.latestCost, tab.item.latestTax, tab.item.latestDiscount )
            }
        }

        //================== Control button
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
            id: btnRtAnalytics
            width: 60
            height: 60
            anchors.right: pnRtAnalytics.left
            anchors.bottom: pnRtAnalytics.bottom

            background: Rectangle {
                id: rectBtnRtAnalytics
                anchors.fill: parent
                color: "transparent"
                radius: 10
            }

            Text {
                id: txtBtnRtAnalytics
                text: "\uf201"
                anchors.centerIn: parent
                color: (pnRtAnalytics.state === "visible") ? UIMaterials.grayLight
                                                           : UIMaterials.grayPrimary
                font {
                    pixelSize: 40;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onClicked: {
                if( pnRtAnalytics.state === "visible" )
                {
                    pnRtAnalytics.state = "invisible"
                }
                else
                {
                    pnRtAnalytics.state = "visible"
                }
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
            width: 3*parent.width / 5
            height: parent.height
            opacity: 0
            x: 0
            y: 0
            z: 20
            clip: true

            //================== Signal handling
            onColapse: {
                payTransitionOnYRev.start()
                tabviewInvoice.enabled = true
            }

            onPayCompleted: {
                showCost(0, 0, 0)
                var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                tab.item.clearList()
                pnPayment.setDefaultDisplay()

                // notification
                if( noti.state == "visible" )
                {
                    noti.state = "invisible"
                }
                noti.showNoti( "Hoàn tất 01 đơn hàng", "success" )
                noti.state = "visible"
                noti.focus = true
            }

            onPointUsed: {
                var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                showCost( tab.item.latestCost, tab.item.latestTax, newDiscount )
            }

            onNeedMorePayingAmount: {
                // notification
                if( noti.state == "visible" )
                {
                    noti.state = "invisible"
                }
                noti.showNoti( "Tiền khách trả chưa đủ!", "error" )
                noti.state = "visible"
                noti.focus = true
            }

            onCustomerNotFound: {
                showNotFoundNoti()
            }

            //================== Animation
            NumberAnimation {
                id: payTransitionOnY
                target: pnPayment
                property: "opacity"
                from: 0
                to: 1
                duration: 250
            }

            NumberAnimation {
                id: payTransitionOnYRev
                target: pnPayment
                property: "opacity"
                from: 1
                to: 0
                duration: 250
            }
        }                        

        //=================== Realtime Analytics Panel
        RealtimeAnalytics {
            id: pnRtAnalytics
            width: root.width * 3/8
            height: parent.height
            y: 0
            z: parent.z + 10
            color: "white"
            state: "invisible"

            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: pnRtAnalytics
                        x: parent.width-pnRtAnalytics.width
                    }
                },

                State {
                    name: "invisible"
                    PropertyChanges {
                        target: pnRtAnalytics
                        x: parent.width
                    }
                }
            ]

            transitions: Transition {
                from: "invisible"
                to: "visible"
                reversible: true
                SequentialAnimation {
                    NumberAnimation {
                        properties: "x"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            onStateChanged: {
                if( state === "visible" )
                {
                    if( categoryText === "Doanh thu(đ)" )
                    {
                        xpBackend.sortTop5( 1 )
                    }
                    else if( categoryText === "Lợi nhuận(đ)" )
                    {
                        xpBackend.sortTop5( 2 )
                    }
                    else
                    {
                        xpBackend.sortTop5( 3 )
                    }
                }
            }
        }
    }

    //=================== Notification Popup
    NotificationPopup {
        id: noti
        width: 3*pnControl.width/4
        height: 100
        x: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        state: "invisible"

        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: noti
                    x: 5
                }
            },

            State {
                name: "invisible"
                PropertyChanges {
                    target: noti
                    x: -noti.width
                }
            }
        ]

        transitions: Transition {
            from: "invisible"
            to: "visible"
            reversible: true
            SequentialAnimation {
                NumberAnimation {
                    properties: "x"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        onColapse: {
            state = "invisible"
        }

        onStateChanged: {
            if( state === "visible" )
            {
                focus = true
            }
        }

        onFocusChanged: {
            if( focus === false )
            {
                state = "invisible"
            }
        }
    }    
}
