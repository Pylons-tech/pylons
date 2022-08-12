import { useLayoutEffect } from 'react';
import ResizeObserver from 'resize-observer-polyfill';
import { getWidth } from '../helpers/style';
export function useFoutDetector(getElements, handleFout) {
    useLayoutEffect(function () {
        var elements = getElements();
        if (!elements)
            return;
        return setupWidthChangeAfterRenderListener(elements, handleFout);
    });
}
function setupWidthChangeAfterRenderListener(elements, handleWidthChangeAfterRender) {
    var getInitialWidth = createInitialWidthProvider(elements);
    var hasWidthChanged = function (element) {
        return isSignificantDifference(getInitialWidth(element), getWidth(element));
    };
    return setupResizeObserver(elements, function (maybeResizedElements) {
        if (maybeResizedElements.some(hasWidthChanged)) {
            handleWidthChangeAfterRender();
        }
    });
}
function createInitialWidthProvider(elements) {
    var initialWidths = elements.map(getWidth);
    return function getInitialWidth(element) {
        var index = elements.indexOf(element);
        return initialWidths[index];
    };
}
function setupResizeObserver(elements, handleElementsResized) {
    var resizeObserver = new ResizeObserver(function (entries) {
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
