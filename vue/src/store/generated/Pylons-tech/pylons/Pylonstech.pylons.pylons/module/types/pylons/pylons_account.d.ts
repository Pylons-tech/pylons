import { Writer, Reader } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface PylonsAccount {
    account: string;
    username: string;
}
export declare const PylonsAccount: {
    encode(message: PylonsAccount, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): PylonsAccount;
    fromJSON(object: any): PylonsAccount;
    toJSON(message: PylonsAccount): unknown;
    fromPartial(object: DeepPartial<PylonsAccount>): PylonsAccount;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
