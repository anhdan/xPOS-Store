import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root
    implicitWidth: UIMaterials.windowWidth
    implicitHeight: UIMaterials.windowHeight
    color: "white"

    //======================= I. Signal
    signal menuClicked()


    //======================= II. Tab definition
    TabView {
        anchors.fill: parent

        // Tab 1: for updating inventory
        Tab {
            id: tab1
            title: "Phân tích kinh doanh"
            source: "AnalyticsRetailStatus.qml"
            onLoaded: {

            }
        }

        // Tab 2: for reporting on inventory status
        Tab {
            id: tab2
            title: "Phân tích khách hàng"
            source: "InventoryStatus.qml"
            onLoaded: {

            }
        }


        // Tab Delegate definition
        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                id: rectTab
                color: styleData.selected ? UIMaterials.colorNearWhite : UIMaterials.colorTaskBar
                implicitWidth: 0.2930 * root.width
                implicitHeight: 0.0781 * root.height

                Rectangle {
                    width: 2
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    color: UIMaterials.colorNearWhite
                }

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? UIMaterials.colorTaskBar : UIMaterials.colorNearWhite
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        family: UIMaterials.fontRobotoLight
                    }
                }
            }

            tabBar: Rectangle {
                width: root.width
                height: 0.0781 * root.height
                color: UIMaterials.colorTaskBar

                Button {
                    id: btnMenu
                    width: height
                    height: 0.8333 * parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: y

                    background: Rectangle {
                        id: rectBtnMenu
                        anchors.fill: parent
                        color: UIMaterials.colorNearWhite
                        radius: 10

                        Image {
                            id: imgBtnMenu
                            source: "qrc:/resource/imgs/Logo_withName_tr_40.png"
                            anchors.centerIn: parent
                            smooth: true
                        }
                    }

                    onPressed: {
                        rectBtnMenu.opacity = 0.6
                    }

                    onReleased: {
                        rectBtnMenu.opacity = 1
                        menuClicked()
                    }
                }
            }
        }
    }
}
