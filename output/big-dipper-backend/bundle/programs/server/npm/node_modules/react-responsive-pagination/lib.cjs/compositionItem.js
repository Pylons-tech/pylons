"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isEllipsis = exports.isNav = exports.createEllipsis = exports.createNavNext = exports.createNavPrevious = exports.createPage = exports.createActivePage = void 0;
function createActivePage(page) {
    return { type: 'active', page: page };
}
exports.createActivePage = createActivePage;
function createPage(page) {
    return { type: 'page', page: page };
}
exports.createPage = createPage;
function createNavPrevious(page) {
    return { type: '<', page: page };
}
exports.createNavPrevious = createNavPrevious;
function createNavNext(page) {
    return { type: '>', page: page };
}
exports.createNavNext = createNavNext;
function createEllipsis(ellipsisPos) {
    return { type: "\u2026".concat(ellipsisPos), page: undefined };
}
exports.createEllipsis = createEllipsis;
function isNav(item) {
    return item.type === '<' || item.type === '>';
}
exports.isNav = isNav;
function isEllipsis(item) {
    return item.type === '…L' || item.type === '…R';
}
exports.isEllipsis = isEllipsis;
