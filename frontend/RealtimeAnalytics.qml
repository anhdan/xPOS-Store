import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2

import "."

Rectangle {
    id: root

    property var todayShift: xpBackend.qTodayShift
    property var yesterdayShift: xpBackend.qYesterdayShift  

    Label {
        id: titRAName
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: colIndicators.left
        font.pixelSize: UIMaterials.fontSizeLarge
        color: UIMaterials.grayLight
        text: "Chỉ số kinh doanh trong ngày"
    }

    //===== 1. Indicator panel
    Column {
        id: colIndicators
        anchors.top: titRAName.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        Row {
            width: root.width * 11/12
            height: indRevenue.height
            spacing: width - 2*indRevenue.width

            IndicatorCard {
                id: indRevenue
                width: root.width * 5/12
                height: 0.14*root.height
                color: UIMaterials.grayLight
                name: "DOANH THU"
                value: todayShift["total_earning"]
                compareSign: "\uf783"
                compareValue: (yesterdayShift["total_earning"] > 0) ? (todayShift["total_earnning"] / yesterdayShift["total_earning"] * 100)
                                                                    : 100
            }

            IndicatorCard {
                id: indProfit
                width: indRevenue.width
                height: indRevenue.height
                color: indRevenue.color
                name: "LỢI NHUẬN"
                value: todayShift["total_profit"]
                compareSign: "\uf783"
                compareValue: (yesterdayShift["total_profit"] > 0) ? (todayShift["total_profit"] / yesterdayShift["total_profit"] * 100)
                                                                   : 100
            }
        }

        Row {
            width: root.width * 11/12
            height: indRevenue.height
            spacing: width - 2*indRevenue.width

            IndicatorCard {
                id: indCustomers
                width: indRevenue.width
                height: indRevenue.height
                color: indRevenue.color
                name: "LƯỢNG KHÁCH"
                value: todayShift["total_customers"]
                isCurrency: false
                compareSign: "\uf783"
                compareValue: (yesterdayShift["total_customers"] > 0) ? (todayShift["total_customers"] * 1.0 / yesterdayShift["total_customers"] * 100)
                                                                      : 100
            }

            IndicatorCard {
                id: indPoint
                width: indRevenue.width
                height: indRevenue.height
                color: indRevenue.color
                name: "ĐIỂM THƯỞNG"
                value: todayShift["total_rewarded_points"]
                isCurrency: false
                compareSign: "\uf53a"
                compareValue: (yesterdayShift["total_rewarded_points"] > 0) ? (todayShift["total_rewarded_points"] * 1.0 / yesterdayShift["total_rewarded_points"] * 100)
                                                                            : 100
                compareSuffix: "%"
                showColorIndicator: false
            }
        }
    }




    //===== 2. Top 5 best sellers panel
    Rectangle {
        id: pnTop5
        width: colIndicators.width
        height: root.height * 4/9
        anchors.top: colIndicators.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: UIMaterials.grayLight

        Label {
            id: titTop5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pixelSize: UIMaterials.fontSizeMedium
            color: UIMaterials.grayDark
            text: "TOP 5 SẢN PHẨM BÁN CHẠY"
        }

        Top5ListView {
            id: lvTop5
            width: parent.width * 43/44
            height: parent.height * 3/4
            anchors.top: titTop5.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            model: xpBackend.top5Model
        }

        Label {
            id: lblTop5Overall
            anchors.top: lvTop5.bottom
            anchors.topMargin: 10
            anchors.right: lvTop5.right
            font.pixelSize: UIMaterials.fontSizeSmall
            color: UIMaterials.greenPrimary
            horizontalAlignment: Text.AlignRight
            text: "50% Tổng DT"
        }
    }

    //===== 3. Workshift timer
    Row {
        id: rowTimer
        width: colIndicators.width
        anchors.top: pnTop5.bottom
        anchors.topMargin: 20
        anchors.left: colIndicators.left

        Label {
            width: parent.width/2
            font.pixelSize: UIMaterials.fontSizeSmall
            color: "black"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: "Thời gian ca làm việc:"
        }

        Label {
            width: parent.width/2
            font.pixelSize: UIMaterials.fontSizeSmall
            color: "black"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: UIMaterials.stopWatchTime
        }
    }
    
    //===== 4. Footer
    Row {
        id: rowFooter
        width: colIndicators.width
        anchors.bottom: root.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: root.horizontalCenter

        Rectangle {
            width: parent.width/2
            height: lblCalendarSign.height
            color: "transparent"
            Label {
                id: lblCalendarSign
                anchors.top: parent.top
                anchors.left: parent.left
                color: UIMaterials.grayDark
                font {
                    pixelSize: UIMaterials.fontSizeSmall
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                text: "\uf783"
            }
            Label {
                anchors.verticalCenter: lblCalendarSign.verticalCenter
                anchors.left: lblCalendarSign.right
                anchors.leftMargin: 5
                color: UIMaterials.grayDark
                font.pixelSize: UIMaterials.fontSizeTiny
                text: "So với ngày hôm trước"
            }
        }

        Rectangle {
            width: parent.width/2
            height: lblPortionSign.height
            color: "transparent"
            Label {
                id: lblPortionSign
                anchors.top: parent.top
                anchors.right: lblPortionNote.left
                anchors.rightMargin: 5
                color: UIMaterials.grayDark
                font {
                    pixelSize: UIMaterials.fontSizeSmall
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                text: "\uf783"
            }
            Label {
                id: lblPortionNote
                anchors.verticalCenter: lblPortionSign.verticalCenter
                anchors.right: parent.right
                color: UIMaterials.grayDark
                font.pixelSize: UIMaterials.fontSizeTiny
                text: "Phần trăm trên doanh thu"
            }
        }
    }
}
