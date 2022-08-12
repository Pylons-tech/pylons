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
import { useCallback, useState } from 'react';
import { setRefValue } from '../helpers/ref';
import { useAvailableWidth } from './useAvailableWidth';
import { useWidestCompositionForWidth } from './useWidestCompositionForWidth';
export function useWidestComposition(narrowToWideCompositionsProvider, maxWidth) {
    var _a;
    var _b = __read(useState(null), 2), containerElement = _b[0], setContainerElement = _b[1];
    var availableWidth = useAvailableWidth(maxWidth === undefined ? containerElement : null);
    var width = (_a = maxWidth !== null && maxWidth !== void 0 ? maxWidth : availableWidth) !== null && _a !== void 0 ? _a : 0;
    var _c = useWidestCompositionForWidth(narrowToWideCompositionsProvider, width), items = _c.items, widestCompositionRef = _c.ref, clearCache = _c.clearCache;
    var ref = useCallback(function (element) {
        setRefValue(widestCompositionRef, element);
        setContainerElement(element);
    }, [widestCompositionRef]);
    return {
        items: items,
        ref: ref,
        clearCache: clearCache,
    };
}
