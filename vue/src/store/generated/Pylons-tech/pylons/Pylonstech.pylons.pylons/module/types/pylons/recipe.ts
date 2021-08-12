/* eslint-disable */
import * as Long from 'long'
import { util, configure, Writer, Reader } from 'protobufjs/minimal'
import { Coin } from '../cosmos/base/v1beta1/coin'

export const protobufPackage = 'Pylonstech.pylons.pylons'

/** DoubleInputParam describes the bounds on an item input/output parameter of type float64 */
export interface DoubleInputParam {
  key: string
  /** The minimum legal value of this parameter. */
  minValue: string
  /** The maximum legal value of this parameter. */
  maxValue: string
}

/** LongInputParam describes the bounds on an item input/output parameter of type int64 */
export interface LongInputParam {
  key: string
  /** The minimum legal value of this parameter. */
  minValue: number
  /** The maximum legal value of this parameter. */
  maxValue: number
}

/** StringInputParam describes the bounds on an item input/output parameter of type string */
export interface StringInputParam {
  key: string
  /** The value of the parameter */
  value: string
}

/** ConditionList is a struct for describing ItemInput expression conditions */
export interface ConditionList {
  doubles: DoubleInputParam[]
  longs: LongInputParam[]
  strings: StringInputParam[]
}

/** ItemInput is a struct for describing an input item */
export interface ItemInput {
  ID: string
  doubles: DoubleInputParam[]
  longs: LongInputParam[]
  strings: StringInputParam[]
  conditions: ConditionList | undefined
}

/** DoubleWeightRange describes weight range that produce double value */
export interface DoubleWeightRange {
  lower: string
  upper: string
  weight: number
}

/** DoubleParam describes the bounds on an item input/output parameter of type float64 */
export interface DoubleParam {
  key: string
  /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
  rate: string
  weightRanges: DoubleWeightRange[]
  /** When program is not empty, weightRanges is ignored */
  program: string
}

/** IntWeightRange describes weight range that produce int value */
export interface IntWeightRange {
  lower: number
  upper: number
  weight: number
}

/** LongParam describes the bounds on an item input/output parameter of type int64 */
export interface LongParam {
  key: string
  /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
  rate: string
  weightRanges: IntWeightRange[]
  /** When program is not empty, weightRanges is ignored */
  program: string
}

/** StringParam describes an item input/output parameter of type string */
export interface StringParam {
  key: string
  /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
  rate: string
  value: string
  /** When program is not empty, value is ignored */
  program: string
}

/** CoinOutput models the continuum of valid outcomes for coin generation in recipes */
export interface CoinOutput {
  ID: string
  coin: Coin | undefined
}

/** ItemOutput models the continuum of valid outcomes for item generation in recipes */
export interface ItemOutput {
  ID: string
  doubles: DoubleParam[]
  longs: LongParam[]
  strings: StringParam[]
  /** defines a list of mutable strings whose value can be customized by the user */
  mutableStrings: StringParam[]
  /** transferFee defines the residual percentage that is sent to the cookbook owner when the item is sold. Between 0.0 (inclusive) and 1.0 (exclusive) */
  transferFee: string
  /** quantity defines the maximum amount of these items that can be created. A 0 value indicates an infinite supply */
  quantity: number
  amountMinted: number
}

/** ItemModifyOutput describes what is modified from item input */
export interface ItemModifyOutput {
  ID: string
  itemInputRef: string
  doubles: DoubleParam[]
  longs: LongParam[]
  strings: StringParam[]
  /** transferFee defines the residual percentage that is sent to the cookbook owner when the item is sold. Between 0.0 (inclusive) and 1.0 (exclusive) */
  transferFee: string
}

/** EntriesList is a struct to keep list of items and coins */
export interface EntriesList {
  coinOutputs: CoinOutput[]
  itemOutputs: ItemOutput[]
  itemModifyOutputs: ItemModifyOutput[]
}

/** WeightedOutputs is to make structs which is using weight to be based on */
export interface WeightedOutputs {
  entryIDs: string[]
  weight: number
}

export interface Recipe {
  cookbookID: string
  ID: string
  nodeVersion: string
  name: string
  description: string
  version: string
  coinInputs: Coin[]
  itemInputs: ItemInput[]
  entries: EntriesList | undefined
  outputs: WeightedOutputs[]
  blockInterval: number
  enabled: boolean
  extraInfo: string
}

const baseDoubleInputParam: object = { key: '', minValue: '', maxValue: '' }

