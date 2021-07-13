/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal';
import * as Long from 'long';
import { CoinInput, ItemInput, WeightedOutputs, EntriesList, TradeItemInput, Item, DoubleKeyValue, LongKeyValue, StringKeyValue, StripePrice, StripeInventory } from '../pylons/pylons';
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
const baseMsgExecuteRecipe = { RecipeID: '', Sender: '', PaymentId: '', PaymentMethod: '', ItemIDs: '' };
export const MsgExecuteRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.RecipeID !== '') {
            writer.uint32(10).string(message.RecipeID);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        if (message.PaymentId !== '') {
            writer.uint32(26).string(message.PaymentId);
        }
        if (message.PaymentMethod !== '') {
            writer.uint32(34).string(message.PaymentMethod);
        }
        for (const v of message.ItemIDs) {
            writer.uint32(42).string(v);
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
                    message.PaymentId = reader.string();
                    break;
                case 4:
                    message.PaymentMethod = reader.string();
                    break;
                case 5:
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
        if (object.PaymentId !== undefined && object.PaymentId !== null) {
            message.PaymentId = String(object.PaymentId);
        }
        else {
            message.PaymentId = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = String(object.PaymentMethod);
        }
        else {
            message.PaymentMethod = '';
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
        message.PaymentId !== undefined && (obj.PaymentId = message.PaymentId);
        message.PaymentMethod !== undefined && (obj.PaymentMethod = message.PaymentMethod);
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
        if (object.PaymentId !== undefined && object.PaymentId !== null) {
            message.PaymentId = object.PaymentId;
        }
        else {
            message.PaymentId = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = object.PaymentMethod;
        }
        else {
            message.PaymentMethod = '';
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
const baseMsgUpdateRecipe = { Name: '', CookbookID: '', ID: '', BlockInterval: 0, Sender: '', Description: '', ExtraInfo: '' };
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
        if (message.ExtraInfo !== '') {
            writer.uint32(90).string(message.ExtraInfo);
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
        message.ExtraInfo !== undefined && (obj.ExtraInfo = message.ExtraInfo);
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
        if (object.ExtraInfo !== undefined && object.ExtraInfo !== null) {
            message.ExtraInfo = object.ExtraInfo;
        }
        else {
            message.ExtraInfo = '';
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
const baseMsgStripeCreateProduct = { StripeKey: '', Name: '', Description: '', Images: '', StatementDescriptor: '', UnitLabel: '', Sender: '' };
export const MsgStripeCreateProduct = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Name !== '') {
            writer.uint32(18).string(message.Name);
        }
        if (message.Description !== '') {
            writer.uint32(26).string(message.Description);
        }
        for (const v of message.Images) {
            writer.uint32(34).string(v);
        }
        if (message.StatementDescriptor !== '') {
            writer.uint32(42).string(message.StatementDescriptor);
        }
        if (message.UnitLabel !== '') {
            writer.uint32(50).string(message.UnitLabel);
        }
        if (message.Sender !== '') {
            writer.uint32(58).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreateProduct };
        message.Images = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Name = reader.string();
                    break;
                case 3:
                    message.Description = reader.string();
                    break;
                case 4:
                    message.Images.push(reader.string());
                    break;
                case 5:
                    message.StatementDescriptor = reader.string();
                    break;
                case 6:
                    message.UnitLabel = reader.string();
                    break;
                case 7:
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
        const message = { ...baseMsgStripeCreateProduct };
        message.Images = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
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
        if (object.Images !== undefined && object.Images !== null) {
            for (const e of object.Images) {
                message.Images.push(String(e));
            }
        }
        if (object.StatementDescriptor !== undefined && object.StatementDescriptor !== null) {
            message.StatementDescriptor = String(object.StatementDescriptor);
        }
        else {
            message.StatementDescriptor = '';
        }
        if (object.UnitLabel !== undefined && object.UnitLabel !== null) {
            message.UnitLabel = String(object.UnitLabel);
        }
        else {
            message.UnitLabel = '';
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Name !== undefined && (obj.Name = message.Name);
        message.Description !== undefined && (obj.Description = message.Description);
        if (message.Images) {
            obj.Images = message.Images.map((e) => e);
        }
        else {
            obj.Images = [];
        }
        message.StatementDescriptor !== undefined && (obj.StatementDescriptor = message.StatementDescriptor);
        message.UnitLabel !== undefined && (obj.UnitLabel = message.UnitLabel);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateProduct };
        message.Images = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
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
        if (object.Images !== undefined && object.Images !== null) {
            for (const e of object.Images) {
                message.Images.push(e);
            }
        }
        if (object.StatementDescriptor !== undefined && object.StatementDescriptor !== null) {
            message.StatementDescriptor = object.StatementDescriptor;
        }
        else {
            message.StatementDescriptor = '';
        }
        if (object.UnitLabel !== undefined && object.UnitLabel !== null) {
            message.UnitLabel = object.UnitLabel;
        }
        else {
            message.UnitLabel = '';
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
const baseMsgStripeCreateProductResponse = { ProductID: '', Message: '', Status: '' };
export const MsgStripeCreateProductResponse = {
    encode(message, writer = Writer.create()) {
        if (message.ProductID !== '') {
            writer.uint32(10).string(message.ProductID);
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
        const message = { ...baseMsgStripeCreateProductResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ProductID = reader.string();
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
        const message = { ...baseMsgStripeCreateProductResponse };
        if (object.ProductID !== undefined && object.ProductID !== null) {
            message.ProductID = String(object.ProductID);
        }
        else {
            message.ProductID = '';
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
        message.ProductID !== undefined && (obj.ProductID = message.ProductID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateProductResponse };
        if (object.ProductID !== undefined && object.ProductID !== null) {
            message.ProductID = object.ProductID;
        }
        else {
            message.ProductID = '';
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
const baseMsgStripeCreatePrice = { StripeKey: '', Product: '', Amount: '', Currency: '', Description: '', Sender: '' };
export const MsgStripeCreatePrice = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Product !== '') {
            writer.uint32(18).string(message.Product);
        }
        if (message.Amount !== '') {
            writer.uint32(26).string(message.Amount);
        }
        if (message.Currency !== '') {
            writer.uint32(34).string(message.Currency);
        }
        if (message.Description !== '') {
            writer.uint32(42).string(message.Description);
        }
        if (message.Sender !== '') {
            writer.uint32(50).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreatePrice };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Product = reader.string();
                    break;
                case 3:
                    message.Amount = reader.string();
                    break;
                case 4:
                    message.Currency = reader.string();
                    break;
                case 5:
                    message.Description = reader.string();
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
        const message = { ...baseMsgStripeCreatePrice };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
        }
        if (object.Product !== undefined && object.Product !== null) {
            message.Product = String(object.Product);
        }
        else {
            message.Product = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            message.Amount = String(object.Amount);
        }
        else {
            message.Amount = '';
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = String(object.Currency);
        }
        else {
            message.Currency = '';
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Product !== undefined && (obj.Product = message.Product);
        message.Amount !== undefined && (obj.Amount = message.Amount);
        message.Currency !== undefined && (obj.Currency = message.Currency);
        message.Description !== undefined && (obj.Description = message.Description);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreatePrice };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
        }
        if (object.Product !== undefined && object.Product !== null) {
            message.Product = object.Product;
        }
        else {
            message.Product = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            message.Amount = object.Amount;
        }
        else {
            message.Amount = '';
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = object.Currency;
        }
        else {
            message.Currency = '';
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
const baseMsgStripeCreatePriceResponse = { PriceID: '', Message: '', Status: '' };
export const MsgStripeCreatePriceResponse = {
    encode(message, writer = Writer.create()) {
        if (message.PriceID !== '') {
            writer.uint32(10).string(message.PriceID);
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
        const message = { ...baseMsgStripeCreatePriceResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.PriceID = reader.string();
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
        const message = { ...baseMsgStripeCreatePriceResponse };
        if (object.PriceID !== undefined && object.PriceID !== null) {
            message.PriceID = String(object.PriceID);
        }
        else {
            message.PriceID = '';
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
        message.PriceID !== undefined && (obj.PriceID = message.PriceID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreatePriceResponse };
        if (object.PriceID !== undefined && object.PriceID !== null) {
            message.PriceID = object.PriceID;
        }
        else {
            message.PriceID = '';
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
const baseMsgStripeCustomer = { Email: '', PaymentMethod: '' };
export const MsgStripeCustomer = {
    encode(message, writer = Writer.create()) {
        if (message.Email !== '') {
            writer.uint32(10).string(message.Email);
        }
        if (message.PaymentMethod !== '') {
            writer.uint32(18).string(message.PaymentMethod);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCustomer };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Email = reader.string();
                    break;
                case 2:
                    message.PaymentMethod = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgStripeCustomer };
        if (object.Email !== undefined && object.Email !== null) {
            message.Email = String(object.Email);
        }
        else {
            message.Email = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = String(object.PaymentMethod);
        }
        else {
            message.PaymentMethod = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Email !== undefined && (obj.Email = message.Email);
        message.PaymentMethod !== undefined && (obj.PaymentMethod = message.PaymentMethod);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCustomer };
        if (object.Email !== undefined && object.Email !== null) {
            message.Email = object.Email;
        }
        else {
            message.Email = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = object.PaymentMethod;
        }
        else {
            message.PaymentMethod = '';
        }
        return message;
    }
};
const baseMsgStripeCheckout = { StripeKey: '', PaymentMethod: '', Sender: '' };
export const MsgStripeCheckout = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.PaymentMethod !== '') {
            writer.uint32(18).string(message.PaymentMethod);
        }
        if (message.Price !== undefined) {
            StripePrice.encode(message.Price, writer.uint32(26).fork()).ldelim();
        }
        if (message.Sender !== '') {
            writer.uint32(34).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCheckout };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.PaymentMethod = reader.string();
                    break;
                case 3:
                    message.Price = StripePrice.decode(reader, reader.uint32());
                    break;
                case 4:
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
        const message = { ...baseMsgStripeCheckout };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = String(object.PaymentMethod);
        }
        else {
            message.PaymentMethod = '';
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = StripePrice.fromJSON(object.Price);
        }
        else {
            message.Price = undefined;
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.PaymentMethod !== undefined && (obj.PaymentMethod = message.PaymentMethod);
        message.Price !== undefined && (obj.Price = message.Price ? StripePrice.toJSON(message.Price) : undefined);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCheckout };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
        }
        if (object.PaymentMethod !== undefined && object.PaymentMethod !== null) {
            message.PaymentMethod = object.PaymentMethod;
        }
        else {
            message.PaymentMethod = '';
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = StripePrice.fromPartial(object.Price);
        }
        else {
            message.Price = undefined;
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
const baseMsgStripeCheckoutResponse = { SessionID: '', Message: '', Status: '' };
export const MsgStripeCheckoutResponse = {
    encode(message, writer = Writer.create()) {
        if (message.SessionID !== '') {
            writer.uint32(10).string(message.SessionID);
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
        const message = { ...baseMsgStripeCheckoutResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.SessionID = reader.string();
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
        const message = { ...baseMsgStripeCheckoutResponse };
        if (object.SessionID !== undefined && object.SessionID !== null) {
            message.SessionID = String(object.SessionID);
        }
        else {
            message.SessionID = '';
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
        message.SessionID !== undefined && (obj.SessionID = message.SessionID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCheckoutResponse };
        if (object.SessionID !== undefined && object.SessionID !== null) {
            message.SessionID = object.SessionID;
        }
        else {
            message.SessionID = '';
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
const baseMsgStripeCreateSku = { StripeKey: '', Product: '', Price: 0, Currency: '', Sender: '' };
export const MsgStripeCreateSku = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Product !== '') {
            writer.uint32(18).string(message.Product);
        }
        for (const v of message.Attributes) {
            StringKeyValue.encode(v, writer.uint32(26).fork()).ldelim();
        }
        if (message.Price !== 0) {
            writer.uint32(32).int64(message.Price);
        }
        if (message.Currency !== '') {
            writer.uint32(42).string(message.Currency);
        }
        if (message.Inventory !== undefined) {
            StripeInventory.encode(message.Inventory, writer.uint32(50).fork()).ldelim();
        }
        if (message.Sender !== '') {
            writer.uint32(58).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreateSku };
        message.Attributes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Product = reader.string();
                    break;
                case 3:
                    message.Attributes.push(StringKeyValue.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.Price = longToNumber(reader.int64());
                    break;
                case 5:
                    message.Currency = reader.string();
                    break;
                case 6:
                    message.Inventory = StripeInventory.decode(reader, reader.uint32());
                    break;
                case 7:
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
        const message = { ...baseMsgStripeCreateSku };
        message.Attributes = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
        }
        if (object.Product !== undefined && object.Product !== null) {
            message.Product = String(object.Product);
        }
        else {
            message.Product = '';
        }
        if (object.Attributes !== undefined && object.Attributes !== null) {
            for (const e of object.Attributes) {
                message.Attributes.push(StringKeyValue.fromJSON(e));
            }
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = Number(object.Price);
        }
        else {
            message.Price = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = String(object.Currency);
        }
        else {
            message.Currency = '';
        }
        if (object.Inventory !== undefined && object.Inventory !== null) {
            message.Inventory = StripeInventory.fromJSON(object.Inventory);
        }
        else {
            message.Inventory = undefined;
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Product !== undefined && (obj.Product = message.Product);
        if (message.Attributes) {
            obj.Attributes = message.Attributes.map((e) => (e ? StringKeyValue.toJSON(e) : undefined));
        }
        else {
            obj.Attributes = [];
        }
        message.Price !== undefined && (obj.Price = message.Price);
        message.Currency !== undefined && (obj.Currency = message.Currency);
        message.Inventory !== undefined && (obj.Inventory = message.Inventory ? StripeInventory.toJSON(message.Inventory) : undefined);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateSku };
        message.Attributes = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
        }
        if (object.Product !== undefined && object.Product !== null) {
            message.Product = object.Product;
        }
        else {
            message.Product = '';
        }
        if (object.Attributes !== undefined && object.Attributes !== null) {
            for (const e of object.Attributes) {
                message.Attributes.push(StringKeyValue.fromPartial(e));
            }
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = object.Price;
        }
        else {
            message.Price = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = object.Currency;
        }
        else {
            message.Currency = '';
        }
        if (object.Inventory !== undefined && object.Inventory !== null) {
            message.Inventory = StripeInventory.fromPartial(object.Inventory);
        }
        else {
            message.Inventory = undefined;
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
const baseMsgStripeCreateSkuResponse = { SKUID: '', Message: '', Status: '' };
export const MsgStripeCreateSkuResponse = {
    encode(message, writer = Writer.create()) {
        if (message.SKUID !== '') {
            writer.uint32(10).string(message.SKUID);
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
        const message = { ...baseMsgStripeCreateSkuResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.SKUID = reader.string();
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
        const message = { ...baseMsgStripeCreateSkuResponse };
        if (object.SKUID !== undefined && object.SKUID !== null) {
            message.SKUID = String(object.SKUID);
        }
        else {
            message.SKUID = '';
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
        message.SKUID !== undefined && (obj.SKUID = message.SKUID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateSkuResponse };
        if (object.SKUID !== undefined && object.SKUID !== null) {
            message.SKUID = object.SKUID;
        }
        else {
            message.SKUID = '';
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
const baseMsgStripeCreatePaymentIntent = { StripeKey: '', Amount: 0, Currency: '', SKUID: '', Sender: '' };
export const MsgStripeCreatePaymentIntent = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Amount !== 0) {
            writer.uint32(16).int64(message.Amount);
        }
        if (message.Currency !== '') {
            writer.uint32(26).string(message.Currency);
        }
        if (message.SKUID !== '') {
            writer.uint32(34).string(message.SKUID);
        }
        if (message.Sender !== '') {
            writer.uint32(42).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreatePaymentIntent };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Amount = longToNumber(reader.int64());
                    break;
                case 3:
                    message.Currency = reader.string();
                    break;
                case 4:
                    message.SKUID = reader.string();
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
        const message = { ...baseMsgStripeCreatePaymentIntent };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            message.Amount = Number(object.Amount);
        }
        else {
            message.Amount = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = String(object.Currency);
        }
        else {
            message.Currency = '';
        }
        if (object.SKUID !== undefined && object.SKUID !== null) {
            message.SKUID = String(object.SKUID);
        }
        else {
            message.SKUID = '';
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Amount !== undefined && (obj.Amount = message.Amount);
        message.Currency !== undefined && (obj.Currency = message.Currency);
        message.SKUID !== undefined && (obj.SKUID = message.SKUID);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreatePaymentIntent };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            message.Amount = object.Amount;
        }
        else {
            message.Amount = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = object.Currency;
        }
        else {
            message.Currency = '';
        }
        if (object.SKUID !== undefined && object.SKUID !== null) {
            message.SKUID = object.SKUID;
        }
        else {
            message.SKUID = '';
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
const baseMsgStripeCreatePaymentIntentResponse = { PaymentID: '', Message: '', Status: '' };
export const MsgStripeCreatePaymentIntentResponse = {
    encode(message, writer = Writer.create()) {
        if (message.PaymentID !== '') {
            writer.uint32(10).string(message.PaymentID);
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
        const message = { ...baseMsgStripeCreatePaymentIntentResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.PaymentID = reader.string();
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
        const message = { ...baseMsgStripeCreatePaymentIntentResponse };
        if (object.PaymentID !== undefined && object.PaymentID !== null) {
            message.PaymentID = String(object.PaymentID);
        }
        else {
            message.PaymentID = '';
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
        message.PaymentID !== undefined && (obj.PaymentID = message.PaymentID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreatePaymentIntentResponse };
        if (object.PaymentID !== undefined && object.PaymentID !== null) {
            message.PaymentID = object.PaymentID;
        }
        else {
            message.PaymentID = '';
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
const baseMsgStripeCreateAccount = { StripeKey: '', Country: '', Email: '', Types: '', Sender: '' };
export const MsgStripeCreateAccount = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Country !== '') {
            writer.uint32(18).string(message.Country);
        }
        if (message.Email !== '') {
            writer.uint32(26).string(message.Email);
        }
        if (message.Types !== '') {
            writer.uint32(34).string(message.Types);
        }
        if (message.Sender !== '') {
            writer.uint32(42).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreateAccount };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Country = reader.string();
                    break;
                case 3:
                    message.Email = reader.string();
                    break;
                case 4:
                    message.Types = reader.string();
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
        const message = { ...baseMsgStripeCreateAccount };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
        }
        if (object.Country !== undefined && object.Country !== null) {
            message.Country = String(object.Country);
        }
        else {
            message.Country = '';
        }
        if (object.Email !== undefined && object.Email !== null) {
            message.Email = String(object.Email);
        }
        else {
            message.Email = '';
        }
        if (object.Types !== undefined && object.Types !== null) {
            message.Types = String(object.Types);
        }
        else {
            message.Types = '';
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Country !== undefined && (obj.Country = message.Country);
        message.Email !== undefined && (obj.Email = message.Email);
        message.Types !== undefined && (obj.Types = message.Types);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateAccount };
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
        }
        if (object.Country !== undefined && object.Country !== null) {
            message.Country = object.Country;
        }
        else {
            message.Country = '';
        }
        if (object.Email !== undefined && object.Email !== null) {
            message.Email = object.Email;
        }
        else {
            message.Email = '';
        }
        if (object.Types !== undefined && object.Types !== null) {
            message.Types = object.Types;
        }
        else {
            message.Types = '';
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
const baseMsgStripeCreateAccountResponse = { AccountID: '', Message: '', Status: '' };
export const MsgStripeCreateAccountResponse = {
    encode(message, writer = Writer.create()) {
        if (message.AccountID !== '') {
            writer.uint32(10).string(message.AccountID);
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
        const message = { ...baseMsgStripeCreateAccountResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.AccountID = reader.string();
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
        const message = { ...baseMsgStripeCreateAccountResponse };
        if (object.AccountID !== undefined && object.AccountID !== null) {
            message.AccountID = String(object.AccountID);
        }
        else {
            message.AccountID = '';
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
        message.AccountID !== undefined && (obj.AccountID = message.AccountID);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateAccountResponse };
        if (object.AccountID !== undefined && object.AccountID !== null) {
            message.AccountID = object.AccountID;
        }
        else {
            message.AccountID = '';
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
const baseMsgStripeCreateProductSku = { StripeKey: '', Name: '', Description: '', Images: '', Price: 0, Currency: '', ClientId: '', Sender: '' };
export const MsgStripeCreateProductSku = {
    encode(message, writer = Writer.create()) {
        if (message.StripeKey !== '') {
            writer.uint32(10).string(message.StripeKey);
        }
        if (message.Name !== '') {
            writer.uint32(18).string(message.Name);
        }
        if (message.Description !== '') {
            writer.uint32(26).string(message.Description);
        }
        for (const v of message.Images) {
            writer.uint32(34).string(v);
        }
        for (const v of message.Attributes) {
            StringKeyValue.encode(v, writer.uint32(42).fork()).ldelim();
        }
        if (message.Price !== 0) {
            writer.uint32(48).int64(message.Price);
        }
        if (message.Currency !== '') {
            writer.uint32(58).string(message.Currency);
        }
        if (message.Inventory !== undefined) {
            StripeInventory.encode(message.Inventory, writer.uint32(66).fork()).ldelim();
        }
        if (message.ClientId !== '') {
            writer.uint32(74).string(message.ClientId);
        }
        if (message.Sender !== '') {
            writer.uint32(82).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeCreateProductSku };
        message.Images = [];
        message.Attributes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.StripeKey = reader.string();
                    break;
                case 2:
                    message.Name = reader.string();
                    break;
                case 3:
                    message.Description = reader.string();
                    break;
                case 4:
                    message.Images.push(reader.string());
                    break;
                case 5:
                    message.Attributes.push(StringKeyValue.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.Price = longToNumber(reader.int64());
                    break;
                case 7:
                    message.Currency = reader.string();
                    break;
                case 8:
                    message.Inventory = StripeInventory.decode(reader, reader.uint32());
                    break;
                case 9:
                    message.ClientId = reader.string();
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
        const message = { ...baseMsgStripeCreateProductSku };
        message.Images = [];
        message.Attributes = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = String(object.StripeKey);
        }
        else {
            message.StripeKey = '';
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
        if (object.Images !== undefined && object.Images !== null) {
            for (const e of object.Images) {
                message.Images.push(String(e));
            }
        }
        if (object.Attributes !== undefined && object.Attributes !== null) {
            for (const e of object.Attributes) {
                message.Attributes.push(StringKeyValue.fromJSON(e));
            }
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = Number(object.Price);
        }
        else {
            message.Price = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = String(object.Currency);
        }
        else {
            message.Currency = '';
        }
        if (object.Inventory !== undefined && object.Inventory !== null) {
            message.Inventory = StripeInventory.fromJSON(object.Inventory);
        }
        else {
            message.Inventory = undefined;
        }
        if (object.ClientId !== undefined && object.ClientId !== null) {
            message.ClientId = String(object.ClientId);
        }
        else {
            message.ClientId = '';
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
        message.StripeKey !== undefined && (obj.StripeKey = message.StripeKey);
        message.Name !== undefined && (obj.Name = message.Name);
        message.Description !== undefined && (obj.Description = message.Description);
        if (message.Images) {
            obj.Images = message.Images.map((e) => e);
        }
        else {
            obj.Images = [];
        }
        if (message.Attributes) {
            obj.Attributes = message.Attributes.map((e) => (e ? StringKeyValue.toJSON(e) : undefined));
        }
        else {
            obj.Attributes = [];
        }
        message.Price !== undefined && (obj.Price = message.Price);
        message.Currency !== undefined && (obj.Currency = message.Currency);
        message.Inventory !== undefined && (obj.Inventory = message.Inventory ? StripeInventory.toJSON(message.Inventory) : undefined);
        message.ClientId !== undefined && (obj.ClientId = message.ClientId);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeCreateProductSku };
        message.Images = [];
        message.Attributes = [];
        if (object.StripeKey !== undefined && object.StripeKey !== null) {
            message.StripeKey = object.StripeKey;
        }
        else {
            message.StripeKey = '';
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
        if (object.Images !== undefined && object.Images !== null) {
            for (const e of object.Images) {
                message.Images.push(e);
            }
        }
        if (object.Attributes !== undefined && object.Attributes !== null) {
            for (const e of object.Attributes) {
                message.Attributes.push(StringKeyValue.fromPartial(e));
            }
        }
        if (object.Price !== undefined && object.Price !== null) {
            message.Price = object.Price;
        }
        else {
            message.Price = 0;
        }
        if (object.Currency !== undefined && object.Currency !== null) {
            message.Currency = object.Currency;
        }
        else {
            message.Currency = '';
        }
        if (object.Inventory !== undefined && object.Inventory !== null) {
            message.Inventory = StripeInventory.fromPartial(object.Inventory);
        }
        else {
            message.Inventory = undefined;
        }
        if (object.ClientId !== undefined && object.ClientId !== null) {
            message.ClientId = object.ClientId;
        }
        else {
            message.ClientId = '';
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
const baseMsgStripeInfo = { Sender: '' };
export const MsgStripeInfo = {
    encode(message, writer = Writer.create()) {
        if (message.Sender !== '') {
            writer.uint32(10).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeInfo };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
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
        const message = { ...baseMsgStripeInfo };
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
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeInfo };
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        return message;
    }
};
const baseMsgStripeInfoResponse = { PubKey: '', ClientID: '', URI: '', Message: '', Status: '' };
export const MsgStripeInfoResponse = {
    encode(message, writer = Writer.create()) {
        if (message.PubKey !== '') {
            writer.uint32(10).string(message.PubKey);
        }
        if (message.ClientID !== '') {
            writer.uint32(18).string(message.ClientID);
        }
        if (message.URI !== '') {
            writer.uint32(26).string(message.URI);
        }
        if (message.Message !== '') {
            writer.uint32(34).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(42).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeInfoResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.PubKey = reader.string();
                    break;
                case 2:
                    message.ClientID = reader.string();
                    break;
                case 3:
                    message.URI = reader.string();
                    break;
                case 4:
                    message.Message = reader.string();
                    break;
                case 5:
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
        const message = { ...baseMsgStripeInfoResponse };
        if (object.PubKey !== undefined && object.PubKey !== null) {
            message.PubKey = String(object.PubKey);
        }
        else {
            message.PubKey = '';
        }
        if (object.ClientID !== undefined && object.ClientID !== null) {
            message.ClientID = String(object.ClientID);
        }
        else {
            message.ClientID = '';
        }
        if (object.URI !== undefined && object.URI !== null) {
            message.URI = String(object.URI);
        }
        else {
            message.URI = '';
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
        message.PubKey !== undefined && (obj.PubKey = message.PubKey);
        message.ClientID !== undefined && (obj.ClientID = message.ClientID);
        message.URI !== undefined && (obj.URI = message.URI);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeInfoResponse };
        if (object.PubKey !== undefined && object.PubKey !== null) {
            message.PubKey = object.PubKey;
        }
        else {
            message.PubKey = '';
        }
        if (object.ClientID !== undefined && object.ClientID !== null) {
            message.ClientID = object.ClientID;
        }
        else {
            message.ClientID = '';
        }
        if (object.URI !== undefined && object.URI !== null) {
            message.URI = object.URI;
        }
        else {
            message.URI = '';
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
const baseMsgStripeOauthToken = { GrantType: '', Code: '', Sender: '' };
export const MsgStripeOauthToken = {
    encode(message, writer = Writer.create()) {
        if (message.GrantType !== '') {
            writer.uint32(10).string(message.GrantType);
        }
        if (message.Code !== '') {
            writer.uint32(18).string(message.Code);
        }
        if (message.Sender !== '') {
            writer.uint32(26).string(message.Sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeOauthToken };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.GrantType = reader.string();
                    break;
                case 2:
                    message.Code = reader.string();
                    break;
                case 3:
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
        const message = { ...baseMsgStripeOauthToken };
        if (object.GrantType !== undefined && object.GrantType !== null) {
            message.GrantType = String(object.GrantType);
        }
        else {
            message.GrantType = '';
        }
        if (object.Code !== undefined && object.Code !== null) {
            message.Code = String(object.Code);
        }
        else {
            message.Code = '';
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
        message.GrantType !== undefined && (obj.GrantType = message.GrantType);
        message.Code !== undefined && (obj.Code = message.Code);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeOauthToken };
        if (object.GrantType !== undefined && object.GrantType !== null) {
            message.GrantType = object.GrantType;
        }
        else {
            message.GrantType = '';
        }
        if (object.Code !== undefined && object.Code !== null) {
            message.Code = object.Code;
        }
        else {
            message.Code = '';
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
const baseMsgStripeOauthTokenResponse = {
    AcessToken: '',
    LiveMode: '',
    RefreshToken: '',
    TokenType: '',
    StripePublishKey: '',
    StripeUserID: '',
    Scope: '',
    Message: '',
    Status: ''
};
export const MsgStripeOauthTokenResponse = {
    encode(message, writer = Writer.create()) {
        if (message.AcessToken !== '') {
            writer.uint32(10).string(message.AcessToken);
        }
        if (message.LiveMode !== '') {
            writer.uint32(18).string(message.LiveMode);
        }
        if (message.RefreshToken !== '') {
            writer.uint32(26).string(message.RefreshToken);
        }
        if (message.TokenType !== '') {
            writer.uint32(34).string(message.TokenType);
        }
        if (message.StripePublishKey !== '') {
            writer.uint32(42).string(message.StripePublishKey);
        }
        if (message.StripeUserID !== '') {
            writer.uint32(50).string(message.StripeUserID);
        }
        if (message.Scope !== '') {
            writer.uint32(58).string(message.Scope);
        }
        if (message.Message !== '') {
            writer.uint32(66).string(message.Message);
        }
        if (message.Status !== '') {
            writer.uint32(74).string(message.Status);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgStripeOauthTokenResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.AcessToken = reader.string();
                    break;
                case 2:
                    message.LiveMode = reader.string();
                    break;
                case 3:
                    message.RefreshToken = reader.string();
                    break;
                case 4:
                    message.TokenType = reader.string();
                    break;
                case 5:
                    message.StripePublishKey = reader.string();
                    break;
                case 6:
                    message.StripeUserID = reader.string();
                    break;
                case 7:
                    message.Scope = reader.string();
                    break;
                case 8:
                    message.Message = reader.string();
                    break;
                case 9:
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
        const message = { ...baseMsgStripeOauthTokenResponse };
        if (object.AcessToken !== undefined && object.AcessToken !== null) {
            message.AcessToken = String(object.AcessToken);
        }
        else {
            message.AcessToken = '';
        }
        if (object.LiveMode !== undefined && object.LiveMode !== null) {
            message.LiveMode = String(object.LiveMode);
        }
        else {
            message.LiveMode = '';
        }
        if (object.RefreshToken !== undefined && object.RefreshToken !== null) {
            message.RefreshToken = String(object.RefreshToken);
        }
        else {
            message.RefreshToken = '';
        }
        if (object.TokenType !== undefined && object.TokenType !== null) {
            message.TokenType = String(object.TokenType);
        }
        else {
            message.TokenType = '';
        }
        if (object.StripePublishKey !== undefined && object.StripePublishKey !== null) {
            message.StripePublishKey = String(object.StripePublishKey);
        }
        else {
            message.StripePublishKey = '';
        }
        if (object.StripeUserID !== undefined && object.StripeUserID !== null) {
            message.StripeUserID = String(object.StripeUserID);
        }
        else {
            message.StripeUserID = '';
        }
        if (object.Scope !== undefined && object.Scope !== null) {
            message.Scope = String(object.Scope);
        }
        else {
            message.Scope = '';
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
        message.AcessToken !== undefined && (obj.AcessToken = message.AcessToken);
        message.LiveMode !== undefined && (obj.LiveMode = message.LiveMode);
        message.RefreshToken !== undefined && (obj.RefreshToken = message.RefreshToken);
        message.TokenType !== undefined && (obj.TokenType = message.TokenType);
        message.StripePublishKey !== undefined && (obj.StripePublishKey = message.StripePublishKey);
        message.StripeUserID !== undefined && (obj.StripeUserID = message.StripeUserID);
        message.Scope !== undefined && (obj.Scope = message.Scope);
        message.Message !== undefined && (obj.Message = message.Message);
        message.Status !== undefined && (obj.Status = message.Status);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgStripeOauthTokenResponse };
        if (object.AcessToken !== undefined && object.AcessToken !== null) {
            message.AcessToken = object.AcessToken;
        }
        else {
            message.AcessToken = '';
        }
        if (object.LiveMode !== undefined && object.LiveMode !== null) {
            message.LiveMode = object.LiveMode;
        }
        else {
            message.LiveMode = '';
        }
        if (object.RefreshToken !== undefined && object.RefreshToken !== null) {
            message.RefreshToken = object.RefreshToken;
        }
        else {
            message.RefreshToken = '';
        }
        if (object.TokenType !== undefined && object.TokenType !== null) {
            message.TokenType = object.TokenType;
        }
        else {
            message.TokenType = '';
        }
        if (object.StripePublishKey !== undefined && object.StripePublishKey !== null) {
            message.StripePublishKey = object.StripePublishKey;
        }
        else {
            message.StripePublishKey = '';
        }
        if (object.StripeUserID !== undefined && object.StripeUserID !== null) {
            message.StripeUserID = object.StripeUserID;
        }
        else {
            message.StripeUserID = '';
        }
        if (object.Scope !== undefined && object.Scope !== null) {
            message.Scope = object.Scope;
        }
        else {
            message.Scope = '';
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
    StripeCheckout(request) {
        const data = MsgStripeCheckout.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'StripeCheckout', data);
        return promise.then((data) => MsgStripeCheckoutResponse.decode(new Reader(data)));
    }
    StripeCreateProduct(request) {
        const data = MsgStripeCreateProduct.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'StripeCreateProduct', data);
        return promise.then((data) => MsgStripeCreateProductResponse.decode(new Reader(data)));
    }
    StripeCreatePrice(request) {
        const data = MsgStripeCreatePrice.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'StripeCreatePrice', data);
        return promise.then((data) => MsgStripeCreatePriceResponse.decode(new Reader(data)));
    }
    StripeCreateSku(request) {
        const data = MsgStripeCreateSku.encode(request).finish();
        const promise = this.rpc.request('pylons.Msg', 'StripeCreateSku', data);
        return promise.then((data) => MsgStripeCreateSkuResponse.decode(new Reader(data)));
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
