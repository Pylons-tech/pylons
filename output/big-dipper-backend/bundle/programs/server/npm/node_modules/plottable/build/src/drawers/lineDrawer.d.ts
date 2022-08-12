/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import * as d3 from "d3";
import { SimpleSelection } from "../core/interfaces";
import { CanvasDrawStep } from "./canvasDrawer";
import { SVGDrawer } from "./svgDrawer";
export declare class LineSVGDrawer extends SVGDrawer {
    constructor();
    protected _applyDefaultAttributes(selection: SimpleSelection<any>): void;
    getVisualPrimitiveAtIndex(index: number): Element;
}
/**
 * @param d3LineFactory A callback that gives this Line Drawer a d3.Line object which will be
 * used to draw with.
 *
 * TODO put the d3.Line into the attrToAppliedProjector directly
 */
export declare function makeLineCanvasDrawStep(d3LineFactory: () => d3.Line<any>): CanvasDrawStep;
