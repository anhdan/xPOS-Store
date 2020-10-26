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

    //=========== Login Form
    Login {
        id: formLogin
        anchors.fill: parent

        onApproved: {
            stack.pop()
            stack.push( formInvoice )

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

        onToInventoryBoard: {
            stack.pop()
            stack.push( formInventory )
        }

        onToLoginBoard: {
            stack.pop()
            stack.push( formLogin )
        }
    }

    //=========== Inventory Management Form
    InventoryMgmt {
        id: formInventory
        anchors.fill: parent

        onToInvoiceBoard: {
            stack.pop()
            stack.push( formInvoice )
        }

        onToLoginBoard: {
            stack.pop()
            stack.push( formLogin )
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

        initialItem: formInvoice
        anchors.fill: parent

        pushEnter: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        pushExit: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        popEnter: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        popExit: Transition {
            PropertyAnimation
            {
                properties: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }


    //=================== Input panel
//    InputPanel {
//        id: inputPanel
//        z: 99
//        x: 0
//        y: root.height
//        width: root.width

//        states: State {
//            name: "visible"
//            when: inputPanel.active
//            PropertyChanges {
//                target: inputPanel
//                y: root.height - inputPanel.height
//            }
//        }
//        transitions: Transition {
//            from: ""
//            to: "visible"
//            reversible: true
//            ParallelAnimation {
//                NumberAnimation {
//                    properties: "y"
//                    duration: 250
//                    easing.type: Easing.InOutQuad
//                }
//            }
//        }
//    }
}
