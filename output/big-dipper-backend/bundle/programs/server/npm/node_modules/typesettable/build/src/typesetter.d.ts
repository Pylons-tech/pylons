/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { ICanvasFontStyle, ITypesetterContext } from "./contexts";
import { CacheMeasurer } from "./measurers";
import { Wrapper } from "./wrappers";
import { IWriteOptions, Writer } from "./writers";
/**
 * This is a convenience interface for typesetting strings using the default
 * measurer/wrapper/writer setup.
 */
export declare class Typesetter {
    private context;
    static svg(element: SVGElement, className?: string, addTitleElement?: boolean): Typesetter;
    static canvas(ctx: CanvasRenderingContext2D, lineHeight?: number, style?: ICanvasFontStyle): Typesetter;
    static html(element: HTMLElement, className?: string, addTitle?: boolean): Typesetter;
    measurer: CacheMeasurer;
    wrapper: Wrapper;
    writer: Writer;
    constructor(context: ITypesetterContext<any>);
    /**
     * Wraps the given string into the width/height and writes it into the
     * canvas or SVG (depending on context).
     *
     * Delegates to `Writer.write` using the internal `ITypesetterContext`.
     */
    write(text: string, width: number, height: number, options?: IWriteOptions, into?: any): void;
    /**
     * Clears the `Measurer`'s CacheMeasurer.
     *
     * Call this if your font style changee in SVG.
     */
    clearMeasurerCache(): void;
}
