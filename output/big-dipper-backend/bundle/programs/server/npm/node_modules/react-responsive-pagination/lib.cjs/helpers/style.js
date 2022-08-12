"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getWidth = exports.getNonContentWidth = exports.getContentWidth = exports.getElementWidth = void 0;
function getElementWidth(element) {
    var style = getComputedStyle(element);
    return (styleMetricToInt(style.marginLeft) +
        getWidth(element) +
        styleMetricToInt(style.marginRight));
}
exports.getElementWidth = getElementWidth;
function getContentWidth(element) {
    var style = getComputedStyle(element);
    return (element.getBoundingClientRect().width -
        styleMetricToInt(style.borderLeftWidth) -
        styleMetricToInt(style.paddingLeft) -
        styleMetricToInt(style.paddingRight) -
        styleMetricToInt(style.borderRightWidth));
}
exports.getContentWidth = getContentWidth;
function getNonContentWidth(element) {
    var style = getComputedStyle(element);
    return (styleMetricToInt(style.marginLeft) +
        styleMetricToInt(style.borderLeftWidth) +
        styleMetricToInt(style.paddingLeft) +
        styleMetricToInt(style.paddingRight) +
        styleMetricToInt(style.borderRightWidth) +
        styleMetricToInt(style.marginRight));
}
exports.getNonContentWidth = getNonContentWidth;
function getWidth(element) {
    return element.getBoundingClientRect().width;
}
exports.getWidth = getWidth;
function styleMetricToInt(styleAttribute) {
    return styleAttribute ? parseInt(styleAttribute) : 0;
}
