import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2



ListView {

    property string veryGreen: "#00d315"
    property string mileGray: "#c9c9c9"
    property string numKeyColor: "#607d8b"
    property string borderColor: "white"
    property string itemNormalColor: "white"
    property string itemHighlightColor: "#2196f3"
    property int keySize: 95

    id: root
    model: itemModel
    clip: true
    cacheBuffer: 50
    anchors.fill: parent

    //====================== Signals ============================
    signal itemAdded()
    signal currItemQuantityUpdated()
    signal itemRemoved()


    //====================== Functions ==========================
    function addItem( item )
    {
        var itemFull =  item
        itemFull["_itemCount"] = itemModel.count + 1
        itemModel.append( item )
        var newIndex = itemModel.count - 1
        changeHighLight( newIndex )
        itemAdded()
    }

    function getCurrItemQuantity()
    {
        if( currentIndex == - 1 )
        {
            return 0
        }
        var currItem = itemModel.get( root.currentIndex )
        return currItem["_itemNum"]
    }

    function updateCurrItemQuantity( newQuant )
    {
        if( currentIndex == -1 )
        {
            return
        }

        var currItem = itemModel.get( root.currentIndex )        
        currItem["_itemNum"] = newQuant
        currItemQuantityUpdated()
    }

    function changeHighLight( newIndex )
    {        
        if( root.currentIndex > -1 && currentIndex < itemModel.count )
        {
            var prevDelegate = root.currentItem
            prevDelegate.color = itemNormalColor
        }
        root.currentIndex = newIndex
        var currDelegate = root.currentItem
        currDelegate.color = itemHighlightColor
    }

    function removeCurrItem()
    {
        if( currentIndex > -1 )
        {
            for( var i = currentIndex+1; i < itemModel.count; i++ )
            {
                itemModel.setProperty( i, "_itemCount", i )
            }
            itemModel.remove( currentIndex )
            if( currentIndex >= itemModel.count )
            {
                currentIndex = itemModel.count - 1
            }
            changeHighLight( currentIndex )
            itemRemoved()
        }
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
        border.color: mileGray
        color: "white"
        border.width: 1
        Row {
            id: itemRow
            anchors.fill: parent
            spacing: 0
            Label {
                id: lblCount
                width: parent.width * 45.0 / 760.0
                height: parent.height

                text: _itemCount
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }

            Label {
                id: lblItemInfo
                width: parent.width * 46 / 76
                height: parent.height

                text: _itemInfo
                font.pixelSize: 22
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "black"

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    onClicked: {
//                        var currItem = root.currentItem
//                        currItem.color = "white"
//                        root.currentIndex = index
//                        currItem = root.currentItem
//                        currItem.color = itemHighlightColor
                        changeHighLight( index )
                    }
                }
            }

            TextField {
                id: txtItemNum
                width: parent.width * 105 / 760
                height: parent.height

                text: _itemNum
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
//                activeFocus: true

                background: Rectangle {
                    id: bgrItemNum
                    anchors.fill: parent
                    border.width: 0
                    opacity: 0
                }

                onPressed: {
//                    root.currentIndex = root.indexAt( txtItemNum.x, txtItemNum.y )
                    changeHighLight( index )
                    bgrItemNum.color = itemNormalColor
                    width *= 1.25
                    height *= 1.25
                }

                onEditingFinished: {
                    bgrItemNum.color = itemHighlightColor
                    width *= 0.8
                    height *=- 0.8
                }
            }

            Label {
                id: lblItemPrice
                width: parent.width * 150 / 760
                height: parent.height

                text: _itemPrice
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
        }
    }


    //================= Listview Header ========================
    header: Rectangle {
        id: pnTitleBar
        width: parent.width
        height: 40
        color: mileGray

        Row {
            spacing: 0
            anchors.fill: parent
            Rectangle {
                width: parent.width * 45.0/760.0
                height: 40
                color: "#00000000"
                border.color: borderColor
                border.width: 0.5
                Text {
                    text: qsTr("#")
                    font.pixelSize: 22
                    color: "#000000"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width * 46.0/76
                height: 40
                color: "#00000000"
                border.color: borderColor
                border.width: 0.5
                Text {
                    text: qsTr("Thông tin sản phẩm")
                    font.pixelSize: 22
                    color: "#000000"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width * 105/760
                height: 40
                color: "#00000000"
                border.color: borderColor
                border.width: 0.5
                Text {
                    text: qsTr("Số lượng")
                    font.pixelSize: 22
                    color: "#000000"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width * 15/76
                height: 40
                color: "#00000000"
                border.color: borderColor
                border.width: 1
                Text {
                    text: qsTr("Thành tiền")
                    font.pixelSize: 22
                    color: "#000000"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    headerPositioning: ListView.OverlayHeader


    //================== List item highlight animation ==========
    Component {
        id: highlightBar
        Rectangle {
            width: 760
            height: 70
            color: "#FFFF88"
            opacity: 0.5
            y: root.currentItem.y;
            z: root.currentItem.z + 1;
//            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
        }
    }

//    highlight: highlightBar
    highlightFollowsCurrentItem: false
}
