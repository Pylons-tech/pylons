/**
 * Copyright 2017-present Palantir Technologies
 * @license MIT
 */
/**
 * This class keeps track of bucketing state while collapsing dense line
 * geometry in a line and area plots.
 */
export declare class Bucket {
    private bucketValue;
    private entryIndex;
    private exitIndex;
    private minValue;
    private maxValue;
    private minIndex;
    private maxIndex;
    constructor(index: number, xValue: number, yValue: number);
    isInBucket(value: number): boolean;
    addToBucket(value: number, index: number): void;
    getUniqueIndices(): number[];
}
