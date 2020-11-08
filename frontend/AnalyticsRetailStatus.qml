import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2
import QtCharts 2.0

import "."
Item {
    id: root
    //========================= I. KPI panel
    Rectangle {
        id: pnControl
        width: 0.332 * parent.width
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.colorNearWhite


        Row {
            id: rowDuration
            spacing: 0
            anchors.left: kpiKindsNum.left
            y: 0.0282 * parent.height
            width: kpiKindsNum.width

            Button {
                id : btnBackward
                width: 0.1176 * pnControl.width
                height: 0.0565 * pnControl.height

                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }

                Text {
                    id: txtBtnBackward
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                    color: UIMaterials.colorTrueGray
                    text: "\uf053"
                }

                onPressed: {
                    txtBtnBackward.opacity = 0.6
                }

                onReleased: {
                    txtBtnBackward.opacity = 1
                }
            }

            Label {
                id: lblCalendar
                width: parent.width - 2* btnBackward.width
                height: btnBackward.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: UIMaterials.colorTaskBar
                text: "Tháng này"

                MouseArea {
                    id: maLblCalendar
                    anchors.fill: parent

                    onClicked: {
                        if( durationPicker.visible === false )
                        {
                            maDurationPicker.state = "visible"
                            pnControl.enabled = false
                            tvInfo.enabled = false
                        }
                    }
                }
            }

            Button {
                id : btnForward
                width: btnBackward.width
                height: btnBackward.height

                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }

                Text {
                    id: txtBtnForward
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                    color: UIMaterials.colorTrueGray
                    text: "\uf054"
                }

                onPressed: {
                    txtBtnForward.opacity = 0.6
                }

                onReleased: {
                    txtBtnForward.opacity = 1
                }
            }
        }

        KPICard {
            id: kpiKindsNum
            width: 0.7941 * parent.width
            height: 0.1695 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0.1271 * parent.height
            kpiName: "Tổng doanh thu"
            kpiValue: "0"
        }

        KPICard {
            id: kpiTotalValue
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiKindsNum.bottom
            anchors.topMargin: 0.0565 * parent.height
            kpiName: "Tổng lợi nhuận ròng"
            kpiValue: "0 vnd"
        }

        KPICard {
            id: kpiExpectedProfit
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiTotalValue.bottom
            anchors.topMargin: kpiTotalValue.anchors.topMargin
            kpiName: "Tổng chiết khấu/KM"
            kpiValue: "0 vnd"
        }

        KPICard {
            id: kpiTotalLost
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiExpectedProfit.bottom
            anchors.topMargin: kpiTotalValue.anchors.topMargin
            kpiName: "Tổng giá trị thất thoát"
            valueFontColor: UIMaterials.colorTrueRed
            kpiValue: "0 vnd"
        }
    }

    MouseArea {
        id: maDurationPicker
        anchors.fill: parent
        z: tvInfo.z + 1

        TimeDurationPicker {
            id: durationPicker
            width: 0.7324 * root.width
            height: 0.4520 * root.height
            x: rowDuration.x
            y: rowDuration.y
        }
        enabled: false
        visible: false

        states: State {
            name: "visible"
            PropertyChanges {
                target: maDurationPicker
                visible: true
                enabled: true
            }
        }

        onClicked: {
            state = ""
            pnControl.enabled = true
            tvInfo.enabled = true
        }
    }

    //========================= II. In-depth info panel
    Rectangle {
        id: pnDetails
        width: root.width - pnControl.width
        height: root.height
        anchors.left: pnControl.right
        anchors.top: root.top
        color: "white"

        //----- II.1. Bar chart showing income/profit variation
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


        //----- II.2. Pie chart showing profit/income sharing
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

    }

}
