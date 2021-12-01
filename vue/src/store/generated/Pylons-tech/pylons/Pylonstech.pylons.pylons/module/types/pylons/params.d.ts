import { Writer, Reader } from "protobufjs/minimal";
import { Coin } from "../cosmos/base/v1beta1/coin";
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface GoogleInAppPurchasePackage {
    packageName: string;
    productID: string;
    amount: string;
}
/** CoinIssuer represents an entity or external blockchain */
export interface CoinIssuer {
    coinDenom: string;
    packages: GoogleInAppPurchasePackage[];
    googleInAppPurchasePubKey: string;
    entityName: string;
}
export interface PaymentProcessor {
    CoinDenom: string;
    /** pubKey is assumed to be ed25519 */
    pubKey: string;
    /** Represents the percentage retained by the payment processor when new coins are minted. In the range [0, 1), this amount is burned on-chain, actual fee is retained at the source. */
    processorPercentage: string;
    /** Represents the percentage distributed to stakers. In the range [0, 1). The sum with processingCut cannot exceed 1. */
    validatorsPercentage: string;
    name: string;
}
/** Params represent the parameters used by the pylons module */
export interface Params {
    minNameFieldLength: number;
    minDescriptionFieldLength: number;
    coinIssuers: CoinIssuer[];
    paymentProcessors: PaymentProcessor[];
    recipeFeePercentage: string;
    itemTransferFeePercentage: string;
    updateItemStringFee: Coin | undefined;
    minTransferFee: string;
    maxTransferFee: string;
    updateUsernameFee: Coin | undefined;
    distrEpochIdentifier: string;
    engineVersion: number;
}
export declare const GoogleInAppPurchasePackage: {
    encode(message: GoogleInAppPurchasePackage, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GoogleInAppPurchasePackage;
    fromJSON(object: any): GoogleInAppPurchasePackage;
    toJSON(message: GoogleInAppPurchasePackage): unknown;
    fromPartial(object: DeepPartial<GoogleInAppPurchasePackage>): GoogleInAppPurchasePackage;
};
export declare const CoinIssuer: {
    encode(message: CoinIssuer, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): CoinIssuer;
    fromJSON(object: any): CoinIssuer;
    toJSON(message: CoinIssuer): unknown;
    fromPartial(object: DeepPartial<CoinIssuer>): CoinIssuer;
};
export declare const PaymentProcessor: {
    encode(message: PaymentProcessor, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): PaymentProcessor;
    fromJSON(object: any): PaymentProcessor;
    toJSON(message: PaymentProcessor): unknown;
    fromPartial(object: DeepPartial<PaymentProcessor>): PaymentProcessor;
};
export declare const Params: {
    encode(message: Params, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Params;
    fromJSON(object: any): Params;
    toJSON(message: Params): unknown;
    fromPartial(object: DeepPartial<Params>): Params;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
