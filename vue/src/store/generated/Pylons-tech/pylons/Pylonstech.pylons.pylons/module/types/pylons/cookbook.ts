/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface Cookbook {
  creator: string
  ID: string
  nodeVersion: string
  name: string
  description: string
  developer: string
  version: string
  supportEmail: string
  tier: number
  costPerBlock: number
  enabled: boolean
}

const baseCookbook: object = {
  creator: '',
  ID: '',
  nodeVersion: '',
  name: '',
  description: '',
  developer: '',
  version: '',
  supportEmail: '',
  tier: 0,
  costPerBlock: 0,
  enabled: false
}

export const Cookbook = {
  encode(message: Cookbook, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
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
    if (message.tier !== 0) {
      writer.uint32(72).int64(message.tier)
    }
    if (message.costPerBlock !== 0) {
      writer.uint32(80).uint64(message.costPerBlock)
    }
    if (message.enabled === true) {
      writer.uint32(88).bool(message.enabled)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Cookbook {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseCookbook } as Cookbook
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
          message.tier = longToNumber(reader.int64() as Long)
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

  fromJSON(object: any): Cookbook {
    const message = { ...baseCookbook } as Cookbook
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

  toJSON(message: Cookbook): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.ID !== undefined && (obj.ID = message.ID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
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

  fromPartial(object: DeepPartial<Cookbook>): Cookbook {
    const message = { ...baseCookbook } as Cookbook
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
