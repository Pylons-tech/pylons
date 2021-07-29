/* eslint-disable */
import { Reader, Writer } from 'protobufjs/minimal';
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
export const protobufPackage = 'Pylonstech.pylons.pylons';
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
