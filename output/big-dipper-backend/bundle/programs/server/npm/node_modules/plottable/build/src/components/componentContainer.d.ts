/**
 * Copyright 2014-present Palantir Technologies
 * @license MIT
 */
import * as d3 from "d3";
import { Component } from "./component";
export declare class ComponentContainer extends Component {
    private _detachCallback;
    constructor();
    anchor(selection: d3.Selection<HTMLElement, any, any, any>): this;
    render(): this;
    /**
     * Checks whether the specified Component is in the ComponentContainer.
     */
    has(component: Component): boolean;
    protected _adoptAndAnchor(component: Component): void;
    /**
     * Removes the specified Component from the ComponentContainer.
     */
    remove(component: Component): this;
    /**
     * Carry out the actual removal of a Component.
     * Implementation dependent on the type of container.
     *
     * @return {boolean} true if the Component was successfully removed, false otherwise.
     */
    protected _remove(component: Component): boolean;
    /**
     * Invokes a callback on each Component in the ComponentContainer.
     */
    protected _forEach(callback: (component: Component) => void): void;
    /**
     * Destroys the ComponentContainer and all Components within it.
     */
    destroy(): void;
    invalidateCache(): void;
}
