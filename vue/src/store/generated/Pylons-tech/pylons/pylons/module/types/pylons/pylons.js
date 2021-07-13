/* eslint-disable */
import * as Long from 'long';
import { util, configure, Writer, Reader } from 'protobufjs/minimal';
import { Coin } from '../cosmos/base/v1beta1/coin';
export const protobufPackage = 'pylons';
const baseEntriesList = {};
export const EntriesList = {
    encode(message, writer = Writer.create()) {
        for (const v of message.CoinOutputs) {
            CoinOutput.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.ItemOutputs) {
            ItemOutput.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.ItemModifyOutputs) {
            ItemModifyOutput.encode(v, writer.uint32(26).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEntriesList };
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        message.ItemModifyOutputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CoinOutputs.push(CoinOutput.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.ItemOutputs.push(ItemOutput.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.ItemModifyOutputs.push(ItemModifyOutput.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEntriesList };
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        message.ItemModifyOutputs = [];
        if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
            for (const e of object.CoinOutputs) {
                message.CoinOutputs.push(CoinOutput.fromJSON(e));
            }
        }
        if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
            for (const e of object.ItemOutputs) {
                message.ItemOutputs.push(ItemOutput.fromJSON(e));
            }
        }
        if (object.ItemModifyOutputs !== undefined && object.ItemModifyOutputs !== null) {
            for (const e of object.ItemModifyOutputs) {
                message.ItemModifyOutputs.push(ItemModifyOutput.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.CoinOutputs) {
            obj.CoinOutputs = message.CoinOutputs.map((e) => (e ? CoinOutput.toJSON(e) : undefined));
        }
        else {
            obj.CoinOutputs = [];
        }
        if (message.ItemOutputs) {
            obj.ItemOutputs = message.ItemOutputs.map((e) => (e ? ItemOutput.toJSON(e) : undefined));
        }
        else {
            obj.ItemOutputs = [];
        }
        if (message.ItemModifyOutputs) {
            obj.ItemModifyOutputs = message.ItemModifyOutputs.map((e) => (e ? ItemModifyOutput.toJSON(e) : undefined));
        }
        else {
            obj.ItemModifyOutputs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEntriesList };
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        message.ItemModifyOutputs = [];
        if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
            for (const e of object.CoinOutputs) {
                message.CoinOutputs.push(CoinOutput.fromPartial(e));
            }
        }
        if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
            for (const e of object.ItemOutputs) {
                message.ItemOutputs.push(ItemOutput.fromPartial(e));
            }
        }
        if (object.ItemModifyOutputs !== undefined && object.ItemModifyOutputs !== null) {
            for (const e of object.ItemModifyOutputs) {
                message.ItemModifyOutputs.push(ItemModifyOutput.fromPartial(e));
            }
        }
        return message;
    }
};
const baseCoinInput = { Coin: '', Count: 0 };
export const CoinInput = {
    encode(message, writer = Writer.create()) {
        if (message.Coin !== '') {
            writer.uint32(10).string(message.Coin);
        }
        if (message.Count !== 0) {
            writer.uint32(16).int64(message.Count);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCoinInput };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Coin = reader.string();
                    break;
                case 2:
                    message.Count = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCoinInput };
        if (object.Coin !== undefined && object.Coin !== null) {
            message.Coin = String(object.Coin);
        }
        else {
            message.Coin = '';
        }
        if (object.Count !== undefined && object.Count !== null) {
            message.Count = Number(object.Count);
        }
        else {
            message.Count = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Coin !== undefined && (obj.Coin = message.Coin);
        message.Count !== undefined && (obj.Count = message.Count);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCoinInput };
        if (object.Coin !== undefined && object.Coin !== null) {
            message.Coin = object.Coin;
        }
        else {
            message.Coin = '';
        }
        if (object.Count !== undefined && object.Count !== null) {
            message.Count = object.Count;
        }
        else {
            message.Count = 0;
        }
        return message;
    }
};
const baseCoinOutput = { ID: '', Coin: '', Count: '' };
export const CoinOutput = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        if (message.Coin !== '') {
            writer.uint32(18).string(message.Coin);
        }
        if (message.Count !== '') {
            writer.uint32(26).string(message.Count);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCoinOutput };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.Coin = reader.string();
                    break;
                case 3:
                    message.Count = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCoinOutput };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Coin !== undefined && object.Coin !== null) {
            message.Coin = String(object.Coin);
        }
        else {
            message.Coin = '';
        }
        if (object.Count !== undefined && object.Count !== null) {
            message.Count = String(object.Count);
        }
        else {
            message.Count = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        message.Coin !== undefined && (obj.Coin = message.Coin);
        message.Count !== undefined && (obj.Count = message.Count);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCoinOutput };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Coin !== undefined && object.Coin !== null) {
            message.Coin = object.Coin;
        }
        else {
            message.Coin = '';
        }
        if (object.Count !== undefined && object.Count !== null) {
            message.Count = object.Count;
        }
        else {
            message.Count = '';
        }
        return message;
    }
};
const baseDoubleInputParam = { Key: '', MinValue: '', MaxValue: '' };
export const DoubleInputParam = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.MinValue !== '') {
            writer.uint32(18).string(message.MinValue);
        }
        if (message.MaxValue !== '') {
            writer.uint32(26).string(message.MaxValue);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseDoubleInputParam };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.MinValue = reader.string();
                    break;
                case 3:
                    message.MaxValue = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseDoubleInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = String(object.MinValue);
        }
        else {
            message.MinValue = '';
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = String(object.MaxValue);
        }
        else {
            message.MaxValue = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.MinValue !== undefined && (obj.MinValue = message.MinValue);
        message.MaxValue !== undefined && (obj.MaxValue = message.MaxValue);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseDoubleInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = object.MinValue;
        }
        else {
            message.MinValue = '';
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = object.MaxValue;
        }
        else {
            message.MaxValue = '';
        }
        return message;
    }
};
const baseDoubleWeightRange = { Lower: '', Upper: '', Weight: 0 };
export const DoubleWeightRange = {
    encode(message, writer = Writer.create()) {
        if (message.Lower !== '') {
            writer.uint32(10).string(message.Lower);
        }
        if (message.Upper !== '') {
            writer.uint32(18).string(message.Upper);
        }
        if (message.Weight !== 0) {
            writer.uint32(24).int64(message.Weight);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseDoubleWeightRange };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Lower = reader.string();
                    break;
                case 2:
                    message.Upper = reader.string();
                    break;
                case 3:
                    message.Weight = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseDoubleWeightRange };
        if (object.Lower !== undefined && object.Lower !== null) {
            message.Lower = String(object.Lower);
        }
        else {
            message.Lower = '';
        }
        if (object.Upper !== undefined && object.Upper !== null) {
            message.Upper = String(object.Upper);
        }
        else {
            message.Upper = '';
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = Number(object.Weight);
        }
        else {
            message.Weight = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Lower !== undefined && (obj.Lower = message.Lower);
        message.Upper !== undefined && (obj.Upper = message.Upper);
        message.Weight !== undefined && (obj.Weight = message.Weight);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseDoubleWeightRange };
        if (object.Lower !== undefined && object.Lower !== null) {
            message.Lower = object.Lower;
        }
        else {
            message.Lower = '';
        }
        if (object.Upper !== undefined && object.Upper !== null) {
            message.Upper = object.Upper;
        }
        else {
            message.Upper = '';
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = object.Weight;
        }
        else {
            message.Weight = 0;
        }
        return message;
    }
};
const baseLongParam = { Key: '', Rate: '', Program: '' };
export const LongParam = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.Rate !== '') {
            writer.uint32(18).string(message.Rate);
        }
        for (const v of message.WeightRanges) {
            IntWeightRange.encode(v, writer.uint32(26).fork()).ldelim();
        }
        if (message.Program !== '') {
            writer.uint32(34).string(message.Program);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseLongParam };
        message.WeightRanges = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.Rate = reader.string();
                    break;
                case 3:
                    message.WeightRanges.push(IntWeightRange.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Program = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseLongParam };
        message.WeightRanges = [];
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = String(object.Rate);
        }
        else {
            message.Rate = '';
        }
        if (object.WeightRanges !== undefined && object.WeightRanges !== null) {
            for (const e of object.WeightRanges) {
                message.WeightRanges.push(IntWeightRange.fromJSON(e));
            }
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = String(object.Program);
        }
        else {
            message.Program = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.Rate !== undefined && (obj.Rate = message.Rate);
        if (message.WeightRanges) {
            obj.WeightRanges = message.WeightRanges.map((e) => (e ? IntWeightRange.toJSON(e) : undefined));
        }
        else {
            obj.WeightRanges = [];
        }
        message.Program !== undefined && (obj.Program = message.Program);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseLongParam };
        message.WeightRanges = [];
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = object.Rate;
        }
        else {
            message.Rate = '';
        }
        if (object.WeightRanges !== undefined && object.WeightRanges !== null) {
            for (const e of object.WeightRanges) {
                message.WeightRanges.push(IntWeightRange.fromPartial(e));
            }
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = object.Program;
        }
        else {
            message.Program = '';
        }
        return message;
    }
};
const baseIntWeightRange = { Lower: 0, Upper: 0, Weight: 0 };
export const IntWeightRange = {
    encode(message, writer = Writer.create()) {
        if (message.Lower !== 0) {
            writer.uint32(8).int64(message.Lower);
        }
        if (message.Upper !== 0) {
            writer.uint32(16).int64(message.Upper);
        }
        if (message.Weight !== 0) {
            writer.uint32(24).int64(message.Weight);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseIntWeightRange };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Lower = longToNumber(reader.int64());
                    break;
                case 2:
                    message.Upper = longToNumber(reader.int64());
                    break;
                case 3:
                    message.Weight = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseIntWeightRange };
        if (object.Lower !== undefined && object.Lower !== null) {
            message.Lower = Number(object.Lower);
        }
        else {
            message.Lower = 0;
        }
        if (object.Upper !== undefined && object.Upper !== null) {
            message.Upper = Number(object.Upper);
        }
        else {
            message.Upper = 0;
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = Number(object.Weight);
        }
        else {
            message.Weight = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Lower !== undefined && (obj.Lower = message.Lower);
        message.Upper !== undefined && (obj.Upper = message.Upper);
        message.Weight !== undefined && (obj.Weight = message.Weight);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseIntWeightRange };
        if (object.Lower !== undefined && object.Lower !== null) {
            message.Lower = object.Lower;
        }
        else {
            message.Lower = 0;
        }
        if (object.Upper !== undefined && object.Upper !== null) {
            message.Upper = object.Upper;
        }
        else {
            message.Upper = 0;
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = object.Weight;
        }
        else {
            message.Weight = 0;
        }
        return message;
    }
};
const baseStringInputParam = { Key: '', Value: '' };
export const StringInputParam = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.Value !== '') {
            writer.uint32(18).string(message.Value);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseStringInputParam };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.Value = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseStringInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = String(object.Value);
        }
        else {
            message.Value = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.Value !== undefined && (obj.Value = message.Value);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseStringInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = '';
        }
        return message;
    }
};
const baseFeeInputParam = { MinValue: 0, MaxValue: 0 };
export const FeeInputParam = {
    encode(message, writer = Writer.create()) {
        if (message.MinValue !== 0) {
            writer.uint32(8).int64(message.MinValue);
        }
        if (message.MaxValue !== 0) {
            writer.uint32(16).int64(message.MaxValue);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseFeeInputParam };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.MinValue = longToNumber(reader.int64());
                    break;
                case 2:
                    message.MaxValue = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseFeeInputParam };
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = Number(object.MinValue);
        }
        else {
            message.MinValue = 0;
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = Number(object.MaxValue);
        }
        else {
            message.MaxValue = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.MinValue !== undefined && (obj.MinValue = message.MinValue);
        message.MaxValue !== undefined && (obj.MaxValue = message.MaxValue);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseFeeInputParam };
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = object.MinValue;
        }
        else {
            message.MinValue = 0;
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = object.MaxValue;
        }
        else {
            message.MaxValue = 0;
        }
        return message;
    }
};
const baseLongInputParam = { Key: '', MinValue: 0, MaxValue: 0 };
export const LongInputParam = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.MinValue !== 0) {
            writer.uint32(16).int64(message.MinValue);
        }
        if (message.MaxValue !== 0) {
            writer.uint32(24).int64(message.MaxValue);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseLongInputParam };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.MinValue = longToNumber(reader.int64());
                    break;
                case 3:
                    message.MaxValue = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseLongInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = Number(object.MinValue);
        }
        else {
            message.MinValue = 0;
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = Number(object.MaxValue);
        }
        else {
            message.MaxValue = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.MinValue !== undefined && (obj.MinValue = message.MinValue);
        message.MaxValue !== undefined && (obj.MaxValue = message.MaxValue);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseLongInputParam };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.MinValue !== undefined && object.MinValue !== null) {
            message.MinValue = object.MinValue;
        }
        else {
            message.MinValue = 0;
        }
        if (object.MaxValue !== undefined && object.MaxValue !== null) {
            message.MaxValue = object.MaxValue;
        }
        else {
            message.MaxValue = 0;
        }
        return message;
    }
};
const baseConditionList = {};
export const ConditionList = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Doubles) {
            DoubleInputParam.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongInputParam.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringInputParam.encode(v, writer.uint32(26).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseConditionList };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Doubles.push(DoubleInputParam.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.Longs.push(LongInputParam.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.Strings.push(StringInputParam.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseConditionList };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleInputParam.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongInputParam.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringInputParam.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseConditionList };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleInputParam.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongInputParam.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringInputParam.fromPartial(e));
            }
        }
        return message;
    }
};
const baseItemInput = { ID: '' };
export const ItemInput = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        for (const v of message.Doubles) {
            DoubleInputParam.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongInputParam.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringInputParam.encode(v, writer.uint32(34).fork()).ldelim();
        }
        if (message.TransferFee !== undefined) {
            FeeInputParam.encode(message.TransferFee, writer.uint32(42).fork()).ldelim();
        }
        if (message.Conditions !== undefined) {
            ConditionList.encode(message.Conditions, writer.uint32(50).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemInput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.Doubles.push(DoubleInputParam.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.Longs.push(LongInputParam.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Strings.push(StringInputParam.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.TransferFee = FeeInputParam.decode(reader, reader.uint32());
                    break;
                case 6:
                    message.Conditions = ConditionList.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemInput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleInputParam.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongInputParam.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringInputParam.fromJSON(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = FeeInputParam.fromJSON(object.TransferFee);
        }
        else {
            message.TransferFee = undefined;
        }
        if (object.Conditions !== undefined && object.Conditions !== null) {
            message.Conditions = ConditionList.fromJSON(object.Conditions);
        }
        else {
            message.Conditions = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringInputParam.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee ? FeeInputParam.toJSON(message.TransferFee) : undefined);
        message.Conditions !== undefined && (obj.Conditions = message.Conditions ? ConditionList.toJSON(message.Conditions) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemInput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleInputParam.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongInputParam.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringInputParam.fromPartial(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = FeeInputParam.fromPartial(object.TransferFee);
        }
        else {
            message.TransferFee = undefined;
        }
        if (object.Conditions !== undefined && object.Conditions !== null) {
            message.Conditions = ConditionList.fromPartial(object.Conditions);
        }
        else {
            message.Conditions = undefined;
        }
        return message;
    }
};
const baseWeightedOutputs = { EntryIDs: '', Weight: '' };
export const WeightedOutputs = {
    encode(message, writer = Writer.create()) {
        for (const v of message.EntryIDs) {
            writer.uint32(10).string(v);
        }
        if (message.Weight !== '') {
            writer.uint32(18).string(message.Weight);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseWeightedOutputs };
        message.EntryIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.EntryIDs.push(reader.string());
                    break;
                case 2:
                    message.Weight = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseWeightedOutputs };
        message.EntryIDs = [];
        if (object.EntryIDs !== undefined && object.EntryIDs !== null) {
            for (const e of object.EntryIDs) {
                message.EntryIDs.push(String(e));
            }
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = String(object.Weight);
        }
        else {
            message.Weight = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.EntryIDs) {
            obj.EntryIDs = message.EntryIDs.map((e) => e);
        }
        else {
            obj.EntryIDs = [];
        }
        message.Weight !== undefined && (obj.Weight = message.Weight);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseWeightedOutputs };
        message.EntryIDs = [];
        if (object.EntryIDs !== undefined && object.EntryIDs !== null) {
            for (const e of object.EntryIDs) {
                message.EntryIDs.push(e);
            }
        }
        if (object.Weight !== undefined && object.Weight !== null) {
            message.Weight = object.Weight;
        }
        else {
            message.Weight = '';
        }
        return message;
    }
};
const baseStringParam = { Rate: '', Key: '', Value: '', Program: '' };
export const StringParam = {
    encode(message, writer = Writer.create()) {
        if (message.Rate !== '') {
            writer.uint32(10).string(message.Rate);
        }
        if (message.Key !== '') {
            writer.uint32(18).string(message.Key);
        }
        if (message.Value !== '') {
            writer.uint32(26).string(message.Value);
        }
        if (message.Program !== '') {
            writer.uint32(34).string(message.Program);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseStringParam };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Rate = reader.string();
                    break;
                case 2:
                    message.Key = reader.string();
                    break;
                case 3:
                    message.Value = reader.string();
                    break;
                case 4:
                    message.Program = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseStringParam };
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = String(object.Rate);
        }
        else {
            message.Rate = '';
        }
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = String(object.Value);
        }
        else {
            message.Value = '';
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = String(object.Program);
        }
        else {
            message.Program = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Rate !== undefined && (obj.Rate = message.Rate);
        message.Key !== undefined && (obj.Key = message.Key);
        message.Value !== undefined && (obj.Value = message.Value);
        message.Program !== undefined && (obj.Program = message.Program);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseStringParam };
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = object.Rate;
        }
        else {
            message.Rate = '';
        }
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = '';
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = object.Program;
        }
        else {
            message.Program = '';
        }
        return message;
    }
};
const baseDoubleParam = { Rate: '', Key: '', Program: '' };
export const DoubleParam = {
    encode(message, writer = Writer.create()) {
        if (message.Rate !== '') {
            writer.uint32(10).string(message.Rate);
        }
        if (message.Key !== '') {
            writer.uint32(18).string(message.Key);
        }
        for (const v of message.WeightRanges) {
            DoubleWeightRange.encode(v, writer.uint32(26).fork()).ldelim();
        }
        if (message.Program !== '') {
            writer.uint32(34).string(message.Program);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseDoubleParam };
        message.WeightRanges = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Rate = reader.string();
                    break;
                case 2:
                    message.Key = reader.string();
                    break;
                case 3:
                    message.WeightRanges.push(DoubleWeightRange.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Program = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseDoubleParam };
        message.WeightRanges = [];
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = String(object.Rate);
        }
        else {
            message.Rate = '';
        }
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.WeightRanges !== undefined && object.WeightRanges !== null) {
            for (const e of object.WeightRanges) {
                message.WeightRanges.push(DoubleWeightRange.fromJSON(e));
            }
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = String(object.Program);
        }
        else {
            message.Program = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Rate !== undefined && (obj.Rate = message.Rate);
        message.Key !== undefined && (obj.Key = message.Key);
        if (message.WeightRanges) {
            obj.WeightRanges = message.WeightRanges.map((e) => (e ? DoubleWeightRange.toJSON(e) : undefined));
        }
        else {
            obj.WeightRanges = [];
        }
        message.Program !== undefined && (obj.Program = message.Program);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseDoubleParam };
        message.WeightRanges = [];
        if (object.Rate !== undefined && object.Rate !== null) {
            message.Rate = object.Rate;
        }
        else {
            message.Rate = '';
        }
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.WeightRanges !== undefined && object.WeightRanges !== null) {
            for (const e of object.WeightRanges) {
                message.WeightRanges.push(DoubleWeightRange.fromPartial(e));
            }
        }
        if (object.Program !== undefined && object.Program !== null) {
            message.Program = object.Program;
        }
        else {
            message.Program = '';
        }
        return message;
    }
};
const baseItemOutput = { ID: '', TransferFee: 0 };
export const ItemOutput = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        for (const v of message.Doubles) {
            DoubleParam.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongParam.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringParam.encode(v, writer.uint32(34).fork()).ldelim();
        }
        if (message.TransferFee !== 0) {
            writer.uint32(40).int64(message.TransferFee);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.Doubles.push(DoubleParam.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.Longs.push(LongParam.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Strings.push(StringParam.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.TransferFee = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromJSON(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = Number(object.TransferFee);
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleParam.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongParam.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringParam.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromPartial(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = object.TransferFee;
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    }
};
const baseItemModifyOutput = { ID: '', ItemInputRef: '', TransferFee: 0 };
export const ItemModifyOutput = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        if (message.ItemInputRef !== '') {
            writer.uint32(18).string(message.ItemInputRef);
        }
        for (const v of message.Doubles) {
            DoubleParam.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongParam.encode(v, writer.uint32(34).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringParam.encode(v, writer.uint32(42).fork()).ldelim();
        }
        if (message.TransferFee !== 0) {
            writer.uint32(48).int64(message.TransferFee);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemModifyOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.ItemInputRef = reader.string();
                    break;
                case 3:
                    message.Doubles.push(DoubleParam.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Longs.push(LongParam.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.Strings.push(StringParam.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.TransferFee = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemModifyOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.ItemInputRef !== undefined && object.ItemInputRef !== null) {
            message.ItemInputRef = String(object.ItemInputRef);
        }
        else {
            message.ItemInputRef = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromJSON(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = Number(object.TransferFee);
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        message.ItemInputRef !== undefined && (obj.ItemInputRef = message.ItemInputRef);
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleParam.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongParam.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringParam.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemModifyOutput };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.ItemInputRef !== undefined && object.ItemInputRef !== null) {
            message.ItemInputRef = object.ItemInputRef;
        }
        else {
            message.ItemInputRef = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromPartial(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = object.TransferFee;
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    }
};
const baseItemModifyParams = { TransferFee: 0 };
export const ItemModifyParams = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Doubles) {
            DoubleParam.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongParam.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringParam.encode(v, writer.uint32(26).fork()).ldelim();
        }
        if (message.TransferFee !== 0) {
            writer.uint32(32).int64(message.TransferFee);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemModifyParams };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Doubles.push(DoubleParam.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.Longs.push(LongParam.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.Strings.push(StringParam.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.TransferFee = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemModifyParams };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromJSON(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = Number(object.TransferFee);
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleParam.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongParam.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringParam.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemModifyParams };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleParam.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongParam.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringParam.fromPartial(e));
            }
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = object.TransferFee;
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    }
};
const baseItem = {
    NodeVersion: '',
    ID: '',
    CookbookID: '',
    Sender: '',
    OwnerRecipeID: '',
    OwnerTradeID: '',
    Tradable: false,
    LastUpdate: 0,
    TransferFee: 0
};
export const Item = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        for (const v of message.Doubles) {
            DoubleKeyValue.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongKeyValue.encode(v, writer.uint32(34).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringKeyValue.encode(v, writer.uint32(42).fork()).ldelim();
        }
        if (message.CookbookID !== '') {
            writer.uint32(50).string(message.CookbookID);
        }
        if (message.Sender !== '') {
            writer.uint32(58).string(message.Sender);
        }
        if (message.OwnerRecipeID !== '') {
            writer.uint32(66).string(message.OwnerRecipeID);
        }
        if (message.OwnerTradeID !== '') {
            writer.uint32(74).string(message.OwnerTradeID);
        }
        if (message.Tradable === true) {
            writer.uint32(80).bool(message.Tradable);
        }
        if (message.LastUpdate !== 0) {
            writer.uint32(88).int64(message.LastUpdate);
        }
        if (message.TransferFee !== 0) {
            writer.uint32(96).int64(message.TransferFee);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.Doubles.push(DoubleKeyValue.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Longs.push(LongKeyValue.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.Strings.push(StringKeyValue.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.CookbookID = reader.string();
                    break;
                case 7:
                    message.Sender = reader.string();
                    break;
                case 8:
                    message.OwnerRecipeID = reader.string();
                    break;
                case 9:
                    message.OwnerTradeID = reader.string();
                    break;
                case 10:
                    message.Tradable = reader.bool();
                    break;
                case 11:
                    message.LastUpdate = longToNumber(reader.int64());
                    break;
                case 12:
                    message.TransferFee = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleKeyValue.fromJSON(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongKeyValue.fromJSON(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringKeyValue.fromJSON(e));
            }
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.OwnerRecipeID !== undefined && object.OwnerRecipeID !== null) {
            message.OwnerRecipeID = String(object.OwnerRecipeID);
        }
        else {
            message.OwnerRecipeID = '';
        }
        if (object.OwnerTradeID !== undefined && object.OwnerTradeID !== null) {
            message.OwnerTradeID = String(object.OwnerTradeID);
        }
        else {
            message.OwnerTradeID = '';
        }
        if (object.Tradable !== undefined && object.Tradable !== null) {
            message.Tradable = Boolean(object.Tradable);
        }
        else {
            message.Tradable = false;
        }
        if (object.LastUpdate !== undefined && object.LastUpdate !== null) {
            message.LastUpdate = Number(object.LastUpdate);
        }
        else {
            message.LastUpdate = 0;
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = Number(object.TransferFee);
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.ID !== undefined && (obj.ID = message.ID);
        if (message.Doubles) {
            obj.Doubles = message.Doubles.map((e) => (e ? DoubleKeyValue.toJSON(e) : undefined));
        }
        else {
            obj.Doubles = [];
        }
        if (message.Longs) {
            obj.Longs = message.Longs.map((e) => (e ? LongKeyValue.toJSON(e) : undefined));
        }
        else {
            obj.Longs = [];
        }
        if (message.Strings) {
            obj.Strings = message.Strings.map((e) => (e ? StringKeyValue.toJSON(e) : undefined));
        }
        else {
            obj.Strings = [];
        }
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.OwnerRecipeID !== undefined && (obj.OwnerRecipeID = message.OwnerRecipeID);
        message.OwnerTradeID !== undefined && (obj.OwnerTradeID = message.OwnerTradeID);
        message.Tradable !== undefined && (obj.Tradable = message.Tradable);
        message.LastUpdate !== undefined && (obj.LastUpdate = message.LastUpdate);
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Doubles !== undefined && object.Doubles !== null) {
            for (const e of object.Doubles) {
                message.Doubles.push(DoubleKeyValue.fromPartial(e));
            }
        }
        if (object.Longs !== undefined && object.Longs !== null) {
            for (const e of object.Longs) {
                message.Longs.push(LongKeyValue.fromPartial(e));
            }
        }
        if (object.Strings !== undefined && object.Strings !== null) {
            for (const e of object.Strings) {
                message.Strings.push(StringKeyValue.fromPartial(e));
            }
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.OwnerRecipeID !== undefined && object.OwnerRecipeID !== null) {
            message.OwnerRecipeID = object.OwnerRecipeID;
        }
        else {
            message.OwnerRecipeID = '';
        }
        if (object.OwnerTradeID !== undefined && object.OwnerTradeID !== null) {
            message.OwnerTradeID = object.OwnerTradeID;
        }
        else {
            message.OwnerTradeID = '';
        }
        if (object.Tradable !== undefined && object.Tradable !== null) {
            message.Tradable = object.Tradable;
        }
        else {
            message.Tradable = false;
        }
        if (object.LastUpdate !== undefined && object.LastUpdate !== null) {
            message.LastUpdate = object.LastUpdate;
        }
        else {
            message.LastUpdate = 0;
        }
        if (object.TransferFee !== undefined && object.TransferFee !== null) {
            message.TransferFee = object.TransferFee;
        }
        else {
            message.TransferFee = 0;
        }
        return message;
    }
};
const baseDoubleKeyValue = { Key: '', Value: '' };
export const DoubleKeyValue = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.Value !== '') {
            writer.uint32(18).string(message.Value);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseDoubleKeyValue };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.Value = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseDoubleKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = String(object.Value);
        }
        else {
            message.Value = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.Value !== undefined && (obj.Value = message.Value);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseDoubleKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = '';
        }
        return message;
    }
};
const baseLongKeyValue = { Key: '', Value: 0 };
export const LongKeyValue = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.Value !== 0) {
            writer.uint32(16).int64(message.Value);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseLongKeyValue };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.Value = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseLongKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = Number(object.Value);
        }
        else {
            message.Value = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.Value !== undefined && (obj.Value = message.Value);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseLongKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = 0;
        }
        return message;
    }
};
const baseStringKeyValue = { Key: '', Value: '' };
export const StringKeyValue = {
    encode(message, writer = Writer.create()) {
        if (message.Key !== '') {
            writer.uint32(10).string(message.Key);
        }
        if (message.Value !== '') {
            writer.uint32(18).string(message.Value);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseStringKeyValue };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Key = reader.string();
                    break;
                case 2:
                    message.Value = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseStringKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = String(object.Key);
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = String(object.Value);
        }
        else {
            message.Value = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Key !== undefined && (obj.Key = message.Key);
        message.Value !== undefined && (obj.Value = message.Value);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseStringKeyValue };
        if (object.Key !== undefined && object.Key !== null) {
            message.Key = object.Key;
        }
        else {
            message.Key = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = '';
        }
        return message;
    }
};
const baseTradeItemInput = { CookbookID: '' };
export const TradeItemInput = {
    encode(message, writer = Writer.create()) {
        if (message.ItemInput !== undefined) {
            ItemInput.encode(message.ItemInput, writer.uint32(10).fork()).ldelim();
        }
        if (message.CookbookID !== '') {
            writer.uint32(18).string(message.CookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseTradeItemInput };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ItemInput = ItemInput.decode(reader, reader.uint32());
                    break;
                case 2:
                    message.CookbookID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseTradeItemInput };
        if (object.ItemInput !== undefined && object.ItemInput !== null) {
            message.ItemInput = ItemInput.fromJSON(object.ItemInput);
        }
        else {
            message.ItemInput = undefined;
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ItemInput !== undefined && (obj.ItemInput = message.ItemInput ? ItemInput.toJSON(message.ItemInput) : undefined);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseTradeItemInput };
        if (object.ItemInput !== undefined && object.ItemInput !== null) {
            message.ItemInput = ItemInput.fromPartial(object.ItemInput);
        }
        else {
            message.ItemInput = undefined;
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        return message;
    }
};
const baseLockedCoinDescribe = { ID: '' };
export const LockedCoinDescribe = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        for (const v of message.Amount) {
            Coin.encode(v, writer.uint32(18).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseLockedCoinDescribe };
        message.Amount = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.Amount.push(Coin.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseLockedCoinDescribe };
        message.Amount = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        if (message.Amount) {
            obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.Amount = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseLockedCoinDescribe };
        message.Amount = [];
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromPartial(e));
            }
        }
        return message;
    }
};
const baseShortenRecipe = { ID: '', CookbookID: '', Name: '', Description: '', Sender: '' };
export const ShortenRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        if (message.CookbookID !== '') {
            writer.uint32(18).string(message.CookbookID);
        }
        if (message.Name !== '') {
            writer.uint32(26).string(message.Name);
        }
        if (message.Description !== '') {
            writer.uint32(34).string(message.Description);
        }
        if (message.Sender !== '') {
            writer.uint32(42).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseShortenRecipe };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.CookbookID = reader.string();
                    break;
                case 3:
                    message.Name = reader.string();
                    break;
                case 4:
                    message.Description = reader.string();
                    break;
                case 5:
                    message.Sender = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseShortenRecipe };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = String(object.Name);
        }
        else {
            message.Name = '';
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = String(object.Description);
        }
        else {
            message.Description = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Name !== undefined && (obj.Name = message.Name);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseShortenRecipe };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = object.Name;
        }
        else {
            message.Name = '';
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = object.Description;
        }
        else {
            message.Description = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        return message;
    }
};
const baseExecution = { NodeVersion: '', ID: '', RecipeID: '', CookbookID: '', BlockHeight: 0, Sender: '', Completed: false };
export const Execution = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.RecipeID !== '') {
            writer.uint32(26).string(message.RecipeID);
        }
        if (message.CookbookID !== '') {
            writer.uint32(34).string(message.CookbookID);
        }
        for (const v of message.CoinInputs) {
            Coin.encode(v, writer.uint32(42).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            Item.encode(v, writer.uint32(50).fork()).ldelim();
        }
        if (message.BlockHeight !== 0) {
            writer.uint32(56).int64(message.BlockHeight);
        }
        if (message.Sender !== '') {
            writer.uint32(66).string(message.Sender);
        }
        if (message.Completed === true) {
            writer.uint32(72).bool(message.Completed);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseExecution };
        message.CoinInputs = [];
        message.ItemInputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.RecipeID = reader.string();
                    break;
                case 4:
                    message.CookbookID = reader.string();
                    break;
                case 5:
                    message.CoinInputs.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.ItemInputs.push(Item.decode(reader, reader.uint32()));
                    break;
                case 7:
                    message.BlockHeight = longToNumber(reader.int64());
                    break;
                case 8:
                    message.Sender = reader.string();
                    break;
                case 9:
                    message.Completed = reader.bool();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseExecution };
        message.CoinInputs = [];
        message.ItemInputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(Coin.fromJSON(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(Item.fromJSON(e));
            }
        }
        if (object.BlockHeight !== undefined && object.BlockHeight !== null) {
            message.BlockHeight = Number(object.BlockHeight);
        }
        else {
            message.BlockHeight = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.Completed !== undefined && object.Completed !== null) {
            message.Completed = Boolean(object.Completed);
        }
        else {
            message.Completed = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.ID !== undefined && (obj.ID = message.ID);
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        if (message.CoinInputs) {
            obj.CoinInputs = message.CoinInputs.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.CoinInputs = [];
        }
        if (message.ItemInputs) {
            obj.ItemInputs = message.ItemInputs.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.ItemInputs = [];
        }
        message.BlockHeight !== undefined && (obj.BlockHeight = message.BlockHeight);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Completed !== undefined && (obj.Completed = message.Completed);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseExecution };
        message.CoinInputs = [];
        message.ItemInputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(Coin.fromPartial(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(Item.fromPartial(e));
            }
        }
        if (object.BlockHeight !== undefined && object.BlockHeight !== null) {
            message.BlockHeight = object.BlockHeight;
        }
        else {
            message.BlockHeight = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.Completed !== undefined && object.Completed !== null) {
            message.Completed = object.Completed;
        }
        else {
            message.Completed = false;
        }
        return message;
    }
};
const baseCookbook = {
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
};
export const Cookbook = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.Name !== '') {
            writer.uint32(26).string(message.Name);
        }
        if (message.Description !== '') {
            writer.uint32(34).string(message.Description);
        }
        if (message.Version !== '') {
            writer.uint32(42).string(message.Version);
        }
        if (message.Developer !== '') {
            writer.uint32(50).string(message.Developer);
        }
        if (message.Level !== 0) {
            writer.uint32(56).int64(message.Level);
        }
        if (message.SupportEmail !== '') {
            writer.uint32(66).string(message.SupportEmail);
        }
        if (message.CostPerBlock !== 0) {
            writer.uint32(72).int64(message.CostPerBlock);
        }
        if (message.Sender !== '') {
            writer.uint32(82).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.Name = reader.string();
                    break;
                case 4:
                    message.Description = reader.string();
                    break;
                case 5:
                    message.Version = reader.string();
                    break;
                case 6:
                    message.Developer = reader.string();
                    break;
                case 7:
                    message.Level = longToNumber(reader.int64());
                    break;
                case 8:
                    message.SupportEmail = reader.string();
                    break;
                case 9:
                    message.CostPerBlock = longToNumber(reader.int64());
                    break;
                case 10:
                    message.Sender = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCookbook };
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = String(object.Name);
        }
        else {
            message.Name = '';
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = String(object.Description);
        }
        else {
            message.Description = '';
        }
        if (object.Version !== undefined && object.Version !== null) {
            message.Version = String(object.Version);
        }
        else {
            message.Version = '';
        }
        if (object.Developer !== undefined && object.Developer !== null) {
            message.Developer = String(object.Developer);
        }
        else {
            message.Developer = '';
        }
        if (object.Level !== undefined && object.Level !== null) {
            message.Level = Number(object.Level);
        }
        else {
            message.Level = 0;
        }
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = String(object.SupportEmail);
        }
        else {
            message.SupportEmail = '';
        }
        if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
            message.CostPerBlock = Number(object.CostPerBlock);
        }
        else {
            message.CostPerBlock = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.ID !== undefined && (obj.ID = message.ID);
        message.Name !== undefined && (obj.Name = message.Name);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Version !== undefined && (obj.Version = message.Version);
        message.Developer !== undefined && (obj.Developer = message.Developer);
        message.Level !== undefined && (obj.Level = message.Level);
        message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail);
        message.CostPerBlock !== undefined && (obj.CostPerBlock = message.CostPerBlock);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCookbook };
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = object.Name;
        }
        else {
            message.Name = '';
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = object.Description;
        }
        else {
            message.Description = '';
        }
        if (object.Version !== undefined && object.Version !== null) {
            message.Version = object.Version;
        }
        else {
            message.Version = '';
        }
        if (object.Developer !== undefined && object.Developer !== null) {
            message.Developer = object.Developer;
        }
        else {
            message.Developer = '';
        }
        if (object.Level !== undefined && object.Level !== null) {
            message.Level = object.Level;
        }
        else {
            message.Level = 0;
        }
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = object.SupportEmail;
        }
        else {
            message.SupportEmail = '';
        }
        if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
            message.CostPerBlock = object.CostPerBlock;
        }
        else {
            message.CostPerBlock = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        return message;
    }
};
const baseRecipe = { NodeVersion: '', ID: '', CookbookID: '', Name: '', Description: '', BlockInterval: 0, Sender: '', Disabled: false, ExtraInfo: '' };
export const Recipe = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.CookbookID !== '') {
            writer.uint32(26).string(message.CookbookID);
        }
        if (message.Name !== '') {
            writer.uint32(34).string(message.Name);
        }
        for (const v of message.CoinInputs) {
            CoinInput.encode(v, writer.uint32(42).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            ItemInput.encode(v, writer.uint32(50).fork()).ldelim();
        }
        if (message.Entries !== undefined) {
            EntriesList.encode(message.Entries, writer.uint32(58).fork()).ldelim();
        }
        for (const v of message.Outputs) {
            WeightedOutputs.encode(v, writer.uint32(66).fork()).ldelim();
        }
        if (message.Description !== '') {
            writer.uint32(74).string(message.Description);
        }
        if (message.BlockInterval !== 0) {
            writer.uint32(80).int64(message.BlockInterval);
        }
        if (message.Sender !== '') {
            writer.uint32(90).string(message.Sender);
        }
        if (message.Disabled === true) {
            writer.uint32(96).bool(message.Disabled);
        }
        if (message.ExtraInfo !== '') {
            writer.uint32(106).string(message.ExtraInfo);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.CookbookID = reader.string();
                    break;
                case 4:
                    message.Name = reader.string();
                    break;
                case 5:
                    message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()));
                    break;
                case 7:
                    message.Entries = EntriesList.decode(reader, reader.uint32());
                    break;
                case 8:
                    message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()));
                    break;
                case 9:
                    message.Description = reader.string();
                    break;
                case 10:
                    message.BlockInterval = longToNumber(reader.int64());
                    break;
                case 11:
                    message.Sender = reader.string();
                    break;
                case 12:
                    message.Disabled = reader.bool();
                    break;
                case 13:
                    message.ExtraInfo = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = String(object.Name);
        }
        else {
            message.Name = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(CoinInput.fromJSON(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(ItemInput.fromJSON(e));
            }
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromJSON(object.Entries);
        }
        else {
            message.Entries = undefined;
        }
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromJSON(e));
            }
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = String(object.Description);
        }
        else {
            message.Description = '';
        }
        if (object.BlockInterval !== undefined && object.BlockInterval !== null) {
            message.BlockInterval = Number(object.BlockInterval);
        }
        else {
            message.BlockInterval = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.Disabled !== undefined && object.Disabled !== null) {
            message.Disabled = Boolean(object.Disabled);
        }
        else {
            message.Disabled = false;
        }
        if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
            message.ExtraInfo = String(object.ExtraInfo);
        }
        else {
            message.ExtraInfo = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.ID !== undefined && (obj.ID = message.ID);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Name !== undefined && (obj.Name = message.Name);
        if (message.CoinInputs) {
            obj.CoinInputs = message.CoinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined));
        }
        else {
            obj.CoinInputs = [];
        }
        if (message.ItemInputs) {
            obj.ItemInputs = message.ItemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined));
        }
        else {
            obj.ItemInputs = [];
        }
        message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined);
        if (message.Outputs) {
            obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined));
        }
        else {
            obj.Outputs = [];
        }
        message.Description !== undefined && (obj.Description = message.Description);
        message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Disabled !== undefined && (obj.Disabled = message.Disabled);
        message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = object.Name;
        }
        else {
            message.Name = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(CoinInput.fromPartial(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(ItemInput.fromPartial(e));
            }
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromPartial(object.Entries);
        }
        else {
            message.Entries = undefined;
        }
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromPartial(e));
            }
        }
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = object.Description;
        }
        else {
            message.Description = '';
        }
        if (object.BlockInterval !== undefined && object.BlockInterval !== null) {
            message.BlockInterval = object.BlockInterval;
        }
        else {
            message.BlockInterval = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.Disabled !== undefined && object.Disabled !== null) {
            message.Disabled = object.Disabled;
        }
        else {
            message.Disabled = false;
        }
        if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
            message.ExtraInfo = object.ExtraInfo;
        }
        else {
            message.ExtraInfo = '';
        }
        return message;
    }
};
const baseTrade = { NodeVersion: '', ID: '', ExtraInfo: '', Sender: '', FulFiller: '', Disabled: false, Completed: false };
export const Trade = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        for (const v of message.CoinInputs) {
            CoinInput.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            TradeItemInput.encode(v, writer.uint32(34).fork()).ldelim();
        }
        for (const v of message.CoinOutputs) {
            Coin.encode(v, writer.uint32(42).fork()).ldelim();
        }
        for (const v of message.ItemOutputs) {
            Item.encode(v, writer.uint32(50).fork()).ldelim();
        }
        if (message.ExtraInfo !== '') {
            writer.uint32(58).string(message.ExtraInfo);
        }
        if (message.Sender !== '') {
            writer.uint32(66).string(message.Sender);
        }
        if (message.FulFiller !== '') {
            writer.uint32(74).string(message.FulFiller);
        }
        if (message.Disabled === true) {
            writer.uint32(80).bool(message.Disabled);
        }
        if (message.Completed === true) {
            writer.uint32(88).bool(message.Completed);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.ItemInputs.push(TradeItemInput.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.CoinOutputs.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.ItemOutputs.push(Item.decode(reader, reader.uint32()));
                    break;
                case 7:
                    message.ExtraInfo = reader.string();
                    break;
                case 8:
                    message.Sender = reader.string();
                    break;
                case 9:
                    message.FulFiller = reader.string();
                    break;
                case 10:
                    message.Disabled = reader.bool();
                    break;
                case 11:
                    message.Completed = reader.bool();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(CoinInput.fromJSON(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(TradeItemInput.fromJSON(e));
            }
        }
        if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
            for (const e of object.CoinOutputs) {
                message.CoinOutputs.push(Coin.fromJSON(e));
            }
        }
        if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
            for (const e of object.ItemOutputs) {
                message.ItemOutputs.push(Item.fromJSON(e));
            }
        }
        if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
            message.ExtraInfo = String(object.ExtraInfo);
        }
        else {
            message.ExtraInfo = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.FulFiller !== undefined && object.FulFiller !== null) {
            message.FulFiller = String(object.FulFiller);
        }
        else {
            message.FulFiller = '';
        }
        if (object.Disabled !== undefined && object.Disabled !== null) {
            message.Disabled = Boolean(object.Disabled);
        }
        else {
            message.Disabled = false;
        }
        if (object.Completed !== undefined && object.Completed !== null) {
            message.Completed = Boolean(object.Completed);
        }
        else {
            message.Completed = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.ID !== undefined && (obj.ID = message.ID);
        if (message.CoinInputs) {
            obj.CoinInputs = message.CoinInputs.map((e) => (e ? CoinInput.toJSON(e) : undefined));
        }
        else {
            obj.CoinInputs = [];
        }
        if (message.ItemInputs) {
            obj.ItemInputs = message.ItemInputs.map((e) => (e ? TradeItemInput.toJSON(e) : undefined));
        }
        else {
            obj.ItemInputs = [];
        }
        if (message.CoinOutputs) {
            obj.CoinOutputs = message.CoinOutputs.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.CoinOutputs = [];
        }
        if (message.ItemOutputs) {
            obj.ItemOutputs = message.ItemOutputs.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.ItemOutputs = [];
        }
        message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.FulFiller !== undefined && (obj.FulFiller = message.FulFiller);
        message.Disabled !== undefined && (obj.Disabled = message.Disabled);
        message.Completed !== undefined && (obj.Completed = message.Completed);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.CoinInputs !== undefined && object.CoinInputs !== null) {
            for (const e of object.CoinInputs) {
                message.CoinInputs.push(CoinInput.fromPartial(e));
            }
        }
        if (object.ItemInputs !== undefined && object.ItemInputs !== null) {
            for (const e of object.ItemInputs) {
                message.ItemInputs.push(TradeItemInput.fromPartial(e));
            }
        }
        if (object.CoinOutputs !== undefined && object.CoinOutputs !== null) {
            for (const e of object.CoinOutputs) {
                message.CoinOutputs.push(Coin.fromPartial(e));
            }
        }
        if (object.ItemOutputs !== undefined && object.ItemOutputs !== null) {
            for (const e of object.ItemOutputs) {
                message.ItemOutputs.push(Item.fromPartial(e));
            }
        }
        if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
            message.ExtraInfo = object.ExtraInfo;
        }
        else {
            message.ExtraInfo = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.FulFiller !== undefined && object.FulFiller !== null) {
            message.FulFiller = object.FulFiller;
        }
        else {
            message.FulFiller = '';
        }
        if (object.Disabled !== undefined && object.Disabled !== null) {
            message.Disabled = object.Disabled;
        }
        else {
            message.Disabled = false;
        }
        if (object.Completed !== undefined && object.Completed !== null) {
            message.Completed = object.Completed;
        }
        else {
            message.Completed = false;
        }
        return message;
    }
};
var globalThis = (() => {
    if (typeof globalThis !== 'undefined')
        return globalThis;
    if (typeof self !== 'undefined')
        return self;
    if (typeof window !== 'undefined')
        return window;
    if (typeof global !== 'undefined')
        return global;
    throw 'Unable to locate global object';
})();
function longToNumber(long) {
    if (long.gt(Number.MAX_SAFE_INTEGER)) {
        throw new globalThis.Error('Value is larger than Number.MAX_SAFE_INTEGER');
    }
    return long.toNumber();
}
if (util.Long !== Long) {
    util.Long = Long;
    configure();
}
