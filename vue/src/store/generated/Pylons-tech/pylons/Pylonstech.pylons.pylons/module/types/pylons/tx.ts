/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'
import { ItemRef } from '../pylons/trade'
import { CoinInput, ItemInput, EntriesList, WeightedOutputs } from '../pylons/recipe'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgUpdateAccount {
  creator: string
  username: string
}

export interface MsgUpdateAccountResponse {}

export interface MsgCreateAccount {
  creator: string
  username: string
}

export interface MsgCreateAccountResponse {}

export interface MsgFulfillTrade {
  creator: string
  ID: number
  coinInputsIndex: number
  items: ItemRef[]
}

export interface MsgFulfillTradeResponse {}

export interface MsgCreateTrade {
  creator: string
  coinInputs: CoinInput[]
  itemInputs: ItemInput[]
  coinOutputs: Coin[]
  itemOutputs: ItemRef[]
  extraInfo: string
}

export interface MsgCreateTradeResponse {
  ID: number
}

export interface MsgCancelTrade {
  creator: string
  ID: number
}

export interface MsgCancelTradeResponse {}

export interface MsgCompleteExecutionEarly {
  creator: string
  ID: string
}

export interface MsgCompleteExecutionEarlyResponse {
  ID: string
}

export interface MsgTransferCookbook {
  creator: string
  ID: string
  recipient: string
}

export interface MsgTransferCookbookResponse {}

export interface MsgGoogleInAppPurchaseGetCoins {
  creator: string
  productID: string
  purchaseToken: string
  receiptDataBase64: string
  signature: string
}

export interface MsgGoogleInAppPurchaseGetCoinsResponse {}

export interface MsgSendItems {
  creator: string
  receiver: string
  items: ItemRef[]
}

export interface MsgSendItemsResponse {}

export interface MsgExecuteRecipe {
  creator: string
  cookbookID: string
  recipeID: string
  coinInputsIndex: number
  itemIDs: string[]
}

export interface MsgExecuteRecipeResponse {
  ID: string
}

export interface MsgSetItemString {
  creator: string
  cookbookID: string
  ID: string
  field: string
  value: string
}

export interface MsgSetItemStringResponse {}

export interface MsgCreateRecipe {
  creator: string
  cookbookID: string
  ID: string
  name: string
  description: string
  version: string
  coinInputs: CoinInput[]
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
  coinInputs: CoinInput[]
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
  costPerBlock: Coin | undefined
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
  costPerBlock: Coin | undefined
  enabled: boolean
}

export interface MsgUpdateCookbookResponse {}

const baseMsgUpdateAccount: object = { creator: '', username: '' }

export const MsgUpdateAccount = {
  encode(message: MsgUpdateAccount, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.username !== '') {
      writer.uint32(18).string(message.username)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateAccount } as MsgUpdateAccount
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.username = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateAccount {
    const message = { ...baseMsgUpdateAccount } as MsgUpdateAccount
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = String(object.username)
    } else {
      message.username = ''
    }
    return message
  },

  toJSON(message: MsgUpdateAccount): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.username !== undefined && (obj.username = message.username)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateAccount>): MsgUpdateAccount {
    const message = { ...baseMsgUpdateAccount } as MsgUpdateAccount
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = object.username
    } else {
      message.username = ''
    }
    return message
  }
}

const baseMsgUpdateAccountResponse: object = {}

export const MsgUpdateAccountResponse = {
  encode(_: MsgUpdateAccountResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateAccountResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateAccountResponse } as MsgUpdateAccountResponse
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

  fromJSON(_: any): MsgUpdateAccountResponse {
    const message = { ...baseMsgUpdateAccountResponse } as MsgUpdateAccountResponse
    return message
  },

  toJSON(_: MsgUpdateAccountResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgUpdateAccountResponse>): MsgUpdateAccountResponse {
    const message = { ...baseMsgUpdateAccountResponse } as MsgUpdateAccountResponse
    return message
  }
}

const baseMsgCreateAccount: object = { creator: '', username: '' }

