export function createNavWidthCalculator(widths) {
    return function navWidthCalculator(type, enabled) {
        var widthsForType = widths[type];
        return enabled ? widthsForType.enabled : widthsForType.disabled;
    };
}
