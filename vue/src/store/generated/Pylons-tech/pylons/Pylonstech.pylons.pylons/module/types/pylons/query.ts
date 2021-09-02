/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'
import { PylonsAccount } from '../pylons/pylons_account'
import { Trade } from '../pylons/trade'
import { PageRequest, PageResponse } from '../cosmos/base/query/v1beta1/pagination'
import { Item } from '../pylons/item'
import { GoogleInAppPurchaseOrder } from '../pylons/google_iap_order'
import { Execution } from '../pylons/execution'
import { Recipe } from '../pylons/recipe'
import { Cookbook } from '../pylons/cookbook'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** this line is used by starport scaffolding # 3 */
export interface QueryGetAccountRequest {
  username: string
}

export interface QueryGetAccountResponse {
  pylonsAccount: PylonsAccount | undefined
}

export interface QueryGetTradeRequest {
  ID: number
}

export interface QueryGetTradeResponse {
  Trade: Trade | undefined
}

export interface QueryListItemByOwnerRequest {
  owner: string
  /** pagination defines an optional pagination for the request. */
  pagination: PageRequest | undefined
}

export interface QueryListItemByOwnerResponse {
  Items: Item[]
  /** pagination defines the pagination in the response. */
  pagination: PageResponse | undefined
}

export interface QueryGetGoogleInAppPurchaseOrderRequest {
  PurchaseToken: string
}

export interface QueryGetGoogleInAppPurchaseOrderResponse {
  Order: GoogleInAppPurchaseOrder | undefined
}

export interface QueryListExecutionsByItemRequest {
  CookbookID: string
  ItemID: string
  /** pagination defines an optional pagination for the request. */
  pagination: PageRequest | undefined
}

export interface QueryListExecutionsByItemResponse {
  CompletedExecutions: Execution[]
  PendingExecutions: Execution[]
  /** pagination defines the pagination in the response. */
  pagination: PageResponse | undefined
}

export interface QueryListExecutionsByRecipeRequest {
  CookbookID: string
  RecipeID: string
  /** pagination defines an optional pagination for the request. */
  pagination: PageRequest | undefined
}

export interface QueryListExecutionsByRecipeResponse {
  CompletedExecutions: Execution[]
  PendingExecutions: Execution[]
  /** pagination defines the pagination in the response. */
  pagination: PageResponse | undefined
}

export interface QueryGetExecutionRequest {
  ID: string
}

export interface QueryGetExecutionResponse {
  Execution: Execution | undefined
  Completed: boolean
}

export interface QueryListRecipesByCookbookRequest {
  CookbookID: string
  /** pagination defines an optional pagination for the request. */
  pagination: PageRequest | undefined
}

export interface QueryListRecipesByCookbookResponse {
  Recipes: Recipe[]
  /** pagination defines the pagination in the response. */
  pagination: PageResponse | undefined
}

export interface QueryGetItemRequest {
  CookbookID: string
  ID: string
}

export interface QueryGetItemResponse {
  Item: Item | undefined
}

export interface QueryGetRecipeRequest {
  CookbookID: string
  ID: string
}

export interface QueryGetRecipeResponse {
  Recipe: Recipe | undefined
}

export interface QueryListCookbooksByCreatorRequest {
  creator: string
  /** pagination defines an optional pagination for the request. */
  pagination: PageRequest | undefined
}

export interface QueryListCookbooksByCreatorResponse {
  Cookbooks: Cookbook[]
  /** pagination defines the pagination in the response. */
  pagination: PageResponse | undefined
}

export interface QueryGetCookbookRequest {
  ID: string
}

export interface QueryGetCookbookResponse {
  Cookbook: Cookbook | undefined
}

const baseQueryGetAccountRequest: object = { username: '' }

