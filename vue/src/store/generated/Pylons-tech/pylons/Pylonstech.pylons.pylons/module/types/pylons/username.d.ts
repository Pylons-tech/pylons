import { Writer, Reader } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface Username {
    creator: string;
    value: string;
}
export declare const Username: {
    encode(message: Username, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Username;
    fromJSON(object: any): Username;
    toJSON(message: Username): unknown;
    fromPartial(object: DeepPartial<Username>): Username;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
