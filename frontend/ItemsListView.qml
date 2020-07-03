import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import "."


ListView {
    id: root
    model: itemModel
    clip: true
    cacheBuffer: 50

    property real latestCost: 0
    property real latestTax: 0
    property real latestDiscount: 0


    //====================== Signals ============================
    signal itemAdded()
    signal currItemQuantityUpdated()
    signal itemRemoved()
    signal costCalculated( var cost, var tax, var discount )
    signal productFound( var product )
    signal productNotFound()

    //====================== Function ==========================
    function searchProductInList( code )
    {
        for( var idx = 0; idx < itemModel.count; idx++ )
        {
            var item = itemModel.get( idx )
            if( item["barcode"] === code )
            {
                changeHighLight( idx )
                var currQuant = getCurrItemQuantity()
                updateCurrItemQuantity( currQuant + 1 )
                return true
            }
        }

        return false
    }


    function changeHighLight( newIndex )
    {
        if( root.currentIndex > -1 && root.currentIndex < itemModel.count )
        {
            var prevDelegate = root.currentItem
            prevDelegate.color = "white"
            prevDelegate.textColor = "black"
        }

        if( newIndex > -1 )
        {
            root.currentIndex = newIndex
            var currDelegate = root.currentItem
            currDelegate.color = UIMaterials.appBgrColorPrimary
            currDelegate.textColor = "white"
        }
    }


    function getCurrItemQuantity()
    {
        if( root.currentIndex === - 1 )
        {
            return 0
        }
        var currItem = itemModel.get( root.currentIndex )
        return currItem["item_num"]
    }


    function updateCurrItemQuantity( newQuant )
    {
        if( root.currentIndex === -1 )
        {
            return
        }

        var currItem = itemModel.get( root.currentIndex )
        currItem["item_num"] = newQuant
        currItemQuantityUpdated()
        calculateCost()
    }


    function calculateCost()
    {
        if( itemModel.count > 0 )
        {
            console.log( "-----> here" )
            var cost = 0
            for( var idx = 0; idx < itemModel.count; idx++ )
            {
                var item = itemModel.get( idx )
                cost += Number( item["unit_price"] ) * Number(item["item_num"])
            }
            latestCost = cost
        }
        else
        {
            latestCost = latestDiscount = latestTax = 0
        }

        costCalculated( latestCost, latestTax, latestDiscount )
    }


    function addItem( code )
    {
        var ret = searchProductInList( code )

        if( ret === false )
        {
            xpBackend.searchForProduct( code )
        }
        else
        {
            itemAdded()
        }
    }


    function removeCurrItem()
    {
        if( root.currentIndex > -1 )
        {
            for( var i = root.currentIndex+1; i < itemModel.count; i++ )
            {
                itemModel.setProperty( i, "item_order", i )
            }
            itemModel.remove( root.currentIndex )
            if( root.currentIndex >= itemModel.count )
            {
                root.currentIndex = itemModel.count - 1
            }
            changeHighLight( root.currentIndex )
            itemRemoved()
            calculateCost()
        }
    }


    //=================== Signal - slot connection
    Component.onCompleted: {
        xpBackend.sigProductFound.connect( root.productFound )
        xpBackend.sigProductNotFound.connect( root.productNotFound )
    }

    //================== Signal Handling
    onProductFound: {
        var item = Helper.deepCopy( product )
        item["item_order"] = itemModel.count + 1
        item["item_num"] = 1
        itemModel.append( item )
        var newIndex = itemModel.count - 1
        changeHighLight( newIndex )
        itemAdded()
        calculateCost()
    }


    //====================== List model =========================
    ListModel {
        id: itemModel
    }


    //==================== Listview Delegate ====================
    delegate: Rectangle {
        id: itemDelegate
        width: parent.width
        height: 70
        border.color: "#cdcdcd"
        color: "white"
        border.width: 1

        property alias bgrItemNumColor: bgrItemNum.color
        property string textColor: "black"

        Row {
            id: itemRow
            anchors.fill: parent
            spacing: 0
            Label {
                id: lblCount
                width: parent.width * 3/50
                height: parent.height

                text: item_order
                font.pixelSize: UIMaterials.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: textColor
            }

            Label {
                id: lblItemInfo
                width: parent.width * 3/5
                height: parent.height

                text: barcode + " @ " + name + "\n" + "unit" + " @ " + Number(unit_price).toLocaleString(Qt.locale(), "f", 0) + "vnd"
                font.pixelSize: UIMaterials.fontSizeMedium
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: textColor

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    onClicked: {
                        changeHighLight( index )
                    }
                }
            }

            TextField {
                id: txtItemNum
                width: parent.width * 2 / 15
                height: parent.height
                focus: false

                text: item_num
                font.pixelSize: UIMaterials.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: textColor

                background: Rectangle {
                    id: bgrItemNum
                    anchors.fill: parent
                    border.width: 0
                    color: "transparent"
                }

                onPressed: {
                    changeHighLight( index )
                    var currDelegate = root.currentItem
                    currDelegate.bgrItemNumColor = UIMaterials.goldDark
                }

                onAccepted: {
                    var currDelegate = root.currentItem
                    var currItemQuant = parseInt( text, 10 )
                    updateCurrItemQuantity( currItemQuant )
                    currDelegate.bgrItemNumColor = "transparent"
                    focus = false
                }
            }

            Label {
                id: lblItemPrice
                width: parent.width * 11 / 50
                height: parent.height

                text: (item_num * unit_price).toLocaleString( Qt.locale(), 'f', 0 )
                font.pixelSize: UIMaterials.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: textColor
            }
        }
    }


    //================= Listview Header ========================
    header: Row {
        id: pnTitleBar
        width: parent.width
        height: 50
        spacing: 0

        Rectangle {
            id: rectTitOrder
            width: parent.width * 3/50
            height: parent.height
            color: UIMaterials.appBgrColorLight
            border.color: "white"
            border.width: 1
            Text {
                text: qsTr("#")
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: rectTitInfo
            width: parent.width * 3/5
            height: parent.height
            color: UIMaterials.appBgrColorLight
            border.color: "white"
            border.width: 1
            Text {
                text: qsTr("Thông tin sản phẩm")
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: rectTitNum
            width: parent.width * 2 / 15
            height: parent.height
            color: UIMaterials.appBgrColorLight
            border.color: "white"
            border.width: 1
            Text {
                text: qsTr("Số lượng")
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: rectTitPrice
            width: parent.width * 11 / 50
            height: parent.height
            color: UIMaterials.appBgrColorLight
            border.color: "white"
            border.width: 1
            Text {
                text: qsTr("Thành tiền")
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    headerPositioning: ListView.OverlayHeader
}