export const QueryGetAccountRequest = {
  encode(message: QueryGetAccountRequest, writer: Writer = Writer.create()): Writer {
    if (message.username !== '') {
      writer.uint32(10).string(message.username)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetAccountRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetAccountRequest } as QueryGetAccountRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.username = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetAccountRequest {
    const message = { ...baseQueryGetAccountRequest } as QueryGetAccountRequest
    if (object.username !== undefined && object.username !== null) {
      message.username = String(object.username)
    } else {
      message.username = ''
    }
    return message
  },

  toJSON(message: QueryGetAccountRequest): unknown {
    const obj: any = {}
    message.username !== undefined && (obj.username = message.username)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetAccountRequest>): QueryGetAccountRequest {
    const message = { ...baseQueryGetAccountRequest } as QueryGetAccountRequest
    if (object.username !== undefined && object.username !== null) {
      message.username = object.username
    } else {
      message.username = ''
    }
    return message
  }
}

const baseQueryGetAccountResponse: object = {}

export const QueryGetAccountResponse = {
  encode(message: QueryGetAccountResponse, writer: Writer = Writer.create()): Writer {
    if (message.pylonsAccount !== undefined) {
      PylonsAccount.encode(message.pylonsAccount, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetAccountResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetAccountResponse } as QueryGetAccountResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.pylonsAccount = PylonsAccount.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetAccountResponse {
    const message = { ...baseQueryGetAccountResponse } as QueryGetAccountResponse
    if (object.pylonsAccount !== undefined && object.pylonsAccount !== null) {
      message.pylonsAccount = PylonsAccount.fromJSON(object.pylonsAccount)
    } else {
      message.pylonsAccount = undefined
    }
    return message
  },

  toJSON(message: QueryGetAccountResponse): unknown {
    const obj: any = {}
    message.pylonsAccount !== undefined && (obj.pylonsAccount = message.pylonsAccount ? PylonsAccount.toJSON(message.pylonsAccount) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetAccountResponse>): QueryGetAccountResponse {
    const message = { ...baseQueryGetAccountResponse } as QueryGetAccountResponse
    if (object.pylonsAccount !== undefined && object.pylonsAccount !== null) {
      message.pylonsAccount = PylonsAccount.fromPartial(object.pylonsAccount)
    } else {
      message.pylonsAccount = undefined
    }
    return message
  }
}

const baseQueryGetTradeRequest: object = { ID: 0 }

export const QueryGetTradeRequest = {
  encode(message: QueryGetTradeRequest, writer: Writer = Writer.create()): Writer {
    if (message.ID !== 0) {
      writer.uint32(8).uint64(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetTradeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetTradeRequest } as QueryGetTradeRequest
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

  fromJSON(object: any): QueryGetTradeRequest {
    const message = { ...baseQueryGetTradeRequest } as QueryGetTradeRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = Number(object.ID)
    } else {
      message.ID = 0
    }
    return message
  },

  toJSON(message: QueryGetTradeRequest): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetTradeRequest>): QueryGetTradeRequest {
    const message = { ...baseQueryGetTradeRequest } as QueryGetTradeRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = 0
    }
    return message
  }
}

const baseQueryGetTradeResponse: object = {}

export const QueryGetTradeResponse = {
  encode(message: QueryGetTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Trade !== undefined) {
      Trade.encode(message.Trade, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetTradeResponse } as QueryGetTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Trade = Trade.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetTradeResponse {
    const message = { ...baseQueryGetTradeResponse } as QueryGetTradeResponse
    if (object.Trade !== undefined && object.Trade !== null) {
      message.Trade = Trade.fromJSON(object.Trade)
    } else {
      message.Trade = undefined
    }
    return message
  },

  toJSON(message: QueryGetTradeResponse): unknown {
    const obj: any = {}
    message.Trade !== undefined && (obj.Trade = message.Trade ? Trade.toJSON(message.Trade) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetTradeResponse>): QueryGetTradeResponse {
    const message = { ...baseQueryGetTradeResponse } as QueryGetTradeResponse
    if (object.Trade !== undefined && object.Trade !== null) {
      message.Trade = Trade.fromPartial(object.Trade)
    } else {
      message.Trade = undefined
    }
    return message
  }
}

const baseQueryListItemByOwnerRequest: object = { owner: '' }

export const QueryListItemByOwnerRequest = {
  encode(message: QueryListItemByOwnerRequest, writer: Writer = Writer.create()): Writer {
    if (message.owner !== '') {
      writer.uint32(10).string(message.owner)
    }
    if (message.pagination !== undefined) {
      PageRequest.encode(message.pagination, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListItemByOwnerRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListItemByOwnerRequest } as QueryListItemByOwnerRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.owner = reader.string()
          break
        case 3:
          message.pagination = PageRequest.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListItemByOwnerRequest {
    const message = { ...baseQueryListItemByOwnerRequest } as QueryListItemByOwnerRequest
    if (object.owner !== undefined && object.owner !== null) {
      message.owner = String(object.owner)
    } else {
      message.owner = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListItemByOwnerRequest): unknown {
    const obj: any = {}
    message.owner !== undefined && (obj.owner = message.owner)
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListItemByOwnerRequest>): QueryListItemByOwnerRequest {
    const message = { ...baseQueryListItemByOwnerRequest } as QueryListItemByOwnerRequest
    if (object.owner !== undefined && object.owner !== null) {
      message.owner = object.owner
    } else {
      message.owner = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryListItemByOwnerResponse: object = {}

export const QueryListItemByOwnerResponse = {
  encode(message: QueryListItemByOwnerResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Items) {
      Item.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    if (message.pagination !== undefined) {
      PageResponse.encode(message.pagination, writer.uint32(18).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListItemByOwnerResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListItemByOwnerResponse } as QueryListItemByOwnerResponse
    message.Items = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Items.push(Item.decode(reader, reader.uint32()))
          break
        case 2:
          message.pagination = PageResponse.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListItemByOwnerResponse {
    const message = { ...baseQueryListItemByOwnerResponse } as QueryListItemByOwnerResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromJSON(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListItemByOwnerResponse): unknown {
    const obj: any = {}
    if (message.Items) {
      obj.Items = message.Items.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.Items = []
    }
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListItemByOwnerResponse>): QueryListItemByOwnerResponse {
    const message = { ...baseQueryListItemByOwnerResponse } as QueryListItemByOwnerResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromPartial(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryGetGoogleInAppPurchaseOrderRequest: object = { PurchaseToken: '' }

export const QueryGetGoogleInAppPurchaseOrderRequest = {
  encode(message: QueryGetGoogleInAppPurchaseOrderRequest, writer: Writer = Writer.create()): Writer {
    if (message.PurchaseToken !== '') {
      writer.uint32(10).string(message.PurchaseToken)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetGoogleInAppPurchaseOrderRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest } as QueryGetGoogleInAppPurchaseOrderRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.PurchaseToken = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetGoogleInAppPurchaseOrderRequest {
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest } as QueryGetGoogleInAppPurchaseOrderRequest
    if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
      message.PurchaseToken = String(object.PurchaseToken)
    } else {
      message.PurchaseToken = ''
    }
    return message
  },

  toJSON(message: QueryGetGoogleInAppPurchaseOrderRequest): unknown {
    const obj: any = {}
    message.PurchaseToken !== undefined && (obj.PurchaseToken = message.PurchaseToken)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetGoogleInAppPurchaseOrderRequest>): QueryGetGoogleInAppPurchaseOrderRequest {
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest } as QueryGetGoogleInAppPurchaseOrderRequest
    if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
      message.PurchaseToken = object.PurchaseToken
    } else {
      message.PurchaseToken = ''
    }
    return message
  }
}

const baseQueryGetGoogleInAppPurchaseOrderResponse: object = {}

export const QueryGetGoogleInAppPurchaseOrderResponse = {
  encode(message: QueryGetGoogleInAppPurchaseOrderResponse, writer: Writer = Writer.create()): Writer {
    if (message.Order !== undefined) {
      GoogleInAppPurchaseOrder.encode(message.Order, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetGoogleInAppPurchaseOrderResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse } as QueryGetGoogleInAppPurchaseOrderResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Order = GoogleInAppPurchaseOrder.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetGoogleInAppPurchaseOrderResponse {
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse } as QueryGetGoogleInAppPurchaseOrderResponse
    if (object.Order !== undefined && object.Order !== null) {
      message.Order = GoogleInAppPurchaseOrder.fromJSON(object.Order)
    } else {
      message.Order = undefined
    }
    return message
  },

  toJSON(message: QueryGetGoogleInAppPurchaseOrderResponse): unknown {
    const obj: any = {}
    message.Order !== undefined && (obj.Order = message.Order ? GoogleInAppPurchaseOrder.toJSON(message.Order) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetGoogleInAppPurchaseOrderResponse>): QueryGetGoogleInAppPurchaseOrderResponse {
    const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse } as QueryGetGoogleInAppPurchaseOrderResponse
    if (object.Order !== undefined && object.Order !== null) {
      message.Order = GoogleInAppPurchaseOrder.fromPartial(object.Order)
    } else {
      message.Order = undefined
    }
    return message
  }
}

const baseQueryListExecutionsByItemRequest: object = { CookbookID: '', ItemID: '' }

export const QueryListExecutionsByItemRequest = {
  encode(message: QueryListExecutionsByItemRequest, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.ItemID !== '') {
      writer.uint32(18).string(message.ItemID)
    }
    if (message.pagination !== undefined) {
      PageRequest.encode(message.pagination, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByItemRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListExecutionsByItemRequest } as QueryListExecutionsByItemRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.ItemID = reader.string()
          break
        case 3:
          message.pagination = PageRequest.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListExecutionsByItemRequest {
    const message = { ...baseQueryListExecutionsByItemRequest } as QueryListExecutionsByItemRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = String(object.ItemID)
    } else {
      message.ItemID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListExecutionsByItemRequest): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ItemID !== undefined && (obj.ItemID = message.ItemID)
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListExecutionsByItemRequest>): QueryListExecutionsByItemRequest {
    const message = { ...baseQueryListExecutionsByItemRequest } as QueryListExecutionsByItemRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = object.ItemID
    } else {
      message.ItemID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryListExecutionsByItemResponse: object = {}

export const QueryListExecutionsByItemResponse = {
  encode(message: QueryListExecutionsByItemResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.CompletedExecutions) {
      Execution.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    for (const v of message.PendingExecutions) {
      Execution.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    if (message.pagination !== undefined) {
      PageResponse.encode(message.pagination, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListExecutionsByItemResponse } as QueryListExecutionsByItemResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CompletedExecutions.push(Execution.decode(reader, reader.uint32()))
          break
        case 2:
          message.PendingExecutions.push(Execution.decode(reader, reader.uint32()))
          break
        case 3:
          message.pagination = PageResponse.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListExecutionsByItemResponse {
    const message = { ...baseQueryListExecutionsByItemResponse } as QueryListExecutionsByItemResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    if (object.CompletedExecutions !== undefined && object.CompletedExecutions !== null) {
      for (const e of object.CompletedExecutions) {
        message.CompletedExecutions.push(Execution.fromJSON(e))
      }
    }
    if (object.PendingExecutions !== undefined && object.PendingExecutions !== null) {
      for (const e of object.PendingExecutions) {
        message.PendingExecutions.push(Execution.fromJSON(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListExecutionsByItemResponse): unknown {
    const obj: any = {}
    if (message.CompletedExecutions) {
      obj.CompletedExecutions = message.CompletedExecutions.map((e) => (e ? Execution.toJSON(e) : undefined))
    } else {
      obj.CompletedExecutions = []
    }
    if (message.PendingExecutions) {
      obj.PendingExecutions = message.PendingExecutions.map((e) => (e ? Execution.toJSON(e) : undefined))
    } else {
      obj.PendingExecutions = []
    }
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListExecutionsByItemResponse>): QueryListExecutionsByItemResponse {
    const message = { ...baseQueryListExecutionsByItemResponse } as QueryListExecutionsByItemResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    if (object.CompletedExecutions !== undefined && object.CompletedExecutions !== null) {
      for (const e of object.CompletedExecutions) {
        message.CompletedExecutions.push(Execution.fromPartial(e))
      }
    }
    if (object.PendingExecutions !== undefined && object.PendingExecutions !== null) {
      for (const e of object.PendingExecutions) {
        message.PendingExecutions.push(Execution.fromPartial(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryListExecutionsByRecipeRequest: object = { CookbookID: '', RecipeID: '' }

export const QueryListExecutionsByRecipeRequest = {
  encode(message: QueryListExecutionsByRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.RecipeID !== '') {
      writer.uint32(18).string(message.RecipeID)
    }
    if (message.pagination !== undefined) {
      PageRequest.encode(message.pagination, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByRecipeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListExecutionsByRecipeRequest } as QueryListExecutionsByRecipeRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.RecipeID = reader.string()
          break
        case 3:
          message.pagination = PageRequest.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListExecutionsByRecipeRequest {
    const message = { ...baseQueryListExecutionsByRecipeRequest } as QueryListExecutionsByRecipeRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListExecutionsByRecipeRequest): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListExecutionsByRecipeRequest>): QueryListExecutionsByRecipeRequest {
    const message = { ...baseQueryListExecutionsByRecipeRequest } as QueryListExecutionsByRecipeRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryListExecutionsByRecipeResponse: object = {}

export const QueryListExecutionsByRecipeResponse = {
  encode(message: QueryListExecutionsByRecipeResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.CompletedExecutions) {
      Execution.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    for (const v of message.PendingExecutions) {
      Execution.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    if (message.pagination !== undefined) {
      PageResponse.encode(message.pagination, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListExecutionsByRecipeResponse } as QueryListExecutionsByRecipeResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CompletedExecutions.push(Execution.decode(reader, reader.uint32()))
          break
        case 2:
          message.PendingExecutions.push(Execution.decode(reader, reader.uint32()))
          break
        case 3:
          message.pagination = PageResponse.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListExecutionsByRecipeResponse {
    const message = { ...baseQueryListExecutionsByRecipeResponse } as QueryListExecutionsByRecipeResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    if (object.CompletedExecutions !== undefined && object.CompletedExecutions !== null) {
      for (const e of object.CompletedExecutions) {
        message.CompletedExecutions.push(Execution.fromJSON(e))
      }
    }
    if (object.PendingExecutions !== undefined && object.PendingExecutions !== null) {
      for (const e of object.PendingExecutions) {
        message.PendingExecutions.push(Execution.fromJSON(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListExecutionsByRecipeResponse): unknown {
    const obj: any = {}
    if (message.CompletedExecutions) {
      obj.CompletedExecutions = message.CompletedExecutions.map((e) => (e ? Execution.toJSON(e) : undefined))
    } else {
      obj.CompletedExecutions = []
    }
    if (message.PendingExecutions) {
      obj.PendingExecutions = message.PendingExecutions.map((e) => (e ? Execution.toJSON(e) : undefined))
    } else {
      obj.PendingExecutions = []
    }
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListExecutionsByRecipeResponse>): QueryListExecutionsByRecipeResponse {
    const message = { ...baseQueryListExecutionsByRecipeResponse } as QueryListExecutionsByRecipeResponse
    message.CompletedExecutions = []
    message.PendingExecutions = []
    if (object.CompletedExecutions !== undefined && object.CompletedExecutions !== null) {
      for (const e of object.CompletedExecutions) {
        message.CompletedExecutions.push(Execution.fromPartial(e))
      }
    }
    if (object.PendingExecutions !== undefined && object.PendingExecutions !== null) {
      for (const e of object.PendingExecutions) {
        message.PendingExecutions.push(Execution.fromPartial(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryGetExecutionRequest: object = { ID: '' }

export const QueryGetExecutionRequest = {
  encode(message: QueryGetExecutionRequest, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetExecutionRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetExecutionRequest } as QueryGetExecutionRequest
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

  fromJSON(object: any): QueryGetExecutionRequest {
    const message = { ...baseQueryGetExecutionRequest } as QueryGetExecutionRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    return message
  },

  toJSON(message: QueryGetExecutionRequest): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetExecutionRequest>): QueryGetExecutionRequest {
    const message = { ...baseQueryGetExecutionRequest } as QueryGetExecutionRequest
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    return message
  }
}

const baseQueryGetExecutionResponse: object = { Completed: false }

export const QueryGetExecutionResponse = {
  encode(message: QueryGetExecutionResponse, writer: Writer = Writer.create()): Writer {
    if (message.Execution !== undefined) {
      Execution.encode(message.Execution, writer.uint32(10).fork()).ldelim()
    }
    if (message.Completed === true) {
      writer.uint32(16).bool(message.Completed)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetExecutionResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetExecutionResponse } as QueryGetExecutionResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Execution = Execution.decode(reader, reader.uint32())
          break
        case 2:
          message.Completed = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetExecutionResponse {
    const message = { ...baseQueryGetExecutionResponse } as QueryGetExecutionResponse
    if (object.Execution !== undefined && object.Execution !== null) {
      message.Execution = Execution.fromJSON(object.Execution)
    } else {
      message.Execution = undefined
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = Boolean(object.Completed)
    } else {
      message.Completed = false
    }
    return message
  },

  toJSON(message: QueryGetExecutionResponse): unknown {
    const obj: any = {}
    message.Execution !== undefined && (obj.Execution = message.Execution ? Execution.toJSON(message.Execution) : undefined)
    message.Completed !== undefined && (obj.Completed = message.Completed)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetExecutionResponse>): QueryGetExecutionResponse {
    const message = { ...baseQueryGetExecutionResponse } as QueryGetExecutionResponse
    if (object.Execution !== undefined && object.Execution !== null) {
      message.Execution = Execution.fromPartial(object.Execution)
    } else {
      message.Execution = undefined
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = object.Completed
    } else {
      message.Completed = false
    }
    return message
  }
}

const baseQueryListRecipesByCookbookRequest: object = { CookbookID: '' }

export const QueryListRecipesByCookbookRequest = {
  encode(message: QueryListRecipesByCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.pagination !== undefined) {
      PageRequest.encode(message.pagination, writer.uint32(18).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListRecipesByCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListRecipesByCookbookRequest } as QueryListRecipesByCookbookRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.pagination = PageRequest.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListRecipesByCookbookRequest {
    const message = { ...baseQueryListRecipesByCookbookRequest } as QueryListRecipesByCookbookRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListRecipesByCookbookRequest): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListRecipesByCookbookRequest>): QueryListRecipesByCookbookRequest {
    const message = { ...baseQueryListRecipesByCookbookRequest } as QueryListRecipesByCookbookRequest
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryListRecipesByCookbookResponse: object = {}

export const QueryListRecipesByCookbookResponse = {
  encode(message: QueryListRecipesByCookbookResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Recipes) {
      Recipe.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    if (message.pagination !== undefined) {
      PageResponse.encode(message.pagination, writer.uint32(18).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryListRecipesByCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryListRecipesByCookbookResponse } as QueryListRecipesByCookbookResponse
    message.Recipes = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Recipes.push(Recipe.decode(reader, reader.uint32()))
          break
        case 2:
          message.pagination = PageResponse.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryListRecipesByCookbookResponse {
    const message = { ...baseQueryListRecipesByCookbookResponse } as QueryListRecipesByCookbookResponse
    message.Recipes = []
    if (object.Recipes !== undefined && object.Recipes !== null) {
      for (const e of object.Recipes) {
        message.Recipes.push(Recipe.fromJSON(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListRecipesByCookbookResponse): unknown {
    const obj: any = {}
    if (message.Recipes) {
      obj.Recipes = message.Recipes.map((e) => (e ? Recipe.toJSON(e) : undefined))
    } else {
      obj.Recipes = []
    }
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListRecipesByCookbookResponse>): QueryListRecipesByCookbookResponse {
    const message = { ...baseQueryListRecipesByCookbookResponse } as QueryListRecipesByCookbookResponse
    message.Recipes = []
    if (object.Recipes !== undefined && object.Recipes !== null) {
      for (const e of object.Recipes) {
        message.Recipes.push(Recipe.fromPartial(e))
      }
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  }
}

const baseQueryGetItemRequest: object = { CookbookID: '', ID: '' }

export const QueryGetItemRequest = {
  encode(message: QueryGetItemRequest, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetItemRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetItemRequest } as QueryGetItemRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
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

  fromJSON(object: any): QueryGetItemRequest {
    const message = { ...baseQueryGetItemRequest } as QueryGetItemRequest
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

  toJSON(message: QueryGetItemRequest): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetItemRequest>): QueryGetItemRequest {
    const message = { ...baseQueryGetItemRequest } as QueryGetItemRequest
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

const baseQueryGetItemResponse: object = {}

export const QueryGetItemResponse = {
  encode(message: QueryGetItemResponse, writer: Writer = Writer.create()): Writer {
    if (message.Item !== undefined) {
      Item.encode(message.Item, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): QueryGetItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseQueryGetItemResponse } as QueryGetItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Item = Item.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): QueryGetItemResponse {
    const message = { ...baseQueryGetItemResponse } as QueryGetItemResponse
    if (object.Item !== undefined && object.Item !== null) {
      message.Item = Item.fromJSON(object.Item)
    } else {
      message.Item = undefined
    }
    return message
  },

  toJSON(message: QueryGetItemResponse): unknown {
    const obj: any = {}
    message.Item !== undefined && (obj.Item = message.Item ? Item.toJSON(message.Item) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryGetItemResponse>): QueryGetItemResponse {
    const message = { ...baseQueryGetItemResponse } as QueryGetItemResponse
    if (object.Item !== undefined && object.Item !== null) {
      message.Item = Item.fromPartial(object.Item)
    } else {
      message.Item = undefined
    }
    return message
  }
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
    if (message.pagination !== undefined) {
      PageRequest.encode(message.pagination, writer.uint32(26).fork()).ldelim()
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
        case 3:
          message.pagination = PageRequest.decode(reader, reader.uint32())
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
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
    }
    return message
  },

  toJSON(message: QueryListCookbooksByCreatorRequest): unknown {
    const obj: any = {}
    message.creator !== undefined && (obj.creator = message.creator)
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<QueryListCookbooksByCreatorRequest>): QueryListCookbooksByCreatorRequest {
    const message = { ...baseQueryListCookbooksByCreatorRequest } as QueryListCookbooksByCreatorRequest
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator
    } else {
      message.creator = ''
    }
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageRequest.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
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
    if (message.pagination !== undefined) {
      PageResponse.encode(message.pagination, writer.uint32(26).fork()).ldelim()
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
        case 3:
          message.pagination = PageResponse.decode(reader, reader.uint32())
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
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromJSON(object.pagination)
    } else {
      message.pagination = undefined
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
    message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined)
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
    if (object.pagination !== undefined && object.pagination !== null) {
      message.pagination = PageResponse.fromPartial(object.pagination)
    } else {
      message.pagination = undefined
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
  /** Queries a username by account. */
  Username(request: QueryGetAccountRequest): Promise<QueryGetAccountResponse>
  /** Queries a trade by id. */
  Trade(request: QueryGetTradeRequest): Promise<QueryGetTradeResponse>
  /** Queries a list of listItemByOwner items. */
  ListItemByOwner(request: QueryListItemByOwnerRequest): Promise<QueryListItemByOwnerResponse>
  /** Queries a googleIAPOrder by PurchaseToken. */
  GoogleInAppPurchaseOrder(request: QueryGetGoogleInAppPurchaseOrderRequest): Promise<QueryGetGoogleInAppPurchaseOrderResponse>
  /** Queries a list of listExecutionsByItem items. */
  ListExecutionsByItem(request: QueryListExecutionsByItemRequest): Promise<QueryListExecutionsByItemResponse>
  /** Queries a list of listExecutionsByRecipe items. */
  ListExecutionsByRecipe(request: QueryListExecutionsByRecipeRequest): Promise<QueryListExecutionsByRecipeResponse>
  /** Queries a execution by id. */
  Execution(request: QueryGetExecutionRequest): Promise<QueryGetExecutionResponse>
  /** Queries a list of listRecipesByCookbook items. */
  ListRecipesByCookbook(request: QueryListRecipesByCookbookRequest): Promise<QueryListRecipesByCookbookResponse>
  /** Queries a item by ID. */
  Item(request: QueryGetItemRequest): Promise<QueryGetItemResponse>
  /** Retrieves a recipe by ID. */
  Recipe(request: QueryGetRecipeRequest): Promise<QueryGetRecipeResponse>
  /** Retrieves the list of cookbooks owned by an address */
  ListCookbooksByCreator(request: QueryListCookbooksByCreatorRequest): Promise<QueryListCookbooksByCreatorResponse>
  /** Retrieves a cookbook by ID. */
  Cookbook(request: QueryGetCookbookRequest): Promise<QueryGetCookbookResponse>
}

export class QueryClientImpl implements Query {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
  }
  Username(request: QueryGetAccountRequest): Promise<QueryGetAccountResponse> {
    const data = QueryGetAccountRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Username', data)
    return promise.then((data) => QueryGetAccountResponse.decode(new Reader(data)))
  }

  Trade(request: QueryGetTradeRequest): Promise<QueryGetTradeResponse> {
    const data = QueryGetTradeRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Trade', data)
    return promise.then((data) => QueryGetTradeResponse.decode(new Reader(data)))
  }

  ListItemByOwner(request: QueryListItemByOwnerRequest): Promise<QueryListItemByOwnerResponse> {
    const data = QueryListItemByOwnerRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListItemByOwner', data)
    return promise.then((data) => QueryListItemByOwnerResponse.decode(new Reader(data)))
  }

  GoogleInAppPurchaseOrder(request: QueryGetGoogleInAppPurchaseOrderRequest): Promise<QueryGetGoogleInAppPurchaseOrderResponse> {
    const data = QueryGetGoogleInAppPurchaseOrderRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'GoogleInAppPurchaseOrder', data)
    return promise.then((data) => QueryGetGoogleInAppPurchaseOrderResponse.decode(new Reader(data)))
  }

  ListExecutionsByItem(request: QueryListExecutionsByItemRequest): Promise<QueryListExecutionsByItemResponse> {
    const data = QueryListExecutionsByItemRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListExecutionsByItem', data)
    return promise.then((data) => QueryListExecutionsByItemResponse.decode(new Reader(data)))
  }

  ListExecutionsByRecipe(request: QueryListExecutionsByRecipeRequest): Promise<QueryListExecutionsByRecipeResponse> {
    const data = QueryListExecutionsByRecipeRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListExecutionsByRecipe', data)
    return promise.then((data) => QueryListExecutionsByRecipeResponse.decode(new Reader(data)))
  }

  Execution(request: QueryGetExecutionRequest): Promise<QueryGetExecutionResponse> {
    const data = QueryGetExecutionRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Execution', data)
    return promise.then((data) => QueryGetExecutionResponse.decode(new Reader(data)))
  }

  ListRecipesByCookbook(request: QueryListRecipesByCookbookRequest): Promise<QueryListRecipesByCookbookResponse> {
    const data = QueryListRecipesByCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListRecipesByCookbook', data)
    return promise.then((data) => QueryListRecipesByCookbookResponse.decode(new Reader(data)))
  }

  Item(request: QueryGetItemRequest): Promise<QueryGetItemResponse> {
    const data = QueryGetItemRequest.encode(request).finish()
    const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Item', data)
    return promise.then((data) => QueryGetItemResponse.decode(new Reader(data)))
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
