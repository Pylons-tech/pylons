import { Writer, Reader } from "protobufjs/minimal";
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface UserMap {
    accountAddr: string;
    username: string;
}
export interface Username {
    value: string;
}
export interface AccountAddr {
    value: string;
}
export declare const UserMap: {
    encode(message: UserMap, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): UserMap;
    fromJSON(object: any): UserMap;
    toJSON(message: UserMap): unknown;
    fromPartial(object: DeepPartial<UserMap>): UserMap;
};
export declare const Username: {
    encode(message: Username, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Username;
    fromJSON(object: any): Username;
    toJSON(message: Username): unknown;
    fromPartial(object: DeepPartial<Username>): Username;
};
export declare const AccountAddr: {
    encode(message: AccountAddr, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): AccountAddr;
    fromJSON(object: any): AccountAddr;
    toJSON(message: AccountAddr): unknown;
    fromPartial(object: DeepPartial<AccountAddr>): AccountAddr;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
