/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import * as Measurers from "../measurers";
import { IWrappingResult, Wrapper } from "./wrapper";
export declare class SingleLineWrapper extends Wrapper {
    private static NO_WRAP_ITERATIONS;
    wrap(text: string, measurer: Measurers.AbstractMeasurer, width: number, height?: number): IWrappingResult;
    private areSameResults(one, two);
}
