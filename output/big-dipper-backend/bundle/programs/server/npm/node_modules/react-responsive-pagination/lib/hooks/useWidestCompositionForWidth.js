import { useRef } from 'react';
import { lastWhere, iteratorNext } from '../helpers/iterator';
import { useWidthCalculator } from './useWidthCalculator';
import { useFoutDetector } from './useFoutDetector';
export function useWidestCompositionForWidth(narrowToWideCompositionsProvider, maxWidth) {
    var widthCalculator = useWidthCalculator();
    var containerElementRef = useRef(null);
    var clearCache = widthCalculator.clearCache;
    useFoutDetector(function () { return getItemsDomElements(containerElementRef.current); }, clearCache);
    if ('renderNeeded' in widthCalculator) {
        return {
            items: widthCalculator.renderNeeded.items,
            ref: function (containerElement) {
                widthCalculator.renderNeeded.ref(containerElement);
                containerElementRef.current = containerElement;
            },
            clearCache: clearCache,
        };
    }
    else {
        return {
            items: getLargestFittingCompositionWithFallback(narrowToWideCompositionsProvider, widthCalculator.calculator, maxWidth),
            ref: containerElementRef,
            clearCache: clearCache,
        };
    }
}
function getLargestFittingCompositionWithFallback(getNarrowToWideCompositions, getCompositionWidth, maxWidth) {
    var _a, _b;
    var narrowToWideCompositions = getNarrowToWideCompositions();
    var firstComposition = (_a = iteratorNext(narrowToWideCompositions)) !== null && _a !== void 0 ? _a : [];
    var doesCompositionFit = function (composition) {
        return getCompositionWidth(composition) < maxWidth;
    };
    return (_b = lastWhere(narrowToWideCompositions, doesCompositionFit)) !== null && _b !== void 0 ? _b : firstComposition;
}
function getItemsDomElements(viewDomElement) {
    return viewDomElement && Array.from(viewDomElement.children);
}
