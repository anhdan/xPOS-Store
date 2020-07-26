pragma Singleton
import QtQuick 2.0

QtObject {

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
        ret["unit_price"] = 0.0
        ret["discount_price"] = 0.0
        ret["discount_start"] = "01/01/1970"
        ret["discount_end"] = "01/01/1970"
        ret["num_instock"] = 0
        ret["num_sold"] = 0
        ret["num_disqualified"] = 0

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
        product["unit_price"] = 0.0
        product["discount_price"] = 0.0
        product["discount_start"] = "01/01/1970"
        product["discount_end"] = "01/01/1970"
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

}
