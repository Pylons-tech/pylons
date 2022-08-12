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
exports.useWidthCalculator = void 0;
var react_1 = require("react");
var widthCalculator_1 = require("../../widthCalculator");
var getViewMetrics_1 = require("./getViewMetrics");
var object_1 = require("../../helpers/object");
function useWidthCalculator() {
    var _a = __read((0, react_1.useState)(null), 2), baseMetrics = _a[0], setBaseMetrics = _a[1];
    var resetCalculator = (0, react_1.useCallback)(function () { return setBaseMetrics(null); }, []);
    var calculatorResult = (0, react_1.useMemo)(function () {
        return (0, widthCalculator_1.createWidthCalculator)(baseMetrics);
    }, [baseMetrics]);
    if ('requiredBaseMetrics' in calculatorResult) {
        var _b = __read((0, object_1.objectUnzip)(calculatorResult.requiredBaseMetrics), 2), itemKeys_1 = _b[0], items = _b[1];
        return {
            renderNeeded: {
                items: items,
                ref: function (containerElement) {
                    if (containerElement) {
                        setBaseMetrics((0, getViewMetrics_1.getViewMetricsFromContainer)(containerElement, itemKeys_1));
                    }
                },
            },
            clearCache: resetCalculator,
        };
    }
    return {
        calculator: calculatorResult,
        clearCache: resetCalculator,
    };
}
exports.useWidthCalculator = useWidthCalculator;
