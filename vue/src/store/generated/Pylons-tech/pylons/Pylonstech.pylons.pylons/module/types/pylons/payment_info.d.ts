import { Writer, Reader } from "protobufjs/minimal";
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface PaymentInfo {
    purchaseID: string;
    processorName: string;
    payerAddr: string;
    amount: string;
    productID: string;
    signature: string;
}
export declare const PaymentInfo: {
    encode(message: PaymentInfo, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): PaymentInfo;
    fromJSON(object: any): PaymentInfo;
    toJSON(message: PaymentInfo): unknown;
    fromPartial(object: DeepPartial<PaymentInfo>): PaymentInfo;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
