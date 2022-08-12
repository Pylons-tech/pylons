/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IPenFactoryContext } from "../contexts";
import { AbstractMeasurer } from "../measurers";
import { Wrapper } from "../wrappers";
export declare type IXAlign = "left" | "center" | "right";
export declare type IYAlign = "top" | "center" | "bottom";
/**
 * A euclidean transformation, which preserves the size of text and only affects
 * location and orientation.
 */
export interface ITransform {
    /**
     * Translation in pixels.
     */
    translate: [number, number];
    /**
     * Rotation in degrees.
     */
    rotate: number;
}
export interface IPen {
    /**
     * Called once all the lines have been written
     */
    destroy?: () => void;
    /**
     * Called once for each line of text in the block.
     *
     * `xOffset` and `yOffset` are assumed to be in an independent text-aligned
     * coordinate space.
     */
    write: (line: string, width: number, anchor: IXAlign, xOffset: number, yOffset: number) => void;
}
/**
 * A factory method that sets up a line pen for a new block of text. This method
 * will receive a transform that needs to be applied to the whole text block.
 *
 * You may optionally pass the final `container` argument to specify the parent
 * into which the text is written. This allows you to easily share cached
 * measurer results while writing text into multiple SVG elements or Canvas
 * contexts. Use this ONLY if you are certain the font styles will match those
 * used by the `Measurer`'s `IRuler`.
 *
 * The returned `IPen` will be used render each line in the block.
 */
export declare type IPenFactory<T> = (text: string, transform: ITransform, container?: T) => IPen;
export interface IWriteOptions {
    /**
     * An optional cardinal-direction rotation for the whole text block.
     *
     * Supported rotations are -90, 0, 180, and 90.
     *
     * @default 0
     */
    textRotation?: number;
    /**
     * An optional shear angle. Shearing allows the rotation and re-alignment of
     * individual lines as opposed to the whole text block.
     *
     * Supported shears are between -80 and 80 degrees.
     *
     * @default 0
     */
    textShear?: number;
    /**
     * The x-alignment of text.
     *
     * @default "left"
     */
    xAlign?: IXAlign;
    /**
     * The y-alignment of text.
     *
     * @default "top"
     */
    yAlign?: IYAlign;
}
export declare class Writer {
    private _measurer;
    private _penFactory;
    private _wrapper;
    static XOffsetFactor: {
        [K in IXAlign]: number;
    };
    static YOffsetFactor: {
        [K in IYAlign]: number;
    };
    private static SupportedRotation;
    constructor(_measurer: AbstractMeasurer, _penFactory: IPenFactoryContext<any>, _wrapper?: Wrapper);
    measurer(newMeasurer: AbstractMeasurer): Writer;
    wrapper(newWrapper: Wrapper): Writer;
    penFactory(newPenFactory: IPenFactoryContext<any>): Writer;
    /**
     * Writes the text into the container. If no container is specified, the pen's
     * default container will be used.
     */
    write<T>(text: string, width: number, height: number, options?: IWriteOptions, container?: T): void;
    private writeLines(lines, linePen, width, lineHeight, shearShift, xAlign);
}
