import { Reader, Writer } from 'protobufjs/minimal';
import { Coin } from '../cosmos/base/v1beta1/coin';
import { Item, CoinInput, ItemInput, EntriesList, WeightedOutputs, TradeItemInput, Cookbook, Execution, LockedCoinDescribe, Recipe, ShortenRecipe, Trade } from '../pylons/pylons';
export declare const protobufPackage = "pylons";
export interface AddrFromPubKeyRequest {
    hexPubKey: string;
}
export interface AddrFromPubKeyResponse {
    Bech32Addr: string;
}
export interface CheckGoogleIapOrderRequest {
    purchaseToken: string;
}
export interface CheckGoogleIapOrderResponse {
    purchaseToken: string;
    exist: boolean;
}
export interface GetCookbookRequest {
    cookbookID: string;
}
export interface GetCookbookResponse {
    NodeVersion: string;
    ID: string;
    Name: string;
    Description: string;
    Version: string;
    Developer: string;
    Level: number;
    SupportEmail: string;
    CostPerBlock: number;
    Sender: string;
}
export interface GetExecutionRequest {
    executionID: string;
}
export interface GetExecutionResponse {
    NodeVersion: string;
    ID: string;
    RecipeID: string;
    CookbookID: string;
    CoinsInput: Coin[];
    ItemInputs: Item[];
    BlockHeight: number;
    Sender: string;
    Completed: boolean;
}
export interface GetItemRequest {
    itemID: string;
}
export interface GetItemResponse {
    item: Item | undefined;
}
export interface GetRecipeRequest {
    recipeID: string;
}
export interface GetRecipeResponse {
    NodeVersion: string;
    ID: string;
    CookbookID: string;
    Name: string;
    CoinInputs: CoinInput[];
    ItemInputs: ItemInput[];
    Entries: EntriesList | undefined;
    Outputs: WeightedOutputs[];
    Description: string;
    BlockInterval: number;
    Sender: string;
    Disabled: boolean;
    ExtraInfo: string;
}
export interface GetTradeRequest {
    tradeID: string;
}
export interface GetTradeResponse {
    NodeVersion: string;
    ID: string;
    CoinInputs: CoinInput[];
    ItemInputs: TradeItemInput[];
    CoinOutputs: Coin[];
    ItemOutputs: Item[];
    ExtraInfo: string;
    Sender: string;
    FulFiller: string;
    Disabled: boolean;
    Completed: boolean;
}
export interface ItemsByCookbookRequest {
    cookbookID: string;
}
export interface ItemsByCookbookResponse {
    Items: Item[];
}
export interface ItemsBySenderRequest {
    sender: string;
}
export interface ItemsBySenderResponse {
    Items: Item[];
}
export interface ListCookbookRequest {
    address: string;
}
export interface ListCookbookResponse {
    Cookbooks: Cookbook[];
}
export interface ListExecutionsRequest {
    sender: string;
}
export interface ListExecutionsResponse {
    Executions: Execution[];
}
export interface GetLockedCoinsRequest {
    address: string;
}
export interface GetLockedCoinsResponse {
    NodeVersion: string;
    Sender: string;
    Amount: Coin[];
}
export interface GetLockedCoinDetailsRequest {
    address: string;
}
export interface GetLockedCoinDetailsResponse {
    sender: string;
    Amount: Coin[];
    LockCoinTrades: LockedCoinDescribe[];
    LockCoinExecs: LockedCoinDescribe[];
}
export interface ListRecipeRequest {
    address: string;
}
export interface ListRecipeResponse {
    recipes: Recipe[];
}
export interface ListRecipeByCookbookRequest {
    cookbookID: string;
}
export interface ListRecipeByCookbookResponse {
    recipes: Recipe[];
}
export interface ListShortenRecipeRequest {
    address: string;
}
export interface ListShortenRecipeResponse {
    recipes: ShortenRecipe[];
}
export interface ListShortenRecipeByCookbookRequest {
    cookbookID: string;
}
export interface ListShortenRecipeByCookbookResponse {
    recipes: ShortenRecipe[];
}
export interface ListTradeRequest {
    address: string;
}
export interface ListTradeResponse {
    trades: Trade[];
}
export interface PylonsBalanceRequest {
    address: string;
}
export interface PylonsBalanceResponse {
    balance: number;
}
export declare const AddrFromPubKeyRequest: {
    encode(message: AddrFromPubKeyRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): AddrFromPubKeyRequest;
    fromJSON(object: any): AddrFromPubKeyRequest;
    toJSON(message: AddrFromPubKeyRequest): unknown;
    fromPartial(object: DeepPartial<AddrFromPubKeyRequest>): AddrFromPubKeyRequest;
};
export declare const AddrFromPubKeyResponse: {
    encode(message: AddrFromPubKeyResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): AddrFromPubKeyResponse;
    fromJSON(object: any): AddrFromPubKeyResponse;
    toJSON(message: AddrFromPubKeyResponse): unknown;
    fromPartial(object: DeepPartial<AddrFromPubKeyResponse>): AddrFromPubKeyResponse;
};
export declare const CheckGoogleIapOrderRequest: {
    encode(message: CheckGoogleIapOrderRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): CheckGoogleIapOrderRequest;
    fromJSON(object: any): CheckGoogleIapOrderRequest;
    toJSON(message: CheckGoogleIapOrderRequest): unknown;
    fromPartial(object: DeepPartial<CheckGoogleIapOrderRequest>): CheckGoogleIapOrderRequest;
};
export declare const CheckGoogleIapOrderResponse: {
    encode(message: CheckGoogleIapOrderResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): CheckGoogleIapOrderResponse;
    fromJSON(object: any): CheckGoogleIapOrderResponse;
    toJSON(message: CheckGoogleIapOrderResponse): unknown;
    fromPartial(object: DeepPartial<CheckGoogleIapOrderResponse>): CheckGoogleIapOrderResponse;
};
export declare const GetCookbookRequest: {
    encode(message: GetCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetCookbookRequest;
    fromJSON(object: any): GetCookbookRequest;
    toJSON(message: GetCookbookRequest): unknown;
    fromPartial(object: DeepPartial<GetCookbookRequest>): GetCookbookRequest;
};
export declare const GetCookbookResponse: {
    encode(message: GetCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetCookbookResponse;
    fromJSON(object: any): GetCookbookResponse;
    toJSON(message: GetCookbookResponse): unknown;
    fromPartial(object: DeepPartial<GetCookbookResponse>): GetCookbookResponse;
};
export declare const GetExecutionRequest: {
    encode(message: GetExecutionRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetExecutionRequest;
    fromJSON(object: any): GetExecutionRequest;
    toJSON(message: GetExecutionRequest): unknown;
    fromPartial(object: DeepPartial<GetExecutionRequest>): GetExecutionRequest;
};
export declare const GetExecutionResponse: {
    encode(message: GetExecutionResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetExecutionResponse;
    fromJSON(object: any): GetExecutionResponse;
    toJSON(message: GetExecutionResponse): unknown;
    fromPartial(object: DeepPartial<GetExecutionResponse>): GetExecutionResponse;
};
export declare const GetItemRequest: {
    encode(message: GetItemRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetItemRequest;
    fromJSON(object: any): GetItemRequest;
    toJSON(message: GetItemRequest): unknown;
    fromPartial(object: DeepPartial<GetItemRequest>): GetItemRequest;
};
export declare const GetItemResponse: {
    encode(message: GetItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetItemResponse;
    fromJSON(object: any): GetItemResponse;
    toJSON(message: GetItemResponse): unknown;
    fromPartial(object: DeepPartial<GetItemResponse>): GetItemResponse;
};
export declare const GetRecipeRequest: {
    encode(message: GetRecipeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetRecipeRequest;
    fromJSON(object: any): GetRecipeRequest;
    toJSON(message: GetRecipeRequest): unknown;
    fromPartial(object: DeepPartial<GetRecipeRequest>): GetRecipeRequest;
};
export declare const GetRecipeResponse: {
    encode(message: GetRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetRecipeResponse;
    fromJSON(object: any): GetRecipeResponse;
    toJSON(message: GetRecipeResponse): unknown;
    fromPartial(object: DeepPartial<GetRecipeResponse>): GetRecipeResponse;
};
export declare const GetTradeRequest: {
    encode(message: GetTradeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetTradeRequest;
    fromJSON(object: any): GetTradeRequest;
    toJSON(message: GetTradeRequest): unknown;
    fromPartial(object: DeepPartial<GetTradeRequest>): GetTradeRequest;
};
export declare const GetTradeResponse: {
    encode(message: GetTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetTradeResponse;
    fromJSON(object: any): GetTradeResponse;
    toJSON(message: GetTradeResponse): unknown;
    fromPartial(object: DeepPartial<GetTradeResponse>): GetTradeResponse;
};
export declare const ItemsByCookbookRequest: {
    encode(message: ItemsByCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemsByCookbookRequest;
    fromJSON(object: any): ItemsByCookbookRequest;
    toJSON(message: ItemsByCookbookRequest): unknown;
    fromPartial(object: DeepPartial<ItemsByCookbookRequest>): ItemsByCookbookRequest;
};
export declare const ItemsByCookbookResponse: {
    encode(message: ItemsByCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemsByCookbookResponse;
    fromJSON(object: any): ItemsByCookbookResponse;
    toJSON(message: ItemsByCookbookResponse): unknown;
    fromPartial(object: DeepPartial<ItemsByCookbookResponse>): ItemsByCookbookResponse;
};
export declare const ItemsBySenderRequest: {
    encode(message: ItemsBySenderRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemsBySenderRequest;
    fromJSON(object: any): ItemsBySenderRequest;
    toJSON(message: ItemsBySenderRequest): unknown;
    fromPartial(object: DeepPartial<ItemsBySenderRequest>): ItemsBySenderRequest;
};
export declare const ItemsBySenderResponse: {
    encode(message: ItemsBySenderResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemsBySenderResponse;
    fromJSON(object: any): ItemsBySenderResponse;
    toJSON(message: ItemsBySenderResponse): unknown;
    fromPartial(object: DeepPartial<ItemsBySenderResponse>): ItemsBySenderResponse;
};
export declare const ListCookbookRequest: {
    encode(message: ListCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListCookbookRequest;
    fromJSON(object: any): ListCookbookRequest;
    toJSON(message: ListCookbookRequest): unknown;
    fromPartial(object: DeepPartial<ListCookbookRequest>): ListCookbookRequest;
};
export declare const ListCookbookResponse: {
    encode(message: ListCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListCookbookResponse;
    fromJSON(object: any): ListCookbookResponse;
    toJSON(message: ListCookbookResponse): unknown;
    fromPartial(object: DeepPartial<ListCookbookResponse>): ListCookbookResponse;
};
export declare const ListExecutionsRequest: {
    encode(message: ListExecutionsRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListExecutionsRequest;
    fromJSON(object: any): ListExecutionsRequest;
    toJSON(message: ListExecutionsRequest): unknown;
    fromPartial(object: DeepPartial<ListExecutionsRequest>): ListExecutionsRequest;
};
export declare const ListExecutionsResponse: {
    encode(message: ListExecutionsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListExecutionsResponse;
    fromJSON(object: any): ListExecutionsResponse;
    toJSON(message: ListExecutionsResponse): unknown;
    fromPartial(object: DeepPartial<ListExecutionsResponse>): ListExecutionsResponse;
};
export declare const GetLockedCoinsRequest: {
    encode(message: GetLockedCoinsRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetLockedCoinsRequest;
    fromJSON(object: any): GetLockedCoinsRequest;
    toJSON(message: GetLockedCoinsRequest): unknown;
    fromPartial(object: DeepPartial<GetLockedCoinsRequest>): GetLockedCoinsRequest;
};
export declare const GetLockedCoinsResponse: {
    encode(message: GetLockedCoinsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetLockedCoinsResponse;
    fromJSON(object: any): GetLockedCoinsResponse;
    toJSON(message: GetLockedCoinsResponse): unknown;
    fromPartial(object: DeepPartial<GetLockedCoinsResponse>): GetLockedCoinsResponse;
};
export declare const GetLockedCoinDetailsRequest: {
    encode(message: GetLockedCoinDetailsRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetLockedCoinDetailsRequest;
    fromJSON(object: any): GetLockedCoinDetailsRequest;
    toJSON(message: GetLockedCoinDetailsRequest): unknown;
    fromPartial(object: DeepPartial<GetLockedCoinDetailsRequest>): GetLockedCoinDetailsRequest;
};
export declare const GetLockedCoinDetailsResponse: {
    encode(message: GetLockedCoinDetailsResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): GetLockedCoinDetailsResponse;
    fromJSON(object: any): GetLockedCoinDetailsResponse;
    toJSON(message: GetLockedCoinDetailsResponse): unknown;
    fromPartial(object: DeepPartial<GetLockedCoinDetailsResponse>): GetLockedCoinDetailsResponse;
};
export declare const ListRecipeRequest: {
    encode(message: ListRecipeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListRecipeRequest;
    fromJSON(object: any): ListRecipeRequest;
    toJSON(message: ListRecipeRequest): unknown;
    fromPartial(object: DeepPartial<ListRecipeRequest>): ListRecipeRequest;
};
export declare const ListRecipeResponse: {
    encode(message: ListRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListRecipeResponse;
    fromJSON(object: any): ListRecipeResponse;
    toJSON(message: ListRecipeResponse): unknown;
    fromPartial(object: DeepPartial<ListRecipeResponse>): ListRecipeResponse;
};
export declare const ListRecipeByCookbookRequest: {
    encode(message: ListRecipeByCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListRecipeByCookbookRequest;
    fromJSON(object: any): ListRecipeByCookbookRequest;
    toJSON(message: ListRecipeByCookbookRequest): unknown;
    fromPartial(object: DeepPartial<ListRecipeByCookbookRequest>): ListRecipeByCookbookRequest;
};
export declare const ListRecipeByCookbookResponse: {
    encode(message: ListRecipeByCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListRecipeByCookbookResponse;
    fromJSON(object: any): ListRecipeByCookbookResponse;
    toJSON(message: ListRecipeByCookbookResponse): unknown;
    fromPartial(object: DeepPartial<ListRecipeByCookbookResponse>): ListRecipeByCookbookResponse;
};
export declare const ListShortenRecipeRequest: {
    encode(message: ListShortenRecipeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeRequest;
    fromJSON(object: any): ListShortenRecipeRequest;
    toJSON(message: ListShortenRecipeRequest): unknown;
    fromPartial(object: DeepPartial<ListShortenRecipeRequest>): ListShortenRecipeRequest;
};
export declare const ListShortenRecipeResponse: {
    encode(message: ListShortenRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeResponse;
    fromJSON(object: any): ListShortenRecipeResponse;
    toJSON(message: ListShortenRecipeResponse): unknown;
    fromPartial(object: DeepPartial<ListShortenRecipeResponse>): ListShortenRecipeResponse;
};
export declare const ListShortenRecipeByCookbookRequest: {
    encode(message: ListShortenRecipeByCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeByCookbookRequest;
    fromJSON(object: any): ListShortenRecipeByCookbookRequest;
    toJSON(message: ListShortenRecipeByCookbookRequest): unknown;
    fromPartial(object: DeepPartial<ListShortenRecipeByCookbookRequest>): ListShortenRecipeByCookbookRequest;
};
export declare const ListShortenRecipeByCookbookResponse: {
    encode(message: ListShortenRecipeByCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListShortenRecipeByCookbookResponse;
    fromJSON(object: any): ListShortenRecipeByCookbookResponse;
    toJSON(message: ListShortenRecipeByCookbookResponse): unknown;
    fromPartial(object: DeepPartial<ListShortenRecipeByCookbookResponse>): ListShortenRecipeByCookbookResponse;
};
export declare const ListTradeRequest: {
    encode(message: ListTradeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListTradeRequest;
    fromJSON(object: any): ListTradeRequest;
    toJSON(message: ListTradeRequest): unknown;
    fromPartial(object: DeepPartial<ListTradeRequest>): ListTradeRequest;
};
export declare const ListTradeResponse: {
    encode(message: ListTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ListTradeResponse;
    fromJSON(object: any): ListTradeResponse;
    toJSON(message: ListTradeResponse): unknown;
    fromPartial(object: DeepPartial<ListTradeResponse>): ListTradeResponse;
};
export declare const PylonsBalanceRequest: {
    encode(message: PylonsBalanceRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): PylonsBalanceRequest;
    fromJSON(object: any): PylonsBalanceRequest;
    toJSON(message: PylonsBalanceRequest): unknown;
    fromPartial(object: DeepPartial<PylonsBalanceRequest>): PylonsBalanceRequest;
};
export declare const PylonsBalanceResponse: {
    encode(message: PylonsBalanceResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): PylonsBalanceResponse;
    fromJSON(object: any): PylonsBalanceResponse;
    toJSON(message: PylonsBalanceResponse): unknown;
    fromPartial(object: DeepPartial<PylonsBalanceResponse>): PylonsBalanceResponse;
};
export interface Query {
    /** AddrFromPubKey returns a bech32 public address from the public key */
    AddrFromPubKey(request: AddrFromPubKeyRequest): Promise<AddrFromPubKeyResponse>;
    /** CheckGoogleIapOrder check if google iap order is given to user with purchase token */
    CheckGoogleIapOrder(request: CheckGoogleIapOrderRequest): Promise<CheckGoogleIapOrderResponse>;
    /** GetCookbook returns a cookbook based on the cookbook id */
    GetCookbook(request: GetCookbookRequest): Promise<GetCookbookResponse>;
    /** GetExecution returns an execution based on the execution id */
    GetExecution(request: GetExecutionRequest): Promise<GetExecutionResponse>;
    /** GetItem returns a item based on the item id */
    GetItem(request: GetItemRequest): Promise<GetItemResponse>;
    /** GetRecipe returns a recipe based on the recipe id */
    GetRecipe(request: GetRecipeRequest): Promise<GetRecipeResponse>;
    /** GetTrade returns a trade based on the trade id */
    GetTrade(request: GetTradeRequest): Promise<GetTradeResponse>;
    /** ItemsByCookbook returns a cookbook based on the cookbook id */
    ItemsByCookbook(request: ItemsByCookbookRequest): Promise<ItemsByCookbookResponse>;
    /** ItemsBySender returns all items based on the sender address */
    ItemsBySender(request: ItemsBySenderRequest): Promise<ItemsBySenderResponse>;
    /** ListCookbook returns a cookbook based on the cookbook id */
    ListCookbook(request: ListCookbookRequest): Promise<ListCookbookResponse>;
    /** ListExecutions lists all the executions based on the sender address */
    ListExecutions(request: ListExecutionsRequest): Promise<ListExecutionsResponse>;
    /** GetLockedCoins returns locked coins based on user */
    GetLockedCoins(request: GetLockedCoinsRequest): Promise<GetLockedCoinsResponse>;
    /** GetLockedCoinDetails returns locked coins with details based on user */
    GetLockedCoinDetails(request: GetLockedCoinDetailsRequest): Promise<GetLockedCoinDetailsResponse>;
    /** ListRecipe returns a recipe based on the recipe id */
    ListRecipe(request: ListRecipeRequest): Promise<ListRecipeResponse>;
    /** ListRecipeByCookbook returns a recipe based on the recipe id */
    ListRecipeByCookbook(request: ListRecipeByCookbookRequest): Promise<ListRecipeByCookbookResponse>;
    /** ListShortenRecipe returns a recipe based on the recipe id */
    ListShortenRecipe(request: ListShortenRecipeRequest): Promise<ListShortenRecipeResponse>;
    /** ListShortenRecipeByCookbook returns a recipe based on the recipe id */
    ListShortenRecipeByCookbook(request: ListShortenRecipeByCookbookRequest): Promise<ListShortenRecipeByCookbookResponse>;
    /** ListTrade returns a trade based on the trade id */
    ListTrade(request: ListTradeRequest): Promise<ListTradeResponse>;
    /** PylonsBalance provides balances in pylons */
    PylonsBalance(request: PylonsBalanceRequest): Promise<PylonsBalanceResponse>;
}
export declare class QueryClientImpl implements Query {
    private readonly rpc;
    constructor(rpc: Rpc);
    AddrFromPubKey(request: AddrFromPubKeyRequest): Promise<AddrFromPubKeyResponse>;
    CheckGoogleIapOrder(request: CheckGoogleIapOrderRequest): Promise<CheckGoogleIapOrderResponse>;
    GetCookbook(request: GetCookbookRequest): Promise<GetCookbookResponse>;
    GetExecution(request: GetExecutionRequest): Promise<GetExecutionResponse>;
    GetItem(request: GetItemRequest): Promise<GetItemResponse>;
    GetRecipe(request: GetRecipeRequest): Promise<GetRecipeResponse>;
    GetTrade(request: GetTradeRequest): Promise<GetTradeResponse>;
    ItemsByCookbook(request: ItemsByCookbookRequest): Promise<ItemsByCookbookResponse>;
    ItemsBySender(request: ItemsBySenderRequest): Promise<ItemsBySenderResponse>;
    ListCookbook(request: ListCookbookRequest): Promise<ListCookbookResponse>;
    ListExecutions(request: ListExecutionsRequest): Promise<ListExecutionsResponse>;
    GetLockedCoins(request: GetLockedCoinsRequest): Promise<GetLockedCoinsResponse>;
    GetLockedCoinDetails(request: GetLockedCoinDetailsRequest): Promise<GetLockedCoinDetailsResponse>;
    ListRecipe(request: ListRecipeRequest): Promise<ListRecipeResponse>;
    ListRecipeByCookbook(request: ListRecipeByCookbookRequest): Promise<ListRecipeByCookbookResponse>;
    ListShortenRecipe(request: ListShortenRecipeRequest): Promise<ListShortenRecipeResponse>;
    ListShortenRecipeByCookbook(request: ListShortenRecipeByCookbookRequest): Promise<ListShortenRecipeByCookbookResponse>;
    ListTrade(request: ListTradeRequest): Promise<ListTradeResponse>;
    PylonsBalance(request: PylonsBalanceRequest): Promise<PylonsBalanceResponse>;
}
interface Rpc {
    request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>;
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
