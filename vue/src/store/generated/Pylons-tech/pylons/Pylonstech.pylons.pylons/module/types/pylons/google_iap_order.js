/* eslint-disable */
import { Writer, Reader } from "protobufjs/minimal";
export const protobufPackage = "Pylonstech.pylons.pylons";
const baseGoogleInAppPurchaseOrder = {
    creator: "",
    productID: "",
    purchaseToken: "",
    receiptDataBase64: "",
    signature: "",
};
export const GoogleInAppPurchaseOrder = {
    encode(message, writer = Writer.create()) {
        if (message.creator !== "") {
            writer.uint32(10).string(message.creator);
        }
        if (message.productID !== "") {
            writer.uint32(18).string(message.productID);
        }
        if (message.purchaseToken !== "") {
            writer.uint32(26).string(message.purchaseToken);
        }
        if (message.receiptDataBase64 !== "") {
            writer.uint32(34).string(message.receiptDataBase64);
        }
        if (message.signature !== "") {
            writer.uint32(42).string(message.signature);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = {
            ...baseGoogleInAppPurchaseOrder,
        };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.creator = reader.string();
                    break;
                case 2:
                    message.productID = reader.string();
                    break;
                case 3:
                    message.purchaseToken = reader.string();
                    break;
                case 4:
                    message.receiptDataBase64 = reader.string();
                    break;
                case 5:
                    message.signature = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = {
            ...baseGoogleInAppPurchaseOrder,
        };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = String(object.creator);
        }
        else {
            message.creator = "";
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = String(object.productID);
        }
        else {
            message.productID = "";
        }
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = String(object.purchaseToken);
        }
        else {
            message.purchaseToken = "";
        }
        if (object.receiptDataBase64 !== undefined &&
            object.receiptDataBase64 !== null) {
            message.receiptDataBase64 = String(object.receiptDataBase64);
        }
        else {
            message.receiptDataBase64 = "";
        }
        if (object.signature !== undefined && object.signature !== null) {
            message.signature = String(object.signature);
        }
        else {
            message.signature = "";
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.creator !== undefined && (obj.creator = message.creator);
        message.productID !== undefined && (obj.productID = message.productID);
        message.purchaseToken !== undefined &&
            (obj.purchaseToken = message.purchaseToken);
        message.receiptDataBase64 !== undefined &&
            (obj.receiptDataBase64 = message.receiptDataBase64);
        message.signature !== undefined && (obj.signature = message.signature);
        return obj;
    },
    fromPartial(object) {
        const message = {
            ...baseGoogleInAppPurchaseOrder,
        };
        if (object.creator !== undefined && object.creator !== null) {
            message.creator = object.creator;
        }
        else {
            message.creator = "";
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = object.productID;
        }
        else {
            message.productID = "";
        }
        if (object.purchaseToken !== undefined && object.purchaseToken !== null) {
            message.purchaseToken = object.purchaseToken;
        }
        else {
            message.purchaseToken = "";
        }
        if (object.receiptDataBase64 !== undefined &&
            object.receiptDataBase64 !== null) {
            message.receiptDataBase64 = object.receiptDataBase64;
        }
        else {
            message.receiptDataBase64 = "";
        }
        if (object.signature !== undefined && object.signature !== null) {
            message.signature = object.signature;
        }
        else {
            message.signature = "";
        }
        return message;
    },
};
