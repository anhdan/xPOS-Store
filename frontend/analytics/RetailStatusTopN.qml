import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 2.2
import QtCharts 2.0

import ".."
import "../gadgets"

Item {

    id: root

    property real maxLen: 0
    property real minLen: 0

    property color maxColor: UIMaterials.greenDark
    property color minColor: UIMaterials.greenLight
    property var deltaColor: [maxColor.r - minColor.r, maxColor.g - minColor.g, maxColor.b - minColor.b]

    signal prevClicked()

    Component.onCompleted: {
        beAnalytics.topNBestSellersChanged.connect( root.updateBarChart )
    }

    function updateBarChart( _barSeries ) {

        barTop1.visible = false
        barTop2.visible = false
        barTop3.visible = false
        barTop4.visible = false
        barTop5.visible = false
        lblGood.visible = false
        var finalIdx = 0
        if( _barSeries.length <= 0 )
        {
            lblGood.visible = true
            return
        }
        else if( _barSeries.length > 4 )
        {
            finalIdx = 4
        }
        else
        {
            finalIdx = _barSeries.length-1
        }


        var vietnam = Qt.locale()

        var bar =  _barSeries[0]
        var finalBar = _barSeries[finalIdx]
        var deltaLen = barTop1.barLenght - barTop5.barLenght
        var deltaProfit = bar["profit"] - finalBar["profit"]
        var factor = Number( deltaLen / deltaProfit )
        var profitRate

        barTop1.label = bar["name"]
        barTop1.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
        barTop1.barColor = maxColor
        barTop1.labelColor = barTop1.barColor
        barTop1.visible = true

        if(finalIdx >= 1)
        {
            bar =  _barSeries[1]
            profitRate = (bar["profit"] - finalBar["profit"]) / deltaProfit
            barTop2.label = bar["name"]
            barTop2.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
            barTop2.barLenght =  profitRate * deltaLen + barTop5.barLenght
            barTop2.barColor = Qt.rgba(minColor.r + profitRate * deltaColor[0],
                                       minColor.g + profitRate * deltaColor[1],
                                       minColor.b + profitRate * deltaColor[2],
                                       1)
            barTop2.labelColor = barTop2.barColor
            barTop2.visible = true
        }

        if(finalIdx >= 2)
        {
            bar =  _barSeries[2]
            profitRate = (bar["profit"] - finalBar["profit"]) / deltaProfit
            barTop3.label = bar["name"]
            barTop3.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
            barTop3.barLenght =  profitRate * deltaLen + barTop5.barLenght
            barTop3.barColor = Qt.rgba(minColor.r + profitRate * deltaColor[0],
                                       minColor.g + profitRate * deltaColor[1],
                                       minColor.b + profitRate * deltaColor[2],
                                       1)
            barTop3.labelColor = barTop3.barColor
            barTop3.visible = true
        }

        if(finalIdx >= 3)
        {
            bar =  _barSeries[3]
            profitRate = (bar["profit"] - finalBar["profit"]) / deltaProfit
            barTop4.label = bar["name"]
            barTop4.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
            barTop4.barLenght =  profitRate * deltaLen + barTop5.barLenght
            barTop4.barColor = Qt.rgba(minColor.r + profitRate * deltaColor[0],
                                       minColor.g + profitRate * deltaColor[1],
                                       minColor.b + profitRate * deltaColor[2],
                                       1)
            barTop4.labelColor = barTop4.barColor
            barTop4.visible = true
        }

        if(finalIdx >= 4)
        {
            bar =  _barSeries[4]
            profitRate = (bar["profit"] - finalBar["profit"]) / deltaProfit
            barTop5.label = bar["name"]
            barTop5.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
            barTop5.barLenght =  profitRate * deltaLen + barTop5.barLenght
            barTop5.barColor = minColor
            barTop5.labelColor = barTop5.barColor
            barTop5.visible = true
        }
    }

    Label {
        id: titVariationChart
        height: 0.0565 * parent.height
        y: 0.0282 * parent.height
        x: 0.0146 * parent.width

        font{
            pixelSize: UIMaterials.fontsizeM
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        verticalAlignment: Text.AlignVCenter
        color: UIMaterials.grayDark
        text: "Top 5 sản phẩm bán chạy nhất"
    }


    Column {
        anchors.top: titVariationChart.bottom
        anchors.topMargin: 0.0847 * parent.height
        anchors.left: parent.left
        anchors.leftMargin: 0.073 * parent.width
        spacing: barTop1.barHeight / 2


        CustomHorizontalBar {
            id: barTop1
            barLenght: 0.8538 * root.width
            barHeight: 0.0565 * root.height
            barColor: UIMaterials.colorTaskBar
            fontSize: UIMaterials.fontsizeM
            labelColor: "black"
            valueColor: "white"
        }

        CustomHorizontalBar {
            id: barTop2
            barLenght: barTop1.barLenght
            barHeight: barTop1.barHeight
            barColor: barTop1.barColor
            fontSize: barTop1.fontSize
            labelColor: barTop1.labelColor
            valueColor: barTop1.valueColor
        }

        CustomHorizontalBar {
            id: barTop3
            barLenght: barTop1.barLenght
            barHeight: barTop1.barHeight
            barColor: barTop1.barColor
            fontSize: barTop1.fontSize
            labelColor: barTop1.labelColor
            valueColor: barTop1.valueColor
        }

        CustomHorizontalBar {
            id: barTop4
            barLenght: barTop1.barLenght
            barHeight: barTop1.barHeight
            barColor: barTop1.barColor
            fontSize: barTop1.fontSize
            labelColor: barTop1.labelColor
            valueColor: barTop1.valueColor
        }

        CustomHorizontalBar {
            id: barTop5
            barLenght: 0.4386 * root.width
            barHeight: barTop1.barHeight
            barColor: barTop1.barColor
            fontSize: barTop1.fontSize
            labelColor: barTop1.labelColor
            valueColor: barTop1.valueColor
        }

    }


    Label {
        id: lblGood
        anchors.centerIn: parent
        visible: false

        font{
            pixelSize: UIMaterials.fontsizeM
            family: UIMaterials.fontRobotoLight
        }
        verticalAlignment: Text.AlignVCenter
        color: UIMaterials.colorTrueGray
//        opacity: 0.8
        text: "Không có mặt hàng nào được bán trong thời gian này"
    }


    //=========== III. Control buttons
    Button {
        id: btnPrev
        width: 0.0877 * parent.width
        height: width
        anchors.verticalCenter: titVariationChart.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0.0146 * parent.width

        background: Rectangle{
            anchors.fill: parent
            color: "transparent"
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: Math.min( 0.8*parent.width, 0.8*parent.height, UIMaterials.fontsizeM )
                weight: Font.Bold
                family: UIMaterials.solidFont
            }
            color: UIMaterials.colorTrueGray
            text: "\uf060"
        }

        onClicked: {
            prevClicked()
        }
    }


}
