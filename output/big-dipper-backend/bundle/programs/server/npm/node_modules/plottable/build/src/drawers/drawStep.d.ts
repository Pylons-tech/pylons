/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { IAnimator } from "../animators/animator";
import { AttributeToAppliedProjector, AttributeToProjector } from "../core/interfaces";
/**
 * A step for the drawer to draw.
 *
 * Specifies how AttributeToProjector needs to be animated.
 */
export declare type DrawStep = {
    attrToProjector: AttributeToProjector;
    animator: IAnimator;
};
/**
 * A DrawStep that carries an AttributeToAppliedProjector map.
 */
export declare type AppliedDrawStep = {
    attrToAppliedProjector: AttributeToAppliedProjector;
    animator: IAnimator;
};
