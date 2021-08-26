/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface EventCreateAccount {
  msgTypeUrl: string
}

export interface EventCreateCookbook {
  msgTypeUrl: string
}

export interface EventUpdateCookbook {
  msgTypeUrl: string
}

export interface EventTransferCookbook {
  msgTypeUrl: string
}

export interface EventCreateRecipe {
  msgTypeUrl: string
}

export interface EventUpdateRecipe {
  msgTypeUrl: string
}

export interface EventCreateExecution {
  msgTypeUrl: string
}

export interface EventCompleteExecution {
  msgTypeUrl: string
}

export interface EventCompleteExecutionEarly {
  msgTypeUrl: string
}

export interface EventSentItems {
  msgTypeUrl: string
}

export interface EventSetIemString {
  msgTypeUrl: string
}

export interface GooglePurchase {
  msgTypeUrl: string
}

export interface StripePurchase {
  msgTypeUrl: string
}

const baseEventCreateAccount: object = { msgTypeUrl: '' }

export const EventCreateAccount = {
  encode(message: EventCreateAccount, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCreateAccount): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateAccount>): EventCreateAccount {
    const message = { ...baseEventCreateAccount } as EventCreateAccount
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventCreateCookbook: object = { msgTypeUrl: '' }

export const EventCreateCookbook = {
  encode(message: EventCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCreateCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateCookbook>): EventCreateCookbook {
    const message = { ...baseEventCreateCookbook } as EventCreateCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventUpdateCookbook: object = { msgTypeUrl: '' }

export const EventUpdateCookbook = {
  encode(message: EventUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventUpdateCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateCookbook>): EventUpdateCookbook {
    const message = { ...baseEventUpdateCookbook } as EventUpdateCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventTransferCookbook: object = { msgTypeUrl: '' }

export const EventTransferCookbook = {
  encode(message: EventTransferCookbook, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventTransferCookbook): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventTransferCookbook>): EventTransferCookbook {
    const message = { ...baseEventTransferCookbook } as EventTransferCookbook
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventCreateRecipe: object = { msgTypeUrl: '' }

export const EventCreateRecipe = {
  encode(message: EventCreateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCreateRecipe): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateRecipe>): EventCreateRecipe {
    const message = { ...baseEventCreateRecipe } as EventCreateRecipe
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventUpdateRecipe: object = { msgTypeUrl: '' }

export const EventUpdateRecipe = {
  encode(message: EventUpdateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventUpdateRecipe): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventUpdateRecipe>): EventUpdateRecipe {
    const message = { ...baseEventUpdateRecipe } as EventUpdateRecipe
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventCreateExecution: object = { msgTypeUrl: '' }

export const EventCreateExecution = {
  encode(message: EventCreateExecution, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCreateExecution): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCreateExecution>): EventCreateExecution {
    const message = { ...baseEventCreateExecution } as EventCreateExecution
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventCompleteExecution: object = { msgTypeUrl: '' }

export const EventCompleteExecution = {
  encode(message: EventCompleteExecution, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCompleteExecution): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecution>): EventCompleteExecution {
    const message = { ...baseEventCompleteExecution } as EventCompleteExecution
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventCompleteExecutionEarly: object = { msgTypeUrl: '' }

export const EventCompleteExecutionEarly = {
  encode(message: EventCompleteExecutionEarly, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventCompleteExecutionEarly): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventCompleteExecutionEarly>): EventCompleteExecutionEarly {
    const message = { ...baseEventCompleteExecutionEarly } as EventCompleteExecutionEarly
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventSentItems: object = { msgTypeUrl: '' }

export const EventSentItems = {
  encode(message: EventSentItems, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EventSentItems {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEventSentItems } as EventSentItems
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 2:
          message.msgTypeUrl = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EventSentItems {
    const message = { ...baseEventSentItems } as EventSentItems
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = String(object.msgTypeUrl)
    } else {
      message.msgTypeUrl = ''
    }
    return message
  },

  toJSON(message: EventSentItems): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventSentItems>): EventSentItems {
    const message = { ...baseEventSentItems } as EventSentItems
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseEventSetIemString: object = { msgTypeUrl: '' }

export const EventSetIemString = {
  encode(message: EventSetIemString, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: EventSetIemString): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<EventSetIemString>): EventSetIemString {
    const message = { ...baseEventSetIemString } as EventSetIemString
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseGooglePurchase: object = { msgTypeUrl: '' }

export const GooglePurchase = {
  encode(message: GooglePurchase, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: GooglePurchase): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<GooglePurchase>): GooglePurchase {
    const message = { ...baseGooglePurchase } as GooglePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
    }
    return message
  }
}

const baseStripePurchase: object = { msgTypeUrl: '' }

export const StripePurchase = {
  encode(message: StripePurchase, writer: Writer = Writer.create()): Writer {
    if (message.msgTypeUrl !== '') {
      writer.uint32(18).string(message.msgTypeUrl)
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
    return message
  },

  toJSON(message: StripePurchase): unknown {
    const obj: any = {}
    message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl)
    return obj
  },

  fromPartial(object: DeepPartial<StripePurchase>): StripePurchase {
    const message = { ...baseStripePurchase } as StripePurchase
    if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
      message.msgTypeUrl = object.msgTypeUrl
    } else {
      message.msgTypeUrl = ''
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
