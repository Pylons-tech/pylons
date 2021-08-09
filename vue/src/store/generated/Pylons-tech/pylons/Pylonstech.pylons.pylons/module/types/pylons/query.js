/* eslint-disable */
import { Reader, util, configure, Writer } from 'protobufjs/minimal';
import * as Long from 'long';
import { Execution } from '../pylons/execution';
import { PageRequest, PageResponse } from '../cosmos/base/query/v1beta1/pagination';
import { Recipe } from '../pylons/recipe';
import { Item } from '../pylons/item';
import { Cookbook } from '../pylons/cookbook';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseQueryGetExecutionRequest = { ID: 0 };
export const QueryGetExecutionRequest = {
    encode(message, writer = Writer.create()) {
        if (message.ID !== 0) {
            writer.uint32(8).uint64(message.ID);
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
                    message.ID = longToNumber(reader.uint64());
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
            message.ID = Number(object.ID);
        }
        else {
            message.ID = 0;
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
            message.ID = 0;
        }
        return message;
    }
};
const baseQueryGetExecutionResponse = {};
export const QueryGetExecutionResponse = {
    encode(message, writer = Writer.create()) {
        if (message.Execution !== undefined) {
            Execution.encode(message.Execution, writer.uint32(10).fork()).ldelim();
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.Execution !== undefined && (obj.Execution = message.Execution ? Execution.toJSON(message.Execution) : undefined);
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
        return message;
    }
};
const baseQueryAllExecutionRequest = {};
export const QueryAllExecutionRequest = {
    encode(message, writer = Writer.create()) {
        if (message.pagination !== undefined) {
            PageRequest.encode(message.pagination, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryAllExecutionRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.pagination = PageRequest.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryAllExecutionRequest };
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageRequest.fromJSON(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryAllExecutionRequest };
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageRequest.fromPartial(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    }
};
const baseQueryAllExecutionResponse = {};
export const QueryAllExecutionResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Execution) {
            Execution.encode(v, writer.uint32(10).fork()).ldelim();
        }
        if (message.pagination !== undefined) {
            PageResponse.encode(message.pagination, writer.uint32(18).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryAllExecutionResponse };
        message.Execution = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Execution.push(Execution.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.pagination = PageResponse.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryAllExecutionResponse };
        message.Execution = [];
        if (object.Execution !== undefined && object.Execution !== null) {
            for (const e of object.Execution) {
                message.Execution.push(Execution.fromJSON(e));
            }
        }
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageResponse.fromJSON(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Execution) {
            obj.Execution = message.Execution.map((e) => (e ? Execution.toJSON(e) : undefined));
        }
        else {
            obj.Execution = [];
        }
        message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryAllExecutionResponse };
        message.Execution = [];
        if (object.Execution !== undefined && object.Execution !== null) {
            for (const e of object.Execution) {
                message.Execution.push(Execution.fromPartial(e));
            }
        }
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageResponse.fromPartial(object.pagination);
        }
        else {
            message.pagination = undefined;
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
const baseQueryGetItemRequest = { CookbookID: '', RecipeID: '', ID: '' };
export const QueryGetItemRequest = {
    encode(message, writer = Writer.create()) {
        if (message.CookbookID !== '') {
            writer.uint32(10).string(message.CookbookID);
        }
        if (message.RecipeID !== '') {
            writer.uint32(18).string(message.RecipeID);
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
                case 2:
                    message.RecipeID = reader.string();
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
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = String(object.RecipeID);
        }
        else {
            message.RecipeID = '';
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
        message.RecipeID !== undefined && (obj.RecipeID = message.RecipeID);
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
        if (object.RecipeID !== undefined && object.RecipeID !== null) {
            message.RecipeID = object.RecipeID;
        }
        else {
            message.RecipeID = '';
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
const baseQueryAllItemRequest = {};
export const QueryAllItemRequest = {
    encode(message, writer = Writer.create()) {
        if (message.pagination !== undefined) {
            PageRequest.encode(message.pagination, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryAllItemRequest };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.pagination = PageRequest.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryAllItemRequest };
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageRequest.fromJSON(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.pagination !== undefined && (obj.pagination = message.pagination ? PageRequest.toJSON(message.pagination) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryAllItemRequest };
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageRequest.fromPartial(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    }
};
const baseQueryAllItemResponse = {};
export const QueryAllItemResponse = {
    encode(message, writer = Writer.create()) {
        for (const v of message.Item) {
            Item.encode(v, writer.uint32(10).fork()).ldelim();
        }
        if (message.pagination !== undefined) {
            PageResponse.encode(message.pagination, writer.uint32(18).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseQueryAllItemResponse };
        message.Item = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.Item.push(Item.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.pagination = PageResponse.decode(reader, reader.uint32());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseQueryAllItemResponse };
        message.Item = [];
        if (object.Item !== undefined && object.Item !== null) {
            for (const e of object.Item) {
                message.Item.push(Item.fromJSON(e));
            }
        }
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageResponse.fromJSON(object.pagination);
        }
        else {
            message.pagination = undefined;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.Item) {
            obj.Item = message.Item.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.Item = [];
        }
        message.pagination !== undefined && (obj.pagination = message.pagination ? PageResponse.toJSON(message.pagination) : undefined);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseQueryAllItemResponse };
        message.Item = [];
        if (object.Item !== undefined && object.Item !== null) {
            for (const e of object.Item) {
                message.Item.push(Item.fromPartial(e));
            }
        }
        if (object.pagination !== undefined && object.pagination !== null) {
            message.pagination = PageResponse.fromPartial(object.pagination);
        }
        else {
            message.pagination = undefined;
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
