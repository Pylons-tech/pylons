/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'
import { DoubleKeyValue, LongKeyValue, StringKeyValue } from '../pylons/item'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface ItemRecord {
  ID: string
  doubles: DoubleKeyValue[]
  longs: LongKeyValue[]
  strings: StringKeyValue[]
}

export interface Execution {
  creator: string
  ID: number
  cookbookID: string
  recipeID: string
  nodeVersion: string
  blockHeight: number
  coinInputs: Coin[]
  itemInputs: ItemRecord[]
  itemOutputIDs: string[]
}

const baseItemRecord: object = { ID: '' }

export const ItemRecord = {
  encode(message: ItemRecord, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    for (const v of message.doubles) {
      DoubleKeyValue.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongKeyValue.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringKeyValue.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemRecord {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemRecord } as ItemRecord
    message.doubles = []
    message.longs = []
    message.strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        case 2:
          message.doubles.push(DoubleKeyValue.decode(reader, reader.uint32()))
          break
        case 3:
          message.longs.push(LongKeyValue.decode(reader, reader.uint32()))
          break
        case 4:
          message.strings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemRecord {
    const message = { ...baseItemRecord } as ItemRecord
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleKeyValue.fromJSON(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongKeyValue.fromJSON(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringKeyValue.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ItemRecord): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.doubles) {
      obj.doubles = message.doubles.map((e) => (e ? DoubleKeyValue.toJSON(e) : undefined))
    } else {
      obj.doubles = []
    }
    if (message.longs) {
      obj.longs = message.longs.map((e) => (e ? LongKeyValue.toJSON(e) : undefined))
    } else {
      obj.longs = []
    }
    if (message.strings) {
      obj.strings = message.strings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.strings = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ItemRecord>): ItemRecord {
    const message = { ...baseItemRecord } as ItemRecord
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleKeyValue.fromPartial(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongKeyValue.fromPartial(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringKeyValue.fromPartial(e))
      }
    }
    return message
  }
}

const baseExecution: object = { creator: '', ID: 0, cookbookID: '', recipeID: '', nodeVersion: '', blockHeight: 0, itemOutputIDs: '' }

export const Execution = {
  encode(message: Execution, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== 0) {
      writer.uint32(16).uint64(message.ID)
    }
    if (message.cookbookID !== '') {
      writer.uint32(26).string(message.cookbookID)
    }
    if (message.recipeID !== '') {
      writer.uint32(34).string(message.recipeID)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(42).string(message.nodeVersion)
    }
    if (message.blockHeight !== 0) {
      writer.uint32(48).int64(message.blockHeight)
    }
    for (const v of message.coinInputs) {
      Coin.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.itemInputs) {
      ItemRecord.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    for (const v of message.itemOutputIDs) {
      writer.uint32(74).string(v!)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Execution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseExecution } as Execution
    message.coinInputs = []
    message.itemInputs = []
    message.itemOutputIDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = longToNumber(reader.uint64() as Long)
          break
        case 3:
          message.cookbookID = reader.string()
          break
        case 4:
          message.recipeID = reader.string()
          break
        case 5:
          message.nodeVersion = reader.string()
          break
        case 6:
          message.blockHeight = longToNumber(reader.int64() as Long)
          break
        case 7:
          message.coinInputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 8:
          message.itemInputs.push(ItemRecord.decode(reader, reader.uint32()))
          break
        case 9:
          message.itemOutputIDs.push(reader.string())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): Execution {
    const message = { ...baseExecution } as Execution
    message.coinInputs = []
    message.itemInputs = []
    message.itemOutputIDs = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = Number(object.ID)
    } else {
      message.ID = 0
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    if (object.recipeID !== undefined && object.recipeID !== null) {
      message.recipeID = String(object.recipeID)
    } else {
      message.recipeID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
    }
    if (object.blockHeight !== undefined && object.blockHeight !== null) {
      message.blockHeight = Number(object.blockHeight)
    } else {
      message.blockHeight = 0
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromJSON(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemRecord.fromJSON(e))
      }
    }
    if (object.itemOutputIDs !== undefined && object.itemOutputIDs !== null) {
      for (const e of object.itemOutputIDs) {
        message.itemOutputIDs.push(String(e))
      }
    }
    return message
  },

  toJSON(message: Execution): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.recipeID !== undefined && (obj.recipeID = message.recipeID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    message.blockHeight !== undefined && (obj.blockHeight = message.blockHeight)
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinInputs = []
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) => (e ? ItemRecord.toJSON(e) : undefined))
    } else {
      obj.itemInputs = []
    }
    if (message.itemOutputIDs) {
      obj.itemOutputIDs = message.itemOutputIDs.map((e) => e)
    } else {
      obj.itemOutputIDs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<Execution>): Execution {
    const message = { ...baseExecution } as Execution
    message.coinInputs = []
    message.itemInputs = []
    message.itemOutputIDs = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = 0
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    if (object.recipeID !== undefined && object.recipeID !== null) {
      message.recipeID = object.recipeID
    } else {
      message.recipeID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
    }
    if (object.blockHeight !== undefined && object.blockHeight !== null) {
      message.blockHeight = object.blockHeight
    } else {
      message.blockHeight = 0
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromPartial(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemRecord.fromPartial(e))
      }
    }
    if (object.itemOutputIDs !== undefined && object.itemOutputIDs !== null) {
      for (const e of object.itemOutputIDs) {
        message.itemOutputIDs.push(e)
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
