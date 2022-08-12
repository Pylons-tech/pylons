import { objectZip } from '../../helpers/object';
import { getNonContentWidth, getElementWidth } from '../../helpers/style';
export function getViewMetricsFromContainer(containerElement, itemKeys) {
    var itemElements = Array.from(containerElement.children);
    return {
        outerFrameWidth: getNonContentWidth(containerElement),
        itemWidths: getItemWidthsFromItemDomElements(itemKeys, itemElements),
    };
}
function getItemWidthsFromItemDomElements(itemKeys, itemElements) {
    var itemWidths = itemElements.map(getElementWidth);
    return objectZip(itemKeys, itemWidths);
}
