/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal'
import * as Long from 'long'
import { CoinInput, ItemInput, WeightedOutputs, EntriesList, TradeItemInput, Item, DoubleKeyValue, LongKeyValue, StringKeyValue } from '../pylons/pylons'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'pylons'

/** MsgCheckExecution defines a CheckExecution message */
export interface MsgCheckExecution {
  ExecID: string
  Sender: string
  /** if this is set to true then we complete the execution by paying for it */
  PayToComplete: boolean
}

/** CheckExecutionResponse is the response for checkExecution */
export interface MsgCheckExecutionResponse {
  Message: string
  Status: string
  Output: Uint8Array
}

/** MsgCreateAccount defines a CreateAccount message */
export interface MsgCreateAccount {
  Requester: string
}

/** MsgCreateExecutionResponse is the response for create-account */
export interface MsgCreateExecutionResponse {
  Message: string
  Status: string
}

/** Cookbook is a struct that contains all the metadata of a cookbook */
export interface MsgCreateCookbook {
  /** optinal id which can be provided by the developer */
  CookbookID: string
  Name: string
  Description: string
  Version: string
  Developer: string
  SupportEmail: string
  Level: number
  Sender: string
  /** Pylons per block to be charged across this cookbook for delayed execution early completion */
  CostPerBlock: number
}

/** MsgCreateCookbookResponse is a struct of create cookbook response */
export interface MsgCreateCookbookResponse {
  CookbookID: string
  Message: string
  Status: string
}

/** MsgCreateRecipe defines a CreateRecipe message */
export interface MsgCreateRecipe {
  /** optional RecipeID if someone */
  RecipeID: string
  Name: string
  /** the cookbook guid */
  CookbookID: string
  CoinInputs: CoinInput[]
  ItemInputs: ItemInput[]
  Outputs: WeightedOutputs[]
  BlockInterval: number
  Sender: string
  Description: string
  Entries: EntriesList | undefined
  ExtraInfo: string
}

/** MsgCreateRecipeResponse is struct of create recipe response */
export interface MsgCreateRecipeResponse {
  RecipeID: string
  Message: string
  Status: string
}

/** MsgCreateTrade defines a CreateTrade message */
export interface MsgCreateTrade {
  CoinInputs: CoinInput[]
  ItemInputs: TradeItemInput[]
  CoinOutputs: Coin[]
  ItemOutputs: Item[]
  ExtraInfo: string
  Sender: string
}

/** MsgCreateTradeResponse is struct of create trade response */
export interface MsgCreateTradeResponse {
  TradeID: string
  Message: string
  Status: string
}

/** MsgDisableRecipe defines a DisableRecipe message */
export interface MsgDisableRecipe {
  RecipeID: string
  Sender: string
}

/** DisableRecipeResponse is the response for disableRecipe */
export interface MsgDisableRecipeResponse {
  Message: string
  Status: string
}

/** MsgDisableTrade defines a DisableTrade message */
export interface MsgDisableTrade {
  TradeID: string
  Sender: string
}

/** MsgDisableTradeResponse is the response for enableTrade */
export interface MsgDisableTradeResponse {
  Message: string
  Status: string
}

/** MsgEnableRecipe defines a EnableRecipe message */
export interface MsgEnableRecipe {
  RecipeID: string
  Sender: string
}

/** MsgEnableRecipeResponse is the response for enableRecipe */
export interface MsgEnableRecipeResponse {
  Message: string
  Status: string
}

/** MsgEnableTrade defines a EnableTrade message */
export interface MsgEnableTrade {
  TradeID: string
  Sender: string
}

/** MsgEnableTradeResponse is the response for enableTrade */
export interface MsgEnableTradeResponse {
  Message: string
  Status: string
}

/** MsgExecuteRecipe defines a SetName message */
export interface MsgExecuteRecipe {
  RecipeID: string
  Sender: string
  ItemIDs: string[]
}

/** ExecuteRecipeResponse is the response for executeRecipe */
export interface MsgExecuteRecipeResponse {
  Message: string
  Status: string
  Output: Uint8Array
}

/** MsgFiatItem is a msg struct to be used to fiat item */
export interface MsgFiatItem {
  CookbookID: string
  Doubles: DoubleKeyValue[]
  Longs: LongKeyValue[]
  Strings: StringKeyValue[]
  Sender: string
  TransferFee: number
}

/** MsgFiatItemResponse is a struct to control fiat item response */
export interface MsgFiatItemResponse {
  ItemID: string
  Message: string
  Status: string
}

/** MsgFulfillTrade defines a FulfillTrade message */
export interface MsgFulfillTrade {
  TradeID: string
  Sender: string
  ItemIDs: string[]
}

/** FulfillTradeResponse is the response for fulfillRecipe */
export interface MsgFulfillTradeResponse {
  Message: string
  Status: string
}

/** MsgGetPylons defines a GetPylons message */
export interface MsgGetPylons {
  Amount: Coin[]
  Requester: string
}

/** MsgGetPylonsResponse is the response for get-pylons */
export interface MsgGetPylonsResponse {
  Message: string
  Status: string
}

/** MsgGoogleIAPGetPylons defines a GetPylons message */
export interface MsgGoogleIAPGetPylons {
  ProductID: string
  PurchaseToken: string
  ReceiptDataBase64: string
  Signature: string
  Requester: string
}

/** MsgGoogleIAPGetPylonsResponse is the response for get-pylons */
export interface MsgGoogleIAPGetPylonsResponse {
  Message: string
  Status: string
}

/** MsgSendCoins defines a SendCoins message */
export interface MsgSendCoins {
  Amount: Coin[]
  Sender: string
  Receiver: string
}

export interface MsgSendCoinsResponse {}

/** MsgSendItems defines a SendItems message */
export interface MsgSendItems {
  ItemIDs: string[]
  Sender: string
  Receiver: string
}

/** MsgSendItemsResponse is the response for fulfillRecipe */
export interface MsgSendItemsResponse {
  Message: string
  Status: string
}

/** MsgUpdateItemString defines a UpdateItemString message */
export interface MsgUpdateItemString {
  Field: string
  Value: string
  Sender: string
  ItemID: string
}

/** MsgUpdateItemStringResponse is a struct to control update item string response */
export interface MsgUpdateItemStringResponse {
  Status: string
  Message: string
}

/** MsgUpdateCookbook defines a UpdateCookbook message */
export interface MsgUpdateCookbook {
  ID: string
  Description: string
  Version: string
  Developer: string
  SupportEmail: string
  Sender: string
}

/** MsgUpdateCookbookResponse is a struct to control update cookbook response */
export interface MsgUpdateCookbookResponse {
  CookbookID: string
  Message: string
  Status: string
}

/** MsgUpdateRecipe defines a UpdateRecipe message */
export interface MsgUpdateRecipe {
  Name: string
  /** the cookbook guid */
  CookbookID: string
  /** the recipe guid */
  ID: string
  CoinInputs: CoinInput[]
  ItemInputs: ItemInput[]
  Outputs: WeightedOutputs[]
  BlockInterval: number
  Sender: string
  Description: string
  Entries: EntriesList | undefined
}

/** UpdateRecipeResponse is a struct to control update recipe response */
export interface MsgUpdateRecipeResponse {
  RecipeID: string
  Message: string
  Status: string
}

const baseMsgCheckExecution: object = { ExecID: '', Sender: '', PayToComplete: false }

