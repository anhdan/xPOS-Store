pragma Singleton
import QtQuick 2.0


QtObject {

    //============ Application background color ============
    readonly property color appBgrColorPrimary : "#2a4863"
    readonly property color appBgrColorLight: "#577391"
    readonly property color appBgrColorDark: "#002139"


    //============ Text border property ====================
    readonly property color textBorderColorPrimary: "#aa937a"
    readonly property color textBorderColorLight: "#dcc3a9"
    readonly property color textBorderColorDark: "#7a654e"
    readonly property int textBorderRadius: 30


    //=========== Button and title property
    readonly property color goldPrimary: "#FFD700"
    readonly property color goldLight: "#ffff52"
    readonly property color goldDark: "#c7a600"

    readonly property color grayPrimary: "#9e9e9e"
    readonly property color grayLight: "#f5f5f5"
    readonly property color grayDark: "#616161"

    readonly property color greenPrimary: "#4caf50"
    readonly property color greenLight: "#8bc34a"
    readonly property color greenDark: "#388e3c"

    //=========== Font
    readonly property int fontSizeLargeLarge: 36
    readonly property int fontSizeLarge: 26
    readonly property int fontSizeMedium: 22
    readonly property int fontSizeSmall: 18


    readonly property FontLoader fontAwesomeRegular: FontLoader {
        source: "qrc:/resource/fonts/FontAwesomeRegular-400.otf"
    }
    readonly property FontLoader fontAwesomeSolid: FontLoader {
        source: "qrc:/resource/fonts/FontAwesomeSolid-900.otf"
    }
    readonly property string solidFont: fontAwesomeSolid.name
    readonly property string regularFont: fontAwesomeRegular.name

    //=========== Icon font
    readonly property string iconSuccess: "\uf058"
    readonly property string iconError: "\uf071"

}
