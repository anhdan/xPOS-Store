import QtQuick 2.0
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.2

import "."
import ".."
import "../gadgets"

Item {
    id: root

    property var currItem

    //========================= Signals and slots
    //----- Signals
    Component.onCompleted: {
        beInventory.sigProductFound.connect(
                    function( product ) {
                        currItem = Helper.deepCopy( product )
                        currItem[qsTr("completed")] = false
                        currItem[qsTr("exp_date")] = new Date()
                        lvItems.append( currItem )
                        showProductInfo( product )
                    }
                    )

        beInventory.sigProductNotFound.connect(
                    function( code ) {
                        currItem = Helper.createDefaultProduct()
                        console.log( "=====> category: " + currItem["category"] )
                        currItem["barcode"] = code
                        currItem["completed"] = false
                        currItem["exp_date"] = new Date()
                        lvItems.append( currItem )
                        noti.showNoti( "Sản phẩm chưa tồn tại", UIMaterials.iconError )
                        noti.state = "visible"
                        showProductInfo( currItem )
                    }
                    )

        beInventory.sigUpdateSucceeded.connect(
                    function() {

                    }

                    )
    }

    //----- Slots
    function showProductInfo( product )
    {
        icBarcode.infoText = product["barcode"]
        icClass.infoText = (product["category"] !== -1) ? formCategory.getCategoryString( product["category"] ) : ""
        icName.infoText = product["name"]
        icUnitLabel.infoText = product["unit"]
        icShortenName.infoText = product["shorten_name"]
        icSKU.infoText = product["sku"]

        icInputPrice.infoText = product["input_price"]
        icUnitPrice.infoText = product["unit_price"]
        if( (product["discount_price"] > 0) && (product["discount_price"] < product["unit_price"]) )
        {
            icDiscountPrice.infoText = product["discount_price"]
            icDiscountStart.infoText = Helper.dateToString(product["discount_start"])
            icDiscountEnd.infoText = Helper.dateToString(product["discount_end"])
            btnDiscountPrg.state = "running"
            rowDiscountPrg.visible = true
        }
        else
        {
            rowDiscountPrg.visible = false
            btnDiscountPrg.state = ""
        }

        boardStockInfo.instock = product["num_instock"]
        boardStockInfo.sold = product["num_sold"]
        var totalQuantity = (product["num_instock"] + product["num_sold"] + product["num_disqualified"])
        boardStockInfo.disqualifiedRate = (totalQuantity > 0) ? product["num_disqualified"] / totalQuantity : 0
    }

    //========================= I. Control panel
    Rectangle {
        id: pnControl
        width: 0.332 * parent.width
        height: parent.height
        x: 0
        y: 0
        color: UIMaterials.colorNearWhite

        //----- I.1. Product search box
        SearchBox {
            id: searchBox
            width: 0.9412 * parent.width
            height: 0.0847 * parent.height
            y: 0.0282 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColor: "white"
            textColor: UIMaterials.colorTaskBar
            placeholderText: "Mã vạch/Tên viết tắt ..."

            onSearchExecuted: {
                var idx = lvItems.find( searchStr )
                if( idx === -1 )
                {
                    beInventory.searchForProduct( searchStr )
                }
                else
                {
                    lvItems.select( idx )
                }
            }
        }

        //----- I.2. Processed item list view
        InventoryItemList {
            id: lvItems
            anchors.top: searchBox.bottom
            anchors.topMargin: 0.0565 * parent.height
            anchors.left: parent.left
            width: parent.width
            height: 0.6893 * parent.height

            onSelected: {
                currItem = Helper.deepCopy( item )
                showProductInfo( currItem )
            }
        }

        //----- I.3. Control button
        Row {
            y: 0.8827 * parent.height
            anchors.horizontalCenter: searchBox.horizontalCenter
            width: 0.9412 * parent.width
            spacing: 0.0149 * width

            Button {
                id: btnDelete
                width: 0.3226 * parent.width
                height: 0.1042 * UIMaterials.windowHeight

                background: Rectangle {
                    id: rectBtnDelete
                    anchors.fill: parent
                    color: "white"
                }

                Text {
                    text: "\uf00d"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.colorTrueRed
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: 0.6667 * height
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                Text {
                    text: "Hủy"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.colorTrueRed
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: UIMaterials.fontsizeS
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnDelete.opacity = 0
                }

                onReleased: {
                    rectBtnDelete.opacity = 1
                }
            }

            Button {
                id: btnUndo
                width: btnDelete.width
                height: btnDelete.height

                background: Rectangle {
                    id: rectBtnUndo
                    anchors.fill: parent
                    color: "white"
                }

                Text {
                    text: "\uf0e2"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.grayPrimary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: 0.6667 * height
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                Text {
                    text: "Hoàn Tác"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.grayPrimary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: UIMaterials.fontsizeS
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnUndo.opacity = 0
                }

                onReleased: {
                    rectBtnUndo.opacity = 1
                }
            }

            Button {
                id: btnSave
                width: btnDelete.width
                height: btnDelete.height

                background: Rectangle {
                    id: rectBtnSave
                    anchors.fill: parent
                    color: "white"
                }

                Text {
                    text: "\uf0c7"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.colorTrueBlue
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: 0.6667 * height
                        weight: Font.Bold
                        family: UIMaterials.solidFont
                    }
                }

                Text {
                    text: "Lưu"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/2
                    width: parent.width
                    color: UIMaterials.colorTrueBlue
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        pixelSize: UIMaterials.fontsizeS
                        family: UIMaterials.fontRobotoLight
                    }
                }

                onPressed: {
                    rectBtnSave.opacity = 0
                }

                onReleased: {
                    rectBtnSave.opacity = 1
                    var ret = beInventory.updateProduct( currItem )
                    if( noti.state === "visible" )
                    {
                        noti.state = "invisible"
                    }
                    if( ret === 0 )
                    {
                        currItem["completed"] = true
                        lvItems.set( lvItems.currentIndex, currItem )
                        noti.showNoti( "Lưu thông tin sản phẩm thành công", "success" )
                    }
                    else
                    {
                        noti.showNoti( "Gặp lỗi lưu thông tin sản phẩm", "error" )
                    }
                    noti.state = "visible"

                    if( lvItems.currentIndex < lvItems.count )
                    {
                        lvItems.select( lvItems.currentIndex + 1 )
                    }
                }
            }
        }
    }

    //========================= II. Product info panel
    Rectangle {
        id: pnInfo
        width: 0.668 * parent.width
        height: parent.height
        x: pnControl.width
        y: 0
        color: "white"

        //----- II.1 Basic product info
        Label {
            id: titBasicInfo
            x: 0.0146 * parent.width
            y: 0.0141 * parent.height
            height: 0.0565 * parent.height
            verticalAlignment: Text.AlignVCenter
            color: UIMaterials.grayDark
            font {
                pixelSize: UIMaterials.fontsizeS
                bold: true
                family: UIMaterials.fontRobotoLight
            }
            text: "Định danh sản phẩm"
        }

        InfoCard {
            id: icBarcode
            anchors.left: titBasicInfo.left
            anchors.top: titBasicInfo.bottom
            anchors.topMargin: 0.0141 * parent.height
            width: 0.5848 * parent.width
            titleHeight: 0.0282 * parent.height
            infoHeight: 2.5 * titleHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: UIMaterials.grayDark
            infoColor: "black"
            editable: true

            titleText: "Mã vạch"
            placeholderText: "..."
            underline: true

            onEditFinished: {
                currItem["barcode"] = infoText
            }
        }

        InfoCard {
            id: icClass
            anchors.right: parent.right
            anchors.rightMargin: 0.0146 * parent.width
            anchors.top: icBarcode.top
            width: 0.3216 * parent.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icBarcode.titleColor
            infoColor: "black"
            editable: true

            titleText: "Nhóm sản phẩm"
            placeholderText: "..."
            underline: true

            onEditStarted: {
                if( formCategory.enabled === false )
                {
                    formCategory.currentIndex = currItem["category"]
                    formCategory.enabled = true
                }
            }
        }

        InfoCard {
            id: icName
            anchors.left: icBarcode.left
            anchors.top: icBarcode.bottom
            anchors.topMargin: 0.0212 * parent.height
            width: icBarcode.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icBarcode.titleColor
            infoColor: "black"
            editable: true

            titleText: "Tên sản phẩm"
            placeholderText: "..."
            underline: true

            onEditFinished: {
                currItem["name"] = infoText
                if( infoText[0] !== " " )
                {
                    var shortenName = infoText[0].toUpperCase()
                }

                for( var i = 1; i < infoText.length-1; i++ )
                {
                    if( infoText[i] === " " && infoText[i+1] !== " " )
                    {
                        shortenName += infoText[i+1].toUpperCase()
                    }
                }
                currItem["shorten_name"] = shortenName
                icShortenName.infoText = shortenName
            }
        }

        InfoCard {
            id: icUnitLabel
            anchors.right: icClass.right
            anchors.top: icName.top
            width: icClass.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icBarcode.titleColor
            infoColor: "black"
            editable: true

            titleText: "Đơn vị"
            placeholderText: "..."
            underline: true

            onEditFinished: {
                currItem["unit"] = infoText
            }
        }

        InfoCard {
            id: icShortenName
            anchors.left: icBarcode.left
            anchors.top: icName.bottom
            anchors.topMargin: 0.0212 * parent.height
            width: icBarcode.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icBarcode.titleColor
            infoColor: "black"
            editable: false

            titleText: "Tên viết tắt sản phẩm"
        }

        InfoCard {
            id: icSKU
            anchors.right: icClass.right
            anchors.top: icShortenName.top
            width: icClass.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icBarcode.titleColor
            infoColor: "black"
            editable: false

            titleText: "SKU"
        }


        //----- II.2. Price info
        Label {
            id: titPriceInfo
            anchors.left: titBasicInfo.left
            y: 0.4379 * parent.height
            height: titBasicInfo.height
            verticalAlignment: Text.AlignVCenter
            color: UIMaterials.grayDark
            font {
                pixelSize: UIMaterials.fontsizeS
                bold: true
                family: UIMaterials.fontRobotoLight
            }
            text: "Giá sản phẩm"
        }

        InfoCard {
            id: icInputPrice
            anchors.left: titPriceInfo.left
            anchors.top: titPriceInfo.bottom
            anchors.topMargin: 0.0141 * parent.height
            width: 0.5 * icBarcode.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight
            isCurrency: true

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: UIMaterials.grayDark
            infoColor: "black"
            editable: true

            titleText: "Đơn giá nhập"
            placeholderText: "..."
            underline: true

            onEditFinished: {
                currItem["input_price"] = Helper.currencyToNumber( infoText )
            }
        }

        InfoCard {
            id: icUnitPrice
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titPriceInfo.bottom
            anchors.topMargin: 0.0141 * parent.height
            width: 0.5 * icBarcode.width
            titleHeight: icBarcode.titleHeight
            infoHeight: icBarcode.infoHeight
            isCurrency: true

            titleFontSize: UIMaterials.fontsizeXS
            titleColor: icInputPrice.titleColor
            infoColor: "black"
            editable: true

            titleText: "Đơn giá bán"
            placeholderText: "..."
            underline: true

            onEditFinished: {
                currItem["unit_price"] = Helper.currencyToNumber( infoText )
            }
        }

        Row {
            id: rowDiscountPrg
            anchors.top: icInputPrice.bottom
            anchors.topMargin: 0.0282 * parent.height
            anchors.left: icInputPrice.left
            anchors.right: icClass.right
            visible: false

            InfoCard {
                id: icDiscountPrice
                anchors.left: parent.left
                width: icInputPrice.width
                titleHeight: icInputPrice.titleHeight
                infoHeight: 2.5 * titleHeight

                titleFontSize: icInputPrice.titleFontSize
                titleColor: icInputPrice.titleColor
                infoColor: UIMaterials.colorAntLogo

                titleText: "Đơn giá khuyến mãi"
                infoText: "10,000 vnd"
            }

            InfoCard {
                id: icDiscountStart
                anchors.horizontalCenter: parent.horizontalCenter
                width: icInputPrice.width
                titleHeight: icInputPrice.titleHeight
                infoHeight: 2.5 * titleHeight

                titleFontSize: icInputPrice.titleFontSize
                titleColor: icInputPrice.titleColor
                infoColor: UIMaterials.colorAntLogo

                titleText: "Ngày bắt đầu"
                infoText: "10/10/2020"
            }

            InfoCard {
                id: icDiscountEnd
                anchors.right: parent.right
                width: icInputPrice.width
                titleHeight: icInputPrice.titleHeight
                infoHeight: 2.5 * titleHeight

                titleFontSize: icInputPrice.titleFontSize
                titleColor: icInputPrice.titleColor
                infoColor: UIMaterials.colorAntLogo

                titleText: "Ngày kết thúc"
                infoText: "11/11/2020"
            }
        }

        Button {
            id: btnDiscountPrg
            width: 0.7 * icInputPrice.width
            height: 0.0847 * root.height
            anchors.right: icClass.right
            anchors.bottom: icInputPrice.bottom
            state: "*"

            background: Rectangle {
                id: rectBtnDiscountPrg
                anchors.fill: parent
                radius: 10
                color: UIMaterials.colorAntLogo
            }

            Text {
                id: txtBtnDiscountPrg
                anchors.centerIn: parent
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
                text: "Tạo KM"
            }

            states: State {
                name: "running"
                PropertyChanges {
                    target: rectBtnDiscountPrg
                    color: UIMaterials.colorTrueGray
                }
                PropertyChanges {
                    target: txtBtnDiscountPrg
                    text: "Hủy KM"
                }
            }

            onPressed: {
                rectBtnDiscountPrg.opacity = 0.6
            }

            onReleased: {
                rectBtnDiscountPrg.opacity = 1
                if( formDiscountPrg.enabled === false )
                {
                    formDiscountPrg.init( currItem["unit_price"] )
                    formDiscountPrg.enabled = true
                }
            }
        }

        //----- II.3. Stock info
        Label {
            id: titStockInfo
            anchors.left: titBasicInfo.left
            y: 0.7486 * parent.height
            height: titBasicInfo.height
            verticalAlignment: Text.AlignVCenter
            color: UIMaterials.grayDark
            font {
                pixelSize: UIMaterials.fontsizeS
                bold: true
                family: UIMaterials.fontRobotoLight
            }
            text: "Tình trạng lưu kho"
        }

        InventoryStockBoard {
            id: boardStockInfo
            width: 0.5263 * parent.width
            height: 3 * titStockInfo.height
            anchors.top: titStockInfo.bottom
            anchors.left: titBasicInfo.left
        }

        Button {
            id: btnUpdate
            width: btnDiscountPrg.width
            height: btnDiscountPrg.height
            anchors.left: boardStockInfo.right
            anchors.verticalCenter: boardStockInfo.verticalCenter

            background: Rectangle {
                id: rectBtnUpdate
                anchors.fill: parent
                radius: 10
                color: UIMaterials.colorTrueBlue
            }

            Text {
                anchors.centerIn: parent
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
                text: "Cập Nhật"
            }

            onPressed: {
                rectBtnUpdate.opacity = 0.6
            }

            onReleased: {
                rectBtnUpdate.opacity = 1
                if( formStockUpdate.enabled === false )
                {
                    formStockUpdate.init(boardStockInfo.instock, new Date() )
                    formStockUpdate.enabled = true
                }
            }
        }

        Button {
            id: btnConvert
            width: btnDiscountPrg.width
            height: btnDiscountPrg.height
            anchors.right: icClass.right
            anchors.verticalCenter: boardStockInfo.verticalCenter

            background: Rectangle {
                id: rectBtnConvert
                anchors.fill: parent
                radius: 10
                color: UIMaterials.colorTrueGray
            }

            Text {
                anchors.centerIn: parent
                font {
                    pixelSize: UIMaterials.fontsizeM
                    family: UIMaterials.fontRobotoLight
                }
                color: "white"
                text: "Quy Đổi"
            }

            onPressed: {
                rectBtnConvert.opacity = 0.6
            }

            onReleased: {
                rectBtnConvert.opacity = 1
            }
        }

        //----- II.4. Discount program form
        DiscountPrgForm {
            id: formDiscountPrg
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            color: "white"
            opacity: 0
            enabled: false

            states: State {
                name: "visible"
                when: formDiscountPrg.enabled
                PropertyChanges {
                    target: formDiscountPrg
                    opacity: 1
                }
            }

            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true

                NumberAnimation {
                    properties: "opacity"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            onChangesCanceled: {
                if( enabled )
                {
                    enabled = false
                }
            }

            onActivated: {
                currItem["discount_price"] = discountPrice
                currItem["discount_start"] = startDate
                currItem["discount_end"] = endDate
                showProductInfo( currItem )
                enabled = false
            }

            onInputInvalid: {
                if( noti.state === "visible" )
                {
                    noti.state = "invisible"
                }

                noti.showNoti( msg, UIMaterials.iconError )
                noti.state = "visible"
            }
        }

        //----- II.5. Category selection form
        CategoryForm {
            id: formCategory
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            color: "white"
            opacity: 0
            enabled: false

            states: State {
                name: "visible"
                when: formCategory.enabled
                PropertyChanges {
                    target: formCategory
                    opacity: 1
                }
            }

            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true

                NumberAnimation {
                    properties: "opacity"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            onChangesCanceled: {
                if( enabled )
                {
                    enabled = false
                }
            }

            onCategorySelected: {
                root.currItem["category"] = major
                icClass.infoText = name
                enabled = false
            }
        }

        //----- II.6. Instock update form
        StockUpdateForm {
            id: formStockUpdate
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            color: "white"
            opacity: 0
            enabled: false

            states: State {
                name: "visible"
                when: formStockUpdate.enabled
                PropertyChanges {
                    target: formStockUpdate
                    opacity: 1
                }
            }

            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true

                NumberAnimation {
                    properties: "opacity"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            onChangesCanceled: {
                if( enabled )
                {
                    enabled = false
                }
            }

            onUpdated: {
                currItem["num_instock"] += quantityChange
                if( quantityChange < 0 )
                {
                    currItem["num_disqualified"] -= quantityChange
                }

                currItem["exp_date"] = expDate
                showProductInfo( currItem )
                enabled = false
            }

            onInvalidInput: {
                if( noti.state === "visible" )
                {
                    noti.state = "invisible"
                }

                noti.showNoti( msg, UIMaterials.iconError )
                noti.state = "visible"
            }
        }

        //----- II.6. Input panel
        InputPanel {
            id: inputPanel
            z: 99
            anchors.horizontalCenter: parent.horizontalCenter
            y: root.height
            width: root.width / 2
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

                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    //======================= III. Notification Popup
    NotificationPopup {
        id: noti
        width: 1.2 * pnControl.width
        height: 0.1412 * root.height
        x: 5
        z: 100
        anchors.bottom: root.bottom
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
            NumberAnimation {
                properties: "x"
                duration: 400
                easing.type: Easing.InOutQuad
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
}
