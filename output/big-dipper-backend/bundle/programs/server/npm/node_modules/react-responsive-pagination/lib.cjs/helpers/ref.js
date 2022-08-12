"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setRefValue = void 0;
function setRefValue(ref, value) {
    if (typeof ref === 'function') {
        ref(value);
    }
    else if (ref) {
        ref.current = value;
    }
}
exports.setRefValue = setRefValue;
