import { useLayoutEffect, useRef } from 'react';
import ResizeObserver from 'resize-observer-polyfill';
export function useResizeNotifier(element, callback) {
    var callBackRef = useRef(callback);
    useLayoutEffect(function () {
        callBackRef.current = callback;
    }, [callback]);
    useLayoutEffect(function () {
        if (!element)
            return;
        var resizeObserver = new ResizeObserver(withResizeLoopDetection(function () {
            callBackRef.current();
        }));
        resizeObserver.observe(element);
        return function () {
            resizeObserver.disconnect();
        };
    }, [element]);
}
function withResizeLoopDetection(callback) {
    return function (entries, resizeObserver) {
        var elements = entries.map(function (entry) { return entry.target; });
        var rectsBefore = elements.map(function (element) { return element.getBoundingClientRect(); });
        callback();
        var rectsAfter = elements.map(function (element) { return element.getBoundingClientRect(); });
        var changedElements = elements.filter(function (_, i) { return !areRectSizesEqual(rectsBefore[i], rectsAfter[i]); });
        changedElements.forEach(function (element) {
            return unobserveUntilNextFrame(element, resizeObserver);
        });
    };
}
function unobserveUntilNextFrame(element, resizeObserver) {
    resizeObserver.unobserve(element);
    requestAnimationFrame(function () {
        resizeObserver.observe(element);
    });
}
function areRectSizesEqual(rect1, rect2) {
    return rect1.width === rect2.width && rect1.height === rect2.height;
}
