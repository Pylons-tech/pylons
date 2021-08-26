/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseEventCreateAccount = { msgTypeUrl: '', address: '' };
export const EventCreateAccount = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.address !== '') {
            writer.uint32(26).string(message.address);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCreateAccount };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
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
        const message = { ...baseEventCreateAccount };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
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
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.address !== undefined && (obj.address = message.address);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCreateAccount };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.address !== undefined && object.address !== null) {
            message.address = object.address;
        }
        else {
            message.address = '';
        }
        return message;
    }
};
const baseEventCreateCookbook = { msgTypeUrl: '', creator: '', id: '' };
export const EventCreateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCreateCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventCreateCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCreateCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventUpdateCookbook = { msgTypeUrl: '', id: '' };
export const EventUpdateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.id !== '') {
            writer.uint32(26).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventUpdateCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventUpdateCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventUpdateCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventTransferCookbook = { msgTypeUrl: '', sender: '', receiver: '', id: '' };
export const EventTransferCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.sender !== '') {
            writer.uint32(26).string(message.sender);
        }
        if (message.receiver !== '') {
            writer.uint32(34).string(message.receiver);
        }
        if (message.id !== '') {
            writer.uint32(42).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventTransferCookbook };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.sender = reader.string();
                    break;
                case 4:
                    message.receiver = reader.string();
                    break;
                case 5:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventTransferCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = String(object.sender);
        }
        else {
            message.sender = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = String(object.receiver);
        }
        else {
            message.receiver = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.sender !== undefined && (obj.sender = message.sender);
        message.receiver !== undefined && (obj.receiver = message.receiver);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventTransferCookbook };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = object.sender;
        }
        else {
            message.sender = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = object.receiver;
        }
        else {
            message.receiver = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventCreateRecipe = { msgTypeUrl: '', creator: '', id: '' };
export const EventCreateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCreateRecipe };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventCreateRecipe };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCreateRecipe };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventUpdateRecipe = { msgTypeUrl: '', creator: '', id: '' };
export const EventUpdateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventUpdateRecipe };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventUpdateRecipe };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventUpdateRecipe };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventCreateExecution = { msgTypeUrl: '', creator: '', id: '' };
export const EventCreateExecution = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCreateExecution };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventCreateExecution };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCreateExecution };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventCompleteExecution = { msgTypeUrl: '', creator: '', id: '' };
export const EventCompleteExecution = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCompleteExecution };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventCompleteExecution };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCompleteExecution };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventCompleteExecutionEarly = { msgTypeUrl: '', creator: '', id: '' };
export const EventCompleteExecutionEarly = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventCompleteExecutionEarly };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventCompleteExecutionEarly };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventCompleteExecutionEarly };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseEventSendItems = { msgTypeUrl: '', sender: '', receiver: '', IDs: '' };
export const EventSendItems = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.sender !== '') {
            writer.uint32(26).string(message.sender);
        }
        if (message.receiver !== '') {
            writer.uint32(34).string(message.receiver);
        }
        for (const v of message.IDs) {
            writer.uint32(42).string(v);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventSendItems };
        message.IDs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.sender = reader.string();
                    break;
                case 4:
                    message.receiver = reader.string();
                    break;
                case 5:
                    message.IDs.push(reader.string());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventSendItems };
        message.IDs = [];
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = String(object.sender);
        }
        else {
            message.sender = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = String(object.receiver);
        }
        else {
            message.receiver = '';
        }
        if (object.IDs !== undefined && object.IDs !== null) {
            for (const e of object.IDs) {
                message.IDs.push(String(e));
            }
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.sender !== undefined && (obj.sender = message.sender);
        message.receiver !== undefined && (obj.receiver = message.receiver);
        if (message.IDs) {
            obj.IDs = message.IDs.map((e) => e);
        }
        else {
            obj.IDs = [];
        }
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventSendItems };
        message.IDs = [];
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.sender !== undefined && object.sender !== null) {
            message.sender = object.sender;
        }
        else {
            message.sender = '';
        }
        if (object.receiver !== undefined && object.receiver !== null) {
            message.receiver = object.receiver;
        }
        else {
            message.receiver = '';
        }
        if (object.IDs !== undefined && object.IDs !== null) {
            for (const e of object.IDs) {
                message.IDs.push(e);
            }
        }
        return message;
    }
};
const baseEventSetIemString = { msgTypeUrl: '', creator: '', id: '' };
export const EventSetIemString = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventSetIemString };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventSetIemString };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventSetIemString };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseGooglePurchase = { msgTypeUrl: '', creator: '', id: '' };
export const GooglePurchase = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseGooglePurchase };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseGooglePurchase };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseGooglePurchase };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
const baseStripePurchase = { msgTypeUrl: '', creator: '', id: '' };
export const StripePurchase = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        if (message.creator !== '') {
            writer.uint32(26).string(message.creator);
        }
        if (message.id !== '') {
            writer.uint32(34).string(message.id);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseStripePurchase };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                case 3:
                    message.creator = reader.string();
                    break;
                case 4:
                    message.id = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseStripePurchase };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = String(object.id);
        }
        else {
            message.id = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        message.creator !== undefined && (obj.creator = message.creator);
        message.id !== undefined && (obj.id = message.id);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseStripePurchase };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = '';
        }
        if (object.id !== undefined && object.id !== null) {
            message.id = object.id;
        }
        else {
            message.id = '';
        }
        return message;
    }
};
