/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
export declare class StringMethods {
    /**
     * Treat all sequences of consecutive spaces as a single " ".
     */
    static combineWhitespace(str: string): string;
    static isNotEmptyString(str: string): boolean;
    static trimStart(str: string, splitter?: string): string;
    static trimEnd(str: string, c?: string): string;
}
