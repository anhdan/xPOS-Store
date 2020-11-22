import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 2.2
import QtCharts 2.3

import ".."

Item {
    id: root

    signal nextClicked()

    property var barsRevenue
    property var piesRevenue

    Component.onCompleted: {
        beAnalytics.barSeriesChanged.connect( root.updateBarChart )
        beAnalytics.pieSeriesChanged.connect( root.updatePieChart )
    }

    function updateBarChart( _barSeries ) {
        barsRevenue = _barSeries
        barsets.clear();
        xAxis.clear()
        var labels = []
        var values = []
        yAxis.max = 0
        for( var i = 0; i < _barSeries.length; i++ )
        {
            var bar = _barSeries[i];
            labels[i] = bar["label"]
            values[i] =  bar["revenue"]
            if( values[i] > yAxis.max )
            {
                yAxis.max = values[i]
            }
        }
        xAxis.categories = labels
        yAxis.max = Math.round(yAxis.max * 1.2 / 100000) * 100000
        barsets.append( "revenue", values )
    }


    function updatePieChart( _pieSeries )
    {
        piesRevenue = _pieSeries
        pieOuter.clear();
        console.log( "---> _pieSeries.length = ",  _pieSeries.length )
        for( var i = 0; i < _pieSeries.length; i++ )
        {
            var pie = _pieSeries[i]
            console.log( "label = ", pie["label"], "  |  revenue = ", pie["revenue"])
            pieOuter.append( pie["label"], pie["revenue"] )
        }
    }

    //============ I. Bar chart showing income/profit variation
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
        text: "Biến động doanh thu"
    }

    Rectangle {
        id: pnBarchart
        width: parent.width - 2 * titVariationChart.x
        height: 0.4237 * parent.height
        anchors.left: titVariationChart.left
        anchors.top: titVariationChart.bottom
        color: "transparent"

        ChartView {
//                title: "Bar series"
            anchors.fill: parent
            legend.alignment: Qt.AlignBottom
            legend.visible: false
            antialiasing: true

            BarSeries {
                id: barsets
                axisX: BarCategoryAxis {
                    id: xAxis
                }

                axisY: ValueAxis {
                    id: yAxis
                    min: 0
                    max: 500000
                    tickInterval: 100000
                }
            }
        }
    }


    //=========== II. Pie chart showing profit/income sharing
    Label {
        id: titProfitShare
        height: titVariationChart.height
        anchors.top: pnBarchart.bottom
        anchors.topMargin: 0.0242 * parent.height
        anchors.left: titVariationChart.left

        font{
            pixelSize: UIMaterials.fontsizeM
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        verticalAlignment: Text.AlignVCenter
        color: UIMaterials.grayDark
        text: "Tỷ lệ doanh thu theo loại mặt hàng"
    }

    Rectangle {
        id: pnPieChart
        width: pnBarchart.width
        height: 0.3955 * parent.height
        anchors.left: titVariationChart.left
        anchors.top: titProfitShare.bottom
        anchors.topMargin: 0.0141 * parent.height
        color: "transparent"

        ChartView {
            id: chart
            anchors.fill: parent
    //        title: "Production costs"
            legend.visible: true
            legend.alignment: Qt.AlignRight
            legend.font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            legend.markerShape: Legend.MarkerShapeCircle

            antialiasing: true

            PieSeries {
                property var previousSlice
                property string previousLabel

                id: pieOuter
                size: 0.8
                holeSize: 0.5

                onClicked: {
                    if( previousSlice !== undefined )
                    {
                        previousSlice.exploded = false
                        previousSlice.labelVisible = false
                        previousSlice.label = previousLabel
                    }

                    previousLabel = slice.label
                    previousSlice = slice
                    slice.label = Number(slice.percentage * 100).toFixed(2) + "%" + slice.label
                    slice.labelVisible = true
                    slice.labelPosition = PieSlice.LabelOutside
                    slice.exploded = true

                }
            }
        }

//            Component.onCompleted: {
//                // Set the common slice properties dynamically for convenience
//                for (var i = 0; i < pieOuter.count; i++) {
//                    pieOuter.at(i).labelPosition = PieSlice.LabelOutside;
//                    pieOuter.at(i).labelVisible = true;
//                    pieOuter.at(i).borderWidth = 3;
//                }
//            }

    }

    //=========== III. Control buttons
    Button {
        id: btnNext
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
            text: "\uf061"
        }

        onClicked: {
            nextClicked()
        }
    }

}