export const DoubleInputParam = {
  encode(message: DoubleInputParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.minValue !== '') {
      writer.uint32(18).string(message.minValue)
    }
    if (message.maxValue !== '') {
      writer.uint32(26).string(message.maxValue)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): DoubleInputParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseDoubleInputParam } as DoubleInputParam
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.minValue = reader.string()
          break
        case 3:
          message.maxValue = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): DoubleInputParam {
    const message = { ...baseDoubleInputParam } as DoubleInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.minValue !== undefined && object.minValue !== null) {
      message.minValue = String(object.minValue)
    } else {
      message.minValue = ''
    }
    if (object.maxValue !== undefined && object.maxValue !== null) {
      message.maxValue = String(object.maxValue)
    } else {
      message.maxValue = ''
    }
    return message
  },

  toJSON(message: DoubleInputParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.minValue !== undefined && (obj.minValue = message.minValue)
    message.maxValue !== undefined && (obj.maxValue = message.maxValue)
    return obj
  },

  fromPartial(object: DeepPartial<DoubleInputParam>): DoubleInputParam {
    const message = { ...baseDoubleInputParam } as DoubleInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.minValue !== undefined && object.minValue !== null) {
      message.minValue = object.minValue
    } else {
      message.minValue = ''
    }
    if (object.maxValue !== undefined && object.maxValue !== null) {
      message.maxValue = object.maxValue
    } else {
      message.maxValue = ''
    }
    return message
  }
}

const baseLongInputParam: object = { key: '', minValue: 0, maxValue: 0 }

export const LongInputParam = {
  encode(message: LongInputParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.minValue !== 0) {
      writer.uint32(16).int64(message.minValue)
    }
    if (message.maxValue !== 0) {
      writer.uint32(24).int64(message.maxValue)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): LongInputParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseLongInputParam } as LongInputParam
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.minValue = longToNumber(reader.int64() as Long)
          break
        case 3:
          message.maxValue = longToNumber(reader.int64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): LongInputParam {
    const message = { ...baseLongInputParam } as LongInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.minValue !== undefined && object.minValue !== null) {
      message.minValue = Number(object.minValue)
    } else {
      message.minValue = 0
    }
    if (object.maxValue !== undefined && object.maxValue !== null) {
      message.maxValue = Number(object.maxValue)
    } else {
      message.maxValue = 0
    }
    return message
  },

  toJSON(message: LongInputParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.minValue !== undefined && (obj.minValue = message.minValue)
    message.maxValue !== undefined && (obj.maxValue = message.maxValue)
    return obj
  },

  fromPartial(object: DeepPartial<LongInputParam>): LongInputParam {
    const message = { ...baseLongInputParam } as LongInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.minValue !== undefined && object.minValue !== null) {
      message.minValue = object.minValue
    } else {
      message.minValue = 0
    }
    if (object.maxValue !== undefined && object.maxValue !== null) {
      message.maxValue = object.maxValue
    } else {
      message.maxValue = 0
    }
    return message
  }
}

const baseStringInputParam: object = { key: '', value: '' }

export const StringInputParam = {
  encode(message: StringInputParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.value !== '') {
      writer.uint32(18).string(message.value)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): StringInputParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseStringInputParam } as StringInputParam
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.value = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): StringInputParam {
    const message = { ...baseStringInputParam } as StringInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = String(object.value)
    } else {
      message.value = ''
    }
    return message
  },

  toJSON(message: StringInputParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.value !== undefined && (obj.value = message.value)
    return obj
  },

  fromPartial(object: DeepPartial<StringInputParam>): StringInputParam {
    const message = { ...baseStringInputParam } as StringInputParam
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = object.value
    } else {
      message.value = ''
    }
    return message
  }
}

const baseConditionList: object = {}

