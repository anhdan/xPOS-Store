import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 2.2
import QtCharts 2.3

import ".."
import "../gadgets"

Item {

    id: root

    property real maxLen: 0
    property real minLen: 0

    signal prevClicked()

    Component.onCompleted: {
        beAnalytics.topNBestSellersChanged.connect( root.updateBarChart )
    }

    function updateBarChart( _barSeries ) {
        var finalIdx = 0
        if( _barSeries.length < 0 )
        {
            return
        }
        else if( _barSeries.length > 4 )
        {
            finalIdx = 4
        }
        else
        {
            finalIdx = _barSeries.length
        }

        var bar =  _barSeries[0]
        var finalBar = _barSeries[finalIdx]
        var deltaProfit = bar["profit"] - finalBar["profit"]
        var deltaWidth = barTop1.barLenght - barTop5.barLenght

        barTop1.label = bar["name"]
        barTop1.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"

        bar =  _barSeries[1]
        barTop2.label = bar["name"]
        barTop2.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
        barTop2.barLenght = (bar["profit"] - bar["profit"]) / deltaProfit * deltaWidth + barTop5.barLenght

        bar =  _barSeries[2]
        barTop3.label = bar["name"]
        barTop3.value = Number(bar["profit"]).toLocaleString( vietnam, 'f', 0 )  + " vnd"
        barTop3.barLenght = (bar["profit"] - bar["profit"]) / deltaProfit * deltaWidth + barTop5.barLenght
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
        spacing: barTop1.barHeight


        CustomHorizontalBar {
            id: barTop1
            barLenght: 0.8538 * root.width
            barHeight: 0.0565 * root.height
            barColor: UIMaterials.colorTaskBar
            fontSize: UIMaterials.fontsizeM
            labelColor: UIMaterials.grayDark
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
