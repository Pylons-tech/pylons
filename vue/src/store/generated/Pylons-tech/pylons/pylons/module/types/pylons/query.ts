/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'
import { Coin } from '../cosmos/base/v1beta1/coin'
import {
  Item,
  CoinInput,
  ItemInput,
  EntriesList,
  WeightedOutputs,
  TradeItemInput,
  Cookbook,
  Execution,
  LockedCoinDescribe,
  Recipe,
  ShortenRecipe,
  Trade
} from '../pylons/pylons'

export const protobufPackage = 'pylons'

export interface AddrFromPubKeyRequest {
  hexPubKey: string
}

export interface AddrFromPubKeyResponse {
  Bech32Addr: string
}

export interface CheckGoogleIapOrderRequest {
  purchaseToken: string
}

export interface CheckGoogleIapOrderResponse {
  purchaseToken: string
  exist: boolean
}

export interface GetCookbookRequest {
  cookbookID: string
}

export interface GetCookbookResponse {
  NodeVersion: string
  ID: string
  Name: string
  Description: string
  Version: string
  Developer: string
  Level: number
  SupportEmail: string
  CostPerBlock: number
  Sender: string
}

export interface GetExecutionRequest {
  executionID: string
}

export interface GetExecutionResponse {
  NodeVersion: string
  ID: string
  RecipeID: string
  CookbookID: string
  CoinsInput: Coin[]
  ItemInputs: Item[]
  BlockHeight: number
  Sender: string
  Completed: boolean
}

export interface GetItemRequest {
  itemID: string
}

export interface GetItemResponse {
  item: Item | undefined
}

export interface GetRecipeRequest {
  recipeID: string
}

export interface GetRecipeResponse {
  NodeVersion: string
  ID: string
  CookbookID: string
  Name: string
  CoinInputs: CoinInput[]
  ItemInputs: ItemInput[]
  Entries: EntriesList | undefined
  Outputs: WeightedOutputs[]
  Description: string
  BlockInterval: number
  Sender: string
  Disabled: boolean
  ExtraInfo: string
}

export interface GetTradeRequest {
  tradeID: string
}

export interface GetTradeResponse {
  NodeVersion: string
  ID: string
  CoinInputs: CoinInput[]
  ItemInputs: TradeItemInput[]
  CoinOutputs: Coin[]
  ItemOutputs: Item[]
  ExtraInfo: string
  Sender: string
  FulFiller: string
  Disabled: boolean
  Completed: boolean
}

export interface ItemsByCookbookRequest {
  cookbookID: string
}

export interface ItemsByCookbookResponse {
  Items: Item[]
}

export interface ItemsBySenderRequest {
  sender: string
}

export interface ItemsBySenderResponse {
  Items: Item[]
}

export interface ListCookbookRequest {
  address: string
}

export interface ListCookbookResponse {
  Cookbooks: Cookbook[]
}

export interface ListExecutionsRequest {
  sender: string
}

export interface ListExecutionsResponse {
  Executions: Execution[]
}

export interface GetLockedCoinsRequest {
  address: string
}

export interface GetLockedCoinsResponse {
  NodeVersion: string
  Sender: string
  Amount: Coin[]
}

export interface GetLockedCoinDetailsRequest {
  address: string
}

export interface GetLockedCoinDetailsResponse {
  sender: string
  Amount: Coin[]
  LockCoinTrades: LockedCoinDescribe[]
  LockCoinExecs: LockedCoinDescribe[]
}

export interface ListRecipeRequest {
  address: string
}

export interface ListRecipeResponse {
  recipes: Recipe[]
}

export interface ListRecipeByCookbookRequest {
  cookbookID: string
}

export interface ListRecipeByCookbookResponse {
  recipes: Recipe[]
}

export interface ListShortenRecipeRequest {
  address: string
}

export interface ListShortenRecipeResponse {
  recipes: ShortenRecipe[]
}

export interface ListShortenRecipeByCookbookRequest {
  cookbookID: string
}

export interface ListShortenRecipeByCookbookResponse {
  recipes: ShortenRecipe[]
}

export interface ListTradeRequest {
  address: string
}

export interface ListTradeResponse {
  trades: Trade[]
}

export interface PylonsBalanceRequest {
  address: string
}

export interface PylonsBalanceResponse {
  balance: number
}

const baseAddrFromPubKeyRequest: object = { hexPubKey: '' }

export const AddrFromPubKeyRequest = {
  encode(message: AddrFromPubKeyRequest, writer: Writer = Writer.create()): Writer {
    if (message.hexPubKey !== '') {
      writer.uint32(10).string(message.hexPubKey)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): AddrFromPubKeyRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseAddrFromPubKeyRequest } as AddrFromPubKeyRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.hexPubKey = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): AddrFromPubKeyRequest {
    const message = { ...baseAddrFromPubKeyRequest } as AddrFromPubKeyRequest
    if (object.hexPubKey !== undefined && object.hexPubKey !== null) {
      message.hexPubKey = String(object.hexPubKey)
    } else {
      message.hexPubKey = ''
    }
    return message
  },

  toJSON(message: AddrFromPubKeyRequest): unknown {
    const obj: any = {}
    message.hexPubKey !== undefined && (obj.hexPubKey = message.hexPubKey)
    return obj
  },

  fromPartial(object: DeepPartial<AddrFromPubKeyRequest>): AddrFromPubKeyRequest {
    const message = { ...baseAddrFromPubKeyRequest } as AddrFromPubKeyRequest
    if (object.hexPubKey !== undefined && object.hexPubKey !== null) {
      message.hexPubKey = object.hexPubKey
    } else {
      message.hexPubKey = ''
    }
    return message
  }
}

const baseAddrFromPubKeyResponse: object = { Bech32Addr: '' }

export const AddrFromPubKeyResponse = {
  encode(message: AddrFromPubKeyResponse, writer: Writer = Writer.create()): Writer {
    if (message.Bech32Addr !== '') {
      writer.uint32(10).string(message.Bech32Addr)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): AddrFromPubKeyResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseAddrFromPubKeyResponse } as AddrFromPubKeyResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Bech32Addr = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): AddrFromPubKeyResponse {
    const message = { ...baseAddrFromPubKeyResponse } as AddrFromPubKeyResponse
    if (object.Bech32Addr !== undefined && object.Bech32Addr !== null) {
      message.Bech32Addr = String(object.Bech32Addr)
    } else {
      message.Bech32Addr = ''
    }
    return message
  },

  toJSON(message: AddrFromPubKeyResponse): unknown {
    const obj: any = {}
    message.Bech32Addr !== undefined && (obj.Bech32Addr = message.Bech32Addr)
    return obj
  },

  fromPartial(object: DeepPartial<AddrFromPubKeyResponse>): AddrFromPubKeyResponse {
    const message = { ...baseAddrFromPubKeyResponse } as AddrFromPubKeyResponse
    if (object.Bech32Addr !== undefined && object.Bech32Addr !== null) {
      message.Bech32Addr = object.Bech32Addr
    } else {
      message.Bech32Addr = ''
    }
    return message
  }
}

const baseCheckGoogleIapOrderRequest: object = { purchaseToken: '' }

export const CheckGoogleIapOrderRequest = {
  encode(message: CheckGoogleIapOrderRequest, writer: Writer = Writer.create()): Writer {
    if (message.purchaseToken !== '') {
      writer.uint32(10).string(message.purchaseToken)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): CheckGoogleIapOrderRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseCheckGoogleIapOrderRequest } as CheckGoogleIapOrderRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.purchaseToken = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): CheckGoogleIapOrderRequest {
    const message = { ...baseCheckGoogleIapOrderRequest } as CheckGoogleIapOrderRequest
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = String(object.purchaseToken)
    } else {
      message.purchaseToken = ''
    }
    return message
  },

  toJSON(message: CheckGoogleIapOrderRequest): unknown {
    const obj: any = {}
    message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken)
    return obj
  },

  fromPartial(object: DeepPartial<CheckGoogleIapOrderRequest>): CheckGoogleIapOrderRequest {
    const message = { ...baseCheckGoogleIapOrderRequest } as CheckGoogleIapOrderRequest
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = object.purchaseToken
    } else {
      message.purchaseToken = ''
    }
    return message
  }
}

