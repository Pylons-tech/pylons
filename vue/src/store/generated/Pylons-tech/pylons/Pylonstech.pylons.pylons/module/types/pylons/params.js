/* eslint-disable */
import * as Long from "long";
import { util, configure, Writer, Reader } from "protobufjs/minimal";
import { Coin } from "../cosmos/base/v1beta1/coin";
export const protobufPackage = "Pylonstech.pylons.pylons";
const baseGoogleInAppPurchasePackage = {
    packageName: "",
    productID: "",
    amount: "",
};
export const GoogleInAppPurchasePackage = {
    encode(message, writer = Writer.create()) {
        if (message.packageName !== "") {
            writer.uint32(10).string(message.packageName);
        }
        if (message.productID !== "") {
            writer.uint32(18).string(message.productID);
        }
        if (message.amount !== "") {
            writer.uint32(26).string(message.amount);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = {
            ...baseGoogleInAppPurchasePackage,
        };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.packageName = reader.string();
                    break;
                case 2:
                    message.productID = reader.string();
                    break;
                case 3:
                    message.amount = reader.string();
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
            ...baseGoogleInAppPurchasePackage,
        };
        if (object.packageName !== undefined && object.packageName !== null) {
            message.packageName = String(object.packageName);
        }
        else {
            message.packageName = "";
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = String(object.productID);
        }
        else {
            message.productID = "";
        }
        if (object.amount !== undefined && object.amount !== null) {
            message.amount = String(object.amount);
        }
        else {
            message.amount = "";
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.packageName !== undefined &&
            (obj.packageName = message.packageName);
        message.productID !== undefined && (obj.productID = message.productID);
        message.amount !== undefined && (obj.amount = message.amount);
        return obj;
    },
    fromPartial(object) {
        const message = {
            ...baseGoogleInAppPurchasePackage,
        };
        if (object.packageName !== undefined && object.packageName !== null) {
            message.packageName = object.packageName;
        }
        else {
            message.packageName = "";
        }
        if (object.productID !== undefined && object.productID !== null) {
            message.productID = object.productID;
        }
        else {
            message.productID = "";
        }
        if (object.amount !== undefined && object.amount !== null) {
            message.amount = object.amount;
        }
        else {
            message.amount = "";
        }
        return message;
    },
};
const baseCoinIssuer = {
    coinDenom: "",
    googleInAppPurchasePubKey: "",
    entityName: "",
};
export const CoinIssuer = {
    encode(message, writer = Writer.create()) {
        if (message.coinDenom !== "") {
            writer.uint32(10).string(message.coinDenom);
        }
        for (const v of message.packages) {
            GoogleInAppPurchasePackage.encode(v, writer.uint32(18).fork()).ldelim();
        }
        if (message.googleInAppPurchasePubKey !== "") {
            writer.uint32(26).string(message.googleInAppPurchasePubKey);
        }
        if (message.entityName !== "") {
            writer.uint32(34).string(message.entityName);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseCoinIssuer };
        message.packages = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.coinDenom = reader.string();
                    break;
                case 2:
                    message.packages.push(GoogleInAppPurchasePackage.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.googleInAppPurchasePubKey = reader.string();
                    break;
                case 4:
                    message.entityName = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseCoinIssuer };
        message.packages = [];
        if (object.coinDenom !== undefined && object.coinDenom !== null) {
            message.coinDenom = String(object.coinDenom);
        }
        else {
            message.coinDenom = "";
        }
        if (object.packages !== undefined && object.packages !== null) {
            for (const e of object.packages) {
                message.packages.push(GoogleInAppPurchasePackage.fromJSON(e));
            }
        }
        if (object.googleInAppPurchasePubKey !== undefined &&
            object.googleInAppPurchasePubKey !== null) {
            message.googleInAppPurchasePubKey = String(object.googleInAppPurchasePubKey);
        }
        else {
            message.googleInAppPurchasePubKey = "";
        }
        if (object.entityName !== undefined && object.entityName !== null) {
            message.entityName = String(object.entityName);
        }
        else {
            message.entityName = "";
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.coinDenom !== undefined && (obj.coinDenom = message.coinDenom);
        if (message.packages) {
            obj.packages = message.packages.map((e) => e ? GoogleInAppPurchasePackage.toJSON(e) : undefined);
        }
        else {
            obj.packages = [];
        }
        message.googleInAppPurchasePubKey !== undefined &&
            (obj.googleInAppPurchasePubKey = message.googleInAppPurchasePubKey);
        message.entityName !== undefined && (obj.entityName = message.entityName);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseCoinIssuer };
        message.packages = [];
        if (object.coinDenom !== undefined && object.coinDenom !== null) {
            message.coinDenom = object.coinDenom;
        }
        else {
            message.coinDenom = "";
        }
        if (object.packages !== undefined && object.packages !== null) {
            for (const e of object.packages) {
                message.packages.push(GoogleInAppPurchasePackage.fromPartial(e));
            }
        }
        if (object.googleInAppPurchasePubKey !== undefined &&
            object.googleInAppPurchasePubKey !== null) {
            message.googleInAppPurchasePubKey = object.googleInAppPurchasePubKey;
        }
        else {
            message.googleInAppPurchasePubKey = "";
        }
        if (object.entityName !== undefined && object.entityName !== null) {
            message.entityName = object.entityName;
        }
        else {
            message.entityName = "";
        }
        return message;
    },
};
const basePaymentProcessor = {
    CoinDenom: "",
    pubKey: "",
    processorPercentage: "",
    validatorsPercentage: "",
    name: "",
};
export const PaymentProcessor = {
    encode(message, writer = Writer.create()) {
        if (message.CoinDenom !== "") {
            writer.uint32(10).string(message.CoinDenom);
        }
        if (message.pubKey !== "") {
            writer.uint32(18).string(message.pubKey);
        }
        if (message.processorPercentage !== "") {
            writer.uint32(26).string(message.processorPercentage);
        }
        if (message.validatorsPercentage !== "") {
            writer.uint32(34).string(message.validatorsPercentage);
        }
        if (message.name !== "") {
            writer.uint32(42).string(message.name);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...basePaymentProcessor };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.CoinDenom = reader.string();
                    break;
                case 2:
                    message.pubKey = reader.string();
                    break;
                case 3:
                    message.processorPercentage = reader.string();
                    break;
                case 4:
                    message.validatorsPercentage = reader.string();
                    break;
                case 5:
                    message.name = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...basePaymentProcessor };
        if (object.CoinDenom !== undefined && object.CoinDenom !== null) {
            message.CoinDenom = String(object.CoinDenom);
        }
        else {
            message.CoinDenom = "";
        }
        if (object.pubKey !== undefined && object.pubKey !== null) {
            message.pubKey = String(object.pubKey);
        }
        else {
            message.pubKey = "";
        }
        if (object.processorPercentage !== undefined &&
            object.processorPercentage !== null) {
            message.processorPercentage = String(object.processorPercentage);
        }
        else {
            message.processorPercentage = "";
        }
        if (object.validatorsPercentage !== undefined &&
            object.validatorsPercentage !== null) {
            message.validatorsPercentage = String(object.validatorsPercentage);
        }
        else {
            message.validatorsPercentage = "";
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = String(object.name);
        }
        else {
            message.name = "";
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.CoinDenom !== undefined && (obj.CoinDenom = message.CoinDenom);
        message.pubKey !== undefined && (obj.pubKey = message.pubKey);
        message.processorPercentage !== undefined &&
            (obj.processorPercentage = message.processorPercentage);
        message.validatorsPercentage !== undefined &&
            (obj.validatorsPercentage = message.validatorsPercentage);
        message.name !== undefined && (obj.name = message.name);
        return obj;
    },
    fromPartial(object) {
        const message = { ...basePaymentProcessor };
        if (object.CoinDenom !== undefined && object.CoinDenom !== null) {
            message.CoinDenom = object.CoinDenom;
        }
        else {
            message.CoinDenom = "";
        }
        if (object.pubKey !== undefined && object.pubKey !== null) {
            message.pubKey = object.pubKey;
        }
        else {
            message.pubKey = "";
        }
        if (object.processorPercentage !== undefined &&
            object.processorPercentage !== null) {
            message.processorPercentage = object.processorPercentage;
        }
        else {
            message.processorPercentage = "";
        }
        if (object.validatorsPercentage !== undefined &&
            object.validatorsPercentage !== null) {
            message.validatorsPercentage = object.validatorsPercentage;
        }
        else {
            message.validatorsPercentage = "";
        }
        if (object.name !== undefined && object.name !== null) {
            message.name = object.name;
        }
        else {
            message.name = "";
        }
        return message;
    },
};
const baseParams = {
    recipeFeePercentage: "",
    itemTransferFeePercentage: "",
    minTransferFee: "",
    maxTransferFee: "",
    distrEpochIdentifier: "",
    engineVersion: 0,
};
export const Params = {
    encode(message, writer = Writer.create()) {
        for (const v of message.coinIssuers) {
            CoinIssuer.encode(v, writer.uint32(10).fork()).ldelim();
        }
        for (const v of message.paymentProcessors) {
            PaymentProcessor.encode(v, writer.uint32(18).fork()).ldelim();
        }
        if (message.recipeFeePercentage !== "") {
            writer.uint32(26).string(message.recipeFeePercentage);
        }
        if (message.itemTransferFeePercentage !== "") {
            writer.uint32(34).string(message.itemTransferFeePercentage);
        }
        if (message.updateItemStringFee !== undefined) {
            Coin.encode(message.updateItemStringFee, writer.uint32(42).fork()).ldelim();
        }
        if (message.minTransferFee !== "") {
            writer.uint32(50).string(message.minTransferFee);
        }
        if (message.maxTransferFee !== "") {
            writer.uint32(58).string(message.maxTransferFee);
        }
        if (message.updateUsernameFee !== undefined) {
            Coin.encode(message.updateUsernameFee, writer.uint32(66).fork()).ldelim();
        }
        if (message.distrEpochIdentifier !== "") {
            writer.uint32(74).string(message.distrEpochIdentifier);
        }
        if (message.engineVersion !== 0) {
            writer.uint32(80).uint64(message.engineVersion);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof Uint8Array ? new Reader(input) : input;
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseParams };
        message.coinIssuers = [];
        message.paymentProcessors = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.coinIssuers.push(CoinIssuer.decode(reader, reader.uint32()));
                    break;
                case 2:
                    message.paymentProcessors.push(PaymentProcessor.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.recipeFeePercentage = reader.string();
                    break;
                case 4:
                    message.itemTransferFeePercentage = reader.string();
                    break;
                case 5:
                    message.updateItemStringFee = Coin.decode(reader, reader.uint32());
                    break;
                case 6:
                    message.minTransferFee = reader.string();
                    break;
                case 7:
                    message.maxTransferFee = reader.string();
                    break;
                case 8:
                    message.updateUsernameFee = Coin.decode(reader, reader.uint32());
                    break;
                case 9:
                    message.distrEpochIdentifier = reader.string();
                    break;
                case 10:
                    message.engineVersion = longToNumber(reader.uint64());
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseParams };
        message.coinIssuers = [];
        message.paymentProcessors = [];
        if (object.coinIssuers !== undefined && object.coinIssuers !== null) {
            for (const e of object.coinIssuers) {
                message.coinIssuers.push(CoinIssuer.fromJSON(e));
            }
        }
        if (object.paymentProcessors !== undefined &&
            object.paymentProcessors !== null) {
            for (const e of object.paymentProcessors) {
                message.paymentProcessors.push(PaymentProcessor.fromJSON(e));
            }
        }
        if (object.recipeFeePercentage !== undefined &&
            object.recipeFeePercentage !== null) {
            message.recipeFeePercentage = String(object.recipeFeePercentage);
        }
        else {
            message.recipeFeePercentage = "";
        }
        if (object.itemTransferFeePercentage !== undefined &&
            object.itemTransferFeePercentage !== null) {
            message.itemTransferFeePercentage = String(object.itemTransferFeePercentage);
        }
        else {
            message.itemTransferFeePercentage = "";
        }
        if (object.updateItemStringFee !== undefined &&
            object.updateItemStringFee !== null) {
            message.updateItemStringFee = Coin.fromJSON(object.updateItemStringFee);
        }
        else {
            message.updateItemStringFee = undefined;
        }
        if (object.minTransferFee !== undefined && object.minTransferFee !== null) {
            message.minTransferFee = String(object.minTransferFee);
        }
        else {
            message.minTransferFee = "";
        }
        if (object.maxTransferFee !== undefined && object.maxTransferFee !== null) {
            message.maxTransferFee = String(object.maxTransferFee);
        }
        else {
            message.maxTransferFee = "";
        }
        if (object.updateUsernameFee !== undefined &&
            object.updateUsernameFee !== null) {
            message.updateUsernameFee = Coin.fromJSON(object.updateUsernameFee);
        }
        else {
            message.updateUsernameFee = undefined;
        }
        if (object.distrEpochIdentifier !== undefined &&
            object.distrEpochIdentifier !== null) {
            message.distrEpochIdentifier = String(object.distrEpochIdentifier);
        }
        else {
            message.distrEpochIdentifier = "";
        }
        if (object.engineVersion !== undefined && object.engineVersion !== null) {
            message.engineVersion = Number(object.engineVersion);
        }
        else {
            message.engineVersion = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.coinIssuers) {
            obj.coinIssuers = message.coinIssuers.map((e) => e ? CoinIssuer.toJSON(e) : undefined);
        }
        else {
            obj.coinIssuers = [];
        }
        if (message.paymentProcessors) {
            obj.paymentProcessors = message.paymentProcessors.map((e) => e ? PaymentProcessor.toJSON(e) : undefined);
        }
        else {
            obj.paymentProcessors = [];
        }
        message.recipeFeePercentage !== undefined &&
            (obj.recipeFeePercentage = message.recipeFeePercentage);
        message.itemTransferFeePercentage !== undefined &&
            (obj.itemTransferFeePercentage = message.itemTransferFeePercentage);
        message.updateItemStringFee !== undefined &&
            (obj.updateItemStringFee = message.updateItemStringFee
                ? Coin.toJSON(message.updateItemStringFee)
                : undefined);
        message.minTransferFee !== undefined &&
            (obj.minTransferFee = message.minTransferFee);
        message.maxTransferFee !== undefined &&
            (obj.maxTransferFee = message.maxTransferFee);
        message.updateUsernameFee !== undefined &&
            (obj.updateUsernameFee = message.updateUsernameFee
                ? Coin.toJSON(message.updateUsernameFee)
                : undefined);
        message.distrEpochIdentifier !== undefined &&
            (obj.distrEpochIdentifier = message.distrEpochIdentifier);
        message.engineVersion !== undefined &&
            (obj.engineVersion = message.engineVersion);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseParams };
        message.coinIssuers = [];
        message.paymentProcessors = [];
        if (object.coinIssuers !== undefined && object.coinIssuers !== null) {
            for (const e of object.coinIssuers) {
                message.coinIssuers.push(CoinIssuer.fromPartial(e));
            }
        }
        if (object.paymentProcessors !== undefined &&
            object.paymentProcessors !== null) {
            for (const e of object.paymentProcessors) {
                message.paymentProcessors.push(PaymentProcessor.fromPartial(e));
            }
        }
        if (object.recipeFeePercentage !== undefined &&
            object.recipeFeePercentage !== null) {
            message.recipeFeePercentage = object.recipeFeePercentage;
        }
        else {
            message.recipeFeePercentage = "";
        }
        if (object.itemTransferFeePercentage !== undefined &&
            object.itemTransferFeePercentage !== null) {
            message.itemTransferFeePercentage = object.itemTransferFeePercentage;
        }
        else {
            message.itemTransferFeePercentage = "";
        }
        if (object.updateItemStringFee !== undefined &&
            object.updateItemStringFee !== null) {
            message.updateItemStringFee = Coin.fromPartial(object.updateItemStringFee);
        }
        else {
            message.updateItemStringFee = undefined;
        }
        if (object.minTransferFee !== undefined && object.minTransferFee !== null) {
            message.minTransferFee = object.minTransferFee;
        }
        else {
            message.minTransferFee = "";
        }
        if (object.maxTransferFee !== undefined && object.maxTransferFee !== null) {
            message.maxTransferFee = object.maxTransferFee;
        }
        else {
            message.maxTransferFee = "";
        }
        if (object.updateUsernameFee !== undefined &&
            object.updateUsernameFee !== null) {
            message.updateUsernameFee = Coin.fromPartial(object.updateUsernameFee);
        }
        else {
            message.updateUsernameFee = undefined;
        }
        if (object.distrEpochIdentifier !== undefined &&
            object.distrEpochIdentifier !== null) {
            message.distrEpochIdentifier = object.distrEpochIdentifier;
        }
        else {
            message.distrEpochIdentifier = "";
        }
        if (object.engineVersion !== undefined && object.engineVersion !== null) {
            message.engineVersion = object.engineVersion;
        }
        else {
            message.engineVersion = 0;
        }
        return message;
    },
};
var globalThis = (() => {
    if (typeof globalThis !== "undefined")
        return globalThis;
    if (typeof self !== "undefined")
        return self;
    if (typeof window !== "undefined")
        return window;
    if (typeof global !== "undefined")
        return global;
    throw "Unable to locate global object";
})();
function longToNumber(long) {
    if (long.gt(Number.MAX_SAFE_INTEGER)) {
        throw new globalThis.Error("Value is larger than Number.MAX_SAFE_INTEGER");
    }
    return long.toNumber();
}
if (util.Long !== Long) {
    util.Long = Long;
    configure();
}
