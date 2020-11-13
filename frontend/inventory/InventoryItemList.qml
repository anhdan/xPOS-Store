import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import ".."
import "../gadgets"

ListView {
    id: root
    model: itemModel
    clip: true
    cacheBuffer: 100

    property int unsavedItemsNum: 0
    property alias count: itemModel.count

    //====================== I. Signals
    signal selected( var item )


    //====================== II. Slots
    function find( _barcode )
    {
        for( var i = 0; i < itemModel.count; i++ )
        {
            var item = itemModel.get( i )
            if( item["barcode"] === _barcode )
            {
                return i
            }
        }
        return -1
    }

    function updateCurrItem( item )
    {
        var currItem = itemModel.get( currentIndex )
        if( currItem["barcode"] === "" )
        {
            currItem["barcode"] = item["barocde"]
        }
    }

    function select( _index )
    {
        if( _index !== root.currentIndex )
        {
            root.currentIndex = _index
            selected( itemModel.get(_index) )   /// ? Need deep copy ?
        }
    }

    function append( _item )
    {
        itemModel.append( Helper.deepCopy( _item ) )
    }

    function set( _index, _item )
    {
        if( _index < itemModel.count )
        {
            itemModel.set( _index, Helper.deepCopy( _item ) )
        }
    }


    ListModel {
        id: itemModel
    }

    delegate: Rectangle {
        id: itemDelegate
        width: parent.width
        height: 0.1042 * UIMaterials.windowHeight
        color: (index === root.currentIndex) ? "white" : "transparent"

        // Completion indicator LED
        Rectangle {
            id: rectStatus
            width: 0.25 * parent.height
            height: width
            x: 0.0441 * parent.width
            anchors.verticalCenter: parent.verticalCenter
            radius: 0.5 * width
            color: completed ? UIMaterials.greenPrimary : UIMaterials.colorTrueGray
        }

        // Short product info
        Column {
            spacing: 0
            x: 0.1471 * parent.width
            anchors.top: parent.top
            width: parent.width - x
            height: parent.height

            Label {
                id: lblBarcode
                width: parent.width
                height: parent.height / 2
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: (barcode !== "") ? barcode : sku
                color: "black"
            }

            Label {
                id: lblName
                width: parent.width
                height: parent.height / 2
                font {
                    pixelSize: UIMaterials.fontsizeS
                    family: UIMaterials.fontRobotoLight
                }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: (name !== "") ? name : "Chưa có tên sản phẩm"
                color: "black"
            }
        }


        // Separation line
        Rectangle {
            width: parent.width
            height: 1
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: UIMaterials.colorTrueGray
        }

        // Mouse area
        MouseArea {
            anchors.fill: parent

            onPressed: {
                if( index != currentIndex )
                {
                    currentIndex = index
                    selected( itemModel.get(index) )   /// ? Need deep copy ?
                }
            }
        }
    }


    header: Column {
        spacing: 0
        width: parent.width
        height: 0.1042 * UIMaterials.windowHeight

        Label {
            id: titItemsNumber
            width: parent.width
            height: 0.5 * parent.height
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.grayDark
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Danh sách chờ xử lý"
        }

        Label {
            id: lblItemsNumber
            width: parent.width
            height: titItemsNumber.height
            font {
                pixelSize: UIMaterials.fontsizeM
                weight: Font.Bold
                family: UIMaterials.fontRobotoLight
            }
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            text: unsavedItemsNum.toString() + " sản phẩm"
        }

        // Separation line
        Rectangle {
            id: rectLine
            width: parent.width
            height: 1
            color: UIMaterials.colorTrueGray
        }
    }
    headerPositioning: ListView.OverlayHeader
}
