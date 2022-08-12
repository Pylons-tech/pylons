/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import { Point, SpaceRequest } from "../core/interfaces";
import { Component } from "./component";
import { ComponentContainer } from "./componentContainer";
export declare class Group extends ComponentContainer {
    private _components;
    /**
     * Constructs a Group.
     *
     * A Group contains Components that will be rendered on top of each other.
     * Components added later will be rendered above Components already in the Group.
     *
     * @constructor
     * @param {Component[]} [components=[]] Components to be added to the Group.
     */
    constructor(components?: Component[]);
    protected _forEach(callback: (component: Component) => any): void;
    /**
     * Checks whether the specified Component is in the Group.
     */
    has(component: Component): boolean;
    requestedSpace(offeredWidth: number, offeredHeight: number): SpaceRequest;
    computeLayout(origin?: Point, availableWidth?: number, availableHeight?: number): this;
    protected _sizeFromOffer(availableWidth: number, availableHeight: number): {
        width: number;
        height: number;
    };
    fixedWidth(): boolean;
    fixedHeight(): boolean;
    /**
     * @return {Component[]} The Components in this Group.
     */
    components(): Component[];
    /**
     * Adds a Component to this Group.
     * The added Component will be rendered above Components already in the Group.
     */
    append(component: Component): this;
    protected _remove(component: Component): boolean;
}
