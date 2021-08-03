/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

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
  creator: string
  cookbookID: string
  recipeID: string
  ID: string
  nodeVersion: string
  doubles: DoubleKeyValue[]
  longs: LongKeyValue[]
  strings: StringKeyValue[]
  mutableStrings: StringKeyValue[]
  lastTradeID: string
  tradeable: boolean
  lastUpdate: number
  transferFee: number
}

const baseDoubleKeyValue: object = { Key: '', Value: '' }

export const DoubleKeyValue = {
  encode(message: DoubleKeyValue, writer: Writer = Writer.create()): Writer {
    if (message.Key !== '') {
      writer.uint32(10).string(message.Key)
    }
    if (message.Value !== '') {
      writer.uint32(18).string(message.Value)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): DoubleKeyValue {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseDoubleKeyValue } as DoubleKeyValue
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Key = reader.string()
          break
        case 2:
          message.Value = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): DoubleKeyValue {
    const message = { ...baseDoubleKeyValue } as DoubleKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = String(object.Key)
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = String(object.Value)
    } else {
      message.Value = ''
    }
    return message
  },

  toJSON(message: DoubleKeyValue): unknown {
    const obj: any = {}
    message.Key !== undefined && (obj.Key = message.Key)
    message.Value !== undefined && (obj.Value = message.Value)
    return obj
  },

  fromPartial(object: DeepPartial<DoubleKeyValue>): DoubleKeyValue {
    const message = { ...baseDoubleKeyValue } as DoubleKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = object.Key
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = object.Value
    } else {
      message.Value = ''
    }
    return message
  }
}

const baseLongKeyValue: object = { Key: '', Value: 0 }

export const LongKeyValue = {
  encode(message: LongKeyValue, writer: Writer = Writer.create()): Writer {
    if (message.Key !== '') {
      writer.uint32(10).string(message.Key)
    }
    if (message.Value !== 0) {
      writer.uint32(16).int64(message.Value)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): LongKeyValue {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseLongKeyValue } as LongKeyValue
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Key = reader.string()
          break
        case 2:
          message.Value = longToNumber(reader.int64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): LongKeyValue {
    const message = { ...baseLongKeyValue } as LongKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = String(object.Key)
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = Number(object.Value)
    } else {
      message.Value = 0
    }
    return message
  },

  toJSON(message: LongKeyValue): unknown {
    const obj: any = {}
    message.Key !== undefined && (obj.Key = message.Key)
    message.Value !== undefined && (obj.Value = message.Value)
    return obj
  },

  fromPartial(object: DeepPartial<LongKeyValue>): LongKeyValue {
    const message = { ...baseLongKeyValue } as LongKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = object.Key
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = object.Value
    } else {
      message.Value = 0
    }
    return message
  }
}

const baseStringKeyValue: object = { Key: '', Value: '' }

export const StringKeyValue = {
  encode(message: StringKeyValue, writer: Writer = Writer.create()): Writer {
    if (message.Key !== '') {
      writer.uint32(10).string(message.Key)
    }
    if (message.Value !== '') {
      writer.uint32(18).string(message.Value)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): StringKeyValue {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseStringKeyValue } as StringKeyValue
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Key = reader.string()
          break
        case 2:
          message.Value = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): StringKeyValue {
    const message = { ...baseStringKeyValue } as StringKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = String(object.Key)
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = String(object.Value)
    } else {
      message.Value = ''
    }
    return message
  },

  toJSON(message: StringKeyValue): unknown {
    const obj: any = {}
    message.Key !== undefined && (obj.Key = message.Key)
    message.Value !== undefined && (obj.Value = message.Value)
    return obj
  },

  fromPartial(object: DeepPartial<StringKeyValue>): StringKeyValue {
    const message = { ...baseStringKeyValue } as StringKeyValue
    if (object.Key !== undefined && object.Key !== null) {
      message.Key = object.Key
    } else {
      message.Key = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = object.Value
    } else {
      message.Value = ''
    }
    return message
  }
}

const baseItem: object = {
  creator: '',
  cookbookID: '',
  recipeID: '',
  ID: '',
  nodeVersion: '',
  lastTradeID: '',
  tradeable: false,
  lastUpdate: 0,
  transferFee: 0
}

