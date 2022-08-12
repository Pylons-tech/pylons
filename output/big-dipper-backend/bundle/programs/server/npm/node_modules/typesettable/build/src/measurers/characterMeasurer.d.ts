/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IDimensions } from "./abstractMeasurer";
import { Measurer } from "./measurer";
export declare class CharacterMeasurer extends Measurer {
    _measureCharacter(c: string): IDimensions;
    _measureLine(line: string): IDimensions;
}