export const ConditionList = {
  encode(message: ConditionList, writer: Writer = Writer.create()): Writer {
    for (const v of message.doubles) {
      DoubleInputParam.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongInputParam.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringInputParam.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ConditionList {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseConditionList } as ConditionList
    message.doubles = []
    message.longs = []
    message.strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.doubles.push(DoubleInputParam.decode(reader, reader.uint32()))
          break
        case 2:
          message.longs.push(LongInputParam.decode(reader, reader.uint32()))
          break
        case 3:
          message.strings.push(StringInputParam.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ConditionList {
    const message = { ...baseConditionList } as ConditionList
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleInputParam.fromJSON(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongInputParam.fromJSON(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringInputParam.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: ConditionList): unknown {
    const obj: any = {}
    if (message.doubles) {
      obj.doubles = message.doubles.map((e) => (e ? DoubleInputParam.toJSON(e) : undefined))
    } else {
      obj.doubles = []
    }
    if (message.longs) {
      obj.longs = message.longs.map((e) => (e ? LongInputParam.toJSON(e) : undefined))
    } else {
      obj.longs = []
    }
    if (message.strings) {
      obj.strings = message.strings.map((e) => (e ? StringInputParam.toJSON(e) : undefined))
    } else {
      obj.strings = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<ConditionList>): ConditionList {
    const message = { ...baseConditionList } as ConditionList
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleInputParam.fromPartial(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongInputParam.fromPartial(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringInputParam.fromPartial(e))
      }
    }
    return message
  }
}

const baseItemInput: object = { ID: '' }

export const ItemInput = {
  encode(message: ItemInput, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    for (const v of message.doubles) {
      DoubleInputParam.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongInputParam.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringInputParam.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    if (message.conditions !== undefined) {
      ConditionList.encode(message.conditions, writer.uint32(42).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemInput {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemInput } as ItemInput
    message.doubles = []
    message.longs = []
    message.strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        case 2:
          message.doubles.push(DoubleInputParam.decode(reader, reader.uint32()))
          break
        case 3:
          message.longs.push(LongInputParam.decode(reader, reader.uint32()))
          break
        case 4:
          message.strings.push(StringInputParam.decode(reader, reader.uint32()))
          break
        case 5:
          message.conditions = ConditionList.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemInput {
    const message = { ...baseItemInput } as ItemInput
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleInputParam.fromJSON(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongInputParam.fromJSON(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringInputParam.fromJSON(e))
      }
    }
    if (object.conditions !== undefined && object.conditions !== null) {
      message.conditions = ConditionList.fromJSON(object.conditions)
    } else {
      message.conditions = undefined
    }
    return message
  },

  toJSON(message: ItemInput): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.doubles) {
      obj.doubles = message.doubles.map((e) => (e ? DoubleInputParam.toJSON(e) : undefined))
    } else {
      obj.doubles = []
    }
    if (message.longs) {
      obj.longs = message.longs.map((e) => (e ? LongInputParam.toJSON(e) : undefined))
    } else {
      obj.longs = []
    }
    if (message.strings) {
      obj.strings = message.strings.map((e) => (e ? StringInputParam.toJSON(e) : undefined))
    } else {
      obj.strings = []
    }
    message.conditions !== undefined && (obj.conditions = message.conditions ? ConditionList.toJSON(message.conditions) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<ItemInput>): ItemInput {
    const message = { ...baseItemInput } as ItemInput
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleInputParam.fromPartial(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongInputParam.fromPartial(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringInputParam.fromPartial(e))
      }
    }
    if (object.conditions !== undefined && object.conditions !== null) {
      message.conditions = ConditionList.fromPartial(object.conditions)
    } else {
      message.conditions = undefined
    }
    return message
  }
}

const baseDoubleWeightRange: object = { lower: '', upper: '', weight: 0 }

export const DoubleWeightRange = {
  encode(message: DoubleWeightRange, writer: Writer = Writer.create()): Writer {
    if (message.lower !== '') {
      writer.uint32(10).string(message.lower)
    }
    if (message.upper !== '') {
      writer.uint32(18).string(message.upper)
    }
    if (message.weight !== 0) {
      writer.uint32(24).uint64(message.weight)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): DoubleWeightRange {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseDoubleWeightRange } as DoubleWeightRange
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.lower = reader.string()
          break
        case 2:
          message.upper = reader.string()
          break
        case 3:
          message.weight = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): DoubleWeightRange {
    const message = { ...baseDoubleWeightRange } as DoubleWeightRange
    if (object.lower !== undefined && object.lower !== null) {
      message.lower = String(object.lower)
    } else {
      message.lower = ''
    }
    if (object.upper !== undefined && object.upper !== null) {
      message.upper = String(object.upper)
    } else {
      message.upper = ''
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = Number(object.weight)
    } else {
      message.weight = 0
    }
    return message
  },

  toJSON(message: DoubleWeightRange): unknown {
    const obj: any = {}
    message.lower !== undefined && (obj.lower = message.lower)
    message.upper !== undefined && (obj.upper = message.upper)
    message.weight !== undefined && (obj.weight = message.weight)
    return obj
  },

  fromPartial(object: DeepPartial<DoubleWeightRange>): DoubleWeightRange {
    const message = { ...baseDoubleWeightRange } as DoubleWeightRange
    if (object.lower !== undefined && object.lower !== null) {
      message.lower = object.lower
    } else {
      message.lower = ''
    }
    if (object.upper !== undefined && object.upper !== null) {
      message.upper = object.upper
    } else {
      message.upper = ''
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = object.weight
    } else {
      message.weight = 0
    }
    return message
  }
}

const baseDoubleParam: object = { key: '', rate: '', program: '' }

export const DoubleParam = {
  encode(message: DoubleParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.rate !== '') {
      writer.uint32(18).string(message.rate)
    }
    for (const v of message.weightRanges) {
      DoubleWeightRange.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    if (message.program !== '') {
      writer.uint32(34).string(message.program)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): DoubleParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseDoubleParam } as DoubleParam
    message.weightRanges = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.rate = reader.string()
          break
        case 3:
          message.weightRanges.push(DoubleWeightRange.decode(reader, reader.uint32()))
          break
        case 4:
          message.program = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): DoubleParam {
    const message = { ...baseDoubleParam } as DoubleParam
    message.weightRanges = []
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = String(object.rate)
    } else {
      message.rate = ''
    }
    if (object.weightRanges !== undefined && object.weightRanges !== null) {
      for (const e of object.weightRanges) {
        message.weightRanges.push(DoubleWeightRange.fromJSON(e))
      }
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = String(object.program)
    } else {
      message.program = ''
    }
    return message
  },

  toJSON(message: DoubleParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.rate !== undefined && (obj.rate = message.rate)
    if (message.weightRanges) {
      obj.weightRanges = message.weightRanges.map((e) => (e ? DoubleWeightRange.toJSON(e) : undefined))
    } else {
      obj.weightRanges = []
    }
    message.program !== undefined && (obj.program = message.program)
    return obj
  },

  fromPartial(object: DeepPartial<DoubleParam>): DoubleParam {
    const message = { ...baseDoubleParam } as DoubleParam
    message.weightRanges = []
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = object.rate
    } else {
      message.rate = ''
    }
    if (object.weightRanges !== undefined && object.weightRanges !== null) {
      for (const e of object.weightRanges) {
        message.weightRanges.push(DoubleWeightRange.fromPartial(e))
      }
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = object.program
    } else {
      message.program = ''
    }
    return message
  }
}

const baseIntWeightRange: object = { lower: 0, upper: 0, weight: 0 }

export const IntWeightRange = {
  encode(message: IntWeightRange, writer: Writer = Writer.create()): Writer {
    if (message.lower !== 0) {
      writer.uint32(8).int64(message.lower)
    }
    if (message.upper !== 0) {
      writer.uint32(16).int64(message.upper)
    }
    if (message.weight !== 0) {
      writer.uint32(24).uint64(message.weight)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): IntWeightRange {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseIntWeightRange } as IntWeightRange
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.lower = longToNumber(reader.int64() as Long)
          break
        case 2:
          message.upper = longToNumber(reader.int64() as Long)
          break
        case 3:
          message.weight = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): IntWeightRange {
    const message = { ...baseIntWeightRange } as IntWeightRange
    if (object.lower !== undefined && object.lower !== null) {
      message.lower = Number(object.lower)
    } else {
      message.lower = 0
    }
    if (object.upper !== undefined && object.upper !== null) {
      message.upper = Number(object.upper)
    } else {
      message.upper = 0
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = Number(object.weight)
    } else {
      message.weight = 0
    }
    return message
  },

  toJSON(message: IntWeightRange): unknown {
    const obj: any = {}
    message.lower !== undefined && (obj.lower = message.lower)
    message.upper !== undefined && (obj.upper = message.upper)
    message.weight !== undefined && (obj.weight = message.weight)
    return obj
  },

  fromPartial(object: DeepPartial<IntWeightRange>): IntWeightRange {
    const message = { ...baseIntWeightRange } as IntWeightRange
    if (object.lower !== undefined && object.lower !== null) {
      message.lower = object.lower
    } else {
      message.lower = 0
    }
    if (object.upper !== undefined && object.upper !== null) {
      message.upper = object.upper
    } else {
      message.upper = 0
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = object.weight
    } else {
      message.weight = 0
    }
    return message
  }
}

const baseLongParam: object = { key: '', rate: '', program: '' }

export const LongParam = {
  encode(message: LongParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.rate !== '') {
      writer.uint32(18).string(message.rate)
    }
    for (const v of message.weightRanges) {
      IntWeightRange.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    if (message.program !== '') {
      writer.uint32(34).string(message.program)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): LongParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseLongParam } as LongParam
    message.weightRanges = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.rate = reader.string()
          break
        case 3:
          message.weightRanges.push(IntWeightRange.decode(reader, reader.uint32()))
          break
        case 4:
          message.program = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): LongParam {
    const message = { ...baseLongParam } as LongParam
    message.weightRanges = []
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = String(object.rate)
    } else {
      message.rate = ''
    }
    if (object.weightRanges !== undefined && object.weightRanges !== null) {
      for (const e of object.weightRanges) {
        message.weightRanges.push(IntWeightRange.fromJSON(e))
      }
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = String(object.program)
    } else {
      message.program = ''
    }
    return message
  },

  toJSON(message: LongParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.rate !== undefined && (obj.rate = message.rate)
    if (message.weightRanges) {
      obj.weightRanges = message.weightRanges.map((e) => (e ? IntWeightRange.toJSON(e) : undefined))
    } else {
      obj.weightRanges = []
    }
    message.program !== undefined && (obj.program = message.program)
    return obj
  },

  fromPartial(object: DeepPartial<LongParam>): LongParam {
    const message = { ...baseLongParam } as LongParam
    message.weightRanges = []
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = object.rate
    } else {
      message.rate = ''
    }
    if (object.weightRanges !== undefined && object.weightRanges !== null) {
      for (const e of object.weightRanges) {
        message.weightRanges.push(IntWeightRange.fromPartial(e))
      }
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = object.program
    } else {
      message.program = ''
    }
    return message
  }
}