export const MsgCheckExecution = {
  encode(message: MsgCheckExecution, writer: Writer = Writer.create()): Writer {
    if (message.ExecID !== '') {
      writer.uint32(10).string(message.ExecID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    if (message.PayToComplete === true) {
      writer.uint32(24).bool(message.PayToComplete)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCheckExecution {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCheckExecution } as MsgCheckExecution
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ExecID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.PayToComplete = reader.bool()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCheckExecution {
    const message = { ...baseMsgCheckExecution } as MsgCheckExecution
    if (object.ExecID !== undefined && object.ExecID !== null) {
      message.ExecID = String(object.ExecID)
    } else {
      message.ExecID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.PayToComplete !== undefined && object.PayToComplete !== null) {
      message.PayToComplete = Boolean(object.PayToComplete)
    } else {
      message.PayToComplete = false
    }
    return message
  },

  toJSON(message: MsgCheckExecution): unknown {
    const obj: any = {}
    message.ExecID !== undefined && (obj.ExecID = message.ExecID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.PayToComplete !== undefined && (obj.PayToComplete = message.PayToComplete)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCheckExecution>): MsgCheckExecution {
    const message = { ...baseMsgCheckExecution } as MsgCheckExecution
    if (object.ExecID !== undefined && object.ExecID !== null) {
      message.ExecID = object.ExecID
    } else {
      message.ExecID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.PayToComplete !== undefined && object.PayToComplete !== null) {
      message.PayToComplete = object.PayToComplete
    } else {
      message.PayToComplete = false
    }
    return message
  }
}

const baseMsgCheckExecutionResponse: object = { Message: '', Status: '' }

export const MsgCheckExecutionResponse = {
  encode(message: MsgCheckExecutionResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    if (message.Output.length !== 0) {
      writer.uint32(26).bytes(message.Output)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCheckExecutionResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCheckExecutionResponse } as MsgCheckExecutionResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        case 3:
          message.Output = reader.bytes()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCheckExecutionResponse {
    const message = { ...baseMsgCheckExecutionResponse } as MsgCheckExecutionResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    if (object.Output !== undefined && object.Output !== null) {
      message.Output = bytesFromBase64(object.Output)
    }
    return message
  },

  toJSON(message: MsgCheckExecutionResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    message.Output !== undefined && (obj.Output = base64FromBytes(message.Output !== undefined ? message.Output : new Uint8Array()))
    return obj
  },

  fromPartial(object: DeepPartial<MsgCheckExecutionResponse>): MsgCheckExecutionResponse {
    const message = { ...baseMsgCheckExecutionResponse } as MsgCheckExecutionResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    if (object.Output !== undefined && object.Output !== null) {
      message.Output = object.Output
    } else {
      message.Output = new Uint8Array()
    }
    return message
  }
}

const baseMsgCreateAccount: object = { Requester: '' }

export const MsgCreateAccount = {
  encode(message: MsgCreateAccount, writer: Writer = Writer.create()): Writer {
    if (message.Requester !== '') {
      writer.uint32(10).string(message.Requester)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Requester = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateAccount {
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = String(object.Requester)
    } else {
      message.Requester = ''
    }
    return message
  },

  toJSON(message: MsgCreateAccount): unknown {
    const obj: any = {}
    message.Requester !== undefined && (obj.Requester = message.Requester)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateAccount>): MsgCreateAccount {
    const message = { ...baseMsgCreateAccount } as MsgCreateAccount
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = object.Requester
    } else {
      message.Requester = ''
    }
    return message
  }
}

const baseMsgCreateExecutionResponse: object = { Message: '', Status: '' }

export const MsgCreateExecutionResponse = {
  encode(message: MsgCreateExecutionResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateExecutionResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateExecutionResponse } as MsgCreateExecutionResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateExecutionResponse {
    const message = { ...baseMsgCreateExecutionResponse } as MsgCreateExecutionResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgCreateExecutionResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateExecutionResponse>): MsgCreateExecutionResponse {
    const message = { ...baseMsgCreateExecutionResponse } as MsgCreateExecutionResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgCreateCookbook: object = {
  CookbookID: '',
  Name: '',
  Description: '',
  Version: '',
  Developer: '',
  SupportEmail: '',
  Level: 0,
  Sender: '',
  CostPerBlock: 0
}

export const MsgCreateCookbook = {
  encode(message: MsgCreateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.Name !== '') {
      writer.uint32(18).string(message.Name)
    }
    if (message.Description !== '') {
      writer.uint32(26).string(message.Description)
    }
    if (message.Version !== '') {
      writer.uint32(34).string(message.Version)
    }
    if (message.Developer !== '') {
      writer.uint32(42).string(message.Developer)
    }
    if (message.SupportEmail !== '') {
      writer.uint32(50).string(message.SupportEmail)
    }
    if (message.Level !== 0) {
      writer.uint32(56).int64(message.Level)
    }
    if (message.Sender !== '') {
      writer.uint32(66).string(message.Sender)
    }
    if (message.CostPerBlock !== 0) {
      writer.uint32(72).int64(message.CostPerBlock)
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
          message.CookbookID = reader.string()
          break
        case 2:
          message.Name = reader.string()
          break
        case 3:
          message.Description = reader.string()
          break
        case 4:
          message.Version = reader.string()
          break
        case 5:
          message.Developer = reader.string()
          break
        case 6:
          message.SupportEmail = reader.string()
          break
        case 7:
          message.Level = longToNumber(reader.int64() as Long)
          break
        case 8:
          message.Sender = reader.string()
          break
        case 9:
          message.CostPerBlock = longToNumber(reader.int64() as Long)
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
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = String(object.SupportEmail)
    } else {
      message.SupportEmail = ''
    }
    if (object.Level !== undefined && object.Level !== null) {
      message.Level = Number(object.Level)
    } else {
      message.Level = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
      message.CostPerBlock = Number(object.CostPerBlock)
    } else {
      message.CostPerBlock = 0
    }
    return message
  },

  toJSON(message: MsgCreateCookbook): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.Name !== undefined && (obj.Name = message.Name)
    message.Description !== undefined && (obj.Description = message.Description)
    message.Version !== undefined && (obj.Version = message.Version)
    message.Developer !== undefined && (obj.Developer = message.Developer)
    message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail)
    message.Level !== undefined && (obj.Level = message.Level)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.CostPerBlock !== undefined && (obj.CostPerBlock = message.CostPerBlock)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateCookbook>): MsgCreateCookbook {
    const message = { ...baseMsgCreateCookbook } as MsgCreateCookbook
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
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = object.SupportEmail
    } else {
      message.SupportEmail = ''
    }
    if (object.Level !== undefined && object.Level !== null) {
      message.Level = object.Level
    } else {
      message.Level = 0
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
      message.CostPerBlock = object.CostPerBlock
    } else {
      message.CostPerBlock = 0
    }
    return message
  }
}

const baseMsgCreateCookbookResponse: object = { CookbookID: '', Message: '', Status: '' }

export const MsgCreateCookbookResponse = {
  encode(message: MsgCreateCookbookResponse, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateCookbookResponse {
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgCreateCookbookResponse): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateCookbookResponse>): MsgCreateCookbookResponse {
    const message = { ...baseMsgCreateCookbookResponse } as MsgCreateCookbookResponse
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgCreateRecipe: object = { RecipeID: '', Name: '', CookbookID: '', BlockInterval: 0, Sender: '', Description: '', ExtraInfo: '' }

export const MsgCreateRecipe = {
  encode(message: MsgCreateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Name !== '') {
      writer.uint32(18).string(message.Name)
    }
    if (message.CookbookID !== '') {
      writer.uint32(26).string(message.CookbookID)
    }
    for (const v of message.CoinInputs) {
      CoinInput.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      ItemInput.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.Outputs) {
      WeightedOutputs.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    if (message.BlockInterval !== 0) {
      writer.uint32(56).int64(message.BlockInterval)
    }
    if (message.Sender !== '') {
      writer.uint32(66).string(message.Sender)
    }
    if (message.Description !== '') {
      writer.uint32(74).string(message.Description)
    }
    if (message.Entries !== undefined) {
      EntriesList.encode(message.Entries, writer.uint32(82).fork()).ldelim()
    }
    if (message.ExtraInfo !== '') {
      writer.uint32(90).string(message.ExtraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Name = reader.string()
          break
        case 3:
          message.CookbookID = reader.string()
          break
        case 4:
          message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 5:
          message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 6:
          message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 7:
          message.BlockInterval = longToNumber(reader.int64() as Long)
          break
        case 8:
          message.Sender = reader.string()
          break
        case 9:
          message.Description = reader.string()
          break
        case 10:
          message.Entries = EntriesList.decode(reader, reader.uint32())
          break
        case 11:
          message.ExtraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateRecipe {
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = String(object.Name)
    } else {
      message.Name = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
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
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromJSON(e))
      }
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
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = String(object.Description)
    } else {
      message.Description = ''
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromJSON(object.Entries)
    } else {
      message.Entries = undefined
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = String(object.ExtraInfo)
    } else {
      message.ExtraInfo = ''
    }
    return message
  },

  toJSON(message: MsgCreateRecipe): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Name !== undefined && (obj.Name = message.Name)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
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
    if (message.Outputs) {
      obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.Outputs = []
    }
    message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Description !== undefined && (obj.Description = message.Description)
    message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined)
    message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateRecipe>): MsgCreateRecipe {
    const message = { ...baseMsgCreateRecipe } as MsgCreateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = object.Name
    } else {
      message.Name = ''
    }
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
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
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromPartial(e))
      }
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
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = object.Description
    } else {
      message.Description = ''
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromPartial(object.Entries)
    } else {
      message.Entries = undefined
    }
    if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
      message.ExtraInfo = object.ExtraInfo
    } else {
      message.ExtraInfo = ''
    }
    return message
  }
}

