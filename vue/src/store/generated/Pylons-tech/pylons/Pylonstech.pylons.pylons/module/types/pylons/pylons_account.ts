/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

export interface PylonsAccount {
  account: string
  username: string
}

const basePylonsAccount: object = { account: '', username: '' }

export const PylonsAccount = {
  encode(message: PylonsAccount, writer: Writer = Writer.create()): Writer {
    if (message.account !== '') {
      writer.uint32(10).string(message.account)
    }
    if (message.username !== '') {
      writer.uint32(18).string(message.username)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): PylonsAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...basePylonsAccount } as PylonsAccount
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.account = reader.string()
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

  fromJSON(object: any): PylonsAccount {
    const message = { ...basePylonsAccount } as PylonsAccount
    if (object.account !== undefined && object.account !== null) {
      message.account = String(object.account)
    } else {
      message.account = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = String(object.username)
    } else {
      message.username = ''
    }
    return message
  },

  toJSON(message: PylonsAccount): unknown {
    const obj: any = {}
    message.account !== undefined && (obj.account = message.account)
    message.username !== undefined && (obj.username = message.username)
    return obj
  },

  fromPartial(object: DeepPartial<PylonsAccount>): PylonsAccount {
    const message = { ...basePylonsAccount } as PylonsAccount
    if (object.account !== undefined && object.account !== null) {
      message.account = object.account
    } else {
      message.account = ''
    }
    if (object.username !== undefined && object.username !== null) {
      message.username = object.username
    } else {
      message.username = ''
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
