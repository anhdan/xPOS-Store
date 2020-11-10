import QtQuick 2.0
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
        z: pnDetails.z + 1

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
        clip: true

        RetailStatusRevenue {
            id: revenuePage
            width: parent.width
            height: parent.height
            x: 0
            y: 0

            onNextClicked: {
                stack.pop()
                stack.push( profitPage )
            }
        }

        RetailStatusProfit {
            id: profitPage
            width: parent.width
            height: parent.height
            x: parent.width
            y: 0

            onPrevClicked: {
                stack.pop()
                stack.push( revenuePage )
            }
        }

        StackView {
            id: stack
            initialItem: revenuePage
            anchors.fill: parent

            pushEnter: Transition {
                PropertyAnimation
                {
                    properties: "x"
                    from: pnDetails.width
                    to: 0
                    duration: 400
                }
            }

            pushExit: Transition {
                PropertyAnimation
                {
                    properties: "x"
                    from: 0
                    to: -pnDetails.width
                    duration: 400
                }
            }

            popEnter: Transition {
                PropertyAnimation
                {
                    properties: "x"
                    from: -pnDetails.width
                    to: 0
                    duration: 400
                }
            }

            popExit: Transition {
                PropertyAnimation
                {
                    properties: "x"
                    from: 0
                    to: pnDetails.width
                    duration: 400
                }
            }
        }
    }

}
