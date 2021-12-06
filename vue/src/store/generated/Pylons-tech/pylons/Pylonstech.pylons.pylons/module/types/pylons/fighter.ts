/* eslint-disable */
import * as Long from "long";
import { util, configure, Writer, Reader } from "protobufjs/minimal";

export const protobufPackage = "Pylonstech.pylons.pylons";

export interface Fighter {
  creator: string;
  ID: number;
  cookbookID: string;
  LHitem: string;
  RHitem: string;
  Armoritem: string;
  NFT: string;
  Status: string;
  Log: string;
  opponentFighter: number;
}

const baseFighter: object = {
  creator: "",
  ID: 0,
  cookbookID: "",
  LHitem: "",
  RHitem: "",
  Armoritem: "",
  NFT: "",
  Status: "",
  Log: "",
  opponentFighter: 0,
};

export const Fighter = {
  encode(message: Fighter, writer: Writer = Writer.create()): Writer {
    if (message.creator !== "") {
      writer.uint32(10).string(message.creator);
    }
    if (message.ID !== 0) {
      writer.uint32(16).uint64(message.ID);
    }
    if (message.cookbookID !== "") {
      writer.uint32(26).string(message.cookbookID);
    }
    if (message.LHitem !== "") {
      writer.uint32(34).string(message.LHitem);
    }
    if (message.RHitem !== "") {
      writer.uint32(42).string(message.RHitem);
    }
    if (message.Armoritem !== "") {
      writer.uint32(50).string(message.Armoritem);
    }
    if (message.NFT !== "") {
      writer.uint32(58).string(message.NFT);
    }
    if (message.Status !== "") {
      writer.uint32(66).string(message.Status);
    }
    if (message.Log !== "") {
      writer.uint32(74).string(message.Log);
    }
    if (message.opponentFighter !== 0) {
      writer.uint32(80).uint64(message.opponentFighter);
    }
    return writer;
  },

  decode(input: Reader | Uint8Array, length?: number): Fighter {
    const reader = input instanceof Uint8Array ? new Reader(input) : input;
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = { ...baseFighter } as Fighter;
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
          message.cookbookID = reader.string();
          break;
        case 4:
          message.LHitem = reader.string();
          break;
        case 5:
          message.RHitem = reader.string();
          break;
        case 6:
          message.Armoritem = reader.string();
          break;
        case 7:
          message.NFT = reader.string();
          break;
        case 8:
          message.Status = reader.string();
          break;
        case 9:
          message.Log = reader.string();
          break;
        case 10:
          message.opponentFighter = longToNumber(reader.uint64() as Long);
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  },

  fromJSON(object: any): Fighter {
    const message = { ...baseFighter } as Fighter;
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
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = String(object.cookbookID);
    } else {
      message.cookbookID = "";
    }
    if (object.LHitem !== undefined && object.LHitem !== null) {
      message.LHitem = String(object.LHitem);
    } else {
      message.LHitem = "";
    }
    if (object.RHitem !== undefined && object.RHitem !== null) {
      message.RHitem = String(object.RHitem);
    } else {
      message.RHitem = "";
    }
    if (object.Armoritem !== undefined && object.Armoritem !== null) {
      message.Armoritem = String(object.Armoritem);
    } else {
      message.Armoritem = "";
    }
    if (object.NFT !== undefined && object.NFT !== null) {
      message.NFT = String(object.NFT);
    } else {
      message.NFT = "";
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = String(object.Status);
    } else {
      message.Status = "";
    }
    if (object.Log !== undefined && object.Log !== null) {
      message.Log = String(object.Log);
    } else {
      message.Log = "";
    }
    if (
      object.opponentFighter !== undefined &&
      object.opponentFighter !== null
    ) {
      message.opponentFighter = Number(object.opponentFighter);
    } else {
      message.opponentFighter = 0;
    }
    return message;
  },

  toJSON(message: Fighter): unknown {
    const obj: any = {};
    message.creator !== undefined && (obj.creator = message.creator);
    message.ID !== undefined && (obj.ID = message.ID);
    message.cookbookID !== undefined && (obj.cookbookID = message.cookbookID);
    message.LHitem !== undefined && (obj.LHitem = message.LHitem);
    message.RHitem !== undefined && (obj.RHitem = message.RHitem);
    message.Armoritem !== undefined && (obj.Armoritem = message.Armoritem);
    message.NFT !== undefined && (obj.NFT = message.NFT);
    message.Status !== undefined && (obj.Status = message.Status);
    message.Log !== undefined && (obj.Log = message.Log);
    message.opponentFighter !== undefined &&
      (obj.opponentFighter = message.opponentFighter);
    return obj;
  },

  fromPartial(object: DeepPartial<Fighter>): Fighter {
    const message = { ...baseFighter } as Fighter;
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
    if (object.cookbookID !== undefined && object.cookbookID !== null) {
      message.cookbookID = object.cookbookID;
    } else {
      message.cookbookID = "";
    }
    if (object.LHitem !== undefined && object.LHitem !== null) {
      message.LHitem = object.LHitem;
    } else {
      message.LHitem = "";
    }
    if (object.RHitem !== undefined && object.RHitem !== null) {
      message.RHitem = object.RHitem;
    } else {
      message.RHitem = "";
    }
    if (object.Armoritem !== undefined && object.Armoritem !== null) {
      message.Armoritem = object.Armoritem;
    } else {
      message.Armoritem = "";
    }
    if (object.NFT !== undefined && object.NFT !== null) {
      message.NFT = object.NFT;
    } else {
      message.NFT = "";
    }
    if (object.Status !== undefined && object.Status !== null) {
      message.Status = object.Status;
    } else {
      message.Status = "";
    }
    if (object.Log !== undefined && object.Log !== null) {
      message.Log = object.Log;
    } else {
      message.Log = "";
    }
    if (
      object.opponentFighter !== undefined &&
      object.opponentFighter !== null
    ) {
      message.opponentFighter = object.opponentFighter;
    } else {
      message.opponentFighter = 0;
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
