import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

Rectangle {
    id: root
    implicitHeight: 60

    property alias placeholderText: txtSearchInput.placeholderText
    property alias text: txtSearchInput.text
    property alias textColor: txtSearchInput.color
    property alias backgroundColor: root.color
    property bool clearTextOnPressed: true

    //===== I. Signals & slots
    signal searchExecuted( var searchStr )

    function clearText()
    {
        txtSearchInput.text = ""
        txtSearchInput.focus = false
    }

    //===== II. Search excution button
    Button {
        id: btnSearch
        width: Math.min( parent.height, 60 )
        height: Math.min( parent.height, 60 )
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        focusPolicy: Qt.NoFocus

        background: Rectangle {
            id: rectBtnSearch
            anchors.fill: parent
            color: "transparent"
        }

        Text {
            text: "\uf002"
            anchors.centerIn: parent
            color: UIMaterials.grayDark
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font {
                pixelSize: Math.floor( 0.5 * parent.width )
                weight: Font.Bold
                family: UIMaterials.solidFont
            }
        }

        onPressed: {
            rectBtnSearch.color = UIMaterials.colorTrueGray
        }

        onReleased: {
            rectBtnSearch.color = "transparent"
            searchExecuted( txtSearchInput.text )
        }
    }

    //===== III. Search input text
    TextField {
        id: txtSearchInput
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: btnSearch.right
        anchors.right: parent.right

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }

        placeholderText: "Nhập từ khóa cần tìm ..."
        font {
            pixelSize: Math.floor( 0.4333 * btnSearch.width )
            family: UIMaterials.fontRobotoLight
        }
        color: UIMaterials.colorTaskBar

        onPressed: {
            if( clearTextOnPressed )
            {
                text = ""
            }
        }

        onAccepted: {
            focus = false
            searchExecuted( text )
        }
    }

}
