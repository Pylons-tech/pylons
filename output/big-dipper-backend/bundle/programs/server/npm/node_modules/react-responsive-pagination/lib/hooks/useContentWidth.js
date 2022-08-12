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
import { useState, useLayoutEffect } from 'react';
import { getContentWidth } from '../helpers/style';
import { useResizeNotifier } from './useResizeNotifier';
export function useContentWidth(element) {
    var _a = __read(useState(), 2), width = _a[0], setWidth = _a[1];
    function syncWidth() {
        var newWidth = element ? getContentWidth(element) : undefined;
        if (width !== newWidth) {
            setWidth(newWidth);
        }
    }
    useResizeNotifier(element, syncWidth);
    useLayoutEffect(syncWidth);
    return width;
}
