import { Writer, Reader } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface UserMap {
    account: string;
    username: string;
}
export declare const UserMap: {
    encode(message: UserMap, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): UserMap;
    fromJSON(object: any): UserMap;
    toJSON(message: UserMap): unknown;
    fromPartial(object: DeepPartial<UserMap>): UserMap;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
