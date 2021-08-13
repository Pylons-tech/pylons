/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface GooglIAPOrder {
  creator: string
  id: number
  productID: string
  purchaseToken: string
  receiptDaBase64: string
  signature: string
}

const baseGooglIAPOrder: object = { creator: '', id: 0, productID: '', purchaseToken: '', receiptDaBase64: '', signature: '' }

export const GooglIAPOrder = {
  encode(message: GooglIAPOrder, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.id !== 0) {
      writer.uint32(16).uint64(message.id)
    }
    if (message.productID !== '') {
      writer.uint32(26).string(message.productID)
    }
    if (message.purchaseToken !== '') {
      writer.uint32(34).string(message.purchaseToken)
    }
    if (message.receiptDaBase64 !== '') {
      writer.uint32(42).string(message.receiptDaBase64)
    }
    if (message.signature !== '') {
      writer.uint32(50).string(message.signature)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GooglIAPOrder {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGooglIAPOrder } as GooglIAPOrder
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.id = longToNumber(reader.uint64() as Long)
          break
        case 3:
          message.productID = reader.string()
          break
        case 4:
          message.purchaseToken = reader.string()
          break
        case 5:
          message.receiptDaBase64 = reader.string()
          break
        case 6:
          message.signature = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GooglIAPOrder {
    const message = { ...baseGooglIAPOrder } as GooglIAPOrder
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = Number(object.id)
    } else {
      message.id = 0
    }
    if (object.productID !== undefined && object.productID !== null) {
      message.productID = String(object.productID)
    } else {
      message.productID = ''
    }
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = String(object.purchaseToken)
    } else {
      message.purchaseToken = ''
    }
    if (object.receiptDaBase64 !== undefined && object.receiptDaBase64 !== null) {
      message.receiptDaBase64 = String(object.receiptDaBase64)
    } else {
      message.receiptDaBase64 = ''
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = String(object.signature)
    } else {
      message.signature = ''
    }
    return message
  },

  toJSON(message: GooglIAPOrder): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    message.productID !== undefined && (obj.productID = message.productID)
    message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken)
    message.receiptDaBase64 !== undefined && (obj.receiptDaBase64 = message.receiptDaBase64)
    message.signature !== undefined && (obj.signature = message.signature)
    return obj
  },

  fromPartial(object: DeepPartial<GooglIAPOrder>): GooglIAPOrder {
    const message = { ...baseGooglIAPOrder } as GooglIAPOrder
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = 0
    }
    if (object.productID !== undefined && object.productID !== null) {
      message.productID = object.productID
    } else {
      message.productID = ''
    }
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = object.purchaseToken
    } else {
      message.purchaseToken = ''
    }
    if (object.receiptDaBase64 !== undefined && object.receiptDaBase64 !== null) {
      message.receiptDaBase64 = object.receiptDaBase64
    } else {
      message.receiptDaBase64 = ''
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = object.signature
    } else {
      message.signature = ''
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
