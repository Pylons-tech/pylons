import { Reader, Writer } from 'protobufjs/minimal';
import { Coin } from '../cosmos/base/v1beta1/coin';
import { ItemInput, EntriesList, WeightedOutputs } from '../pylons/recipe';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgExecuteRecipe {
    creator: string;
    cookbookID: string;
    recipeID: string;
    itemIDs: string[];
}
export interface MsgExecuteRecipeResponse {
    ID: number;
}
export interface MsgSetItemString {
    creator: string;
    cookbookID: string;
    recipeID: string;
    ID: string;
    field: string;
    value: string;
}
export interface MsgSetItemStringResponse {
}
export interface MsgCreateRecipe {
    creator: string;
    cookbookID: string;
    ID: string;
    name: string;
    description: string;
    version: string;
    coinInputs: Coin[];
    itemInputs: ItemInput[];
    entries: EntriesList | undefined;
    outputs: WeightedOutputs[];
    blockInterval: number;
    enabled: boolean;
    extraInfo: string;
}
export interface MsgCreateRecipeResponse {
}
export interface MsgUpdateRecipe {
    creator: string;
    cookbookID: string;
    ID: string;
    name: string;
    description: string;
    version: string;
    coinInputs: Coin[];
    itemInputs: ItemInput[];
    entries: EntriesList | undefined;
    outputs: WeightedOutputs[];
    blockInterval: number;
    enabled: boolean;
    extraInfo: string;
}
export interface MsgUpdateRecipeResponse {
}
export interface MsgCreateCookbook {
    creator: string;
    ID: string;
    name: string;
    description: string;
    developer: string;
    version: string;
    supportEmail: string;
    tier: number;
    costPerBlock: number;
    enabled: boolean;
}
export interface MsgCreateCookbookResponse {
}
export interface MsgUpdateCookbook {
    creator: string;
    ID: string;
    name: string;
    description: string;
    developer: string;
    version: string;
    supportEmail: string;
    tier: number;
    costPerBlock: number;
    enabled: boolean;
}
export interface MsgUpdateCookbookResponse {
}
export declare const MsgExecuteRecipe: {
    encode(message: MsgExecuteRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipe;
    fromJSON(object: any): MsgExecuteRecipe;
    toJSON(message: MsgExecuteRecipe): unknown;
    fromPartial(object: DeepPartial<MsgExecuteRecipe>): MsgExecuteRecipe;
};
export declare const MsgExecuteRecipeResponse: {
    encode(message: MsgExecuteRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipeResponse;
    fromJSON(object: any): MsgExecuteRecipeResponse;
    toJSON(message: MsgExecuteRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgExecuteRecipeResponse>): MsgExecuteRecipeResponse;
};
export declare const MsgSetItemString: {
    encode(message: MsgSetItemString, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSetItemString;
    fromJSON(object: any): MsgSetItemString;
    toJSON(message: MsgSetItemString): unknown;
    fromPartial(object: DeepPartial<MsgSetItemString>): MsgSetItemString;
};
export declare const MsgSetItemStringResponse: {
    encode(_: MsgSetItemStringResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSetItemStringResponse;
    fromJSON(_: any): MsgSetItemStringResponse;
    toJSON(_: MsgSetItemStringResponse): unknown;
    fromPartial(_: DeepPartial<MsgSetItemStringResponse>): MsgSetItemStringResponse;
};
export declare const MsgCreateRecipe: {
    encode(message: MsgCreateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipe;
    fromJSON(object: any): MsgCreateRecipe;
    toJSON(message: MsgCreateRecipe): unknown;
    fromPartial(object: DeepPartial<MsgCreateRecipe>): MsgCreateRecipe;
};
export declare const MsgCreateRecipeResponse: {
    encode(_: MsgCreateRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipeResponse;
    fromJSON(_: any): MsgCreateRecipeResponse;
    toJSON(_: MsgCreateRecipeResponse): unknown;
    fromPartial(_: DeepPartial<MsgCreateRecipeResponse>): MsgCreateRecipeResponse;
};
export declare const MsgUpdateRecipe: {
    encode(message: MsgUpdateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipe;
    fromJSON(object: any): MsgUpdateRecipe;
    toJSON(message: MsgUpdateRecipe): unknown;
    fromPartial(object: DeepPartial<MsgUpdateRecipe>): MsgUpdateRecipe;
};
export declare const MsgUpdateRecipeResponse: {
    encode(_: MsgUpdateRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipeResponse;
    fromJSON(_: any): MsgUpdateRecipeResponse;
    toJSON(_: MsgUpdateRecipeResponse): unknown;
    fromPartial(_: DeepPartial<MsgUpdateRecipeResponse>): MsgUpdateRecipeResponse;
};
export declare const MsgCreateCookbook: {
    encode(message: MsgCreateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbook;
    fromJSON(object: any): MsgCreateCookbook;
    toJSON(message: MsgCreateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgCreateCookbook>): MsgCreateCookbook;
};
export declare const MsgCreateCookbookResponse: {
    encode(_: MsgCreateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbookResponse;
    fromJSON(_: any): MsgCreateCookbookResponse;
    toJSON(_: MsgCreateCookbookResponse): unknown;
    fromPartial(_: DeepPartial<MsgCreateCookbookResponse>): MsgCreateCookbookResponse;
};
export declare const MsgUpdateCookbook: {
    encode(message: MsgUpdateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbook;
    fromJSON(object: any): MsgUpdateCookbook;
    toJSON(message: MsgUpdateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgUpdateCookbook>): MsgUpdateCookbook;
};
export declare const MsgUpdateCookbookResponse: {
    encode(_: MsgUpdateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbookResponse;
    fromJSON(_: any): MsgUpdateCookbookResponse;
    toJSON(_: MsgUpdateCookbookResponse): unknown;
    fromPartial(_: DeepPartial<MsgUpdateCookbookResponse>): MsgUpdateCookbookResponse;
};
/** Msg defines the Msg service. */
export interface Msg {
    /** this line is used by starport scaffolding # proto/tx/rpc */
    ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>;
    SetItemString(request: MsgSetItemString): Promise<MsgSetItemStringResponse>;
    CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>;
    UpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>;
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
}
export declare class MsgClientImpl implements Msg {
    private readonly rpc;
    constructor(rpc: Rpc);
    ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>;
    SetItemString(request: MsgSetItemString): Promise<MsgSetItemStringResponse>;
    CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>;
    UpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>;
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
}
interface Rpc {
    request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>;
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
