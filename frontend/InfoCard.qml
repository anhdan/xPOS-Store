import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Column {
    spacing: 0
    clip: true

    property int titleFontSize: UIMaterials.fontsizeS
    property alias titleHeight: lblTitle.height
    property string titleColor: UIMaterials.colorTaskBar
    property alias titleText: lblTitle.text
    property int infoFontsize: UIMaterials.fontsizeM
    property int infoHeight: lblInfo.height
    property string infoColor: UIMaterials.colorTaskBar
    property alias infoText: lblInfo.text
    property alias inputMethodHints: lblInfo.inputMethodHints

    property alias cardWidth: lblTitle.width
    property bool isBold: false
    property alias bgrColor: rectInfo.color
    property alias editable: lblInfo.enabled
    property alias placeholderText: lblInfo.placeholderText
    property bool underline: false
    property bool isCurrency: false
    property bool isNumber: false
    property bool isCalendar: false

    signal editStarted()
    signal editFinished()


    Label {
        id: lblTitle
        width: parent.width
        font {
            pixelSize: titleFontSize
            family: UIMaterials.fontRobotoLight
        }
        color: titleColor
        opacity: 0.6
        text: ""
    }


    TextField {
        id: lblInfo
        anchors.left: lblTitle.left
        anchors.leftMargin: -10
        width: parent.width
        font {
            pixelSize: infoFontsize
            bold: isBold
            family: UIMaterials.fontRobotoLight
        }
        inputMethodHints: (isCurrency || isNumber) ? Qt.ImhDialableCharactersOnly
                                                   : Qt.ImhNone
        activeFocusOnPress: (isCalendar) ? false : true

        background: Rectangle {
            id: rectInfo
            anchors.fill: parent
            color: "transparent"
        }

        leftInset: 0
        color: infoColor
        placeholderTextColor: UIMaterials.colorTrueGray
        text: ""
        placeholderText: ""
        enabled: true

        onPressed: {
            editStarted()
        }

        onAccepted: {
            editFinished()
        }

        onTextEdited: {
            if( isCurrency )
            {
                var orgText = text.replace( /,/g, "" )
                orgText = orgText.replace( "vnd", "" )
                var num = parseInt(orgText, 10)
                if( isNaN(num) === false )
                {
                    var vietnam = Qt.locale()
                    text = Number(num).toLocaleString( vietnam, 'f', 0 )  + " vnd"
                    cursorPosition = length - 4
                }
                else
                {
                    text = ""
                }
            }
        }

        onFocusChanged: {
            if( focus === true )
            {
                lblTitle.font.bold = true
            }
            else
            {
                lblTitle.font.bold = false
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: underline ? UIMaterials.colorNearWhite : "transparent"
    }

    onEditStarted: {
        lblTitle.font.bold = true
    }

    onEditFinished: {
        lblTitle.font.bold = false
    }

}
