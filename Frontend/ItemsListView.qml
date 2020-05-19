import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2



ListView {

    property string veryGreen: "#00d315"
    property string mileGray: "#c9c9c9"
    property string numKeyColor: "#607d8b"
    property string borderColor: "white"
    property int keySize: 95

    id: root
    model: itemModel
    clip: true
    cacheBuffer: 50
    anchors.fill: parent

    //====================== Signals ============================
    signal itemAdded()

    //====================== Functions ==========================
    function addItem( item )
    {
        var itemFull =  item
        itemFull["_itemCount"] = itemModel.count + 1
        itemModel.append( item )
        root.currentIndex++
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
                    anchors.fill: parent
                    onClicked: root.currentIndex = index
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
            anchors.left: root.left
            color: "#FFFF88"
            opacity: 0.5
            y: root.currentItem.y;
            z: root.currentItem.z + 1;
//            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
        }
    }

    highlight: highlightBar
    highlightFollowsCurrentItem: false
}
