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
exports.useWidestComposition = void 0;
var react_1 = require("react");
var ref_1 = require("../helpers/ref");
var useAvailableWidth_1 = require("./useAvailableWidth");
var useWidestCompositionForWidth_1 = require("./useWidestCompositionForWidth");
function useWidestComposition(narrowToWideCompositionsProvider, maxWidth) {
    var _a;
    var _b = __read((0, react_1.useState)(null), 2), containerElement = _b[0], setContainerElement = _b[1];
    var availableWidth = (0, useAvailableWidth_1.useAvailableWidth)(maxWidth === undefined ? containerElement : null);
    var width = (_a = maxWidth !== null && maxWidth !== void 0 ? maxWidth : availableWidth) !== null && _a !== void 0 ? _a : 0;
    var _c = (0, useWidestCompositionForWidth_1.useWidestCompositionForWidth)(narrowToWideCompositionsProvider, width), items = _c.items, widestCompositionRef = _c.ref, clearCache = _c.clearCache;
    var ref = (0, react_1.useCallback)(function (element) {
        (0, ref_1.setRefValue)(widestCompositionRef, element);
        setContainerElement(element);
    }, [widestCompositionRef]);
    return {
        items: items,
        ref: ref,
        clearCache: clearCache,
    };
}
exports.useWidestComposition = useWidestComposition;
