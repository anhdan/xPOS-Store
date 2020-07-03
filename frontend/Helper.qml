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

}