const baseStringParam: object = { key: '', rate: '', value: '', program: '' }

export const StringParam = {
  encode(message: StringParam, writer: Writer = Writer.create()): Writer {
    if (message.key !== '') {
      writer.uint32(10).string(message.key)
    }
    if (message.rate !== '') {
      writer.uint32(18).string(message.rate)
    }
    if (message.value !== '') {
      writer.uint32(26).string(message.value)
    }
    if (message.program !== '') {
      writer.uint32(34).string(message.program)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): StringParam {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseStringParam } as StringParam
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string()
          break
        case 2:
          message.rate = reader.string()
          break
        case 3:
          message.value = reader.string()
          break
        case 4:
          message.program = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): StringParam {
    const message = { ...baseStringParam } as StringParam
    if (object.key !== undefined && object.key !== null) {
      message.key = String(object.key)
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = String(object.rate)
    } else {
      message.rate = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = String(object.value)
    } else {
      message.value = ''
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = String(object.program)
    } else {
      message.program = ''
    }
    return message
  },

  toJSON(message: StringParam): unknown {
    const obj: any = {}
    message.key !== undefined && (obj.key = message.key)
    message.rate !== undefined && (obj.rate = message.rate)
    message.value !== undefined && (obj.value = message.value)
    message.program !== undefined && (obj.program = message.program)
    return obj
  },

  fromPartial(object: DeepPartial<StringParam>): StringParam {
    const message = { ...baseStringParam } as StringParam
    if (object.key !== undefined && object.key !== null) {
      message.key = object.key
    } else {
      message.key = ''
    }
    if (object.rate !== undefined && object.rate !== null) {
      message.rate = object.rate
    } else {
      message.rate = ''
    }
    if (object.value !== undefined && object.value !== null) {
      message.value = object.value
    } else {
      message.value = ''
    }
    if (object.program !== undefined && object.program !== null) {
      message.program = object.program
    } else {
      message.program = ''
    }
    return message
  }
}

