"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createNavWidthCalculator = void 0;
function createNavWidthCalculator(widths) {
    return function navWidthCalculator(type, enabled) {
        var widthsForType = widths[type];
        return enabled ? widthsForType.enabled : widthsForType.disabled;
    };
}
exports.createNavWidthCalculator = createNavWidthCalculator;
