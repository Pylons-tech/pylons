/* eslint-disable */
import { Cookbook, Recipe, Item } from '../pylons/pylons';
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'pylons';
const baseGenesisState = {};
export const GenesisState = {
    encode(message, writer = Writer.create()) {
        for (const v of message.cookbooks) {
            Cookbook.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.recipes) {
            Recipe.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.items) {
            Item.encode(v, writer.uint32(26).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGenesisState };
        message.cookbooks = [];
        message.recipes = [];
        message.items = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.cookbooks.push(Cookbook.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.recipes.push(Recipe.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.items.push(Item.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGenesisState };
        message.cookbooks = [];
        message.recipes = [];
        message.items = [];
        if (object.cookbooks !== undefined && object.cookbooks !== null) {
            for (const e of object.cookbooks) {
                message.cookbooks.push(Cookbook.fromJSON(e));
            }
        }
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromJSON(e));
            }
        }
        if (object.items !== undefined && object.items !== null) {
            for (const e of object.items) {
                message.items.push(Item.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.cookbooks) {
            obj.cookbooks = message.cookbooks.map((e) => (e ? Cookbook.toJSON(e) : undefined));
        }
        else {
            obj.cookbooks = [];
        }
        if (message.recipes) {
            obj.recipes = message.recipes.map((e) => (e ? Recipe.toJSON(e) : undefined));
        }
        else {
            obj.recipes = [];
        }
        if (message.items) {
            obj.items = message.items.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.items = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGenesisState };
        message.cookbooks = [];
        message.recipes = [];
        message.items = [];
        if (object.cookbooks !== undefined && object.cookbooks !== null) {
            for (const e of object.cookbooks) {
                message.cookbooks.push(Cookbook.fromPartial(e));
            }
        }
        if (object.recipes !== undefined && object.recipes !== null) {
            for (const e of object.recipes) {
                message.recipes.push(Recipe.fromPartial(e));
            }
        }
        if (object.items !== undefined && object.items !== null) {
            for (const e of object.items) {
                message.items.push(Item.fromPartial(e));
            }
        }
        return message;
    }
};
