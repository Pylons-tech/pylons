/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { QuantitativeScale } from "../scales/quantitativeScale";
/**
 * Generates an array of tick values for the specified scale.
 *
 * @param {QuantitativeScale} scale
 * @returns {D[]}
 */
export interface ITickGenerator<D> {
    (scale: QuantitativeScale<D>): D[];
}
/**
 * Creates a TickGenerator using the specified interval.
 *
 * Generates ticks at multiples of the interval while also including the domain boundaries.
 *
 * @param {number} interval
 * @returns {TickGenerator}
 */
export declare function intervalTickGenerator(interval: number): ITickGenerator<number>;
/**
 * Creates a TickGenerator returns only integer tick values.
 *
 * @returns {TickGenerator}
 */
export declare function integerTickGenerator(): ITickGenerator<number>;
