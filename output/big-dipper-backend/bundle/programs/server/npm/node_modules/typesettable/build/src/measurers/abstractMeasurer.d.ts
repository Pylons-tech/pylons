/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IRulerFactoryContext } from "../contexts";
/**
 * Width and height of a span of text.
 */
export interface IDimensions {
    width: number;
    height: number;
}
/**
 * A method that returns the screen-space dimensions of a string of text. The
 * text is assumed to be a single span without line breaks.
 */
export declare type IRuler = (text: string) => IDimensions;
export declare type IRulerFactory = () => IRuler;
export declare class AbstractMeasurer {
    /**
     * A string representing the full ascender/descender range of your text.
     *
     * Note that this is really only applicable to western alphabets. If you are
     * using a different locale language such as arabic or chinese, you may want
     * to override this.
     */
    static HEIGHT_TEXT: string;
    private ruler;
    constructor(ruler: IRuler | IRulerFactoryContext);
    measure(text?: string): IDimensions;
}
