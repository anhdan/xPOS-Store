pragma Singleton
import QtQuick 2.0


QtObject {

    // Timer property
    property var currDateTime
    property var currSecs: 0
    property string stopWatchTime: "00:00"

    property int fontsizeXS: 20
    property int fontsizeS: 22
    property int fontsizeM: 26
    property int fontsizeL: 30
    property int fontsizeXL: 36
    property int fontsizeXXL: 42

    readonly property int windowWidth: 1024
    readonly property int windowHeight: 768

    //============ Update 14/10/2020
    //= Change theme according to new logo
    readonly property color colorNearWhite: "#F2F2F2"
    readonly property color colorConcrete: "#6A7289"
    readonly property color colorTrueBlue: "#2C93F2"
    readonly property color colorTrueRed: "#F44336"
    readonly property color colorTrueYellow: "#FFD700"
    readonly property color colorTrueGray: "#C4C4C4"
    readonly property color colorAntLogo: "#CCAC01"
    readonly property color colorTaskBar: "#2A4863"

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

    readonly property color redPrimary: "#f44336"
    readonly property color redLight: "#ff7961"
    readonly property color redDark: "#ba000d"

    readonly property color bluePrimary: "#2C93F2"
    readonly property color blueLight: "#2C93F2"
    readonly property color blueDark: "#2C93F2"


    //=========== Font
    readonly property int fontSizeLargeLarge: 36
    readonly property int fontSizeLarge: 26
    readonly property int fontSizeMedium: 22
    readonly property int fontSizeSmall: 18
    readonly property int fontSizeTiny: 16


    readonly property FontLoader fontAwesomeRegular: FontLoader {
        source: "qrc:/resource/fonts/FontAwesomeRegular-400.otf"
    }
    readonly property FontLoader fontAwesomeSolid: FontLoader {
        source: "qrc:/resource/fonts/FontAwesomeSolid-900.otf"
    }

    readonly property FontLoader fontLDOpenSansLight: FontLoader {
        source: "qrc:/resource/fonts/Open_Sans/OpenSans-Light.ttf"
    }

    readonly property FontLoader fontLDRobotoLight: FontLoader {
        source: "qrc:/resource/fonts/Roboto/Roboto-Light.ttf"
    }

    readonly property string solidFont: fontAwesomeSolid.name
    readonly property string regularFont: fontAwesomeRegular.name
    readonly property string fontOpenSansLight: fontLDOpenSansLight.name
    readonly property string fontRobotoLight: fontLDRobotoLight.name

    //=========== Icon font
    readonly property string iconSuccess: "\uf058"
    readonly property string iconError: "\uf071"

}
