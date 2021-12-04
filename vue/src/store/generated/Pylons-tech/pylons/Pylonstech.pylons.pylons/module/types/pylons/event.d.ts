import { Writer, Reader } from "protobufjs/minimal";
import { RedeemInfo } from "../pylons/redeem_info";
import { Cookbook } from "../pylons/cookbook";
import { Recipe } from "../pylons/recipe";
import { PaymentInfo } from "../pylons/payment_info";
import { Coin } from "../cosmos/base/v1beta1/coin";
import { Item, StringKeyValue } from "../pylons/item";
import { ItemRef } from "../pylons/trade";
export declare const protobufPackage = "Pylonstech.pylons.pylons";
export interface EventBurnDebtToken {
    redeemInfo: RedeemInfo | undefined;
}
export interface EventCreateAccount {
    address: string;
    username: string;
}
export interface EventUpdateAccount {
    address: string;
    username: string;
}
export interface EventCreateCookbook {
    creator: string;
    ID: string;
}
/** EventUpdateCookbook contains a record of the cookbook pre-update.  The updated fields can be found by the message emitted by MsgUpdateCookbook */
export interface EventUpdateCookbook {
    originalCookbook: Cookbook | undefined;
}
export interface EventTransferCookbook {
    sender: string;
    receiver: string;
    ID: string;
}
export interface EventCreateRecipe {
    creator: string;
    CookbookID: string;
    ID: string;
}
/** EventUpdateRecipe contains a record of the recipe pre-update.  The updated fields can be found by the message emitted by MsgUpdateRecipe */
export interface EventUpdateRecipe {
    originalRecipe: Recipe | undefined;
}
/** EventCreateExecution contains the creator and ID of a created execution. Execution IDs are of the form {count-targetBlockHeight} */
export interface EventCreateExecution {
    creator: string;
    ID: string;
    paymentInfos: PaymentInfo[];
}
export interface EventCompleteExecution {
    creator: string;
    ID: string;
    burnCoins: Coin[];
    payCoins: Coin[];
    transferCoins: Coin[];
    feeCoins: Coin[];
    coinOutputs: Coin[];
    mintItems: Item[];
    modifyItems: Item[];
}
export interface EventDropExecution {
    creator: string;
    ID: string;
}
export interface EventCompleteExecutionEarly {
    creator: string;
    ID: string;
}
export interface EventSendItems {
    sender: string;
    receiver: string;
    items: ItemRef[];
}
export interface EventSetItemString {
    creator: string;
    CookbookID: string;
    ID: string;
    originalMutableStrings: StringKeyValue[];
}
export interface EventCreateTrade {
    creator: string;
    ID: number;
}
export interface EventCancelTrade {
    creator: string;
    ID: number;
}
export interface EventFulfillTrade {
    ID: number;
    creator: string;
    fulfiller: string;
    itemInputs: ItemRef[];
    coinInputs: Coin[];
    itemOutputs: ItemRef[];
    coinOutputs: Coin[];
    paymentInfos: PaymentInfo[];
}
export interface EventCreateFighter {
    creator: string;
    ID: number;
}
export interface EventCancelFighter {
    creator: string;
    ID: number;
}
export interface EventFulfillFight {
    ID: number;
    creator: string;
    fulfiller: string;
}
export interface EventGooglePurchase {
    creator: string;
    productID: string;
    purchaseToken: string;
    receiptDataBase64: string;
    signature: string;
}
export interface EventStripePurchase {
    creator: string;
    ID: string;
}
export declare const EventBurnDebtToken: {
    encode(message: EventBurnDebtToken, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventBurnDebtToken;
    fromJSON(object: any): EventBurnDebtToken;
    toJSON(message: EventBurnDebtToken): unknown;
    fromPartial(object: DeepPartial<EventBurnDebtToken>): EventBurnDebtToken;
};
export declare const EventCreateAccount: {
    encode(message: EventCreateAccount, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateAccount;
    fromJSON(object: any): EventCreateAccount;
    toJSON(message: EventCreateAccount): unknown;
    fromPartial(object: DeepPartial<EventCreateAccount>): EventCreateAccount;
};
export declare const EventUpdateAccount: {
    encode(message: EventUpdateAccount, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventUpdateAccount;
    fromJSON(object: any): EventUpdateAccount;
    toJSON(message: EventUpdateAccount): unknown;
    fromPartial(object: DeepPartial<EventUpdateAccount>): EventUpdateAccount;
};
export declare const EventCreateCookbook: {
    encode(message: EventCreateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateCookbook;
    fromJSON(object: any): EventCreateCookbook;
    toJSON(message: EventCreateCookbook): unknown;
    fromPartial(object: DeepPartial<EventCreateCookbook>): EventCreateCookbook;
};
export declare const EventUpdateCookbook: {
    encode(message: EventUpdateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventUpdateCookbook;
    fromJSON(object: any): EventUpdateCookbook;
    toJSON(message: EventUpdateCookbook): unknown;
    fromPartial(object: DeepPartial<EventUpdateCookbook>): EventUpdateCookbook;
};
export declare const EventTransferCookbook: {
    encode(message: EventTransferCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventTransferCookbook;
    fromJSON(object: any): EventTransferCookbook;
    toJSON(message: EventTransferCookbook): unknown;
    fromPartial(object: DeepPartial<EventTransferCookbook>): EventTransferCookbook;
};
export declare const EventCreateRecipe: {
    encode(message: EventCreateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateRecipe;
    fromJSON(object: any): EventCreateRecipe;
    toJSON(message: EventCreateRecipe): unknown;
    fromPartial(object: DeepPartial<EventCreateRecipe>): EventCreateRecipe;
};
export declare const EventUpdateRecipe: {
    encode(message: EventUpdateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventUpdateRecipe;
    fromJSON(object: any): EventUpdateRecipe;
    toJSON(message: EventUpdateRecipe): unknown;
    fromPartial(object: DeepPartial<EventUpdateRecipe>): EventUpdateRecipe;
};
export declare const EventCreateExecution: {
    encode(message: EventCreateExecution, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateExecution;
    fromJSON(object: any): EventCreateExecution;
    toJSON(message: EventCreateExecution): unknown;
    fromPartial(object: DeepPartial<EventCreateExecution>): EventCreateExecution;
};
export declare const EventCompleteExecution: {
    encode(message: EventCompleteExecution, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCompleteExecution;
    fromJSON(object: any): EventCompleteExecution;
    toJSON(message: EventCompleteExecution): unknown;
    fromPartial(object: DeepPartial<EventCompleteExecution>): EventCompleteExecution;
};
export declare const EventDropExecution: {
    encode(message: EventDropExecution, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventDropExecution;
    fromJSON(object: any): EventDropExecution;
    toJSON(message: EventDropExecution): unknown;
    fromPartial(object: DeepPartial<EventDropExecution>): EventDropExecution;
};
export declare const EventCompleteExecutionEarly: {
    encode(message: EventCompleteExecutionEarly, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCompleteExecutionEarly;
    fromJSON(object: any): EventCompleteExecutionEarly;
    toJSON(message: EventCompleteExecutionEarly): unknown;
    fromPartial(object: DeepPartial<EventCompleteExecutionEarly>): EventCompleteExecutionEarly;
};
export declare const EventSendItems: {
    encode(message: EventSendItems, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventSendItems;
    fromJSON(object: any): EventSendItems;
    toJSON(message: EventSendItems): unknown;
    fromPartial(object: DeepPartial<EventSendItems>): EventSendItems;
};
export declare const EventSetItemString: {
    encode(message: EventSetItemString, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventSetItemString;
    fromJSON(object: any): EventSetItemString;
    toJSON(message: EventSetItemString): unknown;
    fromPartial(object: DeepPartial<EventSetItemString>): EventSetItemString;
};
export declare const EventCreateTrade: {
    encode(message: EventCreateTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateTrade;
    fromJSON(object: any): EventCreateTrade;
    toJSON(message: EventCreateTrade): unknown;
    fromPartial(object: DeepPartial<EventCreateTrade>): EventCreateTrade;
};
export declare const EventCancelTrade: {
    encode(message: EventCancelTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCancelTrade;
    fromJSON(object: any): EventCancelTrade;
    toJSON(message: EventCancelTrade): unknown;
    fromPartial(object: DeepPartial<EventCancelTrade>): EventCancelTrade;
};
export declare const EventFulfillTrade: {
    encode(message: EventFulfillTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventFulfillTrade;
    fromJSON(object: any): EventFulfillTrade;
    toJSON(message: EventFulfillTrade): unknown;
    fromPartial(object: DeepPartial<EventFulfillTrade>): EventFulfillTrade;
};
export declare const EventCreateFighter: {
    encode(message: EventCreateFighter, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCreateFighter;
    fromJSON(object: any): EventCreateFighter;
    toJSON(message: EventCreateFighter): unknown;
    fromPartial(object: DeepPartial<EventCreateFighter>): EventCreateFighter;
};
export declare const EventCancelFighter: {
    encode(message: EventCancelFighter, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventCancelFighter;
    fromJSON(object: any): EventCancelFighter;
    toJSON(message: EventCancelFighter): unknown;
    fromPartial(object: DeepPartial<EventCancelFighter>): EventCancelFighter;
};
export declare const EventFulfillFight: {
    encode(message: EventFulfillFight, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventFulfillFight;
    fromJSON(object: any): EventFulfillFight;
    toJSON(message: EventFulfillFight): unknown;
    fromPartial(object: DeepPartial<EventFulfillFight>): EventFulfillFight;
};
export declare const EventGooglePurchase: {
    encode(message: EventGooglePurchase, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventGooglePurchase;
    fromJSON(object: any): EventGooglePurchase;
    toJSON(message: EventGooglePurchase): unknown;
    fromPartial(object: DeepPartial<EventGooglePurchase>): EventGooglePurchase;
};
export declare const EventStripePurchase: {
    encode(message: EventStripePurchase, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EventStripePurchase;
    fromJSON(object: any): EventStripePurchase;
    toJSON(message: EventStripePurchase): unknown;
    fromPartial(object: DeepPartial<EventStripePurchase>): EventStripePurchase;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
