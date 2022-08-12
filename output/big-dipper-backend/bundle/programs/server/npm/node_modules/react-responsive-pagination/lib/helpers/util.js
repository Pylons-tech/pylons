export function isNumber(val) {
    return typeof val === 'number';
}
export function sum(items) {
    return items.reduce(function (acc, width) { return acc + width; }, 0);
}
export function sanatizeInteger(maybeInteger) {
    return typeof maybeInteger === 'number' && Number.isInteger(maybeInteger)
        ? maybeInteger
        : 0;
}
