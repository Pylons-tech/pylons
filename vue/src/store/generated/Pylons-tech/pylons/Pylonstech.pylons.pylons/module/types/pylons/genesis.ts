/* eslint-disable */
import { Item } from '../pylons/item'
import { Recipe } from '../pylons/recipe'
import { Cookbook } from '../pylons/cookbook'
import { Writer, Reader } from 'protobufjs/minimal'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** GenesisState defines the pylons module's genesis state. */
export interface GenesisState {
  /** this line is used by starport scaffolding # genesis/proto/state */
  itemList: Item[]
  /** this line is used by starport scaffolding # genesis/proto/stateField */
  recipeList: Recipe[]
  /** this line is used by starport scaffolding # genesis/proto/stateField */
  cookbookList: Cookbook[]
}

const baseGenesisState: object = {}

export const GenesisState = {
  encode(message: GenesisState, writer: Writer = Writer.create()): Writer {
    for (const v of message.itemList) {
      Item.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.recipeList) {
      Recipe.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.cookbookList) {
      Cookbook.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GenesisState {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGenesisState } as GenesisState
    message.itemList = []
    message.recipeList = []
    message.cookbookList = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 3:
          message.itemList.push(Item.decode(reader, reader.uint32()))
          break
        case 2:
          message.recipeList.push(Recipe.decode(reader, reader.uint32()))
          break
        case 1:
          message.cookbookList.push(Cookbook.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GenesisState {
    const message = { ...baseGenesisState } as GenesisState
    message.itemList = []
    message.recipeList = []
    message.cookbookList = []
    if (object.itemList !== undefined && object.itemList !== null) {
      for (const e of object.itemList) {
        message.itemList.push(Item.fromJSON(e))
      }
    }
    if (object.recipeList !== undefined && object.recipeList !== null) {
      for (const e of object.recipeList) {
        message.recipeList.push(Recipe.fromJSON(e))
      }
    }
    if (object.cookbookList !== undefined && object.cookbookList !== null) {
      for (const e of object.cookbookList) {
        message.cookbookList.push(Cookbook.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: GenesisState): unknown {
    const obj: any = {}
    if (message.itemList) {
      obj.itemList = message.itemList.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.itemList = []
    }
    if (message.recipeList) {
      obj.recipeList = message.recipeList.map((e) => (e ? Recipe.toJSON(e) : undefined))
    } else {
      obj.recipeList = []
    }
    if (message.cookbookList) {
      obj.cookbookList = message.cookbookList.map((e) => (e ? Cookbook.toJSON(e) : undefined))
    } else {
      obj.cookbookList = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<GenesisState>): GenesisState {
    const message = { ...baseGenesisState } as GenesisState
    message.itemList = []
    message.recipeList = []
    message.cookbookList = []
    if (object.itemList !== undefined && object.itemList !== null) {
      for (const e of object.itemList) {
        message.itemList.push(Item.fromPartial(e))
      }
    }
    if (object.recipeList !== undefined && object.recipeList !== null) {
      for (const e of object.recipeList) {
        message.recipeList.push(Recipe.fromPartial(e))
      }
    }
    if (object.cookbookList !== undefined && object.cookbookList !== null) {
      for (const e of object.cookbookList) {
        message.cookbookList.push(Cookbook.fromPartial(e))
      }
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