export const MsgCreateAccount = {
  encode(message: MsgCreateAccount, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.username !== '') {
      writer.uint32(18).string(message.username)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.username = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateAccount {
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = String(object.username)
    } else {
      message.username = ''
    }
    return message
  },

  toJSON(message: MsgCreateAccount): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.username !== undefined && (obj.username = message.username)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateAccount>): MsgCreateAccount {
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = object.username
    } else {
      message.username = ''
    }
    return message
  }
}

const baseMsgCreateAccountResponse: object = {}

export const MsgCreateAccountResponse = {
  encode(_: MsgCreateAccountResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateAccountResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateAccountResponse } as MsgCreateAccountResponse
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

  fromJSON(_: any): MsgCreateAccountResponse {
    const message = { ...baseMsgCreateAccountResponse } as MsgCreateAccountResponse
    return message
  },

  toJSON(_: MsgCreateAccountResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgCreateAccountResponse>): MsgCreateAccountResponse {
    const message = { ...baseMsgCreateAccountResponse } as MsgCreateAccountResponse
    return message
  }
}

const baseMsgFulfillTrade: object = { creator: '', ID: 0, coinInputsIndex: 0 }

export const MsgFulfillTrade = {
  encode(message: MsgFulfillTrade, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== 0) {
      writer.uint32(16).uint64(message.ID)
    }
    if (message.coinInputsIndex !== 0) {
      writer.uint32(24).uint64(message.coinInputsIndex)
    }
    for (const v of message.items) {
      ItemRef.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFulfillTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.items = []
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
          message.coinInputsIndex = longToNumber(reader.uint64() as Long)
          break
        case 4:
          message.items.push(ItemRef.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgFulfillTrade {
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.items = []
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
    if (object.coinInputsIndex !== undefined && object.coinInputsIndex !== null) {
      message.coinInputsIndex = Number(object.coinInputsIndex)
    } else {
      message.coinInputsIndex = 0
    }
    if (object.items !== undefined && object.items !== null) {
      for (const e of object.items) {
        message.items.push(ItemRef.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: MsgFulfillTrade): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.coinInputsIndex !== undefined && (obj.coinInputsIndex = message.coinInputsIndex)
    if (message.items) {
      obj.items = message.items.map((e) => (e ? ItemRef.toJSON(e) : undefined))
    } else {
      obj.items = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<MsgFulfillTrade>): MsgFulfillTrade {
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.items = []
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
    if (object.coinInputsIndex !== undefined && object.coinInputsIndex !== null) {
      message.coinInputsIndex = object.coinInputsIndex
    } else {
      message.coinInputsIndex = 0
    }
    if (object.items !== undefined && object.items !== null) {
      for (const e of object.items) {
        message.items.push(ItemRef.fromPartial(e))
      }
    }
    return message
  }
}

const baseMsgFulfillTradeResponse: object = {}

export const MsgFulfillTradeResponse = {
  encode(_: MsgFulfillTradeResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFulfillTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
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

  fromJSON(_: any): MsgFulfillTradeResponse {
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
    return message
  },

  toJSON(_: MsgFulfillTradeResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgFulfillTradeResponse>): MsgFulfillTradeResponse {
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
    return message
  }
}

const baseMsgCreateTrade: object = { creator: '', extraInfo: '' }

export const MsgCreateTrade = {
  encode(message: MsgCreateTrade, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    for (const v of message.coinInputs) {
      CoinInput.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.itemInputs) {
      ItemInput.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.coinOutputs) {
      Coin.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.itemOutputs) {
      ItemRef.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    if (message.extraInfo !== '') {
      writer.uint32(50).string(message.extraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.coinInputs = []
    message.itemInputs = []
    message.coinOutputs = []
    message.itemOutputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.coinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 3:
          message.itemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 4:
          message.coinOutputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 5:
          message.itemOutputs.push(ItemRef.decode(reader, reader.uint32()))
          break
        case 6:
          message.extraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateTrade {
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.coinInputs = []
    message.itemInputs = []
    message.coinOutputs = []
    message.itemOutputs = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(CoinInput.fromJSON(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromJSON(e))
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromJSON(e))
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemRef.fromJSON(e))
      }
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = String(object.extraInfo)
    } else {
      message.extraInfo = ''
    }
    return message
  },

  toJSON(message: MsgCreateTrade): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined))
    } else {
      obj.coinInputs = []
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined))
    } else {
      obj.itemInputs = []
    }
    if (message.coinOutputs) {
      obj.coinOutputs = message.coinOutputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinOutputs = []
    }
    if (message.itemOutputs) {
      obj.itemOutputs = message.itemOutputs.map((e) => (e ? ItemRef.toJSON(e) : undefined))
    } else {
      obj.itemOutputs = []
    }
    message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateTrade>): MsgCreateTrade {
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.coinInputs = []
    message.itemInputs = []
    message.coinOutputs = []
    message.itemOutputs = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(CoinInput.fromPartial(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromPartial(e))
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromPartial(e))
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemRef.fromPartial(e))
      }
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = object.extraInfo
    } else {
      message.extraInfo = ''
    }
    return message
  }
}

