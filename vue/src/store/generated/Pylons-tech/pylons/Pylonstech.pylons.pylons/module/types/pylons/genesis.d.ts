import { Writer, Reader } from 'protobufjs/minimal';
import { Params } from '../pylons/params';
import { GoogleInAppPurchaseOrder } from '../pylons/google_iap_order';
import { Execution } from '../pylons/execution';
import { Item } from '../pylons/item';
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
/** GenesisState defines the pylons module's genesis state. */
export interface GenesisState {
    /** this line is used by starport scaffolding # genesis/proto/state */
    entityCount: number;
    params: Params | undefined;
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    googleInAppPurchaseOrderList: GoogleInAppPurchaseOrder[];
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    googleIAPOrderCount: number;
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    executionList: Execution[];
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    executionCount: number;
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    pendingExecutionList: Execution[];
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    pendingExecutionCount: number;
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    itemList: Item[];
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    recipeList: Recipe[];
    /** this line is used by starport scaffolding # genesis/proto/stateField */
    cookbookList: Cookbook[];
}
export declare const GenesisState: {
    encode(message: GenesisState, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GenesisState;
    fromJSON(object: any): GenesisState;
    toJSON(message: GenesisState): unknown;
    fromPartial(object: DeepPartial<GenesisState>): GenesisState;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
