/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { Bounds, Point } from "../core/interfaces";
import { QuantitativeScale } from "../scales/quantitativeScale";
import { DragBoxLayer } from "./dragBoxLayer";
export declare class YDragBoxLayer extends DragBoxLayer {
    /**
     * A YDragBoxLayer is a DragBoxLayer whose size can only be set in the Y-direction.
     * The x-values of the bounds() are always set to 0 and the width() of the YDragBoxLayer.
     *
     * @constructor
     */
    constructor();
    computeLayout(origin?: Point, availableWidth?: number, availableHeight?: number): this;
    protected _setBounds(newBounds: Bounds): void;
    protected _setResizableClasses(canResize: boolean): void;
    xScale<D extends number | {
        valueOf(): number;
    }>(): QuantitativeScale<D>;
    xScale<D extends number | {
        valueOf(): number;
    }>(xScale: QuantitativeScale<D>): this;
    xExtent(): (number | {
        valueOf(): number;
    })[];
    xExtent(xExtent: (number | {
        valueOf(): number;
    })[]): this;
}