const baseMsgCreateTradeResponse: object = { ID: 0 }

export const MsgCreateTradeResponse = {
  encode(message: MsgCreateTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.ID !== 0) {
      writer.uint32(8).uint64(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateTradeResponse {
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = Number(object.ID)
    } else {
      message.ID = 0
    }
    return message
  },

  toJSON(message: MsgCreateTradeResponse): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateTradeResponse>): MsgCreateTradeResponse {
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = 0
    }
    return message
  }
}

const baseMsgCancelTrade: object = { creator: '', ID: 0 }

export const MsgCancelTrade = {
  encode(message: MsgCancelTrade, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== 0) {
      writer.uint32(16).uint64(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCancelTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCancelTrade } as MsgCancelTrade
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.ID = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCancelTrade {
    const message = { ...baseMsgCancelTrade } as MsgCancelTrade
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
    return message
  },

  toJSON(message: MsgCancelTrade): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCancelTrade>): MsgCancelTrade {
    const message = { ...baseMsgCancelTrade } as MsgCancelTrade
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
    return message
  }
}

const baseMsgCancelTradeResponse: object = {}

export const MsgCancelTradeResponse = {
  encode(_: MsgCancelTradeResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCancelTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCancelTradeResponse } as MsgCancelTradeResponse
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

  fromJSON(_: any): MsgCancelTradeResponse {
    const message = { ...baseMsgCancelTradeResponse } as MsgCancelTradeResponse
    return message
  },

  toJSON(_: MsgCancelTradeResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgCancelTradeResponse>): MsgCancelTradeResponse {
    const message = { ...baseMsgCancelTradeResponse } as MsgCancelTradeResponse
    return message
  }
}

const baseMsgCompleteExecutionEarly: object = { creator: '', ID: '' }

