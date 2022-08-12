export function createPageWidthCalculator(_a) {
    var getActivePageWidth = _a.getActivePageWidth, getNormalPageWidth = _a.getNormalPageWidth;
    return function pageWidthCalculator(label, active) {
        return active ? getActivePageWidth(label) : getNormalPageWidth(label);
    };
}
