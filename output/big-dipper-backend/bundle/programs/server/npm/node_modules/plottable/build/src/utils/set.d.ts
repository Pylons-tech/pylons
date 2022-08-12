/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
/**
 * Shim for ES6 set.
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
 */
export declare class Set<T> {
    size: number;
    private _values;
    private _es6Set;
    constructor();
    add(value: T): this;
    delete(value: T): boolean;
    has(value: T): boolean;
    forEach(callback: (value: T, value2: T, set: Set<T>) => void, thisArg?: any): void;
}
