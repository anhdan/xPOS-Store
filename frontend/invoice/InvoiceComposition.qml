import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2
import QtGraphicalEffects 1.0

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root
    implicitWidth: UIMaterials.windowWidth
    implicitHeight: UIMaterials.windowHeight
    color: UIMaterials.colorNearWhite
    state: "invisible"


    //========================== I. Signal - Slot definition
    function showCost( cost, tax, discount )
    {
        var vietnam = Qt.locale( )
        priceScreen.orgPriceStr = Number(cost).toLocaleString( vietnam, "f", 0 ) + " vnd"
        priceScreen.taxStr = Number(tax).toLocaleString( vietnam, "f", 0 ) + " vnd"
        priceScreen.discountStr = Number(discount).toLocaleString( vietnam, "f", 0 ) + " vnd"
        priceScreen.totalChargeStr = Number(cost + tax - discount).toLocaleString( vietnam, "f", 0 ) + " vnd"
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
        beInvoice.sigProductNotFound.connect( showNotFoundNoti )
    }

    onOpacityChanged: {
        var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
        if( opacity === 1 )
        {
            enabled = true
            beInvoice.sigProductNotFound.connect( showNotFoundNoti )
        }
        else
        {
            enabled = false
            beInvoice.sigProductNotFound.disconnect( showNotFoundNoti )
        }
    }

    signal toInventoryBoard()
    signal toCustomerBoard()
    signal toAnalyticsBoard()
    signal toSetupBoard()
    signal toLoginBoard()
    signal menuClicked()


    //========================= II. Panel of control buttons and price screen
    Rectangle {
        id: pnControl
        width: 0.332* parent.width
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.colorTaskBar

        //----- 1.1. Price screen panel
        PriceScreen {
            id: priceScreen
            width: parent.width
            height: 0.2344 * parent.height
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.top: priceScreen.bottom
            anchors.left: parent.left
            color: pnNumpad.keyBgrColor
            opacity: pnNumpad.keyOpacity
        }

        //----- 1.2. Numpad and control keys panel
        Row {
            y: 0.2734 * parent.height
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
                    color: pnNumpad.keyBgrColor
                    opacity: pnNumpad.keyOpacity
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
                    rectBtnDelete.color = pnNumpad.keyBgrColorPressed
                }

                onReleased: {
                    rectBtnDelete.color = pnNumpad.keyBgrColor
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
                    opacity: pnNumpad.keyOpacity
                }

                Text {
                    text: "-"
                    anchors.centerIn: parent
                    color: pnNumpad.keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: Math.floor( 0.6 * rectBtnIncrease.width )
                        weight: Font.Bold
                    }
                }

                onPressed: {
                    rectBtnDecrease.color = pnNumpad.keyBgrColorPressed
                }

                onReleased: {
                    rectBtnDecrease.color = pnNumpad.keyBgrColor
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    tab.item.decreaseItemQuantity()
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
                    color: pnNumpad.keyTxtColor
                    opacity: pnNumpad.keyOpacity
                }

                Text {
                    text: "\uf067"
                    anchors.centerIn: parent
                    color: pnNumpad.keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.3 * rectBtnIncrease.width )
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                onPressed: {
                    rectBtnIncrease.color = pnNumpad.keyBgrColorPressed
                }

                onReleased: {
                    rectBtnIncrease.color = pnNumpad.keyBgrColor
                    var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
                    tab.item.increaseItemQuantity()
                }
            }
        }

        NumPad {
            id: pnNumpad
            y: 0.4036 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            width: 0.9118 * parent.width
            height: 0.4167 * parent.height
        }

        Row {
            y: 0.8854 * parent.height
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
                    color: pnNumpad.keyBgrColor
                    opacity: pnNumpad.keyOpacity
                }

                Text {
                    text: qsTr("Xuất\nNhanh")
                    anchors.centerIn: parent
                    color: pnNumpad.keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: 0.26 * btnQuickFinish.width
                        family: UIMaterials.fontRobotoLight
                    }

                }

                onPressed: {
                    rectBtnQuickFinish.color = pnNumpad.keyBgrColorPressed
                }

                onReleased: {
                    rectBtnQuickFinish.color = pnNumpad.keyBgrColor
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
                        pnPayment.initialize(tab.item.latestCost, tab.item.latestTax, tab.item.latestDiscount, tab.item.getList())

                        if( pnPayment.state === "deactivated" )
                        {
                            pnPayment.state = "activated"
                        }
                    }
                }
            }
        }
    }

    //======================== III. Invoice item tabview
    TabView {
        id: tabviewInvoice
        anchors.left: pnControl.right
        anchors.top: parent.top
        width: parent.width - pnControl.width
        height: parent.height

        Tab {
            id: tab1
            title: "Hóa Đơn 1"
            source: "ItemsList.qml"
            onLoaded: {
                item.costCalculated.connect( root.showCost )
                item.active = true
            }
        }

        Tab {
            id: tab2
            title: "Hóa Đơn 2"
            source: "ItemsList.qml"
            onLoaded: {
                item.costCalculated.connect( root.showCost )
            }
        }

        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                id: rectTab
                color: styleData.selected ? UIMaterials.colorNearWhite : UIMaterials.colorTaskBar
                implicitWidth: 0.2924 * tabviewInvoice.width
                implicitHeight: 0.0781 * root.height

                Rectangle {
                    width: 2
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? UIMaterials.colorTaskBar : UIMaterials.colorNearWhite
                    font {
                        pixelSize: 0.13 * parent.width
                        family: UIMaterials.fontRobotoLight
                    }
                }
            }

            tabBar: Rectangle {
                width: tabviewInvoice.width
                height: 0.0781 * root.height
                color: UIMaterials.colorTaskBar

                Button {
                    id: btnMenu
                    width: height
                    height: 0.8333 * parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: y

                    background: Rectangle {
                        id: rectBtnMenu
                        anchors.fill: parent
                        color: UIMaterials.colorNearWhite
                        radius: 10

                        Image {
                            id: imgBtnMenu
                            source: "qrc:/resource/imgs/Logo_withName_tr_40.png"
                            anchors.centerIn: parent
                            smooth: true
                        }
                    }

                    onPressed: {
                        rectBtnMenu.opacity = 0.6
                    }

                    onReleased: {
                        rectBtnMenu.opacity = 1
                        menuClicked()
                    }
                }
            }
        }

        onCurrentIndexChanged: {
            var prevTab = tabviewInvoice.getTab( 1 - tabviewInvoice.currentIndex )
            prevTab.item.active = false
            var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
            tab.item.active = true
            showCost( tab.item.latestCost, tab.item.latestTax, tab.item.latestDiscount)
        }
    }

    //======================== IV. Payment form
    PaymentForm {
        id: pnPayment
        width: tabviewInvoice.width
        height: tabviewInvoice.height
        anchors.left: tabviewInvoice.left
        anchors.top: tabviewInvoice.top
        state: "deactivated"

        states: [
            State {
                name: "activated"
                PropertyChanges {
                    target: pnPayment
                    opacity: 1
                    enabled: true
                }
            },

            State {
                name: "deactivated"
                PropertyChanges {
                    target: pnPayment
                    opacity: 0
                    enabled: false
                }
            }
        ]

        transitions: Transition {
            from: "deactivated"
            to: "activated"
            reversible: true
            SequentialAnimation {
                NumberAnimation {
                    properties: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        onColapse: {
            if( state === "activated" )
            {
                state = "deactivated"
            }
        }

        onPayCompleted: {
            showCost(0, 0, 0)
            var tab = tabviewInvoice.getTab( tabviewInvoice.currentIndex )
            tab.item.clearList()

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
    }


    //======================= VI. Notification Popup
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


    //========================== VII. States and transition
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
            }

            PropertyChanges {
                target: root
                enabled: true
            }
        },

        State {
            name: "invisible"
            PropertyChanges {
                target: root
                opacity: 0
            }

            PropertyChanges {
                target: root
                enabled: false
            }
        }
    ]

}
