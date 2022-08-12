"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.useFoutDetector = void 0;
var react_1 = require("react");
var resize_observer_polyfill_1 = __importDefault(require("resize-observer-polyfill"));
var style_1 = require("../helpers/style");
function useFoutDetector(getElements, handleFout) {
    (0, react_1.useLayoutEffect)(function () {
        var elements = getElements();
        if (!elements)
            return;
        return setupWidthChangeAfterRenderListener(elements, handleFout);
    });
}
exports.useFoutDetector = useFoutDetector;
function setupWidthChangeAfterRenderListener(elements, handleWidthChangeAfterRender) {
    var getInitialWidth = createInitialWidthProvider(elements);
    var hasWidthChanged = function (element) {
        return isSignificantDifference(getInitialWidth(element), (0, style_1.getWidth)(element));
    };
    return setupResizeObserver(elements, function (maybeResizedElements) {
        if (maybeResizedElements.some(hasWidthChanged)) {
            handleWidthChangeAfterRender();
        }
    });
}
function createInitialWidthProvider(elements) {
    var initialWidths = elements.map(style_1.getWidth);
    return function getInitialWidth(element) {
        var index = elements.indexOf(element);
        return initialWidths[index];
    };
}
function setupResizeObserver(elements, handleElementsResized) {
    var resizeObserver = new resize_observer_polyfill_1.default(function (entries) {
        var elements = entries.map(getTargetElement);
        handleElementsResized(elements);
    });
    elements.forEach(function (element) { return resizeObserver.observe(element); });
    return function () { return resizeObserver.disconnect(); };
}
function getTargetElement(entry) {
    return entry.target;
}
function isSignificantDifference(width1, width2) {
    return Math.abs(width1 - width2) > 0.5;
}
