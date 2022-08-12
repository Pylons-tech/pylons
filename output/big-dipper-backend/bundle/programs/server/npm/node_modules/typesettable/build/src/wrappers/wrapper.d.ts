/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import * as Measurers from "../measurers";
export interface IWrappingResult {
    originalText: string;
    wrappedText: string;
    noLines: number;
    noBrokeWords: number;
    truncatedText: string;
}
export declare class Wrapper {
    _breakingCharacter: string;
    private _maxLines;
    private _textTrimming;
    private _allowBreakingWords;
    private _tokenizer;
    constructor();
    maxLines(): number;
    maxLines(noLines: number): Wrapper;
    textTrimming(): string;
    textTrimming(option: string): Wrapper;
    allowBreakingWords(): boolean;
    allowBreakingWords(allow: boolean): Wrapper;
    wrap(text: string, measurer: Measurers.AbstractMeasurer, width: number, height?: number): IWrappingResult;
    private breakLineToFitWidth(state, line, hasNextLine, measurer);
    private canFitToken(token, width, measurer);
    private addEllipsis(line, width, measurer);
    private wrapNextToken(token, state, measurer);
    private finishWrapping(token, state, measurer);
    /**
     * Breaks single token to fit current line.
     * If token contains only whitespaces then they will not be populated to next line.
     */
    private breakTokenToFitInWidth(token, line, availableWidth, measurer, breakingCharacter?);
}
