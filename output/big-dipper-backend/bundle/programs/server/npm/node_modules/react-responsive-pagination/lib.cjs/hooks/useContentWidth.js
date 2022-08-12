"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.useContentWidth = void 0;
var react_1 = require("react");
var style_1 = require("../helpers/style");
var useResizeNotifier_1 = require("./useResizeNotifier");
function useContentWidth(element) {
    var _a = __read((0, react_1.useState)(), 2), width = _a[0], setWidth = _a[1];
    function syncWidth() {
        var newWidth = element ? (0, style_1.getContentWidth)(element) : undefined;
        if (width !== newWidth) {
            setWidth(newWidth);
        }
    }
    (0, useResizeNotifier_1.useResizeNotifier)(element, syncWidth);
    (0, react_1.useLayoutEffect)(syncWidth);
    return width;
}
exports.useContentWidth = useContentWidth;