const baseCoinOutput: object = { ID: '' }

export const CoinOutput = {
  encode(message: CoinOutput, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    if (message.coin !== undefined) {
      Coin.encode(message.coin, writer.uint32(18).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): CoinOutput {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseCoinOutput } as CoinOutput
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        case 2:
          message.coin = Coin.decode(reader, reader.uint32())
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): CoinOutput {
    const message = { ...baseCoinOutput } as CoinOutput
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.coin !== undefined && object.coin !== null) {
      message.coin = Coin.fromJSON(object.coin)
    } else {
      message.coin = undefined
    }
    return message
  },

  toJSON(message: CoinOutput): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    message.coin !== undefined && (obj.coin = message.coin ? Coin.toJSON(message.coin) : undefined)
    return obj
  },

  fromPartial(object: DeepPartial<CoinOutput>): CoinOutput {
    const message = { ...baseCoinOutput } as CoinOutput
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.coin !== undefined && object.coin !== null) {
      message.coin = Coin.fromPartial(object.coin)
    } else {
      message.coin = undefined
    }
    return message
  }
}

const baseItemOutput: object = { ID: '', transferFee: '', quantity: 0, amountMinted: 0 }

export const ItemOutput = {
  encode(message: ItemOutput, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    for (const v of message.doubles) {
      DoubleParam.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongParam.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringParam.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.mutableStrings) {
      StringParam.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    if (message.transferFee !== '') {
      writer.uint32(50).string(message.transferFee)
    }
    if (message.quantity !== 0) {
      writer.uint32(56).uint64(message.quantity)
    }
    if (message.amountMinted !== 0) {
      writer.uint32(64).uint64(message.amountMinted)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemOutput {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemOutput } as ItemOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        case 2:
          message.doubles.push(DoubleParam.decode(reader, reader.uint32()))
          break
        case 3:
          message.longs.push(LongParam.decode(reader, reader.uint32()))
          break
        case 4:
          message.strings.push(StringParam.decode(reader, reader.uint32()))
          break
        case 5:
          message.mutableStrings.push(StringParam.decode(reader, reader.uint32()))
          break
        case 6:
          message.transferFee = reader.string()
          break
        case 7:
          message.quantity = longToNumber(reader.uint64() as Long)
          break
        case 8:
          message.amountMinted = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemOutput {
    const message = { ...baseItemOutput } as ItemOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleParam.fromJSON(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongParam.fromJSON(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringParam.fromJSON(e))
      }
    }
    if (object.mutableStrings !== undefined && object.mutableStrings !== null) {
      for (const e of object.mutableStrings) {
        message.mutableStrings.push(StringParam.fromJSON(e))
      }
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = String(object.transferFee)
    } else {
      message.transferFee = ''
    }
    if (object.quantity !== undefined && object.quantity !== null) {
      message.quantity = Number(object.quantity)
    } else {
      message.quantity = 0
    }
    if (object.amountMinted !== undefined && object.amountMinted !== null) {
      message.amountMinted = Number(object.amountMinted)
    } else {
      message.amountMinted = 0
    }
    return message
  },

  toJSON(message: ItemOutput): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    if (message.doubles) {
      obj.doubles = message.doubles.map((e) => (e ? DoubleParam.toJSON(e) : undefined))
    } else {
      obj.doubles = []
    }
    if (message.longs) {
      obj.longs = message.longs.map((e) => (e ? LongParam.toJSON(e) : undefined))
    } else {
      obj.longs = []
    }
    if (message.strings) {
      obj.strings = message.strings.map((e) => (e ? StringParam.toJSON(e) : undefined))
    } else {
      obj.strings = []
    }
    if (message.mutableStrings) {
      obj.mutableStrings = message.mutableStrings.map((e) => (e ? StringParam.toJSON(e) : undefined))
    } else {
      obj.mutableStrings = []
    }
    message.transferFee !== undefined && (obj.transferFee = message.transferFee)
    message.quantity !== undefined && (obj.quantity = message.quantity)
    message.amountMinted !== undefined && (obj.amountMinted = message.amountMinted)
    return obj
  },

  fromPartial(object: DeepPartial<ItemOutput>): ItemOutput {
    const message = { ...baseItemOutput } as ItemOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    message.mutableStrings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleParam.fromPartial(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongParam.fromPartial(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringParam.fromPartial(e))
      }
    }
    if (object.mutableStrings !== undefined && object.mutableStrings !== null) {
      for (const e of object.mutableStrings) {
        message.mutableStrings.push(StringParam.fromPartial(e))
      }
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = object.transferFee
    } else {
      message.transferFee = ''
    }
    if (object.quantity !== undefined && object.quantity !== null) {
      message.quantity = object.quantity
    } else {
      message.quantity = 0
    }
    if (object.amountMinted !== undefined && object.amountMinted !== null) {
      message.amountMinted = object.amountMinted
    } else {
      message.amountMinted = 0
    }
    return message
  }
}

