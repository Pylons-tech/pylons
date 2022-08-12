/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
export declare class Tokenizer {
    private WordDividerRegExp;
    private WhitespaceRegExp;
    tokenize(line: string): string[];
    private shouldCreateNewToken(token, newCharacter);
}
