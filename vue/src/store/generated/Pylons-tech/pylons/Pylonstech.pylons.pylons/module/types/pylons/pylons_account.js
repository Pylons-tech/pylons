/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const basePylonsAccount = { account: '', username: '' };
export const PylonsAccount = {
    encode(message, writer = Writer.create()) {
        if (message.account !== '') {
            writer.uint32(10).string(message.account);
        }
        if (message.username !== '') {
            writer.uint32(18).string(message.username);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...basePylonsAccount };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.account = reader.string();
                    break;
                case 2:
                    message.username = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...basePylonsAccount };
        if (object.account !== undefined && object.account !== null) {
            message.account = String(object.account);
        }
        else {
            message.account = '';
        }
        if (object.username !== undefined && object.username !== null) {
            message.username = String(object.username);
        }
        else {
            message.username = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.account !== undefined && (obj.account = message.account);
        message.username !== undefined && (obj.username = message.username);
        return obj;
    },
    fromPartial(object) {
        const message = { ...basePylonsAccount };
        if (object.account !== undefined && object.account !== null) {
            message.account = object.account;
        }
        else {
            message.account = '';
        }
        if (object.username !== undefined && object.username !== null) {
            message.username = object.username;
        }
        else {
            message.username = '';
        }
        return message;
    }
};
