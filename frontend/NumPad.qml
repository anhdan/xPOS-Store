import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    height: 3*width/2
    color: "transparent"

    property string keyBgrColor: UIMaterials.colorNearWhite
    property string keyBgrColorPressed: "white"
    property string keyTxtColor: UIMaterials.colorTaskBar

    Column {
        anchors.fill: parent
        spacing: 0.05 * btnOne.width

        Row {
            spacing: 0.05 * btnOne.width

            Button {
                id: btnOne
                width: 0.3226 * root.width
                height: 0.1875 * root.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnOne
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("1")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnOne.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_1 )
                    rectBtnOne.color = keyBgrColor
                }
            }

            Button {
                id: btnTwo
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnTwo
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("2")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnTwo.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_2 )
                    rectBtnTwo.color = keyBgrColor
                }
            }

            Button {
                id: btnThree
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnThree
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("1")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnThree.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_3 )
                    rectBtnThree.color = keyBgrColor
                }
            }
        }


        Row {
            spacing: 0.05 * btnOne.width

            Button {
                id: btnFour
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnFour
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("4")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnFour.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_4 )
                    rectBtnFour.color = keyBgrColor
                }
            }

            Button {
                id: btnFive
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnFive
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("2")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnFive.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_5 )
                    rectBtnFive.color = keyBgrColor
                }
            }

            Button {
                id: btnSix
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnSix
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("6")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnSix.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_6 )
                    rectBtnSix.color = keyBgrColor
                }
            }
        }

        Row {
            spacing: 0.05 * btnOne.width

            Button {
                id: btnSeven
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnSeven
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("7")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnSeven.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_7 )
                    rectBtnSeven.color = keyBgrColor
                }
            }

            Button {
                id: btnEight
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnEight
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("8")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnEight.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_8 )
                    rectBtnEight.color = keyBgrColor
                }
            }

            Button {
                id: btnNine
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnNine
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("9")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnNine.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_9 )
                    rectBtnNine.color = keyBgrColor
                }
            }
        }

        Row {
            spacing: 0.05 * btnOne.width

            Button {
                id: btnDot
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnDot
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr(".")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnDot.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_Period )
                    rectBtnDot.color = keyBgrColor
                }
            }

            Button {
                id: btnZero
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnZero
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("0")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnZero.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_0 )
                    rectBtnZero.color = keyBgrColor
                }
            }

            Button {
                id: btnTripleZero
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnTripleZero
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("000")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnTripleZero.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_0 )
                    keyEmitter.emitKey( Qt.Key_0 )
                    keyEmitter.emitKey( Qt.Key_0 )
                    rectBtnTripleZero.color = keyBgrColor
                }
            }
        }


        Row {
            spacing: 0.0667 * btnBackspace.width

            Button {
                id: btnBackspace
                width: 0.4839 * root.width
                height: 0.1875 * root.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnBackSpace
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: "\uf55a"
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.3 * btnOne.width )
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                onPressed: {
                    btnBackspace.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_Backspace )
                    btnBackspace.color = keyBgrColor
                }
            }

            Button {
                id: btnEnter
                width: 0.4839 * root.width
                height: 0.1875 * root.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnEnter
                    anchors.fill: parent
                    color: keyBgrColor
                }

                Text {
                    text: qsTr("Enter")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: Math.floor( 0.26 * btnOne.width )
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnEnter.color = keyBgrColorPressed
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_Enter )
                    rectBtnEnter.color = keyBgrColor
                }
            }
        }
    }
}
