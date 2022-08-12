/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IRulerFactoryContext } from "../contexts";
import { IDimensions, IRuler } from "./abstractMeasurer";
import { CharacterMeasurer } from "./characterMeasurer";
export declare class CacheCharacterMeasurer extends CharacterMeasurer {
    private cache;
    constructor(ruler: IRuler | IRulerFactoryContext, useGuards?: boolean);
    _measureCharacterNotFromCache(c: string): IDimensions;
    _measureCharacter(c: string): IDimensions;
    reset(): void;
}
