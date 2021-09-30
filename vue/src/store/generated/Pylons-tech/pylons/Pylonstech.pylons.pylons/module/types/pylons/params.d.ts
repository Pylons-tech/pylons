import { Writer, Reader } from 'protobufjs/minimal'
import { Coin } from '../cosmos/base/v1beta1/coin'
export declare const protobufPackage = 'Pylonstech.pylons.pylons'
export interface GoogleInAppPurchasePackage {
	PackageName: string
	ProductID: string
	Amount: string
}
/** CoinIssuer represents an entity or external blockchain */
export interface CoinIssuer {
	CoinDenom: string
	Packages: GoogleInAppPurchasePackage[]
	GoogleInAppPurchasePubKey: string
	EntityName: string
}
/** Params represent the parameters used by the pylons module */
export interface Params {
	minNameFieldLength: number
	minDescriptionFieldLength: number
	coinIssuers: CoinIssuer[]
	recipeFeePercentage: string
	itemTransferFeePercentage: string
	UpdateItemStringFee: Coin | undefined
	minTransferFee: string
	maxTransferFee: string
	UpdateUsernameFee: Coin | undefined
}
export declare const GoogleInAppPurchasePackage: {
	encode(message: GoogleInAppPurchasePackage, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): GoogleInAppPurchasePackage
	fromJSON(object: any): GoogleInAppPurchasePackage
	toJSON(message: GoogleInAppPurchasePackage): unknown
	fromPartial(object: DeepPartial<GoogleInAppPurchasePackage>): GoogleInAppPurchasePackage
}
export declare const CoinIssuer: {
	encode(message: CoinIssuer, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): CoinIssuer
	fromJSON(object: any): CoinIssuer
	toJSON(message: CoinIssuer): unknown
	fromPartial(object: DeepPartial<CoinIssuer>): CoinIssuer
}
export declare const Params: {
	encode(message: Params, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): Params
	fromJSON(object: any): Params
	toJSON(message: Params): unknown
	fromPartial(object: DeepPartial<Params>): Params
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined
export declare type DeepPartial<T> = T extends Builtin
	? T
	: T extends Array<infer U>
	? Array<DeepPartial<U>>
	: T extends ReadonlyArray<infer U>
	? ReadonlyArray<DeepPartial<U>>
	: T extends {}
	? {
			[K in keyof T]?: DeepPartial<T[K]>
	  }
	: Partial<T>
export {}
