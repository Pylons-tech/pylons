import { Reader, Writer } from 'protobufjs/minimal';
import { Username } from '../pylons/username';
import { PageRequest, PageResponse } from '../cosmos/base/query/v1beta1/pagination';
import { Trade } from '../pylons/trade';
import { Item } from '../pylons/item';
import { GoogleInAppPurchaseOrder } from '../pylons/google_iap_order';
import { Execution } from '../pylons/execution';
import { Recipe } from '../pylons/recipe';
import { Cookbook } from '../pylons/cookbook';
export declare const protobufPackage = "Pylonstech.pylons.pylons";
/** this line is used by starport scaffolding # 3 */
export interface QueryGetUsernameRequest {
    account: string;
}
export interface QueryGetUsernameResponse {
    username: Username | undefined;
}
export interface QueryAllUsernameRequest {
    pagination: PageRequest | undefined;
}
export interface QueryAllUsernameResponse {
    username: Username[];
    pagination: PageResponse | undefined;
}
export interface QueryGetTradeRequest {
    ID: number;
}
export interface QueryGetTradeResponse {
    Trade: Trade | undefined;
}
export interface QueryListItemByOwnerRequest {
    owner: string;
    /** pagination defines an optional pagination for the request. */
    pagination: PageRequest | undefined;
}
export interface QueryListItemByOwnerResponse {
    Items: Item[];
    /** pagination defines the pagination in the response. */
    pagination: PageResponse | undefined;
}
export interface QueryGetGoogleInAppPurchaseOrderRequest {
    PurchaseToken: string;
}
export interface QueryGetGoogleInAppPurchaseOrderResponse {
    Order: GoogleInAppPurchaseOrder | undefined;
}
export interface QueryListExecutionsByItemRequest {
    CookbookID: string;
    ItemID: string;
    /** pagination defines an optional pagination for the request. */
    pagination: PageRequest | undefined;
}
export interface QueryListExecutionsByItemResponse {
    CompletedExecutions: Execution[];
    PendingExecutions: Execution[];
    /** pagination defines the pagination in the response. */
    pagination: PageResponse | undefined;
}
export interface QueryListExecutionsByRecipeRequest {
    CookbookID: string;
    RecipeID: string;
    /** pagination defines an optional pagination for the request. */
    pagination: PageRequest | undefined;
}
export interface QueryListExecutionsByRecipeResponse {
    CompletedExecutions: Execution[];
    PendingExecutions: Execution[];
    /** pagination defines the pagination in the response. */
    pagination: PageResponse | undefined;
}
export interface QueryGetExecutionRequest {
    ID: string;
}
export interface QueryGetExecutionResponse {
    Execution: Execution | undefined;
    Completed: boolean;
}
export interface QueryListRecipesByCookbookRequest {
    CookbookID: string;
    /** pagination defines an optional pagination for the request. */
    pagination: PageRequest | undefined;
}
export interface QueryListRecipesByCookbookResponse {
    Recipes: Recipe[];
    /** pagination defines the pagination in the response. */
    pagination: PageResponse | undefined;
}
export interface QueryGetItemRequest {
    CookbookID: string;
    ID: string;
}
export interface QueryGetItemResponse {
    Item: Item | undefined;
}
export interface QueryGetRecipeRequest {
    CookbookID: string;
    ID: string;
}
export interface QueryGetRecipeResponse {
    Recipe: Recipe | undefined;
}
export interface QueryListCookbooksByCreatorRequest {
    creator: string;
    /** pagination defines an optional pagination for the request. */
    pagination: PageRequest | undefined;
}
export interface QueryListCookbooksByCreatorResponse {
    Cookbooks: Cookbook[];
    /** pagination defines the pagination in the response. */
    pagination: PageResponse | undefined;
}
export interface QueryGetCookbookRequest {
    ID: string;
}
export interface QueryGetCookbookResponse {
    Cookbook: Cookbook | undefined;
}
export declare const QueryGetUsernameRequest: {
    encode(message: QueryGetUsernameRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetUsernameRequest;
    fromJSON(object: any): QueryGetUsernameRequest;
    toJSON(message: QueryGetUsernameRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetUsernameRequest>): QueryGetUsernameRequest;
};
export declare const QueryGetUsernameResponse: {
    encode(message: QueryGetUsernameResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetUsernameResponse;
    fromJSON(object: any): QueryGetUsernameResponse;
    toJSON(message: QueryGetUsernameResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetUsernameResponse>): QueryGetUsernameResponse;
};
export declare const QueryAllUsernameRequest: {
    encode(message: QueryAllUsernameRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryAllUsernameRequest;
    fromJSON(object: any): QueryAllUsernameRequest;
    toJSON(message: QueryAllUsernameRequest): unknown;
    fromPartial(object: DeepPartial<QueryAllUsernameRequest>): QueryAllUsernameRequest;
};
export declare const QueryAllUsernameResponse: {
    encode(message: QueryAllUsernameResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryAllUsernameResponse;
    fromJSON(object: any): QueryAllUsernameResponse;
    toJSON(message: QueryAllUsernameResponse): unknown;
    fromPartial(object: DeepPartial<QueryAllUsernameResponse>): QueryAllUsernameResponse;
};
export declare const QueryGetTradeRequest: {
    encode(message: QueryGetTradeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetTradeRequest;
    fromJSON(object: any): QueryGetTradeRequest;
    toJSON(message: QueryGetTradeRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetTradeRequest>): QueryGetTradeRequest;
};
export declare const QueryGetTradeResponse: {
    encode(message: QueryGetTradeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetTradeResponse;
    fromJSON(object: any): QueryGetTradeResponse;
    toJSON(message: QueryGetTradeResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetTradeResponse>): QueryGetTradeResponse;
};
export declare const QueryListItemByOwnerRequest: {
    encode(message: QueryListItemByOwnerRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListItemByOwnerRequest;
    fromJSON(object: any): QueryListItemByOwnerRequest;
    toJSON(message: QueryListItemByOwnerRequest): unknown;
    fromPartial(object: DeepPartial<QueryListItemByOwnerRequest>): QueryListItemByOwnerRequest;
};
export declare const QueryListItemByOwnerResponse: {
    encode(message: QueryListItemByOwnerResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListItemByOwnerResponse;
    fromJSON(object: any): QueryListItemByOwnerResponse;
    toJSON(message: QueryListItemByOwnerResponse): unknown;
    fromPartial(object: DeepPartial<QueryListItemByOwnerResponse>): QueryListItemByOwnerResponse;
};
export declare const QueryGetGoogleInAppPurchaseOrderRequest: {
    encode(message: QueryGetGoogleInAppPurchaseOrderRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetGoogleInAppPurchaseOrderRequest;
    fromJSON(object: any): QueryGetGoogleInAppPurchaseOrderRequest;
    toJSON(message: QueryGetGoogleInAppPurchaseOrderRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetGoogleInAppPurchaseOrderRequest>): QueryGetGoogleInAppPurchaseOrderRequest;
};
export declare const QueryGetGoogleInAppPurchaseOrderResponse: {
    encode(message: QueryGetGoogleInAppPurchaseOrderResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetGoogleInAppPurchaseOrderResponse;
    fromJSON(object: any): QueryGetGoogleInAppPurchaseOrderResponse;
    toJSON(message: QueryGetGoogleInAppPurchaseOrderResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetGoogleInAppPurchaseOrderResponse>): QueryGetGoogleInAppPurchaseOrderResponse;
};
export declare const QueryListExecutionsByItemRequest: {
    encode(message: QueryListExecutionsByItemRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByItemRequest;
    fromJSON(object: any): QueryListExecutionsByItemRequest;
    toJSON(message: QueryListExecutionsByItemRequest): unknown;
    fromPartial(object: DeepPartial<QueryListExecutionsByItemRequest>): QueryListExecutionsByItemRequest;
};
export declare const QueryListExecutionsByItemResponse: {
    encode(message: QueryListExecutionsByItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByItemResponse;
    fromJSON(object: any): QueryListExecutionsByItemResponse;
    toJSON(message: QueryListExecutionsByItemResponse): unknown;
    fromPartial(object: DeepPartial<QueryListExecutionsByItemResponse>): QueryListExecutionsByItemResponse;
};
export declare const QueryListExecutionsByRecipeRequest: {
    encode(message: QueryListExecutionsByRecipeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByRecipeRequest;
    fromJSON(object: any): QueryListExecutionsByRecipeRequest;
    toJSON(message: QueryListExecutionsByRecipeRequest): unknown;
    fromPartial(object: DeepPartial<QueryListExecutionsByRecipeRequest>): QueryListExecutionsByRecipeRequest;
};
export declare const QueryListExecutionsByRecipeResponse: {
    encode(message: QueryListExecutionsByRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListExecutionsByRecipeResponse;
    fromJSON(object: any): QueryListExecutionsByRecipeResponse;
    toJSON(message: QueryListExecutionsByRecipeResponse): unknown;
    fromPartial(object: DeepPartial<QueryListExecutionsByRecipeResponse>): QueryListExecutionsByRecipeResponse;
};
export declare const QueryGetExecutionRequest: {
    encode(message: QueryGetExecutionRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetExecutionRequest;
    fromJSON(object: any): QueryGetExecutionRequest;
    toJSON(message: QueryGetExecutionRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetExecutionRequest>): QueryGetExecutionRequest;
};
export declare const QueryGetExecutionResponse: {
    encode(message: QueryGetExecutionResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetExecutionResponse;
    fromJSON(object: any): QueryGetExecutionResponse;
    toJSON(message: QueryGetExecutionResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetExecutionResponse>): QueryGetExecutionResponse;
};
export declare const QueryListRecipesByCookbookRequest: {
    encode(message: QueryListRecipesByCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListRecipesByCookbookRequest;
    fromJSON(object: any): QueryListRecipesByCookbookRequest;
    toJSON(message: QueryListRecipesByCookbookRequest): unknown;
    fromPartial(object: DeepPartial<QueryListRecipesByCookbookRequest>): QueryListRecipesByCookbookRequest;
};
export declare const QueryListRecipesByCookbookResponse: {
    encode(message: QueryListRecipesByCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListRecipesByCookbookResponse;
    fromJSON(object: any): QueryListRecipesByCookbookResponse;
    toJSON(message: QueryListRecipesByCookbookResponse): unknown;
    fromPartial(object: DeepPartial<QueryListRecipesByCookbookResponse>): QueryListRecipesByCookbookResponse;
};
export declare const QueryGetItemRequest: {
    encode(message: QueryGetItemRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetItemRequest;
    fromJSON(object: any): QueryGetItemRequest;
    toJSON(message: QueryGetItemRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetItemRequest>): QueryGetItemRequest;
};
export declare const QueryGetItemResponse: {
    encode(message: QueryGetItemResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetItemResponse;
    fromJSON(object: any): QueryGetItemResponse;
    toJSON(message: QueryGetItemResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetItemResponse>): QueryGetItemResponse;
};
export declare const QueryGetRecipeRequest: {
    encode(message: QueryGetRecipeRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetRecipeRequest;
    fromJSON(object: any): QueryGetRecipeRequest;
    toJSON(message: QueryGetRecipeRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetRecipeRequest>): QueryGetRecipeRequest;
};
export declare const QueryGetRecipeResponse: {
    encode(message: QueryGetRecipeResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetRecipeResponse;
    fromJSON(object: any): QueryGetRecipeResponse;
    toJSON(message: QueryGetRecipeResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetRecipeResponse>): QueryGetRecipeResponse;
};
export declare const QueryListCookbooksByCreatorRequest: {
    encode(message: QueryListCookbooksByCreatorRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListCookbooksByCreatorRequest;
    fromJSON(object: any): QueryListCookbooksByCreatorRequest;
    toJSON(message: QueryListCookbooksByCreatorRequest): unknown;
    fromPartial(object: DeepPartial<QueryListCookbooksByCreatorRequest>): QueryListCookbooksByCreatorRequest;
};
export declare const QueryListCookbooksByCreatorResponse: {
    encode(message: QueryListCookbooksByCreatorResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryListCookbooksByCreatorResponse;
    fromJSON(object: any): QueryListCookbooksByCreatorResponse;
    toJSON(message: QueryListCookbooksByCreatorResponse): unknown;
    fromPartial(object: DeepPartial<QueryListCookbooksByCreatorResponse>): QueryListCookbooksByCreatorResponse;
};
export declare const QueryGetCookbookRequest: {
    encode(message: QueryGetCookbookRequest, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetCookbookRequest;
    fromJSON(object: any): QueryGetCookbookRequest;
    toJSON(message: QueryGetCookbookRequest): unknown;
    fromPartial(object: DeepPartial<QueryGetCookbookRequest>): QueryGetCookbookRequest;
};
export declare const QueryGetCookbookResponse: {
    encode(message: QueryGetCookbookResponse, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): QueryGetCookbookResponse;
    fromJSON(object: any): QueryGetCookbookResponse;
    toJSON(message: QueryGetCookbookResponse): unknown;
    fromPartial(object: DeepPartial<QueryGetCookbookResponse>): QueryGetCookbookResponse;
};
/** Query defines the gRPC querier service. */
export interface Query {
    /** Queries a username by account. */
    Username(request: QueryGetUsernameRequest): Promise<QueryGetUsernameResponse>;
    /** Queries a list of username items. */
    UsernameAll(request: QueryAllUsernameRequest): Promise<QueryAllUsernameResponse>;
    /** Queries a trade by id. */
    Trade(request: QueryGetTradeRequest): Promise<QueryGetTradeResponse>;
    /** Queries a list of listItemByOwner items. */
    ListItemByOwner(request: QueryListItemByOwnerRequest): Promise<QueryListItemByOwnerResponse>;
    /** Queries a googleIAPOrder by PurchaseToken. */
    GoogleInAppPurchaseOrder(request: QueryGetGoogleInAppPurchaseOrderRequest): Promise<QueryGetGoogleInAppPurchaseOrderResponse>;
    /** Queries a list of listExecutionsByItem items. */
    ListExecutionsByItem(request: QueryListExecutionsByItemRequest): Promise<QueryListExecutionsByItemResponse>;
    /** Queries a list of listExecutionsByRecipe items. */
    ListExecutionsByRecipe(request: QueryListExecutionsByRecipeRequest): Promise<QueryListExecutionsByRecipeResponse>;
    /** Queries a execution by id. */
    Execution(request: QueryGetExecutionRequest): Promise<QueryGetExecutionResponse>;
    /** Queries a list of listRecipesByCookbook items. */
    ListRecipesByCookbook(request: QueryListRecipesByCookbookRequest): Promise<QueryListRecipesByCookbookResponse>;
    /** Queries a item by ID. */
    Item(request: QueryGetItemRequest): Promise<QueryGetItemResponse>;
    /** Retrieves a recipe by ID. */
    Recipe(request: QueryGetRecipeRequest): Promise<QueryGetRecipeResponse>;
    /** Retrieves the list of cookbooks owned by an address */
    ListCookbooksByCreator(request: QueryListCookbooksByCreatorRequest): Promise<QueryListCookbooksByCreatorResponse>;
    /** Retrieves a cookbook by ID. */
    Cookbook(request: QueryGetCookbookRequest): Promise<QueryGetCookbookResponse>;
}
export declare class QueryClientImpl implements Query {
    private readonly rpc;
    constructor(rpc: Rpc);
    Username(request: QueryGetUsernameRequest): Promise<QueryGetUsernameResponse>;
    UsernameAll(request: QueryAllUsernameRequest): Promise<QueryAllUsernameResponse>;
    Trade(request: QueryGetTradeRequest): Promise<QueryGetTradeResponse>;
    ListItemByOwner(request: QueryListItemByOwnerRequest): Promise<QueryListItemByOwnerResponse>;
    GoogleInAppPurchaseOrder(request: QueryGetGoogleInAppPurchaseOrderRequest): Promise<QueryGetGoogleInAppPurchaseOrderResponse>;
    ListExecutionsByItem(request: QueryListExecutionsByItemRequest): Promise<QueryListExecutionsByItemResponse>;
    ListExecutionsByRecipe(request: QueryListExecutionsByRecipeRequest): Promise<QueryListExecutionsByRecipeResponse>;
    Execution(request: QueryGetExecutionRequest): Promise<QueryGetExecutionResponse>;
    ListRecipesByCookbook(request: QueryListRecipesByCookbookRequest): Promise<QueryListRecipesByCookbookResponse>;
    Item(request: QueryGetItemRequest): Promise<QueryGetItemResponse>;
    Recipe(request: QueryGetRecipeRequest): Promise<QueryGetRecipeResponse>;
    ListCookbooksByCreator(request: QueryListCookbooksByCreatorRequest): Promise<QueryListCookbooksByCreatorResponse>;
    Cookbook(request: QueryGetCookbookRequest): Promise<QueryGetCookbookResponse>;
}
interface Rpc {
    request(service: string, method: string, data: Uint8Array): Promise<Uint8Array>;
}
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
