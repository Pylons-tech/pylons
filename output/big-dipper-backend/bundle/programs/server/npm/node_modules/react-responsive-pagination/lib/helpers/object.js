var __read = (this && this.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};
export function objectUnzip(object) {
    var entries = Object.entries(object);
    var keys = entries.map(function (_a) {
        var _b = __read(_a, 2), key = _b[0], _ = _b[1];
        return key;
    });
    var values = entries.map(function (_a) {
        var _b = __read(_a, 2), _ = _b[0], value = _b[1];
        return value;
    });
    return [keys, values];
}
export function objectZip(keys, values) {
    var ret = {};
    keys.forEach(function (key, index) {
        ret[key] = values[index];
    });
    return ret;
}