const baseCheckGoogleIapOrderResponse: object = { purchaseToken: '', exist: false }

export const CheckGoogleIapOrderResponse = {
  encode(message: CheckGoogleIapOrderResponse, writer: Writer = Writer.create()): Writer {
    if (message.purchaseToken !== '') {
      writer.uint32(10).string(message.purchaseToken)
    }
    if (message.exist === true) {
      writer.uint32(16).bool(message.exist)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): CheckGoogleIapOrderResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseCheckGoogleIapOrderResponse } as CheckGoogleIapOrderResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.purchaseToken = reader.string()
          break
        case 2:
          message.exist = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): CheckGoogleIapOrderResponse {
    const message = { ...baseCheckGoogleIapOrderResponse } as CheckGoogleIapOrderResponse
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = String(object.purchaseToken)
    } else {
      message.purchaseToken = ''
    }
    if (object.exist !== undefined && object.exist !== null) {
      message.exist = Boolean(object.exist)
    } else {
      message.exist = false
    }
    return message
  },

  toJSON(message: CheckGoogleIapOrderResponse): unknown {
    const obj: any = {}
    message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken)
    message.exist !== undefined && (obj.exist = message.exist)
    return obj
  },

  fromPartial(object: DeepPartial<CheckGoogleIapOrderResponse>): CheckGoogleIapOrderResponse {
    const message = { ...baseCheckGoogleIapOrderResponse } as CheckGoogleIapOrderResponse
    if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
      message.purchaseToken = object.purchaseToken
    } else {
      message.purchaseToken = ''
    }
    if (object.exist !== undefined && object.exist !== null) {
      message.exist = object.exist
    } else {
      message.exist = false
    }
    return message
  }
}

const baseGetCookbookRequest: object = { cookbookID: '' }

