/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'
import { DoubleKeyValue, LongKeyValue, StringKeyValue } from '../pylons/item'
import { Coin } from '../cosmos/base/v1beta1/coin'
import { ItemInput, EntriesList, WeightedOutputs } from '../pylons/recipe'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgCreateItem {
  creator: string
  ID: string
  cookbookID: string
  nodeVersion: string
  Doubles: DoubleKeyValue[]
  Longs: LongKeyValue[]
  Strings: StringKeyValue[]
  ownerRecipeID: string
  ownerTradeID: string
  tradable: boolean
  lastUpdate: number
  transferFee: number
}

export interface MsgCreateItemResponse {}

export interface MsgUpdateItem {
  creator: string
  ID: string
  cookbookID: string
  nodeVersion: string
  Doubles: DoubleKeyValue[]
  Longs: LongKeyValue[]
  Strings: StringKeyValue[]
  ownerRecipeID: string
  ownerTradeID: string
  tradable: boolean
  lastUpdate: number
  transferFee: number
}

export interface MsgUpdateItemResponse {}

export interface MsgDeleteItem {
  creator: string
  ID: string
}

export interface MsgDeleteItemResponse {}

export interface MsgCreateRecipe {
  creator: string
  cookbookID: string
  ID: string
  name: string
  description: string
  version: string
  coinInputs: Coin[]
  itemInputs: ItemInput[]
  entries: EntriesList | undefined
  outputs: WeightedOutputs[]
  blockInterval: number
  enabled: boolean
  extraInfo: string
}

export interface MsgCreateRecipeResponse {}

export interface MsgUpdateRecipe {
  creator: string
  cookbookID: string
  ID: string
  name: string
  description: string
  version: string
  coinInputs: Coin[]
  itemInputs: ItemInput[]
  entries: EntriesList | undefined
  outputs: WeightedOutputs[]
  blockInterval: number
  enabled: boolean
  extraInfo: string
}

export interface MsgUpdateRecipeResponse {}

export interface MsgCreateCookbook {
  creator: string
  ID: string
  name: string
  description: string
  developer: string
  version: string
  supportEmail: string
  tier: number
  costPerBlock: number
  enabled: boolean
}

export interface MsgCreateCookbookResponse {}

export interface MsgUpdateCookbook {
  creator: string
  ID: string
  name: string
  description: string
  developer: string
  version: string
  supportEmail: string
  tier: number
  costPerBlock: number
  enabled: boolean
}

export interface MsgUpdateCookbookResponse {}

const baseMsgCreateItem: object = {
  creator: '',
  ID: '',
  cookbookID: '',
  nodeVersion: '',
  ownerRecipeID: '',
  ownerTradeID: '',
  tradable: false,
  lastUpdate: 0,
  transferFee: 0
}

