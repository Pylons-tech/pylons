export function preventDefault(handler) {
    return function (e) {
        e.preventDefault();
        handler();
    };
}
