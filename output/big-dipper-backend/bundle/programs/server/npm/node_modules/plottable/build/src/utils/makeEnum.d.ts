/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
export declare function makeEnum<T extends string>(values: T[]): {
    [K in T]: K;
};
