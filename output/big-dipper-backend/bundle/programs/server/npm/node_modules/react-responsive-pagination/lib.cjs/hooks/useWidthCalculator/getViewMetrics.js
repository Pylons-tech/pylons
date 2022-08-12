"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getViewMetricsFromContainer = void 0;
var object_1 = require("../../helpers/object");
var style_1 = require("../../helpers/style");
function getViewMetricsFromContainer(containerElement, itemKeys) {
    var itemElements = Array.from(containerElement.children);
    return {
        outerFrameWidth: (0, style_1.getNonContentWidth)(containerElement),
        itemWidths: getItemWidthsFromItemDomElements(itemKeys, itemElements),
    };
}
exports.getViewMetricsFromContainer = getViewMetricsFromContainer;
function getItemWidthsFromItemDomElements(itemKeys, itemElements) {
    var itemWidths = itemElements.map(style_1.getElementWidth);
    return (0, object_1.objectZip)(itemKeys, itemWidths);
}
