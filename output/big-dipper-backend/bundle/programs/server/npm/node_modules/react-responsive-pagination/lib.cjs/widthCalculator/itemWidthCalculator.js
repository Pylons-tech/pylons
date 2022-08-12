"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createItemWidthCalculator = void 0;
function createItemWidthCalculator(_a) {
    var getPageWidth = _a.getPageWidth, getNavWidth = _a.getNavWidth, ellipsisWidth = _a.ellipsisWidth;
    return function itemWidthCalculator(_a) {
        var type = _a.type, page = _a.page;
        if (type === 'page' || type === 'active') {
            return getPageWidth(page.toString(), type === 'active');
        }
        if (type === '<' || type === '>') {
            return getNavWidth(type, page !== undefined);
        }
        if (type === '…L' || type === '…R') {
            return ellipsisWidth;
        }
        var _exCheck = type;
        return _exCheck;
    };
}
exports.createItemWidthCalculator = createItemWidthCalculator;
