"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createPageWidthCalculator = void 0;
function createPageWidthCalculator(_a) {
    var getActivePageWidth = _a.getActivePageWidth, getNormalPageWidth = _a.getNormalPageWidth;
    return function pageWidthCalculator(label, active) {
        return active ? getActivePageWidth(label) : getNormalPageWidth(label);
    };
}
exports.createPageWidthCalculator = createPageWidthCalculator;