export const MsgCreateItem = {
  encode(message: MsgCreateItem, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.cookbookID !== '') {
      writer.uint32(26).string(message.cookbookID)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(34).string(message.nodeVersion)
    }
    for (const v of message.Doubles) {
      DoubleKeyValue.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.Longs) {
      LongKeyValue.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    for (const v of message.Strings) {
      StringKeyValue.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    if (message.ownerRecipeID !== '') {
      writer.uint32(74).string(message.ownerRecipeID)
    }
    if (message.ownerTradeID !== '') {
      writer.uint32(82).string(message.ownerTradeID)
    }
    if (message.tradable === true) {
      writer.uint32(88).bool(message.tradable)
    }
    if (message.lastUpdate !== 0) {
      writer.uint32(96).uint64(message.lastUpdate)
    }
    if (message.transferFee !== 0) {
      writer.uint32(104).uint64(message.transferFee)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateItem {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateItem } as MsgCreateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.cookbookID = reader.string()
          break
        case 4:
          message.nodeVersion = reader.string()
          break
        case 5:
          message.Doubles.push(DoubleKeyValue.decode(reader, reader.uint32()))
          break
        case 6:
          message.Longs.push(LongKeyValue.decode(reader, reader.uint32()))
          break
        case 7:
          message.Strings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        case 9:
          message.ownerRecipeID = reader.string()
          break
        case 10:
          message.ownerTradeID = reader.string()
          break
        case 11:
          message.tradable = reader.bool()
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

  fromJSON(object: any): MsgCreateItem {
    const message = { ...baseMsgCreateItem } as MsgCreateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromJSON(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromJSON(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromJSON(e))
      }
    }
    if (object.ownerRecipeID !== undefined && object.ownerRecipeID !== null) {
      message.ownerRecipeID = String(object.ownerRecipeID)
    } else {
      message.ownerRecipeID = ''
    }
    if (object.ownerTradeID !== undefined && object.ownerTradeID !== null) {
      message.ownerTradeID = String(object.ownerTradeID)
    } else {
      message.ownerTradeID = ''
    }
    if (object.tradable !== undefined && object.tradable !== null) {
      message.tradable = Boolean(object.tradable)
    } else {
      message.tradable = false
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

  toJSON(message: MsgCreateItem): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    if (message.Doubles) {
      obj.Doubles = message.Doubles.map((e) => (e ? DoubleKeyValue.toJSON(e) : undefined))
    } else {
      obj.Doubles = []
    }
    if (message.Longs) {
      obj.Longs = message.Longs.map((e) => (e ? LongKeyValue.toJSON(e) : undefined))
    } else {
      obj.Longs = []
    }
    if (message.Strings) {
      obj.Strings = message.Strings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.Strings = []
    }
    message.ownerRecipeID !== undefined && (obj.ownerRecipeID = message.ownerRecipeID)
    message.ownerTradeID !== undefined && (obj.ownerTradeID = message.ownerTradeID)
    message.tradable !== undefined && (obj.tradable = message.tradable)
    message.lastUpdate !== undefined && (obj.lastUpdate = message.lastUpdate)
    message.transferFee !== undefined && (obj.transferFee = message.transferFee)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateItem>): MsgCreateItem {
    const message = { ...baseMsgCreateItem } as MsgCreateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromPartial(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromPartial(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromPartial(e))
      }
    }
    if (object.ownerRecipeID !== undefined && object.ownerRecipeID !== null) {
      message.ownerRecipeID = object.ownerRecipeID
    } else {
      message.ownerRecipeID = ''
    }
    if (object.ownerTradeID !== undefined && object.ownerTradeID !== null) {
      message.ownerTradeID = object.ownerTradeID
    } else {
      message.ownerTradeID = ''
    }
    if (object.tradable !== undefined && object.tradable !== null) {
      message.tradable = object.tradable
    } else {
      message.tradable = false
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

const baseMsgCreateItemResponse: object = {}

export const MsgCreateItemResponse = {
  encode(_: MsgCreateItemResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateItemResponse } as MsgCreateItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgCreateItemResponse {
    const message = { ...baseMsgCreateItemResponse } as MsgCreateItemResponse
    return message
  },

  toJSON(_: MsgCreateItemResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgCreateItemResponse>): MsgCreateItemResponse {
    const message = { ...baseMsgCreateItemResponse } as MsgCreateItemResponse
    return message
  }
}

const baseMsgUpdateItem: object = {
  creator: '',
  ID: '',
  cookbookID: '',
  nodeVersion: '',
  ownerRecipeID: '',
  ownerTradeID: '',
  tradable: false,
  lastUpdate: 0,
  transferFee: 0
}

export const MsgUpdateItem = {
  encode(message: MsgUpdateItem, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.cookbookID !== '') {
      writer.uint32(26).string(message.cookbookID)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(34).string(message.nodeVersion)
    }
    for (const v of message.Doubles) {
      DoubleKeyValue.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.Longs) {
      LongKeyValue.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    for (const v of message.Strings) {
      StringKeyValue.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    if (message.ownerRecipeID !== '') {
      writer.uint32(74).string(message.ownerRecipeID)
    }
    if (message.ownerTradeID !== '') {
      writer.uint32(82).string(message.ownerTradeID)
    }
    if (message.tradable === true) {
      writer.uint32(88).bool(message.tradable)
    }
    if (message.lastUpdate !== 0) {
      writer.uint32(96).uint64(message.lastUpdate)
    }
    if (message.transferFee !== 0) {
      writer.uint32(104).uint64(message.transferFee)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateItem {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateItem } as MsgUpdateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.cookbookID = reader.string()
          break
        case 4:
          message.nodeVersion = reader.string()
          break
        case 5:
          message.Doubles.push(DoubleKeyValue.decode(reader, reader.uint32()))
          break
        case 6:
          message.Longs.push(LongKeyValue.decode(reader, reader.uint32()))
          break
        case 7:
          message.Strings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        case 9:
          message.ownerRecipeID = reader.string()
          break
        case 10:
          message.ownerTradeID = reader.string()
          break
        case 11:
          message.tradable = reader.bool()
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

  fromJSON(object: any): MsgUpdateItem {
    const message = { ...baseMsgUpdateItem } as MsgUpdateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromJSON(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromJSON(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromJSON(e))
      }
    }
    if (object.ownerRecipeID !== undefined && object.ownerRecipeID !== null) {
      message.ownerRecipeID = String(object.ownerRecipeID)
    } else {
      message.ownerRecipeID = ''
    }
    if (object.ownerTradeID !== undefined && object.ownerTradeID !== null) {
      message.ownerTradeID = String(object.ownerTradeID)
    } else {
      message.ownerTradeID = ''
    }
    if (object.tradable !== undefined && object.tradable !== null) {
      message.tradable = Boolean(object.tradable)
    } else {
      message.tradable = false
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

  toJSON(message: MsgUpdateItem): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    if (message.Doubles) {
      obj.Doubles = message.Doubles.map((e) => (e ? DoubleKeyValue.toJSON(e) : undefined))
    } else {
      obj.Doubles = []
    }
    if (message.Longs) {
      obj.Longs = message.Longs.map((e) => (e ? LongKeyValue.toJSON(e) : undefined))
    } else {
      obj.Longs = []
    }
    if (message.Strings) {
      obj.Strings = message.Strings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.Strings = []
    }
    message.ownerRecipeID !== undefined && (obj.ownerRecipeID = message.ownerRecipeID)
    message.ownerTradeID !== undefined && (obj.ownerTradeID = message.ownerTradeID)
    message.tradable !== undefined && (obj.tradable = message.tradable)
    message.lastUpdate !== undefined && (obj.lastUpdate = message.lastUpdate)
    message.transferFee !== undefined && (obj.transferFee = message.transferFee)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateItem>): MsgUpdateItem {
    const message = { ...baseMsgUpdateItem } as MsgUpdateItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromPartial(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromPartial(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromPartial(e))
      }
    }
    if (object.ownerRecipeID !== undefined && object.ownerRecipeID !== null) {
      message.ownerRecipeID = object.ownerRecipeID
    } else {
      message.ownerRecipeID = ''
    }
    if (object.ownerTradeID !== undefined && object.ownerTradeID !== null) {
      message.ownerTradeID = object.ownerTradeID
    } else {
      message.ownerTradeID = ''
    }
    if (object.tradable !== undefined && object.tradable !== null) {
      message.tradable = object.tradable
    } else {
      message.tradable = false
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

const baseMsgUpdateItemResponse: object = {}

export const MsgUpdateItemResponse = {
  encode(_: MsgUpdateItemResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateItemResponse } as MsgUpdateItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgUpdateItemResponse {
    const message = { ...baseMsgUpdateItemResponse } as MsgUpdateItemResponse
    return message
  },

  toJSON(_: MsgUpdateItemResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgUpdateItemResponse>): MsgUpdateItemResponse {
    const message = { ...baseMsgUpdateItemResponse } as MsgUpdateItemResponse
    return message
  }
}

const baseMsgDeleteItem: object = { creator: '', ID: '' }

export const MsgDeleteItem = {
  encode(message: MsgDeleteItem, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDeleteItem {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDeleteItem } as MsgDeleteItem
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgDeleteItem {
    const message = { ...baseMsgDeleteItem } as MsgDeleteItem
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: MsgDeleteItem): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgDeleteItem>): MsgDeleteItem {
    const message = { ...baseMsgDeleteItem } as MsgDeleteItem
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseMsgDeleteItemResponse: object = {}

export const MsgDeleteItemResponse = {
  encode(_: MsgDeleteItemResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDeleteItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDeleteItemResponse } as MsgDeleteItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgDeleteItemResponse {
    const message = { ...baseMsgDeleteItemResponse } as MsgDeleteItemResponse
    return message
  },

  toJSON(_: MsgDeleteItemResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgDeleteItemResponse>): MsgDeleteItemResponse {
    const message = { ...baseMsgDeleteItemResponse } as MsgDeleteItemResponse
    return message
  }
}

const baseMsgCreateRecipe: object = {
  creator: '',
  cookbookID: '',
  ID: '',
  name: '',
  description: '',
  version: '',
  blockInterval: 0,
  enabled: false,
  extraInfo: ''
}

export const MsgCreateRecipe = {
  encode(message: MsgCreateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.cookbookID !== '') {
      writer.uint32(18).string(message.cookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    if (message.name !== '') {
      writer.uint32(34).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(42).string(message.description)
    }
    if (message.version !== '') {
      writer.uint32(50).string(message.version)
    }
    for (const v of message.coinInputs) {
      Coin.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.itemInputs) {
      ItemInput.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    if (message.entries !== undefined) {
      EntriesList.encode(message.entries, writer.uint32(74).fork()).ldelim()
    }
    for (const v of message.outputs) {
      WeightedOutputs.encode(v!, writer.uint32(82).fork()).ldelim()
    }
    if (message.blockInterval !== 0) {
      writer.uint32(88).uint64(message.blockInterval)
    }
    if (message.enabled === true) {
      writer.uint32(96).bool(message.enabled)
    }
    if (message.extraInfo !== '') {
      writer.uint32(106).string(message.extraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
          message.ID = reader.string()
          break
        case 4:
          message.name = reader.string()
          break
        case 5:
          message.description = reader.string()
          break
        case 6:
          message.version = reader.string()
          break
        case 7:
          message.coinInputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 8:
          message.itemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 9:
          message.entries = EntriesList.decode(reader, reader.uint32())
          break
        case 10:
          message.outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 11:
          message.blockInterval = longToNumber(reader.uint64() as Long)
          break
        case 12:
          message.enabled = reader.bool()
          break
        case 13:
          message.extraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateRecipe {
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = String(object.name)
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = String(object.description)
    } else {
      message.description = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = String(object.version)
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromJSON(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromJSON(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromJSON(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromJSON(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = Number(object.blockInterval)
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = Boolean(object.enabled)
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = String(object.extraInfo)
    } else {
      message.extraInfo = ''
    }
    return message
  },

  toJSON(message: MsgCreateRecipe): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.version !== undefined && (obj.version = message.version)
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinInputs = []
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined))
    } else {
      obj.itemInputs = []
    }
    message.entries !== undefined && (obj.entries = message.entries ? EntriesList.toJSON(message.entries) : undefined)
    if (message.outputs) {
      obj.outputs = message.outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.outputs = []
    }
    message.blockInterval !== undefined && (obj.blockInterval = message.blockInterval)
    message.enabled !== undefined && (obj.enabled = message.enabled)
    message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateRecipe>): MsgCreateRecipe {
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = object.name
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = object.description
    } else {
      message.description = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = object.version
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromPartial(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromPartial(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromPartial(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromPartial(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = object.blockInterval
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = object.enabled
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = object.extraInfo
    } else {
      message.extraInfo = ''
    }
    return message
  }
}

const baseMsgCreateRecipeResponse: object = {}

export const MsgCreateRecipeResponse = {
  encode(_: MsgCreateRecipeResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgCreateRecipeResponse {
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    return message
  },

  toJSON(_: MsgCreateRecipeResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgCreateRecipeResponse>): MsgCreateRecipeResponse {
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    return message
  }
}

const baseMsgUpdateRecipe: object = {
  creator: '',
  cookbookID: '',
  ID: '',
  name: '',
  description: '',
  version: '',
  blockInterval: 0,
  enabled: false,
  extraInfo: ''
}

export const MsgUpdateRecipe = {
  encode(message: MsgUpdateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.cookbookID !== '') {
      writer.uint32(18).string(message.cookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    if (message.name !== '') {
      writer.uint32(34).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(42).string(message.description)
    }
    if (message.version !== '') {
      writer.uint32(50).string(message.version)
    }
    for (const v of message.coinInputs) {
      Coin.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.itemInputs) {
      ItemInput.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    if (message.entries !== undefined) {
      EntriesList.encode(message.entries, writer.uint32(74).fork()).ldelim()
    }
    for (const v of message.outputs) {
      WeightedOutputs.encode(v!, writer.uint32(82).fork()).ldelim()
    }
    if (message.blockInterval !== 0) {
      writer.uint32(88).uint64(message.blockInterval)
    }
    if (message.enabled === true) {
      writer.uint32(96).bool(message.enabled)
    }
    if (message.extraInfo !== '') {
      writer.uint32(106).string(message.extraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
          message.ID = reader.string()
          break
        case 4:
          message.name = reader.string()
          break
        case 5:
          message.description = reader.string()
          break
        case 6:
          message.version = reader.string()
          break
        case 7:
          message.coinInputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 8:
          message.itemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 9:
          message.entries = EntriesList.decode(reader, reader.uint32())
          break
        case 10:
          message.outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 11:
          message.blockInterval = longToNumber(reader.uint64() as Long)
          break
        case 12:
          message.enabled = reader.bool()
          break
        case 13:
          message.extraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateRecipe {
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = String(object.name)
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = String(object.description)
    } else {
      message.description = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = String(object.version)
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromJSON(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromJSON(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromJSON(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromJSON(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = Number(object.blockInterval)
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = Boolean(object.enabled)
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = String(object.extraInfo)
    } else {
      message.extraInfo = ''
    }
    return message
  },

  toJSON(message: MsgUpdateRecipe): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.version !== undefined && (obj.version = message.version)
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinInputs = []
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined))
    } else {
      obj.itemInputs = []
    }
    message.entries !== undefined && (obj.entries = message.entries ? EntriesList.toJSON(message.entries) : undefined)
    if (message.outputs) {
      obj.outputs = message.outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.outputs = []
    }
    message.blockInterval !== undefined && (obj.blockInterval = message.blockInterval)
    message.enabled !== undefined && (obj.enabled = message.enabled)
    message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateRecipe>): MsgUpdateRecipe {
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = object.name
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = object.description
    } else {
      message.description = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = object.version
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromPartial(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromPartial(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromPartial(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromPartial(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = object.blockInterval
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = object.enabled
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = object.extraInfo
    } else {
      message.extraInfo = ''
    }
    return message
  }
}

const baseMsgUpdateRecipeResponse: object = {}

export const MsgUpdateRecipeResponse = {
  encode(_: MsgUpdateRecipeResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgUpdateRecipeResponse {
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    return message
  },

  toJSON(_: MsgUpdateRecipeResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgUpdateRecipeResponse>): MsgUpdateRecipeResponse {
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    return message
  }
}

const baseMsgCreateCookbook: object = {
  creator: '',
  ID: '',
  name: '',
  description: '',
  developer: '',
  version: '',
  supportEmail: '',
  tier: 0,
  costPerBlock: 0,
  enabled: false
}

export const MsgCreateCookbook = {
  encode(message: MsgCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.name !== '') {
      writer.uint32(26).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(34).string(message.description)
    }
    if (message.developer !== '') {
      writer.uint32(42).string(message.developer)
    }
    if (message.version !== '') {
      writer.uint32(50).string(message.version)
    }
    if (message.supportEmail !== '') {
      writer.uint32(58).string(message.supportEmail)
    }
    if (message.tier !== 0) {
      writer.uint32(64).int64(message.tier)
    }
    if (message.costPerBlock !== 0) {
      writer.uint32(72).uint64(message.costPerBlock)
    }
    if (message.enabled === true) {
      writer.uint32(80).bool(message.enabled)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateCookbook } as MsgCreateCookbook
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.name = reader.string()
          break
        case 4:
          message.description = reader.string()
          break
        case 5:
          message.developer = reader.string()
          break
        case 6:
          message.version = reader.string()
          break
        case 7:
          message.supportEmail = reader.string()
          break
        case 8:
          message.tier = longToNumber(reader.int64() as Long)
          break
        case 9:
          message.costPerBlock = longToNumber(reader.uint64() as Long)
          break
        case 10:
          message.enabled = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateCookbook {
    const message = { ...baseMsgCreateCookbook } as MsgCreateCookbook
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = String(object.name)
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = String(object.description)
    } else {
      message.description = ''
    }
    if (object.developer !== undefined && object.developer !== null) {
      message.developer = String(object.developer)
    } else {
      message.developer = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = String(object.version)
    } else {
      message.version = ''
    }
    if (object.supportEmail !== undefined && object.supportEmail !== null) {
      message.supportEmail = String(object.supportEmail)
    } else {
      message.supportEmail = ''
    }
    if (object.tier !== undefined && object.tier !== null) {
      message.tier = Number(object.tier)
    } else {
      message.tier = 0
    }
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Number(object.costPerBlock)
    } else {
      message.costPerBlock = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = Boolean(object.enabled)
    } else {
      message.enabled = false
    }
    return message
  },

  toJSON(message: MsgCreateCookbook): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.developer !== undefined && (obj.developer = message.developer)
    message.version !== undefined && (obj.version = message.version)
    message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail)
    message.tier !== undefined && (obj.tier = message.tier)
    message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock)
    message.enabled !== undefined && (obj.enabled = message.enabled)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateCookbook>): MsgCreateCookbook {
    const message = { ...baseMsgCreateCookbook } as MsgCreateCookbook
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = object.name
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = object.description
    } else {
      message.description = ''
    }
    if (object.developer !== undefined && object.developer !== null) {
      message.developer = object.developer
    } else {
      message.developer = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = object.version
    } else {
      message.version = ''
    }
    if (object.supportEmail !== undefined && object.supportEmail !== null) {
      message.supportEmail = object.supportEmail
    } else {
      message.supportEmail = ''
    }
    if (object.tier !== undefined && object.tier !== null) {
      message.tier = object.tier
    } else {
      message.tier = 0
    }
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = object.costPerBlock
    } else {
      message.costPerBlock = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = object.enabled
    } else {
      message.enabled = false
    }
    return message
  }
}

const baseMsgCreateCookbookResponse: object = {}

export const MsgCreateCookbookResponse = {
  encode(_: MsgCreateCookbookResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgCreateCookbookResponse {
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    return message
  },

  toJSON(_: MsgCreateCookbookResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgCreateCookbookResponse>): MsgCreateCookbookResponse {
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    return message
  }
}

const baseMsgUpdateCookbook: object = {
  creator: '',
  ID: '',
  name: '',
  description: '',
  developer: '',
  version: '',
  supportEmail: '',
  tier: 0,
  costPerBlock: 0,
  enabled: false
}

export const MsgUpdateCookbook = {
  encode(message: MsgUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.name !== '') {
      writer.uint32(26).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(34).string(message.description)
    }
    if (message.developer !== '') {
      writer.uint32(42).string(message.developer)
    }
    if (message.version !== '') {
      writer.uint32(50).string(message.version)
    }
    if (message.supportEmail !== '') {
      writer.uint32(58).string(message.supportEmail)
    }
    if (message.tier !== 0) {
      writer.uint32(64).int64(message.tier)
    }
    if (message.costPerBlock !== 0) {
      writer.uint32(72).uint64(message.costPerBlock)
    }
    if (message.enabled === true) {
      writer.uint32(80).bool(message.enabled)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateCookbook } as MsgUpdateCookbook
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.name = reader.string()
          break
        case 4:
          message.description = reader.string()
          break
        case 5:
          message.developer = reader.string()
          break
        case 6:
          message.version = reader.string()
          break
        case 7:
          message.supportEmail = reader.string()
          break
        case 8:
          message.tier = longToNumber(reader.int64() as Long)
          break
        case 9:
          message.costPerBlock = longToNumber(reader.uint64() as Long)
          break
        case 10:
          message.enabled = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateCookbook {
    const message = { ...baseMsgUpdateCookbook } as MsgUpdateCookbook
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = String(object.name)
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = String(object.description)
    } else {
      message.description = ''
    }
    if (object.developer !== undefined && object.developer !== null) {
      message.developer = String(object.developer)
    } else {
      message.developer = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = String(object.version)
    } else {
      message.version = ''
    }
    if (object.supportEmail !== undefined && object.supportEmail !== null) {
      message.supportEmail = String(object.supportEmail)
    } else {
      message.supportEmail = ''
    }
    if (object.tier !== undefined && object.tier !== null) {
      message.tier = Number(object.tier)
    } else {
      message.tier = 0
    }
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Number(object.costPerBlock)
    } else {
      message.costPerBlock = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = Boolean(object.enabled)
    } else {
      message.enabled = false
    }
    return message
  },

  toJSON(message: MsgUpdateCookbook): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.developer !== undefined && (obj.developer = message.developer)
    message.version !== undefined && (obj.version = message.version)
    message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail)
    message.tier !== undefined && (obj.tier = message.tier)
    message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock)
    message.enabled !== undefined && (obj.enabled = message.enabled)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateCookbook>): MsgUpdateCookbook {
    const message = { ...baseMsgUpdateCookbook } as MsgUpdateCookbook
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.name !== undefined && object.name !== null) {
      message.name = object.name
    } else {
      message.name = ''
    }
    if (object.description !== undefined && object.description !== null) {
      message.description = object.description
    } else {
      message.description = ''
    }
    if (object.developer !== undefined && object.developer !== null) {
      message.developer = object.developer
    } else {
      message.developer = ''
    }
    if (object.version !== undefined && object.version !== null) {
      message.version = object.version
    } else {
      message.version = ''
    }
    if (object.supportEmail !== undefined && object.supportEmail !== null) {
      message.supportEmail = object.supportEmail
    } else {
      message.supportEmail = ''
    }
    if (object.tier !== undefined && object.tier !== null) {
      message.tier = object.tier
    } else {
      message.tier = 0
    }
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = object.costPerBlock
    } else {
      message.costPerBlock = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = object.enabled
    } else {
      message.enabled = false
    }
    return message
  }
}

const baseMsgUpdateCookbookResponse: object = {}

export const MsgUpdateCookbookResponse = {
  encode(_: MsgUpdateCookbookResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(_: any): MsgUpdateCookbookResponse {
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    return message
  },

  toJSON(_: MsgUpdateCookbookResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgUpdateCookbookResponse>): MsgUpdateCookbookResponse {
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    return message
  }
}

/** Msg defines the Msg service. */
export interface Msg {
  /** this line is used by starport scaffolding # proto/tx/rpc */
  CreateItem(request: MsgCreateItem): Promise<MsgCreateItemResponse>
  UpdateItem(request: MsgUpdateItem): Promise<MsgUpdateItemResponse>
  DeleteItem(request: MsgDeleteItem): Promise<MsgDeleteItemResponse>
  CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>
  UpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>
  CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>
  UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>
}

export class MsgClientImpl implements Msg {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
  }
  CreateItem(request: MsgCreateItem): Promise<MsgCreateItemResponse> {
    const data = MsgCreateItem.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateItem', data)
    return promise.then((data) => MsgCreateItemResponse.decode(new Reader(data)))
  }

  UpdateItem(request: MsgUpdateItem): Promise<MsgUpdateItemResponse> {
    const data = MsgUpdateItem.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateItem', data)
    return promise.then((data) => MsgUpdateItemResponse.decode(new Reader(data)))
  }

  DeleteItem(request: MsgDeleteItem): Promise<MsgDeleteItemResponse> {
    const data = MsgDeleteItem.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'DeleteItem', data)
    return promise.then((data) => MsgDeleteItemResponse.decode(new Reader(data)))
  }

  CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse> {
    const data = MsgCreateRecipe.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateRecipe', data)
    return promise.then((data) => MsgCreateRecipeResponse.decode(new Reader(data)))
  }

  UpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse> {
    const data = MsgUpdateRecipe.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateRecipe', data)
    return promise.then((data) => MsgUpdateRecipeResponse.decode(new Reader(data)))
  }

  CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse> {
    const data = MsgCreateCookbook.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateCookbook', data)
    return promise.then((data) => MsgCreateCookbookResponse.decode(new Reader(data)))
  }

  UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse> {
    const data = MsgUpdateCookbook.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateCookbook', data)
    return promise.then((data) => MsgUpdateCookbookResponse.decode(new Reader(data)))
  }
}

interface Rpc {
  request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>
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
