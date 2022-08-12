import { useContentWidth } from './useContentWidth';
export function useAvailableWidth(element) {
    var _a;
    return useContentWidth((_a = element === null || element === void 0 ? void 0 : element.parentElement) !== null && _a !== void 0 ? _a : undefined);
}
