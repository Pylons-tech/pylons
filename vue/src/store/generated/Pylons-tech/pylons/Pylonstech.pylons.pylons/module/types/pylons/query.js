/* eslint-disable */
import { Reader, Writer } from 'protobufjs/minimal';
import { Item } from '../pylons/item';
import { GoogleInAppPurchaseOrder } from '../pylons/google_iap_order';
import { Execution } from '../pylons/execution';
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseQueryListItemByOwnerRequest = { owner: '' };
export const QueryListItemByOwnerRequest = {
    encode(message, writer = Writer.create()) {
        if (message.owner !== '') {
            writer.uint32(10).string(message.owner);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListItemByOwnerRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.owner = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryListItemByOwnerRequest };
        if (object.owner !== undefined && object.owner !== null) {
            message.owner = String(object.owner);
        }
        else {
            message.owner = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.owner !== undefined && (obj.owner = message.owner);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryListItemByOwnerRequest };
        if (object.owner !== undefined && object.owner !== null) {
            message.owner = object.owner;
        }
        else {
            message.owner = '';
        }
        return message;
    }
};
const baseQueryListItemByOwnerResponse = {};
export const QueryListItemByOwnerResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Items) {
            Item.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListItemByOwnerResponse };
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
        const message = { ...baseQueryListItemByOwnerResponse };
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
        const message = { ...baseQueryListItemByOwnerResponse };
        message.Items = [];
        if (object.Items !== undefined && object.Items !== null) {
            for (const e of object.Items) {
                message.Items.push(Item.fromPartial(e));
            }
        }
        return message;
    }
};
const baseQueryGetGoogleInAppPurchaseOrderRequest = { PurchaseToken: '' };
export const QueryGetGoogleInAppPurchaseOrderRequest = {
    encode(message, writer = Writer.create()) {
        if (message.PurchaseToken !== '') {
            writer.uint32(10).string(message.PurchaseToken);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.PurchaseToken = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest };
        if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
            message.PurchaseToken = String(object.PurchaseToken);
        }
        else {
            message.PurchaseToken = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.PurchaseToken !== undefined && (obj.PurchaseToken = message.PurchaseToken);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderRequest };
        if (object.PurchaseToken !== undefined && object.PurchaseToken !== null) {
            message.PurchaseToken = object.PurchaseToken;
        }
        else {
            message.PurchaseToken = '';
        }
        return message;
    }
};
const baseQueryGetGoogleInAppPurchaseOrderResponse = {};
export const QueryGetGoogleInAppPurchaseOrderResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Order !== undefined) {
            GoogleInAppPurchaseOrder.encode(message.Order, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Order = GoogleInAppPurchaseOrder.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse };
        if (object.Order !== undefined && object.Order !== null) {
            message.Order = GoogleInAppPurchaseOrder.fromJSON(object.Order);
        }
        else {
            message.Order = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Order !== undefined && (obj.Order = message.Order ? GoogleInAppPurchaseOrder.toJSON(message.Order) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetGoogleInAppPurchaseOrderResponse };
        if (object.Order !== undefined && object.Order !== null) {
            message.Order = GoogleInAppPurchaseOrder.fromPartial(object.Order);
        }
        else {
            message.Order = undefined;
        }
        return message;
    }
};
const baseQueryListExecutionsByItemRequest = { CookbookID: '', ItemID: '' };
export const QueryListExecutionsByItemRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.ItemID !== '') {
            writer.uint32(18).string(message.ItemID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListExecutionsByItemRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
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
        const message = { ...baseQueryListExecutionsByItemRequest };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
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
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.ItemID !== undefined && (obj.ItemID = message.ItemID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryListExecutionsByItemRequest };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
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
const baseQueryListExecutionsByItemResponse = {};
export const QueryListExecutionsByItemResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Executions) {
            Execution.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListExecutionsByItemResponse };
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
        const message = { ...baseQueryListExecutionsByItemResponse };
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
        const message = { ...baseQueryListExecutionsByItemResponse };
        message.Executions = [];
        if (object.Executions !== undefined && object.Executions !== null) {
            for (const e of object.Executions) {
                message.Executions.push(Execution.fromPartial(e));
            }
        }
        return message;
    }
};
const baseQueryListExecutionsByRecipeRequest = { CookbookID: '', RecipeID: '' };
export const QueryListExecutionsByRecipeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.RecipeID !== '') {
            writer.uint32(18).string(message.RecipeID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListExecutionsByRecipeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 2:
                    message.RecipeID = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryListExecutionsByRecipeRequest };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = String(object.CookbookID);
        }
        else {
            message.CookbookID = '';
        }
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryListExecutionsByRecipeRequest };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
        }
        return message;
    }
};
const baseQueryListExecutionsByRecipeResponse = {};
export const QueryListExecutionsByRecipeResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Executions) {
            Execution.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListExecutionsByRecipeResponse };
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
        const message = { ...baseQueryListExecutionsByRecipeResponse };
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
        const message = { ...baseQueryListExecutionsByRecipeResponse };
        message.Executions = [];
        if (object.Executions !== undefined && object.Executions !== null) {
            for (const e of object.Executions) {
                message.Executions.push(Execution.fromPartial(e));
            }
        }
        return message;
    }
};
const baseQueryGetExecutionRequest = { ID: '' };
export const QueryGetExecutionRequest = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetExecutionRequest };
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
        const message = { ...baseQueryGetExecutionRequest };
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
        const message = { ...baseQueryGetExecutionRequest };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        return message;
    }
};
const baseQueryGetExecutionResponse = { Completed: false };
export const QueryGetExecutionResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Execution !== undefined) {
            Execution.encode(message.Execution, writer.uint32(10).fork()).ldelim();
        }
        if (message.Completed === true) {
            writer.uint32(16).bool(message.Completed);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetExecutionResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Execution = Execution.decode(reader, reader.uint32());
                    break;
                case 2:
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
        const message = { ...baseQueryGetExecutionResponse };
        if (object.Execution !== undefined && object.Execution !== null) {
            message.Execution = Execution.fromJSON(object.Execution);
        }
        else {
            message.Execution = undefined;
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
        message.Execution !== undefined && (obj.Execution = message.Execution ? Execution.toJSON(message.Execution) : undefined);
        message.Completed !== undefined && (obj.Completed = message.Completed);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetExecutionResponse };
        if (object.Execution !== undefined && object.Execution !== null) {
            message.Execution = Execution.fromPartial(object.Execution);
        }
        else {
            message.Execution = undefined;
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
const baseQueryListRecipesByCookbookRequest = { CookbookID: '' };
export const QueryListRecipesByCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListRecipesByCookbookRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
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
        const message = { ...baseQueryListRecipesByCookbookRequest };
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
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryListRecipesByCookbookRequest };
        if (object.CookbookID !== undefined && object.CookbookID !== null) {
            message.CookbookID = object.CookbookID;
        }
        else {
            message.CookbookID = '';
        }
        return message;
    }
};
const baseQueryListRecipesByCookbookResponse = {};
export const QueryListRecipesByCookbookResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Recipes) {
            Recipe.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListRecipesByCookbookResponse };
        message.Recipes = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Recipes.push(Recipe.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryListRecipesByCookbookResponse };
        message.Recipes = [];
        if (object.Recipes !== undefined && object.Recipes !== null) {
            for (const e of object.Recipes) {
                message.Recipes.push(Recipe.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Recipes) {
            obj.Recipes = message.Recipes.map((e) => (e ? Recipe.toJSON(e) : undefined));
        }
        else {
            obj.Recipes = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryListRecipesByCookbookResponse };
        message.Recipes = [];
        if (object.Recipes !== undefined && object.Recipes !== null) {
            for (const e of object.Recipes) {
                message.Recipes.push(Recipe.fromPartial(e));
            }
        }
        return message;
    }
};
const baseQueryGetItemRequest = { CookbookID: '', ID: '' };
export const QueryGetItemRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(26).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetItemRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
                    break;
                case 3:
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
        const message = { ...baseQueryGetItemRequest };
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetItemRequest };
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
        return message;
    }
};
const baseQueryGetItemResponse = {};
export const QueryGetItemResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Item !== undefined) {
            Item.encode(message.Item, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetItemResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Item = Item.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryGetItemResponse };
        if (object.Item !== undefined && object.Item !== null) {
            message.Item = Item.fromJSON(object.Item);
        }
        else {
            message.Item = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Item !== undefined && (obj.Item = message.Item ? Item.toJSON(message.Item) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetItemResponse };
        if (object.Item !== undefined && object.Item !== null) {
            message.Item = Item.fromPartial(object.Item);
        }
        else {
            message.Item = undefined;
        }
        return message;
    }
};
const baseQueryGetRecipeRequest = { CookbookID: '', ID: '' };
export const QueryGetRecipeRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.ID !== '') {
            writer.uint32(18).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetRecipeRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CookbookID = reader.string();
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
        const message = { ...baseQueryGetRecipeRequest };
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CookbookID !== undefined && (obj.CookbookID = message.CookbookID);
        message.ID !== undefined && (obj.ID = message.ID);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetRecipeRequest };
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
        return message;
    }
};
const baseQueryGetRecipeResponse = {};
export const QueryGetRecipeResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Recipe !== undefined) {
            Recipe.encode(message.Recipe, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetRecipeResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Recipe = Recipe.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryGetRecipeResponse };
        if (object.Recipe !== undefined && object.Recipe !== null) {
            message.Recipe = Recipe.fromJSON(object.Recipe);
        }
        else {
            message.Recipe = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Recipe !== undefined && (obj.Recipe = message.Recipe ? Recipe.toJSON(message.Recipe) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetRecipeResponse };
        if (object.Recipe !== undefined && object.Recipe !== null) {
            message.Recipe = Recipe.fromPartial(object.Recipe);
        }
        else {
            message.Recipe = undefined;
        }
        return message;
    }
};
const baseQueryListCookbooksByCreatorRequest = { creator: '' };
export const QueryListCookbooksByCreatorRequest = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== '') {
            writer.uint32(10).string(message.creator);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListCookbooksByCreatorRequest };
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
        const message = { ...baseQueryListCookbooksByCreatorRequest };
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
        const message = { ...baseQueryListCookbooksByCreatorRequest };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        return message;
    }
};
const baseQueryListCookbooksByCreatorResponse = {};
export const QueryListCookbooksByCreatorResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Cookbooks) {
            Cookbook.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryListCookbooksByCreatorResponse };
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
        const message = { ...baseQueryListCookbooksByCreatorResponse };
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
        const message = { ...baseQueryListCookbooksByCreatorResponse };
        message.Cookbooks = [];
        if (object.Cookbooks !== undefined && object.Cookbooks !== null) {
            for (const e of object.Cookbooks) {
                message.Cookbooks.push(Cookbook.fromPartial(e));
            }
        }
        return message;
    }
};
const baseQueryGetCookbookRequest = { ID: '' };
export const QueryGetCookbookRequest = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== '') {
            writer.uint32(10).string(message.ID);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetCookbookRequest };
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
        const message = { ...baseQueryGetCookbookRequest };
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
        const message = { ...baseQueryGetCookbookRequest };
        if (object.ID !== undefined && object.ID !== null) {
            message.ID = object.ID;
        }
        else {
            message.ID = '';
        }
        return message;
    }
};
const baseQueryGetCookbookResponse = {};
export const QueryGetCookbookResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Cookbook !== undefined) {
            Cookbook.encode(message.Cookbook, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryGetCookbookResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Cookbook = Cookbook.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryGetCookbookResponse };
        if (object.Cookbook !== undefined && object.Cookbook !== null) {
            message.Cookbook = Cookbook.fromJSON(object.Cookbook);
        }
        else {
            message.Cookbook = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Cookbook !== undefined && (obj.Cookbook = message.Cookbook ? Cookbook.toJSON(message.Cookbook) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryGetCookbookResponse };
        if (object.Cookbook !== undefined && object.Cookbook !== null) {
            message.Cookbook = Cookbook.fromPartial(object.Cookbook);
        }
        else {
            message.Cookbook = undefined;
        }
        return message;
    }
};
export class QueryClientImpl {
    constructor(rpc) {
        this.rpc = rpc;
    }
    ListItemByOwner(request) {
        const data = QueryListItemByOwnerRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListItemByOwner', data);
        return promise.then((data) => QueryListItemByOwnerResponse.decode(new Reader(data)));
    }
    GoogleInAppPurchaseOrder(request) {
        const data = QueryGetGoogleInAppPurchaseOrderRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'GoogleInAppPurchaseOrder', data);
        return promise.then((data) => QueryGetGoogleInAppPurchaseOrderResponse.decode(new Reader(data)));
    }
    ListExecutionsByItem(request) {
        const data = QueryListExecutionsByItemRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListExecutionsByItem', data);
        return promise.then((data) => QueryListExecutionsByItemResponse.decode(new Reader(data)));
    }
    ListExecutionsByRecipe(request) {
        const data = QueryListExecutionsByRecipeRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListExecutionsByRecipe', data);
        return promise.then((data) => QueryListExecutionsByRecipeResponse.decode(new Reader(data)));
    }
    Execution(request) {
        const data = QueryGetExecutionRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Execution', data);
        return promise.then((data) => QueryGetExecutionResponse.decode(new Reader(data)));
    }
    ListRecipesByCookbook(request) {
        const data = QueryListRecipesByCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListRecipesByCookbook', data);
        return promise.then((data) => QueryListRecipesByCookbookResponse.decode(new Reader(data)));
    }
    Item(request) {
        const data = QueryGetItemRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Item', data);
        return promise.then((data) => QueryGetItemResponse.decode(new Reader(data)));
    }
    Recipe(request) {
        const data = QueryGetRecipeRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Recipe', data);
        return promise.then((data) => QueryGetRecipeResponse.decode(new Reader(data)));
    }
    ListCookbooksByCreator(request) {
        const data = QueryListCookbooksByCreatorRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'ListCookbooksByCreator', data);
        return promise.then((data) => QueryListCookbooksByCreatorResponse.decode(new Reader(data)));
    }
    Cookbook(request) {
        const data = QueryGetCookbookRequest.encode(request).finish();
        const promise = this.rpc.request('Pylonstech.pylons.pylons.Query', 'Cookbook', data);
        return promise.then((data) => QueryGetCookbookResponse.decode(new Reader(data)));
    }
}
