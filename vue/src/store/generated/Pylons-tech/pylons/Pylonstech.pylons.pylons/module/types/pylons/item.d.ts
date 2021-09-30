import { Writer, Reader } from 'protobufjs/minimal'
import { Coin } from '../cosmos/base/v1beta1/coin'
export declare const protobufPackage = 'Pylonstech.pylons.pylons'
/** DoubleKeyValue describes double key/value set */
export interface DoubleKeyValue {
	Key: string
	Value: string
}
/** LongKeyValue describes long key/value set */
export interface LongKeyValue {
	Key: string
	Value: number
}
/** StringKeyValue describes string key/value set */
export interface StringKeyValue {
	Key: string
	Value: string
}
export interface Item {
	owner: string
	cookbookID: string
	ID: string
	nodeVersion: string
	doubles: DoubleKeyValue[]
	longs: LongKeyValue[]
	strings: StringKeyValue[]
	mutableStrings: StringKeyValue[]
	tradeable: boolean
	lastUpdate: number
	transferFee: Coin[]
	/** The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0). */
	tradePercentage: string
}
export declare const DoubleKeyValue: {
	encode(message: DoubleKeyValue, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): DoubleKeyValue
	fromJSON(object: any): DoubleKeyValue
	toJSON(message: DoubleKeyValue): unknown
	fromPartial(object: DeepPartial<DoubleKeyValue>): DoubleKeyValue
}
export declare const LongKeyValue: {
	encode(message: LongKeyValue, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): LongKeyValue
	fromJSON(object: any): LongKeyValue
	toJSON(message: LongKeyValue): unknown
	fromPartial(object: DeepPartial<LongKeyValue>): LongKeyValue
}
export declare const StringKeyValue: {
	encode(message: StringKeyValue, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): StringKeyValue
	fromJSON(object: any): StringKeyValue
	toJSON(message: StringKeyValue): unknown
	fromPartial(object: DeepPartial<StringKeyValue>): StringKeyValue
}
export declare const Item: {
	encode(message: Item, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): Item
	fromJSON(object: any): Item
	toJSON(message: Item): unknown
	fromPartial(object: DeepPartial<Item>): Item
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
