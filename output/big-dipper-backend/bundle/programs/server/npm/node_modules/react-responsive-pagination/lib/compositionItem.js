export function createActivePage(page) {
    return { type: 'active', page: page };
}
export function createPage(page) {
    return { type: 'page', page: page };
}
export function createNavPrevious(page) {
    return { type: '<', page: page };
}
export function createNavNext(page) {
    return { type: '>', page: page };
}
export function createEllipsis(ellipsisPos) {
    return { type: "\u2026".concat(ellipsisPos), page: undefined };
}
export function isNav(item) {
    return item.type === '<' || item.type === '>';
}
export function isEllipsis(item) {
    return item.type === '…L' || item.type === '…R';
}
