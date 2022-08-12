"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.useResizeNotifier = void 0;
var react_1 = require("react");
var resize_observer_polyfill_1 = __importDefault(require("resize-observer-polyfill"));
function useResizeNotifier(element, callback) {
    var callBackRef = (0, react_1.useRef)(callback);
    (0, react_1.useLayoutEffect)(function () {
        callBackRef.current = callback;
    }, [callback]);
    (0, react_1.useLayoutEffect)(function () {
        if (!element)
            return;
        var resizeObserver = new resize_observer_polyfill_1.default(withResizeLoopDetection(function () {
            callBackRef.current();
        }));
        resizeObserver.observe(element);
        return function () {
            resizeObserver.disconnect();
        };
    }, [element]);
}
exports.useResizeNotifier = useResizeNotifier;
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
