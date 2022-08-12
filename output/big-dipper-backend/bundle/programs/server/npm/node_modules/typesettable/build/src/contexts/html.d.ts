/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IDimensions } from "../measurers";
import { ITransform, IXAlign } from "../writers";
import { ITypesetterContext } from "./index";
export declare class HtmlUtils {
    /**
     * Appends an HTML element with the specified tag name to the provided element.
     * The variadic classnames are added to the new element.
     *
     * Returns the new element.
     */
    static append(element: Element, tagName: string, ...classNames: string[]): HTMLElement;
    /**
     * Creates and returns a new HTMLElement with the attached classnames.
     */
    static create(tagName: string, ...classNames: string[]): HTMLElement;
    /**
     * Adds the variadic classnames to the Element
     */
    static addClasses(element: Element, ...classNames: string[]): void;
    /**
     * Returns the width/height of HTMLElement's bounding box
     */
    static getDimensions(element: HTMLElement): IDimensions;
}
/**
 * A typesetter context for HTML.
 */
export declare class HtmlContext implements ITypesetterContext<HTMLElement> {
    private element;
    private className;
    private addTitle;
    /**
     * @param element - The CSS font styles applied to `element` will determine the
     * size of text measurements. Also the default text block container.
     * @param className - added to new text blocks
     * @param addTitle - enable title attribute to be added to new text blocks.
     */
    constructor(element: HTMLElement, className?: string, addTitle?: boolean);
    setAddTitle(addTitle: boolean): void;
    createRuler: () => (text: string) => IDimensions;
    createPen: (text: string, transform: ITransform, element?: Element) => {
        write: (line: string, width: number, xAlign: IXAlign, xOffset: number, yOffset: number) => void;
    };
    private createHtmlLinePen(textBlock);
}
