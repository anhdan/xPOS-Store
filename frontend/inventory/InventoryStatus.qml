import QtQuick 2.4
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2
import QtCharts 2.0

import "."
import ".."
import "../gadgets"

Item {
    id: root
    clip: true

    function updatePiechart()
    {
        // Clear legend content
        lvLabel.model.clear()

        if( beInventory.kpi["total_values"] === 0 )
            return

        var categories = beInventory.kpi["categories"]
        console.log( "-------> categories: ", categories )
        var categoryNames = beInventory.kpi["category_names"]
        var values = beInventory.kpi["values"]
        var profit = beInventory.kpi["profit"]

        var accValue = 0.0
        var othersValue = 0.0
        for( var i = 0; i < categories.length; i++ )
        {
            if( accValue / beInventory.kpi["total_values"] > 0.9 )
            {
                othersValue = beInventory.kpi["total_values"] - accValue
                break
            }

            if( categories[i] !== -1 )
            {
                accValue += values[i]
                var share = values[i] / beInventory.kpi["total_values"] * 100
                pieOuter.append( UIMaterials.iconCategories[categories[i]], values[i] )
                legendModel.append({"legend_sign": UIMaterials.iconCategories[categories[i]],
                                    "legend_color": "black",
                                    "legend_name": share.toFixed(2) + " %  " + UIMaterials.categoryNames[categories[i]]
                                   })
            }
            else {
                othersValue += values[i]
            }
        }

        if( othersValue > 0 )
        {
            pieOuter.append( "...", othersValue )
            legendModel.append({"legend_sign": "...",
                                "legend_color": "black",
                                "legend_name": (othersValue * 100 / beInventory.kpi["total_values"]).toFixed(2) + " %  Các mặt hàng khác"
                               })
        }
    }

    //========================= I. KPI panel
    Rectangle {
        id: pnControl
        width: 0.332 * parent.width
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.colorNearWhite

        KPICard {
            id: kpiKindsNum
            width: 0.7941 * parent.width
            height: 0.1695 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0.0565 * parent.height
            kpiName: "Tổng số mặt hàng"
            kpiValue: beInventory.kpi["types_num"].toString()
        }

        KPICard {
            id: kpiTotalValue
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiKindsNum.bottom
            anchors.topMargin: kpiKindsNum.anchors.topMargin
            kpiName: "Tổng giá trị hàng hóa"
            kpiValue: Number(beInventory.kpi["total_values"]).toLocaleString( Qt.locale(), "f", 0 )
        }

        KPICard {
            id: kpiExpectedProfit
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiTotalValue.bottom
            anchors.topMargin: kpiKindsNum.anchors.topMargin
            kpiName: "Lợi nhuận ước tính"
            kpiValue: Number(beInventory.kpi["total_profit"]).toLocaleString( Qt.locale(), "f", 0 )
        }

        KPICard {
            id: kpiTotalLost
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiExpectedProfit.bottom
            anchors.topMargin: kpiKindsNum.anchors.topMargin
            kpiName: "Tổng giá trị thất thoát"
            valueFontColor: UIMaterials.colorTrueRed
            kpiValue: Number(beInventory.kpi["total_lost"]).toLocaleString( Qt.locale(), "f", 0 )
        }
    }

    //========================= Pie chart showing the share value of product categpries
    Rectangle {
        id: pieChart
        width: 0.668 * parent.width
        height: parent.height / 3
        anchors.top: parent.top
        anchors.left: pnControl.right
        color: "white"

        Label {
            id: titPieChart
            y: 0.0282 * parent.height
            x: 0.0146 * parent.width

            font{
                pixelSize: UIMaterials.fontsizeM
                bold: true
                family: UIMaterials.fontRobotoLight
            }
            verticalAlignment: Text.AlignVCenter
            color: UIMaterials.grayDark
            text: "Tỷ lệ giá trị các loại mặt hàng"
        }

        ChartView {
            id: chart
            height: parent.height - titPieChart.y - titPieChart.height
            width: parent.width / 2
            anchors.left: parent.left
            anchors.top: titPieChart.bottom
            legend.visible: false
            antialiasing: true

            PieSeries {
                id: pieOuter
                size: 0.9
                holeSize: 0.5

                onSliceAdded: {
                    slice.labelFont.pixelSize = UIMaterials.fontsizeXS
                    slice.labelFont.weight = Font.Bold
                    slice.labelFont.family = UIMaterials.fontCategories
                    slice.labelPosition = PieSlice.LabelInsideHorizontal;
                    slice.labelColor = UIMaterials.colorNearWhite
                    slice.labelVisible = true;
                }
            }
        }

        Component.onCompleted: {
            updatePiechart()
            beInventory.kpiChanged.connect( root.updatePiechart )
        }

//        Rectangle {
//            anchors.top: chart.top
//            anchors.left: chart.right
//            width: parent.width/2
//            height: chart.height
//            color: "white"

            ListView {
                id: lvLabel
                anchors.top: chart.top
                anchors.topMargin: 60
                anchors.left: chart.right
                width: parent.width / 2
                implicitHeight: chart.height
                model: legendModel

                ListModel {
                    id: legendModel
                }

                delegate: Row {
                    spacing: 10
                    Label {
                        id: lblCategorySign
                        width: UIMaterials.fontsizeXL
                        height: UIMaterials.fontsizeXL
                        font {
                            pixelSize: UIMaterials.fontsizeS
                            weight: Font.Bold
                            family: UIMaterials.fontCategories
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: pieOuter.at(index).color
                        text: legend_sign
                    }

                    Label {
                        id: lblCategoryName
                        height: lblCategorySign.height
                        font {
                            pixelSize: UIMaterials.fontsizeS
                            family: UIMaterials.fontRobotoLight
                        }
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        text: legend_name
                    }
                }

            }
//        }
    }

//    Component.onCompleted: {
//        // Set the common slice properties dynamically for convenience
//        for (var i = 0; i < pieOuter.count; i++) {
//            pieOuter.at(i).labelPosition = PieSlice.LabelOutside;
//            pieOuter.at(i).labelVisible = true;
//            pieOuter.at(i).borderWidth = 3;
//        }
//    }

    //========================= II. In-depth info panel
    TabView {
        id: tvInfo
        width: 0.668 * parent.width
        height: parent.height * 2 / 3
        x: pnControl.width
        y: pieChart.height

        property int numSoonOOS: 0
        property int numSoonExpired: 0
        property int numSlowSelling: 0
        property var tabNameArr: ["Sắp hết hàng", "Sắp hết hạn", "Hàng tồn kho"]
        property var tabColorArr: [UIMaterials.greenPrimary, UIMaterials.colorAntLogo, UIMaterials.colorTrueRed]

        //----- II.1. Tab displaying soon out-of-stock products
        Tab {
            id: tabSoonOOS
            title: ""
            source: "InventoryOOSList.qml"
            onLoaded: {
                title = beInventory.oosModel.length
            }
        }

        //----- II.2. Tab displaying soon date expired products
        Tab {
            id: tabSoonExpire
            title: tvInfo.numSoonExpired.toString()
            source: "InventoryExpiredList.qml"
        }

        //----- II.3. Tab displaying slow selling products
        Tab {
            id: tabSlowSelling
            title: tvInfo.numSlowSelling.toString()
            source: "InventorySlowSellingList.qml"
        }

        // Tab header style
        style: TabViewStyle {
            frameOverlap: 0
            tab: Rectangle {
                id: rectTab
                implicitWidth: tvInfo.width / 3
                implicitHeight: 0.1695 * tvInfo.height
                color: "white"
                opacity: 0.4
                state: styleData.selected ? "selected" : ""

                Label {
                    id: lblTabName
                    width: parent.width
                    height: parent.height / 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: UIMaterials.fontsizeS
                        family: UIMaterials.fontRobotoLight
                    }
                    color: UIMaterials.grayDark
                    text: tvInfo.tabNameArr[styleData.index]
                }

                Label {
                    id: lblTabValue
                    width: parent.width
                    height: parent.height / 2
                    anchors.top: lblTabName.bottom
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        bold: true
                        family: UIMaterials.fontRobotoLight
                    }
                    color: "black"
                    text: styleData.title
                }

                Rectangle {
                    id: rectUnderline
                    width: parent.width / 2
                    height: 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: "transparent"
                }

                states: State {
                    name: "selected"
                    PropertyChanges {
                        target: lblTabName
                        font.pixelSize: UIMaterials.fontsizeM
                        color: tvInfo.tabColorArr[tvInfo.currentIndex]
                    }

                    PropertyChanges {
                        target: lblTabValue
                        font.pixelSize: UIMaterials.fontsizeXL
                        color: tvInfo.tabColorArr[tvInfo.currentIndex]
                    }

                    PropertyChanges {
                        target: rectUnderline
                        color: tvInfo.tabColorArr[tvInfo.currentIndex]
                    }

                    PropertyChanges {
                        target: rectTab
                        opacity: 1
                    }
                }

                transitions: Transition {
                    from: ""
                    to: "selected"
                    reversible: true
                    ParallelAnimation {
                        NumberAnimation {
                            target: lblTabName
                            properties: "font.pixelSize"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: lblTabValue
                            properties: "font.pixelSize"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: rectTab
                            properties: "opacity"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            tabBar: Rectangle {
                width: tvInfo.width
                height: 0.1130 * tvInfo.height
                color: "white"
            }
        }
    }
}