export const MsgCompleteExecutionEarly = {
  encode(message: MsgCompleteExecutionEarly, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCompleteExecutionEarly {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCompleteExecutionEarly } as MsgCompleteExecutionEarly
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

  fromJSON(object: any): MsgCompleteExecutionEarly {
    const message = { ...baseMsgCompleteExecutionEarly } as MsgCompleteExecutionEarly
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

  toJSON(message: MsgCompleteExecutionEarly): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCompleteExecutionEarly>): MsgCompleteExecutionEarly {
    const message = { ...baseMsgCompleteExecutionEarly } as MsgCompleteExecutionEarly
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

const baseMsgCompleteExecutionEarlyResponse: object = { ID: '' }

export const MsgCompleteExecutionEarlyResponse = {
  encode(message: MsgCompleteExecutionEarlyResponse, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCompleteExecutionEarlyResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCompleteExecutionEarlyResponse } as MsgCompleteExecutionEarlyResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCompleteExecutionEarlyResponse {
    const message = { ...baseMsgCompleteExecutionEarlyResponse } as MsgCompleteExecutionEarlyResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: MsgCompleteExecutionEarlyResponse): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCompleteExecutionEarlyResponse>): MsgCompleteExecutionEarlyResponse {
    const message = { ...baseMsgCompleteExecutionEarlyResponse } as MsgCompleteExecutionEarlyResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseMsgTransferCookbook: object = { creator: '', ID: '', recipient: '' }

export const MsgTransferCookbook = {
  encode(message: MsgTransferCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.recipient !== '') {
      writer.uint32(26).string(message.recipient)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgTransferCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgTransferCookbook } as MsgTransferCookbook
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
          message.recipient = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgTransferCookbook {
    const message = { ...baseMsgTransferCookbook } as MsgTransferCookbook
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
    if (object.recipient !== undefined && object.recipient !== null) {
      message.recipient = String(object.recipient)
    } else {
      message.recipient = ''
    }
    return message
  },

  toJSON(message: MsgTransferCookbook): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.recipient !== undefined && (obj.recipient = message.recipient)
    return obj
  },

  fromPartial(object: DeepPartial<MsgTransferCookbook>): MsgTransferCookbook {
    const message = { ...baseMsgTransferCookbook } as MsgTransferCookbook
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
    if (object.recipient !== undefined && object.recipient !== null) {
      message.recipient = object.recipient
    } else {
      message.recipient = ''
    }
    return message
  }
}

const baseMsgTransferCookbookResponse: object = {}

export const MsgTransferCookbookResponse = {
  encode(_: MsgTransferCookbookResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgTransferCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgTransferCookbookResponse } as MsgTransferCookbookResponse
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

  fromJSON(_: any): MsgTransferCookbookResponse {
    const message = { ...baseMsgTransferCookbookResponse } as MsgTransferCookbookResponse
    return message
  },

  toJSON(_: MsgTransferCookbookResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgTransferCookbookResponse>): MsgTransferCookbookResponse {
    const message = { ...baseMsgTransferCookbookResponse } as MsgTransferCookbookResponse
    return message
  }
}

const baseMsgGoogleInAppPurchaseGetCoins: object = { creator: '', productID: '', purchaseToken: '', receiptDataBase64: '', signature: '' }

export const MsgGoogleInAppPurchaseGetCoins = {
  encode(message: MsgGoogleInAppPurchaseGetCoins, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.productID !== '') {
      writer.uint32(18).string(message.productID)
    }
    if (message.purchaseToken !== '') {
      writer.uint32(26).string(message.purchaseToken)
    }
    if (message.receiptDataBase64 !== '') {
      writer.uint32(34).string(message.receiptDataBase64)
    }
    if (message.signature !== '') {
      writer.uint32(42).string(message.signature)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGoogleInAppPurchaseGetCoins {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGoogleInAppPurchaseGetCoins } as MsgGoogleInAppPurchaseGetCoins
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.productID = reader.string()
          break
        case 3:
          message.purchaseToken = reader.string()
          break
        case 4:
          message.receiptDataBase64 = reader.string()
          break
        case 5:
          message.signature = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgGoogleInAppPurchaseGetCoins {
    const message = { ...baseMsgGoogleInAppPurchaseGetCoins } as MsgGoogleInAppPurchaseGetCoins
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
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
    if (object.receiptDataBase64 !== undefined && object.receiptDataBase64 !== null) {
      message.receiptDataBase64 = String(object.receiptDataBase64)
    } else {
      message.receiptDataBase64 = ''
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = String(object.signature)
    } else {
      message.signature = ''
    }
    return message
  },

  toJSON(message: MsgGoogleInAppPurchaseGetCoins): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.productID !== undefined && (obj.productID = message.productID)
    message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken)
    message.receiptDataBase64 !== undefined && (obj.receiptDataBase64 = message.receiptDataBase64)
    message.signature !== undefined && (obj.signature = message.signature)
    return obj
  },

  fromPartial(object: DeepPartial<MsgGoogleInAppPurchaseGetCoins>): MsgGoogleInAppPurchaseGetCoins {
    const message = { ...baseMsgGoogleInAppPurchaseGetCoins } as MsgGoogleInAppPurchaseGetCoins
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
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
    if (object.receiptDataBase64 !== undefined && object.receiptDataBase64 !== null) {
      message.receiptDataBase64 = object.receiptDataBase64
    } else {
      message.receiptDataBase64 = ''
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = object.signature
    } else {
      message.signature = ''
    }
    return message
  }
}

const baseMsgGoogleInAppPurchaseGetCoinsResponse: object = {}

export const MsgGoogleInAppPurchaseGetCoinsResponse = {
  encode(_: MsgGoogleInAppPurchaseGetCoinsResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGoogleInAppPurchaseGetCoinsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse } as MsgGoogleInAppPurchaseGetCoinsResponse
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

  fromJSON(_: any): MsgGoogleInAppPurchaseGetCoinsResponse {
    const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse } as MsgGoogleInAppPurchaseGetCoinsResponse
    return message
  },

  toJSON(_: MsgGoogleInAppPurchaseGetCoinsResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgGoogleInAppPurchaseGetCoinsResponse>): MsgGoogleInAppPurchaseGetCoinsResponse {
    const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse } as MsgGoogleInAppPurchaseGetCoinsResponse
    return message
  }
}

