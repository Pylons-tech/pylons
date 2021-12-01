/* eslint-disable */
import { Writer, Reader } from "protobufjs/minimal";

export const protobufPackage = "Pylonstech.pylons.pylons";

export interface RedeemInfo {
  ID: string;
  processorName: string;
  address: string;
  amount: string;
  signature: string;
}

export interface CreatePaymentAccount {
  address: string;
  token: string;
  signature: string;
}

const baseRedeemInfo: object = {
  ID: "",
  processorName: "",
  address: "",
  amount: "",
  signature: "",
};

export const RedeemInfo = {
  encode(message: RedeemInfo, writer: Writer = Writer.create()): Writer {
    if (message.ID !== "") {
      writer.uint32(10).string(message.ID);
    }
    if (message.processorName !== "") {
      writer.uint32(18).string(message.processorName);
    }
    if (message.address !== "") {
      writer.uint32(26).string(message.address);
    }
    if (message.amount !== "") {
      writer.uint32(34).string(message.amount);
    }
    if (message.signature !== "") {
      writer.uint32(42).string(message.signature);
    }
    return writer;
  },

  decode(input: Reader | Uint8Array, length?: number): RedeemInfo {
    const reader = input instanceof Uint8Array ? new Reader(input) : input;
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = { ...baseRedeemInfo } as RedeemInfo;
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.ID = reader.string();
          break;
        case 2:
          message.processorName = reader.string();
          break;
        case 3:
          message.address = reader.string();
          break;
        case 4:
          message.amount = reader.string();
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

  fromJSON(object: any): RedeemInfo {
    const message = { ...baseRedeemInfo } as RedeemInfo;
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = String(object.ID);
    } else {
      message.ID = "";
    }
    if (object.processorName !== undefined && object.processorName !== null) {
      message.processorName = String(object.processorName);
    } else {
      message.processorName = "";
    }
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address);
    } else {
      message.address = "";
    }
    if (object.amount !== undefined && object.amount !== null) {
      message.amount = String(object.amount);
    } else {
      message.amount = "";
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = String(object.signature);
    } else {
      message.signature = "";
    }
    return message;
  },

  toJSON(message: RedeemInfo): unknown {
    const obj: any = {};
    message.ID !== undefined && (obj.ID = message.ID);
    message.processorName !== undefined &&
      (obj.processorName = message.processorName);
    message.address !== undefined && (obj.address = message.address);
    message.amount !== undefined && (obj.amount = message.amount);
    message.signature !== undefined && (obj.signature = message.signature);
    return obj;
  },

  fromPartial(object: DeepPartial<RedeemInfo>): RedeemInfo {
    const message = { ...baseRedeemInfo } as RedeemInfo;
    if (object.ID !== undefined && object.ID !== null) {
      message.ID = object.ID;
    } else {
      message.ID = "";
    }
    if (object.processorName !== undefined && object.processorName !== null) {
      message.processorName = object.processorName;
    } else {
      message.processorName = "";
    }
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address;
    } else {
      message.address = "";
    }
    if (object.amount !== undefined && object.amount !== null) {
      message.amount = object.amount;
    } else {
      message.amount = "";
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = object.signature;
    } else {
      message.signature = "";
    }
    return message;
  },
};

const baseCreatePaymentAccount: object = {
  address: "",
  token: "",
  signature: "",
};

export const CreatePaymentAccount = {
  encode(
    message: CreatePaymentAccount,
    writer: Writer = Writer.create()
  ): Writer {
    if (message.address !== "") {
      writer.uint32(10).string(message.address);
    }
    if (message.token !== "") {
      writer.uint32(18).string(message.token);
    }
    if (message.signature !== "") {
      writer.uint32(26).string(message.signature);
    }
    return writer;
  },

  decode(input: Reader | Uint8Array, length?: number): CreatePaymentAccount {
    const reader = input instanceof Uint8Array ? new Reader(input) : input;
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = { ...baseCreatePaymentAccount } as CreatePaymentAccount;
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.address = reader.string();
          break;
        case 2:
          message.token = reader.string();
          break;
        case 3:
          message.signature = reader.string();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  },

  fromJSON(object: any): CreatePaymentAccount {
    const message = { ...baseCreatePaymentAccount } as CreatePaymentAccount;
    if (object.address !== undefined && object.address !== null) {
      message.address = String(object.address);
    } else {
      message.address = "";
    }
    if (object.token !== undefined && object.token !== null) {
      message.token = String(object.token);
    } else {
      message.token = "";
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = String(object.signature);
    } else {
      message.signature = "";
    }
    return message;
  },

  toJSON(message: CreatePaymentAccount): unknown {
    const obj: any = {};
    message.address !== undefined && (obj.address = message.address);
    message.token !== undefined && (obj.token = message.token);
    message.signature !== undefined && (obj.signature = message.signature);
    return obj;
  },

  fromPartial(object: DeepPartial<CreatePaymentAccount>): CreatePaymentAccount {
    const message = { ...baseCreatePaymentAccount } as CreatePaymentAccount;
    if (object.address !== undefined && object.address !== null) {
      message.address = object.address;
    } else {
      message.address = "";
    }
    if (object.token !== undefined && object.token !== null) {
      message.token = object.token;
    } else {
      message.token = "";
    }
    if (object.signature !== undefined && object.signature !== null) {
      message.signature = object.signature;
    } else {
      message.signature = "";
    }
    return message;
  },
};

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
