/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** Params represent the parameters used by the pylons module */
export interface Params {
  minNameFieldLength: number
  minDescriptionFieldLength: number
  baseFee: Coin[]
}

const baseParams: object = { minNameFieldLength: 0, minDescriptionFieldLength: 0 }

export const Params = {
  encode(message: Params, writer: Writer = Writer.create()): Writer {
    if (message.minNameFieldLength !== 0) {
      writer.uint32(8).uint64(message.minNameFieldLength)
    }
    if (message.minDescriptionFieldLength !== 0) {
      writer.uint32(16).uint64(message.minDescriptionFieldLength)
    }
    for (const v of message.baseFee) {
      Coin.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Params {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseParams } as Params
    message.baseFee = []
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
          message.baseFee.push(Coin.decode(reader, reader.uint32()))
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
    message.baseFee = []
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
    if (object.baseFee !== undefined && object.baseFee !== null) {
      for (const e of object.baseFee) {
        message.baseFee.push(Coin.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: Params): unknown {
    const obj: any = {}
    message.minNameFieldLength !== undefined && (obj.minNameFieldLength = message.minNameFieldLength)
    message.minDescriptionFieldLength !== undefined && (obj.minDescriptionFieldLength = message.minDescriptionFieldLength)
    if (message.baseFee) {
      obj.baseFee = message.baseFee.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.baseFee = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<Params>): Params {
    const message = { ...baseParams } as Params
    message.baseFee = []
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
    if (object.baseFee !== undefined && object.baseFee !== null) {
      for (const e of object.baseFee) {
        message.baseFee.push(Coin.fromPartial(e))
      }
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
