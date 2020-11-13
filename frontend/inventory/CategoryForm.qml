import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2

import "."
import ".."
import "../gadgets"

Rectangle {
    id: root

    property int currentIndex: -1
    property var currButton: btnCat00

    //====================== I. Signal
    signal categorySelected( var major, var minor, var name )
    signal changesCanceled()

    property var nameArray: ["Thực phẩm", "Đồ uống", "Gia dụng", "Thời trang",
                            "Điện tử", "Văn phòng", "Sức khỏe", "Trẻ em"]
    property var iconSourceArray: [ "qrc:/resource/svgs/food.svg",
                                    "qrc:/resource/svgs/drinks.svg",
                                    "qrc:/resource/svgs/household_appliance.svg",
                                    "qrc:/resource/svgs/fashion.svg",
                                    "qrc:/resource/svgs/electric_devices.svg",
                                    "qrc:/resource/svgs/education.svg",
                                    "qrc:/resource/svgs/health_care.svg",
                                    "qrc:/resource/svgs/baby.svg"]

    function clear()
    {
    }

    function getCategoryString( _majorIdx, _minorIdx )
    {
        return nameArray[_majorIdx]
    }


    //====================== II. Categoriy buttons
    Label {
        id: titCategories
        height: 0.0565 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.0565 * parent.height
        font {
            pixelSize: UIMaterials.fontsizeL
            bold: true
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.grayDark
        text: "Chọn Nhóm Sản Phẩm"
    }

    Column {
        spacing: btnCat00.height / 3
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0.2542 * parent.height

        Row {
            spacing: btnCat00.width / 3

            InconizedButton {
                readonly property int index: 0

                id: btnCat00
                width: 0.1754 * root.width
                height: 0.1695 * root.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[0]
                name: nameArray[0]
                radius: 10
                visible: (name !== "")

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 1

                id: btnCat01
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[1]
                name: nameArray[1]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 2

                id: btnCat02
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[2]
                name: nameArray[2]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 3

                id: btnCat03
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[3]
                name: nameArray[3]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }
        }


        Row {
            spacing: btnCat00.width / 3

            InconizedButton {
                readonly property int index: 4

                id: btnCat10
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[4]
                name: nameArray[4]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 5

                id: btnCat11
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[5]
                name: nameArray[5]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 6

                id: btnCat12
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[6]
                name: nameArray[6]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }

            InconizedButton {
                readonly property int index: 7

                id: btnCat13
                width: btnCat00.width
                height: btnCat00.height
                fgrColor: (index === currentIndex) ? "white" : UIMaterials.grayDark
                bgrColor: (index === currentIndex) ? UIMaterials.colorTrueBlue : UIMaterials.colorNearWhite
                iconSource: iconSourceArray[7]
                name: nameArray[7]
                visible: (name !== "")
                radius: 10

                onPressed: {
                    if( currentIndex !== index )
                    {
                        currentIndex = index
                    }
                }
            }
        }
    }


    //======================= III. Control buttons
    Button {
        id: btnConfirm
        width: 0.2047 * parent.width
        height: 0.0847 * parent.height
        y: 0.8969 * parent.height
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 20
        focusPolicy: Qt.NoFocus
        visible: (currentIndex !== -1)

        background: Rectangle {
            id: rectBtnConfirm
            anchors.fill: parent
            color: UIMaterials.colorTaskBar
            radius: 10
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "white"
            text: "Xác Nhận"
        }

        onPressed: {
            rectBtnConfirm.opacity = 0.6
        }

        onReleased: {
            rectBtnConfirm.opacity = 1
            categorySelected( currentIndex, -1, nameArray[currentIndex] )
        }
    }

    Button {
        id: btnCancel
        width: btnConfirm.width
        height: btnConfirm.height
        anchors.top: btnConfirm.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 20
        focusPolicy: Qt.NoFocus

        background: Rectangle {
            id: rectBtnCancel
            anchors.fill: parent
            color: UIMaterials.colorTrueRed
            radius: 10
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: UIMaterials.fontsizeM
                family: UIMaterials.fontRobotoLight
            }
            color: "white"
            text: "Hủy"
        }

        onPressed: {
            rectBtnCancel.opacity = 0.6
        }

        onReleased: {
            rectBtnCancel.opacity = 1
            changesCanceled()
        }
    }


    Button {
        id: btnBack
        width: 0.0877 * root.width
        height: 0.0847 * root.height
        anchors.verticalCenter: btnConfirm.verticalCenter
        anchors.left: root.left
        anchors.leftMargin: 10
        focusPolicy: Qt.NoFocus

        background: Rectangle {
            id: rectBtnBack
            anchors.fill: parent
            color: "transparent"
        }

        Text {
            id: txtBtnBack
            anchors.centerIn: parent
            font {
                pixelSize: UIMaterials.fontsizeL
                weight: Font.Bold
                family: UIMaterials.solidFont
            }
            color: UIMaterials.grayPrimary
            text: "\uf060"
        }

        onPressed: {
            txtBtnBack.opacity = 0.6
        }

        onReleased: {
            txtBtnBack.opacity = 1
        }
    }

}
