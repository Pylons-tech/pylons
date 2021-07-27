/* eslint-disable */
import { Cookbook } from '../pylons/cookbook';
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseGenesisState = {};
export const GenesisState = {
    encode(message, writer = Writer.create()) {
        for (const v of message.cookbookList) {
            Cookbook.encode(v, writer.uint32(10).fork()).ldelim();
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGenesisState };
        message.cookbookList = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
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
        message.cookbookList = [];
        if (object.cookbookList !== undefined && object.cookbookList !== null) {
            for (const e of object.cookbookList) {
                message.cookbookList.push(Cookbook.fromJSON(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
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
        message.cookbookList = [];
        if (object.cookbookList !== undefined && object.cookbookList !== null) {
            for (const e of object.cookbookList) {
                message.cookbookList.push(Cookbook.fromPartial(e));
            }
        }
        return message;
    }
};
