import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

import "."

Item {
    id: root

    property int currentIndex: 0
    property var currentItem: itInvoice

    //========================== Signals and Slots
    signal exit( var index )


    Rectangle {
        id: rectExit
        anchors.fill: parent
        color: UIMaterials.grayDark
        opacity: 0.9

        MouseArea {
            id: maExit
            width: 0.6445 * parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top

            onClicked: {
                exit( -1 )
            }
        }
    }

    //========================== II. Menu Item Area
    Rectangle {
        id: pnMenu
        width: 0.3555 * parent.width
        height: parent.height
        anchors.top: parent.top
        color: "white"


        //------- II.1 Logo
        Image {
            id: imgLogo
            source: "qrc:/resource/imgs/Logo_only_trans_50.png"
            width: 0.1374 * parent.width
            height: width
            x: 0.0412 * parent.width
            y: 0.0391 * parent.height
            smooth: true
        }

        Label {
            id: titLogo
            x: 0.2060 * parent.width
            anchors.verticalCenter: imgLogo.verticalCenter
            font {
                pixelSize: UIMaterials.fontsizeXL
                family: UIMaterials.fontRobotoLight
            }
            color: UIMaterials.colorConcrete
            text: "Ant Thu Ngân"
        }

        //----- II.2 Function menu
        Column {
            spacing: 0
            width: parent.width
            anchors.left: parent.left
            y: 0.1823 * parent.height

            MenuInstance {
                id: itInvoice
                width: parent.width
                height: 0.0911 * root.height
                icon: "\uf571"
                content: "Tạo hóa đơn"

                onSelected: {
                    if( currentIndex === 0 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itInvoice
                        currentIndex = 0
                        exit( 0 )
                    }
                }
            }

            MenuInstance {
                id: itInventory
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf494"
                content: "Quản lý kho hàng"

                onSelected: {
                    if( currentIndex === 1 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itInventory
                        currentIndex = 1
                        exit( 1 )
                    }
                }
            }

            MenuInstance {
                id: itAnalytics
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf200"
                content: "Báo cáo phân tích"

                onSelected: {
                    if( currentIndex === 2 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itAnalytics
                        currentIndex = 2
                        exit( 2 )
                    }
                }
            }

            MenuInstance {
                id: itStrategy
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf51e"
                content: "Chiến lược bán hàng"

                onSelected: {
                    if( currentIndex === 3 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itStrategy
                        currentIndex = 3
                        exit( 3 )
                    }
                }
            }

            MenuInstance {
                id: itOrder
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf07a"
                content: "Đặt hàng nhà cung ứng"

                onSelected: {
                    if( currentIndex === 4 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itOrder
                        currentIndex = 4
                        exit( 4 )
                    }
                }
            }
        }

        // Separation line
        Rectangle {
            width: parent.width
            height: 1
            x: 0
            y: 0.6640 * parent.height
            color: UIMaterials.colorTrueGray
        }

        //----- II.3 Other menu
        Column {
            spacing: 0
            width: parent.width
            anchors.left: parent.left
            y: 0.6901 * parent.height

            MenuInstance {
                id: itAccount
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf007"
                content: "Tài khoản"

                onSelected: {
                    if( currentIndex === 5)
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itAccount
                        currentIndex = 5
                        exit( 5 )
                    }
                }
            }

            MenuInstance {
                id: itSetting
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf013"
                content: "Cài đặt"

                onSelected: {
                    if( currentIndex === 6 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itSetting
                        currentIndex = 6
                        exit( 6 )
                    }
                }
            }

            MenuInstance {
                id: itInstruction
                width: itInvoice.width
                height: itInvoice.height
                icon: "\uf02d"
                content: "Hướng dẫn sử dụng"

                onSelected: {
                    if( currentIndex === 1 )
                    {
                        exit( -1 )
                    }
                    else
                    {
                        currentItem.state = "deselected"
                        state = "selected"
                        currentItem = itInstruction
                        currentIndex = 7
                        exit( 7 )
                    }
                }
            }
        }

    }

    //========================== III. States and transition
    states: [
        State {
            name: "visible"

            PropertyChanges {
                target: pnMenu
                x: 0.6445 * root.width
            }

            PropertyChanges {
                target: rectExit
                opacity: 0.9
            }

            PropertyChanges {
                target: root
                enabled: true
            }
        },

        State {
            name: "invisible"

            PropertyChanges {
                target: pnMenu
                x: root.width
            }

            PropertyChanges {
                target: rectExit
                opacity: 0
            }

            PropertyChanges {
                target: root
                enabled: false
            }
        }
    ]

    transitions: Transition {
        from: "invisible"
        to: "visible"
        reversible: true
        ParallelAnimation {
            NumberAnimation {
                target: pnMenu
                properties: "x"
                duration: 400
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: rectExit
                properties: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
