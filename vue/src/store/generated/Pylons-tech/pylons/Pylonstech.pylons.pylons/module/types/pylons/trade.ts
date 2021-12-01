/* eslint-disable */
import * as Long from "long";
import { util, configure, Writer, Reader } from "protobufjs/minimal";
import { CoinInput, ItemInput } from "../pylons/recipe";
import { Coin } from "../cosmos/base/v1beta1/coin";

export const protobufPackage = "Pylonstech.pylons.pylons";

export interface ItemRef {
  cookbookID: string;
  itemID: string;
}

export interface Trade {
  creator: string;
  ID: number;
  coinInputs: CoinInput[];
  itemInputs: ItemInput[];
  coinOutputs: Coin[];
  itemOutputs: ItemRef[];
  extraInfo: string;
  receiver: string;
  tradedItemInputs: ItemRef[];
}

const baseItemRef: object = { cookbookID: "", itemID: "" };

export const ItemRef = {
  encode(message: ItemRef, writer: Writer = Writer.create()): Writer {
    if (message.cookbookID !== "") {
      writer.uint32(10).string(message.cookbookID);
    }
    if (message.itemID !== "") {
      writer.uint32(18).string(message.itemID);
    }
    return writer;
  },

  decode(input: Reader | Uint8Array, length?: number): ItemRef {
    const reader = input instanceof Uint8Array ? new Reader(input) : input;
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = { ...baseItemRef } as ItemRef;
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.cookbookID = reader.string();
          break;
        case 2:
          message.itemID = reader.string();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  },

  fromJSON(object: any): ItemRef {
    const message = { ...baseItemRef } as ItemRef;
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID);
    } else {
      message.cookbookID = "";
    }
    if (object.itemID !== undefined && object.itemID !== null) {
      message.itemID = String(object.itemID);
    } else {
      message.itemID = "";
    }
    return message;
  },

  toJSON(message: ItemRef): unknown {
    const obj: any = {};
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
    message.itemID !== undefined && (obj.itemID = message.itemID);
    return obj;
  },

  fromPartial(object: DeepPartial<ItemRef>): ItemRef {
    const message = { ...baseItemRef } as ItemRef;
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID;
    } else {
      message.cookbookID = "";
    }
    if (object.itemID !== undefined && object.itemID !== null) {
      message.itemID = object.itemID;
    } else {
      message.itemID = "";
    }
    return message;
  },
};

const baseTrade: object = { creator: "", ID: 0, extraInfo: "", receiver: "" };

