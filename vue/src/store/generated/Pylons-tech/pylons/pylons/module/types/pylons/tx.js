/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal';
import * as Long from 'long';
import { CoinInput, ItemInput, WeightedOutputs, EntriesList, TradeItemInput, Item, DoubleKeyValue, LongKeyValue, StringKeyValue } from '../pylons/pylons';
import { Coin } from '../cosmos/base/v1beta1/coin';
export const protobufPackage = 'pylons';
const baseMsgCheckExecution = { ExecID: '', Sender: '', PayToComplete: false };
export const MsgCheckExecution = {
    encode(message, writer = Writer.create()) {
        if (message.ExecID !== '') {
            writer.uint32(10).string(message.ExecID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        if (message.PayToComplete === true) {
            writer.uint32(24).bool(message.PayToComplete);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCheckExecution };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ExecID = reader.string();
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
                    message.PayToComplete = reader.bool();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCheckExecution };
        if (object.ExecID !== undefined && object.ExecID !== null) {
            message.ExecID = String(object.ExecID);
        }
        else {
            message.ExecID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.PayToComplete !== undefined && object.PayToComplete !== null) {
            message.PayToComplete = Boolean(object.PayToComplete);
        }
        else {
            message.PayToComplete = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ExecID !== undefined && (obj.ExecID = message.ExecID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.PayToComplete !== undefined && (obj.PayToComplete = message.PayToComplete);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCheckExecution };
        if (object.ExecID !== undefined && object.ExecID !== null) {
            message.ExecID = object.ExecID;
        }
        else {
            message.ExecID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.PayToComplete !== undefined && object.PayToComplete !== null) {
            message.PayToComplete = object.PayToComplete;
        }
        else {
            message.PayToComplete = false;
        }
        return message;
    }
};
const baseMsgCheckExecutionResponse = { Message: '', Status: '' };
export const MsgCheckExecutionResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        if (message.Output.length !== 0) {
            writer.uint32(26).bytes(message.Output);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCheckExecutionResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                case 3:
                    message.Output = reader.bytes();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCheckExecutionResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        if (object.Output !== undefined && object.Output !== null) {
            message.Output = bytesFromBase64(object.Output);
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        message.Output !== undefined && (obj.Output = base64FromBytes(message.Output !== undefined ? message.Output : new Uint8Array()));
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCheckExecutionResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        if (object.Output !== undefined && object.Output !== null) {
            message.Output = object.Output;
        }
        else {
            message.Output = new Uint8Array();
        }
        return message;
    }
};
const baseMsgCreateAccount = { Requester: '' };
export const MsgCreateAccount = {
    encode(message, writer = Writer.create()) {
        if (message.Requester !== '') {
            writer.uint32(10).string(message.Requester);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateAccount };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Requester = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateAccount };
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = String(object.Requester);
        }
        else {
            message.Requester = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Requester !== undefined && (obj.Requester = message.Requester);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateAccount };
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = object.Requester;
        }
        else {
            message.Requester = '';
        }
        return message;
    }
};
const baseMsgCreateExecutionResponse = { Message: '', Status: '' };
export const MsgCreateExecutionResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateExecutionResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateExecutionResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateExecutionResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgCreateCookbook = {
    CookbookID: '',
    Name: '',
    Description: '',
    Version: '',
    Developer: '',
    SupportEmail: '',
    Level: 0,
    Sender: '',
    CostPerBlock: 0
};
export const MsgCreateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.Name !== '') {
            writer.uint32(18).string(message.Name);
        }
        if (message.Description !== '') {
            writer.uint32(26).string(message.Description);
        }
        if (message.Version !== '') {
            writer.uint32(34).string(message.Version);
        }
        if (message.Developer !== '') {
            writer.uint32(42).string(message.Developer);
        }
        if (message.SupportEmail !== '') {
            writer.uint32(50).string(message.SupportEmail);
        }
        if (message.Level !== 0) {
            writer.uint32(56).int64(message.Level);
        }
        if (message.Sender !== '') {
            writer.uint32(66).string(message.Sender);
        }
        if (message.CostPerBlock !== 0) {
            writer.uint32(72).int64(message.CostPerBlock);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
                    message.Name = reader.string();
                    break;
                case 3:
                    message.Description = reader.string();
                    break;
                case 4:
                    message.Version = reader.string();
                    break;
                case 5:
                    message.Developer = reader.string();
                    break;
                case 6:
                    message.SupportEmail = reader.string();
                    break;
                case 7:
                    message.Level = longToNumber(reader.int64());
                    break;
                case 8:
                    message.Sender = reader.string();
                    break;
                case 9:
                    message.CostPerBlock = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateCookbook };
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
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = String(object.SupportEmail);
        }
        else {
            message.SupportEmail = '';
        }
        if (object.Level !== undefined && object.Level !== null) {
            message.Level = Number(object.Level);
        }
        else {
            message.Level = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
            message.CostPerBlock = Number(object.CostPerBlock);
        }
        else {
            message.CostPerBlock = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Name !== undefined && (obj.Name = message.Name);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Version !== undefined && (obj.Version = message.Version);
        message.Developer !== undefined && (obj.Developer = message.Developer);
        message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail);
        message.Level !== undefined && (obj.Level = message.Level);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.CostPerBlock !== undefined && (obj.CostPerBlock = message.CostPerBlock);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateCookbook };
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
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = object.SupportEmail;
        }
        else {
            message.SupportEmail = '';
        }
        if (object.Level !== undefined && object.Level !== null) {
            message.Level = object.Level;
        }
        else {
            message.Level = 0;
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.CostPerBlock !== undefined && object.CostPerBlock !== null) {
            message.CostPerBlock = object.CostPerBlock;
        }
        else {
            message.CostPerBlock = 0;
        }
        return message;
    }
};
const baseMsgCreateCookbookResponse = { CookbookID: '', Message: '', Status: '' };
export const MsgCreateCookbookResponse = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateCookbookResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateCookbookResponse };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateCookbookResponse };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgCreateRecipe = { RecipeID: '', Name: '', CookbookID: '', BlockInterval: 0, Sender: '', Description: '', ExtraInfo: '' };
export const MsgCreateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Name !== '') {
            writer.uint32(18).string(message.Name);
        }
        if (message.CookbookID !== '') {
            writer.uint32(26).string(message.CookbookID);
        }
        for (const v of message.CoinInputs) {
            CoinInput.encode(v, writer.uint32(34).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            ItemInput.encode(v, writer.uint32(42).fork()).ldelim();
        }
        for (const v of message.Outputs) {
            WeightedOutputs.encode(v, writer.uint32(50).fork()).ldelim();
        }
        if (message.BlockInterval !== 0) {
            writer.uint32(56).int64(message.BlockInterval);
        }
        if (message.Sender !== '') {
            writer.uint32(66).string(message.Sender);
        }
        if (message.Description !== '') {
            writer.uint32(74).string(message.Description);
        }
        if (message.Entries !== undefined) {
            EntriesList.encode(message.Entries, writer.uint32(82).fork()).ldelim();
        }
        if (message.ExtraInfo !== '') {
            writer.uint32(90).string(message.ExtraInfo);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
                    message.Name = reader.string();
                    break;
                case 3:
                    message.CookbookID = reader.string();
                    break;
                case 4:
                    message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()));
                    break;
                case 7:
                    message.BlockInterval = longToNumber(reader.int64());
                    break;
                case 8:
                    message.Sender = reader.string();
                    break;
                case 9:
                    message.Description = reader.string();
                    break;
                case 10:
                    message.Entries = EntriesList.decode(reader, reader.uint32());
                    break;
                case 11:
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
        const message = { ...baseMsgCreateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = String(object.Name);
        }
        else {
            message.Name = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
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
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromJSON(e));
            }
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
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = String(object.Description);
        }
        else {
            message.Description = '';
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromJSON(object.Entries);
        }
        else {
            message.Entries = undefined;
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
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Name !== undefined && (obj.Name = message.Name);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
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
        if (message.Outputs) {
            obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined));
        }
        else {
            obj.Outputs = [];
        }
        message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined);
        message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = object.Name;
        }
        else {
            message.Name = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
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
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromPartial(e));
            }
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
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = object.Description;
        }
        else {
            message.Description = '';
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromPartial(object.Entries);
        }
        else {
            message.Entries = undefined;
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
const baseMsgCreateRecipeResponse = { RecipeID: '', Message: '', Status: '' };
export const MsgCreateRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateRecipeResponse };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateRecipeResponse };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgCreateTrade = { ExtraInfo: '', Sender: '' };
export const MsgCreateTrade = {
    encode(message, writer = Writer.create()) {
        for (const v of message.CoinInputs) {
            CoinInput.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            TradeItemInput.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.CoinOutputs) {
            Coin.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.ItemOutputs) {
            Item.encode(v, writer.uint32(34).fork()).ldelim();
        }
        if (message.ExtraInfo !== '') {
            writer.uint32(42).string(message.ExtraInfo);
        }
        if (message.Sender !== '') {
            writer.uint32(50).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.ItemInputs.push(TradeItemInput.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.CoinOutputs.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.ItemOutputs.push(Item.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.ExtraInfo = reader.string();
                    break;
                case 6:
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
        const message = { ...baseMsgCreateTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
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
        return message;
    },
    toJSON(message) {
        const obj = {};
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
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateTrade };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.CoinOutputs = [];
        message.ItemOutputs = [];
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
        return message;
    }
};
const baseMsgCreateTradeResponse = { TradeID: '', Message: '', Status: '' };
export const MsgCreateTradeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.TradeID !== '') {
            writer.uint32(10).string(message.TradeID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateTradeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.TradeID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCreateTradeResponse };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = String(object.TradeID);
        }
        else {
            message.TradeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.TradeID !== undefined && (obj.TradeID = message.TradeID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateTradeResponse };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = object.TradeID;
        }
        else {
            message.TradeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgDisableRecipe = { RecipeID: '', Sender: '' };
export const MsgDisableRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgDisableRecipe };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
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
        const message = { ...baseMsgDisableRecipe };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
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
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgDisableRecipe };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
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
const baseMsgDisableRecipeResponse = { Message: '', Status: '' };
export const MsgDisableRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgDisableRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgDisableRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgDisableRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgDisableTrade = { TradeID: '', Sender: '' };
export const MsgDisableTrade = {
    encode(message, writer = Writer.create()) {
        if (message.TradeID !== '') {
            writer.uint32(10).string(message.TradeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgDisableTrade };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.TradeID = reader.string();
                    break;
                case 2:
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
        const message = { ...baseMsgDisableTrade };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = String(object.TradeID);
        }
        else {
            message.TradeID = '';
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
        message.TradeID !== undefined && (obj.TradeID = message.TradeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgDisableTrade };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = object.TradeID;
        }
        else {
            message.TradeID = '';
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
const baseMsgDisableTradeResponse = { Message: '', Status: '' };
export const MsgDisableTradeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgDisableTradeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgDisableTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgDisableTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgEnableRecipe = { RecipeID: '', Sender: '' };
export const MsgEnableRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgEnableRecipe };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
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
        const message = { ...baseMsgEnableRecipe };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
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
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgEnableRecipe };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
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
const baseMsgEnableRecipeResponse = { Message: '', Status: '' };
export const MsgEnableRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgEnableRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgEnableRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgEnableRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgEnableTrade = { TradeID: '', Sender: '' };
export const MsgEnableTrade = {
    encode(message, writer = Writer.create()) {
        if (message.TradeID !== '') {
            writer.uint32(10).string(message.TradeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgEnableTrade };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.TradeID = reader.string();
                    break;
                case 2:
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
        const message = { ...baseMsgEnableTrade };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = String(object.TradeID);
        }
        else {
            message.TradeID = '';
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
        message.TradeID !== undefined && (obj.TradeID = message.TradeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgEnableTrade };
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = object.TradeID;
        }
        else {
            message.TradeID = '';
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
const baseMsgEnableTradeResponse = { Message: '', Status: '' };
export const MsgEnableTradeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgEnableTradeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgEnableTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgEnableTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgExecuteRecipe = { RecipeID: '', Sender: '', ItemIDs: '' };
export const MsgExecuteRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        for (const v of message.ItemIDs) {
            writer.uint32(26).string(v);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgExecuteRecipe };
        message.ItemIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
                    message.ItemIDs.push(reader.string());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgExecuteRecipe };
        message.ItemIDs = [];
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(String(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        if (message.ItemIDs) {
            obj.ItemIDs = message.ItemIDs.map((e) => e);
        }
        else {
            obj.ItemIDs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgExecuteRecipe };
        message.ItemIDs = [];
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(e);
            }
        }
        return message;
    }
};
const baseMsgExecuteRecipeResponse = { Message: '', Status: '' };
export const MsgExecuteRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        if (message.Output.length !== 0) {
            writer.uint32(26).bytes(message.Output);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgExecuteRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                case 3:
                    message.Output = reader.bytes();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgExecuteRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        if (object.Output !== undefined && object.Output !== null) {
            message.Output = bytesFromBase64(object.Output);
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        message.Output !== undefined && (obj.Output = base64FromBytes(message.Output !== undefined ? message.Output : new Uint8Array()));
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgExecuteRecipeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        if (object.Output !== undefined && object.Output !== null) {
            message.Output = object.Output;
        }
        else {
            message.Output = new Uint8Array();
        }
        return message;
    }
};
const baseMsgFiatItem = { CookbookID: '', Sender: '', TransferFee: 0 };
export const MsgFiatItem = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        for (const v of message.Doubles) {
            DoubleKeyValue.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.Longs) {
            LongKeyValue.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.Strings) {
            StringKeyValue.encode(v, writer.uint32(34).fork()).ldelim();
        }
        if (message.Sender !== '') {
            writer.uint32(42).string(message.Sender);
        }
        if (message.TransferFee !== 0) {
            writer.uint32(48).int64(message.TransferFee);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgFiatItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
                    message.Doubles.push(DoubleKeyValue.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.Longs.push(LongKeyValue.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Strings.push(StringKeyValue.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.Sender = reader.string();
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
        const message = { ...baseMsgFiatItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
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
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
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
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
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
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.TransferFee !== undefined && (obj.TransferFee = message.TransferFee);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgFiatItem };
        message.Doubles = [];
        message.Longs = [];
        message.Strings = [];
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
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
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
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
const baseMsgFiatItemResponse = { ItemID: '', Message: '', Status: '' };
export const MsgFiatItemResponse = {
    encode(message, writer = Writer.create()) {
        if (message.ItemID !== '') {
            writer.uint32(10).string(message.ItemID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgFiatItemResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ItemID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgFiatItemResponse };
        if (object.ItemID !== undefined && object.ItemID !== null) {
            message.ItemID = String(object.ItemID);
        }
        else {
            message.ItemID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ItemID !== undefined && (obj.ItemID = message.ItemID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgFiatItemResponse };
        if (object.ItemID !== undefined && object.ItemID !== null) {
            message.ItemID = object.ItemID;
        }
        else {
            message.ItemID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgFulfillTrade = { TradeID: '', Sender: '', ItemIDs: '' };
export const MsgFulfillTrade = {
    encode(message, writer = Writer.create()) {
        if (message.TradeID !== '') {
            writer.uint32(10).string(message.TradeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        for (const v of message.ItemIDs) {
            writer.uint32(26).string(v);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgFulfillTrade };
        message.ItemIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.TradeID = reader.string();
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
                    message.ItemIDs.push(reader.string());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgFulfillTrade };
        message.ItemIDs = [];
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = String(object.TradeID);
        }
        else {
            message.TradeID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(String(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.TradeID !== undefined && (obj.TradeID = message.TradeID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        if (message.ItemIDs) {
            obj.ItemIDs = message.ItemIDs.map((e) => e);
        }
        else {
            obj.ItemIDs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgFulfillTrade };
        message.ItemIDs = [];
        if (object.TradeID !== undefined && object.TradeID !== null) {
            message.TradeID = object.TradeID;
        }
        else {
            message.TradeID = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(e);
            }
        }
        return message;
    }
};
const baseMsgFulfillTradeResponse = { Message: '', Status: '' };
export const MsgFulfillTradeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgFulfillTradeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgFulfillTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgFulfillTradeResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgGetPylons = { Requester: '' };
export const MsgGetPylons = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Amount) {
            Coin.encode(v, writer.uint32(10).fork()).ldelim();
        }
        if (message.Requester !== '') {
            writer.uint32(18).string(message.Requester);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGetPylons };
        message.Amount = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Amount.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.Requester = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgGetPylons };
        message.Amount = [];
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromJSON(e));
            }
        }
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = String(object.Requester);
        }
        else {
            message.Requester = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Amount) {
            obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.Amount = [];
        }
        message.Requester !== undefined && (obj.Requester = message.Requester);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgGetPylons };
        message.Amount = [];
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromPartial(e));
            }
        }
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = object.Requester;
        }
        else {
            message.Requester = '';
        }
        return message;
    }
};
const baseMsgGetPylonsResponse = { Message: '', Status: '' };
export const MsgGetPylonsResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGetPylonsResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgGetPylonsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgGetPylonsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgGoogleIAPGetPylons = { ProductID: '', PurchaseToken: '', ReceiptDataBase64: '', Signature: '', Requester: '' };
export const MsgGoogleIAPGetPylons = {
    encode(message, writer = Writer.create()) {
        if (message.ProductID !== '') {
            writer.uint32(10).string(message.ProductID);
        }
        if (message.PurchaseToken !== '') {
            writer.uint32(18).string(message.PurchaseToken);
        }
        if (message.ReceiptDataBase64 !== '') {
            writer.uint32(26).string(message.ReceiptDataBase64);
        }
        if (message.Signature !== '') {
            writer.uint32(34).string(message.Signature);
        }
        if (message.Requester !== '') {
            writer.uint32(42).string(message.Requester);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGoogleIAPGetPylons };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ProductID = reader.string();
                    break;
                case 2:
                    message.PurchaseToken = reader.string();
                    break;
                case 3:
                    message.ReceiptDataBase64 = reader.string();
                    break;
                case 4:
                    message.Signature = reader.string();
                    break;
                case 5:
                    message.Requester = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgGoogleIAPGetPylons };
        if (object.ProductID !== undefined && object.ProductID !== null) {
            message.ProductID = String(object.ProductID);
        }
        else {
            message.ProductID = '';
        }
        if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
            message.PurchaseToken = String(object.PurchaseToken);
        }
        else {
            message.PurchaseToken = '';
        }
        if (object.ReceiptDataBase64 !== undefined && object.ReceiptDataBase64 !== null) {
            message.ReceiptDataBase64 = String(object.ReceiptDataBase64);
        }
        else {
            message.ReceiptDataBase64 = '';
        }
        if (object.Signature !== undefined && object.Signature !== null) {
            message.Signature = String(object.Signature);
        }
        else {
            message.Signature = '';
        }
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = String(object.Requester);
        }
        else {
            message.Requester = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ProductID !== undefined && (obj.ProductID = message.ProductID);
        message.PurchaseToken !== undefined && (obj.PurchaseToken = message.PurchaseToken);
        message.ReceiptDataBase64 !== undefined && (obj.ReceiptDataBase64 = message.ReceiptDataBase64);
        message.Signature !== undefined && (obj.Signature = message.Signature);
        message.Requester !== undefined && (obj.Requester = message.Requester);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgGoogleIAPGetPylons };
        if (object.ProductID !== undefined && object.ProductID !== null) {
            message.ProductID = object.ProductID;
        }
        else {
            message.ProductID = '';
        }
        if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
            message.PurchaseToken = object.PurchaseToken;
        }
        else {
            message.PurchaseToken = '';
        }
        if (object.ReceiptDataBase64 !== undefined && object.ReceiptDataBase64 !== null) {
            message.ReceiptDataBase64 = object.ReceiptDataBase64;
        }
        else {
            message.ReceiptDataBase64 = '';
        }
        if (object.Signature !== undefined && object.Signature !== null) {
            message.Signature = object.Signature;
        }
        else {
            message.Signature = '';
        }
        if (object.Requester !== undefined && object.Requester !== null) {
            message.Requester = object.Requester;
        }
        else {
            message.Requester = '';
        }
        return message;
    }
};
const baseMsgGoogleIAPGetPylonsResponse = { Message: '', Status: '' };
export const MsgGoogleIAPGetPylonsResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGoogleIAPGetPylonsResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgGoogleIAPGetPylonsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgGoogleIAPGetPylonsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgSendCoins = { Sender: '', Receiver: '' };
export const MsgSendCoins = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Amount) {
            Coin.encode(v, writer.uint32(10).fork()).ldelim();
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        if (message.Receiver !== '') {
            writer.uint32(26).string(message.Receiver);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendCoins };
        message.Amount = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Amount.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
                    message.Receiver = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgSendCoins };
        message.Amount = [];
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromJSON(e));
            }
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.Receiver !== undefined && object.Receiver !== null) {
            message.Receiver = String(object.Receiver);
        }
        else {
            message.Receiver = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Amount) {
            obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.Amount = [];
        }
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Receiver !== undefined && (obj.Receiver = message.Receiver);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgSendCoins };
        message.Amount = [];
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromPartial(e));
            }
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.Receiver !== undefined && object.Receiver !== null) {
            message.Receiver = object.Receiver;
        }
        else {
            message.Receiver = '';
        }
        return message;
    }
};
const baseMsgSendCoinsResponse = {};
export const MsgSendCoinsResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendCoinsResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(_) {
        const message = { ...baseMsgSendCoinsResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgSendCoinsResponse };
        return message;
    }
};
const baseMsgSendItems = { ItemIDs: '', Sender: '', Receiver: '' };
export const MsgSendItems = {
    encode(message, writer = Writer.create()) {
        for (const v of message.ItemIDs) {
            writer.uint32(10).string(v);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        if (message.Receiver !== '') {
            writer.uint32(26).string(message.Receiver);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendItems };
        message.ItemIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ItemIDs.push(reader.string());
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
                    message.Receiver = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgSendItems };
        message.ItemIDs = [];
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(String(e));
            }
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.Receiver !== undefined && object.Receiver !== null) {
            message.Receiver = String(object.Receiver);
        }
        else {
            message.Receiver = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.ItemIDs) {
            obj.ItemIDs = message.ItemIDs.map((e) => e);
        }
        else {
            obj.ItemIDs = [];
        }
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Receiver !== undefined && (obj.Receiver = message.Receiver);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgSendItems };
        message.ItemIDs = [];
        if (object.ItemIDs !== undefined && object.ItemIDs !== null) {
            for (const e of object.ItemIDs) {
                message.ItemIDs.push(e);
            }
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.Receiver !== undefined && object.Receiver !== null) {
            message.Receiver = object.Receiver;
        }
        else {
            message.Receiver = '';
        }
        return message;
    }
};
const baseMsgSendItemsResponse = { Message: '', Status: '' };
export const MsgSendItemsResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Message !== '') {
            writer.uint32(10).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(18).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendItemsResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Message = reader.string();
                    break;
                case 2:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgSendItemsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgSendItemsResponse };
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgUpdateItemString = { Field: '', Value: '', Sender: '', ItemID: '' };
export const MsgUpdateItemString = {
    encode(message, writer = Writer.create()) {
        if (message.Field !== '') {
            writer.uint32(10).string(message.Field);
        }
        if (message.Value !== '') {
            writer.uint32(18).string(message.Value);
        }
        if (message.Sender !== '') {
            writer.uint32(26).string(message.Sender);
        }
        if (message.ItemID !== '') {
            writer.uint32(34).string(message.ItemID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateItemString };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Field = reader.string();
                    break;
                case 2:
                    message.Value = reader.string();
                    break;
                case 3:
                    message.Sender = reader.string();
                    break;
                case 4:
                    message.ItemID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgUpdateItemString };
        if (object.Field !== undefined && object.Field !== null) {
            message.Field = String(object.Field);
        }
        else {
            message.Field = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = String(object.Value);
        }
        else {
            message.Value = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
        }
        if (object.ItemID !== undefined && object.ItemID !== null) {
            message.ItemID = String(object.ItemID);
        }
        else {
            message.ItemID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Field !== undefined && (obj.Field = message.Field);
        message.Value !== undefined && (obj.Value = message.Value);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.ItemID !== undefined && (obj.ItemID = message.ItemID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateItemString };
        if (object.Field !== undefined && object.Field !== null) {
            message.Field = object.Field;
        }
        else {
            message.Field = '';
        }
        if (object.Value !== undefined && object.Value !== null) {
            message.Value = object.Value;
        }
        else {
            message.Value = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.ItemID !== undefined && object.ItemID !== null) {
            message.ItemID = object.ItemID;
        }
        else {
            message.ItemID = '';
        }
        return message;
    }
};
const baseMsgUpdateItemStringResponse = { Status: '', Message: '' };
export const MsgUpdateItemStringResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Status !== '') {
            writer.uint32(10).string(message.Status);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateItemStringResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Status = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgUpdateItemStringResponse };
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Status !== undefined && (obj.Status = message.Status);
        message.Message !== undefined && (obj.Message = message.Message);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateItemStringResponse };
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        return message;
    }
};
const baseMsgUpdateCookbook = { ID: '', Description: '', Version: '', Developer: '', SupportEmail: '', Sender: '' };
export const MsgUpdateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        if (message.Description !== '') {
            writer.uint32(18).string(message.Description);
        }
        if (message.Version !== '') {
            writer.uint32(26).string(message.Version);
        }
        if (message.Developer !== '') {
            writer.uint32(34).string(message.Developer);
        }
        if (message.SupportEmail !== '') {
            writer.uint32(42).string(message.SupportEmail);
        }
        if (message.Sender !== '') {
            writer.uint32(50).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                case 2:
                    message.Description = reader.string();
                    break;
                case 3:
                    message.Version = reader.string();
                    break;
                case 4:
                    message.Developer = reader.string();
                    break;
                case 5:
                    message.SupportEmail = reader.string();
                    break;
                case 6:
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
        const message = { ...baseMsgUpdateCookbook };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
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
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = String(object.SupportEmail);
        }
        else {
            message.SupportEmail = '';
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
        message.Description !== undefined && (obj.Description = message.Description);
        message.Version !== undefined && (obj.Version = message.Version);
        message.Developer !== undefined && (obj.Developer = message.Developer);
        message.SupportEmail !== undefined && (obj.SupportEmail = message.SupportEmail);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateCookbook };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
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
        if (object.SupportEmail !== undefined && object.SupportEmail !== null) {
            message.SupportEmail = object.SupportEmail;
        }
        else {
            message.SupportEmail = '';
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
const baseMsgUpdateCookbookResponse = { CookbookID: '', Message: '', Status: '' };
export const MsgUpdateCookbookResponse = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateCookbookResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgUpdateCookbookResponse };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateCookbookResponse };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
const baseMsgUpdateRecipe = { Name: '', CookbookID: '', ID: '', BlockInterval: 0, Sender: '', Description: '' };
export const MsgUpdateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.Name !== '') {
            writer.uint32(10).string(message.Name);
        }
        if (message.CookbookID !== '') {
            writer.uint32(18).string(message.CookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(26).string(message.ID);
        }
        for (const v of message.CoinInputs) {
            CoinInput.encode(v, writer.uint32(34).fork()).ldelim();
        }
        for (const v of message.ItemInputs) {
            ItemInput.encode(v, writer.uint32(42).fork()).ldelim();
        }
        for (const v of message.Outputs) {
            WeightedOutputs.encode(v, writer.uint32(50).fork()).ldelim();
        }
        if (message.BlockInterval !== 0) {
            writer.uint32(56).int64(message.BlockInterval);
        }
        if (message.Sender !== '') {
            writer.uint32(66).string(message.Sender);
        }
        if (message.Description !== '') {
            writer.uint32(74).string(message.Description);
        }
        if (message.Entries !== undefined) {
            EntriesList.encode(message.Entries, writer.uint32(82).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Name = reader.string();
                    break;
                case 2:
                    message.CookbookID = reader.string();
                    break;
                case 3:
                    message.ID = reader.string();
                    break;
                case 4:
                    message.CoinInputs.push(CoinInput.decode(reader, reader.uint32()));
                    break;
                case 5:
                    message.ItemInputs.push(ItemInput.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.Outputs.push(WeightedOutputs.decode(reader, reader.uint32()));
                    break;
                case 7:
                    message.BlockInterval = longToNumber(reader.int64());
                    break;
                case 8:
                    message.Sender = reader.string();
                    break;
                case 9:
                    message.Description = reader.string();
                    break;
                case 10:
                    message.Entries = EntriesList.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgUpdateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = String(object.Name);
        }
        else {
            message.Name = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
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
                message.ItemInputs.push(ItemInput.fromJSON(e));
            }
        }
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromJSON(e));
            }
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
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = String(object.Description);
        }
        else {
            message.Description = '';
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromJSON(object.Entries);
        }
        else {
            message.Entries = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Name !== undefined && (obj.Name = message.Name);
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
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
        if (message.Outputs) {
            obj.Outputs = message.Outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined));
        }
        else {
            obj.Outputs = [];
        }
        message.BlockInterval !== undefined && (obj.BlockInterval = message.BlockInterval);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Entries !== undefined && (obj.Entries = message.Entries ? EntriesList.toJSON(message.Entries) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateRecipe };
        message.CoinInputs = [];
        message.ItemInputs = [];
        message.Outputs = [];
        if (object.Name !== undefined && object.Name !== null) {
            message.Name = object.Name;
        }
        else {
            message.Name = '';
        }
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
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
                message.ItemInputs.push(ItemInput.fromPartial(e));
            }
        }
        if (object.Outputs !== undefined && object.Outputs !== null) {
            for (const e of object.Outputs) {
                message.Outputs.push(WeightedOutputs.fromPartial(e));
            }
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
        if (object.Description !== undefined && object.Description !== null) {
            message.Description = object.Description;
        }
        else {
            message.Description = '';
        }
        if (object.Entries !== undefined && object.Entries !== null) {
            message.Entries = EntriesList.fromPartial(object.Entries);
        }
        else {
            message.Entries = undefined;
        }
        return message;
    }
};
const baseMsgUpdateRecipeResponse = { RecipeID: '', Message: '', Status: '' };
export const MsgUpdateRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Message !== '') {
            writer.uint32(18).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(26).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.RecipeID = reader.string();
                    break;
                case 2:
                    message.Message = reader.string();
                    break;
                case 3:
                    message.Status = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgUpdateRecipeResponse };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = String(object.Message);
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = String(object.Status);
        }
        else {
            message.Status = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateRecipeResponse };
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        if (object.Message !== undefined && object.Message !== null) {
            message.Message = object.Message;
        }
        else {
            message.Message = '';
        }
        if (object.Status !== undefined && object.Status !== null) {
            message.Status = object.Status;
        }
        else {
            message.Status = '';
        }
        return message;
    }
};
export class MsgClientImpl {
    constructor(rpc) {
        this.rpc = rpc;
    }
    CreateAccount(request) {
        const data = MsgCreateAccount.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'CreateAccount', data);
        return promise.then((data) => MsgCreateExecutionResponse.decode(new Reader(data)));
    }
    GetPylons(request) {
        const data = MsgGetPylons.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'GetPylons', data);
        return promise.then((data) => MsgGetPylonsResponse.decode(new Reader(data)));
    }
    GoogleIAPGetPylons(request) {
        const data = MsgGoogleIAPGetPylons.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'GoogleIAPGetPylons', data);
        return promise.then((data) => MsgGoogleIAPGetPylonsResponse.decode(new Reader(data)));
    }
    SendCoins(request) {
        const data = MsgSendCoins.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'SendCoins', data);
        return promise.then((data) => MsgSendCoinsResponse.decode(new Reader(data)));
    }
    SendItems(request) {
        const data = MsgSendItems.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'SendItems', data);
        return promise.then((data) => MsgSendItemsResponse.decode(new Reader(data)));
    }
    CreateCookbook(request) {
        const data = MsgCreateCookbook.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'CreateCookbook', data);
        return promise.then((data) => MsgCreateCookbookResponse.decode(new Reader(data)));
    }
    HandlerMsgUpdateCookbook(request) {
        const data = MsgUpdateCookbook.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'HandlerMsgUpdateCookbook', data);
        return promise.then((data) => MsgUpdateCookbookResponse.decode(new Reader(data)));
    }
    CreateRecipe(request) {
        const data = MsgCreateRecipe.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'CreateRecipe', data);
        return promise.then((data) => MsgCreateRecipeResponse.decode(new Reader(data)));
    }
    HandlerMsgUpdateRecipe(request) {
        const data = MsgUpdateRecipe.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'HandlerMsgUpdateRecipe', data);
        return promise.then((data) => MsgUpdateRecipeResponse.decode(new Reader(data)));
    }
    ExecuteRecipe(request) {
        const data = MsgExecuteRecipe.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'ExecuteRecipe', data);
        return promise.then((data) => MsgExecuteRecipeResponse.decode(new Reader(data)));
    }
    DisableRecipe(request) {
        const data = MsgDisableRecipe.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'DisableRecipe', data);
        return promise.then((data) => MsgDisableRecipeResponse.decode(new Reader(data)));
    }
    EnableRecipe(request) {
        const data = MsgEnableRecipe.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'EnableRecipe', data);
        return promise.then((data) => MsgEnableRecipeResponse.decode(new Reader(data)));
    }
    CheckExecution(request) {
        const data = MsgCheckExecution.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'CheckExecution', data);
        return promise.then((data) => MsgCheckExecutionResponse.decode(new Reader(data)));
    }
    FiatItem(request) {
        const data = MsgFiatItem.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'FiatItem', data);
        return promise.then((data) => MsgFiatItemResponse.decode(new Reader(data)));
    }
    UpdateItemString(request) {
        const data = MsgUpdateItemString.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'UpdateItemString', data);
        return promise.then((data) => MsgUpdateItemStringResponse.decode(new Reader(data)));
    }
    CreateTrade(request) {
        const data = MsgCreateTrade.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'CreateTrade', data);
        return promise.then((data) => MsgCreateTradeResponse.decode(new Reader(data)));
    }
    FulfillTrade(request) {
        const data = MsgFulfillTrade.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'FulfillTrade', data);
        return promise.then((data) => MsgFulfillTradeResponse.decode(new Reader(data)));
    }
    DisableTrade(request) {
        const data = MsgDisableTrade.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'DisableTrade', data);
        return promise.then((data) => MsgDisableTradeResponse.decode(new Reader(data)));
    }
    EnableTrade(request) {
        const data = MsgEnableTrade.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'EnableTrade', data);
        return promise.then((data) => MsgEnableTradeResponse.decode(new Reader(data)));
    }
}
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
const atob = globalThis.atob || ((b64) => globalThis.Buffer.from(b64, 'base64').toString('binary'));
function bytesFromBase64(b64) {
    const bin = atob(b64);
    const arr = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; ++i) {
        arr[i] = bin.charCodeAt(i);
    }
    return arr;
}
const btoa = globalThis.btoa || ((bin) => globalThis.Buffer.from(bin, 'binary').toString('base64'));
function base64FromBytes(arr) {
    const bin = [];
    for (let i = 0; i < arr.byteLength; ++i) {
        bin.push(String.fromCharCode(arr[i]));
    }
    return btoa(bin.join(''));
}
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
