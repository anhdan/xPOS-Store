import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.2

import "frontend"
import "frontend/gadgets"
import "frontend/invoice"
import "frontend/inventory"
import "frontend/analytics"

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
        width: root.width
        height: root.height
        x: 0
        y: 0
        state: "visible"

        onApproved: {
            stack.pop()
            stack.push( formInvoice )
            state = "invisble"
        }
    }

    //=========== Invoice Composition Form
    InvoiceComposition {
        id: formInvoice
        width: root.width
        height: root.height
        x: 0
        y: 0
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
    InventoryMgmtForm {
        id: formInventory2
        width: root.width
        height: root.height
        x: 0
        y: 0
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
        width: root.width
        height: root.height
        x: 0
        y: 0
        state: "invisible"

        onMenuClicked: {
            formMenu.state = "visible"
        }

        onOpacityChanged: {
            enabled = (opacity === 1) ? true : false
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