const baseMsgCreateRecipeResponse: object = { RecipeID: '', Message: '', Status: '' }

export const MsgCreateRecipeResponse = {
  encode(message: MsgCreateRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateRecipeResponse {
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgCreateRecipeResponse): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateRecipeResponse>): MsgCreateRecipeResponse {
    const message = { ...baseMsgCreateRecipeResponse } as MsgCreateRecipeResponse
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgCreateTrade: object = { ExtraInfo: '', Sender: '' }

export const MsgCreateTrade = {
  encode(message: MsgCreateTrade, writer: Writer = Writer.create()): Writer {
    for (const v of message.CoinInputs) {
      CoinInput.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      TradeItemInput.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.CoinOutputs) {
      Coin.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.ItemOutputs) {
      Item.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    if (message.ExtraInfo !== '') {
      writer.uint32(42).string(message.ExtraInfo)
    }
    if (message.Sender !== '') {
      writer.uint32(50).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 2:
          message.ItemInputs.push(TradeItemInput.decode(reader, reader.uint32()))
          break
        case 3:
          message.CoinOutputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 4:
          message.ItemOutputs.push(Item.decode(reader, reader.uint32()))
          break
        case 5:
          message.ExtraInfo = reader.string()
          break
        case 6:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateTrade {
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
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
    return message
  },

  toJSON(message: MsgCreateTrade): unknown {
    const obj: any = {}
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
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateTrade>): MsgCreateTrade {
    const message = { ...baseMsgCreateTrade } as MsgCreateTrade
    message.CoinInputs = []
    message.ItemInputs = []
    message.CoinOutputs = []
    message.ItemOutputs = []
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
    return message
  }
}

const baseMsgCreateTradeResponse: object = { TradeID: '', Message: '', Status: '' }

export const MsgCreateTradeResponse = {
  encode(message: MsgCreateTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.TradeID !== '') {
      writer.uint32(10).string(message.TradeID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgCreateTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.TradeID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgCreateTradeResponse {
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = String(object.TradeID)
    } else {
      message.TradeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgCreateTradeResponse): unknown {
    const obj: any = {}
    message.TradeID !== undefined && (obj.TradeID = message.TradeID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgCreateTradeResponse>): MsgCreateTradeResponse {
    const message = { ...baseMsgCreateTradeResponse } as MsgCreateTradeResponse
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = object.TradeID
    } else {
      message.TradeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgDisableRecipe: object = { RecipeID: '', Sender: '' }

export const MsgDisableRecipe = {
  encode(message: MsgDisableRecipe, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDisableRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDisableRecipe } as MsgDisableRecipe
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgDisableRecipe {
    const message = { ...baseMsgDisableRecipe } as MsgDisableRecipe
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: MsgDisableRecipe): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<MsgDisableRecipe>): MsgDisableRecipe {
    const message = { ...baseMsgDisableRecipe } as MsgDisableRecipe
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseMsgDisableRecipeResponse: object = { Message: '', Status: '' }

export const MsgDisableRecipeResponse = {
  encode(message: MsgDisableRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDisableRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDisableRecipeResponse } as MsgDisableRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgDisableRecipeResponse {
    const message = { ...baseMsgDisableRecipeResponse } as MsgDisableRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgDisableRecipeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgDisableRecipeResponse>): MsgDisableRecipeResponse {
    const message = { ...baseMsgDisableRecipeResponse } as MsgDisableRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgDisableTrade: object = { TradeID: '', Sender: '' }

export const MsgDisableTrade = {
  encode(message: MsgDisableTrade, writer: Writer = Writer.create()): Writer {
    if (message.TradeID !== '') {
      writer.uint32(10).string(message.TradeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDisableTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDisableTrade } as MsgDisableTrade
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.TradeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgDisableTrade {
    const message = { ...baseMsgDisableTrade } as MsgDisableTrade
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = String(object.TradeID)
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: MsgDisableTrade): unknown {
    const obj: any = {}
    message.TradeID !== undefined && (obj.TradeID = message.TradeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<MsgDisableTrade>): MsgDisableTrade {
    const message = { ...baseMsgDisableTrade } as MsgDisableTrade
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = object.TradeID
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseMsgDisableTradeResponse: object = { Message: '', Status: '' }

export const MsgDisableTradeResponse = {
  encode(message: MsgDisableTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgDisableTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgDisableTradeResponse } as MsgDisableTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgDisableTradeResponse {
    const message = { ...baseMsgDisableTradeResponse } as MsgDisableTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgDisableTradeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgDisableTradeResponse>): MsgDisableTradeResponse {
    const message = { ...baseMsgDisableTradeResponse } as MsgDisableTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgEnableRecipe: object = { RecipeID: '', Sender: '' }

export const MsgEnableRecipe = {
  encode(message: MsgEnableRecipe, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgEnableRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgEnableRecipe } as MsgEnableRecipe
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgEnableRecipe {
    const message = { ...baseMsgEnableRecipe } as MsgEnableRecipe
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: MsgEnableRecipe): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<MsgEnableRecipe>): MsgEnableRecipe {
    const message = { ...baseMsgEnableRecipe } as MsgEnableRecipe
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseMsgEnableRecipeResponse: object = { Message: '', Status: '' }

export const MsgEnableRecipeResponse = {
  encode(message: MsgEnableRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgEnableRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgEnableRecipeResponse } as MsgEnableRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgEnableRecipeResponse {
    const message = { ...baseMsgEnableRecipeResponse } as MsgEnableRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgEnableRecipeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgEnableRecipeResponse>): MsgEnableRecipeResponse {
    const message = { ...baseMsgEnableRecipeResponse } as MsgEnableRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgEnableTrade: object = { TradeID: '', Sender: '' }

export const MsgEnableTrade = {
  encode(message: MsgEnableTrade, writer: Writer = Writer.create()): Writer {
    if (message.TradeID !== '') {
      writer.uint32(10).string(message.TradeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgEnableTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgEnableTrade } as MsgEnableTrade
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.TradeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgEnableTrade {
    const message = { ...baseMsgEnableTrade } as MsgEnableTrade
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = String(object.TradeID)
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: MsgEnableTrade): unknown {
    const obj: any = {}
    message.TradeID !== undefined && (obj.TradeID = message.TradeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<MsgEnableTrade>): MsgEnableTrade {
    const message = { ...baseMsgEnableTrade } as MsgEnableTrade
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = object.TradeID
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseMsgEnableTradeResponse: object = { Message: '', Status: '' }

export const MsgEnableTradeResponse = {
  encode(message: MsgEnableTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgEnableTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgEnableTradeResponse } as MsgEnableTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgEnableTradeResponse {
    const message = { ...baseMsgEnableTradeResponse } as MsgEnableTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgEnableTradeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgEnableTradeResponse>): MsgEnableTradeResponse {
    const message = { ...baseMsgEnableTradeResponse } as MsgEnableTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgExecuteRecipe: object = { RecipeID: '', Sender: '', ItemIDs: '' }

export const MsgExecuteRecipe = {
  encode(message: MsgExecuteRecipe, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    for (const v of message.ItemIDs) {
      writer.uint32(26).string(v!)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.ItemIDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.ItemIDs.push(reader.string())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgExecuteRecipe {
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.ItemIDs = []
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(String(e))
      }
    }
    return message
  },

  toJSON(message: MsgExecuteRecipe): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    if (message.ItemIDs) {
      obj.ItemIDs = message.ItemIDs.map((e) => e)
    } else {
      obj.ItemIDs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<MsgExecuteRecipe>): MsgExecuteRecipe {
    const message = { ...baseMsgExecuteRecipe } as MsgExecuteRecipe
    message.ItemIDs = []
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(e)
      }
    }
    return message
  }
}

const baseMsgExecuteRecipeResponse: object = { Message: '', Status: '' }

export const MsgExecuteRecipeResponse = {
  encode(message: MsgExecuteRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    if (message.Output.length !== 0) {
      writer.uint32(26).bytes(message.Output)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        case 3:
          message.Output = reader.bytes()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgExecuteRecipeResponse {
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    if (object.Output !== undefined && object.Output !== null) {
      message.Output = bytesFromBase64(object.Output)
    }
    return message
  },

  toJSON(message: MsgExecuteRecipeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    message.Output !== undefined && (obj.Output = base64FromBytes(message.Output !== undefined ? message.Output : new Uint8Array()))
    return obj
  },

  fromPartial(object: DeepPartial<MsgExecuteRecipeResponse>): MsgExecuteRecipeResponse {
    const message = { ...baseMsgExecuteRecipeResponse } as MsgExecuteRecipeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    if (object.Output !== undefined && object.Output !== null) {
      message.Output = object.Output
    } else {
      message.Output = new Uint8Array()
    }
    return message
  }
}

const baseMsgFiatItem: object = { CookbookID: '', Sender: '', TransferFee: 0 }

export const MsgFiatItem = {
  encode(message: MsgFiatItem, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    for (const v of message.Doubles) {
      DoubleKeyValue.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.Longs) {
      LongKeyValue.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.Strings) {
      StringKeyValue.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    if (message.Sender !== '') {
      writer.uint32(42).string(message.Sender)
    }
    if (message.TransferFee !== 0) {
      writer.uint32(48).int64(message.TransferFee)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFiatItem {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFiatItem } as MsgFiatItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.Doubles.push(DoubleKeyValue.decode(reader, reader.uint32()))
          break
        case 3:
          message.Longs.push(LongKeyValue.decode(reader, reader.uint32()))
          break
        case 4:
          message.Strings.push(StringKeyValue.decode(reader, reader.uint32()))
          break
        case 5:
          message.Sender = reader.string()
          break
        case 6:
          message.TransferFee = longToNumber(reader.int64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgFiatItem {
    const message = { ...baseMsgFiatItem } as MsgFiatItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromJSON(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromJSON(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromJSON(e))
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.TransferFee !== undefined && object.TransferFee !== null) {
      message.TransferFee = Number(object.TransferFee)
    } else {
      message.TransferFee = 0
    }
    return message
  },

  toJSON(message: MsgFiatItem): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    if (message.Doubles) {
      obj.Doubles = message.Doubles.map((e) => (e ? DoubleKeyValue.toJSON(e) : undefined))
    } else {
      obj.Doubles = []
    }
    if (message.Longs) {
      obj.Longs = message.Longs.map((e) => (e ? LongKeyValue.toJSON(e) : undefined))
    } else {
      obj.Longs = []
    }
    if (message.Strings) {
      obj.Strings = message.Strings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined))
    } else {
      obj.Strings = []
    }
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee)
    return obj
  },

  fromPartial(object: DeepPartial<MsgFiatItem>): MsgFiatItem {
    const message = { ...baseMsgFiatItem } as MsgFiatItem
    message.Doubles = []
    message.Longs = []
    message.Strings = []
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.Doubles !== undefined && object.Doubles !== null) {
      for (const e of object.Doubles) {
        message.Doubles.push(DoubleKeyValue.fromPartial(e))
      }
    }
    if (object.Longs !== undefined && object.Longs !== null) {
      for (const e of object.Longs) {
        message.Longs.push(LongKeyValue.fromPartial(e))
      }
    }
    if (object.Strings !== undefined && object.Strings !== null) {
      for (const e of object.Strings) {
        message.Strings.push(StringKeyValue.fromPartial(e))
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.TransferFee !== undefined && object.TransferFee !== null) {
      message.TransferFee = object.TransferFee
    } else {
      message.TransferFee = 0
    }
    return message
  }
}

const baseMsgFiatItemResponse: object = { ItemID: '', Message: '', Status: '' }

export const MsgFiatItemResponse = {
  encode(message: MsgFiatItemResponse, writer: Writer = Writer.create()): Writer {
    if (message.ItemID !== '') {
      writer.uint32(10).string(message.ItemID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFiatItemResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFiatItemResponse } as MsgFiatItemResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ItemID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgFiatItemResponse {
    const message = { ...baseMsgFiatItemResponse } as MsgFiatItemResponse
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = String(object.ItemID)
    } else {
      message.ItemID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgFiatItemResponse): unknown {
    const obj: any = {}
    message.ItemID !== undefined && (obj.ItemID = message.ItemID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgFiatItemResponse>): MsgFiatItemResponse {
    const message = { ...baseMsgFiatItemResponse } as MsgFiatItemResponse
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = object.ItemID
    } else {
      message.ItemID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgFulfillTrade: object = { TradeID: '', Sender: '', ItemIDs: '' }

export const MsgFulfillTrade = {
  encode(message: MsgFulfillTrade, writer: Writer = Writer.create()): Writer {
    if (message.TradeID !== '') {
      writer.uint32(10).string(message.TradeID)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    for (const v of message.ItemIDs) {
      writer.uint32(26).string(v!)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFulfillTrade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.ItemIDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.TradeID = reader.string()
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.ItemIDs.push(reader.string())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgFulfillTrade {
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.ItemIDs = []
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = String(object.TradeID)
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(String(e))
      }
    }
    return message
  },

  toJSON(message: MsgFulfillTrade): unknown {
    const obj: any = {}
    message.TradeID !== undefined && (obj.TradeID = message.TradeID)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    if (message.ItemIDs) {
      obj.ItemIDs = message.ItemIDs.map((e) => e)
    } else {
      obj.ItemIDs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<MsgFulfillTrade>): MsgFulfillTrade {
    const message = { ...baseMsgFulfillTrade } as MsgFulfillTrade
    message.ItemIDs = []
    if (object.TradeID !== undefined && object.TradeID !== null) {
      message.TradeID = object.TradeID
    } else {
      message.TradeID = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(e)
      }
    }
    return message
  }
}

const baseMsgFulfillTradeResponse: object = { Message: '', Status: '' }

export const MsgFulfillTradeResponse = {
  encode(message: MsgFulfillTradeResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgFulfillTradeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgFulfillTradeResponse {
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgFulfillTradeResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgFulfillTradeResponse>): MsgFulfillTradeResponse {
    const message = { ...baseMsgFulfillTradeResponse } as MsgFulfillTradeResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgGetPylons: object = { Requester: '' }

export const MsgGetPylons = {
  encode(message: MsgGetPylons, writer: Writer = Writer.create()): Writer {
    for (const v of message.Amount) {
      Coin.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    if (message.Requester !== '') {
      writer.uint32(18).string(message.Requester)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGetPylons {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGetPylons } as MsgGetPylons
    message.Amount = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Amount.push(Coin.decode(reader, reader.uint32()))
          break
        case 2:
          message.Requester = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgGetPylons {
    const message = { ...baseMsgGetPylons } as MsgGetPylons
    message.Amount = []
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromJSON(e))
      }
    }
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = String(object.Requester)
    } else {
      message.Requester = ''
    }
    return message
  },

  toJSON(message: MsgGetPylons): unknown {
    const obj: any = {}
    if (message.Amount) {
      obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.Amount = []
    }
    message.Requester !== undefined && (obj.Requester = message.Requester)
    return obj
  },

  fromPartial(object: DeepPartial<MsgGetPylons>): MsgGetPylons {
    const message = { ...baseMsgGetPylons } as MsgGetPylons
    message.Amount = []
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromPartial(e))
      }
    }
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = object.Requester
    } else {
      message.Requester = ''
    }
    return message
  }
}

const baseMsgGetPylonsResponse: object = { Message: '', Status: '' }

export const MsgGetPylonsResponse = {
  encode(message: MsgGetPylonsResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGetPylonsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGetPylonsResponse } as MsgGetPylonsResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgGetPylonsResponse {
    const message = { ...baseMsgGetPylonsResponse } as MsgGetPylonsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgGetPylonsResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgGetPylonsResponse>): MsgGetPylonsResponse {
    const message = { ...baseMsgGetPylonsResponse } as MsgGetPylonsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgGoogleIAPGetPylons: object = { ProductID: '', PurchaseToken: '', ReceiptDataBase64: '', Signature: '', Requester: '' }

export const MsgGoogleIAPGetPylons = {
  encode(message: MsgGoogleIAPGetPylons, writer: Writer = Writer.create()): Writer {
    if (message.ProductID !== '') {
      writer.uint32(10).string(message.ProductID)
    }
    if (message.PurchaseToken !== '') {
      writer.uint32(18).string(message.PurchaseToken)
    }
    if (message.ReceiptDataBase64 !== '') {
      writer.uint32(26).string(message.ReceiptDataBase64)
    }
    if (message.Signature !== '') {
      writer.uint32(34).string(message.Signature)
    }
    if (message.Requester !== '') {
      writer.uint32(42).string(message.Requester)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGoogleIAPGetPylons {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGoogleIAPGetPylons } as MsgGoogleIAPGetPylons
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ProductID = reader.string()
          break
        case 2:
          message.PurchaseToken = reader.string()
          break
        case 3:
          message.ReceiptDataBase64 = reader.string()
          break
        case 4:
          message.Signature = reader.string()
          break
        case 5:
          message.Requester = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgGoogleIAPGetPylons {
    const message = { ...baseMsgGoogleIAPGetPylons } as MsgGoogleIAPGetPylons
    if (object.ProductID !== undefined && object.ProductID !== null) {
      message.ProductID = String(object.ProductID)
    } else {
      message.ProductID = ''
    }
    if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
      message.PurchaseToken = String(object.PurchaseToken)
    } else {
      message.PurchaseToken = ''
    }
    if (object.ReceiptDataBase64 !== undefined && object.ReceiptDataBase64 !== null) {
      message.ReceiptDataBase64 = String(object.ReceiptDataBase64)
    } else {
      message.ReceiptDataBase64 = ''
    }
    if (object.Signature !== undefined && object.Signature !== null) {
      message.Signature = String(object.Signature)
    } else {
      message.Signature = ''
    }
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = String(object.Requester)
    } else {
      message.Requester = ''
    }
    return message
  },

  toJSON(message: MsgGoogleIAPGetPylons): unknown {
    const obj: any = {}
    message.ProductID !== undefined && (obj.ProductID = message.ProductID)
    message.PurchaseToken !== undefined && (obj.PurchaseToken = message.PurchaseToken)
    message.ReceiptDataBase64 !== undefined && (obj.ReceiptDataBase64 = message.ReceiptDataBase64)
    message.Signature !== undefined && (obj.Signature = message.Signature)
    message.Requester !== undefined && (obj.Requester = message.Requester)
    return obj
  },

  fromPartial(object: DeepPartial<MsgGoogleIAPGetPylons>): MsgGoogleIAPGetPylons {
    const message = { ...baseMsgGoogleIAPGetPylons } as MsgGoogleIAPGetPylons
    if (object.ProductID !== undefined && object.ProductID !== null) {
      message.ProductID = object.ProductID
    } else {
      message.ProductID = ''
    }
    if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
      message.PurchaseToken = object.PurchaseToken
    } else {
      message.PurchaseToken = ''
    }
    if (object.ReceiptDataBase64 !== undefined && object.ReceiptDataBase64 !== null) {
      message.ReceiptDataBase64 = object.ReceiptDataBase64
    } else {
      message.ReceiptDataBase64 = ''
    }
    if (object.Signature !== undefined && object.Signature !== null) {
      message.Signature = object.Signature
    } else {
      message.Signature = ''
    }
    if (object.Requester !== undefined && object.Requester !== null) {
      message.Requester = object.Requester
    } else {
      message.Requester = ''
    }
    return message
  }
}

const baseMsgGoogleIAPGetPylonsResponse: object = { Message: '', Status: '' }

export const MsgGoogleIAPGetPylonsResponse = {
  encode(message: MsgGoogleIAPGetPylonsResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgGoogleIAPGetPylonsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgGoogleIAPGetPylonsResponse } as MsgGoogleIAPGetPylonsResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgGoogleIAPGetPylonsResponse {
    const message = { ...baseMsgGoogleIAPGetPylonsResponse } as MsgGoogleIAPGetPylonsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgGoogleIAPGetPylonsResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgGoogleIAPGetPylonsResponse>): MsgGoogleIAPGetPylonsResponse {
    const message = { ...baseMsgGoogleIAPGetPylonsResponse } as MsgGoogleIAPGetPylonsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgSendCoins: object = { Sender: '', Receiver: '' }

export const MsgSendCoins = {
  encode(message: MsgSendCoins, writer: Writer = Writer.create()): Writer {
    for (const v of message.Amount) {
      Coin.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    if (message.Receiver !== '') {
      writer.uint32(26).string(message.Receiver)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendCoins {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendCoins } as MsgSendCoins
    message.Amount = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Amount.push(Coin.decode(reader, reader.uint32()))
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.Receiver = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgSendCoins {
    const message = { ...baseMsgSendCoins } as MsgSendCoins
    message.Amount = []
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromJSON(e))
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.Receiver !== undefined && object.Receiver !== null) {
      message.Receiver = String(object.Receiver)
    } else {
      message.Receiver = ''
    }
    return message
  },

  toJSON(message: MsgSendCoins): unknown {
    const obj: any = {}
    if (message.Amount) {
      obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.Amount = []
    }
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Receiver !== undefined && (obj.Receiver = message.Receiver)
    return obj
  },

  fromPartial(object: DeepPartial<MsgSendCoins>): MsgSendCoins {
    const message = { ...baseMsgSendCoins } as MsgSendCoins
    message.Amount = []
    if (object.Amount !== undefined && object.Amount !== null) {
      for (const e of object.Amount) {
        message.Amount.push(Coin.fromPartial(e))
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.Receiver !== undefined && object.Receiver !== null) {
      message.Receiver = object.Receiver
    } else {
      message.Receiver = ''
    }
    return message
  }
}

const baseMsgSendCoinsResponse: object = {}

export const MsgSendCoinsResponse = {
  encode(_: MsgSendCoinsResponse, writer: Writer = Writer.create()): Writer {
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendCoinsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendCoinsResponse } as MsgSendCoinsResponse
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

  fromJSON(_: any): MsgSendCoinsResponse {
    const message = { ...baseMsgSendCoinsResponse } as MsgSendCoinsResponse
    return message
  },

  toJSON(_: MsgSendCoinsResponse): unknown {
    const obj: any = {}
    return obj
  },

  fromPartial(_: DeepPartial<MsgSendCoinsResponse>): MsgSendCoinsResponse {
    const message = { ...baseMsgSendCoinsResponse } as MsgSendCoinsResponse
    return message
  }
}

const baseMsgSendItems: object = { ItemIDs: '', Sender: '', Receiver: '' }

export const MsgSendItems = {
  encode(message: MsgSendItems, writer: Writer = Writer.create()): Writer {
    for (const v of message.ItemIDs) {
      writer.uint32(10).string(v!)
    }
    if (message.Sender !== '') {
      writer.uint32(18).string(message.Sender)
    }
    if (message.Receiver !== '') {
      writer.uint32(26).string(message.Receiver)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendItems {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.ItemIDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ItemIDs.push(reader.string())
          break
        case 2:
          message.Sender = reader.string()
          break
        case 3:
          message.Receiver = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgSendItems {
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.ItemIDs = []
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(String(e))
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.Receiver !== undefined && object.Receiver !== null) {
      message.Receiver = String(object.Receiver)
    } else {
      message.Receiver = ''
    }
    return message
  },

  toJSON(message: MsgSendItems): unknown {
    const obj: any = {}
    if (message.ItemIDs) {
      obj.ItemIDs = message.ItemIDs.map((e) => e)
    } else {
      obj.ItemIDs = []
    }
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Receiver !== undefined && (obj.Receiver = message.Receiver)
    return obj
  },

  fromPartial(object: DeepPartial<MsgSendItems>): MsgSendItems {
    const message = { ...baseMsgSendItems } as MsgSendItems
    message.ItemIDs = []
    if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
      for (const e of object.ItemIDs) {
        message.ItemIDs.push(e)
      }
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.Receiver !== undefined && object.Receiver !== null) {
      message.Receiver = object.Receiver
    } else {
      message.Receiver = ''
    }
    return message
  }
}

const baseMsgSendItemsResponse: object = { Message: '', Status: '' }

export const MsgSendItemsResponse = {
  encode(message: MsgSendItemsResponse, writer: Writer = Writer.create()): Writer {
    if (message.Message !== '') {
      writer.uint32(10).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(18).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgSendItemsResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Message = reader.string()
          break
        case 2:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgSendItemsResponse {
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgSendItemsResponse): unknown {
    const obj: any = {}
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgSendItemsResponse>): MsgSendItemsResponse {
    const message = { ...baseMsgSendItemsResponse } as MsgSendItemsResponse
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgUpdateItemString: object = { Field: '', Value: '', Sender: '', ItemID: '' }

export const MsgUpdateItemString = {
  encode(message: MsgUpdateItemString, writer: Writer = Writer.create()): Writer {
    if (message.Field !== '') {
      writer.uint32(10).string(message.Field)
    }
    if (message.Value !== '') {
      writer.uint32(18).string(message.Value)
    }
    if (message.Sender !== '') {
      writer.uint32(26).string(message.Sender)
    }
    if (message.ItemID !== '') {
      writer.uint32(34).string(message.ItemID)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemString {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateItemString } as MsgUpdateItemString
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Field = reader.string()
          break
        case 2:
          message.Value = reader.string()
          break
        case 3:
          message.Sender = reader.string()
          break
        case 4:
          message.ItemID = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateItemString {
    const message = { ...baseMsgUpdateItemString } as MsgUpdateItemString
    if (object.Field !== undefined && object.Field !== null) {
      message.Field = String(object.Field)
    } else {
      message.Field = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = String(object.Value)
    } else {
      message.Value = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = String(object.ItemID)
    } else {
      message.ItemID = ''
    }
    return message
  },

  toJSON(message: MsgUpdateItemString): unknown {
    const obj: any = {}
    message.Field !== undefined && (obj.Field = message.Field)
    message.Value !== undefined && (obj.Value = message.Value)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.ItemID !== undefined && (obj.ItemID = message.ItemID)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateItemString>): MsgUpdateItemString {
    const message = { ...baseMsgUpdateItemString } as MsgUpdateItemString
    if (object.Field !== undefined && object.Field !== null) {
      message.Field = object.Field
    } else {
      message.Field = ''
    }
    if (object.Value !== undefined && object.Value !== null) {
      message.Value = object.Value
    } else {
      message.Value = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    if (object.ItemID !== undefined && object.ItemID !== null) {
      message.ItemID = object.ItemID
    } else {
      message.ItemID = ''
    }
    return message
  }
}

const baseMsgUpdateItemStringResponse: object = { Status: '', Message: '' }

export const MsgUpdateItemStringResponse = {
  encode(message: MsgUpdateItemStringResponse, writer: Writer = Writer.create()): Writer {
    if (message.Status !== '') {
      writer.uint32(10).string(message.Status)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemStringResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateItemStringResponse } as MsgUpdateItemStringResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Status = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateItemStringResponse {
    const message = { ...baseMsgUpdateItemStringResponse } as MsgUpdateItemStringResponse
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    return message
  },

  toJSON(message: MsgUpdateItemStringResponse): unknown {
    const obj: any = {}
    message.Status !== undefined && (obj.Status = message.Status)
    message.Message !== undefined && (obj.Message = message.Message)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateItemStringResponse>): MsgUpdateItemStringResponse {
    const message = { ...baseMsgUpdateItemStringResponse } as MsgUpdateItemStringResponse
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    return message
  }
}

const baseMsgUpdateCookbook: object = { ID: '', Description: '', Version: '', Developer: '', SupportEmail: '', Sender: '' }

export const MsgUpdateCookbook = {
  encode(message: MsgUpdateCookbook, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    if (message.Description !== '') {
      writer.uint32(18).string(message.Description)
    }
    if (message.Version !== '') {
      writer.uint32(26).string(message.Version)
    }
    if (message.Developer !== '') {
      writer.uint32(34).string(message.Developer)
    }
    if (message.SupportEmail !== '') {
      writer.uint32(42).string(message.SupportEmail)
    }
    if (message.Sender !== '') {
      writer.uint32(50).string(message.Sender)
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
          message.ID = reader.string()
          break
        case 2:
          message.Description = reader.string()
          break
        case 3:
          message.Version = reader.string()
          break
        case 4:
          message.Developer = reader.string()
          break
        case 5:
          message.SupportEmail = reader.string()
          break
        case 6:
          message.Sender = reader.string()
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
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
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
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = String(object.SupportEmail)
    } else {
      message.SupportEmail = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = String(object.Sender)
    } else {
      message.Sender = ''
    }
    return message
  },

  toJSON(message: MsgUpdateCookbook): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    message.Description !== undefined && (obj.Description = message.Description)
    message.Version !== undefined && (obj.Version = message.Version)
    message.Developer !== undefined && (obj.Developer = message.Developer)
    message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateCookbook>): MsgUpdateCookbook {
    const message = { ...baseMsgUpdateCookbook } as MsgUpdateCookbook
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
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
    if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
      message.SupportEmail = object.SupportEmail
    } else {
      message.SupportEmail = ''
    }
    if (object.Sender !== undefined && object.Sender !== null) {
      message.Sender = object.Sender
    } else {
      message.Sender = ''
    }
    return message
  }
}

const baseMsgUpdateCookbookResponse: object = { CookbookID: '', Message: '', Status: '' }

export const MsgUpdateCookbookResponse = {
  encode(message: MsgUpdateCookbookResponse, writer: Writer = Writer.create()): Writer {
    if (message.CookbookID !== '') {
      writer.uint32(10).string(message.CookbookID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbookResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.CookbookID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateCookbookResponse {
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = String(object.CookbookID)
    } else {
      message.CookbookID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgUpdateCookbookResponse): unknown {
    const obj: any = {}
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateCookbookResponse>): MsgUpdateCookbookResponse {
    const message = { ...baseMsgUpdateCookbookResponse } as MsgUpdateCookbookResponse
    if (object.CookbookID !== undefined && object.CookbookID !== null) {
      message.CookbookID = object.CookbookID
    } else {
      message.CookbookID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

const baseMsgUpdateRecipe: object = { Name: '', CookbookID: '', ID: '', BlockInterval: 0, Sender: '', Description: '' }

export const MsgUpdateRecipe = {
  encode(message: MsgUpdateRecipe, writer: Writer = Writer.create()): Writer {
    if (message.Name !== '') {
      writer.uint32(10).string(message.Name)
    }
    if (message.CookbookID !== '') {
      writer.uint32(18).string(message.CookbookID)
    }
    if (message.ID !== '') {
      writer.uint32(26).string(message.ID)
    }
    for (const v of message.CoinInputs) {
      CoinInput.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.ItemInputs) {
      ItemInput.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    for (const v of message.Outputs) {
      WeightedOutputs.encode(v!, writer.uint32(50).fork()).ldelim()
    }
    if (message.BlockInterval !== 0) {
      writer.uint32(56).int64(message.BlockInterval)
    }
    if (message.Sender !== '') {
      writer.uint32(66).string(message.Sender)
    }
    if (message.Description !== '') {
      writer.uint32(74).string(message.Description)
    }
    if (message.Entries !== undefined) {
      EntriesList.encode(message.Entries, writer.uint32(82).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.Name = reader.string()
          break
        case 2:
          message.CookbookID = reader.string()
          break
        case 3:
          message.ID = reader.string()
          break
        case 4:
          message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()))
          break
        case 5:
          message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 6:
          message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 7:
          message.BlockInterval = longToNumber(reader.int64() as Long)
          break
        case 8:
          message.Sender = reader.string()
          break
        case 9:
          message.Description = reader.string()
          break
        case 10:
          message.Entries = EntriesList.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateRecipe {
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = String(object.Name)
    } else {
      message.Name = ''
    }
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
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromJSON(e))
      }
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
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = String(object.Description)
    } else {
      message.Description = ''
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromJSON(object.Entries)
    } else {
      message.Entries = undefined
    }
    return message
  },

  toJSON(message: MsgUpdateRecipe): unknown {
    const obj: any = {}
    message.Name !== undefined && (obj.Name = message.Name)
    message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
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
    if (message.Outputs) {
      obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.Outputs = []
    }
    message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval)
    message.Sender !== undefined && (obj.Sender = message.Sender)
    message.Description !== undefined && (obj.Description = message.Description)
    message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateRecipe>): MsgUpdateRecipe {
    const message = { ...baseMsgUpdateRecipe } as MsgUpdateRecipe
    message.CoinInputs = []
    message.ItemInputs = []
    message.Outputs = []
    if (object.Name !== undefined && object.Name !== null) {
      message.Name = object.Name
    } else {
      message.Name = ''
    }
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
    if (object.Outputs !== undefined && object.Outputs !== null) {
      for (const e of object.Outputs) {
        message.Outputs.push(WeightedOutputs.fromPartial(e))
      }
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
    if (object.Description !== undefined && object.Description !== null) {
      message.Description = object.Description
    } else {
      message.Description = ''
    }
    if (object.Entries !== undefined && object.Entries !== null) {
      message.Entries = EntriesList.fromPartial(object.Entries)
    } else {
      message.Entries = undefined
    }
    return message
  }
}

const baseMsgUpdateRecipeResponse: object = { RecipeID: '', Message: '', Status: '' }

export const MsgUpdateRecipeResponse = {
  encode(message: MsgUpdateRecipeResponse, writer: Writer = Writer.create()): Writer {
    if (message.RecipeID !== '') {
      writer.uint32(10).string(message.RecipeID)
    }
    if (message.Message !== '') {
      writer.uint32(18).string(message.Message)
    }
    if (message.Status !== '') {
      writer.uint32(26).string(message.Status)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipeResponse {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.RecipeID = reader.string()
          break
        case 2:
          message.Message = reader.string()
          break
        case 3:
          message.Status = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): MsgUpdateRecipeResponse {
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = String(object.RecipeID)
    } else {
      message.RecipeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = String(object.Message)
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status)
    } else {
      message.Status = ''
    }
    return message
  },

  toJSON(message: MsgUpdateRecipeResponse): unknown {
    const obj: any = {}
    message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID)
    message.Message !== undefined && (obj.Message = message.Message)
    message.Status !== undefined && (obj.Status = message.Status)
    return obj
  },

  fromPartial(object: DeepPartial<MsgUpdateRecipeResponse>): MsgUpdateRecipeResponse {
    const message = { ...baseMsgUpdateRecipeResponse } as MsgUpdateRecipeResponse
    if (object.RecipeID !== undefined && object.RecipeID !== null) {
      message.RecipeID = object.RecipeID
    } else {
      message.RecipeID = ''
    }
    if (object.Message !== undefined && object.Message !== null) {
      message.Message = object.Message
    } else {
      message.Message = ''
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status
    } else {
      message.Status = ''
    }
    return message
  }
}

export interface Msg {
  /** CreateAccount is used to send pylons to requesters. This handler is part of the faucet */
  CreateAccount(request: MsgCreateAccount): Promise<MsgCreateExecutionResponse>
  /** GetPylons is used to send pylons to requesters. This handler is part of the faucet */
  GetPylons(request: MsgGetPylons): Promise<MsgGetPylonsResponse>
  /** GoogleIAPGetPylons is used to send pylons to requesters after google iap verification */
  GoogleIAPGetPylons(request: MsgGoogleIAPGetPylons): Promise<MsgGoogleIAPGetPylonsResponse>
  /** SendCoins is used to transact pylons between people */
  SendCoins(request: MsgSendCoins): Promise<MsgSendCoinsResponse>
  /** SendItems is used to send items between people */
  SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse>
  /** CreateCookbook is used to create cookbook by a developer */
  CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>
  /** HandlerMsgUpdateCookbook is used to update cookbook by a developer */
  HandlerMsgUpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>
  /** CreateRecipe is used to create recipe by a developer */
  CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>
  /** HandlerMsgUpdateRecipe is used to update recipe by a developer */
  HandlerMsgUpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>
  /** ExecuteRecipe is used to execute a recipe */
  ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>
  /** DisableRecipe is used to disable recipe by a developer */
  DisableRecipe(request: MsgDisableRecipe): Promise<MsgDisableRecipeResponse>
  /** EnableRecipe is used to enable recipe by a developer */
  EnableRecipe(request: MsgEnableRecipe): Promise<MsgEnableRecipeResponse>
  /** CheckExecution is used to check the status of an execution */
  CheckExecution(request: MsgCheckExecution): Promise<MsgCheckExecutionResponse>
  /** FiatItem is used to create item within 1 block execution */
  FiatItem(request: MsgFiatItem): Promise<MsgFiatItemResponse>
  /** UpdateItemString is used to transact pylons between people */
  UpdateItemString(request: MsgUpdateItemString): Promise<MsgUpdateItemStringResponse>
  /** CreateTrade is used to create a trade by a user */
  CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse>
  /** FulfillTrade is used to fulfill a trade */
  FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse>
  /** DisableTrade is used to enable trade by a developer */
  DisableTrade(request: MsgDisableTrade): Promise<MsgDisableTradeResponse>
  /** EnableTrade is used to enable trade by a developer */
  EnableTrade(request: MsgEnableTrade): Promise<MsgEnableTradeResponse>
}

export class MsgClientImpl implements Msg {
  private readonly rpc: Rpc
  constructor(rpc: Rpc) {
    this.rpc = rpc
  }
  CreateAccount(request: MsgCreateAccount): Promise<MsgCreateExecutionResponse> {
    const data = MsgCreateAccount.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'CreateAccount', data)
    return promise.then((data) => MsgCreateExecutionResponse.decode(new Reader(data)))
  }

  GetPylons(request: MsgGetPylons): Promise<MsgGetPylonsResponse> {
    const data = MsgGetPylons.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'GetPylons', data)
    return promise.then((data) => MsgGetPylonsResponse.decode(new Reader(data)))
  }

  GoogleIAPGetPylons(request: MsgGoogleIAPGetPylons): Promise<MsgGoogleIAPGetPylonsResponse> {
    const data = MsgGoogleIAPGetPylons.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'GoogleIAPGetPylons', data)
    return promise.then((data) => MsgGoogleIAPGetPylonsResponse.decode(new Reader(data)))
  }

  SendCoins(request: MsgSendCoins): Promise<MsgSendCoinsResponse> {
    const data = MsgSendCoins.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'SendCoins', data)
    return promise.then((data) => MsgSendCoinsResponse.decode(new Reader(data)))
  }

  SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse> {
    const data = MsgSendItems.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'SendItems', data)
    return promise.then((data) => MsgSendItemsResponse.decode(new Reader(data)))
  }

  CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse> {
    const data = MsgCreateCookbook.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'CreateCookbook', data)
    return promise.then((data) => MsgCreateCookbookResponse.decode(new Reader(data)))
  }

  HandlerMsgUpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse> {
    const data = MsgUpdateCookbook.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'HandlerMsgUpdateCookbook', data)
    return promise.then((data) => MsgUpdateCookbookResponse.decode(new Reader(data)))
  }

  CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse> {
    const data = MsgCreateRecipe.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'CreateRecipe', data)
    return promise.then((data) => MsgCreateRecipeResponse.decode(new Reader(data)))
  }

  HandlerMsgUpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse> {
    const data = MsgUpdateRecipe.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'HandlerMsgUpdateRecipe', data)
    return promise.then((data) => MsgUpdateRecipeResponse.decode(new Reader(data)))
  }

  ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse> {
    const data = MsgExecuteRecipe.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'ExecuteRecipe', data)
    return promise.then((data) => MsgExecuteRecipeResponse.decode(new Reader(data)))
  }

  DisableRecipe(request: MsgDisableRecipe): Promise<MsgDisableRecipeResponse> {
    const data = MsgDisableRecipe.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'DisableRecipe', data)
    return promise.then((data) => MsgDisableRecipeResponse.decode(new Reader(data)))
  }

  EnableRecipe(request: MsgEnableRecipe): Promise<MsgEnableRecipeResponse> {
    const data = MsgEnableRecipe.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'EnableRecipe', data)
    return promise.then((data) => MsgEnableRecipeResponse.decode(new Reader(data)))
  }

  CheckExecution(request: MsgCheckExecution): Promise<MsgCheckExecutionResponse> {
    const data = MsgCheckExecution.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'CheckExecution', data)
    return promise.then((data) => MsgCheckExecutionResponse.decode(new Reader(data)))
  }

  FiatItem(request: MsgFiatItem): Promise<MsgFiatItemResponse> {
    const data = MsgFiatItem.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'FiatItem', data)
    return promise.then((data) => MsgFiatItemResponse.decode(new Reader(data)))
  }

  UpdateItemString(request: MsgUpdateItemString): Promise<MsgUpdateItemStringResponse> {
    const data = MsgUpdateItemString.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'UpdateItemString', data)
    return promise.then((data) => MsgUpdateItemStringResponse.decode(new Reader(data)))
  }

  CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse> {
    const data = MsgCreateTrade.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'CreateTrade', data)
    return promise.then((data) => MsgCreateTradeResponse.decode(new Reader(data)))
  }

  FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse> {
    const data = MsgFulfillTrade.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'FulfillTrade', data)
    return promise.then((data) => MsgFulfillTradeResponse.decode(new Reader(data)))
  }

  DisableTrade(request: MsgDisableTrade): Promise<MsgDisableTradeResponse> {
    const data = MsgDisableTrade.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'DisableTrade', data)
    return promise.then((data) => MsgDisableTradeResponse.decode(new Reader(data)))
  }

  EnableTrade(request: MsgEnableTrade): Promise<MsgEnableTradeResponse> {
    const data = MsgEnableTrade.encode(request).finish()
    const promise = this.rpc.request('pylons.Msg', 'EnableTrade', data)
    return promise.then((data) => MsgEnableTradeResponse.decode(new Reader(data)))
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

const atob: (b64: string) => string = globalThis.atob || ((b64) => globalThis.Buffer.from(b64, 'base64').toString('binary'))
function bytesFromBase64(b64: string): Uint8Array {
  const bin = atob(b64)
  const arr = new Uint8Array(bin.length)
  for (let i = 0; i < bin.length; ++i) {
    arr[i] = bin.charCodeAt(i)
  }
  return arr
}

const btoa: (bin: string) => string = globalThis.btoa || ((bin) => globalThis.Buffer.from(bin, 'binary').toString('base64'))
function base64FromBytes(arr: Uint8Array): string {
  const bin: string[] = []
  for (let i = 0; i < arr.byteLength; ++i) {
    bin.push(String.fromCharCode(arr[i]))
  }
  return btoa(bin.join(''))
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
