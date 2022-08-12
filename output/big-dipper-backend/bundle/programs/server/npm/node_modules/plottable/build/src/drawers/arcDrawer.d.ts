/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { SimpleSelection } from "../core/interfaces";
import { SVGDrawer } from "./svgDrawer";
export declare class ArcSVGDrawer extends SVGDrawer {
    constructor();
    protected _applyDefaultAttributes(selection: SimpleSelection<any>): void;
}