const baseItemModifyOutput: object = { ID: '', itemInputRef: '', transferFee: '' }

export const ItemModifyOutput = {
  encode(message: ItemModifyOutput, writer: Writer = Writer.create()): Writer {
    if (message.ID !== '') {
      writer.uint32(10).string(message.ID)
    }
    if (message.itemInputRef !== '') {
      writer.uint32(18).string(message.itemInputRef)
    }
    for (const v of message.doubles) {
      DoubleParam.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    for (const v of message.longs) {
      LongParam.encode(v!, writer.uint32(34).fork()).ldelim()
    }
    for (const v of message.strings) {
      StringParam.encode(v!, writer.uint32(42).fork()).ldelim()
    }
    if (message.transferFee !== '') {
      writer.uint32(50).string(message.transferFee)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): ItemModifyOutput {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseItemModifyOutput } as ItemModifyOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string()
          break
        case 2:
          message.itemInputRef = reader.string()
          break
        case 3:
          message.doubles.push(DoubleParam.decode(reader, reader.uint32()))
          break
        case 4:
          message.longs.push(LongParam.decode(reader, reader.uint32()))
          break
        case 5:
          message.strings.push(StringParam.decode(reader, reader.uint32()))
          break
        case 6:
          message.transferFee = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): ItemModifyOutput {
    const message = { ...baseItemModifyOutput } as ItemModifyOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID)
    } else {
      message.ID = ''
    }
    if (object.itemInputRef !== undefined && object.itemInputRef !== null) {
      message.itemInputRef = String(object.itemInputRef)
    } else {
      message.itemInputRef = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleParam.fromJSON(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongParam.fromJSON(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringParam.fromJSON(e))
      }
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = String(object.transferFee)
    } else {
      message.transferFee = ''
    }
    return message
  },

  toJSON(message: ItemModifyOutput): unknown {
    const obj: any = {}
    message.ID !== undefined && (obj.ID = message.ID)
    message.itemInputRef !== undefined && (obj.itemInputRef = message.itemInputRef)
    if (message.doubles) {
      obj.doubles = message.doubles.map((e) => (e ? DoubleParam.toJSON(e) : undefined))
    } else {
      obj.doubles = []
    }
    if (message.longs) {
      obj.longs = message.longs.map((e) => (e ? LongParam.toJSON(e) : undefined))
    } else {
      obj.longs = []
    }
    if (message.strings) {
      obj.strings = message.strings.map((e) => (e ? StringParam.toJSON(e) : undefined))
    } else {
      obj.strings = []
    }
    message.transferFee !== undefined && (obj.transferFee = message.transferFee)
    return obj
  },

  fromPartial(object: DeepPartial<ItemModifyOutput>): ItemModifyOutput {
    const message = { ...baseItemModifyOutput } as ItemModifyOutput
    message.doubles = []
    message.longs = []
    message.strings = []
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID
    } else {
      message.ID = ''
    }
    if (object.itemInputRef !== undefined && object.itemInputRef !== null) {
      message.itemInputRef = object.itemInputRef
    } else {
      message.itemInputRef = ''
    }
    if (object.doubles !== undefined && object.doubles !== null) {
      for (const e of object.doubles) {
        message.doubles.push(DoubleParam.fromPartial(e))
      }
    }
    if (object.longs !== undefined && object.longs !== null) {
      for (const e of object.longs) {
        message.longs.push(LongParam.fromPartial(e))
      }
    }
    if (object.strings !== undefined && object.strings !== null) {
      for (const e of object.strings) {
        message.strings.push(StringParam.fromPartial(e))
      }
    }
    if (object.transferFee !== undefined && object.transferFee !== null) {
      message.transferFee = object.transferFee
    } else {
      message.transferFee = ''
    }
    return message
  }
}

