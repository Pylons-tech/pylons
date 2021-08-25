/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal';
import * as Long from 'long';
import { Coin } from '../cosmos/base/v1beta1/coin';
import { ItemInput, EntriesList, WeightedOutputs } from '../pylons/recipe';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseMsgCompleteExecutionEarly = { creator: '', ID: '' };
export const MsgCompleteExecutionEarly = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCompleteExecutionEarly };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCompleteExecutionEarly };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.ID !== undefined && (obj.ID = message.ID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCompleteExecutionEarly };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        return message;
    }
};
const baseMsgCompleteExecutionEarlyResponse = { ID: '' };
export const MsgCompleteExecutionEarlyResponse = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCompleteExecutionEarlyResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.ID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgCompleteExecutionEarlyResponse };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCompleteExecutionEarlyResponse };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        return message;
    }
};
const baseMsgTransferCookbook = { creator: '', ID: '', recipient: '' };
export const MsgTransferCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.recipient !== '') {
            writer.uint32(26).string(message.recipient);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgTransferCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.recipient = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgTransferCookbook };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.recipient !== undefined && object.recipient !== null) {
            message.recipient = String(object.recipient);
        }
        else {
            message.recipient = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.ID !== undefined && (obj.ID = message.ID);
        message.recipient !== undefined && (obj.recipient = message.recipient);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgTransferCookbook };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.recipient !== undefined && object.recipient !== null) {
            message.recipient = object.recipient;
        }
        else {
            message.recipient = '';
        }
        return message;
    }
};
const baseMsgTransferCookbookResponse = {};
export const MsgTransferCookbookResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgTransferCookbookResponse };
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
        const message = { ...baseMsgTransferCookbookResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgTransferCookbookResponse };
        return message;
    }
};
const baseMsgGoogleInAppPurchaseGetCoins = { creator: '', productID: '', purchaseToken: '', receiptDataBase64: '', signature: '' };
export const MsgGoogleInAppPurchaseGetCoins = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.productID !== '') {
            writer.uint32(18).string(message.productID);
        }
        if (message.purchaseToken !== '') {
            writer.uint32(26).string(message.purchaseToken);
        }
        if (message.receiptDataBase64 !== '') {
            writer.uint32(34).string(message.receiptDataBase64);
        }
        if (message.signature !== '') {
            writer.uint32(42).string(message.signature);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGoogleInAppPurchaseGetCoins };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.productID = reader.string();
                    break;
                case 3:
                    message.purchaseToken = reader.string();
                    break;
                case 4:
                    message.receiptDataBase64 = reader.string();
                    break;
                case 5:
                    message.signature = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgGoogleInAppPurchaseGetCoins };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = String(object.productID);
        }
        else {
            message.productID = '';
        }
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = String(object.purchaseToken);
        }
        else {
            message.purchaseToken = '';
        }
        if (object.receiptDataBase64 !== undefined && object.receiptDataBase64 !== null) {
            message.receiptDataBase64 = String(object.receiptDataBase64);
        }
        else {
            message.receiptDataBase64 = '';
        }
        if (object.signature !== undefined && object.signature !== null) {
            message.signature = String(object.signature);
        }
        else {
            message.signature = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.productID !== undefined && (obj.productID = message.productID);
        message.purchaseToken !== undefined && (obj.purchaseToken = message.purchaseToken);
        message.receiptDataBase64 !== undefined && (obj.receiptDataBase64 = message.receiptDataBase64);
        message.signature !== undefined && (obj.signature = message.signature);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgGoogleInAppPurchaseGetCoins };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = object.productID;
        }
        else {
            message.productID = '';
        }
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = object.purchaseToken;
        }
        else {
            message.purchaseToken = '';
        }
        if (object.receiptDataBase64 !== undefined && object.receiptDataBase64 !== null) {
            message.receiptDataBase64 = object.receiptDataBase64;
        }
        else {
            message.receiptDataBase64 = '';
        }
        if (object.signature !== undefined && object.signature !== null) {
            message.signature = object.signature;
        }
        else {
            message.signature = '';
        }
        return message;
    }
};
const baseMsgGoogleInAppPurchaseGetCoinsResponse = {};
export const MsgGoogleInAppPurchaseGetCoinsResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse };
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
        const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgGoogleInAppPurchaseGetCoinsResponse };
        return message;
    }
};
const baseMsgCreateAccount = { creator: '' };
export const MsgCreateAccount = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
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
                    message.creator = reader.string();
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
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateAccount };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        return message;
    }
};
const baseMsgCreateAccountResponse = {};
export const MsgCreateAccountResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateAccountResponse };
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
        const message = { ...baseMsgCreateAccountResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgCreateAccountResponse };
        return message;
    }
};
const baseMsgSendItems = { creator: '', receiver: '', cookbookID: '', itemIDs: '' };
export const MsgSendItems = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.receiver !== '') {
            writer.uint32(18).string(message.receiver);
        }
        if (message.cookbookID !== '') {
            writer.uint32(26).string(message.cookbookID);
        }
        for (const v of message.itemIDs) {
            writer.uint32(42).string(v);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendItems };
        message.itemIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.receiver = reader.string();
                    break;
                case 3:
                    message.cookbookID = reader.string();
                    break;
                case 5:
                    message.itemIDs.push(reader.string());
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
        message.itemIDs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = String(object.receiver);
        }
        else {
            message.receiver = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        if (object.itemIDs !== undefined && object.itemIDs !== null) {
            for (const e of object.itemIDs) {
                message.itemIDs.push(String(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.receiver !== undefined && (obj.receiver = message.receiver);
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        if (message.itemIDs) {
            obj.itemIDs = message.itemIDs.map((e) => e);
        }
        else {
            obj.itemIDs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgSendItems };
        message.itemIDs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = object.receiver;
        }
        else {
            message.receiver = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        if (object.itemIDs !== undefined && object.itemIDs !== null) {
            for (const e of object.itemIDs) {
                message.itemIDs.push(e);
            }
        }
        return message;
    }
};
const baseMsgSendItemsResponse = {};
export const MsgSendItemsResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSendItemsResponse };
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
        const message = { ...baseMsgSendItemsResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgSendItemsResponse };
        return message;
    }
};
const baseMsgExecuteRecipe = { creator: '', cookbookID: '', recipeID: '', itemIDs: '' };
export const MsgExecuteRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.cookbookID !== '') {
            writer.uint32(18).string(message.cookbookID);
        }
        if (message.recipeID !== '') {
            writer.uint32(26).string(message.recipeID);
        }
        for (const v of message.itemIDs) {
            writer.uint32(34).string(v);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgExecuteRecipe };
        message.itemIDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.cookbookID = reader.string();
                    break;
                case 3:
                    message.recipeID = reader.string();
                    break;
                case 4:
                    message.itemIDs.push(reader.string());
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
        message.itemIDs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        if (object.recipeID !== undefined && object.recipeID !== null) {
            message.recipeID = String(object.recipeID);
        }
        else {
            message.recipeID = '';
        }
        if (object.itemIDs !== undefined && object.itemIDs !== null) {
            for (const e of object.itemIDs) {
                message.itemIDs.push(String(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        message.recipeID !== undefined && (obj.recipeID = message.recipeID);
        if (message.itemIDs) {
            obj.itemIDs = message.itemIDs.map((e) => e);
        }
        else {
            obj.itemIDs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgExecuteRecipe };
        message.itemIDs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        if (object.recipeID !== undefined && object.recipeID !== null) {
            message.recipeID = object.recipeID;
        }
        else {
            message.recipeID = '';
        }
        if (object.itemIDs !== undefined && object.itemIDs !== null) {
            for (const e of object.itemIDs) {
                message.itemIDs.push(e);
            }
        }
        return message;
    }
};
const baseMsgExecuteRecipeResponse = { ID: '' };
export const MsgExecuteRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
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
                    message.ID = reader.string();
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
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.ID !== undefined && (obj.ID = message.ID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgExecuteRecipeResponse };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        return message;
    }
};
const baseMsgSetItemString = { creator: '', cookbookID: '', ID: '', field: '', value: '' };
export const MsgSetItemString = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.cookbookID !== '') {
            writer.uint32(18).string(message.cookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(34).string(message.ID);
        }
        if (message.field !== '') {
            writer.uint32(42).string(message.field);
        }
        if (message.value !== '') {
            writer.uint32(50).string(message.value);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSetItemString };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.cookbookID = reader.string();
                    break;
                case 4:
                    message.ID = reader.string();
                    break;
                case 5:
                    message.field = reader.string();
                    break;
                case 6:
                    message.value = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseMsgSetItemString };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.field !== undefined && object.field !== null) {
            message.field = String(object.field);
        }
        else {
            message.field = '';
        }
        if (object.value !== undefined && object.value !== null) {
            message.value = String(object.value);
        }
        else {
            message.value = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
        message.field !== undefined && (obj.field = message.field);
        message.value !== undefined && (obj.value = message.value);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgSetItemString };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.field !== undefined && object.field !== null) {
            message.field = object.field;
        }
        else {
            message.field = '';
        }
        if (object.value !== undefined && object.value !== null) {
            message.value = object.value;
        }
        else {
            message.value = '';
        }
        return message;
    }
};
const baseMsgSetItemStringResponse = {};
export const MsgSetItemStringResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgSetItemStringResponse };
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
        const message = { ...baseMsgSetItemStringResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgSetItemStringResponse };
        return message;
    }
};
const baseMsgCreateRecipe = {
    creator: '',
    cookbookID: '',
    ID: '',
    name: '',
    description: '',
    version: '',
    blockInterval: 0,
    enabled: false,
    extraInfo: ''
};
export const MsgCreateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.cookbookID !== '') {
            writer.uint32(18).string(message.cookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(26).string(message.ID);
        }
        if (message.name !== '') {
            writer.uint32(34).string(message.name);
        }
        if (message.description !== '') {
            writer.uint32(42).string(message.description);
        }
        if (message.version !== '') {
            writer.uint32(50).string(message.version);
        }
        for (const v of message.coinInputs) {
            Coin.encode(v, writer.uint32(58).fork()).ldelim();
        }
        for (const v of message.itemInputs) {
            ItemInput.encode(v, writer.uint32(66).fork()).ldelim();
        }
        if (message.entries !== undefined) {
            EntriesList.encode(message.entries, writer.uint32(74).fork()).ldelim();
        }
        for (const v of message.outputs) {
            WeightedOutputs.encode(v, writer.uint32(82).fork()).ldelim();
        }
        if (message.blockInterval !== 0) {
            writer.uint32(88).int64(message.blockInterval);
        }
        if (message.enabled === true) {
            writer.uint32(96).bool(message.enabled);
        }
        if (message.extraInfo !== '') {
            writer.uint32(106).string(message.extraInfo);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateRecipe };
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.cookbookID = reader.string();
                    break;
                case 3:
                    message.ID = reader.string();
                    break;
                case 4:
                    message.name = reader.string();
                    break;
                case 5:
                    message.description = reader.string();
                    break;
                case 6:
                    message.version = reader.string();
                    break;
                case 7:
                    message.coinInputs.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 8:
                    message.itemInputs.push(ItemInput.decode(reader, reader.uint32()));
                    break;
                case 9:
                    message.entries = EntriesList.decode(reader, reader.uint32());
                    break;
                case 10:
                    message.outputs.push(WeightedOutputs.decode(reader, reader.uint32()));
                    break;
                case 11:
                    message.blockInterval = longToNumber(reader.int64());
                    break;
                case 12:
                    message.enabled = reader.bool();
                    break;
                case 13:
                    message.extraInfo = reader.string();
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
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = String(object.name);
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = String(object.description);
        }
        else {
            message.description = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = String(object.version);
        }
        else {
            message.version = '';
        }
        if (object.coinInputs !== undefined && object.coinInputs !== null) {
            for (const e of object.coinInputs) {
                message.coinInputs.push(Coin.fromJSON(e));
            }
        }
        if (object.itemInputs !== undefined && object.itemInputs !== null) {
            for (const e of object.itemInputs) {
                message.itemInputs.push(ItemInput.fromJSON(e));
            }
        }
        if (object.entries !== undefined && object.entries !== null) {
            message.entries = EntriesList.fromJSON(object.entries);
        }
        else {
            message.entries = undefined;
        }
        if (object.outputs !== undefined && object.outputs !== null) {
            for (const e of object.outputs) {
                message.outputs.push(WeightedOutputs.fromJSON(e));
            }
        }
        if (object.blockInterval !== undefined && object.blockInterval !== null) {
            message.blockInterval = Number(object.blockInterval);
        }
        else {
            message.blockInterval = 0;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = Boolean(object.enabled);
        }
        else {
            message.enabled = false;
        }
        if (object.extraInfo !== undefined && object.extraInfo !== null) {
            message.extraInfo = String(object.extraInfo);
        }
        else {
            message.extraInfo = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
        message.name !== undefined && (obj.name = message.name);
        message.description !== undefined && (obj.description = message.description);
        message.version !== undefined && (obj.version = message.version);
        if (message.coinInputs) {
            obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.coinInputs = [];
        }
        if (message.itemInputs) {
            obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined));
        }
        else {
            obj.itemInputs = [];
        }
        message.entries !== undefined && (obj.entries = message.entries ? EntriesList.toJSON(message.entries) : undefined);
        if (message.outputs) {
            obj.outputs = message.outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined));
        }
        else {
            obj.outputs = [];
        }
        message.blockInterval !== undefined && (obj.blockInterval = message.blockInterval);
        message.enabled !== undefined && (obj.enabled = message.enabled);
        message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateRecipe };
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = object.name;
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = object.description;
        }
        else {
            message.description = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = object.version;
        }
        else {
            message.version = '';
        }
        if (object.coinInputs !== undefined && object.coinInputs !== null) {
            for (const e of object.coinInputs) {
                message.coinInputs.push(Coin.fromPartial(e));
            }
        }
        if (object.itemInputs !== undefined && object.itemInputs !== null) {
            for (const e of object.itemInputs) {
                message.itemInputs.push(ItemInput.fromPartial(e));
            }
        }
        if (object.entries !== undefined && object.entries !== null) {
            message.entries = EntriesList.fromPartial(object.entries);
        }
        else {
            message.entries = undefined;
        }
        if (object.outputs !== undefined && object.outputs !== null) {
            for (const e of object.outputs) {
                message.outputs.push(WeightedOutputs.fromPartial(e));
            }
        }
        if (object.blockInterval !== undefined && object.blockInterval !== null) {
            message.blockInterval = object.blockInterval;
        }
        else {
            message.blockInterval = 0;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = object.enabled;
        }
        else {
            message.enabled = false;
        }
        if (object.extraInfo !== undefined && object.extraInfo !== null) {
            message.extraInfo = object.extraInfo;
        }
        else {
            message.extraInfo = '';
        }
        return message;
    }
};
const baseMsgCreateRecipeResponse = {};
export const MsgCreateRecipeResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateRecipeResponse };
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
        const message = { ...baseMsgCreateRecipeResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgCreateRecipeResponse };
        return message;
    }
};
const baseMsgUpdateRecipe = {
    creator: '',
    cookbookID: '',
    ID: '',
    name: '',
    description: '',
    version: '',
    blockInterval: 0,
    enabled: false,
    extraInfo: ''
};
export const MsgUpdateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.cookbookID !== '') {
            writer.uint32(18).string(message.cookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(26).string(message.ID);
        }
        if (message.name !== '') {
            writer.uint32(34).string(message.name);
        }
        if (message.description !== '') {
            writer.uint32(42).string(message.description);
        }
        if (message.version !== '') {
            writer.uint32(50).string(message.version);
        }
        for (const v of message.coinInputs) {
            Coin.encode(v, writer.uint32(58).fork()).ldelim();
        }
        for (const v of message.itemInputs) {
            ItemInput.encode(v, writer.uint32(66).fork()).ldelim();
        }
        if (message.entries !== undefined) {
            EntriesList.encode(message.entries, writer.uint32(74).fork()).ldelim();
        }
        for (const v of message.outputs) {
            WeightedOutputs.encode(v, writer.uint32(82).fork()).ldelim();
        }
        if (message.blockInterval !== 0) {
            writer.uint32(88).int64(message.blockInterval);
        }
        if (message.enabled === true) {
            writer.uint32(96).bool(message.enabled);
        }
        if (message.extraInfo !== '') {
            writer.uint32(106).string(message.extraInfo);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateRecipe };
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.cookbookID = reader.string();
                    break;
                case 3:
                    message.ID = reader.string();
                    break;
                case 4:
                    message.name = reader.string();
                    break;
                case 5:
                    message.description = reader.string();
                    break;
                case 6:
                    message.version = reader.string();
                    break;
                case 7:
                    message.coinInputs.push(Coin.decode(reader, reader.uint32()));
                    break;
                case 8:
                    message.itemInputs.push(ItemInput.decode(reader, reader.uint32()));
                    break;
                case 9:
                    message.entries = EntriesList.decode(reader, reader.uint32());
                    break;
                case 10:
                    message.outputs.push(WeightedOutputs.decode(reader, reader.uint32()));
                    break;
                case 11:
                    message.blockInterval = longToNumber(reader.int64());
                    break;
                case 12:
                    message.enabled = reader.bool();
                    break;
                case 13:
                    message.extraInfo = reader.string();
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
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = String(object.cookbookID);
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = String(object.name);
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = String(object.description);
        }
        else {
            message.description = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = String(object.version);
        }
        else {
            message.version = '';
        }
        if (object.coinInputs !== undefined && object.coinInputs !== null) {
            for (const e of object.coinInputs) {
                message.coinInputs.push(Coin.fromJSON(e));
            }
        }
        if (object.itemInputs !== undefined && object.itemInputs !== null) {
            for (const e of object.itemInputs) {
                message.itemInputs.push(ItemInput.fromJSON(e));
            }
        }
        if (object.entries !== undefined && object.entries !== null) {
            message.entries = EntriesList.fromJSON(object.entries);
        }
        else {
            message.entries = undefined;
        }
        if (object.outputs !== undefined && object.outputs !== null) {
            for (const e of object.outputs) {
                message.outputs.push(WeightedOutputs.fromJSON(e));
            }
        }
        if (object.blockInterval !== undefined && object.blockInterval !== null) {
            message.blockInterval = Number(object.blockInterval);
        }
        else {
            message.blockInterval = 0;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = Boolean(object.enabled);
        }
        else {
            message.enabled = false;
        }
        if (object.extraInfo !== undefined && object.extraInfo !== null) {
            message.extraInfo = String(object.extraInfo);
        }
        else {
            message.extraInfo = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
        message.name !== undefined && (obj.name = message.name);
        message.description !== undefined && (obj.description = message.description);
        message.version !== undefined && (obj.version = message.version);
        if (message.coinInputs) {
            obj.coinInputs = message.coinInputs.map((e) => (e ? Coin.toJSON(e) : undefined));
        }
        else {
            obj.coinInputs = [];
        }
        if (message.itemInputs) {
            obj.itemInputs = message.itemInputs.map((e) => (e ? ItemInput.toJSON(e) : undefined));
        }
        else {
            obj.itemInputs = [];
        }
        message.entries !== undefined && (obj.entries = message.entries ? EntriesList.toJSON(message.entries) : undefined);
        if (message.outputs) {
            obj.outputs = message.outputs.map((e) => (e ? WeightedOutputs.toJSON(e) : undefined));
        }
        else {
            obj.outputs = [];
        }
        message.blockInterval !== undefined && (obj.blockInterval = message.blockInterval);
        message.enabled !== undefined && (obj.enabled = message.enabled);
        message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateRecipe };
        message.coinInputs = [];
        message.itemInputs = [];
        message.outputs = [];
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.cookbookID !== undefined && object.cookbookID !== null) {
            message.cookbookID = object.cookbookID;
        }
        else {
            message.cookbookID = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = object.name;
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = object.description;
        }
        else {
            message.description = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = object.version;
        }
        else {
            message.version = '';
        }
        if (object.coinInputs !== undefined && object.coinInputs !== null) {
            for (const e of object.coinInputs) {
                message.coinInputs.push(Coin.fromPartial(e));
            }
        }
        if (object.itemInputs !== undefined && object.itemInputs !== null) {
            for (const e of object.itemInputs) {
                message.itemInputs.push(ItemInput.fromPartial(e));
            }
        }
        if (object.entries !== undefined && object.entries !== null) {
            message.entries = EntriesList.fromPartial(object.entries);
        }
        else {
            message.entries = undefined;
        }
        if (object.outputs !== undefined && object.outputs !== null) {
            for (const e of object.outputs) {
                message.outputs.push(WeightedOutputs.fromPartial(e));
            }
        }
        if (object.blockInterval !== undefined && object.blockInterval !== null) {
            message.blockInterval = object.blockInterval;
        }
        else {
            message.blockInterval = 0;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = object.enabled;
        }
        else {
            message.enabled = false;
        }
        if (object.extraInfo !== undefined && object.extraInfo !== null) {
            message.extraInfo = object.extraInfo;
        }
        else {
            message.extraInfo = '';
        }
        return message;
    }
};
const baseMsgUpdateRecipeResponse = {};
export const MsgUpdateRecipeResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateRecipeResponse };
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
        const message = { ...baseMsgUpdateRecipeResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgUpdateRecipeResponse };
        return message;
    }
};
const baseMsgCreateCookbook = { creator: '', ID: '', name: '', description: '', developer: '', version: '', supportEmail: '', enabled: false };
export const MsgCreateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.name !== '') {
            writer.uint32(26).string(message.name);
        }
        if (message.description !== '') {
            writer.uint32(34).string(message.description);
        }
        if (message.developer !== '') {
            writer.uint32(42).string(message.developer);
        }
        if (message.version !== '') {
            writer.uint32(50).string(message.version);
        }
        if (message.supportEmail !== '') {
            writer.uint32(58).string(message.supportEmail);
        }
        if (message.costPerBlock !== undefined) {
            Coin.encode(message.costPerBlock, writer.uint32(66).fork()).ldelim();
        }
        if (message.enabled === true) {
            writer.uint32(72).bool(message.enabled);
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
                    message.creator = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.name = reader.string();
                    break;
                case 4:
                    message.description = reader.string();
                    break;
                case 5:
                    message.developer = reader.string();
                    break;
                case 6:
                    message.version = reader.string();
                    break;
                case 7:
                    message.supportEmail = reader.string();
                    break;
                case 8:
                    message.costPerBlock = Coin.decode(reader, reader.uint32());
                    break;
                case 9:
                    message.enabled = reader.bool();
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
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = String(object.name);
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = String(object.description);
        }
        else {
            message.description = '';
        }
        if (object.developer !== undefined && object.developer !== null) {
            message.developer = String(object.developer);
        }
        else {
            message.developer = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = String(object.version);
        }
        else {
            message.version = '';
        }
        if (object.supportEmail !== undefined && object.supportEmail !== null) {
            message.supportEmail = String(object.supportEmail);
        }
        else {
            message.supportEmail = '';
        }
        if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
            message.costPerBlock = Coin.fromJSON(object.costPerBlock);
        }
        else {
            message.costPerBlock = undefined;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = Boolean(object.enabled);
        }
        else {
            message.enabled = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.ID !== undefined && (obj.ID = message.ID);
        message.name !== undefined && (obj.name = message.name);
        message.description !== undefined && (obj.description = message.description);
        message.developer !== undefined && (obj.developer = message.developer);
        message.version !== undefined && (obj.version = message.version);
        message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail);
        message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock ? Coin.toJSON(message.costPerBlock) : undefined);
        message.enabled !== undefined && (obj.enabled = message.enabled);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgCreateCookbook };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = object.name;
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = object.description;
        }
        else {
            message.description = '';
        }
        if (object.developer !== undefined && object.developer !== null) {
            message.developer = object.developer;
        }
        else {
            message.developer = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = object.version;
        }
        else {
            message.version = '';
        }
        if (object.supportEmail !== undefined && object.supportEmail !== null) {
            message.supportEmail = object.supportEmail;
        }
        else {
            message.supportEmail = '';
        }
        if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
            message.costPerBlock = Coin.fromPartial(object.costPerBlock);
        }
        else {
            message.costPerBlock = undefined;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = object.enabled;
        }
        else {
            message.enabled = false;
        }
        return message;
    }
};
const baseMsgCreateCookbookResponse = {};
export const MsgCreateCookbookResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgCreateCookbookResponse };
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
        const message = { ...baseMsgCreateCookbookResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgCreateCookbookResponse };
        return message;
    }
};
const baseMsgUpdateCookbook = { creator: '', ID: '', name: '', description: '', developer: '', version: '', supportEmail: '', enabled: false };
export const MsgUpdateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        if (message.name !== '') {
            writer.uint32(26).string(message.name);
        }
        if (message.description !== '') {
            writer.uint32(34).string(message.description);
        }
        if (message.developer !== '') {
            writer.uint32(42).string(message.developer);
        }
        if (message.version !== '') {
            writer.uint32(50).string(message.version);
        }
        if (message.supportEmail !== '') {
            writer.uint32(58).string(message.supportEmail);
        }
        if (message.costPerBlock !== undefined) {
            Coin.encode(message.costPerBlock, writer.uint32(66).fork()).ldelim();
        }
        if (message.enabled === true) {
            writer.uint32(72).bool(message.enabled);
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
                    message.creator = reader.string();
                    break;
                case 2:
                    message.ID = reader.string();
                    break;
                case 3:
                    message.name = reader.string();
                    break;
                case 4:
                    message.description = reader.string();
                    break;
                case 5:
                    message.developer = reader.string();
                    break;
                case 6:
                    message.version = reader.string();
                    break;
                case 7:
                    message.supportEmail = reader.string();
                    break;
                case 8:
                    message.costPerBlock = Coin.decode(reader, reader.uint32());
                    break;
                case 9:
                    message.enabled = reader.bool();
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
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = String(object.ID);
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = String(object.name);
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = String(object.description);
        }
        else {
            message.description = '';
        }
        if (object.developer !== undefined && object.developer !== null) {
            message.developer = String(object.developer);
        }
        else {
            message.developer = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = String(object.version);
        }
        else {
            message.version = '';
        }
        if (object.supportEmail !== undefined && object.supportEmail !== null) {
            message.supportEmail = String(object.supportEmail);
        }
        else {
            message.supportEmail = '';
        }
        if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
            message.costPerBlock = Coin.fromJSON(object.costPerBlock);
        }
        else {
            message.costPerBlock = undefined;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = Boolean(object.enabled);
        }
        else {
            message.enabled = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.ID !== undefined && (obj.ID = message.ID);
        message.name !== undefined && (obj.name = message.name);
        message.description !== undefined && (obj.description = message.description);
        message.developer !== undefined && (obj.developer = message.developer);
        message.version !== undefined && (obj.version = message.version);
        message.supportEmail !== undefined && (obj.supportEmail = message.supportEmail);
        message.costPerBlock !== undefined && (obj.costPerBlock = message.costPerBlock ? Coin.toJSON(message.costPerBlock) : undefined);
        message.enabled !== undefined && (obj.enabled = message.enabled);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseMsgUpdateCookbook };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = object.name;
        }
        else {
            message.name = '';
        }
        if (object.description !== undefined && object.description !== null) {
            message.description = object.description;
        }
        else {
            message.description = '';
        }
        if (object.developer !== undefined && object.developer !== null) {
            message.developer = object.developer;
        }
        else {
            message.developer = '';
        }
        if (object.version !== undefined && object.version !== null) {
            message.version = object.version;
        }
        else {
            message.version = '';
        }
        if (object.supportEmail !== undefined && object.supportEmail !== null) {
            message.supportEmail = object.supportEmail;
        }
        else {
            message.supportEmail = '';
        }
        if (object.costPerBlock !== undefined && object.costPerBlock !== null) {
            message.costPerBlock = Coin.fromPartial(object.costPerBlock);
        }
        else {
            message.costPerBlock = undefined;
        }
        if (object.enabled !== undefined && object.enabled !== null) {
            message.enabled = object.enabled;
        }
        else {
            message.enabled = false;
        }
        return message;
    }
};
const baseMsgUpdateCookbookResponse = {};
export const MsgUpdateCookbookResponse = {
    encode(_, writer = Writer.create()) {
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseMsgUpdateCookbookResponse };
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
        const message = { ...baseMsgUpdateCookbookResponse };
        return message;
    },
    toJSON(_) {
        const obj = {};
        return obj;
    },
    fromPartial(_) {
        const message = { ...baseMsgUpdateCookbookResponse };
        return message;
    }
};
export class MsgClientImpl {
    constructor(rpc) {
        this.rpc = rpc;
    }
    CompleteExecutionEarly(request) {
        const data = MsgCompleteExecutionEarly.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CompleteExecutionEarly', data);
        return promise.then((data) => MsgCompleteExecutionEarlyResponse.decode(new Reader(data)));
    }
    TransferCookbook(request) {
        const data = MsgTransferCookbook.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'TransferCookbook', data);
        return promise.then((data) => MsgTransferCookbookResponse.decode(new Reader(data)));
    }
    GoogleInAppPurchaseGetCoins(request) {
        const data = MsgGoogleInAppPurchaseGetCoins.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'GoogleInAppPurchaseGetCoins', data);
        return promise.then((data) => MsgGoogleInAppPurchaseGetCoinsResponse.decode(new Reader(data)));
    }
    CreateAccount(request) {
        const data = MsgCreateAccount.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateAccount', data);
        return promise.then((data) => MsgCreateAccountResponse.decode(new Reader(data)));
    }
    SendItems(request) {
        const data = MsgSendItems.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'SendItems', data);
        return promise.then((data) => MsgSendItemsResponse.decode(new Reader(data)));
    }
    ExecuteRecipe(request) {
        const data = MsgExecuteRecipe.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'ExecuteRecipe', data);
        return promise.then((data) => MsgExecuteRecipeResponse.decode(new Reader(data)));
    }
    SetItemString(request) {
        const data = MsgSetItemString.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'SetItemString', data);
        return promise.then((data) => MsgSetItemStringResponse.decode(new Reader(data)));
    }
    CreateRecipe(request) {
        const data = MsgCreateRecipe.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateRecipe', data);
        return promise.then((data) => MsgCreateRecipeResponse.decode(new Reader(data)));
    }
    UpdateRecipe(request) {
        const data = MsgUpdateRecipe.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateRecipe', data);
        return promise.then((data) => MsgUpdateRecipeResponse.decode(new Reader(data)));
    }
    CreateCookbook(request) {
        const data = MsgCreateCookbook.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'CreateCookbook', data);
        return promise.then((data) => MsgCreateCookbookResponse.decode(new Reader(data)));
    }
    UpdateCookbook(request) {
        const data = MsgUpdateCookbook.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Msg', 'UpdateCookbook', data);
        return promise.then((data) => MsgUpdateCookbookResponse.decode(new Reader(data)));
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
