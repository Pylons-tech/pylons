import { Writer, Reader } from 'protobufjs/minimal';
import { CoinInput, ItemInput } from '../pylons/recipe';
import { Coin } from '../cosmos/base/v1beta1/coin';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface ItemRef {
    cookbookID: string;
    itemID: string;
}
export interface Trade {
    creator: string;
    ID: number;
    coinInputs: CoinInput[];
    itemInputs: ItemInput[];
    coinOutputs: Coin[];
    itemOutputs: ItemRef[];
    extraInfo: string;
    receiver: string;
    tradedItemInputs: ItemRef[];
}
export declare const ItemRef: {
    encode(message: ItemRef, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemRef;
    fromJSON(object: any): ItemRef;
    toJSON(message: ItemRef): unknown;
    fromPartial(object: DeepPartial<ItemRef>): ItemRef;
};
export declare const Trade: {
    encode(message: Trade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Trade;
    fromJSON(object: any): Trade;
    toJSON(message: Trade): unknown;
    fromPartial(object: DeepPartial<Trade>): Trade;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