const baseEntriesList: object = {}

export const EntriesList = {
  encode(message: EntriesList, writer: Writer = Writer.create()): Writer {
    for (const v of message.coinOutputs) {
      CoinOutput.encode(v!, writer.uint32(10).fork()).ldelim()
    }
    for (const v of message.itemOutputs) {
      ItemOutput.encode(v!, writer.uint32(18).fork()).ldelim()
    }
    for (const v of message.itemModifyOutputs) {
      ItemModifyOutput.encode(v!, writer.uint32(26).fork()).ldelim()
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): EntriesList {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseEntriesList } as EntriesList
    message.coinOutputs = []
    message.itemOutputs = []
    message.itemModifyOutputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.coinOutputs.push(CoinOutput.decode(reader, reader.uint32()))
          break
        case 2:
          message.itemOutputs.push(ItemOutput.decode(reader, reader.uint32()))
          break
        case 3:
          message.itemModifyOutputs.push(ItemModifyOutput.decode(reader, reader.uint32()))
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): EntriesList {
    const message = { ...baseEntriesList } as EntriesList
    message.coinOutputs = []
    message.itemOutputs = []
    message.itemModifyOutputs = []
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(CoinOutput.fromJSON(e))
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemOutput.fromJSON(e))
      }
    }
    if (object.itemModifyOutputs !== undefined && object.itemModifyOutputs !== null) {
      for (const e of object.itemModifyOutputs) {
        message.itemModifyOutputs.push(ItemModifyOutput.fromJSON(e))
      }
    }
    return message
  },

  toJSON(message: EntriesList): unknown {
    const obj: any = {}
    if (message.coinOutputs) {
      obj.coinOutputs = message.coinOutputs.map((e) => (e ? CoinOutput.toJSON(e) : undefined))
    } else {
      obj.coinOutputs = []
    }
    if (message.itemOutputs) {
      obj.itemOutputs = message.itemOutputs.map((e) => (e ? ItemOutput.toJSON(e) : undefined))
    } else {
      obj.itemOutputs = []
    }
    if (message.itemModifyOutputs) {
      obj.itemModifyOutputs = message.itemModifyOutputs.map((e) => (e ? ItemModifyOutput.toJSON(e) : undefined))
    } else {
      obj.itemModifyOutputs = []
    }
    return obj
  },

  fromPartial(object: DeepPartial<EntriesList>): EntriesList {
    const message = { ...baseEntriesList } as EntriesList
    message.coinOutputs = []
    message.itemOutputs = []
    message.itemModifyOutputs = []
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(CoinOutput.fromPartial(e))
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemOutput.fromPartial(e))
      }
    }
    if (object.itemModifyOutputs !== undefined && object.itemModifyOutputs !== null) {
      for (const e of object.itemModifyOutputs) {
        message.itemModifyOutputs.push(ItemModifyOutput.fromPartial(e))
      }
    }
    return message
  }
}

const baseWeightedOutputs: object = { entryIDs: '', weight: 0 }

export const WeightedOutputs = {
  encode(message: WeightedOutputs, writer: Writer = Writer.create()): Writer {
    for (const v of message.entryIDs) {
      writer.uint32(10).string(v!)
    }
    if (message.weight !== 0) {
      writer.uint32(16).uint64(message.weight)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): WeightedOutputs {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseWeightedOutputs } as WeightedOutputs
    message.entryIDs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.entryIDs.push(reader.string())
          break
        case 2:
          message.weight = longToNumber(reader.uint64() as Long)
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): WeightedOutputs {
    const message = { ...baseWeightedOutputs } as WeightedOutputs
    message.entryIDs = []
    if (object.entryIDs !== undefined && object.entryIDs !== null) {
      for (const e of object.entryIDs) {
        message.entryIDs.push(String(e))
      }
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = Number(object.weight)
    } else {
      message.weight = 0
    }
    return message
  },

  toJSON(message: WeightedOutputs): unknown {
    const obj: any = {}
    if (message.entryIDs) {
      obj.entryIDs = message.entryIDs.map((e) => e)
    } else {
      obj.entryIDs = []
    }
    message.weight !== undefined && (obj.weight = message.weight)
    return obj
  },

  fromPartial(object: DeepPartial<WeightedOutputs>): WeightedOutputs {
    const message = { ...baseWeightedOutputs } as WeightedOutputs
    message.entryIDs = []
    if (object.entryIDs !== undefined && object.entryIDs !== null) {
      for (const e of object.entryIDs) {
        message.entryIDs.push(e)
      }
    }
    if (object.weight !== undefined && object.weight !== null) {
      message.weight = object.weight
    } else {
      message.weight = 0
    }
    return message
  }
}

