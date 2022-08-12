/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
export declare class Methods {
    /**
     * Check if two arrays are equal by strict equality.
     */
    static arrayEq<T>(a: T[], b: T[]): boolean;
    /**
     * @param {any} a Object to check against b for equality.
     * @param {any} b Object to check against a for equality.
     *
     * @returns {boolean} whether or not two objects share the same keys, and
     *          values associated with those keys. Values will be compared
     *          with ===.
     */
    static objEq(a: any, b: any): boolean;
    static strictEq(a: any, b: any): boolean;
    /**
     * Shim for _.defaults
     */
    static defaults(target: any, ...objects: any[]): any;
}