export const GetCookbookRequest = {
  encode(message: GetCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== '') {
      writer.uint32(10).string(message.cookbookID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetCookbookRequest } as GetCookbookRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetCookbookRequest {
    const message = { ...baseGetCookbookRequest } as GetCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    return message
  },

  toJSON(message: GetCookbookRequest): unknown {
    const obj: any = {}
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    return obj
  },

  fromPartial(object: DeepPartial<GetCookbookRequest>): GetCookbookRequest {
    const message = { ...baseGetCookbookRequest } as GetCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    return message
  }
}

const baseGetCookbookResponse: object = {
  NodeVersion: '',
  ID: '',
  Name: '',
  Description: '',
  Version: '',
  Developer: '',
  Level: 0,
  SupportEmail: '',
  CostPerBlock: 0,
  Sender: ''
}

export const GetCookbookResponse = {
  encode(message: GetCookbookResponse, writer: Writer = Writer.create()): Writer {
    if (message.NodeVersion !== '') {
      writer.uint32(10).string(message.NodeVersion)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.Name !== '') {
      writer.uint32(26).string(message.Name)
    }
    if (message.Description !== '') {
      writer.uint32(34).string(message.Description)
    }
    if (message.Version !== '') {
      writer.uint32(42).string(message.Version)
    }
    if (message.Developer !== '') {
      writer.uint32(50).string(message.Developer)
    }
    if (message.Level !== 0) {
      writer.uint32(56).int64(message.Level)
    }
    if (message.SupportEmail !== '') {
      writer.uint32(66).string(message.SupportEmail)
    }
    if (message.CostPerBlock !== 0) {
      writer.uint32(72).int64(message.CostPerBlock)
    }
    if (message.Sender !== '') {
      writer.uint32(82).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetCookbookResponse } as GetCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.NodeVersion = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.Name = reader.string()
          break
        case 4:
          message.Description = reader.string()
          break
        case 5:
          message.Version = reader.string()
          break
        case 6:
          message.Developer = reader.string()
          break
        case 7:
          message.Level = longToNumber(reader.int64() as Long)
          break
        case 8:
          message.SupportEmail = reader.string()
          break
        case 9:
          message.CostPerBlock = longToNumber(reader.int64() as Long)
          break
        case 10:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetCookbookResponse {
    const message = { ...baseGetCookbookResponse } as GetCookbookResponse
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = String(object.NodeVersion)
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = String(object.Name)
    } else {
      message.Name = ''
    }
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = String(object.Description)
    } else {
      message.Description = ''
    }
    if (object.Version !== undefined && object.Version !== null) {
      message.Version = String(object.Version)
    } else {
      message.Version = ''
    }
    if (object.Developer !== undefined && object.Developer !== null) {
      message.Developer = String(object.Developer)
    } else {
      message.Developer = ''
    }
    if (object.Level !== undefined && object.Level !== null) {
      message.Level = Number(object.Level)
    } else {
      message.Level = 0
    }
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = String(object.SupportEmail)
    } else {
      message.SupportEmail = ''
    }
    if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
      message.CostPerBlock = Number(object.CostPerBlock)
    } else {
      message.CostPerBlock = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: GetCookbookResponse): unknown {
    const obj: any = {}
    message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion)
    message.ID !== undefined && (obj.ID = message.ID)
    message.Name !== undefined && (obj.Name = message.Name)
    message.Description !== undefined && (obj.Description = message.Description)
    message.Version !== undefined && (obj.Version = message.Version)
    message.Developer !== undefined && (obj.Developer = message.Developer)
    message.Level !== undefined && (obj.Level = message.Level)
    message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail)
    message.CostPerBlock !== undefined && (obj.CostPerBlock = message.CostPerBlock)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<GetCookbookResponse>): GetCookbookResponse {
    const message = { ...baseGetCookbookResponse } as GetCookbookResponse
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = object.NodeVersion
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = object.Name
    } else {
      message.Name = ''
    }
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = object.Description
    } else {
      message.Description = ''
    }
    if (object.Version !== undefined && object.Version !== null) {
      message.Version = object.Version
    } else {
      message.Version = ''
    }
    if (object.Developer !== undefined && object.Developer !== null) {
      message.Developer = object.Developer
    } else {
      message.Developer = ''
    }
    if (object.Level !== undefined && object.Level !== null) {
      message.Level = object.Level
    } else {
      message.Level = 0
    }
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = object.SupportEmail
    } else {
      message.SupportEmail = ''
    }
    if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
      message.CostPerBlock = object.CostPerBlock
    } else {
      message.CostPerBlock = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseGetExecutionRequest: object = { executionID: '' }

export const GetExecutionRequest = {
  encode(message: GetExecutionRequest, writer: Writer = Writer.create()): Writer {
    if (message.executionID !== '') {
      writer.uint32(10).string(message.executionID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetExecutionRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetExecutionRequest } as GetExecutionRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.executionID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetExecutionRequest {
    const message = { ...baseGetExecutionRequest } as GetExecutionRequest
    if (object.executionID !== undefined && object.executionID !== null) {
      message.executionID = String(object.executionID)
    } else {
      message.executionID = ''
    }
    return message
  },

  toJSON(message: GetExecutionRequest): unknown {
    const obj: any = {}
    message.executionID !== undefined && (obj.executionID = message.executionID)
    return obj
  },

  fromPartial(object: DeepPartial<GetExecutionRequest>): GetExecutionRequest {
    const message = { ...baseGetExecutionRequest } as GetExecutionRequest
    if (object.executionID !== undefined && object.executionID !== null) {
      message.executionID = object.executionID
    } else {
      message.executionID = ''
    }
    return message
  }
}

const baseGetExecutionResponse: object = { NodeVersion: '', ID: '', RecipeID: '', CookbookID: '', BlockHeight: 0, Sender: '', Completed: false }

export const GetExecutionResponse = {
  encode(message: GetExecutionResponse, writer: Writer = Writer.create()): Writer {
    if (message.NodeVersion !== '') {
      writer.uint32(10).string(message.NodeVersion)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.RecipeID !== '') {
      writer.uint32(26).string(message.RecipeID)
    }
    if (message.CookbookID !== '') {
      writer.uint32(34).string(message.CookbookID)
    }
    for (const v of message.CoinsInput) {
      Coin.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      Item.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    if (message.BlockHeight !== 0) {
      writer.uint32(56).int64(message.BlockHeight)
    }
    if (message.Sender !== '') {
      writer.uint32(66).string(message.Sender)
    }
    if (message.Completed === true) {
      writer.uint32(72).bool(message.Completed)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetExecutionResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetExecutionResponse } as GetExecutionResponse
    message.CoinsInput = []
    message.ItemInputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.NodeVersion = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.RecipeID = reader.string()
          break
        case 4:
          message.CookbookID = reader.string()
          break
        case 5:
          message.CoinsInput.push(Coin.decode(reader, reader.uint32()))
          break
        case 6:
          message.ItemInputs.push(Item.decode(reader, reader.uint32()))
          break
        case 7:
          message.BlockHeight = longToNumber(reader.int64() as Long)
          break
        case 8:
          message.Sender = reader.string()
          break
        case 9:
          message.Completed = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetExecutionResponse {
    const message = { ...baseGetExecutionResponse } as GetExecutionResponse
    message.CoinsInput = []
    message.ItemInputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = String(object.NodeVersion)
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.CoinsInput !== undefined && object.CoinsInput !== null) {
      for (const e of object.CoinsInput) {
        message.CoinsInput.push(Coin.fromJSON(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(Item.fromJSON(e))
      }
    }
    if (object.BlockHeight !== undefined && object.BlockHeight !== null) {
      message.BlockHeight = Number(object.BlockHeight)
    } else {
      message.BlockHeight = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = Boolean(object.Completed)
    } else {
      message.Completed = false
    }
    return message
  },

  toJSON(message: GetExecutionResponse): unknown {
    const obj: any = {}
    message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion)
    message.ID !== undefined && (obj.ID = message.ID)
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    if (message.CoinsInput) {
      obj.CoinsInput = message.CoinsInput.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.CoinsInput = []
    }
    if (message.ItemInputs) {
      obj.ItemInputs = message.ItemInputs.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.ItemInputs = []
    }
    message.BlockHeight !== undefined && (obj.BlockHeight = message.BlockHeight)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Completed !== undefined && (obj.Completed = message.Completed)
    return obj
  },

  fromPartial(object: DeepPartial<GetExecutionResponse>): GetExecutionResponse {
    const message = { ...baseGetExecutionResponse } as GetExecutionResponse
    message.CoinsInput = []
    message.ItemInputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = object.NodeVersion
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.CoinsInput !== undefined && object.CoinsInput !== null) {
      for (const e of object.CoinsInput) {
        message.CoinsInput.push(Coin.fromPartial(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(Item.fromPartial(e))
      }
    }
    if (object.BlockHeight !== undefined && object.BlockHeight !== null) {
      message.BlockHeight = object.BlockHeight
    } else {
      message.BlockHeight = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = object.Completed
    } else {
      message.Completed = false
    }
    return message
  }
}

const baseGetItemRequest: object = { itemID: '' }

export const GetItemRequest = {
  encode(message: GetItemRequest, writer: Writer = Writer.create()): Writer {
    if (message.itemID !== '') {
      writer.uint32(10).string(message.itemID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetItemRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetItemRequest } as GetItemRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.itemID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetItemRequest {
    const message = { ...baseGetItemRequest } as GetItemRequest
    if (object.itemID !== undefined && object.itemID !== null) {
      message.itemID = String(object.itemID)
    } else {
      message.itemID = ''
    }
    return message
  },

  toJSON(message: GetItemRequest): unknown {
    const obj: any = {}
    message.itemID !== undefined && (obj.itemID = message.itemID)
    return obj
  },

  fromPartial(object: DeepPartial<GetItemRequest>): GetItemRequest {
    const message = { ...baseGetItemRequest } as GetItemRequest
    if (object.itemID !== undefined && object.itemID !== null) {
      message.itemID = object.itemID
    } else {
      message.itemID = ''
    }
    return message
  }
}

const baseGetItemResponse: object = {}

export const GetItemResponse = {
  encode(message: GetItemResponse, writer: Writer = Writer.create()): Writer {
    if (message.item !== undefined) {
      Item.encode(message.item, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetItemResponse } as GetItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.item = Item.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetItemResponse {
    const message = { ...baseGetItemResponse } as GetItemResponse
    if (object.item !== undefined && object.item !== null) {
      message.item = Item.fromJSON(object.item)
    } else {
      message.item = undefined
    }
    return message
  },

  toJSON(message: GetItemResponse): unknown {
    const obj: any = {}
    message.item !== undefined && (obj.item = message.item ? Item.toJSON(message.item) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<GetItemResponse>): GetItemResponse {
    const message = { ...baseGetItemResponse } as GetItemResponse
    if (object.item !== undefined && object.item !== null) {
      message.item = Item.fromPartial(object.item)
    } else {
      message.item = undefined
    }
    return message
  }
}

const baseGetRecipeRequest: object = { recipeID: '' }

export const GetRecipeRequest = {
  encode(message: GetRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.recipeID !== '') {
      writer.uint32(10).string(message.recipeID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetRecipeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetRecipeRequest } as GetRecipeRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.recipeID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetRecipeRequest {
    const message = { ...baseGetRecipeRequest } as GetRecipeRequest
    if (object.recipeID !== undefined && object.recipeID !== null) {
      message.recipeID = String(object.recipeID)
    } else {
      message.recipeID = ''
    }
    return message
  },

  toJSON(message: GetRecipeRequest): unknown {
    const obj: any = {}
    message.recipeID !== undefined && (obj.recipeID = message.recipeID)
    return obj
  },

  fromPartial(object: DeepPartial<GetRecipeRequest>): GetRecipeRequest {
    const message = { ...baseGetRecipeRequest } as GetRecipeRequest
    if (object.recipeID !== undefined && object.recipeID !== null) {
      message.recipeID = object.recipeID
    } else {
      message.recipeID = ''
    }
    return message
  }
}

const baseGetRecipeResponse: object = {
  NodeVersion: '',
  ID: '',
  CookbookID: '',
  Name: '',
  Description: '',
  BlockInterval: 0,
  Sender: '',
  Disabled: false,
  ExtraInfo: ''
}

export const GetRecipeResponse = {
  encode(message: GetRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.NodeVersion !== '') {
      writer.uint32(10).string(message.NodeVersion)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    if (message.CookbookID !== '') {
      writer.uint32(26).string(message.CookbookID)
    }
    if (message.Name !== '') {
      writer.uint32(34).string(message.Name)
    }
    for (const v of message.CoinInputs) {
      CoinInput.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      ItemInput.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    if (message.Entries !== undefined) {
      EntriesList.encode(message.Entries, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.Outputs) {
      WeightedOutputs.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    if (message.Description !== '') {
      writer.uint32(74).string(message.Description)
    }
    if (message.BlockInterval !== 0) {
      writer.uint32(80).int64(message.BlockInterval)
    }
    if (message.Sender !== '') {
      writer.uint32(90).string(message.Sender)
    }
    if (message.Disabled === true) {
      writer.uint32(96).bool(message.Disabled)
    }
    if (message.ExtraInfo !== '') {
      writer.uint32(106).string(message.ExtraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetRecipeResponse } as GetRecipeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.NodeVersion = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.CookbookID = reader.string()
          break
        case 4:
          message.Name = reader.string()
          break
        case 5:
          message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 6:
          message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 7:
          message.Entries = EntriesList.decode(reader, reader.uint32())
          break
        case 8:
          message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 9:
          message.Description = reader.string()
          break
        case 10:
          message.BlockInterval = longToNumber(reader.int64() as Long)
          break
        case 11:
          message.Sender = reader.string()
          break
        case 12:
          message.Disabled = reader.bool()
          break
        case 13:
          message.ExtraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetRecipeResponse {
    const message = { ...baseGetRecipeResponse } as GetRecipeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = String(object.NodeVersion)
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = String(object.Name)
    } else {
      message.Name = ''
    }
    if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
      for (const e of object.CoinInputs) {
        message.CoinInputs.push(CoinInput.fromJSON(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(ItemInput.fromJSON(e))
      }
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromJSON(object.Entries)
    } else {
      message.Entries = undefined
    }
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromJSON(e))
      }
    }
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = String(object.Description)
    } else {
      message.Description = ''
    }
    if (object.BlockInterval !== undefined && object.BlockInterval !== null) {
      message.BlockInterval = Number(object.BlockInterval)
    } else {
      message.BlockInterval = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.Disabled !== undefined && object.Disabled !== null) {
      message.Disabled = Boolean(object.Disabled)
    } else {
      message.Disabled = false
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = String(object.ExtraInfo)
    } else {
      message.ExtraInfo = ''
    }
    return message
  },

  toJSON(message: GetRecipeResponse): unknown {
    const obj: any = {}
    message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion)
    message.ID !== undefined && (obj.ID = message.ID)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.Name !== undefined && (obj.Name = message.Name)
    if (message.CoinInputs) {
      obj.CoinInputs = message.CoinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined))
    } else {
      obj.CoinInputs = []
    }
    if (message.ItemInputs) {
      obj.ItemInputs = message.ItemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined))
    } else {
      obj.ItemInputs = []
    }
    message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined)
    if (message.Outputs) {
      obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.Outputs = []
    }
    message.Description !== undefined && (obj.Description = message.Description)
    message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Disabled !== undefined && (obj.Disabled = message.Disabled)
    message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<GetRecipeResponse>): GetRecipeResponse {
    const message = { ...baseGetRecipeResponse } as GetRecipeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = object.NodeVersion
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = object.Name
    } else {
      message.Name = ''
    }
    if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
      for (const e of object.CoinInputs) {
        message.CoinInputs.push(CoinInput.fromPartial(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(ItemInput.fromPartial(e))
      }
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromPartial(object.Entries)
    } else {
      message.Entries = undefined
    }
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromPartial(e))
      }
    }
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = object.Description
    } else {
      message.Description = ''
    }
    if (object.BlockInterval !== undefined && object.BlockInterval !== null) {
      message.BlockInterval = object.BlockInterval
    } else {
      message.BlockInterval = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.Disabled !== undefined && object.Disabled !== null) {
      message.Disabled = object.Disabled
    } else {
      message.Disabled = false
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = object.ExtraInfo
    } else {
      message.ExtraInfo = ''
    }
    return message
  }
}

const baseGetTradeRequest: object = { tradeID: '' }

export const GetTradeRequest = {
  encode(message: GetTradeRequest, writer: Writer = Writer.create()): Writer {
    if (message.tradeID !== '') {
      writer.uint32(10).string(message.tradeID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetTradeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetTradeRequest } as GetTradeRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.tradeID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetTradeRequest {
    const message = { ...baseGetTradeRequest } as GetTradeRequest
    if (object.tradeID !== undefined && object.tradeID !== null) {
      message.tradeID = String(object.tradeID)
    } else {
      message.tradeID = ''
    }
    return message
  },

  toJSON(message: GetTradeRequest): unknown {
    const obj: any = {}
    message.tradeID !== undefined && (obj.tradeID = message.tradeID)
    return obj
  },

  fromPartial(object: DeepPartial<GetTradeRequest>): GetTradeRequest {
    const message = { ...baseGetTradeRequest } as GetTradeRequest
    if (object.tradeID !== undefined && object.tradeID !== null) {
      message.tradeID = object.tradeID
    } else {
      message.tradeID = ''
    }
    return message
  }
}

const baseGetTradeResponse: object = { NodeVersion: '', ID: '', ExtraInfo: '', Sender: '', FulFiller: '', Disabled: false, Completed: false }

export const GetTradeResponse = {
  encode(message: GetTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.NodeVersion !== '') {
      writer.uint32(10).string(message.NodeVersion)
    }
    if (message.ID !== '') {
      writer.uint32(18).string(message.ID)
    }
    for (const v of message.CoinInputs) {
      CoinInput.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      TradeItemInput.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.CoinOutputs) {
      Coin.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.ItemOutputs) {
      Item.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    if (message.ExtraInfo !== '') {
      writer.uint32(58).string(message.ExtraInfo)
    }
    if (message.Sender !== '') {
      writer.uint32(66).string(message.Sender)
    }
    if (message.FulFiller !== '') {
      writer.uint32(74).string(message.FulFiller)
    }
    if (message.Disabled === true) {
      writer.uint32(80).bool(message.Disabled)
    }
    if (message.Completed === true) {
      writer.uint32(88).bool(message.Completed)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetTradeResponse } as GetTradeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.NodeVersion = reader.string()
          break
        case 2:
          message.ID = reader.string()
          break
        case 3:
          message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 4:
          message.ItemInputs.push(TradeItemInput.decode(reader, reader.uint32()))
          break
        case 5:
          message.CoinOutputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 6:
          message.ItemOutputs.push(Item.decode(reader, reader.uint32()))
          break
        case 7:
          message.ExtraInfo = reader.string()
          break
        case 8:
          message.Sender = reader.string()
          break
        case 9:
          message.FulFiller = reader.string()
          break
        case 10:
          message.Disabled = reader.bool()
          break
        case 11:
          message.Completed = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetTradeResponse {
    const message = { ...baseGetTradeResponse } as GetTradeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = String(object.NodeVersion)
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
      for (const e of object.CoinInputs) {
        message.CoinInputs.push(CoinInput.fromJSON(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(TradeItemInput.fromJSON(e))
      }
    }
    if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
      for (const e of object.CoinOutputs) {
        message.CoinOutputs.push(Coin.fromJSON(e))
      }
    }
    if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
      for (const e of object.ItemOutputs) {
        message.ItemOutputs.push(Item.fromJSON(e))
      }
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = String(object.ExtraInfo)
    } else {
      message.ExtraInfo = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.FulFiller !== undefined && object.FulFiller !== null) {
      message.FulFiller = String(object.FulFiller)
    } else {
      message.FulFiller = ''
    }
    if (object.Disabled !== undefined && object.Disabled !== null) {
      message.Disabled = Boolean(object.Disabled)
    } else {
      message.Disabled = false
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = Boolean(object.Completed)
    } else {
      message.Completed = false
    }
    return message
  },

  toJSON(message: GetTradeResponse): unknown {
    const obj: any = {}
    message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion)
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.CoinInputs) {
      obj.CoinInputs = message.CoinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined))
    } else {
      obj.CoinInputs = []
    }
    if (message.ItemInputs) {
      obj.ItemInputs = message.ItemInputs.map((e) => (e ? TradeItemInput.toJSON(e) : undefined))
    } else {
      obj.ItemInputs = []
    }
    if (message.CoinOutputs) {
      obj.CoinOutputs = message.CoinOutputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.CoinOutputs = []
    }
    if (message.ItemOutputs) {
      obj.ItemOutputs = message.ItemOutputs.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.ItemOutputs = []
    }
    message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.FulFiller !== undefined && (obj.FulFiller = message.FulFiller)
    message.Disabled !== undefined && (obj.Disabled = message.Disabled)
    message.Completed !== undefined && (obj.Completed = message.Completed)
    return obj
  },

  fromPartial(object: DeepPartial<GetTradeResponse>): GetTradeResponse {
    const message = { ...baseGetTradeResponse } as GetTradeResponse
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = object.NodeVersion
    } else {
      message.NodeVersion = ''
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
      for (const e of object.CoinInputs) {
        message.CoinInputs.push(CoinInput.fromPartial(e))
      }
    }
    if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
      for (const e of object.ItemInputs) {
        message.ItemInputs.push(TradeItemInput.fromPartial(e))
      }
    }
    if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
      for (const e of object.CoinOutputs) {
        message.CoinOutputs.push(Coin.fromPartial(e))
      }
    }
    if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
      for (const e of object.ItemOutputs) {
        message.ItemOutputs.push(Item.fromPartial(e))
      }
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = object.ExtraInfo
    } else {
      message.ExtraInfo = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.FulFiller !== undefined && object.FulFiller !== null) {
      message.FulFiller = object.FulFiller
    } else {
      message.FulFiller = ''
    }
    if (object.Disabled !== undefined && object.Disabled !== null) {
      message.Disabled = object.Disabled
    } else {
      message.Disabled = false
    }
    if (object.Completed !== undefined && object.Completed !== null) {
      message.Completed = object.Completed
    } else {
      message.Completed = false
    }
    return message
  }
}

