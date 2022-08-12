/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { Point } from "../core/interfaces";
import * as Plots from "../plots";
import { Component } from "./component";
import { Group } from "./group";
export declare class PlotGroup extends Group {
    entityNearest(point: Point): Plots.IPlotEntity;
    /**
     * Adds a Plot to this Plot Group.
     * The added Plot will be rendered above Plots already in the Group.
     */
    append(plot: Component): this;
}
