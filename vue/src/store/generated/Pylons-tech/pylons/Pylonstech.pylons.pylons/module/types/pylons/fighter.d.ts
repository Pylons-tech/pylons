import { Writer, Reader } from "protobufjs/minimal";
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface Fighter {
    creator: string;
    ID: number;
    cookbookID: string;
    LHitem: string;
    RHitem: string;
    Armoritem: string;
    NFT: string;
    Status: string;
    Log: string;
}
export declare const Fighter: {
    encode(message: Fighter, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Fighter;
    fromJSON(object: any): Fighter;
    toJSON(message: Fighter): unknown;
    fromPartial(object: DeepPartial<Fighter>): Fighter;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
