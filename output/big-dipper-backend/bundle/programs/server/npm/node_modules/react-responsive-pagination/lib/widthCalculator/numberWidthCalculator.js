export function createNumberWidthCalculator(widths) {
    return function numberWidthCalculator(label) {
        var numDigits = label.length;
        return (widths.singleDigit +
            (widths.doubleDigit - widths.singleDigit) * (numDigits - 1));
    };
}
