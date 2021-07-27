import { Reader, Writer } from 'protobufjs/minimal';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
/** this line is used by starport scaffolding # proto/tx/message */
export interface MsgCreateCookbook {
    creator: string;
    index: string;
    nodeVersion: string;
    name: string;
    description: string;
    developer: string;
    version: string;
    supportEmail: string;
    level: number;
    costPerBlock: number;
    enabled: boolean;
}
export interface MsgCreateCookbookResponse {
}
export interface MsgUpdateCookbook {
    creator: string;
    index: string;
    nodeVersion: string;
    name: string;
    description: string;
    developer: string;
    version: string;
    supportEmail: string;
    level: number;
    costPerBlock: number;
    enabled: boolean;
}
export interface MsgUpdateCookbookResponse {
}
export declare const MsgCreateCookbook: {
    encode(message: MsgCreateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbook;
    fromJSON(object: any): MsgCreateCookbook;
    toJSON(message: MsgCreateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgCreateCookbook>): MsgCreateCookbook;
};
export declare const MsgCreateCookbookResponse: {
    encode(_: MsgCreateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbookResponse;
    fromJSON(_: any): MsgCreateCookbookResponse;
    toJSON(_: MsgCreateCookbookResponse): unknown;
    fromPartial(_: DeepPartial<MsgCreateCookbookResponse>): MsgCreateCookbookResponse;
};
export declare const MsgUpdateCookbook: {
    encode(message: MsgUpdateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbook;
    fromJSON(object: any): MsgUpdateCookbook;
    toJSON(message: MsgUpdateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgUpdateCookbook>): MsgUpdateCookbook;
};
export declare const MsgUpdateCookbookResponse: {
    encode(_: MsgUpdateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbookResponse;
    fromJSON(_: any): MsgUpdateCookbookResponse;
    toJSON(_: MsgUpdateCookbookResponse): unknown;
    fromPartial(_: DeepPartial<MsgUpdateCookbookResponse>): MsgUpdateCookbookResponse;
};
/** Msg defines the Msg service. */
export interface Msg {
    /** this line is used by starport scaffolding # proto/tx/rpc */
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
}
export declare class MsgClientImpl implements Msg {
    private readonly rpc;
    constructor(rpc: Rpc);
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    UpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
}
interface Rpc {
    request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>;
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
