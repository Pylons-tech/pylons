/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { ITransform, IXAlign } from "../writers";
import { ITypesetterContext } from "./index";
/**
 * Options for styling text
 */
export interface ICanvasFontStyle {
    /**
     * An optional fill color.
     *
     * If `null` the text will not be filled. But, if `undefined` we will
     * default to `#444` filled text.
     */
    fill?: string;
    /**
     * An optional CSS font string.
     *
     * If `null` or `undefined`, we will not set the font before writing text,
     * but there may already be a font style defined on the canvas rendering
     * context.
     */
    font?: string;
    /**
     * An optional stroke color.
     *
     * If `null` or `undefined` the text will not be stroked.
     */
    stroke?: string;
}
/**
 * A typesetter context for HTML5 Canvas.
 *
 * Due to the Canvas API, you must explicitly define the line height, and any
 * styling for the font must also be explicitly defined in the optional
 * `ICanvasFontStyle` object.
 */
export declare class CanvasContext implements ITypesetterContext<CanvasRenderingContext2D> {
    private ctx;
    private lineHeight;
    private style;
    constructor(ctx: CanvasRenderingContext2D, lineHeight?: number, style?: ICanvasFontStyle);
    createRuler: () => (text: string) => {
        width: number;
        height: number;
    };
    createPen: (_text: string, transform: ITransform, ctx?: CanvasRenderingContext2D) => {
        destroy: () => void;
        write: (line: string, width: number, xAlign: IXAlign, xOffset: number, yOffset: number) => void;
    };
    private createCanvasPen(ctx);
}
