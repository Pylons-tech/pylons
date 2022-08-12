"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useAvailableWidth = void 0;
var useContentWidth_1 = require("./useContentWidth");
function useAvailableWidth(element) {
    var _a;
    return (0, useContentWidth_1.useContentWidth)((_a = element === null || element === void 0 ? void 0 : element.parentElement) !== null && _a !== void 0 ? _a : undefined);
}
exports.useAvailableWidth = useAvailableWidth;
