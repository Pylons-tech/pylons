import { Coin } from '../cosmos/base/v1beta1/coin'
import { Writer, Reader } from 'protobufjs/minimal'
export declare const protobufPackage = 'Pylonstech.pylons.pylons'
export interface Cookbook {
	creator: string
	ID: string
	nodeVersion: string
	name: string
	description: string
	developer: string
	version: string
	supportEmail: string
	costPerBlock: Coin | undefined
	enabled: boolean
}
export declare const Cookbook: {
	encode(message: Cookbook, writer?: Writer): Writer
	decode(input: Reader | Uint8Array, length?: number): Cookbook
	fromJSON(object: any): Cookbook
	toJSON(message: Cookbook): unknown
	fromPartial(object: DeepPartial<Cookbook>): Cookbook
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
