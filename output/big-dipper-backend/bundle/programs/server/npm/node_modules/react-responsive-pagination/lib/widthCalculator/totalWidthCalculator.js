import { sum } from '../helpers/util';
export function createTotalWidthCalculator(_a) {
    var getItemWidth = _a.getItemWidth, outerFrameWidth = _a.outerFrameWidth;
    return function widthCalculator(items) {
        var itemWidths = items.map(getItemWidth);
        var contentWidth = sum(itemWidths);
        return outerFrameWidth + contentWidth;
    };
}
