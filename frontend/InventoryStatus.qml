import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2

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

        KPICard {
            id: kpiKindsNum
            width: 0.7941 * parent.width
            height: 0.1695 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0.0565 * parent.height
            kpiName: "Tổng số mặt hàng"
            kpiValue: "0"
        }

        KPICard {
            id: kpiTotalValue
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiKindsNum.bottom
            anchors.topMargin: kpiKindsNum.anchors.topMargin
            kpiName: "Tổng giá trị hàng hóa"
            kpiValue: "0 vnd"
        }

        KPICard {
            id: kpiExpectedProfit
            width: kpiKindsNum.width
            height: kpiKindsNum.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: kpiTotalValue.bottom
            anchors.topMargin: kpiKindsNum.anchors.topMargin
            kpiName: "Lợi nhuận ước tính"
            kpiValue: "0 vnd"
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
            kpiValue: "0 vnd"
        }
    }

    //========================= II. In-depth info panel
    TabView {
        id: tvInfo
        width: 0.668 * parent.width
        height: parent.height
        x: pnControl.width
        y: 0

        property int numSoonOOS: 0
        property int numSoonExpired: 0
        property int numSlowSelling: 0
        property var tabNameArr: ["Sắp hết hàng", "Sắp hết hạn", "Hàng tồn kho"]
        property var tabColorArr: [UIMaterials.greenPrimary, UIMaterials.colorAntLogo, UIMaterials.colorTrueRed]

        //----- II.1. Tab displaying soon out-of-stock products
        Tab {
            id: tabSoonOOS
            title: tvInfo.numSoonOOS.toString()
            source: "InventoryOOSList.qml"
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
                implicitHeight: 0.1130 * tvInfo.height
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
