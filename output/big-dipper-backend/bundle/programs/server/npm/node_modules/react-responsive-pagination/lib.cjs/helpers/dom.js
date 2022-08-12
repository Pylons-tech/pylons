"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.preventDefault = void 0;
function preventDefault(handler) {
    return function (e) {
        e.preventDefault();
        handler();
    };
}
exports.preventDefault = preventDefault;
