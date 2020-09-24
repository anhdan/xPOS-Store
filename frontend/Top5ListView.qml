import QtQml 2.2
import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import "."


ListView {
    id: root
    clip: true
    cacheBuffer: 10

    //===== Properties
    property var delegateFontSize: UIMaterials.fontSizeSmall
    property string delegateFontColor: "black"
    property string delegateBgrColor: UIMaterials.grayLight
    property var headerFontSize: UIMaterials.fontSizeSmall
    property string headerFontColor: "black"
    property string headerBgrColor: UIMaterials.grayPrimary
    property string categoryText: "Doanh thu(đ)"

    //===== 2. Listview Delegate
    delegate: Rectangle {
        id: itemDelegate
        width: parent.width
        height: delegateFontSize * 20/9
        color: delegateBgrColor

        Row {
            id: rowItem
            anchors.fill: parent
            spacing: 0

            Label {
                property bool isName: true

                id: lblName
                width: parent.width * 28/43
                height: parent.height
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: delegateFontSize
                color: delegateFontColor
                text: modelData["desc"]

                MouseArea {
                    id: maLblName
                    anchors.fill: parent
                    onPressed: {
                        lblName.text = (lblName.isName === true) ? modelData["product_barcode"] : modelData["desc"]
                        lblName.isName = !lblName.isName
                        focus = true
                    }

                    onFocusChanged: {
                        if( focus === false )
                        {
                            lblName.text = modelData["desc"]
                            lblName.isName = true
                        }
                    }
                }
            }

            Label {
                id: lblInfo
                width: parent.width * 15/43
                height: parent.height
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: delegateFontSize
                color: delegateFontColor
                text: (categoryText === "Doanh thu(đ)") ? modelData["total_price"]
                                                        : (categoryText === "Lợi nhuận(đ)") ? modelData["total_profit"]
                                                                                            : modelData["quantity"]
            }
        }
    }

    //===== 3. Listview header
    header: Row {
        id: rowHeader
        width: parent.width
        height: headerFontSize * 2.5
        spacing: 0

        Rectangle {
            id: rectHeadName
            width: parent.width * 28/43
            height: parent.height
            color: headerBgrColor
            border.color: delegateBgrColor
            border.width: 1
            Text {
                anchors.centerIn: parent
                font.pixelSize: headerFontSize
                color: headerFontColor
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Tên sản phẩm")
            }
        }

        ComboBox {
            id: cbxHeadInfo
            width: parent.width * 15/43
            height: parent.height
            model: ["Số lượng", "Doanh thu(đ)", "Lợi nhuận(đ)"]
            font.pixelSize: headerFontSize

            indicator: Canvas {
                id: canvas
                x: cbxHeadInfo.width - width - cbxHeadInfo.rightPadding
                y: cbxHeadInfo.topPadding + (cbxHeadInfo.availableHeight - height) / 2
                width: 15
                height: 9
                contextType: "2d"

                Connections {
                    target: cbxHeadInfo
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = "#ffffff"
                    context.fill();
                }                
            }

            background: Rectangle {
                id: rectCbxHeadInfo
                anchors.fill: parent
                color: headerBgrColor
                border.color: delegateBgrColor
                border.width: 1
            }

            onCurrentTextChanged: {
                root.categoryText = currentText
            }
        }
    }
    headerPositioning: ListView.OverlayHeader
}
