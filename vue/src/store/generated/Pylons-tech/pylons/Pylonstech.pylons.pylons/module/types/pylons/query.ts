/* eslint-disable */
import { Reader, Writer } from 'protobufjs/minimal'
import { Recipe } from '../pylons/recipe'
import { Cookbook } from '../pylons/cookbook'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # 3 */
export interface QueryGetRecipeRequest {
  index: string
}

export interface QueryGetRecipeResponse {
  Recipe: Recipe | undefined
}

export interface QueryListCookbookByCreatorRequest {
  creator: string
}

export interface QueryListCookbookByCreatorResponse {
  Cookbooks: Cookbook[]
}

export interface QueryGetCookbookRequest {
  index: string
}

export interface QueryGetCookbookResponse {
  Cookbook: Cookbook | undefined
}

const baseQueryGetRecipeRequest: object = { index: '' }

export const QueryGetRecipeRequest = {
  encode(message: QueryGetRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.index !== '') {
      writer.uint32(10).string(message.index)
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
          message.index = reader.string()
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
    if (object.index !== undefined && object.index !== null) {
      message.index = String(object.index)
    } else {
      message.index = ''
    }
    return message
  },

  toJSON(message: QueryGetRecipeRequest): unknown {
    const obj: any = {}
    message.index !== undefined && (obj.index = message.index)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetRecipeRequest>): QueryGetRecipeRequest {
    const message = { ...baseQueryGetRecipeRequest } as QueryGetRecipeRequest
    if (object.index !== undefined && object.index !== null) {
      message.index = object.index
    } else {
      message.index = ''
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

const baseQueryListCookbookByCreatorRequest: object = { creator: '' }

export const QueryListCookbookByCreatorRequest = {
  encode(message: QueryListCookbookByCreatorRequest, writer: Writer = Writer.create()): Writer {
    if (message.creator !== '') {
      writer.uint32(10).string(message.creator)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListCookbookByCreatorRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListCookbookByCreatorRequest } as QueryListCookbookByCreatorRequest
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

  fromJSON(object: any): QueryListCookbookByCreatorRequest {
    const message = { ...baseQueryListCookbookByCreatorRequest } as QueryListCookbookByCreatorRequest
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator)
    } else {
      message.creator = ''
    }
    return message
  },

  toJSON(message: QueryListCookbookByCreatorRequest): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListCookbookByCreatorRequest>): QueryListCookbookByCreatorRequest {
    const message = { ...baseQueryListCookbookByCreatorRequest } as QueryListCookbookByCreatorRequest
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    return message
  }
}

const baseQueryListCookbookByCreatorResponse: object = {}

export const QueryListCookbookByCreatorResponse = {
  encode(message: QueryListCookbookByCreatorResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Cookbooks) {
      Cookbook.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListCookbookByCreatorResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListCookbookByCreatorResponse } as QueryListCookbookByCreatorResponse
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

  fromJSON(object: any): QueryListCookbookByCreatorResponse {
    const message = { ...baseQueryListCookbookByCreatorResponse } as QueryListCookbookByCreatorResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: QueryListCookbookByCreatorResponse): unknown {
    const obj: any = {}
    if (message.Cookbooks) {
      obj.Cookbooks = message.Cookbooks.map((e) => (e ? Cookbook.toJSON(e) : undefined))
    } else {
      obj.Cookbooks = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<QueryListCookbookByCreatorResponse>): QueryListCookbookByCreatorResponse {
    const message = { ...baseQueryListCookbookByCreatorResponse } as QueryListCookbookByCreatorResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromPartial(e))
      }
    }
    return message
  }
}

const baseQueryGetCookbookRequest: object = { index: '' }

export const QueryGetCookbookRequest = {
  encode(message: QueryGetCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.index !== '') {
      writer.uint32(10).string(message.index)
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
          message.index = reader.string()
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
    if (object.index !== undefined && object.index !== null) {
      message.index = String(object.index)
    } else {
      message.index = ''
    }
    return message
  },

  toJSON(message: QueryGetCookbookRequest): unknown {
    const obj: any = {}
    message.index !== undefined && (obj.index = message.index)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetCookbookRequest>): QueryGetCookbookRequest {
    const message = { ...baseQueryGetCookbookRequest } as QueryGetCookbookRequest
    if (object.index !== undefined && object.index !== null) {
      message.index = object.index
    } else {
      message.index = ''
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
  ListCookbookByCreator(request: QueryListCookbookByCreatorRequest): Promise<QueryListCookbookByCreatorResponse>
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

  ListCookbookByCreator(request: QueryListCookbookByCreatorRequest): Promise<QueryListCookbookByCreatorResponse> {
    const data = QueryListCookbookByCreatorRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListCookbookByCreator', data)
    return promise.then((data) => QueryListCookbookByCreatorResponse.decode(new Reader(data)))
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
