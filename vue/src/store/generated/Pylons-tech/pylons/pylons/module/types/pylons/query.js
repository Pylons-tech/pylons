/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal';
import * as Long from 'long';
import { Coin } from '../cosmos/base/v1beta1/coin';
import { Item, CoinInput, ItemInput, EntriesList, WeightedOutputs, TradeItemInput, Cookbook, Execution, LockedCoinDescribe, Recipe, ShortenRecipe, Trade } from '../pylons/pylons';
export const protobufPackage = 'pylons';
const baseAddrFromPubKeyRequest = { hexPubKey: '' };
export const AddrFromPubKeyRequest = {
    encode(message, writer = Writer.create()) {
        if (message.hexPubKey !== '') {
            writer.uint32(10).string(message.hexPubKey);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseAddrFromPubKeyRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.hexPubKey = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseAddrFromPubKeyRequest };
        if (object.hexPubKey !== undefined && object.hexPubKey !== null) {
            message.hexPubKey = String(object.hexPubKey);
        }
        else {
            message.hexPubKey = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.hexPubKey !== undefined && (obj.hexPubKey = message.hexPubKey);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseAddrFromPubKeyRequest };
        if (object.hexPubKey !== undefined && object.hexPubKey !== null) {
            message.hexPubKey = object.hexPubKey;
        }
        else {
            message.hexPubKey = '';
        }
        return message;
    }
};
const baseAddrFromPubKeyResponse = { Bech32Addr: '' };
export const AddrFromPubKeyResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Bech32Addr !== '') {
            writer.uint32(10).string(message.Bech32Addr);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseAddrFromPubKeyResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Bech32Addr = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseAddrFromPubKeyResponse };
        if (object.Bech32Addr !== undefined && object.Bech32Addr !== null) {
            message.Bech32Addr = String(object.Bech32Addr);
        }
        else {
            message.Bech32Addr = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Bech32Addr !== undefined && (obj.Bech32Addr = message.Bech32Addr);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseAddrFromPubKeyResponse };
        if (object.Bech32Addr !== undefined && object.Bech32Addr !== null) {
            message.Bech32Addr = object.Bech32Addr;
        }
        else {
            message.Bech32Addr = '';
        }
        return message;
    }
};
const baseCheckGoogleIapOrderRequest = { purchaseToken: '' };
export const CheckGoogleIapOrderRequest = {
    encode(message, writer = Writer.create()) {
        if (message.purchaseToken !== '') {
            writer.uint32(10).string(message.purchaseToken);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCheckGoogleIapOrderRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.purchaseToken = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCheckGoogleIapOrderRequest };
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = String(object.purchaseToken);
        }
        else {
            message.purchaseToken = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCheckGoogleIapOrderRequest };
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = object.purchaseToken;
        }
        else {
            message.purchaseToken = '';
        }
        return message;
    }
};
const baseCheckGoogleIapOrderResponse = { purchaseToken: '', exist: false };
export const CheckGoogleIapOrderResponse = {
    encode(message, writer = Writer.create()) {
        if (message.purchaseToken !== '') {
            writer.uint32(10).string(message.purchaseToken);
        }
        if (message.exist === true) {
            writer.uint32(16).bool(message.exist);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCheckGoogleIapOrderResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.purchaseToken = reader.string();
                    break;
                case 2:
                    message.exist = reader.bool();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCheckGoogleIapOrderResponse };
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = String(object.purchaseToken);
        }
        else {
            message.purchaseToken = '';
        }
        if (object.exist !== undefined && object.exist !== null) {
            message.exist = Boolean(object.exist);
        }
        else {
            message.exist = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken);
        message.exist !== undefined && (obj.exist = message.exist);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCheckGoogleIapOrderResponse };
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = object.purchaseToken;
        }
        else {
            message.purchaseToken = '';
        }
        if (object.exist !== undefined && object.exist !== null) {
            message.exist = object.exist;
        }
        else {
            message.exist = false;
        }
        return message;
    }
};
const baseGetCookbookRequest = { cookbookID: '' };
export const GetCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.cookbookID !== '') {
            writer.uint32(10).string(message.cookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.cookbookID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        return message;
    }
};
const baseGetCookbookResponse = {
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
export const GetCookbookResponse = {
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
        const message = { ...baseGetCookbookResponse };
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
        const message = { ...baseGetCookbookResponse };
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
        const message = { ...baseGetCookbookResponse };
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
const baseGetExecutionRequest = { executionID: '' };
export const GetExecutionRequest = {
    encode(message, writer = Writer.create()) {
        if (message.executionID !== '') {
            writer.uint32(10).string(message.executionID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetExecutionRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.executionID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetExecutionRequest };
        if (object.executionID !== undefined && object.executionID !== null) {
            message.executionID = String(object.executionID);
        }
        else {
            message.executionID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.executionID !== undefined && (obj.executionID = message.executionID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetExecutionRequest };
        if (object.executionID !== undefined && object.executionID !== null) {
            message.executionID = object.executionID;
        }
        else {
            message.executionID = '';
        }
        return message;
    }
};
const baseGetExecutionResponse = { NodeVersion: '', ID: '', RecipeID: '', CookbookID: '', BlockHeight: 0, Sender: '', Completed: false };
export const GetExecutionResponse = {
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
        for (const v of message.CoinsInput) {
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
        const message = { ...baseGetExecutionResponse };
        message.CoinsInput = [];
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
                    message.CoinsInput.push(Coin.decode(reader, reader.uint32()));
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
        const message = { ...baseGetExecutionResponse };
        message.CoinsInput = [];
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
        if (object.CoinsInput !== undefined && object.CoinsInput !== null) {
            for (const e of object.CoinsInput) {
                message.CoinsInput.push(Coin.fromJSON(e));
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
        if (message.CoinsInput) {
            obj.CoinsInput = message.CoinsInput.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.CoinsInput = [];
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
        const message = { ...baseGetExecutionResponse };
        message.CoinsInput = [];
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
        if (object.CoinsInput !== undefined && object.CoinsInput !== null) {
            for (const e of object.CoinsInput) {
                message.CoinsInput.push(Coin.fromPartial(e));
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
const baseGetItemRequest = { itemID: '' };
export const GetItemRequest = {
    encode(message, writer = Writer.create()) {
        if (message.itemID !== '') {
            writer.uint32(10).string(message.itemID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetItemRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.itemID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetItemRequest };
        if (object.itemID !== undefined && object.itemID !== null) {
            message.itemID = String(object.itemID);
        }
        else {
            message.itemID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.itemID !== undefined && (obj.itemID = message.itemID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetItemRequest };
        if (object.itemID !== undefined && object.itemID !== null) {
            message.itemID = object.itemID;
        }
        else {
            message.itemID = '';
        }
        return message;
    }
};
const baseGetItemResponse = {};
export const GetItemResponse = {
    encode(message, writer = Writer.create()) {
        if (message.item !== undefined) {
            Item.encode(message.item, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetItemResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.item = Item.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetItemResponse };
        if (object.item !== undefined && object.item !== null) {
            message.item = Item.fromJSON(object.item);
        }
        else {
            message.item = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.item !== undefined && (obj.item = message.item ? Item.toJSON(message.item) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetItemResponse };
        if (object.item !== undefined && object.item !== null) {
            message.item = Item.fromPartial(object.item);
        }
        else {
            message.item = undefined;
        }
        return message;
    }
};
const baseGetRecipeRequest = { recipeID: '' };
export const GetRecipeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.recipeID !== '') {
            writer.uint32(10).string(message.recipeID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetRecipeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.recipeID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetRecipeRequest };
        if (object.recipeID !== undefined && object.recipeID !== null) {
            message.recipeID = String(object.recipeID);
        }
        else {
            message.recipeID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.recipeID !== undefined && (obj.recipeID = message.recipeID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetRecipeRequest };
        if (object.recipeID !== undefined && object.recipeID !== null) {
            message.recipeID = object.recipeID;
        }
        else {
            message.recipeID = '';
        }
        return message;
    }
};
const baseGetRecipeResponse = { NodeVersion: '', ID: '', CookbookID: '', Name: '', Description: '', BlockInterval: 0, Sender: '', Disabled: false };
export const GetRecipeResponse = {
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
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetRecipeResponse };
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
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetRecipeResponse };
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
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetRecipeResponse };
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
        return message;
    }
};
const baseGetTradeRequest = { tradeID: '' };
export const GetTradeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.tradeID !== '') {
            writer.uint32(10).string(message.tradeID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetTradeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.tradeID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetTradeRequest };
        if (object.tradeID !== undefined && object.tradeID !== null) {
            message.tradeID = String(object.tradeID);
        }
        else {
            message.tradeID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.tradeID !== undefined && (obj.tradeID = message.tradeID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetTradeRequest };
        if (object.tradeID !== undefined && object.tradeID !== null) {
            message.tradeID = object.tradeID;
        }
        else {
            message.tradeID = '';
        }
        return message;
    }
};
const baseGetTradeResponse = { NodeVersion: '', ID: '', ExtraInfo: '', Sender: '', FulFiller: '', Disabled: false, Completed: false };
export const GetTradeResponse = {
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
        const message = { ...baseGetTradeResponse };
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
        const message = { ...baseGetTradeResponse };
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
        const message = { ...baseGetTradeResponse };
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
const baseItemsByCookbookRequest = { cookbookID: '' };
export const ItemsByCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.cookbookID !== '') {
            writer.uint32(10).string(message.cookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemsByCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.cookbookID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemsByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemsByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        return message;
    }
};
const baseItemsByCookbookResponse = {};
export const ItemsByCookbookResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Items) {
            Item.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemsByCookbookResponse };
        message.Items = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Items.push(Item.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemsByCookbookResponse };
        message.Items = [];
        if (object.Items !== undefined && object.Items !== null) {
            for (const e of object.Items) {
                message.Items.push(Item.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Items) {
            obj.Items = message.Items.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.Items = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemsByCookbookResponse };
        message.Items = [];
        if (object.Items !== undefined && object.Items !== null) {
            for (const e of object.Items) {
                message.Items.push(Item.fromPartial(e));
            }
        }
        return message;
    }
};
const baseItemsBySenderRequest = { sender: '' };
export const ItemsBySenderRequest = {
    encode(message, writer = Writer.create()) {
        if (message.sender !== '') {
            writer.uint32(10).string(message.sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemsBySenderRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.sender = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemsBySenderRequest };
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = String(object.sender);
        }
        else {
            message.sender = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.sender !== undefined && (obj.sender = message.sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemsBySenderRequest };
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = object.sender;
        }
        else {
            message.sender = '';
        }
        return message;
    }
};
const baseItemsBySenderResponse = {};
export const ItemsBySenderResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Items) {
            Item.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseItemsBySenderResponse };
        message.Items = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Items.push(Item.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseItemsBySenderResponse };
        message.Items = [];
        if (object.Items !== undefined && object.Items !== null) {
            for (const e of object.Items) {
                message.Items.push(Item.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Items) {
            obj.Items = message.Items.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.Items = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseItemsBySenderResponse };
        message.Items = [];
        if (object.Items !== undefined && object.Items !== null) {
            for (const e of object.Items) {
                message.Items.push(Item.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListCookbookRequest = { address: '' };
export const ListCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListCookbookRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListCookbookRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseListCookbookResponse = {};
export const ListCookbookResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Cookbooks) {
            Cookbook.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListCookbookResponse };
        message.Cookbooks = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Cookbooks.push(Cookbook.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListCookbookResponse };
        message.Cookbooks = [];
        if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
            for (const e of object.Cookbooks) {
                message.Cookbooks.push(Cookbook.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Cookbooks) {
            obj.Cookbooks = message.Cookbooks.map((e) => (e ? Cookbook.toJSON(e) : undefined));
        }
        else {
            obj.Cookbooks = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListCookbookResponse };
        message.Cookbooks = [];
        if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
            for (const e of object.Cookbooks) {
                message.Cookbooks.push(Cookbook.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListExecutionsRequest = { sender: '' };
export const ListExecutionsRequest = {
    encode(message, writer = Writer.create()) {
        if (message.sender !== '') {
            writer.uint32(10).string(message.sender);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListExecutionsRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.sender = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListExecutionsRequest };
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = String(object.sender);
        }
        else {
            message.sender = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.sender !== undefined && (obj.sender = message.sender);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListExecutionsRequest };
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = object.sender;
        }
        else {
            message.sender = '';
        }
        return message;
    }
};
const baseListExecutionsResponse = {};
export const ListExecutionsResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Executions) {
            Execution.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListExecutionsResponse };
        message.Executions = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Executions.push(Execution.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListExecutionsResponse };
        message.Executions = [];
        if (object.Executions !== undefined && object.Executions !== null) {
            for (const e of object.Executions) {
                message.Executions.push(Execution.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Executions) {
            obj.Executions = message.Executions.map((e) => (e ? Execution.toJSON(e) : undefined));
        }
        else {
            obj.Executions = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListExecutionsResponse };
        message.Executions = [];
        if (object.Executions !== undefined && object.Executions !== null) {
            for (const e of object.Executions) {
                message.Executions.push(Execution.fromPartial(e));
            }
        }
        return message;
    }
};
const baseGetLockedCoinsRequest = { address: '' };
export const GetLockedCoinsRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetLockedCoinsRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetLockedCoinsRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetLockedCoinsRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseGetLockedCoinsResponse = { NodeVersion: '', Sender: '' };
export const GetLockedCoinsResponse = {
    encode(message, writer = Writer.create()) {
        if (message.NodeVersion !== '') {
            writer.uint32(10).string(message.NodeVersion);
        }
        if (message.Sender !== '') {
            writer.uint32(18).string(message.Sender);
        }
        for (const v of message.Amount) {
            Coin.encode(v, writer.uint32(26).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetLockedCoinsResponse };
        message.Amount = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.NodeVersion = reader.string();
                    break;
                case 2:
                    message.Sender = reader.string();
                    break;
                case 3:
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
        const message = { ...baseGetLockedCoinsResponse };
        message.Amount = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = String(object.NodeVersion);
        }
        else {
            message.NodeVersion = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = String(object.Sender);
        }
        else {
            message.Sender = '';
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
        message.NodeVersion !== undefined && (obj.NodeVersion = message.NodeVersion);
        message.Sender !== undefined && (obj.Sender = message.Sender);
        if (message.Amount) {
            obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.Amount = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetLockedCoinsResponse };
        message.Amount = [];
        if (object.NodeVersion !== undefined && object.NodeVersion !== null) {
            message.NodeVersion = object.NodeVersion;
        }
        else {
            message.NodeVersion = '';
        }
        if (object.Sender !== undefined && object.Sender !== null) {
            message.Sender = object.Sender;
        }
        else {
            message.Sender = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromPartial(e));
            }
        }
        return message;
    }
};
const baseGetLockedCoinDetailsRequest = { address: '' };
export const GetLockedCoinDetailsRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetLockedCoinDetailsRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetLockedCoinDetailsRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetLockedCoinDetailsRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseGetLockedCoinDetailsResponse = { sender: '' };
export const GetLockedCoinDetailsResponse = {
    encode(message, writer = Writer.create()) {
        if (message.sender !== '') {
            writer.uint32(10).string(message.sender);
        }
        for (const v of message.Amount) {
            Coin.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.LockCoinTrades) {
            LockedCoinDescribe.encode(v, writer.uint32(26).fork()).ldelim();
        }
        for (const v of message.LockCoinExecs) {
            LockedCoinDescribe.encode(v, writer.uint32(34).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGetLockedCoinDetailsResponse };
        message.Amount = [];
        message.LockCoinTrades = [];
        message.LockCoinExecs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.sender = reader.string();
                    break;
                case 2:
                    message.Amount.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.LockCoinTrades.push(LockedCoinDescribe.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.LockCoinExecs.push(LockedCoinDescribe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGetLockedCoinDetailsResponse };
        message.Amount = [];
        message.LockCoinTrades = [];
        message.LockCoinExecs = [];
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = String(object.sender);
        }
        else {
            message.sender = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromJSON(e));
            }
        }
        if (object.LockCoinTrades !== undefined && object.LockCoinTrades !== null) {
            for (const e of object.LockCoinTrades) {
                message.LockCoinTrades.push(LockedCoinDescribe.fromJSON(e));
            }
        }
        if (object.LockCoinExecs !== undefined && object.LockCoinExecs !== null) {
            for (const e of object.LockCoinExecs) {
                message.LockCoinExecs.push(LockedCoinDescribe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.sender !== undefined && (obj.sender = message.sender);
        if (message.Amount) {
            obj.Amount = message.Amount.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.Amount = [];
        }
        if (message.LockCoinTrades) {
            obj.LockCoinTrades = message.LockCoinTrades.map((e) => (e ? LockedCoinDescribe.toJSON(e) : undefined));
        }
        else {
            obj.LockCoinTrades = [];
        }
        if (message.LockCoinExecs) {
            obj.LockCoinExecs = message.LockCoinExecs.map((e) => (e ? LockedCoinDescribe.toJSON(e) : undefined));
        }
        else {
            obj.LockCoinExecs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGetLockedCoinDetailsResponse };
        message.Amount = [];
        message.LockCoinTrades = [];
        message.LockCoinExecs = [];
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = object.sender;
        }
        else {
            message.sender = '';
        }
        if (object.Amount !== undefined && object.Amount !== null) {
            for (const e of object.Amount) {
                message.Amount.push(Coin.fromPartial(e));
            }
        }
        if (object.LockCoinTrades !== undefined && object.LockCoinTrades !== null) {
            for (const e of object.LockCoinTrades) {
                message.LockCoinTrades.push(LockedCoinDescribe.fromPartial(e));
            }
        }
        if (object.LockCoinExecs !== undefined && object.LockCoinExecs !== null) {
            for (const e of object.LockCoinExecs) {
                message.LockCoinExecs.push(LockedCoinDescribe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListRecipeRequest = { address: '' };
export const ListRecipeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListRecipeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListRecipeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListRecipeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseListRecipeResponse = {};
export const ListRecipeResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.recipes) {
            Recipe.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListRecipeResponse };
        message.recipes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.recipes.push(Recipe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListRecipeResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.recipes) {
            obj.recipes = message.recipes.map((e) => (e ? Recipe.toJSON(e) : undefined));
        }
        else {
            obj.recipes = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListRecipeResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListRecipeByCookbookRequest = { cookbookID: '' };
export const ListRecipeByCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.cookbookID !== '') {
            writer.uint32(10).string(message.cookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListRecipeByCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.cookbookID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListRecipeByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListRecipeByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        return message;
    }
};
const baseListRecipeByCookbookResponse = {};
export const ListRecipeByCookbookResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.recipes) {
            Recipe.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListRecipeByCookbookResponse };
        message.recipes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.recipes.push(Recipe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListRecipeByCookbookResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.recipes) {
            obj.recipes = message.recipes.map((e) => (e ? Recipe.toJSON(e) : undefined));
        }
        else {
            obj.recipes = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListRecipeByCookbookResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListShortenRecipeRequest = { address: '' };
export const ListShortenRecipeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListShortenRecipeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListShortenRecipeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListShortenRecipeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseListShortenRecipeResponse = {};
export const ListShortenRecipeResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.recipes) {
            ShortenRecipe.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListShortenRecipeResponse };
        message.recipes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.recipes.push(ShortenRecipe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListShortenRecipeResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(ShortenRecipe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.recipes) {
            obj.recipes = message.recipes.map((e) => (e ? ShortenRecipe.toJSON(e) : undefined));
        }
        else {
            obj.recipes = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListShortenRecipeResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(ShortenRecipe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListShortenRecipeByCookbookRequest = { cookbookID: '' };
export const ListShortenRecipeByCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.cookbookID !== '') {
            writer.uint32(10).string(message.cookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListShortenRecipeByCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.cookbookID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListShortenRecipeByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListShortenRecipeByCookbookRequest };
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        return message;
    }
};
const baseListShortenRecipeByCookbookResponse = {};
export const ListShortenRecipeByCookbookResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.recipes) {
            ShortenRecipe.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListShortenRecipeByCookbookResponse };
        message.recipes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.recipes.push(ShortenRecipe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListShortenRecipeByCookbookResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(ShortenRecipe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.recipes) {
            obj.recipes = message.recipes.map((e) => (e ? ShortenRecipe.toJSON(e) : undefined));
        }
        else {
            obj.recipes = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListShortenRecipeByCookbookResponse };
        message.recipes = [];
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(ShortenRecipe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseListTradeRequest = { address: '' };
export const ListTradeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListTradeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListTradeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListTradeRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseListTradeResponse = {};
export const ListTradeResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.trades) {
            Trade.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseListTradeResponse };
        message.trades = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.trades.push(Trade.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseListTradeResponse };
        message.trades = [];
        if (object.trades !== undefined && object.trades !== null) {
            for (const e of object.trades) {
                message.trades.push(Trade.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.trades) {
            obj.trades = message.trades.map((e) => (e ? Trade.toJSON(e) : undefined));
        }
        else {
            obj.trades = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseListTradeResponse };
        message.trades = [];
        if (object.trades !== undefined && object.trades !== null) {
            for (const e of object.trades) {
                message.trades.push(Trade.fromPartial(e));
            }
        }
        return message;
    }
};
const basePylonsBalanceRequest = { address: '' };
export const PylonsBalanceRequest = {
    encode(message, writer = Writer.create()) {
        if (message.address !== '') {
            writer.uint32(10).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...basePylonsBalanceRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.address = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...basePylonsBalanceRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = String(object.address);
        }
        else {
            message.address = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...basePylonsBalanceRequest };
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const basePylonsBalanceResponse = { balance: 0 };
export const PylonsBalanceResponse = {
    encode(message, writer = Writer.create()) {
        if (message.balance !== 0) {
            writer.uint32(8).int64(message.balance);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...basePylonsBalanceResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.balance = longToNumber(reader.int64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...basePylonsBalanceResponse };
        if (object.balance !== undefined && object.balance !== null) {
            message.balance = Number(object.balance);
        }
        else {
            message.balance = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.balance !== undefined && (obj.balance = message.balance);
        return obj;
    },
    fromPartial(object) {
        const message = { ...basePylonsBalanceResponse };
        if (object.balance !== undefined && object.balance !== null) {
            message.balance = object.balance;
        }
        else {
            message.balance = 0;
        }
        return message;
    }
};
export class QueryClientImpl {
    constructor(rpc) {
        this.rpc = rpc;
    }
    AddrFromPubKey(request) {
        const data = AddrFromPubKeyRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'AddrFromPubKey', data);
        return promise.then((data) => AddrFromPubKeyResponse.decode(new Reader(data)));
    }
    CheckGoogleIapOrder(request) {
        const data = CheckGoogleIapOrderRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'CheckGoogleIapOrder', data);
        return promise.then((data) => CheckGoogleIapOrderResponse.decode(new Reader(data)));
    }
    GetCookbook(request) {
        const data = GetCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetCookbook', data);
        return promise.then((data) => GetCookbookResponse.decode(new Reader(data)));
    }
    GetExecution(request) {
        const data = GetExecutionRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetExecution', data);
        return promise.then((data) => GetExecutionResponse.decode(new Reader(data)));
    }
    GetItem(request) {
        const data = GetItemRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetItem', data);
        return promise.then((data) => GetItemResponse.decode(new Reader(data)));
    }
    GetRecipe(request) {
        const data = GetRecipeRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetRecipe', data);
        return promise.then((data) => GetRecipeResponse.decode(new Reader(data)));
    }
    GetTrade(request) {
        const data = GetTradeRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetTrade', data);
        return promise.then((data) => GetTradeResponse.decode(new Reader(data)));
    }
    ItemsByCookbook(request) {
        const data = ItemsByCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ItemsByCookbook', data);
        return promise.then((data) => ItemsByCookbookResponse.decode(new Reader(data)));
    }
    ItemsBySender(request) {
        const data = ItemsBySenderRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ItemsBySender', data);
        return promise.then((data) => ItemsBySenderResponse.decode(new Reader(data)));
    }
    ListCookbook(request) {
        const data = ListCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListCookbook', data);
        return promise.then((data) => ListCookbookResponse.decode(new Reader(data)));
    }
    ListExecutions(request) {
        const data = ListExecutionsRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListExecutions', data);
        return promise.then((data) => ListExecutionsResponse.decode(new Reader(data)));
    }
    GetLockedCoins(request) {
        const data = GetLockedCoinsRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetLockedCoins', data);
        return promise.then((data) => GetLockedCoinsResponse.decode(new Reader(data)));
    }
    GetLockedCoinDetails(request) {
        const data = GetLockedCoinDetailsRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'GetLockedCoinDetails', data);
        return promise.then((data) => GetLockedCoinDetailsResponse.decode(new Reader(data)));
    }
    ListRecipe(request) {
        const data = ListRecipeRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListRecipe', data);
        return promise.then((data) => ListRecipeResponse.decode(new Reader(data)));
    }
    ListRecipeByCookbook(request) {
        const data = ListRecipeByCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListRecipeByCookbook', data);
        return promise.then((data) => ListRecipeByCookbookResponse.decode(new Reader(data)));
    }
    ListShortenRecipe(request) {
        const data = ListShortenRecipeRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListShortenRecipe', data);
        return promise.then((data) => ListShortenRecipeResponse.decode(new Reader(data)));
    }
    ListShortenRecipeByCookbook(request) {
        const data = ListShortenRecipeByCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListShortenRecipeByCookbook', data);
        return promise.then((data) => ListShortenRecipeByCookbookResponse.decode(new Reader(data)));
    }
    ListTrade(request) {
        const data = ListTradeRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'ListTrade', data);
        return promise.then((data) => ListTradeResponse.decode(new Reader(data)));
    }
    PylonsBalance(request) {
        const data = PylonsBalanceRequest.encode(request).finish();
        const promise = this.rpc.request('pylons.Query', 'PylonsBalance', data);
        return promise.then((data) => PylonsBalanceResponse.decode(new Reader(data)));
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
