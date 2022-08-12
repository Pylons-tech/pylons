/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IRulerFactoryContext } from "../contexts";
import { AbstractMeasurer, IDimensions, IRuler } from "./abstractMeasurer";
export declare class Measurer extends AbstractMeasurer {
    private guardWidth;
    private useGuards;
    constructor(ruler: IRuler | IRulerFactoryContext, useGuards?: boolean);
    _addGuards(text: string): string;
    _measureLine(line: string, forceGuards?: boolean): IDimensions;
    measure(text?: string): IDimensions;
    private getGuardWidth();
}
