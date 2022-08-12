/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { AttributeToAppliedProjector, SimpleSelection } from "../core/interfaces";
import { IAnimator } from "./animator";
/**
 * An animator implementation with no animation. The attributes are
 * immediately set on the selection.
 */
export declare class Null implements IAnimator {
    totalTime(selection: any): number;
    animate(selection: SimpleSelection<any>, attrToAppliedProjector: AttributeToAppliedProjector): SimpleSelection<any>;
}
