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
    //========================= I. In-depth info panel
    Rectangle {
        id: pnInfo
        width: 0.668 * parent.width
        height: parent.height
        x: pnControl.width
        y: 0
        color: "white"
    }
}
