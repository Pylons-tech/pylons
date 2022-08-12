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
import { useState, useCallback, useMemo } from 'react';
import { createWidthCalculator, } from '../../widthCalculator';
import { getViewMetricsFromContainer } from './getViewMetrics';
import { objectUnzip } from '../../helpers/object';
export function useWidthCalculator() {
    var _a = __read(useState(null), 2), baseMetrics = _a[0], setBaseMetrics = _a[1];
    var resetCalculator = useCallback(function () { return setBaseMetrics(null); }, []);
    var calculatorResult = useMemo(function () {
        return createWidthCalculator(baseMetrics);
    }, [baseMetrics]);
    if ('requiredBaseMetrics' in calculatorResult) {
        var _b = __read(objectUnzip(calculatorResult.requiredBaseMetrics), 2), itemKeys_1 = _b[0], items = _b[1];
        return {
            renderNeeded: {
                items: items,
                ref: function (containerElement) {
                    if (containerElement) {
                        setBaseMetrics(getViewMetricsFromContainer(containerElement, itemKeys_1));
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
