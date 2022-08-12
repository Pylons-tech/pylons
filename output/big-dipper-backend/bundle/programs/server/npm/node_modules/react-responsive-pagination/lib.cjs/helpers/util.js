"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sanatizeInteger = exports.sum = exports.isNumber = void 0;
function isNumber(val) {
    return typeof val === 'number';
}
exports.isNumber = isNumber;
function sum(items) {
    return items.reduce(function (acc, width) { return acc + width; }, 0);
}
exports.sum = sum;
function sanatizeInteger(maybeInteger) {
    return typeof maybeInteger === 'number' && Number.isInteger(maybeInteger)
        ? maybeInteger
        : 0;
}
exports.sanatizeInteger = sanatizeInteger;
