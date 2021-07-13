import { Reader, Writer } from 'protobufjs/minimal';
import { CoinInput, ItemInput, WeightedOutputs, EntriesList, TradeItemInput, Item, DoubleKeyValue, LongKeyValue, StringKeyValue, StripePrice, StripeInventory } from '../pylons/pylons';
import { Coin } from '../cosmos/base/v1beta1/coin';
export declare const protobufPackage = "pylons";
/** MsgCheckExecution defines a CheckExecution message */
export interface MsgCheckExecution {
    ExecID: string;
    Sender: string;
    /** if this is set to true then we complete the execution by paying for it */
    PayToComplete: boolean;
}
/** CheckExecutionResponse is the response for checkExecution */
export interface MsgCheckExecutionResponse {
    Message: string;
    Status: string;
    Output: Uint8Array;
}
/** MsgCreateAccount defines a CreateAccount message */
export interface MsgCreateAccount {
    Requester: string;
}
/** MsgCreateExecutionResponse is the response for create-account */
export interface MsgCreateExecutionResponse {
    Message: string;
    Status: string;
}
/** Cookbook is a struct that contains all the metadata of a cookbook */
export interface MsgCreateCookbook {
    /** optinal id which can be provided by the developer */
    CookbookID: string;
    Name: string;
    Description: string;
    Version: string;
    Developer: string;
    SupportEmail: string;
    Level: number;
    Sender: string;
    /** Pylons per block to be charged across this cookbook for delayed execution early completion */
    CostPerBlock: number;
}
/** MsgCreateCookbookResponse is a struct of create cookbook response */
export interface MsgCreateCookbookResponse {
    CookbookID: string;
    Message: string;
    Status: string;
}
/** MsgCreateRecipe defines a CreateRecipe message */
export interface MsgCreateRecipe {
    /** optional RecipeID if someone */
    RecipeID: string;
    Name: string;
    /** the cookbook guid */
    CookbookID: string;
    CoinInputs: CoinInput[];
    ItemInputs: ItemInput[];
    Outputs: WeightedOutputs[];
    BlockInterval: number;
    Sender: string;
    Description: string;
    Entries: EntriesList | undefined;
    ExtraInfo: string;
}
/** MsgCreateRecipeResponse is struct of create recipe response */
export interface MsgCreateRecipeResponse {
    RecipeID: string;
    Message: string;
    Status: string;
}
/** MsgCreateTrade defines a CreateTrade message */
export interface MsgCreateTrade {
    CoinInputs: CoinInput[];
    ItemInputs: TradeItemInput[];
    CoinOutputs: Coin[];
    ItemOutputs: Item[];
    ExtraInfo: string;
    Sender: string;
}
/** MsgCreateTradeResponse is struct of create trade response */
export interface MsgCreateTradeResponse {
    TradeID: string;
    Message: string;
    Status: string;
}
/** MsgDisableRecipe defines a DisableRecipe message */
export interface MsgDisableRecipe {
    RecipeID: string;
    Sender: string;
}
/** DisableRecipeResponse is the response for disableRecipe */
export interface MsgDisableRecipeResponse {
    Message: string;
    Status: string;
}
/** MsgDisableTrade defines a DisableTrade message */
export interface MsgDisableTrade {
    TradeID: string;
    Sender: string;
}
/** MsgDisableTradeResponse is the response for enableTrade */
export interface MsgDisableTradeResponse {
    Message: string;
    Status: string;
}
/** MsgEnableRecipe defines a EnableRecipe message */
export interface MsgEnableRecipe {
    RecipeID: string;
    Sender: string;
}
/** MsgEnableRecipeResponse is the response for enableRecipe */
export interface MsgEnableRecipeResponse {
    Message: string;
    Status: string;
}
/** MsgEnableTrade defines a EnableTrade message */
export interface MsgEnableTrade {
    TradeID: string;
    Sender: string;
}
/** MsgEnableTradeResponse is the response for enableTrade */
export interface MsgEnableTradeResponse {
    Message: string;
    Status: string;
}
/** MsgExecuteRecipe defines a SetName message */
export interface MsgExecuteRecipe {
    RecipeID: string;
    Sender: string;
    PaymentId: string;
    PaymentMethod: string;
    ItemIDs: string[];
}
/** ExecuteRecipeResponse is the response for executeRecipe */
export interface MsgExecuteRecipeResponse {
    Message: string;
    Status: string;
    Output: Uint8Array;
}
/** MsgFiatItem is a msg struct to be used to fiat item */
export interface MsgFiatItem {
    CookbookID: string;
    Doubles: DoubleKeyValue[];
    Longs: LongKeyValue[];
    Strings: StringKeyValue[];
    Sender: string;
    TransferFee: number;
}
/** MsgFiatItemResponse is a struct to control fiat item response */
export interface MsgFiatItemResponse {
    ItemID: string;
    Message: string;
    Status: string;
}
/** MsgFulfillTrade defines a FulfillTrade message */
export interface MsgFulfillTrade {
    TradeID: string;
    Sender: string;
    ItemIDs: string[];
}
/** FulfillTradeResponse is the response for fulfillRecipe */
export interface MsgFulfillTradeResponse {
    Message: string;
    Status: string;
}
/** MsgGetPylons defines a GetPylons message */
export interface MsgGetPylons {
    Amount: Coin[];
    Requester: string;
}
/** MsgGetPylonsResponse is the response for get-pylons */
export interface MsgGetPylonsResponse {
    Message: string;
    Status: string;
}
/** MsgGoogleIAPGetPylons defines a GetPylons message */
export interface MsgGoogleIAPGetPylons {
    ProductID: string;
    PurchaseToken: string;
    ReceiptDataBase64: string;
    Signature: string;
    Requester: string;
}
/** MsgGoogleIAPGetPylonsResponse is the response for get-pylons */
export interface MsgGoogleIAPGetPylonsResponse {
    Message: string;
    Status: string;
}
/** MsgSendCoins defines a SendCoins message */
export interface MsgSendCoins {
    Amount: Coin[];
    Sender: string;
    Receiver: string;
}
export interface MsgSendCoinsResponse {
}
/** MsgSendItems defines a SendItems message */
export interface MsgSendItems {
    ItemIDs: string[];
    Sender: string;
    Receiver: string;
}
/** MsgSendItemsResponse is the response for fulfillRecipe */
export interface MsgSendItemsResponse {
    Message: string;
    Status: string;
}
/** MsgUpdateItemString defines a UpdateItemString message */
export interface MsgUpdateItemString {
    Field: string;
    Value: string;
    Sender: string;
    ItemID: string;
}
/** MsgUpdateItemStringResponse is a struct to control update item string response */
export interface MsgUpdateItemStringResponse {
    Status: string;
    Message: string;
}
/** MsgUpdateCookbook defines a UpdateCookbook message */
export interface MsgUpdateCookbook {
    ID: string;
    Description: string;
    Version: string;
    Developer: string;
    SupportEmail: string;
    Sender: string;
}
/** MsgUpdateCookbookResponse is a struct to control update cookbook response */
export interface MsgUpdateCookbookResponse {
    CookbookID: string;
    Message: string;
    Status: string;
}
/** MsgUpdateRecipe defines a UpdateRecipe message */
export interface MsgUpdateRecipe {
    Name: string;
    /** the cookbook guid */
    CookbookID: string;
    /** the recipe guid */
    ID: string;
    CoinInputs: CoinInput[];
    ItemInputs: ItemInput[];
    Outputs: WeightedOutputs[];
    BlockInterval: number;
    Sender: string;
    Description: string;
    Entries: EntriesList | undefined;
    ExtraInfo: string;
}
/** UpdateRecipeResponse is a struct to control update recipe response */
export interface MsgUpdateRecipeResponse {
    RecipeID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreateProduct {
    StripeKey: string;
    Name: string;
    Description: string;
    Images: string[];
    StatementDescriptor: string;
    UnitLabel: string;
    Sender: string;
}
export interface MsgStripeCreateProductResponse {
    ProductID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreatePrice {
    StripeKey: string;
    Product: string;
    Amount: string;
    Currency: string;
    Description: string;
    Sender: string;
}
export interface MsgStripeCreatePriceResponse {
    PriceID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCustomer {
    Email: string;
    PaymentMethod: string;
}
export interface MsgStripeCheckout {
    StripeKey: string;
    PaymentMethod: string;
    Price: StripePrice | undefined;
    Sender: string;
}
export interface MsgStripeCheckoutResponse {
    SessionID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreateSku {
    StripeKey: string;
    Product: string;
    Attributes: StringKeyValue[];
    Price: number;
    Currency: string;
    Inventory: StripeInventory | undefined;
    Sender: string;
}
export interface MsgStripeCreateSkuResponse {
    SKUID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreatePaymentIntent {
    StripeKey: string;
    Amount: number;
    Currency: string;
    SKUID: string;
    Sender: string;
}
export interface MsgStripeCreatePaymentIntentResponse {
    PaymentID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreateAccount {
    StripeKey: string;
    Country: string;
    Email: string;
    Types: string;
    Sender: string;
}
export interface MsgStripeCreateAccountResponse {
    AccountID: string;
    Message: string;
    Status: string;
}
export interface MsgStripeCreateProductSku {
    StripeKey: string;
    Name: string;
    Description: string;
    Images: string[];
    Attributes: StringKeyValue[];
    Price: number;
    Currency: string;
    Inventory: StripeInventory | undefined;
    ClientId: string;
    Sender: string;
}
export interface MsgStripeInfo {
    Sender: string;
}
export interface MsgStripeInfoResponse {
    PubKey: string;
    ClientID: string;
    URI: string;
    Message: string;
    Status: string;
}
export interface MsgStripeOauthToken {
    GrantType: string;
    Code: string;
    Sender: string;
}
export interface MsgStripeOauthTokenResponse {
    AcessToken: string;
    LiveMode: string;
    RefreshToken: string;
    TokenType: string;
    StripePublishKey: string;
    StripeUserID: string;
    Scope: string;
    Message: string;
    Status: string;
}
export declare const MsgCheckExecution: {
    encode(message: MsgCheckExecution, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCheckExecution;
    fromJSON(object: any): MsgCheckExecution;
    toJSON(message: MsgCheckExecution): unknown;
    fromPartial(object: DeepPartial<MsgCheckExecution>): MsgCheckExecution;
};
export declare const MsgCheckExecutionResponse: {
    encode(message: MsgCheckExecutionResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCheckExecutionResponse;
    fromJSON(object: any): MsgCheckExecutionResponse;
    toJSON(message: MsgCheckExecutionResponse): unknown;
    fromPartial(object: DeepPartial<MsgCheckExecutionResponse>): MsgCheckExecutionResponse;
};
export declare const MsgCreateAccount: {
    encode(message: MsgCreateAccount, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateAccount;
    fromJSON(object: any): MsgCreateAccount;
    toJSON(message: MsgCreateAccount): unknown;
    fromPartial(object: DeepPartial<MsgCreateAccount>): MsgCreateAccount;
};
export declare const MsgCreateExecutionResponse: {
    encode(message: MsgCreateExecutionResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateExecutionResponse;
    fromJSON(object: any): MsgCreateExecutionResponse;
    toJSON(message: MsgCreateExecutionResponse): unknown;
    fromPartial(object: DeepPartial<MsgCreateExecutionResponse>): MsgCreateExecutionResponse;
};
export declare const MsgCreateCookbook: {
    encode(message: MsgCreateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbook;
    fromJSON(object: any): MsgCreateCookbook;
    toJSON(message: MsgCreateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgCreateCookbook>): MsgCreateCookbook;
};
export declare const MsgCreateCookbookResponse: {
    encode(message: MsgCreateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateCookbookResponse;
    fromJSON(object: any): MsgCreateCookbookResponse;
    toJSON(message: MsgCreateCookbookResponse): unknown;
    fromPartial(object: DeepPartial<MsgCreateCookbookResponse>): MsgCreateCookbookResponse;
};
export declare const MsgCreateRecipe: {
    encode(message: MsgCreateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipe;
    fromJSON(object: any): MsgCreateRecipe;
    toJSON(message: MsgCreateRecipe): unknown;
    fromPartial(object: DeepPartial<MsgCreateRecipe>): MsgCreateRecipe;
};
export declare const MsgCreateRecipeResponse: {
    encode(message: MsgCreateRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateRecipeResponse;
    fromJSON(object: any): MsgCreateRecipeResponse;
    toJSON(message: MsgCreateRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgCreateRecipeResponse>): MsgCreateRecipeResponse;
};
export declare const MsgCreateTrade: {
    encode(message: MsgCreateTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateTrade;
    fromJSON(object: any): MsgCreateTrade;
    toJSON(message: MsgCreateTrade): unknown;
    fromPartial(object: DeepPartial<MsgCreateTrade>): MsgCreateTrade;
};
export declare const MsgCreateTradeResponse: {
    encode(message: MsgCreateTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgCreateTradeResponse;
    fromJSON(object: any): MsgCreateTradeResponse;
    toJSON(message: MsgCreateTradeResponse): unknown;
    fromPartial(object: DeepPartial<MsgCreateTradeResponse>): MsgCreateTradeResponse;
};
export declare const MsgDisableRecipe: {
    encode(message: MsgDisableRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDisableRecipe;
    fromJSON(object: any): MsgDisableRecipe;
    toJSON(message: MsgDisableRecipe): unknown;
    fromPartial(object: DeepPartial<MsgDisableRecipe>): MsgDisableRecipe;
};
export declare const MsgDisableRecipeResponse: {
    encode(message: MsgDisableRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDisableRecipeResponse;
    fromJSON(object: any): MsgDisableRecipeResponse;
    toJSON(message: MsgDisableRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgDisableRecipeResponse>): MsgDisableRecipeResponse;
};
export declare const MsgDisableTrade: {
    encode(message: MsgDisableTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDisableTrade;
    fromJSON(object: any): MsgDisableTrade;
    toJSON(message: MsgDisableTrade): unknown;
    fromPartial(object: DeepPartial<MsgDisableTrade>): MsgDisableTrade;
};
export declare const MsgDisableTradeResponse: {
    encode(message: MsgDisableTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgDisableTradeResponse;
    fromJSON(object: any): MsgDisableTradeResponse;
    toJSON(message: MsgDisableTradeResponse): unknown;
    fromPartial(object: DeepPartial<MsgDisableTradeResponse>): MsgDisableTradeResponse;
};
export declare const MsgEnableRecipe: {
    encode(message: MsgEnableRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgEnableRecipe;
    fromJSON(object: any): MsgEnableRecipe;
    toJSON(message: MsgEnableRecipe): unknown;
    fromPartial(object: DeepPartial<MsgEnableRecipe>): MsgEnableRecipe;
};
export declare const MsgEnableRecipeResponse: {
    encode(message: MsgEnableRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgEnableRecipeResponse;
    fromJSON(object: any): MsgEnableRecipeResponse;
    toJSON(message: MsgEnableRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgEnableRecipeResponse>): MsgEnableRecipeResponse;
};
export declare const MsgEnableTrade: {
    encode(message: MsgEnableTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgEnableTrade;
    fromJSON(object: any): MsgEnableTrade;
    toJSON(message: MsgEnableTrade): unknown;
    fromPartial(object: DeepPartial<MsgEnableTrade>): MsgEnableTrade;
};
export declare const MsgEnableTradeResponse: {
    encode(message: MsgEnableTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgEnableTradeResponse;
    fromJSON(object: any): MsgEnableTradeResponse;
    toJSON(message: MsgEnableTradeResponse): unknown;
    fromPartial(object: DeepPartial<MsgEnableTradeResponse>): MsgEnableTradeResponse;
};
export declare const MsgExecuteRecipe: {
    encode(message: MsgExecuteRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipe;
    fromJSON(object: any): MsgExecuteRecipe;
    toJSON(message: MsgExecuteRecipe): unknown;
    fromPartial(object: DeepPartial<MsgExecuteRecipe>): MsgExecuteRecipe;
};
export declare const MsgExecuteRecipeResponse: {
    encode(message: MsgExecuteRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgExecuteRecipeResponse;
    fromJSON(object: any): MsgExecuteRecipeResponse;
    toJSON(message: MsgExecuteRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgExecuteRecipeResponse>): MsgExecuteRecipeResponse;
};
export declare const MsgFiatItem: {
    encode(message: MsgFiatItem, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgFiatItem;
    fromJSON(object: any): MsgFiatItem;
    toJSON(message: MsgFiatItem): unknown;
    fromPartial(object: DeepPartial<MsgFiatItem>): MsgFiatItem;
};
export declare const MsgFiatItemResponse: {
    encode(message: MsgFiatItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgFiatItemResponse;
    fromJSON(object: any): MsgFiatItemResponse;
    toJSON(message: MsgFiatItemResponse): unknown;
    fromPartial(object: DeepPartial<MsgFiatItemResponse>): MsgFiatItemResponse;
};
export declare const MsgFulfillTrade: {
    encode(message: MsgFulfillTrade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgFulfillTrade;
    fromJSON(object: any): MsgFulfillTrade;
    toJSON(message: MsgFulfillTrade): unknown;
    fromPartial(object: DeepPartial<MsgFulfillTrade>): MsgFulfillTrade;
};
export declare const MsgFulfillTradeResponse: {
    encode(message: MsgFulfillTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgFulfillTradeResponse;
    fromJSON(object: any): MsgFulfillTradeResponse;
    toJSON(message: MsgFulfillTradeResponse): unknown;
    fromPartial(object: DeepPartial<MsgFulfillTradeResponse>): MsgFulfillTradeResponse;
};
export declare const MsgGetPylons: {
    encode(message: MsgGetPylons, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgGetPylons;
    fromJSON(object: any): MsgGetPylons;
    toJSON(message: MsgGetPylons): unknown;
    fromPartial(object: DeepPartial<MsgGetPylons>): MsgGetPylons;
};
export declare const MsgGetPylonsResponse: {
    encode(message: MsgGetPylonsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgGetPylonsResponse;
    fromJSON(object: any): MsgGetPylonsResponse;
    toJSON(message: MsgGetPylonsResponse): unknown;
    fromPartial(object: DeepPartial<MsgGetPylonsResponse>): MsgGetPylonsResponse;
};
export declare const MsgGoogleIAPGetPylons: {
    encode(message: MsgGoogleIAPGetPylons, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgGoogleIAPGetPylons;
    fromJSON(object: any): MsgGoogleIAPGetPylons;
    toJSON(message: MsgGoogleIAPGetPylons): unknown;
    fromPartial(object: DeepPartial<MsgGoogleIAPGetPylons>): MsgGoogleIAPGetPylons;
};
export declare const MsgGoogleIAPGetPylonsResponse: {
    encode(message: MsgGoogleIAPGetPylonsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgGoogleIAPGetPylonsResponse;
    fromJSON(object: any): MsgGoogleIAPGetPylonsResponse;
    toJSON(message: MsgGoogleIAPGetPylonsResponse): unknown;
    fromPartial(object: DeepPartial<MsgGoogleIAPGetPylonsResponse>): MsgGoogleIAPGetPylonsResponse;
};
export declare const MsgSendCoins: {
    encode(message: MsgSendCoins, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSendCoins;
    fromJSON(object: any): MsgSendCoins;
    toJSON(message: MsgSendCoins): unknown;
    fromPartial(object: DeepPartial<MsgSendCoins>): MsgSendCoins;
};
export declare const MsgSendCoinsResponse: {
    encode(_: MsgSendCoinsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSendCoinsResponse;
    fromJSON(_: any): MsgSendCoinsResponse;
    toJSON(_: MsgSendCoinsResponse): unknown;
    fromPartial(_: DeepPartial<MsgSendCoinsResponse>): MsgSendCoinsResponse;
};
export declare const MsgSendItems: {
    encode(message: MsgSendItems, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSendItems;
    fromJSON(object: any): MsgSendItems;
    toJSON(message: MsgSendItems): unknown;
    fromPartial(object: DeepPartial<MsgSendItems>): MsgSendItems;
};
export declare const MsgSendItemsResponse: {
    encode(message: MsgSendItemsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgSendItemsResponse;
    fromJSON(object: any): MsgSendItemsResponse;
    toJSON(message: MsgSendItemsResponse): unknown;
    fromPartial(object: DeepPartial<MsgSendItemsResponse>): MsgSendItemsResponse;
};
export declare const MsgUpdateItemString: {
    encode(message: MsgUpdateItemString, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemString;
    fromJSON(object: any): MsgUpdateItemString;
    toJSON(message: MsgUpdateItemString): unknown;
    fromPartial(object: DeepPartial<MsgUpdateItemString>): MsgUpdateItemString;
};
export declare const MsgUpdateItemStringResponse: {
    encode(message: MsgUpdateItemStringResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateItemStringResponse;
    fromJSON(object: any): MsgUpdateItemStringResponse;
    toJSON(message: MsgUpdateItemStringResponse): unknown;
    fromPartial(object: DeepPartial<MsgUpdateItemStringResponse>): MsgUpdateItemStringResponse;
};
export declare const MsgUpdateCookbook: {
    encode(message: MsgUpdateCookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbook;
    fromJSON(object: any): MsgUpdateCookbook;
    toJSON(message: MsgUpdateCookbook): unknown;
    fromPartial(object: DeepPartial<MsgUpdateCookbook>): MsgUpdateCookbook;
};
export declare const MsgUpdateCookbookResponse: {
    encode(message: MsgUpdateCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateCookbookResponse;
    fromJSON(object: any): MsgUpdateCookbookResponse;
    toJSON(message: MsgUpdateCookbookResponse): unknown;
    fromPartial(object: DeepPartial<MsgUpdateCookbookResponse>): MsgUpdateCookbookResponse;
};
export declare const MsgUpdateRecipe: {
    encode(message: MsgUpdateRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipe;
    fromJSON(object: any): MsgUpdateRecipe;
    toJSON(message: MsgUpdateRecipe): unknown;
    fromPartial(object: DeepPartial<MsgUpdateRecipe>): MsgUpdateRecipe;
};
export declare const MsgUpdateRecipeResponse: {
    encode(message: MsgUpdateRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgUpdateRecipeResponse;
    fromJSON(object: any): MsgUpdateRecipeResponse;
    toJSON(message: MsgUpdateRecipeResponse): unknown;
    fromPartial(object: DeepPartial<MsgUpdateRecipeResponse>): MsgUpdateRecipeResponse;
};
export declare const MsgStripeCreateProduct: {
    encode(message: MsgStripeCreateProduct, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateProduct;
    fromJSON(object: any): MsgStripeCreateProduct;
    toJSON(message: MsgStripeCreateProduct): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateProduct>): MsgStripeCreateProduct;
};
export declare const MsgStripeCreateProductResponse: {
    encode(message: MsgStripeCreateProductResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateProductResponse;
    fromJSON(object: any): MsgStripeCreateProductResponse;
    toJSON(message: MsgStripeCreateProductResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateProductResponse>): MsgStripeCreateProductResponse;
};
export declare const MsgStripeCreatePrice: {
    encode(message: MsgStripeCreatePrice, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreatePrice;
    fromJSON(object: any): MsgStripeCreatePrice;
    toJSON(message: MsgStripeCreatePrice): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreatePrice>): MsgStripeCreatePrice;
};
export declare const MsgStripeCreatePriceResponse: {
    encode(message: MsgStripeCreatePriceResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreatePriceResponse;
    fromJSON(object: any): MsgStripeCreatePriceResponse;
    toJSON(message: MsgStripeCreatePriceResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreatePriceResponse>): MsgStripeCreatePriceResponse;
};
export declare const MsgStripeCustomer: {
    encode(message: MsgStripeCustomer, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCustomer;
    fromJSON(object: any): MsgStripeCustomer;
    toJSON(message: MsgStripeCustomer): unknown;
    fromPartial(object: DeepPartial<MsgStripeCustomer>): MsgStripeCustomer;
};
export declare const MsgStripeCheckout: {
    encode(message: MsgStripeCheckout, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCheckout;
    fromJSON(object: any): MsgStripeCheckout;
    toJSON(message: MsgStripeCheckout): unknown;
    fromPartial(object: DeepPartial<MsgStripeCheckout>): MsgStripeCheckout;
};
export declare const MsgStripeCheckoutResponse: {
    encode(message: MsgStripeCheckoutResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCheckoutResponse;
    fromJSON(object: any): MsgStripeCheckoutResponse;
    toJSON(message: MsgStripeCheckoutResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCheckoutResponse>): MsgStripeCheckoutResponse;
};
export declare const MsgStripeCreateSku: {
    encode(message: MsgStripeCreateSku, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateSku;
    fromJSON(object: any): MsgStripeCreateSku;
    toJSON(message: MsgStripeCreateSku): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateSku>): MsgStripeCreateSku;
};
export declare const MsgStripeCreateSkuResponse: {
    encode(message: MsgStripeCreateSkuResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateSkuResponse;
    fromJSON(object: any): MsgStripeCreateSkuResponse;
    toJSON(message: MsgStripeCreateSkuResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateSkuResponse>): MsgStripeCreateSkuResponse;
};
export declare const MsgStripeCreatePaymentIntent: {
    encode(message: MsgStripeCreatePaymentIntent, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreatePaymentIntent;
    fromJSON(object: any): MsgStripeCreatePaymentIntent;
    toJSON(message: MsgStripeCreatePaymentIntent): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreatePaymentIntent>): MsgStripeCreatePaymentIntent;
};
export declare const MsgStripeCreatePaymentIntentResponse: {
    encode(message: MsgStripeCreatePaymentIntentResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreatePaymentIntentResponse;
    fromJSON(object: any): MsgStripeCreatePaymentIntentResponse;
    toJSON(message: MsgStripeCreatePaymentIntentResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreatePaymentIntentResponse>): MsgStripeCreatePaymentIntentResponse;
};
export declare const MsgStripeCreateAccount: {
    encode(message: MsgStripeCreateAccount, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateAccount;
    fromJSON(object: any): MsgStripeCreateAccount;
    toJSON(message: MsgStripeCreateAccount): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateAccount>): MsgStripeCreateAccount;
};
export declare const MsgStripeCreateAccountResponse: {
    encode(message: MsgStripeCreateAccountResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateAccountResponse;
    fromJSON(object: any): MsgStripeCreateAccountResponse;
    toJSON(message: MsgStripeCreateAccountResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateAccountResponse>): MsgStripeCreateAccountResponse;
};
export declare const MsgStripeCreateProductSku: {
    encode(message: MsgStripeCreateProductSku, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeCreateProductSku;
    fromJSON(object: any): MsgStripeCreateProductSku;
    toJSON(message: MsgStripeCreateProductSku): unknown;
    fromPartial(object: DeepPartial<MsgStripeCreateProductSku>): MsgStripeCreateProductSku;
};
export declare const MsgStripeInfo: {
    encode(message: MsgStripeInfo, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeInfo;
    fromJSON(object: any): MsgStripeInfo;
    toJSON(message: MsgStripeInfo): unknown;
    fromPartial(object: DeepPartial<MsgStripeInfo>): MsgStripeInfo;
};
export declare const MsgStripeInfoResponse: {
    encode(message: MsgStripeInfoResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeInfoResponse;
    fromJSON(object: any): MsgStripeInfoResponse;
    toJSON(message: MsgStripeInfoResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeInfoResponse>): MsgStripeInfoResponse;
};
export declare const MsgStripeOauthToken: {
    encode(message: MsgStripeOauthToken, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeOauthToken;
    fromJSON(object: any): MsgStripeOauthToken;
    toJSON(message: MsgStripeOauthToken): unknown;
    fromPartial(object: DeepPartial<MsgStripeOauthToken>): MsgStripeOauthToken;
};
export declare const MsgStripeOauthTokenResponse: {
    encode(message: MsgStripeOauthTokenResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): MsgStripeOauthTokenResponse;
    fromJSON(object: any): MsgStripeOauthTokenResponse;
    toJSON(message: MsgStripeOauthTokenResponse): unknown;
    fromPartial(object: DeepPartial<MsgStripeOauthTokenResponse>): MsgStripeOauthTokenResponse;
};
export interface Msg {
    /** CreateAccount is used to send pylons to requesters. This handler is part of the faucet */
    CreateAccount(request: MsgCreateAccount): Promise<MsgCreateExecutionResponse>;
    /** GetPylons is used to send pylons to requesters. This handler is part of the faucet */
    GetPylons(request: MsgGetPylons): Promise<MsgGetPylonsResponse>;
    /** GoogleIAPGetPylons is used to send pylons to requesters after google iap verification */
    GoogleIAPGetPylons(request: MsgGoogleIAPGetPylons): Promise<MsgGoogleIAPGetPylonsResponse>;
    /** SendCoins is used to transact pylons between people */
    SendCoins(request: MsgSendCoins): Promise<MsgSendCoinsResponse>;
    /** SendItems is used to send items between people */
    SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse>;
    /** CreateCookbook is used to create cookbook by a developer */
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    /** HandlerMsgUpdateCookbook is used to update cookbook by a developer */
    HandlerMsgUpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
    /** CreateRecipe is used to create recipe by a developer */
    CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>;
    /** HandlerMsgUpdateRecipe is used to update recipe by a developer */
    HandlerMsgUpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>;
    /** ExecuteRecipe is used to execute a recipe */
    ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>;
    /** StripeCheckout is used to checkout stripe */
    StripeCheckout(request: MsgStripeCheckout): Promise<MsgStripeCheckoutResponse>;
    /** StripeCreateProduct is used to create product of stripe */
    StripeCreateProduct(request: MsgStripeCreateProduct): Promise<MsgStripeCreateProductResponse>;
    /** StripeCreatePrice is used to create price of stripe */
    StripeCreatePrice(request: MsgStripeCreatePrice): Promise<MsgStripeCreatePriceResponse>;
    /** StripeCreateSKU is used to create sku of stripe */
    StripeCreateSku(request: MsgStripeCreateSku): Promise<MsgStripeCreateSkuResponse>;
    /** DisableRecipe is used to disable recipe by a developer */
    DisableRecipe(request: MsgDisableRecipe): Promise<MsgDisableRecipeResponse>;
    /** EnableRecipe is used to enable recipe by a developer */
    EnableRecipe(request: MsgEnableRecipe): Promise<MsgEnableRecipeResponse>;
    /** CheckExecution is used to check the status of an execution */
    CheckExecution(request: MsgCheckExecution): Promise<MsgCheckExecutionResponse>;
    /** FiatItem is used to create item within 1 block execution */
    FiatItem(request: MsgFiatItem): Promise<MsgFiatItemResponse>;
    /** UpdateItemString is used to transact pylons between people */
    UpdateItemString(request: MsgUpdateItemString): Promise<MsgUpdateItemStringResponse>;
    /** CreateTrade is used to create a trade by a user */
    CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse>;
    /** FulfillTrade is used to fulfill a trade */
    FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse>;
    /** DisableTrade is used to enable trade by a developer */
    DisableTrade(request: MsgDisableTrade): Promise<MsgDisableTradeResponse>;
    /** EnableTrade is used to enable trade by a developer */
    EnableTrade(request: MsgEnableTrade): Promise<MsgEnableTradeResponse>;
}
export declare class MsgClientImpl implements Msg {
    private readonly rpc;
    constructor(rpc: Rpc);
    CreateAccount(request: MsgCreateAccount): Promise<MsgCreateExecutionResponse>;
    GetPylons(request: MsgGetPylons): Promise<MsgGetPylonsResponse>;
    GoogleIAPGetPylons(request: MsgGoogleIAPGetPylons): Promise<MsgGoogleIAPGetPylonsResponse>;
    SendCoins(request: MsgSendCoins): Promise<MsgSendCoinsResponse>;
    SendItems(request: MsgSendItems): Promise<MsgSendItemsResponse>;
    CreateCookbook(request: MsgCreateCookbook): Promise<MsgCreateCookbookResponse>;
    HandlerMsgUpdateCookbook(request: MsgUpdateCookbook): Promise<MsgUpdateCookbookResponse>;
    CreateRecipe(request: MsgCreateRecipe): Promise<MsgCreateRecipeResponse>;
    HandlerMsgUpdateRecipe(request: MsgUpdateRecipe): Promise<MsgUpdateRecipeResponse>;
    ExecuteRecipe(request: MsgExecuteRecipe): Promise<MsgExecuteRecipeResponse>;
    StripeCheckout(request: MsgStripeCheckout): Promise<MsgStripeCheckoutResponse>;
    StripeCreateProduct(request: MsgStripeCreateProduct): Promise<MsgStripeCreateProductResponse>;
    StripeCreatePrice(request: MsgStripeCreatePrice): Promise<MsgStripeCreatePriceResponse>;
    StripeCreateSku(request: MsgStripeCreateSku): Promise<MsgStripeCreateSkuResponse>;
    DisableRecipe(request: MsgDisableRecipe): Promise<MsgDisableRecipeResponse>;
    EnableRecipe(request: MsgEnableRecipe): Promise<MsgEnableRecipeResponse>;
    CheckExecution(request: MsgCheckExecution): Promise<MsgCheckExecutionResponse>;
    FiatItem(request: MsgFiatItem): Promise<MsgFiatItemResponse>;
    UpdateItemString(request: MsgUpdateItemString): Promise<MsgUpdateItemStringResponse>;
    CreateTrade(request: MsgCreateTrade): Promise<MsgCreateTradeResponse>;
    FulfillTrade(request: MsgFulfillTrade): Promise<MsgFulfillTradeResponse>;
    DisableTrade(request: MsgDisableTrade): Promise<MsgDisableTradeResponse>;
    EnableTrade(request: MsgEnableTrade): Promise<MsgEnableTradeResponse>;
}
interface Rpc {
    request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>;
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
