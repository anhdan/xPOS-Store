pragma Singleton
import QtQuick 2.0

QtObject {

    function copy( src, dst )
    {
        if( dst === undefined )
        {
            dst = deepCopy( src )
        }

        for (var i in p) {
            if (typeof p[i] === 'object') {
                c[i] = (p[i].constructor === Array) ? [] : {};
                deepCopy(p[i], c[i]);
            } else {
                c[i] = p[i];
            }
        }
    }

    function deepCopy(p) {
        var c = {};
        for (var i in p) {
            if (typeof p[i] === 'object') {
                c[i] = (p[i].constructor === Array) ? [] : {};
                deepCopy(p[i], c[i]);
            } else {
                c[i] = p[i];
            }
        }
        return c;
    }

    function createDefaultProduct ()
    {
        var ret = {}
        ret["barcode"] = ""
        ret["name"] = ""
        ret["desc"] = ""
        ret["unit"] = ""
        ret["category"] = -1
        ret["input_price"] = 0.0
        ret["unit_price"] = 0.0
        ret["discount_price"] = 0.0
        ret["discount_start"] = Date.fromLocaleString(Qt.locale(), "01/01/1970", "dd/mm/yyyy") //new Date()
        ret["discount_end"] = Date.fromLocaleString(Qt.locale(), "01/01/1970", "dd/mm/yyyy")
        ret["item_num"] = 0
        ret["num_instock"] = 0
        ret["num_sold"] = 0
        ret["num_disqualified"] = 0
        ret["exp_date"] = Date.fromLocaleString(Qt.locale(), "01/01/1970", "dd/mm/yyyy")
        ret["shorten_name"] = ""
        ret["sku"] = 0

        return ret
    }


    function setDefaultProduct ( product )
    {
        if( product === undefined )
        {
            product = {}
        }

        product["barcode"] = ""
        product["name"] = ""
        product["desc"] = ""
        product["unit"] = ""
        product["category"] = -1
        product["unit_price"] = 0.0
        product["discount_price"] = 0.0
        product["discount_start"] = new Date(0)
        product["discount_end"] = new Date(0)
        product["item_num"] = 0
        product["num_instock"] = 0
        product["num_sold"] = 0
        product["num_disqualified"] = 0

        return product
    }

    function setDefaultCustomer ( customer )
    {
        if( customer === undefined )
        {
            customer = {}
        }

        customer["id"] = ""
        customer["name"] = ""
        customer["phone"] = ""
        customer["email"] = ""
        customer["shopping_count"] = 0
        customer["total_payment"] = 0
        customer["point"] = 0

        return customer
    }


    function createDefaultPayment ()
    {
        var ret = {}
        ret["total_charging"] = 0
        ret["total_discount"] = 0
        ret["customer_payment"] = 0
        ret["used_point"] = 0
        ret["rewarded_point"] = 0

        return ret
    }


    function setDefaultPayment( payment )
    {
        if( payment === undefined )
        {
            payment = {}
        }
        payment["total_charging"] = 0
        payment["total_discount"] = 0
        payment["customer_payment"] = 0
        payment["used_point"] = 0
        payment["rewarded_point"] = 0

        return payment
    }

    function secsToStopWatchString( secs )
    {
        var mins_ = Math.floor( secs / 60.0 )
        var hours_ = Math.floor( secs / 3600.0 )
        return (Number(hours_).toString().padStart(2, "0") + ":" + Number(mins_).toString().padStart(2, "0") )
    }

    function currencyToNumber( text )
    {
        var orgText = text.replace( /,/g, "" )
        orgText = orgText.replace( "vnd", "" )
        return parseInt(orgText, 10)
    }

    function dateToString( date )
    {
        return date.toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
    }
}
