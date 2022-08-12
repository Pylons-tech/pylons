"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTotalWidthCalculator = void 0;
var util_1 = require("../helpers/util");
function createTotalWidthCalculator(_a) {
    var getItemWidth = _a.getItemWidth, outerFrameWidth = _a.outerFrameWidth;
    return function widthCalculator(items) {
        var itemWidths = items.map(getItemWidth);
        var contentWidth = (0, util_1.sum)(itemWidths);
        return outerFrameWidth + contentWidth;
    };
}
exports.createTotalWidthCalculator = createTotalWidthCalculator;
