/* eslint-disable */
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseGenesisState = {};
export const GenesisState = {
    encode(message, writer = Writer.create()) {
        for (const v of message.recipeList) {
            Recipe.encode(v, writer.uint32(18).fork()).ldelim();
        }
        for (const v of message.cookbookList) {
            Cookbook.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGenesisState };
        message.recipeList = [];
        message.cookbookList = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.recipeList.push(Recipe.decode(reader, reader.uint32()));
                    break;
                case 1:
                    message.cookbookList.push(Cookbook.decode(reader, reader.uint32()));
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
        message.recipeList = [];
        message.cookbookList = [];
        if (object.recipeList !== undefined && object.recipeList !== null) {
            for (const e of object.recipeList) {
                message.recipeList.push(Recipe.fromJSON(e));
            }
        }
        if (object.cookbookList !== undefined && object.cookbookList !== null) {
            for (const e of object.cookbookList) {
                message.cookbookList.push(Cookbook.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.recipeList) {
            obj.recipeList = message.recipeList.map((e) => (e ? Recipe.toJSON(e) : undefined));
        }
        else {
            obj.recipeList = [];
        }
        if (message.cookbookList) {
            obj.cookbookList = message.cookbookList.map((e) => (e ? Cookbook.toJSON(e) : undefined));
        }
        else {
            obj.cookbookList = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGenesisState };
        message.recipeList = [];
        message.cookbookList = [];
        if (object.recipeList !== undefined && object.recipeList !== null) {
            for (const e of object.recipeList) {
                message.recipeList.push(Recipe.fromPartial(e));
            }
        }
        if (object.cookbookList !== undefined && object.cookbookList !== null) {
            for (const e of object.cookbookList) {
                message.cookbookList.push(Cookbook.fromPartial(e));
            }
        }
        return message;
    }
};