const baseItemsByCookbookRequest: object = { cookbookID: '' }

export const ItemsByCookbookRequest = {
  encode(message: ItemsByCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== '') {
      writer.uint32(10).string(message.cookbookID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemsByCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemsByCookbookRequest } as ItemsByCookbookRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemsByCookbookRequest {
    const message = { ...baseItemsByCookbookRequest } as ItemsByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    return message
  },

  toJSON(message: ItemsByCookbookRequest): unknown {
    const obj: any = {}
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    return obj
  },

  fromPartial(object: DeepPartial<ItemsByCookbookRequest>): ItemsByCookbookRequest {
    const message = { ...baseItemsByCookbookRequest } as ItemsByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    return message
  }
}

const baseItemsByCookbookResponse: object = {}

export const ItemsByCookbookResponse = {
  encode(message: ItemsByCookbookResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Items) {
      Item.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemsByCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemsByCookbookResponse } as ItemsByCookbookResponse
    message.Items = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Items.push(Item.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemsByCookbookResponse {
    const message = { ...baseItemsByCookbookResponse } as ItemsByCookbookResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ItemsByCookbookResponse): unknown {
    const obj: any = {}
    if (message.Items) {
      obj.Items = message.Items.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.Items = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ItemsByCookbookResponse>): ItemsByCookbookResponse {
    const message = { ...baseItemsByCookbookResponse } as ItemsByCookbookResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromPartial(e))
      }
    }
    return message
  }
}