const baseMsgSendItems: object = { creator: '', receiver: '' }

export const MsgSendItems = {
  encode(message: MsgSendItems, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.receiver !== '') {
      writer.uint32(18).string(message.receiver)
    }
    for (const v of message.items) {
      ItemRef.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendItems {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.items = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.receiver = reader.string()
          break
        case 3:
          message.items.push(ItemRef.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgSendItems {
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.items = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = String(object.receiver)
    } else {
      message.receiver = ''
    }
    if (object.items !== undefined && object.items !== null) {
      for (const e of object.items) {
        message.items.push(ItemRef.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: MsgSendItems): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.receiver !== undefined && (obj.receiver = message.receiver)
    if (message.items) {
      obj.items = message.items.map((e) => (e ? ItemRef.toJSON(e) : undefined))
    } else {
      obj.items = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<MsgSendItems>): MsgSendItems {
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.items = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = object.receiver
    } else {
      message.receiver = ''
    }
    if (object.items !== undefined && object.items !== null) {
      for (const e of object.items) {
        message.items.push(ItemRef.fromPartial(e))
      }
    }
    return message
  }
}

const baseMsgSendItemsResponse: object = {}

export const MsgSendItemsResponse = {
  encode(_: MsgSendItemsResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendItemsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
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

  fromJSON(_: any): MsgSendItemsResponse {
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
    return message
  },

  toJSON(_: MsgSendItemsResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgSendItemsResponse>): MsgSendItemsResponse {
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
    return message
  }
}

const baseMsgExecuteRecipe: object = { creator: '', cookbookID: '', recipeID: '', coinInputsIndex: 0, itemIDs: '' }

export const MsgExecuteRecipe = {
  encode(message: MsgExecuteRecipe, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.cookbookID !== '') {
      writer.uint32(18).string(message.cookbookID)
    }
    if (message.recipeID !== '') {
      writer.uint32(26).string(message.recipeID)
    }
    if (message.coinInputsIndex !== 0) {
      writer.uint32(32).uint64(message.coinInputsIndex)
    }
    for (const v of message.itemIDs) {
      writer.uint32(42).string(v!)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.itemIDs = []
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
          message.coinInputsIndex = longToNumber(reader.uint64() as Long)
          break
        case 5:
          message.itemIDs.push(reader.string())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgExecuteRecipe {
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.itemIDs = []
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
    if (object.coinInputsIndex !== undefined && object.coinInputsIndex !== null) {
      message.coinInputsIndex = Number(object.coinInputsIndex)
    } else {
      message.coinInputsIndex = 0
    }
    if (object.itemIDs !== undefined && object.itemIDs !== null) {
      for (const e of object.itemIDs) {
        message.itemIDs.push(String(e))
      }
    }
    return message
  },

  toJSON(message: MsgExecuteRecipe): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.recipeID !== undefined && (obj.recipeID = message.recipeID)
    message.coinInputsIndex !== undefined && (obj.coinInputsIndex = message.coinInputsIndex)
    if (message.itemIDs) {
      obj.itemIDs = message.itemIDs.map((e) => e)
    } else {
      obj.itemIDs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<MsgExecuteRecipe>): MsgExecuteRecipe {
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.itemIDs = []
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
    if (object.coinInputsIndex !== undefined && object.coinInputsIndex !== null) {
      message.coinInputsIndex = object.coinInputsIndex
    } else {
      message.coinInputsIndex = 0
    }
    if (object.itemIDs !== undefined && object.itemIDs !== null) {
      for (const e of object.itemIDs) {
        message.itemIDs.push(e)
      }
    }
    return message
  }
}

const baseMsgExecuteRecipeResponse: object = { ID: '' }

export const MsgExecuteRecipeResponse = {
  encode(message: MsgExecuteRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgExecuteRecipeResponse {
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: MsgExecuteRecipeResponse): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgExecuteRecipeResponse>): MsgExecuteRecipeResponse {
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseMsgSetItemString: object = { creator: '', cookbookID: '', ID: '', field: '', value: '' }

export const MsgSetItemString = {
  encode(message: MsgSetItemString, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.cookbookID !== '') {
      writer.uint32(18).string(message.cookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(34).string(message.ID)
    }
    if (message.field !== '') {
      writer.uint32(42).string(message.field)
    }
    if (message.value !== '') {
      writer.uint32(50).string(message.value)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSetItemString {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSetItemString } as MsgSetItemString
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.cookbookID = reader.string()
          break
        case 4:
          message.ID = reader.string()
          break
        case 5:
          message.field = reader.string()
          break
        case 6:
          message.value = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgSetItemString {
    const message = { ...baseMsgSetItemString } as MsgSetItemString
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
    if (object.field !== undefined && object.field !== null) {
      message.field = String(object.field)
    } else {
      message.field = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = String(object.value)
    } else {
      message.value = ''
    }
    return message
  },

  toJSON(message: MsgSetItemString): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    message.field !== undefined && (obj.field = message.field)
    message.value !== undefined && (obj.value = message.value)
    return obj
  },

  fromPartial(object: DeepPartial<MsgSetItemString>): MsgSetItemString {
    const message = { ...baseMsgSetItemString } as MsgSetItemString
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
    if (object.field !== undefined && object.field !== null) {
      message.field = object.field
    } else {
      message.field = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = object.value
    } else {
      message.value = ''
    }
    return message
  }
}

const baseMsgSetItemStringResponse: object = {}

export const MsgSetItemStringResponse = {
  encode(_: MsgSetItemStringResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSetItemStringResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSetItemStringResponse } as MsgSetItemStringResponse
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

  fromJSON(_: any): MsgSetItemStringResponse {
    const message = { ...baseMsgSetItemStringResponse } as MsgSetItemStringResponse
    return message
  },

  toJSON(_: MsgSetItemStringResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgSetItemStringResponse>): MsgSetItemStringResponse {
    const message = { ...baseMsgSetItemStringResponse } as MsgSetItemStringResponse
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
      CoinInput.encode(v!, writer.uint32(58).fork()).ldelim()
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
      writer.uint32(88).int64(message.blockInterval)
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
          message.coinInputs.push(CoinInput.decode(reader, reader.uint32()))
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
          message.blockInterval = longToNumber(reader.int64() as Long)
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
        message.coinInputs.push(CoinInput.fromJSON(e))
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
      obj.coinInputs = message.coinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined))
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
        message.coinInputs.push(CoinInput.fromPartial(e))
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
      CoinInput.encode(v!, writer.uint32(58).fork()).ldelim()
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
      writer.uint32(88).int64(message.blockInterval)
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
          message.coinInputs.push(CoinInput.decode(reader, reader.uint32()))
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
          message.blockInterval = longToNumber(reader.int64() as Long)
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
        message.coinInputs.push(CoinInput.fromJSON(e))
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
      obj.coinInputs = message.coinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined))
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
        message.coinInputs.push(CoinInput.fromPartial(e))
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

const baseMsgCreateCookbook: object = { creator: '', ID: '', name: '', description: '', developer: '', version: '', supportEmail: '', enabled: false }

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
    if (message.costPerBlock !== undefined) {
      Coin.encode(message.costPerBlock, writer.uint32(66).fork()).ldelim()
    }
    if (message.enabled === true) {
      writer.uint32(72).bool(message.enabled)
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
          message.costPerBlock = Coin.decode(reader, reader.uint32())
          break
        case 9:
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
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Coin.fromJSON(object.costPerBlock)
    } else {
      message.costPerBlock = undefined
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
    message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock ? Coin.toJSON(message.costPerBlock) : undefined)
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
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Coin.fromPartial(object.costPerBlock)
    } else {
      message.costPerBlock = undefined
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

const baseMsgUpdateCookbook: object = { creator: '', ID: '', name: '', description: '', developer: '', version: '', supportEmail: '', enabled: false }

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
    if (message.costPerBlock !== undefined) {
      Coin.encode(message.costPerBlock, writer.uint32(66).fork()).ldelim()
    }
    if (message.enabled === true) {
      writer.uint32(72).bool(message.enabled)
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
          message.costPerBlock = Coin.decode(reader, reader.uint32())
          break
        case 9:
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
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Coin.fromJSON(object.costPerBlock)
    } else {
      message.costPerBlock = undefined
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
    message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock ? Coin.toJSON(message.costPerBlock) : undefined)
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
    if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
      message.costPerBlock = Coin.fromPartial(object.costPerBlock)
    } else {
      message.costPerBlock = undefined
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
  UpdateAccount(request: MsgUpdateAccount): Promise<MsgUpdateAccountResponse>
  FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse>
  CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse>
  CancelTrade(request: MsgCancelTrade): Promise<MsgCancelTradeResponse>
  CompleteExecutionEarly(request: MsgCompleteExecutionEarly): Promise<MsgCompleteExecutionEarlyResponse>
  TransferCookbook(request: MsgTransferCookbook): Promise<MsgTransferCookbookResponse>
  GoogleInAppPurchaseGetCoins(request: MsgGoogleInAppPurchaseGetCoins): Promise<MsgGoogleInAppPurchaseGetCoinsResponse>
  CreateAccount(request: MsgCreateAccount): Promise<MsgCreateAccountResponse>
  SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse>
  ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>
  SetItemString(request: MsgSetItemString): Promise<MsgSetItemStringResponse>
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
  UpdateAccount(request: MsgUpdateAccount): Promise<MsgUpdateAccountResponse> {
    const data = MsgUpdateAccount.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateAccount', data)
    return promise.then((data) => MsgUpdateAccountResponse.decode(new Reader(data)))
  }

  FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse> {
    const data = MsgFulfillTrade.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'FulfillTrade', data)
    return promise.then((data) => MsgFulfillTradeResponse.decode(new Reader(data)))
  }

  CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse> {
    const data = MsgCreateTrade.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateTrade', data)
    return promise.then((data) => MsgCreateTradeResponse.decode(new Reader(data)))
  }

  CancelTrade(request: MsgCancelTrade): Promise<MsgCancelTradeResponse> {
    const data = MsgCancelTrade.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CancelTrade', data)
    return promise.then((data) => MsgCancelTradeResponse.decode(new Reader(data)))
  }

  CompleteExecutionEarly(request: MsgCompleteExecutionEarly): Promise<MsgCompleteExecutionEarlyResponse> {
    const data = MsgCompleteExecutionEarly.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CompleteExecutionEarly', data)
    return promise.then((data) => MsgCompleteExecutionEarlyResponse.decode(new Reader(data)))
  }

  TransferCookbook(request: MsgTransferCookbook): Promise<MsgTransferCookbookResponse> {
    const data = MsgTransferCookbook.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'TransferCookbook', data)
    return promise.then((data) => MsgTransferCookbookResponse.decode(new Reader(data)))
  }

  GoogleInAppPurchaseGetCoins(request: MsgGoogleInAppPurchaseGetCoins): Promise<MsgGoogleInAppPurchaseGetCoinsResponse> {
    const data = MsgGoogleInAppPurchaseGetCoins.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'GoogleInAppPurchaseGetCoins', data)
    return promise.then((data) => MsgGoogleInAppPurchaseGetCoinsResponse.decode(new Reader(data)))
  }

  CreateAccount(request: MsgCreateAccount): Promise<MsgCreateAccountResponse> {
    const data = MsgCreateAccount.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateAccount', data)
    return promise.then((data) => MsgCreateAccountResponse.decode(new Reader(data)))
  }

  SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse> {
    const data = MsgSendItems.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'SendItems', data)
    return promise.then((data) => MsgSendItemsResponse.decode(new Reader(data)))
  }

  ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse> {
    const data = MsgExecuteRecipe.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'ExecuteRecipe', data)
    return promise.then((data) => MsgExecuteRecipeResponse.decode(new Reader(data)))
  }

  SetItemString(request: MsgSetItemString): Promise<MsgSetItemStringResponse> {
    const data = MsgSetItemString.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'SetItemString', data)
    return promise.then((data) => MsgSetItemStringResponse.decode(new Reader(data)))
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
