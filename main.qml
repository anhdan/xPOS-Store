import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.2
import "Frontend"

Window {
    id: window
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")        

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
            setVisible( false )
            inventoryForm.enabelInteface()
        }
    }


    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
