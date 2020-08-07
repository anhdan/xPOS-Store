import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    height: 3*width/2
    color: "transparent"

    property string keyBgrColor: UIMaterials.grayPrimary
    property string keyBgrColorSecondary: UIMaterials.grayLight
    property string keyTxtColor: "white"
    property int keyTxtFontSize: UIMaterials.fontSizeLargeLarge
    readonly property alias keySize: btnOne.width

    Column {
        anchors.fill: parent
        spacing: 15

        Row {
            spacing: 15

            Button {
                id: btnOne
                width: 3*root.width/10
                height: 3*root.width/10
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnOne
                    anchors.fill: parent
                    color: keyBgrColor
                    radius: 5
                }

                Text {
                    text: qsTr("1")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnOne.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("2")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnTwo.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("3")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnThree.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_3 )
                    rectBtnThree.color = keyBgrColor
                }
            }
        }


        Row {
            spacing: 15
            Button {
                id: btnFour
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnFour
                    anchors.fill: parent
                    color: keyBgrColor
                    radius: 5
                }

                Text {
                    text: qsTr("4")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnFour.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("5")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnFive.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("6")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnSix.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_6 )
                    rectBtnSix.color = keyBgrColor
                }
            }
        }

        Row {
            spacing: 15
            Button {
                id: btnSeven
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnSeven
                    anchors.fill: parent
                    color: keyBgrColor
                    radius: 5
                }

                Text {
                    text: qsTr("7")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnSeven.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("8")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnEight.color = keyBgrColorSecondary
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
                    radius: 5
                }

                Text {
                    text: qsTr("9")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnNine.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_9 )
                    rectBtnNine.color = keyBgrColor
                }
            }
        }

        Row {
            spacing: 15
            Button {
                id: btnClear
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnClear
                    anchors.fill: parent
                    color: keyBgrColor
                    radius: 5
                }

                Text {
                    text: qsTr("C")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnClear.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_Backspace )
                    rectBtnClear.color = keyBgrColor
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
                    radius: 5
                }

                Text {
                    text: qsTr("0")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: keyTxtFontSize
                }

                onPressed: {
                    rectBtnZero.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_0 )
                    rectBtnZero.color = keyBgrColor
                }
            }

            Button {
                id: btnEnter
                width: btnOne.width
                height: btnOne.height
                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    id: rectBtnEnter
                    anchors.fill: parent
                    color: keyBgrColor
                    radius: 5
                }

                Text {
                    text: qsTr("Nhập")
                    anchors.centerIn: parent
                    color: keyTxtColor
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: UIMaterials.fontSizeLarge
                }

                onPressed: {
                    rectBtnEnter.color = keyBgrColorSecondary
                }

                onReleased: {
                    keyEmitter.emitKey( Qt.Key_Enter )
                    rectBtnEnter.color = keyBgrColor
                }
            }
        }       
    }
}
