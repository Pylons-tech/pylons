"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createNumberWidthCalculator = void 0;
function createNumberWidthCalculator(widths) {
    return function numberWidthCalculator(label) {
        var numDigits = label.length;
        return (widths.singleDigit +
            (widths.doubleDigit - widths.singleDigit) * (numDigits - 1));
    };
}
exports.createNumberWidthCalculator = createNumberWidthCalculator;