export const Trade = {
  encode(message: Trade, writer: Writer = Writer.create()): Writer {
    if (message.creator !== "") {
      writer.uint32(10).string(message.creator);
    }
    if (message.ID !== 0) {
      writer.uint32(16).uint64(message.ID);
    }
    for (const v of message.coinInputs) {
      CoinInput.encode(v!, writer.uint32(26).fork()).ldelim();
    }
    for (const v of message.itemInputs) {
      ItemInput.encode(v!, writer.uint32(34).fork()).ldelim();
    }
    for (const v of message.coinOutputs) {
      Coin.encode(v!, writer.uint32(42).fork()).ldelim();
    }
    for (const v of message.itemOutputs) {
      ItemRef.encode(v!, writer.uint32(50).fork()).ldelim();
    }
    if (message.extraInfo !== "") {
      writer.uint32(58).string(message.extraInfo);
    }
    if (message.receiver !== "") {
      writer.uint32(66).string(message.receiver);
    }
    for (const v of message.tradedItemInputs) {
      ItemRef.encode(v!, writer.uint32(74).fork()).ldelim();
    }
    return writer;
  },

  decode(input: Reader | Uint8Array, length?: number): Trade {
    const reader = input instanceof Uint8Array ? new Reader(input) : input;
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = { ...baseTrade } as Trade;
    message.coinInputs = [];
    message.itemInputs = [];
    message.coinOutputs = [];
    message.itemOutputs = [];
    message.tradedItemInputs = [];
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.creator = reader.string();
          break;
        case 2:
          message.ID = longToNumber(reader.uint64() as Long);
          break;
        case 3:
          message.coinInputs.push(CoinInput.decode(reader, reader.uint32()));
          break;
        case 4:
          message.itemInputs.push(ItemInput.decode(reader, reader.uint32()));
          break;
        case 5:
          message.coinOutputs.push(Coin.decode(reader, reader.uint32()));
          break;
        case 6:
          message.itemOutputs.push(ItemRef.decode(reader, reader.uint32()));
          break;
        case 7:
          message.extraInfo = reader.string();
          break;
        case 8:
          message.receiver = reader.string();
          break;
        case 9:
          message.tradedItemInputs.push(
            ItemRef.decode(reader, reader.uint32())
          );
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  },

  fromJSON(object: any): Trade {
    const message = { ...baseTrade } as Trade;
    message.coinInputs = [];
    message.itemInputs = [];
    message.coinOutputs = [];
    message.itemOutputs = [];
    message.tradedItemInputs = [];
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = String(object.creator);
    } else {
      message.creator = "";
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = Number(object.ID);
    } else {
      message.ID = 0;
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(CoinInput.fromJSON(e));
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromJSON(e));
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromJSON(e));
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemRef.fromJSON(e));
      }
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = String(object.extraInfo);
    } else {
      message.extraInfo = "";
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = String(object.receiver);
    } else {
      message.receiver = "";
    }
    if (
      object.tradedItemInputs !== undefined &&
      object.tradedItemInputs !== null
    ) {
      for (const e of object.tradedItemInputs) {
        message.tradedItemInputs.push(ItemRef.fromJSON(e));
      }
    }
    return message;
  },

  toJSON(message: Trade): unknown {
    const obj: any = {};
    message.creator !== undefined && (obj.creator = message.creator);
    message.ID !== undefined && (obj.ID = message.ID);
    if (message.coinInputs) {
      obj.coinInputs = message.coinInputs.map((e) =>
        e ? CoinInput.toJSON(e) : undefined
      );
    } else {
      obj.coinInputs = [];
    }
    if (message.itemInputs) {
      obj.itemInputs = message.itemInputs.map((e) =>
        e ? ItemInput.toJSON(e) : undefined
      );
    } else {
      obj.itemInputs = [];
    }
    if (message.coinOutputs) {
      obj.coinOutputs = message.coinOutputs.map((e) =>
        e ? Coin.toJSON(e) : undefined
      );
    } else {
      obj.coinOutputs = [];
    }
    if (message.itemOutputs) {
      obj.itemOutputs = message.itemOutputs.map((e) =>
        e ? ItemRef.toJSON(e) : undefined
      );
    } else {
      obj.itemOutputs = [];
    }
    message.extraInfo !== undefined && (obj.extraInfo = message.extraInfo);
    message.receiver !== undefined && (obj.receiver = message.receiver);
    if (message.tradedItemInputs) {
      obj.tradedItemInputs = message.tradedItemInputs.map((e) =>
        e ? ItemRef.toJSON(e) : undefined
      );
    } else {
      obj.tradedItemInputs = [];
    }
    return obj;
  },

  fromPartial(object: DeepPartial<Trade>): Trade {
    const message = { ...baseTrade } as Trade;
    message.coinInputs = [];
    message.itemInputs = [];
    message.coinOutputs = [];
    message.itemOutputs = [];
    message.tradedItemInputs = [];
    if (object.creator !== undefined && object.creator !== null) {
      message.creator = object.creator;
    } else {
      message.creator = "";
    }
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID;
    } else {
      message.ID = 0;
    }
    if (object.coinInputs !== undefined && object.coinInputs !== null) {
      for (const e of object.coinInputs) {
        message.coinInputs.push(CoinInput.fromPartial(e));
      }
    }
    if (object.itemInputs !== undefined && object.itemInputs !== null) {
      for (const e of object.itemInputs) {
        message.itemInputs.push(ItemInput.fromPartial(e));
      }
    }
    if (object.coinOutputs !== undefined && object.coinOutputs !== null) {
      for (const e of object.coinOutputs) {
        message.coinOutputs.push(Coin.fromPartial(e));
      }
    }
    if (object.itemOutputs !== undefined && object.itemOutputs !== null) {
      for (const e of object.itemOutputs) {
        message.itemOutputs.push(ItemRef.fromPartial(e));
      }
    }
    if (object.extraInfo !== undefined && object.extraInfo !== null) {
      message.extraInfo = object.extraInfo;
    } else {
      message.extraInfo = "";
    }
    if (object.receiver !== undefined && object.receiver !== null) {
      message.receiver = object.receiver;
    } else {
      message.receiver = "";
    }
    if (
      object.tradedItemInputs !== undefined &&
      object.tradedItemInputs !== null
    ) {
      for (const e of object.tradedItemInputs) {
        message.tradedItemInputs.push(ItemRef.fromPartial(e));
      }
    }
    return message;
  },
};

declare var self: any | undefined;
declare var window: any | undefined;
var globalThis: any = (() => {
  if (typeof globalThis !== "undefined") return globalThis;
  if (typeof self !== "undefined") return self;
  if (typeof window !== "undefined") return window;
  if (typeof global !== "undefined") return global;
  throw "Unable to locate global object";
})();

type Builtin = Date | Function | Uint8Array | string | number | undefined;
export type DeepPartial<T> = T extends Builtin
  ? T
  : T extends Array<infer U>
  ? Array<DeepPartial<U>>
  : T extends ReadonlyArray<infer U>
  ? ReadonlyArray<DeepPartial<U>>
  : T extends {}
  ? { [K in keyof T]?: DeepPartial<T[K]> }
  : Partial<T>;

function longToNumber(long: Long): number {
  if (long.gt(Number.MAX_SAFE_INTEGER)) {
    throw new globalThis.Error("Value is larger than Number.MAX_SAFE_INTEGER");
  }
  return long.toNumber();
}

if (util.Long !== Long) {
  util.Long = Long as any;
  configure();
}