export const Item = {
  encode(message: Item, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.cookbookID !== '') {
      writer.uint32(18).string(message.cookbookID)
    }
    if (message.recipeID !== '') {
      writer.uint32(26).string(message.recipeID)
    }
    if (message.ID !== '') {
      writer.uint32(34).string(message.ID)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(42).string(message.nodeVersion)
    }
    for (const v of message.doubles) {
      DoubleKeyValue.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongKeyValue.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringKeyValue.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    for (const v of message.mutableStrings) {
      StringKeyValue.encode(v!, writer.uint32(74).fork()).ldelim()
    }
    if (message.lastTradeID !== '') {
      writer.uint32(82).string(message.lastTradeID)
    }
    if (message.tradeable === true) {
      writer.uint32(88).bool(message.tradeable)
    }
    if (message.lastUpdate !== 0) {
      writer.uint32(96).uint64(message.lastUpdate)
    }
    if (message.transferFee !== 0) {
      writer.uint32(104).uint64(message.transferFee)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Item {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItem } as Item
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.cookbookID = reader.string()
          break
        case 3:
          message.recipeID = reader.string()
          break
        case 4:
          message.ID = reader.string()
          break
        case 5:
          message.nodeVersion = reader.string()
          break
        case 6:
          message.doubles.push(DoubleKeyValue.decode(reader, reader.uint32()))
          break
        case 7:
          message.longs.push(LongKeyValue.decode(reader, reader.uint32()))
          break
        case 8:
          message.strings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        case 9:
          message.mutableStrings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        case 10:
          message.lastTradeID = reader.string()
          break
        case 11:
          message.tradeable = reader.bool()
          break
        case 12:
          message.lastUpdate = longToNumber(reader.uint64() as Long)
          break
        case 13:
          message.transferFee = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): Item {
    const message = { ...baseItem } as Item
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
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
    if (object.mutableStrings !== undefined && object.mutableStrings !== null) {
      for (const e of object.mutableStrings) {
        message.mutableStrings.push(StringKeyValue.fromJSON(e))
      }
    }
    if (object.lastTradeID !== undefined && object.lastTradeID !== null) {
      message.lastTradeID = String(object.lastTradeID)
    } else {
      message.lastTradeID = ''
    }
    if (object.tradeable !== undefined && object.tradeable !== null) {
      message.tradeable = Boolean(object.tradeable)
    } else {
      message.tradeable = false
    }
    if (object.lastUpdate !== undefined && object.lastUpdate !== null) {
      message.lastUpdate = Number(object.lastUpdate)
    } else {
      message.lastUpdate = 0
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = Number(object.transferFee)
    } else {
      message.transferFee = 0
    }
    return message
  },

  toJSON(message: Item): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.recipeID !== undefined && (obj.recipeID = message.recipeID)
    message.ID !== undefined && (obj.ID = message.ID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
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
    if (message.mutableStrings) {
      obj.mutableStrings = message.mutableStrings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.mutableStrings = []
    }
    message.lastTradeID !== undefined && (obj.lastTradeID = message.lastTradeID)
    message.tradeable !== undefined && (obj.tradeable = message.tradeable)
    message.lastUpdate !== undefined && (obj.lastUpdate = message.lastUpdate)
    message.transferFee !== undefined && (obj.transferFee = message.transferFee)
    return obj
  },

  fromPartial(object: DeepPartial<Item>): Item {
    const message = { ...baseItem } as Item
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
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
    if (object.mutableStrings !== undefined && object.mutableStrings !== null) {
      for (const e of object.mutableStrings) {
        message.mutableStrings.push(StringKeyValue.fromPartial(e))
      }
    }
    if (object.lastTradeID !== undefined && object.lastTradeID !== null) {
      message.lastTradeID = object.lastTradeID
    } else {
      message.lastTradeID = ''
    }
    if (object.tradeable !== undefined && object.tradeable !== null) {
      message.tradeable = object.tradeable
    } else {
      message.tradeable = false
    }
    if (object.lastUpdate !== undefined && object.lastUpdate !== null) {
      message.lastUpdate = object.lastUpdate
    } else {
      message.lastUpdate = 0
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = object.transferFee
    } else {
      message.transferFee = 0
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
