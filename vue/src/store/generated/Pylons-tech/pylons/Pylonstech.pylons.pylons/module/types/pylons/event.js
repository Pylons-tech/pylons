/* eslint-disable */
import { Writer, Reader } from 'protobufjs/minimal';
export const protobufPackage = 'Pylonstech.pylons.pylons';
const baseEventCreateAccount = { msgTypeUrl: '' };
export const EventCreateAccount = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventCreateCookbook = { msgTypeUrl: '' };
export const EventCreateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventUpdateCookbook = { msgTypeUrl: '' };
export const EventUpdateCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventTransferCookbook = { msgTypeUrl: '' };
export const EventTransferCookbook = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventCreateRecipe = { msgTypeUrl: '' };
export const EventCreateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventUpdateRecipe = { msgTypeUrl: '' };
export const EventUpdateRecipe = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventCreateExecution = { msgTypeUrl: '' };
export const EventCreateExecution = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventCompleteExecution = { msgTypeUrl: '' };
export const EventCompleteExecution = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventCompleteExecutionEarly = { msgTypeUrl: '' };
export const EventCompleteExecutionEarly = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseEventSentItems = { msgTypeUrl: '' };
export const EventSentItems = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseEventSentItems };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 2:
                    message.msgTypeUrl = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseEventSentItems };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = String(object.msgTypeUrl);
        }
        else {
            message.msgTypeUrl = '';
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseEventSentItems };
        if (object.msgTypeUrl !== undefined && object.msgTypeUrl !== null) {
            message.msgTypeUrl = object.msgTypeUrl;
        }
        else {
            message.msgTypeUrl = '';
        }
        return message;
    }
};
const baseEventSetIemString = { msgTypeUrl: '' };
export const EventSetIemString = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseGooglePurchase = { msgTypeUrl: '' };
export const GooglePurchase = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
const baseStripePurchase = { msgTypeUrl: '' };
export const StripePurchase = {
    encode(message, writer = Writer.create()) {
        if (message.msgTypeUrl !== '') {
            writer.uint32(18).string(message.msgTypeUrl);
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
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.msgTypeUrl !== undefined && (obj.msgTypeUrl = message.msgTypeUrl);
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
        return message;
    }
};
