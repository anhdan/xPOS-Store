import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import "."

Rectangle {
    id: root
    implicitWidth: 684
    implicitHeight: 768
    color: UIMaterials.colorNearWhite

    property real latestCost: 0
    property real latestTax: 0
    property real latestDiscount: 0
    property bool active: false
    property alias count: itemModel.count

    //======================= I. Signals
    signal itemAdded()
    signal currItemQuantityUpdated()
    signal itemRemoved()
    signal costCalculated( var cost, var tax, var discount )
    signal productFound( var product )
    signal productNotFound()

    Component.onCompleted: {
        beInvoice.sigProductFound.connect(
                    function(product) {
                        if( active )
                        {
                            var item = Helper.deepCopy( product )
                            item["item_order"] = itemModel.count + 1
                            item["item_num"] = 1
                            itemModel.append( item )
                            var newIndex = itemModel.count - 1
                            changeHighLight( newIndex )
                            itemAdded()
                            calculateCost()
                        }
                    }
                    )
    }

    //======================= II. Function

    function searchProductInList( code )
    {
        for( var idx = 0; idx < lvItems.model.count; idx++ )
        {
            var item = lvItems.model.get( idx )
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
        if( lvItems.currentIndex > -1 && lvItems.currentIndex < lvItems.model.count )
        {
            var prevDelegate = lvItems.currentItem
            prevDelegate.color = "white"
        }

        if( newIndex > -1 )
        {
            lvItems.currentIndex = newIndex
            var currDelegate = lvItems.currentItem
            currDelegate.color = UIMaterials.colorTrueGray
        }
    }

    function getCurrItemInstock()
    {
        if( lvItems.currentIndex === - 1 )
        {
            return 0
        }
        var currItem = lvItems.model.get( lvItems.currentIndex )
        return currItem["num_instock"]
    }

    function getCurrItemQuantity()
    {
        if( lvItems.currentIndex === - 1 )
        {
            return 0
        }
        var currItem = lvItems.model.get( lvItems.currentIndex )
        return currItem["item_num"]
    }

    function increaseItemQuantity()
    {
        if( lvItems.currentIndex === -1 )
        {
            return
        }

        var currItem = lvItems.model.get( lvItems.currentIndex )
        if( currItem["item_num"] < currItem["num_instock"] )
        {
            currItem["item_num"]++
            calculateCost()
        }
    }

    function decreaseItemQuantity()
    {
        if( lvItems.currentIndex === -1 )
        {
            return
        }

        var currItem = lvItems.model.get( lvItems.currentIndex )
        if( currItem["item_num"] > 1 )
        {
            currItem["item_num"]--
            calculateCost()
        }
    }

    function removeCurrItem()
    {
        if( lvItems.currentIndex > -1 )
        {
            for( var i = lvItems.currentIndex+1; i < lvItems.model.count; i++ )
            {
                lvItems.model.setProperty( i, "item_order", i )
            }
            lvItems.model.remove( lvItems.currentIndex )
            if( lvItems.currentIndex >= lvItems.model.count )
            {
                lvItems.currentIndex = lvItems.model.count - 1
            }
            changeHighLight( lvItems.currentIndex )
            itemRemoved()
            calculateCost()
        }
    }

    function calculateCost()
    {
        latestCost = latestDiscount = latestTax = 0
        if( lvItems.model.count > 0 )
        {
            for( var idx = 0; idx < lvItems.model.count; idx++ )
            {
                var item = lvItems.model.get( idx )
                latestCost += Number( item["unit_price"] ) * Number(item["item_num"])
                latestDiscount += Number( item["unit_price"] - item["selling_price"] ) * Number(item["item_num"])
            }
//            latestCost = cost
        }
//        else
//        {
//            latestCost = latestDiscount = latestTax = 0
//        }

        costCalculated( latestCost, latestTax, latestDiscount )
    }    

    function clearList()
    {
        lvItems.model.clear()
        latestCost = latestDiscount = latestTax = 0
    }

    function getList()
    {
        return lvItems.model
    }

    //====================== I. Item Search Box
    // Dropshadow effect
    DropShadow {
        anchors.fill: searchBox
        transparentBorder: true
        color: UIMaterials.colorTrueGray
        horizontalOffset: 4
        verticalOffset: 4
        radius: 4
        source: searchBox
    }

    SearchBox {
        id: searchBox
        width: 0.8772 * parent.width
        height: 0.0847 * parent.height
        y: 0.0212 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        onSearchExecuted: {
            // Send search request to backend if product hasn't been added
            var ret = searchProductInList( searchStr )
            if( ret === false )
            {
                beInvoice.searchForProduct( searchStr )
            }
            else
            {
                itemAdded()
            }

            clearText()
            focus = false
        }
    }


    //===================== II. Item List View
    ListView {
        id: lvItems
        y: 0.1271 * parent.height
        width: parent.width
        height: parent.height - y
        model: itemModel
        clip: true
        cacheBuffer: 50
        visible: (itemModel.count > 0) ? true : false

        //===== II.1 List model
        ListModel {
            id: itemModel
        }

        //===== II.2. Item delegate
        delegate: Rectangle {
            id: itemDelegate
            width: parent.width
            height: 0.0989 * root.height
            color: "white"

            // Order
            Label {
                id: lblOrder
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 0.0643 * parent.width
                height: parent.height
                color: UIMaterials.grayPrimary
                font {
                    pixelSize: Math.floor( 0.5 * width )
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: item_order
            }

            // Product info
            Label {
                id: lblInfo
                anchors.left: lblOrder.right
                anchors.verticalCenter: parent.verticalCenter
                width: 0.5702 * parent.width
                height: parent.height
                color: "black"
                font {
                    pixelSize: lblOrder.font.pixelSize
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: name + " @ " + unit + "\n" + barcode + " @ " + Number(selling_price).toLocaleString(Qt.locale(), "f", 0) + "vnd"

                MouseArea {
                    id: maInfo
                    anchors.fill: parent
                    onClicked: {
                        changeHighLight( index )
                    }
                }
            }

            // Quantity
            Rectangle {
                id: rectQuantity
                anchors.left: lblInfo.right
                anchors.verticalCenter: parent.verticalCenter
                width: 0.1462 * parent.width
                height: parent.height
                color: "transparent"

                TextField {
                    property string prevText

                    id: txtQuantity
                    width: 0.8 * parent.width
                    height: 0.6 * parent.height
                    anchors.centerIn: parent
                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: UIMaterials.grayPrimary
                        border.width: 1
                        radius: 10
                    }
                    inputMethodHints: Qt.ImhDigitsOnly
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: lblOrder.font.pixelSize
                        family: UIMaterials.fontRobotoLight
                    }
                    text: item_num

                    onPressed: {
                        changeHighLight( index )
                        prevText = text
                        focus = true
                    }

//                    onTextEdited: {
//                        text = text.replace( /./g, "" )
//                        var newQuant = parseInt( text, 10 )
//                        console.log( "------> text: " + newQuant )
//                        var item = itemModel.get( index )
//                        if( newQuant <= item["num_instock"] )
//                        {
//                            item["item_num"] = newQuant
//                            calculateCost()
//                        }
//                        else
//                        {
//                            text = text.substring(0, text.length-1)
//                        }
//                    }

                    onAccepted: {
                        var newQuant = parseInt( text, 10 )
                        var item = itemModel.get( index )
                        if( newQuant <= item["num_instock"] )
                        {
                            item["item_num"] = newQuant
                            calculateCost()
                            prevText = text
                        }
                        else
                        {
                            text = prevText
                        }
                        focus = false
                    }
                }
            }

            // Price
            Label {
                id: lblPrice
                anchors.left: rectQuantity.right
                width: 0.2206*parent.width
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                color: "black"
                font {
                    pixelSize: lblOrder.font.pixelSize
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: (item_num * selling_price).toLocaleString( Qt.locale(), 'f', 0 )
            }

            // Separation line
            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: UIMaterials.colorTrueGray
            }
        }

        //===== II.3. List header
        header: Rectangle {
            id: rectHeader
            width: parent.width
            height: 0.0847 * root.height

            Label {
                id: titOrder
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 0.0643 * parent.width
                height: parent.height
                color: UIMaterials.colorTaskBar
                font {
                    pixelSize: Math.floor( 0.5 * width )
                    weight: Font.Bold
                    family: UIMaterials.fontRobotoLight
                }
                text: "#"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: titInfo
                anchors.left: titOrder.right
                anchors.verticalCenter: parent.verticalCenter
                width: 0.5702 * parent.width
                height: parent.height
                color: UIMaterials.colorTaskBar
                font {
                    pixelSize: titOrder.font.pixelSize
                    weight: Font.Bold
                    family: UIMaterials.fontRobotoLight
                }
                text: "Thông tin sản phẩm"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: titQuantity
                anchors.left: titInfo.right
                anchors.verticalCenter: parent.verticalCenter
                width: 0.1462 * parent.width
                height: parent.height
                color: UIMaterials.colorTaskBar
                font {
                    pixelSize: titOrder.font.pixelSize
                    weight: Font.Bold
                    family: UIMaterials.fontRobotoLight
                }
                text: "Số lượng"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: titPrice
                anchors.left: titQuantity.right
                width: 0.2206*parent.width
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                color: UIMaterials.colorTaskBar
                font {
                    pixelSize: titOrder.font.pixelSize
                    weight: Font.Bold
                    family: UIMaterials.fontRobotoLight
                }
                text: "Thành tiền"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                width: parent.width
                height: 3
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: UIMaterials.colorTrueGray
            }
        }
        headerPositioning: ListView.OverlayHeader
    }

}
