"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useWidestCompositionForWidth = void 0;
var react_1 = require("react");
var iterator_1 = require("../helpers/iterator");
var useWidthCalculator_1 = require("./useWidthCalculator");
var useFoutDetector_1 = require("./useFoutDetector");
function useWidestCompositionForWidth(narrowToWideCompositionsProvider, maxWidth) {
    var widthCalculator = (0, useWidthCalculator_1.useWidthCalculator)();
    var containerElementRef = (0, react_1.useRef)(null);
    var clearCache = widthCalculator.clearCache;
    (0, useFoutDetector_1.useFoutDetector)(function () { return getItemsDomElements(containerElementRef.current); }, clearCache);
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
exports.useWidestCompositionForWidth = useWidestCompositionForWidth;
function getLargestFittingCompositionWithFallback(getNarrowToWideCompositions, getCompositionWidth, maxWidth) {
    var _a, _b;
    var narrowToWideCompositions = getNarrowToWideCompositions();
    var firstComposition = (_a = (0, iterator_1.iteratorNext)(narrowToWideCompositions)) !== null && _a !== void 0 ? _a : [];
    var doesCompositionFit = function (composition) {
        return getCompositionWidth(composition) < maxWidth;
    };
    return (_b = (0, iterator_1.lastWhere)(narrowToWideCompositions, doesCompositionFit)) !== null && _b !== void 0 ? _b : firstComposition;
}
function getItemsDomElements(viewDomElement) {
    return viewDomElement && Array.from(viewDomElement.children);
}
