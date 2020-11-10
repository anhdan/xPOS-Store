import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 2.2
import QtCharts 2.0

import ".."

Item {
    id: root

    signal nextClicked()
    signal prevClicked()

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
//            anchors.topMargin: 0.0141 * parent.height
        color: "transparent"

        ChartView {
//                title: "Bar series"
            anchors.fill: parent
            legend.alignment: Qt.AlignBottom
            antialiasing: true

            BarSeries {
                id: mySeries
                axisX: BarCategoryAxis { categories: ["2007", "2008", "2009", "2010", "2011", "2012" ] }
                BarSet { label: "Bob"; values: [2, 2, 3, 4, 5, 6] }
                BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
                BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
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
        text: "Tỷ lệ lợi nhuận theo loại mặt hàng"
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
                id: pieOuter
                size: 0.8
                holeSize: 0.5
                PieSlice {
                    id: slice;
                    label: "Thời trang 30%";
                    labelFont {
                        pixelSize: UIMaterials.fontsizeM
                        weight: Font.Bold
                        family: UIMaterials.fontCategories
                    }
                    labelColor: color
                    value: 19511;
                    color: "#99CA53"

                    onPressed: {
                        exploded = true
                    }

                    onReleased: {
                        exploded = false
                    }
                }

                PieSlice {
                    label: "Thực phẩm 20%";
                    labelFont {
                        pixelSize: UIMaterials.fontsizeM
                        weight: Font.Bold
                        family: UIMaterials.fontCategories
                    }
                    labelColor: color
                    value: 11105;
                    color: "#209FDF"

                    onPressed: {
                        exploded = true
                    }

                    onReleased: {
                        exploded = false
                    }
                }

                PieSlice {
                    label: "Đồ gia dụng 50%";
                    labelFont {
                        pixelSize: UIMaterials.fontsizeM
                        weight: Font.Bold
                        family: UIMaterials.fontCategories
                    }
                    labelColor: color
                    value: 9352;
                    color: "#F6A625"

                    onPressed: {
                        exploded = true
                    }

                    onReleased: {
                        exploded = false
                    }
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
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorTrueGray
            text: "\uf061"
        }

        onClicked: {
            nextClicked()
        }
    }

    Button {
        id: btnPrev
        width: btnNext.width
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
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorTrueGray
            text: "\uf060"
        }

        onClicked: {
            nextClicked()
        }
    }

}