const baseItemsBySenderRequest: object = { sender: '' }

export const ItemsBySenderRequest = {
  encode(message: ItemsBySenderRequest, writer: Writer = Writer.create()): Writer {
    if (message.sender !== '') {
      writer.uint32(10).string(message.sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemsBySenderRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemsBySenderRequest } as ItemsBySenderRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemsBySenderRequest {
    const message = { ...baseItemsBySenderRequest } as ItemsBySenderRequest
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = String(object.sender)
    } else {
      message.sender = ''
    }
    return message
  },

  toJSON(message: ItemsBySenderRequest): unknown {
    const obj: any = {}
    message.sender !== undefined && (obj.sender = message.sender)
    return obj
  },

  fromPartial(object: DeepPartial<ItemsBySenderRequest>): ItemsBySenderRequest {
    const message = { ...baseItemsBySenderRequest } as ItemsBySenderRequest
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = object.sender
    } else {
      message.sender = ''
    }
    return message
  }
}

const baseItemsBySenderResponse: object = {}

export const ItemsBySenderResponse = {
  encode(message: ItemsBySenderResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Items) {
      Item.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemsBySenderResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemsBySenderResponse } as ItemsBySenderResponse
    message.Items = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Items.push(Item.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemsBySenderResponse {
    const message = { ...baseItemsBySenderResponse } as ItemsBySenderResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ItemsBySenderResponse): unknown {
    const obj: any = {}
    if (message.Items) {
      obj.Items = message.Items.map((e) => (e ? Item.toJSON(e) : undefined))
    } else {
      obj.Items = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ItemsBySenderResponse>): ItemsBySenderResponse {
    const message = { ...baseItemsBySenderResponse } as ItemsBySenderResponse
    message.Items = []
    if (object.Items !== undefined && object.Items !== null) {
      for (const e of object.Items) {
        message.Items.push(Item.fromPartial(e))
      }
    }
    return message
  }
}

const baseListCookbookRequest: object = { address: '' }

export const ListCookbookRequest = {
  encode(message: ListCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListCookbookRequest } as ListCookbookRequest
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

  fromJSON(object: any): ListCookbookRequest {
    const message = { ...baseListCookbookRequest } as ListCookbookRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: ListCookbookRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<ListCookbookRequest>): ListCookbookRequest {
    const message = { ...baseListCookbookRequest } as ListCookbookRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseListCookbookResponse: object = {}

export const ListCookbookResponse = {
  encode(message: ListCookbookResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Cookbooks) {
      Cookbook.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListCookbookResponse } as ListCookbookResponse
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

  fromJSON(object: any): ListCookbookResponse {
    const message = { ...baseListCookbookResponse } as ListCookbookResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListCookbookResponse): unknown {
    const obj: any = {}
    if (message.Cookbooks) {
      obj.Cookbooks = message.Cookbooks.map((e) => (e ? Cookbook.toJSON(e) : undefined))
    } else {
      obj.Cookbooks = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListCookbookResponse>): ListCookbookResponse {
    const message = { ...baseListCookbookResponse } as ListCookbookResponse
    message.Cookbooks = []
    if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
      for (const e of object.Cookbooks) {
        message.Cookbooks.push(Cookbook.fromPartial(e))
      }
    }
    return message
  }
}

const baseListExecutionsRequest: object = { sender: '' }

export const ListExecutionsRequest = {
  encode(message: ListExecutionsRequest, writer: Writer = Writer.create()): Writer {
    if (message.sender !== '') {
      writer.uint32(10).string(message.sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListExecutionsRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListExecutionsRequest } as ListExecutionsRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListExecutionsRequest {
    const message = { ...baseListExecutionsRequest } as ListExecutionsRequest
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = String(object.sender)
    } else {
      message.sender = ''
    }
    return message
  },

  toJSON(message: ListExecutionsRequest): unknown {
    const obj: any = {}
    message.sender !== undefined && (obj.sender = message.sender)
    return obj
  },

  fromPartial(object: DeepPartial<ListExecutionsRequest>): ListExecutionsRequest {
    const message = { ...baseListExecutionsRequest } as ListExecutionsRequest
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = object.sender
    } else {
      message.sender = ''
    }
    return message
  }
}

const baseListExecutionsResponse: object = {}

export const ListExecutionsResponse = {
  encode(message: ListExecutionsResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.Executions) {
      Execution.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListExecutionsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListExecutionsResponse } as ListExecutionsResponse
    message.Executions = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Executions.push(Execution.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListExecutionsResponse {
    const message = { ...baseListExecutionsResponse } as ListExecutionsResponse
    message.Executions = []
    if (object.Executions !== undefined && object.Executions !== null) {
      for (const e of object.Executions) {
        message.Executions.push(Execution.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListExecutionsResponse): unknown {
    const obj: any = {}
    if (message.Executions) {
      obj.Executions = message.Executions.map((e) => (e ? Execution.toJSON(e) : undefined))
    } else {
      obj.Executions = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListExecutionsResponse>): ListExecutionsResponse {
    const message = { ...baseListExecutionsResponse } as ListExecutionsResponse
    message.Executions = []
    if (object.Executions !== undefined && object.Executions !== null) {
      for (const e of object.Executions) {
        message.Executions.push(Execution.fromPartial(e))
      }
    }
    return message
  }
}

const baseGetLockedCoinsRequest: object = { address: '' }

export const GetLockedCoinsRequest = {
  encode(message: GetLockedCoinsRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetLockedCoinsRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetLockedCoinsRequest } as GetLockedCoinsRequest
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

  fromJSON(object: any): GetLockedCoinsRequest {
    const message = { ...baseGetLockedCoinsRequest } as GetLockedCoinsRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: GetLockedCoinsRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<GetLockedCoinsRequest>): GetLockedCoinsRequest {
    const message = { ...baseGetLockedCoinsRequest } as GetLockedCoinsRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseGetLockedCoinsResponse: object = { NodeVersion: '', Sender: '' }

export const GetLockedCoinsResponse = {
  encode(message: GetLockedCoinsResponse, writer: Writer = Writer.create()): Writer {
    if (message.NodeVersion !== '') {
      writer.uint32(10).string(message.NodeVersion)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    for (const v of message.Amount) {
      Coin.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetLockedCoinsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetLockedCoinsResponse } as GetLockedCoinsResponse
    message.Amount = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.NodeVersion = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.Amount.push(Coin.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetLockedCoinsResponse {
    const message = { ...baseGetLockedCoinsResponse } as GetLockedCoinsResponse
    message.Amount = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = String(object.NodeVersion)
    } else {
      message.NodeVersion = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: GetLockedCoinsResponse): unknown {
    const obj: any = {}
    message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    if (message.Amount) {
      obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.Amount = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<GetLockedCoinsResponse>): GetLockedCoinsResponse {
    const message = { ...baseGetLockedCoinsResponse } as GetLockedCoinsResponse
    message.Amount = []
    if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
      message.NodeVersion = object.NodeVersion
    } else {
      message.NodeVersion = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromPartial(e))
      }
    }
    return message
  }
}

const baseGetLockedCoinDetailsRequest: object = { address: '' }

export const GetLockedCoinDetailsRequest = {
  encode(message: GetLockedCoinDetailsRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetLockedCoinDetailsRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetLockedCoinDetailsRequest } as GetLockedCoinDetailsRequest
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

  fromJSON(object: any): GetLockedCoinDetailsRequest {
    const message = { ...baseGetLockedCoinDetailsRequest } as GetLockedCoinDetailsRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: GetLockedCoinDetailsRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<GetLockedCoinDetailsRequest>): GetLockedCoinDetailsRequest {
    const message = { ...baseGetLockedCoinDetailsRequest } as GetLockedCoinDetailsRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseGetLockedCoinDetailsResponse: object = { sender: '' }

export const GetLockedCoinDetailsResponse = {
  encode(message: GetLockedCoinDetailsResponse, writer: Writer = Writer.create()): Writer {
    if (message.sender !== '') {
      writer.uint32(10).string(message.sender)
    }
    for (const v of message.Amount) {
      Coin.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.LockCoinTrades) {
      LockedCoinDescribe.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.LockCoinExecs) {
      LockedCoinDescribe.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): GetLockedCoinDetailsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseGetLockedCoinDetailsResponse } as GetLockedCoinDetailsResponse
    message.Amount = []
    message.LockCoinTrades = []
    message.LockCoinExecs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.sender = reader.string()
          break
        case 2:
          message.Amount.push(Coin.decode(reader, reader.uint32()))
          break
        case 3:
          message.LockCoinTrades.push(LockedCoinDescribe.decode(reader, reader.uint32()))
          break
        case 4:
          message.LockCoinExecs.push(LockedCoinDescribe.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): GetLockedCoinDetailsResponse {
    const message = { ...baseGetLockedCoinDetailsResponse } as GetLockedCoinDetailsResponse
    message.Amount = []
    message.LockCoinTrades = []
    message.LockCoinExecs = []
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = String(object.sender)
    } else {
      message.sender = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromJSON(e))
      }
    }
    if (object.LockCoinTrades !== undefined && object.LockCoinTrades !== null) {
      for (const e of object.LockCoinTrades) {
        message.LockCoinTrades.push(LockedCoinDescribe.fromJSON(e))
      }
    }
    if (object.LockCoinExecs !== undefined && object.LockCoinExecs !== null) {
      for (const e of object.LockCoinExecs) {
        message.LockCoinExecs.push(LockedCoinDescribe.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: GetLockedCoinDetailsResponse): unknown {
    const obj: any = {}
    message.sender !== undefined && (obj.sender = message.sender)
    if (message.Amount) {
      obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.Amount = []
    }
    if (message.LockCoinTrades) {
      obj.LockCoinTrades = message.LockCoinTrades.map((e) => (e ? LockedCoinDescribe.toJSON(e) : undefined))
    } else {
      obj.LockCoinTrades = []
    }
    if (message.LockCoinExecs) {
      obj.LockCoinExecs = message.LockCoinExecs.map((e) => (e ? LockedCoinDescribe.toJSON(e) : undefined))
    } else {
      obj.LockCoinExecs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<GetLockedCoinDetailsResponse>): GetLockedCoinDetailsResponse {
    const message = { ...baseGetLockedCoinDetailsResponse } as GetLockedCoinDetailsResponse
    message.Amount = []
    message.LockCoinTrades = []
    message.LockCoinExecs = []
    if (object.sender !== undefined && object.sender !== null) {
      message.sender = object.sender
    } else {
      message.sender = ''
    }
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromPartial(e))
      }
    }
    if (object.LockCoinTrades !== undefined && object.LockCoinTrades !== null) {
      for (const e of object.LockCoinTrades) {
        message.LockCoinTrades.push(LockedCoinDescribe.fromPartial(e))
      }
    }
    if (object.LockCoinExecs !== undefined && object.LockCoinExecs !== null) {
      for (const e of object.LockCoinExecs) {
        message.LockCoinExecs.push(LockedCoinDescribe.fromPartial(e))
      }
    }
    return message
  }
}

const baseListRecipeRequest: object = { address: '' }

export const ListRecipeRequest = {
  encode(message: ListRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListRecipeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListRecipeRequest } as ListRecipeRequest
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

  fromJSON(object: any): ListRecipeRequest {
    const message = { ...baseListRecipeRequest } as ListRecipeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: ListRecipeRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<ListRecipeRequest>): ListRecipeRequest {
    const message = { ...baseListRecipeRequest } as ListRecipeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseListRecipeResponse: object = {}

export const ListRecipeResponse = {
  encode(message: ListRecipeResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.recipes) {
      Recipe.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListRecipeResponse } as ListRecipeResponse
    message.recipes = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.recipes.push(Recipe.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListRecipeResponse {
    const message = { ...baseListRecipeResponse } as ListRecipeResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(Recipe.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListRecipeResponse): unknown {
    const obj: any = {}
    if (message.recipes) {
      obj.recipes = message.recipes.map((e) => (e ? Recipe.toJSON(e) : undefined))
    } else {
      obj.recipes = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListRecipeResponse>): ListRecipeResponse {
    const message = { ...baseListRecipeResponse } as ListRecipeResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(Recipe.fromPartial(e))
      }
    }
    return message
  }
}

const baseListRecipeByCookbookRequest: object = { cookbookID: '' }

export const ListRecipeByCookbookRequest = {
  encode(message: ListRecipeByCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== '') {
      writer.uint32(10).string(message.cookbookID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListRecipeByCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListRecipeByCookbookRequest } as ListRecipeByCookbookRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListRecipeByCookbookRequest {
    const message = { ...baseListRecipeByCookbookRequest } as ListRecipeByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    return message
  },

  toJSON(message: ListRecipeByCookbookRequest): unknown {
    const obj: any = {}
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    return obj
  },

  fromPartial(object: DeepPartial<ListRecipeByCookbookRequest>): ListRecipeByCookbookRequest {
    const message = { ...baseListRecipeByCookbookRequest } as ListRecipeByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    return message
  }
}

const baseListRecipeByCookbookResponse: object = {}

export const ListRecipeByCookbookResponse = {
  encode(message: ListRecipeByCookbookResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.recipes) {
      Recipe.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListRecipeByCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListRecipeByCookbookResponse } as ListRecipeByCookbookResponse
    message.recipes = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.recipes.push(Recipe.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListRecipeByCookbookResponse {
    const message = { ...baseListRecipeByCookbookResponse } as ListRecipeByCookbookResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(Recipe.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListRecipeByCookbookResponse): unknown {
    const obj: any = {}
    if (message.recipes) {
      obj.recipes = message.recipes.map((e) => (e ? Recipe.toJSON(e) : undefined))
    } else {
      obj.recipes = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListRecipeByCookbookResponse>): ListRecipeByCookbookResponse {
    const message = { ...baseListRecipeByCookbookResponse } as ListRecipeByCookbookResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(Recipe.fromPartial(e))
      }
    }
    return message
  }
}

const baseListShortenRecipeRequest: object = { address: '' }

export const ListShortenRecipeRequest = {
  encode(message: ListShortenRecipeRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListShortenRecipeRequest } as ListShortenRecipeRequest
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

  fromJSON(object: any): ListShortenRecipeRequest {
    const message = { ...baseListShortenRecipeRequest } as ListShortenRecipeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: ListShortenRecipeRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<ListShortenRecipeRequest>): ListShortenRecipeRequest {
    const message = { ...baseListShortenRecipeRequest } as ListShortenRecipeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseListShortenRecipeResponse: object = {}

export const ListShortenRecipeResponse = {
  encode(message: ListShortenRecipeResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.recipes) {
      ShortenRecipe.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListShortenRecipeResponse } as ListShortenRecipeResponse
    message.recipes = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.recipes.push(ShortenRecipe.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListShortenRecipeResponse {
    const message = { ...baseListShortenRecipeResponse } as ListShortenRecipeResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(ShortenRecipe.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListShortenRecipeResponse): unknown {
    const obj: any = {}
    if (message.recipes) {
      obj.recipes = message.recipes.map((e) => (e ? ShortenRecipe.toJSON(e) : undefined))
    } else {
      obj.recipes = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListShortenRecipeResponse>): ListShortenRecipeResponse {
    const message = { ...baseListShortenRecipeResponse } as ListShortenRecipeResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(ShortenRecipe.fromPartial(e))
      }
    }
    return message
  }
}

const baseListShortenRecipeByCookbookRequest: object = { cookbookID: '' }

export const ListShortenRecipeByCookbookRequest = {
  encode(message: ListShortenRecipeByCookbookRequest, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== '') {
      writer.uint32(10).string(message.cookbookID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeByCookbookRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListShortenRecipeByCookbookRequest } as ListShortenRecipeByCookbookRequest
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListShortenRecipeByCookbookRequest {
    const message = { ...baseListShortenRecipeByCookbookRequest } as ListShortenRecipeByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
    }
    return message
  },

  toJSON(message: ListShortenRecipeByCookbookRequest): unknown {
    const obj: any = {}
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    return obj
  },

  fromPartial(object: DeepPartial<ListShortenRecipeByCookbookRequest>): ListShortenRecipeByCookbookRequest {
    const message = { ...baseListShortenRecipeByCookbookRequest } as ListShortenRecipeByCookbookRequest
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
    }
    return message
  }
}

const baseListShortenRecipeByCookbookResponse: object = {}

export const ListShortenRecipeByCookbookResponse = {
  encode(message: ListShortenRecipeByCookbookResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.recipes) {
      ShortenRecipe.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeByCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListShortenRecipeByCookbookResponse } as ListShortenRecipeByCookbookResponse
    message.recipes = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.recipes.push(ShortenRecipe.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListShortenRecipeByCookbookResponse {
    const message = { ...baseListShortenRecipeByCookbookResponse } as ListShortenRecipeByCookbookResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(ShortenRecipe.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListShortenRecipeByCookbookResponse): unknown {
    const obj: any = {}
    if (message.recipes) {
      obj.recipes = message.recipes.map((e) => (e ? ShortenRecipe.toJSON(e) : undefined))
    } else {
      obj.recipes = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListShortenRecipeByCookbookResponse>): ListShortenRecipeByCookbookResponse {
    const message = { ...baseListShortenRecipeByCookbookResponse } as ListShortenRecipeByCookbookResponse
    message.recipes = []
    if (object.recipes !== undefined && object.recipes !== null) {
      for (const e of object.recipes) {
        message.recipes.push(ShortenRecipe.fromPartial(e))
      }
    }
    return message
  }
}

const baseListTradeRequest: object = { address: '' }

export const ListTradeRequest = {
  encode(message: ListTradeRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListTradeRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListTradeRequest } as ListTradeRequest
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

  fromJSON(object: any): ListTradeRequest {
    const message = { ...baseListTradeRequest } as ListTradeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: ListTradeRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<ListTradeRequest>): ListTradeRequest {
    const message = { ...baseListTradeRequest } as ListTradeRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const baseListTradeResponse: object = {}

export const ListTradeResponse = {
  encode(message: ListTradeResponse, writer: Writer = Writer.create()): Writer {
    for (const v of message.trades) {
      Trade.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ListTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseListTradeResponse } as ListTradeResponse
    message.trades = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.trades.push(Trade.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ListTradeResponse {
    const message = { ...baseListTradeResponse } as ListTradeResponse
    message.trades = []
    if (object.trades !== undefined && object.trades !== null) {
      for (const e of object.trades) {
        message.trades.push(Trade.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ListTradeResponse): unknown {
    const obj: any = {}
    if (message.trades) {
      obj.trades = message.trades.map((e) => (e ? Trade.toJSON(e) : undefined))
    } else {
      obj.trades = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ListTradeResponse>): ListTradeResponse {
    const message = { ...baseListTradeResponse } as ListTradeResponse
    message.trades = []
    if (object.trades !== undefined && object.trades !== null) {
      for (const e of object.trades) {
        message.trades.push(Trade.fromPartial(e))
      }
    }
    return message
  }
}

const basePylonsBalanceRequest: object = { address: '' }

export const PylonsBalanceRequest = {
  encode(message: PylonsBalanceRequest, writer: Writer = Writer.create()): Writer {
    if (message.address !== '') {
      writer.uint32(10).string(message.address)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): PylonsBalanceRequest {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...basePylonsBalanceRequest } as PylonsBalanceRequest
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

  fromJSON(object: any): PylonsBalanceRequest {
    const message = { ...basePylonsBalanceRequest } as PylonsBalanceRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address)
    } else {
      message.address = ''
    }
    return message
  },

  toJSON(message: PylonsBalanceRequest): unknown {
    const obj: any = {}
    message.address !== undefined && (obj.address = message.address)
    return obj
  },

  fromPartial(object: DeepPartial<PylonsBalanceRequest>): PylonsBalanceRequest {
    const message = { ...basePylonsBalanceRequest } as PylonsBalanceRequest
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address
    } else {
      message.address = ''
    }
    return message
  }
}

const basePylonsBalanceResponse: object = { balance: 0 }

export const PylonsBalanceResponse = {
  encode(message: PylonsBalanceResponse, writer: Writer = Writer.create()): Writer {
    if (message.balance !== 0) {
      writer.uint32(8).int64(message.balance)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): PylonsBalanceResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...basePylonsBalanceResponse } as PylonsBalanceResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.balance = longToNumber(reader.int64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): PylonsBalanceResponse {
    const message = { ...basePylonsBalanceResponse } as PylonsBalanceResponse
    if (object.balance !== undefined && object.balance !== null) {
      message.balance = Number(object.balance)
    } else {
      message.balance = 0
    }
    return message
  },

  toJSON(message: PylonsBalanceResponse): unknown {
    const obj: any = {}
    message.balance !== undefined && (obj.balance = message.balance)
    return obj
  },

  fromPartial(object: DeepPartial<PylonsBalanceResponse>): PylonsBalanceResponse {
    const message = { ...basePylonsBalanceResponse } as PylonsBalanceResponse
    if (object.balance !== undefined && object.balance !== null) {
      message.balance = object.balance
    } else {
      message.balance = 0
    }
    return message
  }
}

export interface Query {
  /** AddrFromPubKey returns a bech32 public address from the public key */
  AddrFromPubKey(request: AddrFromPubKeyRequest): Promise<AddrFromPubKeyResponse>
  /** CheckGoogleIapOrder check if google iap order is given to user with purchase token */
  CheckGoogleIapOrder(request: CheckGoogleIapOrderRequest): Promise<CheckGoogleIapOrderResponse>
  /** GetCookbook returns a cookbook based on the cookbook id */
  GetCookbook(request: GetCookbookRequest): Promise<GetCookbookResponse>
  /** GetExecution returns an execution based on the execution id */
  GetExecution(request: GetExecutionRequest): Promise<GetExecutionResponse>
  /** GetItem returns a item based on the item id */
  GetItem(request: GetItemRequest): Promise<GetItemResponse>
  /** GetRecipe returns a recipe based on the recipe id */
  GetRecipe(request: GetRecipeRequest): Promise<GetRecipeResponse>
  /** GetTrade returns a trade based on the trade id */
  GetTrade(request: GetTradeRequest): Promise<GetTradeResponse>
  /** ItemsByCookbook returns a cookbook based on the cookbook id */
  ItemsByCookbook(request: ItemsByCookbookRequest): Promise<ItemsByCookbookResponse>
  /** ItemsBySender returns all items based on the sender address */
  ItemsBySender(request: ItemsBySenderRequest): Promise<ItemsBySenderResponse>
  /** ListCookbook returns a cookbook based on the cookbook id */
  ListCookbook(request: ListCookbookRequest): Promise<ListCookbookResponse>
  /** ListExecutions lists all the executions based on the sender address */
  ListExecutions(request: ListExecutionsRequest): Promise<ListExecutionsResponse>
  /** GetLockedCoins returns locked coins based on user */
  GetLockedCoins(request: GetLockedCoinsRequest): Promise<GetLockedCoinsResponse>
  /** GetLockedCoinDetails returns locked coins with details based on user */
  GetLockedCoinDetails(request: GetLockedCoinDetailsRequest): Promise<GetLockedCoinDetailsResponse>
  /** ListRecipe returns a recipe based on the recipe id */
  ListRecipe(request: ListRecipeRequest): Promise<ListRecipeResponse>
  /** ListRecipeByCookbook returns a recipe based on the recipe id */
  ListRecipeByCookbook(request: ListRecipeByCookbookRequest): Promise<ListRecipeByCookbookResponse>
  /** ListShortenRecipe returns a recipe based on the recipe id */
  ListShortenRecipe(request: ListShortenRecipeRequest): Promise<ListShortenRecipeResponse>
  /** ListShortenRecipeByCookbook returns a recipe based on the recipe id */
  ListShortenRecipeByCookbook(request: ListShortenRecipeByCookbookRequest): Promise<ListShortenRecipeByCookbookResponse>
  /** ListTrade returns a trade based on the trade id */
  ListTrade(request: ListTradeRequest): Promise<ListTradeResponse>
  /** PylonsBalance provides balances in pylons */
  PylonsBalance(request: PylonsBalanceRequest): Promise<PylonsBalanceResponse>
}

export class QueryClientImpl implements Query {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
  }
  AddrFromPubKey(request: AddrFromPubKeyRequest): Promise<AddrFromPubKeyResponse> {
    const data = AddrFromPubKeyRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'AddrFromPubKey', data)
    return promise.then((data) => AddrFromPubKeyResponse.decode(new Reader(data)))
  }

  CheckGoogleIapOrder(request: CheckGoogleIapOrderRequest): Promise<CheckGoogleIapOrderResponse> {
    const data = CheckGoogleIapOrderRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'CheckGoogleIapOrder', data)
    return promise.then((data) => CheckGoogleIapOrderResponse.decode(new Reader(data)))
  }

  GetCookbook(request: GetCookbookRequest): Promise<GetCookbookResponse> {
    const data = GetCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetCookbook', data)
    return promise.then((data) => GetCookbookResponse.decode(new Reader(data)))
  }

  GetExecution(request: GetExecutionRequest): Promise<GetExecutionResponse> {
    const data = GetExecutionRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetExecution', data)
    return promise.then((data) => GetExecutionResponse.decode(new Reader(data)))
  }

  GetItem(request: GetItemRequest): Promise<GetItemResponse> {
    const data = GetItemRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetItem', data)
    return promise.then((data) => GetItemResponse.decode(new Reader(data)))
  }

  GetRecipe(request: GetRecipeRequest): Promise<GetRecipeResponse> {
    const data = GetRecipeRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetRecipe', data)
    return promise.then((data) => GetRecipeResponse.decode(new Reader(data)))
  }

  GetTrade(request: GetTradeRequest): Promise<GetTradeResponse> {
    const data = GetTradeRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetTrade', data)
    return promise.then((data) => GetTradeResponse.decode(new Reader(data)))
  }

  ItemsByCookbook(request: ItemsByCookbookRequest): Promise<ItemsByCookbookResponse> {
    const data = ItemsByCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ItemsByCookbook', data)
    return promise.then((data) => ItemsByCookbookResponse.decode(new Reader(data)))
  }

  ItemsBySender(request: ItemsBySenderRequest): Promise<ItemsBySenderResponse> {
    const data = ItemsBySenderRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ItemsBySender', data)
    return promise.then((data) => ItemsBySenderResponse.decode(new Reader(data)))
  }

  ListCookbook(request: ListCookbookRequest): Promise<ListCookbookResponse> {
    const data = ListCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListCookbook', data)
    return promise.then((data) => ListCookbookResponse.decode(new Reader(data)))
  }

  ListExecutions(request: ListExecutionsRequest): Promise<ListExecutionsResponse> {
    const data = ListExecutionsRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListExecutions', data)
    return promise.then((data) => ListExecutionsResponse.decode(new Reader(data)))
  }

  GetLockedCoins(request: GetLockedCoinsRequest): Promise<GetLockedCoinsResponse> {
    const data = GetLockedCoinsRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetLockedCoins', data)
    return promise.then((data) => GetLockedCoinsResponse.decode(new Reader(data)))
  }

  GetLockedCoinDetails(request: GetLockedCoinDetailsRequest): Promise<GetLockedCoinDetailsResponse> {
    const data = GetLockedCoinDetailsRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'GetLockedCoinDetails', data)
    return promise.then((data) => GetLockedCoinDetailsResponse.decode(new Reader(data)))
  }

  ListRecipe(request: ListRecipeRequest): Promise<ListRecipeResponse> {
    const data = ListRecipeRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListRecipe', data)
    return promise.then((data) => ListRecipeResponse.decode(new Reader(data)))
  }

  ListRecipeByCookbook(request: ListRecipeByCookbookRequest): Promise<ListRecipeByCookbookResponse> {
    const data = ListRecipeByCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListRecipeByCookbook', data)
    return promise.then((data) => ListRecipeByCookbookResponse.decode(new Reader(data)))
  }

  ListShortenRecipe(request: ListShortenRecipeRequest): Promise<ListShortenRecipeResponse> {
    const data = ListShortenRecipeRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListShortenRecipe', data)
    return promise.then((data) => ListShortenRecipeResponse.decode(new Reader(data)))
  }

  ListShortenRecipeByCookbook(request: ListShortenRecipeByCookbookRequest): Promise<ListShortenRecipeByCookbookResponse> {
    const data = ListShortenRecipeByCookbookRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListShortenRecipeByCookbook', data)
    return promise.then((data) => ListShortenRecipeByCookbookResponse.decode(new Reader(data)))
  }

  ListTrade(request: ListTradeRequest): Promise<ListTradeResponse> {
    const data = ListTradeRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'ListTrade', data)
    return promise.then((data) => ListTradeResponse.decode(new Reader(data)))
  }

  PylonsBalance(request: PylonsBalanceRequest): Promise<PylonsBalanceResponse> {
    const data = PylonsBalanceRequest.encode(request).finish()
    const promise = this.rpc.request('pylons.Query', 'PylonsBalance', data)
    return promise.then((data) => PylonsBalanceResponse.decode(new Reader(data)))
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
