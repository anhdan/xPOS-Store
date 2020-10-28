import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.2

import "."

Rectangle {
    id: root
    implicitWidth: UIMaterials.windowWidth
    implicitHeight: UIMaterials.windowHeight

    property var currProduct
    property var updateProduct
    state: "invisible"

    //====================== Signal and slot definition
    function showProduct( product )
    {
        var vietnam = Qt.locale( )
        txtName.text = product["name"]
        txtName.enabled = true
        txtDesc.text = product["desc"]
        txtDesc.enabled = true
        txtUnit.text = product["unit"]
        txtUnit.enabled = true
        txtUnitPrice.text = Number(product["unit_price"]).toLocaleString( vietnam, "f", 0 )
        if( (product["discount_price"] > 0) && (product["discount_price"] < product["unit_price"]) )
        {
            txtDiscountPrice.text = lblCurrentPrice.text = Number(product["discount_price"]).toLocaleString( vietnam, "f", 0 )
            txtDiscountStart.text = product["discount_start"]
            txtDiscountEnd.text = product["discount_end"]
            txtDiscountPrice.enabled = txtDiscountStart.enabled = txtDiscountEnd.enabled = false

            btnDiscount.state = "active"
        }
        else
        {
            lblCurrentPrice.text = Number(product["unit_price"]).toLocaleString( vietnam, "f", 0 )
            txtDiscountPrice.text = "None"
            txtDiscountStart.text = txtDiscountEnd.text = "None"
            txtDiscountPrice.enabled = txtDiscountStart.enabled = txtDiscountEnd.enabled = true

            btnDiscount.state = "inactive"
        }
        lblNumInstock.text = product["num_instock"]
        lblNumSold.text = product["num_sold"]
        lblRatioDisqualified.text =
                Number(product["num_disqualified"] / (product["num_instock"] + product["num_sold"] + product["num_disqualified"]) * 100).toFixed(2) + "%"
    }


    signal productInfoChanged()
    signal productFound( var product )
    signal productNotFound()
    signal changesUndone()

    signal toInvoiceBoard()
    signal toCustomerBoard()
    signal toAnalyticsBoard()
    signal toSetupBoard()
    signal toLoginBoard()


    //=================== Signal - Slot connection
    Component.onCompleted: {
        xpBackend.sigProductFound.connect( root.productFound )
        xpBackend.sigProductNotFound.connect( root.productNotFound )
    }

    onOpacityChanged: {
        if( opacity === 1 )
        {
            enabled = true
        }
        else
        {
            enabled = false
        }
    }


    //================== Signal Handling
    onProductFound: {
        if( enabled === true )
        {
            updateProduct = Helper.deepCopy( product )
            currProduct = Helper.deepCopy( product )
            showProduct( product )
        }
    }

    onProductNotFound: {
        if( enabled === true )
        {
            updateProduct = Helper.createDefaultProduct()
            updateProduct["barcode"] = txtBarcode.text
            currProduct = Helper.createDefaultProduct()
            currProduct["barcode"] = txtBarcode.text
            showProduct( currProduct )
            if( noti.state === "visible" )
            {
                noti.state = "invisible"
            }
            noti.showNoti( "Sản phẩm chưa tồn tại. Mời bạn điền thông tin!", "error" )
            noti.state = "visible"
        }
    }

    onProductInfoChanged: {
        showProduct( updateProduct )
        btnSave.enabled = true
        btnUndo.enabled = true
    }


    //=================== Input panel
    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: root.height
        width: root.width
        active: false

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: root.height - inputPanel.height
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

    //=================== 1. Panel of basic product infomation
    Rectangle {
        id: pnBasic
        width: 1*parent.width / 3
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.appBgrColorPrimary

        TextField {
            id: txtBarcode
            anchors.top: parent.top
            anchors.topMargin: 30
//            anchors.left: parent.left
//            anchors.leftMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.85
            font.pixelSize: UIMaterials.fontSizeMedium
            height: UIMaterials.fontSizeMedium * 2
            placeholderText: "Nhập mã sản phẩm..."
            color: "white"
            inputMethodHints: Qt.ImhDialableCharactersOnly
            background: Rectangle {
                anchors.fill: parent
                color: UIMaterials.appBgrColorLight
                radius: 10
            }

            onPressed: {
                text = ""
            }

            // Invoke product searching by input barcode
            onAccepted: {
                inputPanel.active = false
                console.log( "+++++++++> text = " + text )
                var ret = xpBackend.searchForProduct( text )
            }
        }


        Button {
            id: btnKeyBoard
            anchors.top: txtBarcode.top
            anchors.right: txtBarcode.right
            height: txtBarcode.height
            width: 1.5 * txtBarcode.height
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            focusPolicy: Qt.NoFocus

            Text {
                id: txtBtnKeyBoard
                text: "\uf11c"
                anchors.centerIn: parent
                color: UIMaterials.grayPrimary
                font {
                    pixelSize: 50;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onPressed: {
                txtBtnKeyBoard.color = "white"
                txtBarcode.text = ""
                txtBarcode.focus = true
                inputPanel.active = true
            }
            onReleased: {
                txtBtnKeyBoard.color = UIMaterials.grayPrimary
            }
        }

        Label {
            id: titInfo
            anchors.top: txtBarcode.bottom
            anchors.topMargin: 30
            anchors.left: txtBarcode.left
            text: "Tên sản phẩm"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: UIMaterials.grayPrimary
        }

        TextField {
            id: txtName
            anchors.top: titInfo.bottom
            anchors.topMargin: 5
            anchors.left: txtBarcode.left
            width: txtBarcode.width
            font.pixelSize: UIMaterials.fontSizeMedium
            color: "white"
            text: ""
            enabled: false

            background: Rectangle {
                id: rectTxtName
                anchors.fill: parent
                color: "transparent"
            }

            onPressed: {
                rectTxtName.color = "white"
                color = "black"
                readOnly = false
                focus = true
                cursorPosition = length
                inputPanel.active = true
            }

            onAccepted: {
                updateProduct["name"] = text
                rectTxtName.color = "transparent"
                color = "white"
                readOnly = true
                focus = false
                inputPanel.active = false
                productInfoChanged()
            }
        }

        Label {
            id: titUnit
            anchors.top: txtName.bottom
            anchors.topMargin: 30
            anchors.left: txtBarcode.left
            text: "Đơn vị"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: UIMaterials.grayPrimary
        }

        TextField {
            id: txtUnit
            anchors.top: titUnit.bottom
            anchors.topMargin: 5
            anchors.left: txtBarcode.left
            width: txtBarcode.width
            font.pixelSize: UIMaterials.fontSizeMedium
            color: "white"
            text: ""
            enabled: false

            background: Rectangle {
                id: rectTxtUnit
                anchors.fill: parent
                color: "transparent"
            }

            onPressed: {
                rectTxtUnit.color = "white"
                color = "black"
                readOnly = false
                focus = true
                cursorPosition = length
                inputPanel.active = true
            }

            onAccepted: {
                updateProduct["unit"] = text
                rectTxtUnit.color = "transparent"
                color = "white"
                readOnly = true
                focus = false
                inputPanel.active = false
                productInfoChanged()
            }
        }

        Label {
            id: titDesc
            anchors.top: txtUnit.bottom
            anchors.topMargin: 30
            anchors.left: txtBarcode.left
            text: "Mô tả"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: UIMaterials.grayPrimary
        }

        TextField {
            id: txtDesc
            anchors.top: titDesc.bottom
            anchors.topMargin: 5
            anchors.left: txtBarcode.left
            width: txtBarcode.width
            height: 4 * UIMaterials.fontSizeMedium
            font.pixelSize: UIMaterials.fontSizeMedium
            color: "white"
            text: ""
            enabled: false
            wrapMode: Text.Wrap
//            readOnly: true

            background: Rectangle {
                id: rectTxtDesc
                anchors.fill: parent
                color: "transparent"
            }

            onPressed: {
                rectTxtDesc.color = "white"
                color = "black"
                readOnly = false
                focus = true
                cursorPosition = length
                inputPanel.active = true
            }

            onAccepted: {
                updateProduct["desc"] = text
                rectTxtDesc.color = "transparent"
                color = "white"
                readOnly = true
                focus = false
                inputPanel.active = false
                aniBasicDownTransition.from = -root.height / 6
                aniBasicDownTransition.start()
                productInfoChanged()
            }

            onFocusChanged: {
                if( focus === false )
                {
                    accepted()
                }
                else
                {
                    aniBasicUpTransition.to = -root.height / 6
                    aniBasicUpTransition.start()
                }
            }
        }

        Label {
            id: titUnitPrice
            anchors.top: txtDesc.bottom
            anchors.topMargin: 30
            anchors.left: txtBarcode.left
            text: "Đơn giá (vnđ)"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: UIMaterials.grayPrimary
        }

        TextField {
            id: txtUnitPrice
            anchors.top: titUnitPrice.bottom
            anchors.topMargin: 5
            anchors.left: txtBarcode.left
            width: txtBarcode.width / 2
            font.pixelSize: UIMaterials.fontSizeMedium
            color: "white"
            text: ""
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
            enabled: false
            inputMethodHints: Qt.ImhDialableCharactersOnly

            background: Rectangle {
                id: rectTxtUnitPrice
                anchors.fill: parent
                color: "transparent"
            }

            onAccepted: {                
                updateProduct["unit_price"] = parseInt( text.replace(/,/g, ""), 10 ) * 1.0
                rectTxtUnitPrice.color = "transparent"
                color = "white"
                enabled = false
                focus = false
                rectBtnUnitPrice.color = UIMaterials.grayPrimary
                btnUnitPrice.enabled = true
                inputPanel.active = false
                aniBasicDownTransition.from = -root.height / 3
                aniBasicDownTransition.start()

                productInfoChanged()
            }

            onTextEdited: {
                var orgText = text.replace( /,/g, "" )
                var num = parseInt(orgText, 10)
                if( isNaN(num) === false )
                {
                    var vietnam = Qt.locale( )
                    text = Number(num).toLocaleString( vietnam, "f", 0 )
                    cursorPosition = length
                }
                else
                {
                    text = ""
                }
            }

            onFocusChanged:
            {
                if( focus === false )
                {
                    accepted()
                }
                else
                {
                    aniBasicUpTransition.to = -root.height / 3
                    aniBasicUpTransition.start()
                }
            }
        }

        Button{
            id: btnUnitPrice
            anchors.bottom: txtUnitPrice.bottom
            anchors.right: txtBarcode.right
            width: Math.max(txtBarcode.width / 4, txtBtnUnitPrice.width + 4)
            height: 2 * UIMaterials.fontSizeMedium
//            visible: (currProduct !== undefined)
            Text {
                id: txtBtnUnitPrice
                text: "Nhập giá"
                anchors.centerIn: parent
                font.pixelSize: UIMaterials.fontSizeMedium
                color: "white"
            }
            background: Rectangle
            {
                id: rectBtnUnitPrice
                anchors.fill: parent
                color: UIMaterials.grayPrimary
                radius: 10
            }

            onClicked: {
                rectBtnUnitPrice.color = UIMaterials.grayDark
                rectTxtUnitPrice.color = "white"
                txtUnitPrice.color = "black"
                txtUnitPrice.enabled = true
                txtUnitPrice.focus = true
                inputPanel.active = true
                enabled = false
            }
        }

        Button {
            id: btnSave
            anchors.right: txtBarcode.horizontalCenter
            anchors.rightMargin: 20
            anchors.top: btnUndo.top
            width: 70
            height: 70
            enabled: false

            background: Rectangle {
                id: rectBtnSave
                anchors.fill: parent
                radius: 10
                color: UIMaterials.goldDark
            }

            Text {
                id: txtBtnSave
                anchors.centerIn: parent
                text: "\uf0c7"
                font {
                    pixelSize: 45;
                    weight: Font.Bold;
                    family: UIMaterials.solidFont
                }
                color: pnBasic.color
            }

            onDoubleClicked: {
                var ret = xpBackend.updateProductFromInventory( updateProduct )
                if( noti.state === "visible" )
                {
                    noti.state = "invisible"
                }

                if( ret === 0 )
                {
                    btnSave.enabled = false
                    btnUndo.enabled = false
                    noti.showNoti( "Lưu thông tin sản phẩm thành công", "success" )
                    noti.state = "visible"
                }
                else
                {
                    btnSave.enabled = false
                    noti.showNoti( "Gặp lỗi lưu thông tin sản phẩm", "error" )
                    noti.state = "visible"
                }
            }

            onPressed: {
                rectBtnSave.color = UIMaterials.goldPrimary
            }

            onReleased: {
                rectBtnSave.color = UIMaterials.goldDark
            }
        }

        Button {
            id: btnUndo
            anchors.left: txtBarcode.horizontalCenter
            anchors.leftMargin: 20
            anchors.top: txtUnitPrice.bottom
            anchors.topMargin: 40
            width: 70
            height: 70
            enabled: false

            background: Rectangle {
                id: rectBtnUndo
                anchors.fill: parent
                radius: 10
                color: UIMaterials.grayPrimary
            }

            Text {
                id: txtBtnUndo
                anchors.centerIn: parent
                text: "\uf0e2"
                font {
                    pixelSize: 45;
                    weight: Font.Bold;
                    family: UIMaterials.solidFont
                }
                color: pnBasic.color
            }

            onClicked: {
                showProduct( currProduct )
                updateProduct = Helper.deepCopy(currProduct)
                btnSave.enabled = false
                enabled = false
                changesUndone()
            }

            onPressed: {
                rectBtnUndo.color = UIMaterials.grayLight
            }

            onReleased: {
                rectBtnUndo.color = UIMaterials.grayPrimary
            }
        }

        Button {
            id: btnMenu
            width: 60
            height: 60
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }

            Text {
                id: txtBtnMenu
                text: "\uf0c9"
                anchors.centerIn: parent
                color: UIMaterials.grayPrimary
                font {
                    pixelSize: 40;
                    weight: Font.Bold
                    family: UIMaterials.solidFont
                }
                horizontalAlignment: Text.AlignHCenter
            }

            onPressed: {
                txtBtnMenu.color = UIMaterials.grayLight
            }

            onReleased: {
                txtBtnMenu.color = UIMaterials.grayPrimary
                menu.open()
            }
        }

        Menu {
            id: menu
            x: btnMenu.x
            y: btnMenu.y

            MenuItem {
                text: "Tạo hóa đơn"
                onTriggered: {
                    toInvoiceBoard()
                }
            }

            MenuItem {
                text: "Quản lý khách hàng"
                onTriggered: {
                    toCustomerBoard()
                }
            }

            MenuItem {
                text: "Phân tích kinh doanh"
                onTriggered: {
                    toAnalyticsBoard()
                }
            }

            MenuItem {
                text: "Cài đặt"
                onTriggered: {
                    toSetupBoard()
                }
            }

            MenuSeparator{}

            MenuItem {
                text: "Đăng xuất"
                onTriggered: {
                    toLoginBoard()
                    xpBackend.logout()
                }
            }

        }

        //======= Account infomation
        Label {
            id: lblAccSign
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            text: "\uf007"
            color: "white"
            font {
                pixelSize: 40;
                weight: Font.Bold;
                family: UIMaterials.solidFont
            }
        }

        Label {
            id: lblAccText
            anchors.right: lblAccSign.left
            anchors.rightMargin: 10
            anchors.bottom: lblAccSign.bottom
            text: "Do Anh Dan"
            font.pixelSize: UIMaterials.fontSizeSmall
            color: "white"
        }

        //======== Animation
        NumberAnimation {
            id: aniBasicUpTransition
            target: pnBasic
            property: "y"
            from: 0
            to: -root.height/3
            duration: 250
        }

        NumberAnimation {
            id: aniBasicDownTransition
            target: pnBasic
            property: "y"
            from: -root.height/3
            to: 0
            duration: 250
        }
    }


    //=================== 2. Panel of detail product infomation
    Rectangle {
        id: pnDetail
        width: 2*parent.width / 3
        height: parent.height
        y: 0
        anchors.left: pnBasic.right
        color: "#fffcf3"

        Row {
            id: rowPrice
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 50
            width: Math.max(0.9 * parent.width, parent.width - 100 )
            height: txtBarcode.height
            spacing: 10
            Label {
                id: titCurrentPrice
                width: rowPrice.width / 3
                height: rowPrice.height
                text: "Giá đang bán:"
                color: UIMaterials.appBgrColorLight
                font.pixelSize: UIMaterials.fontSizeMedium
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lblCurrentPrice
                text: ""
                height: rowPrice.height
                color: UIMaterials.appBgrColorPrimary
                font.pixelSize: UIMaterials.fontSizeMedium
                verticalAlignment: Text.AlignVCenter
            }
        }

        //============ Panel Quantity
        Label {
            id: titPnQuantity
            anchors.top: rowPrice.bottom
            anchors.topMargin: 40
            anchors.left: rowPrice.left
            text: "Thông tin kho hàng:"
            font.pixelSize: UIMaterials.fontSizeMedium
            font.bold: true
            color: UIMaterials.appBgrColorLight
        }

        Rectangle { // Just a line
            id: linePnQuantity
            anchors.top: pnQuantity.top
            anchors.left: pnQuantity.left
            width: pnQuantity.width
            height: 1
            color: UIMaterials.appBgrColorLight
        }

        Rectangle {
            id: pnQuantity
            anchors.top: titPnQuantity.bottom
            anchors.topMargin: 5
            anchors.left: rowPrice.left
            width: rowPrice.width
            height: 5 * UIMaterials.fontSizeMedium
            color: "transparent"

            Row {
                id: rowQuantity
                width: Math.min(2 * parent.width / 3, btnImport.x - 50)
                height: parent.height
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 20
                spacing: 5

                Column {
                    id: columnTitleQuantity
                    width: parent.width / 2
                    height: parent.height

                    Label {
                        id: titNumInstock
                        text: "Số lượng trong kho:"
                        width: parent.width
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }

                    Label {
                        id: titNumSold
                        text: "Số lượng đã bán:"
                        width: parent.width
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }

                    Label {
                        id: titRatioDisqualified
                        text: "Tỷ lệ hỏng/đổi trả:"
                        width: parent.width
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }

                Column {
                    id: columnLabelQuantity
                    width: parent.width / 2
                    height: parent.height

                    Label {
                        id: lblNumInstock
                        text: ""
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: UIMaterials.appBgrColorPrimary
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap                        
                    }

                    Label {
                        id: lblNumSold
                        text: ""
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: UIMaterials.appBgrColorPrimary
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }

                    Label {
                        id: lblRatioDisqualified
                        text: ""
                        height: parent.height / 3
                        font.pixelSize: UIMaterials.fontSizeMedium
                        color: UIMaterials.appBgrColorPrimary
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                id: pnQuantityInput
                width: rowQuantity.width
                height: rowQuantity.height
                x: rowQuantity.x
                y: rowQuantity.y
                z: rowQuantity.z + 1
                color: pnDetail.color
                visible: false

                Label {
                    id: titQuantityInput
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: UIMaterials.fontSizeMedium
                    text: ""
                    font.pixelSize: UIMaterials.fontSizeMedium
                    horizontalAlignment: Text.AlignHCenter
                }

                TextField {
                    id: txtQuantityInput
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: titQuantityInput.bottom
                    anchors.topMargin: 10
                    width: parent.width * 2/3
                    height: 2 * UIMaterials.fontSizeMedium
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: UIMaterials.fontSizeMedium
                    color: "black"
                    text: ""
                    inputMethodHints: Qt.ImhDialableCharactersOnly

                    background: Rectangle {
                        id: rectTxtQuantityInput
                        anchors.fill: parent
                        color: pnQuantityInput.color
                        radius: 10
                        border.width: 1
                        border.color: titQuantityInput.color
                    }

                    onAccepted: {
                        if( pnQuantityInput.state === "import" )
                        {
                            updateProduct["num_instock"] = currProduct["num_instock"] +  Number(text)
                            lblNumInstock.text = updateProduct["num_instock"]
                            lblRatioDisqualified.text = Number(updateProduct["num_disqualified"] / (updateProduct["num_instock"] + updateProduct["num_sold"] + updateProduct["num_disqualified"]) * 100).toFixed(2) + "%"
                            productInfoChanged()
                        }
                        else
                        {
                            var instock = currProduct["num_instock"]
                            var sold = currProduct["num_sold"]
                            var disqualify = currProduct["num_disqualified"]
                            var newDisqualify = Number( text )
                            if( newDisqualify <= instock )
                            {
                                updateProduct["num_instock"] = currProduct["num_instock"] - newDisqualify
                                updateProduct["num_disqualified"] = currProduct["num_disqualified"] + newDisqualify
                                lblNumInstock.text = updateProduct["num_instock"]
                                lblRatioDisqualified.text = Number(updateProduct["num_disqualified"] / (updateProduct["num_instock"] + updateProduct["num_sold"] + updateProduct["num_disqualified"]) * 100).toFixed(2) + "%"
                                productInfoChanged()
                            }
                            else {
                                if( noti.state === "visible" )
                                {
                                    noti.state = "invisible"
                                }
                                noti.showNoti( "Số lượng hàng xả vượt số lượng trong kho", "error" )
                                noti.state = "visible"
                            }
                        }
                        inputPanel.active = false
                        pnQuantityInput.visible = false
                    }

                    onFocusChanged: {
                        if( focus === true )
                        {
                            inputPanel.active = true
                        }
                    }
                }

                states: [
                    State {
                        name: "import"
                        PropertyChanges {
                            target: titQuantityInput
                            color: rectbtnImport.color
                            text: "Nhập số lượng hàng thêm vào kho"
                        }
                    },

                    State {
                        name: "disqualify"
                        PropertyChanges {
                            target: titQuantityInput
                            color: rectBtnDisqualify.color
                            text: "Nhập số lượng hàng loại khỏi kho"
                        }
                    }
                ]
            }

            Button {
                id: btnImport
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: btnDisqualify.left
                anchors.rightMargin: 30
                width: txtBtnImport.width + 8
                height: UIMaterials.fontSizeMedium * 3

                background: Rectangle {
                    id: rectbtnImport
                    anchors.fill: parent
                    radius: 10
                    color: UIMaterials.appBgrColorPrimary
                }

                Text {
                    id: txtBtnImport
                    anchors.centerIn: parent
                    text: "Nhập kho"
                    font.pixelSize: UIMaterials.fontSizeMedium
                    color: "white"
                }

                onClicked: {
                    pnQuantityInput.state = "import"
                    pnQuantityInput.visible = true
                    txtQuantityInput.text = ""
                    txtQuantityInput.focus = true
                }
            }

            Button {
                id: btnDisqualify
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
                width: btnImport.width
                height: UIMaterials.fontSizeMedium * 3

                background: Rectangle {
                    id: rectBtnDisqualify
                    anchors.fill: parent
                    radius: 10
                    color: UIMaterials.goldDark
                }

                Text {
                    id: txtBtnDisqualify
                    anchors.centerIn: parent
                    text: "Thải loại\nĐổi trả"
                    font.pixelSize: UIMaterials.fontSizeMedium
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    pnQuantityInput.state = "disqualify"
                    pnQuantityInput.visible = true
                    txtQuantityInput.text = ""
                    txtQuantityInput.focus = true
                }
            }
        }

        //============ Panel Discount
        Label {
            id: titPnDiscount
            anchors.top: pnQuantity.bottom
            anchors.topMargin: 40
            anchors.left: rowPrice.left
            text: "Chương trình khuyến mãi:"
            font.pixelSize: UIMaterials.fontSizeMedium
            font.bold: true
            color: UIMaterials.appBgrColorLight
        }

        Label {
            id: lblDiscountStatus
            anchors.left: titPnDiscount.right
            anchors.leftMargin: UIMaterials.fontSizeMedium
            anchors.verticalCenter: titPnDiscount.verticalCenter
            font.pixelSize: UIMaterials.fontSizeSmall
            state: "inactive"

            states: [
                State {
                    name: "active"
                    PropertyChanges {
                        target: lblDiscountStatus;
                        text: "(Đang chạy khuyến mãi)"
                        color: UIMaterials.goldDark
                    }
                },

                State {
                    name: "inactive"
                    PropertyChanges {
                        target: lblDiscountStatus;
                        text: "(Chưa có chương trình khuyến mãi)"
                        color: UIMaterials.grayPrimary
                    }
                }
            ]
        }

        Rectangle { // Just a line
            id: linePnDiscount
            anchors.top: pnDiscount.top
            anchors.left: pnDiscount.left
            width: pnDiscount.width
            height: 1
            color: UIMaterials.appBgrColorLight
        }

        Rectangle {
            id: pnDiscount
            anchors.top: titPnDiscount.bottom
            anchors.topMargin: 5
            anchors.left: rowPrice.left
            width: rowPrice.width
            height: 5 * UIMaterials.fontSizeMedium
            color: "transparent"

            Label {
                id: titDiscountPrice
                anchors.left: txtDiscountPrice.left
                anchors.bottom: txtDiscountPrice.top
                anchors.bottomMargin: 5
                text: "Giá KM (vnđ)"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: UIMaterials.goldDark//"black"
            }

            TextField {
                id: txtDiscountPrice
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 20
                anchors.left: parent.left
                anchors.leftMargin: 20
                width: parent.width / 5
                height: 1.5 * UIMaterials.fontSizeMedium
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.appBgrColorPrimary
                text: ""
                inputMethodHints: Qt.ImhDialableCharactersOnly

                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: UIMaterials.goldDark
                    radius: 5
                }

                onAccepted: {
                    focus = false
                    inputPanel.active = false
                    aniDetailDownTransition.from = -root.height / 6
                    aniDetailDownTransition.start()
                    txtDiscountStart.focus = true
                }

                onTextEdited: {
                    var orgText = text.replace( /,/g, "" )
                    var num = parseInt(orgText, 10)
                    if( isNaN(num) === false )
                    {
                        var vietnam = Qt.locale()
                        text = Number(num).toLocaleString( vietnam, 'f', 0 )
//                        cursorPosition = length
                    }
                    else
                    {
                        text = ""
                    }
                }

                onFocusChanged: {
                    if( focus === false )
                    {
                        accepted()
                    }
                    else
                    {
                        inputPanel.active = true
                        aniDetailUpTransition.to = -root.height / 6
                        aniDetailUpTransition.start()
                        text = ""
                    }
                }
            }

            Label {
                id: titDiscountStart
                anchors.left: txtDiscountPrice.right
                anchors.leftMargin: 50
                anchors.top: titDiscountPrice.top
                text: "Ngày bắt đầu"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: "black"
            }

            TextField {
                id: txtDiscountStart
                anchors.top: txtDiscountPrice.top
                anchors.left: titDiscountStart.left
                width: parent.width / 5
                height: 1.5 * UIMaterials.fontSizeMedium
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.appBgrColorPrimary
                text: ""

                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "black"
                    radius: 5
                }

                onFocusChanged:
                {
                    if( focus === true && enabled === true )
                    {
                        text = ""
                        var calendar = Qt.createQmlObject( "import QtQuick.Controls 1.4; Calendar {id: calendar; maximumDate: new Date(2050, 0, 1); minimumDate: new Date(2020, 0, 1); x: txtDiscountStart.x + pnDiscount.x; y: txtDiscountStart.y + pnDiscount.y; z: 20}",
                                                          pnDetail, "calendarErr" )
                        calendar.focus = true
                        calendar.doubleClicked.connect(function( date ) {
                            text = date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                            calendar.destroy()
                            focus = false
                            txtDiscountEnd.focus = true
                        })
                        calendar.focusChanged.connect(function() {
                            if( calendar.focus === false )
                            {
                                calendar.destroy()
                            }
                        })
                    }
                }
            }

            Label {
                id: titDiscountEnd
                anchors.left: txtDiscountStart.right
                anchors.leftMargin: 30
                anchors.top: titDiscountPrice.top
                text: "Ngày kết thúc"
                font.pixelSize: UIMaterials.fontSizeSmall
                color: "black"
            }

            TextField {
                id: txtDiscountEnd
                anchors.top: txtDiscountPrice.top
                anchors.left: titDiscountEnd.left
                width: parent.width / 5
                height: 1.5 * UIMaterials.fontSizeMedium
                font.pixelSize: UIMaterials.fontSizeMedium
                color: UIMaterials.appBgrColorPrimary
                text: ""

                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "black"
                    radius: 5
                }

                onFocusChanged: {
                    if( focus === true && enabled === true )
                    {
                        text = ""
                        var calendar = Qt.createQmlObject( "import QtQuick.Controls 1.4; Calendar {id: calendar; maximumDate: new Date(2050, 0, 1); minimumDate: new Date(2020, 0, 1); x: txtDiscountEnd.x + pnDiscount.x; y: txtDiscountEnd.y + pnDiscount.y; z: 20}",
                                                          pnDetail, "calendarErr" )
                        calendar.focus = true
                        calendar.doubleClicked.connect(function( date ) {
                            text = date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                            calendar.destroy()
                        })
                        calendar.focusChanged.connect(function() {
                            if( calendar.focus === false )
                            {
                                calendar.destroy()
                            }
                        })
                    }
                }
            }

            Button {
                id: btnDiscount
                width: btnDisqualify.width
                height: btnDisqualify.height
                anchors.right: parent.right
                anchors.rightMargin: btnDisqualify.anchors.rightMargin
                anchors.bottom: txtDiscountEnd.bottom
                state: "inactive"

                states: [
                    State {
                        name: "active"
                        PropertyChanges {
                            target: rectBtnDiscount;
                            color: UIMaterials.goldDark
                        }
                        PropertyChanges {
                            target: txtBtnDiscount
                            text: "Hủy KM"
                            color: "black"
                        }
                    },

                    State {
                        name: "inactive"
                        PropertyChanges {
                            target: rectBtnDiscount;
                            color: UIMaterials.appBgrColorPrimary
                        }
                        PropertyChanges {
                            target: txtBtnDiscount
                            text: "Chạy KM"
                            color: "white"
                        }
                    }
                ]

                Text {
                    id: txtBtnDiscount
                    anchors.centerIn: parent
                    text: "Chạy KM"
                    font.pixelSize: UIMaterials.fontSizeMedium
                    color: "black"
                }

                background: Rectangle {
                    id: rectBtnDiscount
                    anchors.fill: parent
                    color: UIMaterials.goldDark
                    radius: 10
                }

                onDoubleClicked: {
                    if( state === "inactive" )
                    {
                        var priceText = txtUnitPrice.text.replace( /,/g, "" )
                        var discountPriceText = txtDiscountPrice.text.replace( /,/g, "" )
                        var price = (priceText !== "" ) ? parseInt( priceText, 10 ) : 0
                        var discountPrice = (discountPriceText !== "" ) ? parseInt( discountPriceText, 10 ) : 0
                        var startDate = Date.fromLocaleDateString(Qt.locale(), txtDiscountStart.text, "dd/MM/yyyy" )
                        var endDate = Date.fromLocaleDateString(Qt.locale(), txtDiscountEnd.text, "dd/MM/yyyy" )
                        var currDate = new Date()
                        console.log( "price = ", price, ", currDate = ", currDate.getTime(),
                                    ", start = ", startDate.getTime(), ", end = ", endDate.getTime() )
                        if( (discountPrice < price) && (discountPrice > 0)
                                && (startDate.getTime() >= (currDate.getTime()-86400000))
                                && (endDate.getTime() > startDate.getTime()) )
                        {
                            state = "active"
                            txtDiscountPrice.enabled = false
                            txtDiscountStart.enabled = false
                            txtDiscountEnd.enabled = false

                            updateProduct["discount_price"] = discountPrice
                            updateProduct["discount_start"] = txtDiscountStart.text
                            updateProduct["discount_end"] = txtDiscountEnd.text
                            productInfoChanged()
                        }
                        else
                        {
                            if( noti.state === "visible" )
                            {
                                noti.state = "invisible"
                            }

                            noti.showNoti( "Thông tin không hợp lệ", "error" )
                            noti.state = "visible"
                        }
                    }
                    else
                    {
                        state = "inactive"
                        txtDiscountPrice.text = ""
                        txtDiscountStart.text = ""
                        txtDiscountEnd.text =""
                        txtDiscountPrice.enabled = true
                        txtDiscountStart.enabled = true
                        txtDiscountEnd.enabled = true
                        updateProduct["discount_price"] = 0.0
                        updateProduct["discount_start"] = "01/01/1970"
                        updateProduct["discount_end"] = "01/01/1970"
                        productInfoChanged()
                    }
                }

                onStateChanged: {
                    lblDiscountStatus.state = state
                }
            }
        }

        //========== Panel Provider
        Label {
            id: titPnProviders
            anchors.top: pnDiscount.bottom
            anchors.topMargin: 40
            anchors.left: rowPrice.left
            text: "Nhà cung cấp:"
            font.pixelSize: UIMaterials.fontSizeMedium
            font.bold: true
            color: UIMaterials.appBgrColorLight
        }

        Rectangle { // Just a line
            id: linePnProvider
            anchors.top: pnProvider.top
            anchors.left: pnProvider.left
            width: pnProvider.width
            height: 1
            color: UIMaterials.appBgrColorLight
        }

        Rectangle {
            id: pnProvider
            anchors.top: titPnProviders.bottom
            anchors.topMargin: 5
            anchors.left: rowPrice.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: rowPrice.width / 2
            color: "transparent"

            ProvidersListview {
                id: lvProviders
                anchors.fill: parent
            }


            Button {
                id: btnAddProvider
                width: 50
                height: 50
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                }

                Text {
                    id: txtBtnAddProvider
                    text: "\uf067"
                    anchors.centerIn: parent
                    color: UIMaterials.appBgrColorPrimary
                    font {
                        pixelSize: 30;
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Button {
                id: btnDeleteProvider
                width: 50
                height: 50
                anchors.left: btnAddProvider.right
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                }

                Text {
                    id: txtBtnDeleteProvider
                    text: "\uf2ed"
                    anchors.centerIn: parent
                    color: UIMaterials.grayPrimary
                    font {
                        pixelSize: 30;
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Button {
                id: btnCall
                width: 50
                height: 50
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                }

                Text {
                    id: txtBtnCall
                    text: "\uf095"
                    anchors.centerIn: parent
                    color: UIMaterials.goldDark
                    font {
                        pixelSize: 30;
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        //========== Panel Update History
        Label {
            id: titPnHistory
            anchors.top: titPnProviders.top
            anchors.left: pnProvider.right
            anchors.leftMargin: rowPrice.width / 8
            text: "Lịch sử:"
            font.pixelSize: UIMaterials.fontSizeMedium
            font.bold: true
            color: UIMaterials.grayPrimary
        }

        Rectangle { // Just a line
            id: linePnHistory
            anchors.top: pnHistory.top
            anchors.left: pnHistory.left
            width: pnHistory.width
            height: 1
            color: UIMaterials.grayPrimary
        }

        Rectangle {
            id: pnHistory
            anchors.top: titPnHistory.bottom
            anchors.topMargin: 5
            anchors.left: titPnHistory.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: pnProvider.anchors.bottomMargin
            width: 3 * rowPrice.width / 8
            color: "transparent"

            HistoryListview {
                id: lvHistory
                anchors.fill: parent
            }
        }

        //======== Animation
        NumberAnimation {
            id: aniDetailUpTransition
            target: pnDetail
            property: "y"
            from: 0
            to: -root.height/3
            duration: 250
        }

        NumberAnimation {
            id: aniDetailDownTransition
            target: pnDetail
            property: "y"
            from: -root.height/3
            to: 0
            duration: 250
        }
    }

    //=================== 3. Notification Popup
    NotificationPopup {
        id: noti
        width: 3*pnBasic.width/4
        height: 100
        x: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        state: "invisible"

        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: noti
                    x: 5
                }
            },

            State {
                name: "invisible"
                PropertyChanges {
                    target: noti
                    x: -noti.width
                }
            }
        ]

        transitions: Transition {
            from: "invisible"
            to: "visible"
            reversible: true
            SequentialAnimation {
                NumberAnimation {
                    properties: "x"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

//                PropertyAnimation {
//                    properties: "focus"
//                    from: false
//                    to: true
//                }

//                PauseAnimation {
//                    duration: 500
//                }
            }
        }

        onColapse: {
            state = "invisible"
        }

        onStateChanged: {
            if( state === "visible" )
            {
                focus = true
            }
        }

        onFocusChanged: {
            if( focus === false )
            {
                state = "invisible"
            }
        }
    }


    //========================== III. States and transition
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
            }

            PropertyChanges {
                target: root
                enabled: true
            }
        },

        State {
            name: "invisible"
            PropertyChanges {
                target: root
                opacity: 0
            }

            PropertyChanges {
                target: root
                enabled: false
            }
        }
    ]
}
