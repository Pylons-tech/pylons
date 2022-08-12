"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createWidthCalculator = void 0;
var totalWidthCalculator_1 = require("./totalWidthCalculator");
var itemWidthCalculator_1 = require("./itemWidthCalculator");
var navWidthCalculator_1 = require("./navWidthCalculator");
var pageWidthCalculator_1 = require("./pageWidthCalculator");
var numberWidthCalculator_1 = require("./numberWidthCalculator");
var compositionItem_1 = require("../compositionItem");
function createWidthCalculator(baseMetrics) {
    if (!baseMetrics) {
        return { requiredBaseMetrics: baseMetricItemsToMeasure };
    }
    return createGraph(baseMetrics);
}
exports.createWidthCalculator = createWidthCalculator;
function createGraph(baseMetrics) {
    var itemWidths = baseMetrics.itemWidths, outerFrameWidth = baseMetrics.outerFrameWidth;
    return (0, totalWidthCalculator_1.createTotalWidthCalculator)({
        getItemWidth: (0, itemWidthCalculator_1.createItemWidthCalculator)({
            getPageWidth: (0, pageWidthCalculator_1.createPageWidthCalculator)({
                getNormalPageWidth: (0, numberWidthCalculator_1.createNumberWidthCalculator)({
                    singleDigit: itemWidths.normalPageSingleDigit,
                    doubleDigit: itemWidths.normalPageDoubleDigit,
                }),
                getActivePageWidth: (0, numberWidthCalculator_1.createNumberWidthCalculator)({
                    singleDigit: itemWidths.activePageSingleDigit,
                    doubleDigit: itemWidths.activePageDoubleDigit,
                }),
            }),
            getNavWidth: (0, navWidthCalculator_1.createNavWidthCalculator)({
                '<': {
                    enabled: itemWidths.navPreviousEnabled,
                    disabled: itemWidths.navPreviousDisabled,
                },
                '>': {
                    enabled: itemWidths.navNextEnabled,
                    disabled: itemWidths.navNextDisabled,
                },
            }),
            ellipsisWidth: itemWidths.ellipsis,
        }),
        outerFrameWidth: outerFrameWidth,
    });
}
var baseMetricItemsToMeasure = {
    normalPageSingleDigit: (0, compositionItem_1.createPage)(8),
    normalPageDoubleDigit: (0, compositionItem_1.createPage)(88),
    activePageSingleDigit: (0, compositionItem_1.createActivePage)(8),
    activePageDoubleDigit: (0, compositionItem_1.createActivePage)(88),
    navPreviousEnabled: (0, compositionItem_1.createNavPrevious)(0),
    navPreviousDisabled: (0, compositionItem_1.createNavPrevious)(undefined),
    navNextEnabled: (0, compositionItem_1.createNavNext)(0),
    navNextDisabled: (0, compositionItem_1.createNavNext)(undefined),
    ellipsis: (0, compositionItem_1.createEllipsis)('L'),
};
