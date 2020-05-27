import QtQuick 2.9
import QtQuick.Window 2.2
//import QtQuick.VirtualKeyboard 2.2
import QtQuick.Controls 2.2
import "Frontend"

Window {
    id: window
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")

    Invoice {
        id: invoiceForm
        anchors.fill: parent
        visible: false
        onSigEnableInterface:
        {
            setVisible( true )
        }
    }

    Inventory {
        id: inventoryForm
        anchors.fill: parent
        visible: false
        onSigEnableInterface:
        {
            setVisible( true )
        }
    }


    Signin
    {
        id: signInForm
        anchors.fill: parent
        visible: true
        onSigAuthenticated:
        {
            stack.pop()
            stack.push( invoiceForm )
        }
    }


    StackView {
        id: stack

        initialItem: invoiceForm
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

//    InputPanel {
//        id: inputPanel
//        z: 99
//        x: 0
//        y: window.height
//        width: window.width

//        states: State {
//            name: "visible"
//            when: inputPanel.active
//            PropertyChanges {
//                target: inputPanel
//                y: window.height - inputPanel.height
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
