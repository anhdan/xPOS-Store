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

    ListModel {
        id: itemModel

        ListElement {
            _itemCount: 1
            _itemInfo: "test"
            _itemNum: 10
            _itemPrice: "1000000.00"
        }

        ListElement {
            _itemCount: 2
            _itemInfo: "test2"
            _itemNum: 10
            _itemPrice: "1000000.00"
        }
    }

    delegate: Rectangle {
        width: parent.width
        height: 70
        border.color: mileGray
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

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
                }
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

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
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

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
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

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.currentIndex = index
        }
    }


    header: Rectangle {
        id: pnTitleBar
        width: parent.width
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
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


    Component {
        id: highlight
        Rectangle {
            width: 760; height: 70
            color: "lightsteelblue"
            y: root.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }

    highlight: highlight
    highlightFollowsCurrentItem: false
    focus: true
}
