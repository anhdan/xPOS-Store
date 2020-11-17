import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import ".."

Rectangle {
    id: root
    color: UIMaterials.colorTrueGray
    opacity: 0.95
    radius: 10

    property int currPeriodIndex: -1
    property string periodString: ""
    property var startDate: new Date()
    property var endDate: new Date()
    property bool startSelected: false
    property bool endSelected: false

    function next()
    {
        if( endDate <= new Date() )
        {
            var days = Math.ceil( (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) );
            startDate = new Date(endDate)
            endDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + days )
            periodString = startDate.toLocaleDateString("dd/mm") + " - " + endDate.toLocaleDateString("dd/mm")
            picked( startDate, endDate )
        }
    }

    function back()
    {
        var days = Math.ceil( (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) );
        endDate = new Date(startDate)
        startDate = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate() - days )
        if( currPeriodIndex !== -1 )
            currPeriodIndex = -1

        if( currPeriodIndex === btnToday.index )
        {
            periodString = "Hôm qua"
        }
        else if(currPeriodIndex === btnThisWeek.index )
        {
            periodString = "Tuần trước"
        }
        else if(currPeriodIndex === btnThisMonth.index )
        {
            periodString = "Tháng trước"
        }
        else if(currPeriodIndex === btnThisQuater.index )
        {
            periodString = "Quý trước"
        }
        else if(currPeriodIndex === btnThisYear.index )
        {
            periodString = "Năm trước"
        }
        else
        {
            periodString = startDate.toLocaleDateString("dd/mm") + " - " + endDate.toLocaleDateString("dd/mm")
        }

        picked( startDate, endDate )
    }

    Component.onCompleted: {
        btnToday.clicked()
    }

    //================ Signals
    signal picked( var _startDate, var _endDate )

    //================ I. Quick time picker
    Column {
        id: columnQuickPicker

        spacing: 0
        width: 0.1867 * parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top

        Button {
            id: btnToday
            readonly property int index: 0

            width: parent.width
            height: 0.1875 * parent.height

            background: Rectangle {
                anchors.fill: parent
                color: (currPeriodIndex === btnToday.index) ? "#388fc6" : "transparent"
            }

            Text {
                id: txtBtnToday
                anchors.left: parent.left
                anchors.leftMargin: 0.0133 * parent.width
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: (currPeriodIndex === btnToday.index) ? "white" : "black"
                text: "Hôm nay"
            }

            onClicked: {
                root.currPeriodIndex = btnToday.index
                periodString = txtBtnToday.text
                endDate = new Date()
                startDate = new Date()
                endDate.setDate( startDate.getDate() + 1 )
                picked( startDate, endDate )
            }
        }

        Button {
            id: btnThisWeek
            readonly property int index: 1

            width: parent.width
            height: btnToday.height

            background: Rectangle {
                anchors.fill: parent
                color: (currPeriodIndex === btnThisWeek.index) ? "#388fc6" : "transparent"
            }

            Text {
                id: txtBtnThisWeek
                anchors.left: parent.left
                anchors.leftMargin: 0.0133 * parent.width
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: (currPeriodIndex === btnThisWeek.index) ? "white" : "black"
                text: "Tuần này"
            }

            onClicked: {
                root.currPeriodIndex = btnThisWeek.index
                periodString = txtBtnThisWeek.text

                var today = new Date()
                startDate = new Date()
                endDate = new Date()
                var day = today.getDay()
                startDate.setDate( today.getDate() + 1 - day )
                endDate.setDate( today.getDate() + 8 - day )
                picked( startDate, endDate )
            }
        }

        Button {
            id: btnThisMonth
            readonly property int index: 2

            width: parent.width
            height: btnToday.height

            background: Rectangle {
                anchors.fill: parent
                color: (currPeriodIndex === btnThisMonth.index) ? "#388fc6" : "transparent"
            }

            Text {
                id: txtBtnThisMonth
                anchors.left: parent.left
                anchors.leftMargin: 0.0133 * parent.width
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: (currPeriodIndex === btnThisMonth.index) ? "white" : "black"
                text: "Tháng này"
            }

            onClicked: {
                root.currPeriodIndex = btnThisMonth.index
                periodString = txtBtnThisMonth.text

                var today = new Date()
                startDate = new Date( today.getFullYear(), today.getMonth(), 1 )
                endDate = new Date( today.getFullYear(), today.getMonth() + 1, 1 )
                picked( startDate, endDate )
            }
        }

        Button {
            id: btnThisQuater
            readonly property int index: 3

            width: parent.width
            height: btnToday.height

            background: Rectangle {
                anchors.fill: parent
                color: (currPeriodIndex === btnThisQuater.index) ? "#388fc6" : "transparent"
            }

            Text {
                id: txtBtnThisQuater
                anchors.left: parent.left
                anchors.leftMargin: 0.0133 * parent.width
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: (currPeriodIndex === btnThisQuater.index) ? "white" : "black"
                text: "Quý này"
            }

            onClicked: {
                root.currPeriodIndex = btnThisQuater.index
                periodString = txtBtnThisQuater.text

                var today = new Date()
                var quater = Math.floor( today.getMonth() / 3 )
                startDate = new Date( today.getFullYear(), quater * 3, 1 )
                endDate = new Date( today.getFullYear(), (quater+1) * 3, 1 )
                picked( startDate, endDate )
            }
        }

        Button {
            id: btnThisYear
            readonly property int index: 4

            width: parent.width
            height: btnToday.height

            background: Rectangle {
                anchors.fill: parent
                color: (currPeriodIndex === btnThisYear.index) ? "#388fc6" : "transparent"
            }

            Text {
                id: txtBtnThisYear
                anchors.left: parent.left
                anchors.leftMargin: 0.0133 * parent.width
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: (currPeriodIndex === btnThisYear.index) ? "white" : "black"
                text: "Năm nay"
            }

            onClicked: {
                root.currPeriodIndex = btnThisYear.index
                periodString = txtBtnThisYear.text

                var today = new Date()
                var quater = Math.floor( today.getMonth() / 3 )
                startDate = new Date( today.getFullYear(), 0, 1 )
                endDate = new Date( today.getFullYear() + 1, 0, 1 )
                picked( startDate, endDate )
            }
        }
    }


    //=============== II. Start Date picker by calendar
    Calendar {
        id: calendarStart
        anchors.top: parent.top
        anchors.left: columnQuickPicker.right
        anchors.leftMargin: 0.0267 * root.width
        width: 0.875 * height
        height: parent.height
        frameVisible: false

        style: CalendarStyle {
            id: startStyle
            gridVisible: false
            background: Rectangle {
                id: startBgr
                anchors.fill: parent
                color: "transparent"
            }

            navigationBar: Rectangle {
                width: parent.width
                height: Math.round(dateStartText.font.pixelSize * 2.184)
                color:"transparent"

                Button {
                    id : btnBackward
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

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
                        color: UIMaterials.grayDark
                        text: "\uf053"
                    }

                    onClicked: startStyle.control.showPreviousMonth()
                }

                Label {
                    id: dateStartText
                    text: styleData.title
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        family: UIMaterials.fontRobotoLight
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        maximumDate: new Date(2050, 0, 1)
        minimumDate: new Date(2020, 0, 1)
        selectedDate: startDate

        onClicked: {
            startDate = selectedDate
            if( endSelected )
            {
                startSelected = endSelected = false
                picked( startDate, endDate )
            }
            else
            {
                startSelected = true
            }
        }
    }

    //=============== II. End Date picker by calendar
    Calendar {
        id: calendarEnd
        anchors.top: parent.top
        anchors.left: calendarStart.right
        anchors.leftMargin: calendarStart.anchors.leftMargin
        width: calendarStart.width
        height: parent.height
        frameVisible: false

        style: CalendarStyle {
            id: endStyle
            gridVisible: false
            background: Rectangle {
                id: endBgr
                anchors.fill: parent
                color: "transparent"
            }

            navigationBar: Rectangle {
                width: parent.width
                height: Math.round(dateEndText.font.pixelSize * 2.184)
                color:"transparent"

                Button {
                    id : btnForward
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

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
                        color: UIMaterials.grayDark
                        text: "\uf054"
                    }

                    onClicked: endStyle.control.showNextMonth()
                }

                Label {
                    id: dateEndText
                    text: styleData.title
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    font {
                        pixelSize: UIMaterials.fontsizeM
                        family: UIMaterials.fontRobotoLight
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        maximumDate: new Date(2050, 0, 1)
        minimumDate: new Date(2020, 0, 1)

        onClicked: {
            endDate = selectedDate
            if( startSelected )
            {
                startSelected = endSelected = false
                picked( startDate, endDate )
            }
            else
            {
                endSelected = true
            }
        }
    }
}
