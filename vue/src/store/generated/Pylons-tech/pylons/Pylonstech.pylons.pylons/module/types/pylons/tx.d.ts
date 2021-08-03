import { Reader, Writer } from 'protobufjs/minimal';
import { DoubleKeyValue, LongKeyValue, StringKeyValue } from '../pylons/item';
import { Coin } from '../cosmos/base/v1beta1/coin';
import { ItemInput, EntriesList, WeightedOutputs } from '../pylons/recipe';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgCreateItem {
    creator: string;
    ID: string;
    cookbookID: string;
    nodeVersion: string;
    Doubles: DoubleKeyValue[];
    Longs: LongKeyValue[];
    Strings: StringKeyValue[];
    ownerRecipeID: string;
    ownerTradeID: string;
    tradable: boolean;
    lastUpdate: number;
    transferFee: number;
}
export interface MsgCreateItemResponse {
}
export interface MsgUpdateItem {
    creator: string;
    ID: string;
    cookbookID: string;
    nodeVersion: string;
    Doubles: DoubleKeyValue[];
    Longs: LongKeyValue[];
    Strings: StringKeyValue[];
    ownerRecipeID: string;
    ownerTradeID: string;
    tradable: boolean;
    lastUpdate: number;
    transferFee: number;
}
export interface MsgUpdateItemResponse {
}
export interface MsgDeleteItem {
    creator: string;
    ID: string;
}
export interface MsgDeleteItemResponse {
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
export declare const MsgCreateItem: {
    encode(message: MsgCreateItem, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateItem;
    fromJSON(object: any): MsgCreateItem;
    toJSON(message: MsgCreateItem): unknown;
    fromPartial(object: DeepPartial<MsgCreateItem>): MsgCreateItem;
};
export declare const MsgCreateItemResponse: {
    encode(_: MsgCreateItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateItemResponse;
    fromJSON(_: any): MsgCreateItemResponse;
    toJSON(_: MsgCreateItemResponse): unknown;
    fromPartial(_: DeepPartial<MsgCreateItemResponse>): MsgCreateItemResponse;
};
export declare const MsgUpdateItem: {
    encode(message: MsgUpdateItem, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateItem;
    fromJSON(object: any): MsgUpdateItem;
    toJSON(message: MsgUpdateItem): unknown;
    fromPartial(object: DeepPartial<MsgUpdateItem>): MsgUpdateItem;
};
export declare const MsgUpdateItemResponse: {
    encode(_: MsgUpdateItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemResponse;
    fromJSON(_: any): MsgUpdateItemResponse;
    toJSON(_: MsgUpdateItemResponse): unknown;
    fromPartial(_: DeepPartial<MsgUpdateItemResponse>): MsgUpdateItemResponse;
};
export declare const MsgDeleteItem: {
    encode(message: MsgDeleteItem, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDeleteItem;
    fromJSON(object: any): MsgDeleteItem;
    toJSON(message: MsgDeleteItem): unknown;
    fromPartial(object: DeepPartial<MsgDeleteItem>): MsgDeleteItem;
};
export declare const MsgDeleteItemResponse: {
    encode(_: MsgDeleteItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDeleteItemResponse;
    fromJSON(_: any): MsgDeleteItemResponse;
    toJSON(_: MsgDeleteItemResponse): unknown;
    fromPartial(_: DeepPartial<MsgDeleteItemResponse>): MsgDeleteItemResponse;
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
    CreateItem(request: MsgCreateItem): Promise<MsgCreateItemResponse>;
    UpdateItem(request: MsgUpdateItem): Promise<MsgUpdateItemResponse>;
    DeleteItem(request: MsgDeleteItem): Promise<MsgDeleteItemResponse>;
    CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>;
    UpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>;
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
}
export declare class MsgClientImpl implements Msg {
    private readonly rpc;
    constructor(rpc: Rpc);
    CreateItem(request: MsgCreateItem): Promise<MsgCreateItemResponse>;
    UpdateItem(request: MsgUpdateItem): Promise<MsgUpdateItemResponse>;
    DeleteItem(request: MsgDeleteItem): Promise<MsgDeleteItemResponse>;
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
