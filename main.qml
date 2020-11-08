import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.2

import "frontend"

Window {
    id: root
    visible: true
    width: UIMaterials.windowWidth
    height: UIMaterials.windowHeight
    title: qsTr("Ant Thu Ngân")

    onWidthChanged: {
        UIMaterials.fontsizeXS = Math.round(0.0195 * width)
        UIMaterials.fontsizeS = Math.round(0.0215 * width)
        UIMaterials.fontsizeM = Math.round(0.0254 * width)
        UIMaterials.fontsizeL = Math.round(0.0293 * width)
        UIMaterials.fontsizeXL = Math.round(0.0352 * width)
        UIMaterials.fontsizeXXL = Math.round(0.0410 * width)
    }

    //=========== Login Form
    Login {
        id: formLogin
        anchors.fill: parent
        state: "visible"

        onApproved: {
            stack.pop()
            stack.push( formInvoice )
            state = "invisble"

            // restart timer
            UIMaterials.currDateTime = Date()
            UIMaterials.currSecs = 0
            timer.restart()
        }
    }

    //=========== Invoice Composition Form
    InvoiceComposition {
        id: formInvoice
        anchors.fill: parent
        state: "invisible"

        onToInventoryBoard: {
            stack.pop()
            stack.push( formInventory )
        }

        onToLoginBoard: {
            stack.pop()
            stack.push( formLogin )
        }

        onMenuClicked: {
            formMenu.state = "visible"
        }

        onOpacityChanged: {
            enabled = (opacity === 1) ? true : false
        }
    }

    //=========== Inventory Management Form
    InventoryMgmt {
        id: formInventory
        anchors.fill: parent
        state: "visible"

        onToInvoiceBoard: {
            stack.pop()
            stack.push( formInvoice )
        }

        onToLoginBoard: {
            stack.pop()
            stack.push( formLogin )
        }

        onOpacityChanged: {
            enabled = (opacity === 1) ? true : false
        }
    }

    InventoryMgmtForm {
        id: formInventory2
        anchors.fill: parent
        state: "invisible"

        onMenuClicked: {
            formMenu.state = "visible"
        }

        onOpacityChanged: {
            enabled = (opacity === 1) ? true : false
        }
    }

    //============ Advance analytics form
    AdvanceAnalyticsForm {
        id: formAdvanceAnalytics
        anchors.fill: parent
        state: "invisible"

        onMenuClicked: {
            formMenu.state = "visible"
        }

        onOpacityChanged: {
            enabled = (opacity === 1) ? true : false
        }
    }

    //============ GLobal timer
    Timer {
        id: timer
        interval: 30000
        repeat: true
        running: false
        onTriggered: {
            UIMaterials.currDateTime = new Date()
            UIMaterials.currSecs = UIMaterials.currSecs + 60
            UIMaterials.stopWatchTime = Helper.secsToStopWatchString( UIMaterials.currSecs )
        }
    }

    /*****************************************************
     *
     * Put all the above forms to a stack view
     *
     ****************************************************/
    StackView {
        id: stack

        initialItem: formAdvanceAnalytics
        anchors.fill: parent

        pushEnter: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 0
                to: 1
                duration: 400
            }
        }

        pushExit: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 1
                to: 0
                duration: 400
            }
        }

        popEnter: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 0
                to: 1
                duration: 400
            }
        }

        popExit: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 1
                to: 0
                duration: 400
            }
        }
    }


    //================= Menu form
    MenuForm {
        id: formMenu
        anchors.fill: parent
        state: "invisible"

        onExit: {
            if( index === 0 )
            {
                stack.pop()
                stack.push( formInvoice )
            }
            else if( index === 1 )
            {
                stack.pop()
                stack.push( formInventory2 )
            }
            else if( index === 2 )
            {
                stack.pop()
                stack.push( formAdvanceAnalytics )
            }

            state = "invisible"
        }
    }
}
