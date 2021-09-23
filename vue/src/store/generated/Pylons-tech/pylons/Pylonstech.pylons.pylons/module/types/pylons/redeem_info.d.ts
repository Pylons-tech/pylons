import { Writer, Reader } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface RedeemInfo {
    creator: string;
    index: string;
    processorName: string;
    address: string;
    amount: string;
    signature: string;
}
export declare const RedeemInfo: {
    encode(message: RedeemInfo, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): RedeemInfo;
    fromJSON(object: any): RedeemInfo;
    toJSON(message: RedeemInfo): unknown;
    fromPartial(object: DeepPartial<RedeemInfo>): RedeemInfo;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