const baseRecipe: object = { cookbookID: '', ID: '', nodeVersion: '', name: '', description: '', version: '', blockInterval: 0, enabled: false, extraInfo: '' }

export const Recipe = {
  encode(message: Recipe, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== '') {
      writer.uint32(10).string(message.cookbookID)
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
    if (message.version !== '') {
      writer.uint32(50).string(message.version)
    }
    for (const v of message.coinInputs) {
      Coin.encode(v!, writer.uint32(58).fork()).ldelim()
    }
    for (const v of message.itemInputs) {
      ItemInput.encode(v!, writer.uint32(66).fork()).ldelim()
    }
    if (message.entries !== undefined) {
      EntriesList.encode(message.entries, writer.uint32(74).fork()).ldelim()
    }
    for (const v of message.outputs) {
      WeightedOutputs.encode(v!, writer.uint32(82).fork()).ldelim()
    }
    if (message.blockInterval !== 0) {
      writer.uint32(88).uint64(message.blockInterval)
    }
    if (message.enabled === true) {
      writer.uint32(96).bool(message.enabled)
    }
    if (message.extraInfo !== '') {
      writer.uint32(106).string(message.extraInfo)
    }
    return writer
  },

  decode(input: Reader | Uint8Array, length?: number): Recipe {
    const reader = input instanceof Uint8Array ? new Reader(input) : input
    let end = length === undefined ? reader.len : reader.pos + length
    const message = { ...baseRecipe } as Recipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
    while (reader.pos < end) {
      const tag = reader.uint32()
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string()
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
          message.version = reader.string()
          break
        case 7:
          message.coinInputs.push(Coin.decode(reader, reader.uint32()))
          break
        case 8:
          message.itemInputs.push(ItemInput.decode(reader, reader.uint32()))
          break
        case 9:
          message.entries = EntriesList.decode(reader, reader.uint32())
          break
        case 10:
          message.outputs.push(WeightedOutputs.decode(reader, reader.uint32()))
          break
        case 11:
          message.blockInterval = longToNumber(reader.uint64() as Long)
          break
        case 12:
          message.enabled = reader.bool()
          break
        case 13:
          message.extraInfo = reader.string()
          break
        default:
          reader.skipType(tag & 7)
          break
      }
    }
    return message
  },

  fromJSON(object: any): Recipe {
    const message = { ...baseRecipe } as Recipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID)
    } else {
      message.cookbookID = ''
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
    if (object.version !== undefined && object.version !== null) {
      message.version = String(object.version)
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromJSON(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromJSON(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromJSON(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromJSON(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = Number(object.blockInterval)
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = Boolean(object.enabled)
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = String(object.extraInfo)
    } else {
      message.extraInfo = ''
    }
    return message
  },

  toJSON(message: Recipe): unknown {
    const obj: any = {}
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID)
    message.ID !== undefined && (obj.ID = message.ID)
    message.nodeVersion !== undefined && (obj.nodeVersion = message.nodeVersion)
    message.name !== undefined && (obj.name = message.name)
    message.description !== undefined && (obj.description = message.description)
    message.version !== undefined && (obj.version = message.version)
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined))
    } else {
      obj.coinInputs = []
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined))
    } else {
      obj.itemInputs = []
    }
    message.entries !== undefined && (obj.entries = message.entries ? EntriesList.toJSON(message.entries) : undefined)
    if (message.outputs) {
      obj.outputs = message.outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined))
    } else {
      obj.outputs = []
    }
    message.blockInterval !== undefined && (obj.blockInterval = message.blockInterval)
    message.enabled !== undefined && (obj.enabled = message.enabled)
    message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo)
    return obj
  },

  fromPartial(object: DeepPartial<Recipe>): Recipe {
    const message = { ...baseRecipe } as Recipe
    message.coinInputs = []
    message.itemInputs = []
    message.outputs = []
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID
    } else {
      message.cookbookID = ''
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
    if (object.version !== undefined && object.version !== null) {
      message.version = object.version
    } else {
      message.version = ''
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(Coin.fromPartial(e))
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromPartial(e))
      }
    }
    if (object.entries !== undefined && object.entries !== null) {
      message.entries = EntriesList.fromPartial(object.entries)
    } else {
      message.entries = undefined
    }
    if (object.outputs !== undefined && object.outputs !== null) {
      for (const e of object.outputs) {
        message.outputs.push(WeightedOutputs.fromPartial(e))
      }
    }
    if (object.blockInterval !== undefined && object.blockInterval !== null) {
      message.blockInterval = object.blockInterval
    } else {
      message.blockInterval = 0
    }
    if (object.enabled !== undefined && object.enabled !== null) {
      message.enabled = object.enabled
    } else {
      message.enabled = false
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = object.extraInfo
    } else {
      message.extraInfo = ''
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
