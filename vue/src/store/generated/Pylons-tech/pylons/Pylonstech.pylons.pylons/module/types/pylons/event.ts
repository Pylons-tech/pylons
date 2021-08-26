/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface EventCreateAccount {
  msgTypeUrl: string
  address: string
}

export interface EventCreateCookbook {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventUpdateCookbook {
  msgTypeUrl: string
  id: string
}

export interface EventTransferCookbook {
  msgTypeUrl: string
  sender: string
  receiver: string
  id: string
}

export interface EventCreateRecipe {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventUpdateRecipe {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventCreateExecution {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventCompleteExecution {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventCompleteExecutionEarly {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface EventSendItems {
  msgTypeUrl: string
  sender: string
  receiver: string
  IDs: string[]
}

export interface EventSetIemString {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface GooglePurchase {
  msgTypeUrl: string
  creator: string
  id: string
}

export interface StripePurchase {
  msgTypeUrl: string
  creator: string
  id: string
}

const baseEventCreateAccount: object = { msgTypeUrl: '', address: '' }

export const EventCreateAccount = {
  encode(message: EventCreateAccount, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.address !== '') {
      writer.uint32(26).string(message.address)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: EventCreateAccount): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateAccount>): EventCreateAccount {
    const message = { ...baseEventCreateAccount } as EventCreateAccount
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseEventCreateCookbook: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventCreateCookbook = {
  encode(message: EventCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventCreateCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateCookbook>): EventCreateCookbook {
    const message = { ...baseEventCreateCookbook } as EventCreateCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventUpdateCookbook: object = { msgTypeUrl: '', id: '' }

export const EventUpdateCookbook = {
  encode(message: EventUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.id !== '') {
      writer.uint32(26).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventUpdateCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateCookbook>): EventUpdateCookbook {
    const message = { ...baseEventUpdateCookbook } as EventUpdateCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventTransferCookbook: object = { msgTypeUrl: '', sender: '', receiver: '', id: '' }

export const EventTransferCookbook = {
  encode(message: EventTransferCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.sender !== '') {
      writer.uint32(26).string(message.sender)
    }
    if (message.receiver !== '') {
      writer.uint32(34).string(message.receiver)
    }
    if (message.id !== '') {
      writer.uint32(42).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.sender = reader.string()
          break
        case 4:
          message.receiver = reader.string()
          break
        case 5:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
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
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventTransferCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.sender !== undefined && (obj.sender = message.sender)
    message.receiver !== undefined && (obj.receiver = message.receiver)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventTransferCookbook>): EventTransferCookbook {
    const message = { ...baseEventTransferCookbook } as EventTransferCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
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
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventCreateRecipe: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventCreateRecipe = {
  encode(message: EventCreateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventCreateRecipe): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateRecipe>): EventCreateRecipe {
    const message = { ...baseEventCreateRecipe } as EventCreateRecipe
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventUpdateRecipe: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventUpdateRecipe = {
  encode(message: EventUpdateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventUpdateRecipe): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateRecipe>): EventUpdateRecipe {
    const message = { ...baseEventUpdateRecipe } as EventUpdateRecipe
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventCreateExecution: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventCreateExecution = {
  encode(message: EventCreateExecution, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventCreateExecution): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateExecution>): EventCreateExecution {
    const message = { ...baseEventCreateExecution } as EventCreateExecution
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventCompleteExecution: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventCompleteExecution = {
  encode(message: EventCompleteExecution, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventCompleteExecution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventCompleteExecution): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecution>): EventCompleteExecution {
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventCompleteExecutionEarly: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventCompleteExecutionEarly = {
  encode(message: EventCompleteExecutionEarly, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
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
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
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
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventCompleteExecutionEarly): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecutionEarly>): EventCompleteExecutionEarly {
    const message = { ...baseEventCompleteExecutionEarly } as EventCompleteExecutionEarly
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseEventSendItems: object = { msgTypeUrl: '', sender: '', receiver: '', IDs: '' }

export const EventSendItems = {
  encode(message: EventSendItems, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.sender !== '') {
      writer.uint32(26).string(message.sender)
    }
    if (message.receiver !== '') {
      writer.uint32(34).string(message.receiver)
    }
    for (const v of message.IDs) {
      writer.uint32(42).string(v!)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventSendItems {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventSendItems } as EventSendItems
    message.IDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.sender = reader.string()
          break
        case 4:
          message.receiver = reader.string()
          break
        case 5:
          message.IDs.push(reader.string())
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
    message.IDs = []
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
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
    if (object.IDs !== undefined && object.IDs !== null) {
      for (const e of object.IDs) {
        message.IDs.push(String(e))
      }
    }
    return message
  },

  toJSON(message: EventSendItems): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.sender !== undefined && (obj.sender = message.sender)
    message.receiver !== undefined && (obj.receiver = message.receiver)
    if (message.IDs) {
      obj.IDs = message.IDs.map((e) => e)
    } else {
      obj.IDs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<EventSendItems>): EventSendItems {
    const message = { ...baseEventSendItems } as EventSendItems
    message.IDs = []
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
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
    if (object.IDs !== undefined && object.IDs !== null) {
      for (const e of object.IDs) {
        message.IDs.push(e)
      }
    }
    return message
  }
}

const baseEventSetIemString: object = { msgTypeUrl: '', creator: '', id: '' }

export const EventSetIemString = {
  encode(message: EventSetIemString, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventSetIemString {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventSetIemString } as EventSetIemString
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventSetIemString {
    const message = { ...baseEventSetIemString } as EventSetIemString
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: EventSetIemString): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<EventSetIemString>): EventSetIemString {
    const message = { ...baseEventSetIemString } as EventSetIemString
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseGooglePurchase: object = { msgTypeUrl: '', creator: '', id: '' }

export const GooglePurchase = {
  encode(message: GooglePurchase, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GooglePurchase {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGooglePurchase } as GooglePurchase
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GooglePurchase {
    const message = { ...baseGooglePurchase } as GooglePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: GooglePurchase): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<GooglePurchase>): GooglePurchase {
    const message = { ...baseGooglePurchase } as GooglePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
    }
    return message
  }
}

const baseStripePurchase: object = { msgTypeUrl: '', creator: '', id: '' }

export const StripePurchase = {
  encode(message: StripePurchase, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    if (message.creator !== '') {
      writer.uint32(26).string(message.creator)
    }
    if (message.id !== '') {
      writer.uint32(34).string(message.id)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): StripePurchase {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseStripePurchase } as StripePurchase
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        case 3:
          message.creator = reader.string()
          break
        case 4:
          message.id = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): StripePurchase {
    const message = { ...baseStripePurchase } as StripePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = String(object.id)
    } else {
      message.id = ''
    }
    return message
  },

  toJSON(message: StripePurchase): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    message.creator !== undefined && (obj.creator = message.creator)
    message.id !== undefined && (obj.id = message.id)
    return obj
  },

  fromPartial(object: DeepPartial<StripePurchase>): StripePurchase {
    const message = { ...baseStripePurchase } as StripePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.id !== undefined && object.id !== null) {
      message.id = object.id
    } else {
      message.id = ''
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
