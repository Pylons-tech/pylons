/**
 * Copyright 2017-present Palantir Technologies, Inc. All rights reserved.
 * Licensed under the MIT License (the "License"); you may obtain a copy of the
 * license at https://github.com/palantir/typesettable/blob/develop/LICENSE
 */
import { IRulerFactoryContext } from "../contexts";
import { IDimensions, IRuler } from "./abstractMeasurer";
import { CacheCharacterMeasurer } from "./cacheCharacterMeasurer";
export declare class CacheMeasurer extends CacheCharacterMeasurer {
    private dimCache;
    constructor(ruler: IRuler | IRulerFactoryContext);
    _measureNotFromCache(s: string): IDimensions;
    measure(s?: string): IDimensions;
    reset(): void;
}
