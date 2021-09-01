/* eslint-disable */
import { Cookbook } from '../pylons/cookbook'
import { Recipe } from '../pylons/recipe'
import { Coin } from '../cosmos/base/v1beta1/coin'
import { Item, StringKeyValue } from '../pylons/item'
import { ItemRef } from '../pylons/trade'
import { Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface EventCreateAccount {
  address: string
}

export interface EventCreateCookbook {
  creator: string
  ID: string
}

/** EventUpdateCookbook contains a record of the cookbook pre-update.  The updated fields can be found by the message emitted by MsgUpdateCookbook */
export interface EventUpdateCookbook {
  originalCookbook: Cookbook | undefined
}

export interface EventTransferCookbook {
  sender: string
  receiver: string
  ID: string
}

export interface EventCreateRecipe {
  creator: string
  CookbookID: string
  ID: string
}

/** EventUpdateRecipe contains a record of the recipe pre-update.  The updated fields can be found by the message emitted by MsgUpdateRecipe */
export interface EventUpdateRecipe {
  originalRecipe: Recipe | undefined
}

/** EventCreateExecution contains the creator and ID of a created execution. Execution IDs are of the form {count-targetBlockHeight} */
export interface EventCreateExecution {
  creator: string
  ID: string
}

export interface EventCompleteExecution {
  creator: string
  ID: string
  burnCoins: Coin[]
  payCoins: Coin[]
  transferCoins: Coin[]
  feeCoins: Coin[]
  coinOutputs: Coin[]
  mintItems: Item[]
  modifyItems: Item[]
}

export interface EventDropExecution {
  creator: string
  ID: string
}

export interface EventCompleteExecutionEarly {
  creator: string
  ID: string
}

export interface EventSendItems {
  sender: string
  receiver: string
  items: ItemRef[]
}

export interface EventSetItemString {
  creator: string
  CookbookID: string
  ID: string
  originalMutableStrings: StringKeyValue[]
}

export interface EventGooglePurchase {
  creator: string
  productID: string
  purchaseToken: string
  receiptDataBase64: string
  signature: string
}

export interface EventStripePurchase {
  creator: string
  ID: string
}

const baseEventCreateAccount: object = { address: '' }

export const EventCreateAccount = {
  encode(message: EventCreateAccount, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCreateAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCreateAccount } as EventCreateAccount
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.address = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventCreateAccount {
    const message = { ...baseEventCreateAccount } as EventCreateAccount
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: EventCreateAccount): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateAccount>): EventCreateAccount {
    const message = { ...baseEventCreateAccount } as EventCreateAccount
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseEventCreateCookbook: object = { creator: '', ID: '' }

export const EventCreateCookbook = {
  encode(message: EventCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCreateCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCreateCookbook } as EventCreateCookbook
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

  fromJSON(object: any): EventCreateCookbook {
    const message = { ...baseEventCreateCookbook } as EventCreateCookbook
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

  toJSON(message: EventCreateCookbook): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateCookbook>): EventCreateCookbook {
    const message = { ...baseEventCreateCookbook } as EventCreateCookbook
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

const baseEventUpdateCookbook: object = {}

export const EventUpdateCookbook = {
  encode(message: EventUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.originalCookbook !== undefined) {
      Cookbook.encode(message.originalCookbook, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventUpdateCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventUpdateCookbook } as EventUpdateCookbook
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.originalCookbook = Cookbook.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventUpdateCookbook {
    const message = { ...baseEventUpdateCookbook } as EventUpdateCookbook
    if (object.originalCookbook !== undefined && object.originalCookbook !== null) {
      message.originalCookbook = Cookbook.fromJSON(object.originalCookbook)
    } else {
      message.originalCookbook = undefined
    }
    return message
  },

  toJSON(message: EventUpdateCookbook): unknown {
    const obj: any = {}
    message.originalCookbook !== undefined && (obj.originalCookbook = message.originalCookbook ? Cookbook.toJSON(message.originalCookbook) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateCookbook>): EventUpdateCookbook {
    const message = { ...baseEventUpdateCookbook } as EventUpdateCookbook
    if (object.originalCookbook !== undefined && object.originalCookbook !== null) {
      message.originalCookbook = Cookbook.fromPartial(object.originalCookbook)
    } else {
      message.originalCookbook = undefined
    }
    return message
  }
}

const baseEventTransferCookbook: object = { sender: '', receiver: '', ID: '' }

export const EventTransferCookbook = {
  encode(message: EventTransferCookbook, writer: Writer = Writer.create()): Writer {
    if (message.sender !== '') {
      writer.uint32(10).string(message.sender)
    }
    if (message.receiver !== '') {
      writer.uint32(18).string(message.receiver)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventTransferCookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventTransferCookbook } as EventTransferCookbook
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.sender = reader.string()
          break
        case 2:
          message.receiver = reader.string()
          break
        case 3:
          message.ID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventTransferCookbook {
    const message = { ...baseEventTransferCookbook } as EventTransferCookbook
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = String(object.sender)
    } else {
      message.sender = ''
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = String(object.receiver)
    } else {
      message.receiver = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: EventTransferCookbook): unknown {
    const obj: any = {}
    message.sender !== undefined && (obj.sender = message.sender)
    message.receiver !== undefined && (obj.receiver = message.receiver)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventTransferCookbook>): EventTransferCookbook {
    const message = { ...baseEventTransferCookbook } as EventTransferCookbook
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = object.sender
    } else {
      message.sender = ''
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = object.receiver
    } else {
      message.receiver = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseEventCreateRecipe: object = { creator: '', CookbookID: '', ID: '' }

export const EventCreateRecipe = {
  encode(message: EventCreateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.CookbookID !== '') {
      writer.uint32(18).string(message.CookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCreateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCreateRecipe } as EventCreateRecipe
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.CookbookID = reader.string()
          break
        case 3:
          message.ID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventCreateRecipe {
    const message = { ...baseEventCreateRecipe } as EventCreateRecipe
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: EventCreateRecipe): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateRecipe>): EventCreateRecipe {
    const message = { ...baseEventCreateRecipe } as EventCreateRecipe
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseEventUpdateRecipe: object = {}

export const EventUpdateRecipe = {
  encode(message: EventUpdateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.originalRecipe !== undefined) {
      Recipe.encode(message.originalRecipe, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventUpdateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventUpdateRecipe } as EventUpdateRecipe
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.originalRecipe = Recipe.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventUpdateRecipe {
    const message = { ...baseEventUpdateRecipe } as EventUpdateRecipe
    if (object.originalRecipe !== undefined && object.originalRecipe !== null) {
      message.originalRecipe = Recipe.fromJSON(object.originalRecipe)
    } else {
      message.originalRecipe = undefined
    }
    return message
  },

  toJSON(message: EventUpdateRecipe): unknown {
    const obj: any = {}
    message.originalRecipe !== undefined && (obj.originalRecipe = message.originalRecipe ? Recipe.toJSON(message.originalRecipe) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateRecipe>): EventUpdateRecipe {
    const message = { ...baseEventUpdateRecipe } as EventUpdateRecipe
    if (object.originalRecipe !== undefined && object.originalRecipe !== null) {
      message.originalRecipe = Recipe.fromPartial(object.originalRecipe)
    } else {
      message.originalRecipe = undefined
    }
    return message
  }
}

const baseEventCreateExecution: object = { creator: '', ID: '' }

export const EventCreateExecution = {
  encode(message: EventCreateExecution, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCreateExecution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCreateExecution } as EventCreateExecution
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

  fromJSON(object: any): EventCreateExecution {
    const message = { ...baseEventCreateExecution } as EventCreateExecution
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

  toJSON(message: EventCreateExecution): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateExecution>): EventCreateExecution {
    const message = { ...baseEventCreateExecution } as EventCreateExecution
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

const baseEventCompleteExecution: object = { creator: '', ID: '' }

export const EventCompleteExecution = {
  encode(message: EventCompleteExecution, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    for (const v of message.burnCoins) {
      Coin.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.payCoins) {
      Coin.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.transferCoins) {
      Coin.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.feeCoins) {
      Coin.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    for (const v of message.coinOutputs) {
      Coin.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.mintItems) {
      Item.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    for (const v of message.modifyItems) {
      Item.encode(v!, writer.uint32(74).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCompleteExecution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    message.burnCoins = []
    message.payCoins = []
    message.transferCoins = []
    message.feeCoins = []
    message.coinOutputs = []
    message.mintItems = []
    message.modifyItems = []
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
          message.burnCoins.push(Coin.decode(reader, reader.uint32()))
          break
        case 4:
          message.payCoins.push(Coin.decode(reader, reader.uint32()))
          break
        case 5:
          message.transferCoins.push(Coin.decode(reader, reader.uint32()))
          break
        case 6:
          message.feeCoins.push(Coin.decode(reader, reader.uint32()))
          break
        case 7:
          message.coinOutputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 8:
          message.mintItems.push(Item.decode(reader, reader.uint32()))
          break
        case 9:
          message.modifyItems.push(Item.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventCompleteExecution {
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    message.burnCoins = []
    message.payCoins = []
    message.transferCoins = []
    message.feeCoins = []
    message.coinOutputs = []
    message.mintItems = []
    message.modifyItems = []
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
    if (object.burnCoins !== undefined && object.burnCoins !== null) {
      for (const e of object.burnCoins) {
        message.burnCoins.push(Coin.fromJSON(e))
      }
    }
    if (object.payCoins !== undefined && object.payCoins !== null) {
      for (const e of object.payCoins) {
        message.payCoins.push(Coin.fromJSON(e))
      }
    }
    if (object.transferCoins !== undefined && object.transferCoins !== null) {
      for (const e of object.transferCoins) {
        message.transferCoins.push(Coin.fromJSON(e))
      }
    }
    if (object.feeCoins !== undefined && object.feeCoins !== null) {
      for (const e of object.feeCoins) {
        message.feeCoins.push(Coin.fromJSON(e))
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromJSON(e))
      }
    }
    if (object.mintItems !== undefined && object.mintItems !== null) {
      for (const e of object.mintItems) {
        message.mintItems.push(Item.fromJSON(e))
      }
    }
    if (object.modifyItems !== undefined && object.modifyItems !== null) {
      for (const e of object.modifyItems) {
        message.modifyItems.push(Item.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: EventCompleteExecution): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.burnCoins) {
      obj.burnCoins = message.burnCoins.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.burnCoins = []
    }
    if (message.payCoins) {
      obj.payCoins = message.payCoins.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.payCoins = []
    }
    if (message.transferCoins) {
      obj.transferCoins = message.transferCoins.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.transferCoins = []
    }
    if (message.feeCoins) {
      obj.feeCoins = message.feeCoins.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.feeCoins = []
    }
    if (message.coinOutputs) {
      obj.coinOutputs = message.coinOutputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinOutputs = []
    }
    if (message.mintItems) {
      obj.mintItems = message.mintItems.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.mintItems = []
    }
    if (message.modifyItems) {
      obj.modifyItems = message.modifyItems.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.modifyItems = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecution>): EventCompleteExecution {
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    message.burnCoins = []
    message.payCoins = []
    message.transferCoins = []
    message.feeCoins = []
    message.coinOutputs = []
    message.mintItems = []
    message.modifyItems = []
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
    if (object.burnCoins !== undefined && object.burnCoins !== null) {
      for (const e of object.burnCoins) {
        message.burnCoins.push(Coin.fromPartial(e))
      }
    }
    if (object.payCoins !== undefined && object.payCoins !== null) {
      for (const e of object.payCoins) {
        message.payCoins.push(Coin.fromPartial(e))
      }
    }
    if (object.transferCoins !== undefined && object.transferCoins !== null) {
      for (const e of object.transferCoins) {
        message.transferCoins.push(Coin.fromPartial(e))
      }
    }
    if (object.feeCoins !== undefined && object.feeCoins !== null) {
      for (const e of object.feeCoins) {
        message.feeCoins.push(Coin.fromPartial(e))
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromPartial(e))
      }
    }
    if (object.mintItems !== undefined && object.mintItems !== null) {
      for (const e of object.mintItems) {
        message.mintItems.push(Item.fromPartial(e))
      }
    }
    if (object.modifyItems !== undefined && object.modifyItems !== null) {
      for (const e of object.modifyItems) {
        message.modifyItems.push(Item.fromPartial(e))
      }
    }
    return message
  }
}

const baseEventDropExecution: object = { creator: '', ID: '' }

export const EventDropExecution = {
  encode(message: EventDropExecution, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventDropExecution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventDropExecution } as EventDropExecution
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

  fromJSON(object: any): EventDropExecution {
    const message = { ...baseEventDropExecution } as EventDropExecution
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

  toJSON(message: EventDropExecution): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventDropExecution>): EventDropExecution {
    const message = { ...baseEventDropExecution } as EventDropExecution
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

const baseEventCompleteExecutionEarly: object = { creator: '', ID: '' }

export const EventCompleteExecutionEarly = {
  encode(message: EventCompleteExecutionEarly, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCompleteExecutionEarly {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCompleteExecutionEarly } as EventCompleteExecutionEarly
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

  fromJSON(object: any): EventCompleteExecutionEarly {
    const message = { ...baseEventCompleteExecutionEarly } as EventCompleteExecutionEarly
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

  toJSON(message: EventCompleteExecutionEarly): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecutionEarly>): EventCompleteExecutionEarly {
    const message = { ...baseEventCompleteExecutionEarly } as EventCompleteExecutionEarly
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

const baseEventSendItems: object = { sender: '', receiver: '' }

export const EventSendItems = {
  encode(message: EventSendItems, writer: Writer = Writer.create()): Writer {
    if (message.sender !== '') {
      writer.uint32(10).string(message.sender)
    }
    if (message.receiver !== '') {
      writer.uint32(18).string(message.receiver)
    }
    for (const v of message.items) {
      ItemRef.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventSendItems {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventSendItems } as EventSendItems
    message.items = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.sender = reader.string()
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

  fromJSON(object: any): EventSendItems {
    const message = { ...baseEventSendItems } as EventSendItems
    message.items = []
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = String(object.sender)
    } else {
      message.sender = ''
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

  toJSON(message: EventSendItems): unknown {
    const obj: any = {}
    message.sender !== undefined && (obj.sender = message.sender)
    message.receiver !== undefined && (obj.receiver = message.receiver)
    if (message.items) {
      obj.items = message.items.map((e) => (e ? ItemRef.toJSON(e) : undefined))
    } else {
      obj.items = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<EventSendItems>): EventSendItems {
    const message = { ...baseEventSendItems } as EventSendItems
    message.items = []
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = object.sender
    } else {
      message.sender = ''
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

const baseEventSetItemString: object = { creator: '', CookbookID: '', ID: '' }

export const EventSetItemString = {
  encode(message: EventSetItemString, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.CookbookID !== '') {
      writer.uint32(18).string(message.CookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    for (const v of message.originalMutableStrings) {
      StringKeyValue.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventSetItemString {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventSetItemString } as EventSetItemString
    message.originalMutableStrings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        case 2:
          message.CookbookID = reader.string()
          break
        case 3:
          message.ID = reader.string()
          break
        case 4:
          message.originalMutableStrings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventSetItemString {
    const message = { ...baseEventSetItemString } as EventSetItemString
    message.originalMutableStrings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.originalMutableStrings !== undefined && object.originalMutableStrings !== null) {
      for (const e of object.originalMutableStrings) {
        message.originalMutableStrings.push(StringKeyValue.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: EventSetItemString): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.originalMutableStrings) {
      obj.originalMutableStrings = message.originalMutableStrings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.originalMutableStrings = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<EventSetItemString>): EventSetItemString {
    const message = { ...baseEventSetItemString } as EventSetItemString
    message.originalMutableStrings = []
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.originalMutableStrings !== undefined && object.originalMutableStrings !== null) {
      for (const e of object.originalMutableStrings) {
        message.originalMutableStrings.push(StringKeyValue.fromPartial(e))
      }
    }
    return message
  }
}

const baseEventGooglePurchase: object = { creator: '', productID: '', purchaseToken: '', receiptDataBase64: '', signature: '' }

export const EventGooglePurchase = {
  encode(message: EventGooglePurchase, writer: Writer = Writer.create()): Writer {
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

  decode(input: Reader | Uint8Array, length?: number): EventGooglePurchase {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventGooglePurchase } as EventGooglePurchase
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

  fromJSON(object: any): EventGooglePurchase {
    const message = { ...baseEventGooglePurchase } as EventGooglePurchase
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

  toJSON(message: EventGooglePurchase): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.productID !== undefined && (obj.productID = message.productID)
    message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken)
    message.receiptDataBase64 !== undefined && (obj.receiptDataBase64 = message.receiptDataBase64)
    message.signature !== undefined && (obj.signature = message.signature)
    return obj
  },

  fromPartial(object: DeepPartial<EventGooglePurchase>): EventGooglePurchase {
    const message = { ...baseEventGooglePurchase } as EventGooglePurchase
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

const baseEventStripePurchase: object = { creator: '', ID: '' }

export const EventStripePurchase = {
  encode(message: EventStripePurchase, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventStripePurchase {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventStripePurchase } as EventStripePurchase
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

  fromJSON(object: any): EventStripePurchase {
    const message = { ...baseEventStripePurchase } as EventStripePurchase
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

  toJSON(message: EventStripePurchase): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<EventStripePurchase>): EventStripePurchase {
    const message = { ...baseEventStripePurchase } as EventStripePurchase
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
