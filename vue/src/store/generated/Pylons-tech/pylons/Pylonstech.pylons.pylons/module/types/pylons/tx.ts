/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgCreateCookbook {
  creator: string
  index: string
  nodeVersion: string
  name: string
  description: string
  developer: string
  version: string
  supportEmail: string
  level: number
  costPerBlock: number
  enabled: boolean
}

export interface MsgCreateCookbookResponse {}

export interface MsgUpdateCookbook {
  creator: string
  index: string
  nodeVersion: string
  name: string
  description: string
  developer: string
  version: string
  supportEmail: string
  level: number
  costPerBlock: number
  enabled: boolean
}

export interface MsgUpdateCookbookResponse {}

const baseMsgCreateCookbook: object = {
  creator: '',
  index: '',
  nodeVersion: '',
  name: '',
  description: '',
  developer: '',
  version: '',
  supportEmail: '',
  level: 0,
  costPerBlock: 0,
  enabled: false
}

export const MsgCreateCookbook = {
  encode(message: MsgCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.index !== '') {
      writer.uint32(18).string(message.index)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(26).string(message.nodeVersion)
    }
    if (message.name !== '') {
      writer.uint32(34).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(42).string(message.description)
    }
    if (message.developer !== '') {
      writer.uint32(50).string(message.developer)
    }
    if (message.version !== '') {
      writer.uint32(58).string(message.version)
    }
    if (message.supportEmail !== '') {
      writer.uint32(66).string(message.supportEmail)
    }
    if (message.level !== 0) {
      writer.uint32(72).int64(message.level)
    }
    if (message.costPerBlock !== 0) {
      writer.uint32(80).uint64(message.costPerBlock)
    }
    if (message.enabled === true) {
      writer.uint32(88).bool(message.enabled)
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
          message.index = reader.string()
          break
        case 3:
          message.nodeVersion = reader.string()
          break
        case 4:
          message.name = reader.string()
          break
        case 5:
          message.description = reader.string()
          break
        case 6:
          message.developer = reader.string()
          break
        case 7:
          message.version = reader.string()
          break
        case 8:
          message.supportEmail = reader.string()
          break
        case 9:
          message.level = longToNumber(reader.int64() as Long)
          break
        case 10:
          message.costPerBlock = longToNumber(reader.uint64() as Long)
          break
        case 11:
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
    if (object.index !== undefined && object.index !== null) {
      message.index = String(object.index)
    } else {
      message.index = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
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
    if (object.level !== undefined && object.level !== null) {
      message.level = Number(object.level)
    } else {
      message.level = 0
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
    message.index !== undefined && (obj.index = message.index)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.developer !== undefined && (obj.developer = message.developer)
    message.version !== undefined && (obj.version = message.version)
    message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail)
    message.level !== undefined && (obj.level = message.level)
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
    if (object.index !== undefined && object.index !== null) {
      message.index = object.index
    } else {
      message.index = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
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
    if (object.level !== undefined && object.level !== null) {
      message.level = object.level
    } else {
      message.level = 0
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
  index: '',
  nodeVersion: '',
  name: '',
  description: '',
  developer: '',
  version: '',
  supportEmail: '',
  level: 0,
  costPerBlock: 0,
  enabled: false
}

export const MsgUpdateCookbook = {
  encode(message: MsgUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.index !== '') {
      writer.uint32(18).string(message.index)
    }
    if (message.nodeVersion !== '') {
      writer.uint32(26).string(message.nodeVersion)
    }
    if (message.name !== '') {
      writer.uint32(34).string(message.name)
    }
    if (message.description !== '') {
      writer.uint32(42).string(message.description)
    }
    if (message.developer !== '') {
      writer.uint32(50).string(message.developer)
    }
    if (message.version !== '') {
      writer.uint32(58).string(message.version)
    }
    if (message.supportEmail !== '') {
      writer.uint32(66).string(message.supportEmail)
    }
    if (message.level !== 0) {
      writer.uint32(72).int64(message.level)
    }
    if (message.costPerBlock !== 0) {
      writer.uint32(80).uint64(message.costPerBlock)
    }
    if (message.enabled === true) {
      writer.uint32(88).bool(message.enabled)
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
          message.index = reader.string()
          break
        case 3:
          message.nodeVersion = reader.string()
          break
        case 4:
          message.name = reader.string()
          break
        case 5:
          message.description = reader.string()
          break
        case 6:
          message.developer = reader.string()
          break
        case 7:
          message.version = reader.string()
          break
        case 8:
          message.supportEmail = reader.string()
          break
        case 9:
          message.level = longToNumber(reader.int64() as Long)
          break
        case 10:
          message.costPerBlock = longToNumber(reader.uint64() as Long)
          break
        case 11:
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
    if (object.index !== undefined && object.index !== null) {
      message.index = String(object.index)
    } else {
      message.index = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = String(object.nodeVersion)
    } else {
      message.nodeVersion = ''
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
    if (object.level !== undefined && object.level !== null) {
      message.level = Number(object.level)
    } else {
      message.level = 0
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
    message.index !== undefined && (obj.index = message.index)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.developer !== undefined && (obj.developer = message.developer)
    message.version !== undefined && (obj.version = message.version)
    message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail)
    message.level !== undefined && (obj.level = message.level)
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
    if (object.index !== undefined && object.index !== null) {
      message.index = object.index
    } else {
      message.index = ''
    }
    if (object.nodeVersion !== undefined && object.nodeVersion !== null) {
      message.nodeVersion = object.nodeVersion
    } else {
      message.nodeVersion = ''
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
    if (object.level !== undefined && object.level !== null) {
      message.level = object.level
    } else {
      message.level = 0
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
  CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>
  UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>
}

export class MsgClientImpl implements Msg {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
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
