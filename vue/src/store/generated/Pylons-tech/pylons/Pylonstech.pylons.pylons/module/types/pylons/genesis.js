/* eslint-disable */
import * as Long from 'long';
import { util, configure, Writer, Reader } from 'protobufjs/minimal';
import { Username } from '../pylons/username';
import { Trade } from '../pylons/trade';
import { Params } from '../pylons/params';
import { GoogleInAppPurchaseOrder } from '../pylons/google_iap_order';
import { Execution } from '../pylons/execution';
import { Item } from '../pylons/item';
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseGenesisState = { tradeCount: 0, entityCount: 0, googleIAPOrderCount: 0, executionCount: 0, pendingExecutionCount: 0 };
export const GenesisState = {
    encode(message, writer = Writer.create()) {
        for (const v of message.usernameList) {
            Username.encode(v, writer.uint32(114).fork()).ldelim();
        }
        for (const v of message.tradeList) {
            Trade.encode(v, writer.uint32(98).fork()).ldelim();
        }
        if (message.tradeCount !== 0) {
            writer.uint32(104).uint64(message.tradeCount);
        }
        if (message.entityCount !== 0) {
            writer.uint32(88).uint64(message.entityCount);
        }
        if (message.params !== undefined) {
            Params.encode(message.params, writer.uint32(82).fork()).ldelim();
        }
        for (const v of message.googleInAppPurchaseOrderList) {
            GoogleInAppPurchaseOrder.encode(v, writer.uint32(66).fork()).ldelim();
        }
        if (message.googleIAPOrderCount !== 0) {
            writer.uint32(72).uint64(message.googleIAPOrderCount);
        }
        for (const v of message.executionList) {
            Execution.encode(v, writer.uint32(58).fork()).ldelim();
        }
        if (message.executionCount !== 0) {
            writer.uint32(48).uint64(message.executionCount);
        }
        for (const v of message.pendingExecutionList) {
            Execution.encode(v, writer.uint32(42).fork()).ldelim();
        }
        if (message.pendingExecutionCount !== 0) {
            writer.uint32(32).uint64(message.pendingExecutionCount);
        }
        for (const v of message.itemList) {
            Item.encode(v, writer.uint32(26).fork()).ldelim();
        }
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
        message.usernameList = [];
        message.tradeList = [];
        message.googleInAppPurchaseOrderList = [];
        message.executionList = [];
        message.pendingExecutionList = [];
        message.itemList = [];
        message.recipeList = [];
        message.cookbookList = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 14:
                    message.usernameList.push(Username.decode(reader, reader.uint32()));
                    break;
                case 12:
                    message.tradeList.push(Trade.decode(reader, reader.uint32()));
                    break;
                case 13:
                    message.tradeCount = longToNumber(reader.uint64());
                    break;
                case 11:
                    message.entityCount = longToNumber(reader.uint64());
                    break;
                case 10:
                    message.params = Params.decode(reader, reader.uint32());
                    break;
                case 8:
                    message.googleInAppPurchaseOrderList.push(GoogleInAppPurchaseOrder.decode(reader, reader.uint32()));
                    break;
                case 9:
                    message.googleIAPOrderCount = longToNumber(reader.uint64());
                    break;
                case 7:
                    message.executionList.push(Execution.decode(reader, reader.uint32()));
                    break;
                case 6:
                    message.executionCount = longToNumber(reader.uint64());
                    break;
                case 5:
                    message.pendingExecutionList.push(Execution.decode(reader, reader.uint32()));
                    break;
                case 4:
                    message.pendingExecutionCount = longToNumber(reader.uint64());
                    break;
                case 3:
                    message.itemList.push(Item.decode(reader, reader.uint32()));
                    break;
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
        message.usernameList = [];
        message.tradeList = [];
        message.googleInAppPurchaseOrderList = [];
        message.executionList = [];
        message.pendingExecutionList = [];
        message.itemList = [];
        message.recipeList = [];
        message.cookbookList = [];
        if (object.usernameList !== undefined && object.usernameList !== null) {
            for (const e of object.usernameList) {
                message.usernameList.push(Username.fromJSON(e));
            }
        }
        if (object.tradeList !== undefined && object.tradeList !== null) {
            for (const e of object.tradeList) {
                message.tradeList.push(Trade.fromJSON(e));
            }
        }
        if (object.tradeCount !== undefined && object.tradeCount !== null) {
            message.tradeCount = Number(object.tradeCount);
        }
        else {
            message.tradeCount = 0;
        }
        if (object.entityCount !== undefined && object.entityCount !== null) {
            message.entityCount = Number(object.entityCount);
        }
        else {
            message.entityCount = 0;
        }
        if (object.params !== undefined && object.params !== null) {
            message.params = Params.fromJSON(object.params);
        }
        else {
            message.params = undefined;
        }
        if (object.googleInAppPurchaseOrderList !== undefined && object.googleInAppPurchaseOrderList !== null) {
            for (const e of object.googleInAppPurchaseOrderList) {
                message.googleInAppPurchaseOrderList.push(GoogleInAppPurchaseOrder.fromJSON(e));
            }
        }
        if (object.googleIAPOrderCount !== undefined && object.googleIAPOrderCount !== null) {
            message.googleIAPOrderCount = Number(object.googleIAPOrderCount);
        }
        else {
            message.googleIAPOrderCount = 0;
        }
        if (object.executionList !== undefined && object.executionList !== null) {
            for (const e of object.executionList) {
                message.executionList.push(Execution.fromJSON(e));
            }
        }
        if (object.executionCount !== undefined && object.executionCount !== null) {
            message.executionCount = Number(object.executionCount);
        }
        else {
            message.executionCount = 0;
        }
        if (object.pendingExecutionList !== undefined && object.pendingExecutionList !== null) {
            for (const e of object.pendingExecutionList) {
                message.pendingExecutionList.push(Execution.fromJSON(e));
            }
        }
        if (object.pendingExecutionCount !== undefined && object.pendingExecutionCount !== null) {
            message.pendingExecutionCount = Number(object.pendingExecutionCount);
        }
        else {
            message.pendingExecutionCount = 0;
        }
        if (object.itemList !== undefined && object.itemList !== null) {
            for (const e of object.itemList) {
                message.itemList.push(Item.fromJSON(e));
            }
        }
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
        if (message.usernameList) {
            obj.usernameList = message.usernameList.map((e) => (e ? Username.toJSON(e) : undefined));
        }
        else {
            obj.usernameList = [];
        }
        if (message.tradeList) {
            obj.tradeList = message.tradeList.map((e) => (e ? Trade.toJSON(e) : undefined));
        }
        else {
            obj.tradeList = [];
        }
        message.tradeCount !== undefined && (obj.tradeCount = message.tradeCount);
        message.entityCount !== undefined && (obj.entityCount = message.entityCount);
        message.params !== undefined && (obj.params = message.params ? Params.toJSON(message.params) : undefined);
        if (message.googleInAppPurchaseOrderList) {
            obj.googleInAppPurchaseOrderList = message.googleInAppPurchaseOrderList.map((e) => (e ? GoogleInAppPurchaseOrder.toJSON(e) : undefined));
        }
        else {
            obj.googleInAppPurchaseOrderList = [];
        }
        message.googleIAPOrderCount !== undefined && (obj.googleIAPOrderCount = message.googleIAPOrderCount);
        if (message.executionList) {
            obj.executionList = message.executionList.map((e) => (e ? Execution.toJSON(e) : undefined));
        }
        else {
            obj.executionList = [];
        }
        message.executionCount !== undefined && (obj.executionCount = message.executionCount);
        if (message.pendingExecutionList) {
            obj.pendingExecutionList = message.pendingExecutionList.map((e) => (e ? Execution.toJSON(e) : undefined));
        }
        else {
            obj.pendingExecutionList = [];
        }
        message.pendingExecutionCount !== undefined && (obj.pendingExecutionCount = message.pendingExecutionCount);
        if (message.itemList) {
            obj.itemList = message.itemList.map((e) => (e ? Item.toJSON(e) : undefined));
        }
        else {
            obj.itemList = [];
        }
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
        message.usernameList = [];
        message.tradeList = [];
        message.googleInAppPurchaseOrderList = [];
        message.executionList = [];
        message.pendingExecutionList = [];
        message.itemList = [];
        message.recipeList = [];
        message.cookbookList = [];
        if (object.usernameList !== undefined && object.usernameList !== null) {
            for (const e of object.usernameList) {
                message.usernameList.push(Username.fromPartial(e));
            }
        }
        if (object.tradeList !== undefined && object.tradeList !== null) {
            for (const e of object.tradeList) {
                message.tradeList.push(Trade.fromPartial(e));
            }
        }
        if (object.tradeCount !== undefined && object.tradeCount !== null) {
            message.tradeCount = object.tradeCount;
        }
        else {
            message.tradeCount = 0;
        }
        if (object.entityCount !== undefined && object.entityCount !== null) {
            message.entityCount = object.entityCount;
        }
        else {
            message.entityCount = 0;
        }
        if (object.params !== undefined && object.params !== null) {
            message.params = Params.fromPartial(object.params);
        }
        else {
            message.params = undefined;
        }
        if (object.googleInAppPurchaseOrderList !== undefined && object.googleInAppPurchaseOrderList !== null) {
            for (const e of object.googleInAppPurchaseOrderList) {
                message.googleInAppPurchaseOrderList.push(GoogleInAppPurchaseOrder.fromPartial(e));
            }
        }
        if (object.googleIAPOrderCount !== undefined && object.googleIAPOrderCount !== null) {
            message.googleIAPOrderCount = object.googleIAPOrderCount;
        }
        else {
            message.googleIAPOrderCount = 0;
        }
        if (object.executionList !== undefined && object.executionList !== null) {
            for (const e of object.executionList) {
                message.executionList.push(Execution.fromPartial(e));
            }
        }
        if (object.executionCount !== undefined && object.executionCount !== null) {
            message.executionCount = object.executionCount;
        }
        else {
            message.executionCount = 0;
        }
        if (object.pendingExecutionList !== undefined && object.pendingExecutionList !== null) {
            for (const e of object.pendingExecutionList) {
                message.pendingExecutionList.push(Execution.fromPartial(e));
            }
        }
        if (object.pendingExecutionCount !== undefined && object.pendingExecutionCount !== null) {
            message.pendingExecutionCount = object.pendingExecutionCount;
        }
        else {
            message.pendingExecutionCount = 0;
        }
        if (object.itemList !== undefined && object.itemList !== null) {
            for (const e of object.itemList) {
                message.itemList.push(Item.fromPartial(e));
            }
        }
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
