/* eslint-disable */
import { Reader, Writer } from 'protobufjs/minimal'
import { Recipe } from '../pylons/recipe'
import { Cookbook } from '../pylons/cookbook'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # 3 */
export interface QueryGetRecipeRequest {
  CookbookID: string
  ID: string
}

export interface QueryGetRecipeResponse {
  Recipe: Recipe | undefined
}

export interface QueryListCookbooksByCreatorRequest {
  creator: string
}

export interface QueryListCookbooksByCreatorResponse {
  Cookbooks: Cookbook[]
}

export interface QueryGetCookbookRequest {
  ID: string
}

export interface QueryGetCookbookResponse {
  Cookbook: Cookbook | undefined
}

const baseQueryGetRecipeRequest: object = { CookbookID: '', ID: '' }

export const QueryGetRecipeRequest = {
  encode(message: QueryGetRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetRecipeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetRecipeRequest } as QueryGetRecipeRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
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

  fromJSON(object: any): QueryGetRecipeRequest {
    const message = { ...baseQueryGetRecipeRequest } as QueryGetRecipeRequest
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

  toJSON(message: QueryGetRecipeRequest): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetRecipeRequest>): QueryGetRecipeRequest {
    const message = { ...baseQueryGetRecipeRequest } as QueryGetRecipeRequest
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

const baseQueryGetRecipeResponse: object = {}

export const QueryGetRecipeResponse = {
  encode(message: QueryGetRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Recipe !== undefined) {
      Recipe.encode(message.Recipe, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetRecipeResponse } as QueryGetRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Recipe = Recipe.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetRecipeResponse {
    const message = { ...baseQueryGetRecipeResponse } as QueryGetRecipeResponse
    if (object.Recipe !== undefined && object.Recipe !== null) {
      message.Recipe = Recipe.fromJSON(object.Recipe)
    } else {
      message.Recipe = undefined
    }
    return message
  },

  toJSON(message: QueryGetRecipeResponse): unknown {
    const obj: any = {}
    message.Recipe !== undefined && (obj.Recipe = message.Recipe ? Recipe.toJSON(message.Recipe) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetRecipeResponse>): QueryGetRecipeResponse {
    const message = { ...baseQueryGetRecipeResponse } as QueryGetRecipeResponse
    if (object.Recipe !== undefined && object.Recipe !== null) {
      message.Recipe = Recipe.fromPartial(object.Recipe)
    } else {
      message.Recipe = undefined
    }
    return message
  }
}

const baseQueryListCookbooksByCreatorRequest: object = { creator: '' }

export const QueryListCookbooksByCreatorRequest = {
  encode(message: QueryListCookbooksByCreatorRequest, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListCookbooksByCreatorRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListCookbooksByCreatorRequest } as QueryListCookbooksByCreatorRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListCookbooksByCreatorRequest {
    const message = { ...baseQueryListCookbooksByCreatorRequest } as QueryListCookbooksByCreatorRequest
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    return message
  },

  toJSON(message: QueryListCookbooksByCreatorRequest): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListCookbooksByCreatorRequest>): QueryListCookbooksByCreatorRequest {
    const message = { ...baseQueryListCookbooksByCreatorRequest } as QueryListCookbooksByCreatorRequest
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    return message
  }
}

const baseQueryListCookbooksByCreatorResponse: object = {}

export const QueryListCookbooksByCreatorResponse = {
  encode(message: QueryListCookbooksByCreatorResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Cookbooks) {
      Cookbook.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListCookbooksByCreatorResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListCookbooksByCreatorResponse } as QueryListCookbooksByCreatorResponse
    message.Cookbooks = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Cookbooks.push(Cookbook.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListCookbooksByCreatorResponse {
    const message = { ...baseQueryListCookbooksByCreatorResponse } as QueryListCookbooksByCreatorResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: QueryListCookbooksByCreatorResponse): unknown {
    const obj: any = {}
    if (message.Cookbooks) {
      obj.Cookbooks = message.Cookbooks.map((e) => (e ? Cookbook.toJSON(e) : undefined))
    } else {
      obj.Cookbooks = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<QueryListCookbooksByCreatorResponse>): QueryListCookbooksByCreatorResponse {
    const message = { ...baseQueryListCookbooksByCreatorResponse } as QueryListCookbooksByCreatorResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromPartial(e))
      }
    }
    return message
  }
}

const baseQueryGetCookbookRequest: object = { ID: '' }

export const QueryGetCookbookRequest = {
  encode(message: QueryGetCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetCookbookRequest } as QueryGetCookbookRequest
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

  fromJSON(object: any): QueryGetCookbookRequest {
    const message = { ...baseQueryGetCookbookRequest } as QueryGetCookbookRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: QueryGetCookbookRequest): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetCookbookRequest>): QueryGetCookbookRequest {
    const message = { ...baseQueryGetCookbookRequest } as QueryGetCookbookRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseQueryGetCookbookResponse: object = {}

export const QueryGetCookbookResponse = {
  encode(message: QueryGetCookbookResponse, writer: Writer = Writer.create()): Writer {
    if (message.Cookbook !== undefined) {
      Cookbook.encode(message.Cookbook, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetCookbookResponse } as QueryGetCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Cookbook = Cookbook.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetCookbookResponse {
    const message = { ...baseQueryGetCookbookResponse } as QueryGetCookbookResponse
    if (object.Cookbook !== undefined && object.Cookbook !== null) {
      message.Cookbook = Cookbook.fromJSON(object.Cookbook)
    } else {
      message.Cookbook = undefined
    }
    return message
  },

  toJSON(message: QueryGetCookbookResponse): unknown {
    const obj: any = {}
    message.Cookbook !== undefined && (obj.Cookbook = message.Cookbook ? Cookbook.toJSON(message.Cookbook) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetCookbookResponse>): QueryGetCookbookResponse {
    const message = { ...baseQueryGetCookbookResponse } as QueryGetCookbookResponse
    if (object.Cookbook !== undefined && object.Cookbook !== null) {
      message.Cookbook = Cookbook.fromPartial(object.Cookbook)
    } else {
      message.Cookbook = undefined
    }
    return message
  }
}

/** Query defines the gRPC querier service. */
export interface Query {
  /** Queries a recipe by index. */
  Recipe(request: QueryGetRecipeRequest): Promise<QueryGetRecipeResponse>
  /** Queries a list of listCookbookByCreator items. */
  ListCookbooksByCreator(request: QueryListCookbooksByCreatorRequest): Promise<QueryListCookbooksByCreatorResponse>
  /** Queries a cookbook by index. */
  Cookbook(request: QueryGetCookbookRequest): Promise<QueryGetCookbookResponse>
}

export class QueryClientImpl implements Query {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
  }
  Recipe(request: QueryGetRecipeRequest): Promise<QueryGetRecipeResponse> {
    const data = QueryGetRecipeRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Recipe', data)
    return promise.then((data) => QueryGetRecipeResponse.decode(new Reader(data)))
  }

  ListCookbooksByCreator(request: QueryListCookbooksByCreatorRequest): Promise<QueryListCookbooksByCreatorResponse> {
    const data = QueryListCookbooksByCreatorRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListCookbooksByCreator', data)
    return promise.then((data) => QueryListCookbooksByCreatorResponse.decode(new Reader(data)))
  }

  Cookbook(request: QueryGetCookbookRequest): Promise<QueryGetCookbookResponse> {
    const data = QueryGetCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Cookbook', data)
    return promise.then((data) => QueryGetCookbookResponse.decode(new Reader(data)))
  }
}

interface Rpc {
  request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>
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
