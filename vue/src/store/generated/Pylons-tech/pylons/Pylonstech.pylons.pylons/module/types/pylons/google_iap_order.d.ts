import { Writer, Reader } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface GoogleInAppPurchaseOrder {
    creator: string;
    productID: string;
    purchaseToken: string;
    receiptDataBase64: string;
    signature: string;
}
export declare const GoogleInAppPurchaseOrder: {
    encode(message: GoogleInAppPurchaseOrder, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GoogleInAppPurchaseOrder;
    fromJSON(object: any): GoogleInAppPurchaseOrder;
    toJSON(message: GoogleInAppPurchaseOrder): unknown;
    fromPartial(object: DeepPartial<GoogleInAppPurchaseOrder>): GoogleInAppPurchaseOrder;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
