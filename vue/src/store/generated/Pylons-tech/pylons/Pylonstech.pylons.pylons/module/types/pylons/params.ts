/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface GoogleInAppPurchasePackage {
  PackageName: string
  ProductID: string
  Amount: string
}

export interface CoinIssuer {
  CoinDenom: string
  Packages: GoogleInAppPurchasePackage[]
  GoogleInAppPurchasePubKey: string
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

const baseGoogleInAppPurchasePackage: object = { PackageName: '', ProductID: '', Amount: '' }

export const GoogleInAppPurchasePackage = {
  encode(message: GoogleInAppPurchasePackage, writer: Writer = Writer.create()): Writer {
    if (message.PackageName !== '') {
      writer.uint32(10).string(message.PackageName)
    }
    if (message.ProductID !== '') {
      writer.uint32(18).string(message.ProductID)
    }
    if (message.Amount !== '') {
      writer.uint32(26).string(message.Amount)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GoogleInAppPurchasePackage {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGoogleInAppPurchasePackage } as GoogleInAppPurchasePackage
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.PackageName = reader.string()
          break
        case 2:
          message.ProductID = reader.string()
          break
        case 3:
          message.Amount = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GoogleInAppPurchasePackage {
    const message = { ...baseGoogleInAppPurchasePackage } as GoogleInAppPurchasePackage
    if (object.PackageName !== undefined && object.PackageName !== null) {
      message.PackageName = String(object.PackageName)
    } else {
      message.PackageName = ''
    }
    if (object.ProductID !== undefined && object.ProductID !== null) {
      message.ProductID = String(object.ProductID)
    } else {
      message.ProductID = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      message.Amount = String(object.Amount)
    } else {
      message.Amount = ''
    }
    return message
  },

  toJSON(message: GoogleInAppPurchasePackage): unknown {
    const obj: any = {}
    message.PackageName !== undefined && (obj.PackageName = message.PackageName)
    message.ProductID !== undefined && (obj.ProductID = message.ProductID)
    message.Amount !== undefined && (obj.Amount = message.Amount)
    return obj
  },

  fromPartial(object: DeepPartial<GoogleInAppPurchasePackage>): GoogleInAppPurchasePackage {
    const message = { ...baseGoogleInAppPurchasePackage } as GoogleInAppPurchasePackage
    if (object.PackageName !== undefined && object.PackageName !== null) {
      message.PackageName = object.PackageName
    } else {
      message.PackageName = ''
    }
    if (object.ProductID !== undefined && object.ProductID !== null) {
      message.ProductID = object.ProductID
    } else {
      message.ProductID = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      message.Amount = object.Amount
    } else {
      message.Amount = ''
    }
    return message
  }
}

const baseCoinIssuer: object = { CoinDenom: '', GoogleInAppPurchasePubKey: '' }

export const CoinIssuer = {
  encode(message: CoinIssuer, writer: Writer = Writer.create()): Writer {
    if (message.CoinDenom !== '') {
      writer.uint32(10).string(message.CoinDenom)
    }
    for (const v of message.Packages) {
      GoogleInAppPurchasePackage.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    if (message.GoogleInAppPurchasePubKey !== '') {
      writer.uint32(26).string(message.GoogleInAppPurchasePubKey)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): CoinIssuer {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseCoinIssuer } as CoinIssuer
    message.Packages = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CoinDenom = reader.string()
          break
        case 2:
          message.Packages.push(GoogleInAppPurchasePackage.decode(reader, reader.uint32()))
          break
        case 3:
          message.GoogleInAppPurchasePubKey = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): CoinIssuer {
    const message = { ...baseCoinIssuer } as CoinIssuer
    message.Packages = []
    if (object.CoinDenom !== undefined && object.CoinDenom !== null) {
      message.CoinDenom = String(object.CoinDenom)
    } else {
      message.CoinDenom = ''
    }
    if (object.Packages !== undefined && object.Packages !== null) {
      for (const e of object.Packages) {
        message.Packages.push(GoogleInAppPurchasePackage.fromJSON(e))
      }
    }
    if (object.GoogleInAppPurchasePubKey !== undefined && object.GoogleInAppPurchasePubKey !== null) {
      message.GoogleInAppPurchasePubKey = String(object.GoogleInAppPurchasePubKey)
    } else {
      message.GoogleInAppPurchasePubKey = ''
    }
    return message
  },

  toJSON(message: CoinIssuer): unknown {
    const obj: any = {}
    message.CoinDenom !== undefined && (obj.CoinDenom = message.CoinDenom)
    if (message.Packages) {
      obj.Packages = message.Packages.map((e) => (e ? GoogleInAppPurchasePackage.toJSON(e) : undefined))
    } else {
      obj.Packages = []
    }
    message.GoogleInAppPurchasePubKey !== undefined && (obj.GoogleInAppPurchasePubKey = message.GoogleInAppPurchasePubKey)
    return obj
  },

  fromPartial(object: DeepPartial<CoinIssuer>): CoinIssuer {
    const message = { ...baseCoinIssuer } as CoinIssuer
    message.Packages = []
    if (object.CoinDenom !== undefined && object.CoinDenom !== null) {
      message.CoinDenom = object.CoinDenom
    } else {
      message.CoinDenom = ''
    }
    if (object.Packages !== undefined && object.Packages !== null) {
      for (const e of object.Packages) {
        message.Packages.push(GoogleInAppPurchasePackage.fromPartial(e))
      }
    }
    if (object.GoogleInAppPurchasePubKey !== undefined && object.GoogleInAppPurchasePubKey !== null) {
      message.GoogleInAppPurchasePubKey = object.GoogleInAppPurchasePubKey
    } else {
      message.GoogleInAppPurchasePubKey = ''
    }
    return message
  }
}

const baseParams: object = {
  minNameFieldLength: 0,
  minDescriptionFieldLength: 0,
  recipeFeePercentage: '',
  itemTransferFeePercentage: '',
  minTransferFee: '',
  maxTransferFee: ''
}

export const Params = {
  encode(message: Params, writer: Writer = Writer.create()): Writer {
    if (message.minNameFieldLength !== 0) {
      writer.uint32(8).uint64(message.minNameFieldLength)
    }
    if (message.minDescriptionFieldLength !== 0) {
      writer.uint32(16).uint64(message.minDescriptionFieldLength)
    }
    for (const v of message.coinIssuers) {
      CoinIssuer.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    if (message.recipeFeePercentage !== '') {
      writer.uint32(34).string(message.recipeFeePercentage)
    }
    if (message.itemTransferFeePercentage !== '') {
      writer.uint32(42).string(message.itemTransferFeePercentage)
    }
    if (message.UpdateItemStringFee !== undefined) {
      Coin.encode(message.UpdateItemStringFee, writer.uint32(50).fork()).ldelim()
    }
    if (message.minTransferFee !== '') {
      writer.uint32(58).string(message.minTransferFee)
    }
    if (message.maxTransferFee !== '') {
      writer.uint32(66).string(message.maxTransferFee)
    }
    if (message.UpdateUsernameFee !== undefined) {
      Coin.encode(message.UpdateUsernameFee, writer.uint32(74).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Params {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseParams } as Params
    message.coinIssuers = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.minNameFieldLength = longToNumber(reader.uint64() as Long)
          break
        case 2:
          message.minDescriptionFieldLength = longToNumber(reader.uint64() as Long)
          break
        case 3:
          message.coinIssuers.push(CoinIssuer.decode(reader, reader.uint32()))
          break
        case 4:
          message.recipeFeePercentage = reader.string()
          break
        case 5:
          message.itemTransferFeePercentage = reader.string()
          break
        case 6:
          message.UpdateItemStringFee = Coin.decode(reader, reader.uint32())
          break
        case 7:
          message.minTransferFee = reader.string()
          break
        case 8:
          message.maxTransferFee = reader.string()
          break
        case 9:
          message.UpdateUsernameFee = Coin.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): Params {
    const message = { ...baseParams } as Params
    message.coinIssuers = []
    if (object.minNameFieldLength !== undefined && object.minNameFieldLength !== null) {
      message.minNameFieldLength = Number(object.minNameFieldLength)
    } else {
      message.minNameFieldLength = 0
    }
    if (object.minDescriptionFieldLength !== undefined && object.minDescriptionFieldLength !== null) {
      message.minDescriptionFieldLength = Number(object.minDescriptionFieldLength)
    } else {
      message.minDescriptionFieldLength = 0
    }
    if (object.coinIssuers !== undefined && object.coinIssuers !== null) {
      for (const e of object.coinIssuers) {
        message.coinIssuers.push(CoinIssuer.fromJSON(e))
      }
    }
    if (object.recipeFeePercentage !== undefined && object.recipeFeePercentage !== null) {
      message.recipeFeePercentage = String(object.recipeFeePercentage)
    } else {
      message.recipeFeePercentage = ''
    }
    if (object.itemTransferFeePercentage !== undefined && object.itemTransferFeePercentage !== null) {
      message.itemTransferFeePercentage = String(object.itemTransferFeePercentage)
    } else {
      message.itemTransferFeePercentage = ''
    }
    if (object.UpdateItemStringFee !== undefined && object.UpdateItemStringFee !== null) {
      message.UpdateItemStringFee = Coin.fromJSON(object.UpdateItemStringFee)
    } else {
      message.UpdateItemStringFee = undefined
    }
    if (object.minTransferFee !== undefined && object.minTransferFee !== null) {
      message.minTransferFee = String(object.minTransferFee)
    } else {
      message.minTransferFee = ''
    }
    if (object.maxTransferFee !== undefined && object.maxTransferFee !== null) {
      message.maxTransferFee = String(object.maxTransferFee)
    } else {
      message.maxTransferFee = ''
    }
    if (object.UpdateUsernameFee !== undefined && object.UpdateUsernameFee !== null) {
      message.UpdateUsernameFee = Coin.fromJSON(object.UpdateUsernameFee)
    } else {
      message.UpdateUsernameFee = undefined
    }
    return message
  },

  toJSON(message: Params): unknown {
    const obj: any = {}
    message.minNameFieldLength !== undefined && (obj.minNameFieldLength = message.minNameFieldLength)
    message.minDescriptionFieldLength !== undefined && (obj.minDescriptionFieldLength = message.minDescriptionFieldLength)
    if (message.coinIssuers) {
      obj.coinIssuers = message.coinIssuers.map((e) => (e ? CoinIssuer.toJSON(e) : undefined))
    } else {
      obj.coinIssuers = []
    }
    message.recipeFeePercentage !== undefined && (obj.recipeFeePercentage = message.recipeFeePercentage)
    message.itemTransferFeePercentage !== undefined && (obj.itemTransferFeePercentage = message.itemTransferFeePercentage)
    message.UpdateItemStringFee !== undefined && (obj.UpdateItemStringFee = message.UpdateItemStringFee ? Coin.toJSON(message.UpdateItemStringFee) : undefined)
    message.minTransferFee !== undefined && (obj.minTransferFee = message.minTransferFee)
    message.maxTransferFee !== undefined && (obj.maxTransferFee = message.maxTransferFee)
    message.UpdateUsernameFee !== undefined && (obj.UpdateUsernameFee = message.UpdateUsernameFee ? Coin.toJSON(message.UpdateUsernameFee) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<Params>): Params {
    const message = { ...baseParams } as Params
    message.coinIssuers = []
    if (object.minNameFieldLength !== undefined && object.minNameFieldLength !== null) {
      message.minNameFieldLength = object.minNameFieldLength
    } else {
      message.minNameFieldLength = 0
    }
    if (object.minDescriptionFieldLength !== undefined && object.minDescriptionFieldLength !== null) {
      message.minDescriptionFieldLength = object.minDescriptionFieldLength
    } else {
      message.minDescriptionFieldLength = 0
    }
    if (object.coinIssuers !== undefined && object.coinIssuers !== null) {
      for (const e of object.coinIssuers) {
        message.coinIssuers.push(CoinIssuer.fromPartial(e))
      }
    }
    if (object.recipeFeePercentage !== undefined && object.recipeFeePercentage !== null) {
      message.recipeFeePercentage = object.recipeFeePercentage
    } else {
      message.recipeFeePercentage = ''
    }
    if (object.itemTransferFeePercentage !== undefined && object.itemTransferFeePercentage !== null) {
      message.itemTransferFeePercentage = object.itemTransferFeePercentage
    } else {
      message.itemTransferFeePercentage = ''
    }
    if (object.UpdateItemStringFee !== undefined && object.UpdateItemStringFee !== null) {
      message.UpdateItemStringFee = Coin.fromPartial(object.UpdateItemStringFee)
    } else {
      message.UpdateItemStringFee = undefined
    }
    if (object.minTransferFee !== undefined && object.minTransferFee !== null) {
      message.minTransferFee = object.minTransferFee
    } else {
      message.minTransferFee = ''
    }
    if (object.maxTransferFee !== undefined && object.maxTransferFee !== null) {
      message.maxTransferFee = object.maxTransferFee
    } else {
      message.maxTransferFee = ''
    }
    if (object.UpdateUsernameFee !== undefined && object.UpdateUsernameFee !== null) {
      message.UpdateUsernameFee = Coin.fromPartial(object.UpdateUsernameFee)
    } else {
      message.UpdateUsernameFee = undefined
    }
    return message
  }
}

declare var self: any | undefined
declare var window: any | undefined
var globalThis: any = (() => {
  if (typeof globalThis !== 'undefined') return globalThis
  if (typeof self !== 'undefined') return self
  if (typeof window !== 'undefined') return window
  if (typeof global !== 'undefined') return global
  throw 'Unable to locate global object'
})()

type Builtin = Date | Function | Uint8Array | string | number | undefined
export type DeepPartial<T> = T extends Builtin
  ? T
  : T extends Array<infer U>
  ? Array<DeepPartial<U>>
  : T extends ReadonlyArray<infer U>
  ? ReadonlyArray<DeepPartial<U>>
  : T extends {}
  ? { [K in keyof T]?: DeepPartial<T[K]> }
  : Partial<T>

function longToNumber(long: Long): number {
  if (long.gt(Number.MAX_SAFE_INTEGER)) {
    throw new globalThis.Error('Value is larger than Number.MAX_SAFE_INTEGER')
  }
  return long.toNumber()
}

if (util.Long !== Long) {
  util.Long = Long as any
  configure()
}
