export interface ProtobufAny {
    "@type"?: string;
}
export interface PylonsAccountAddr {
    value?: string;
}
export interface PylonsCoinInput {
    coins?: V1Beta1Coin[];
}
export interface PylonsCoinOutput {
    ID?: string;
    /**
     * Coin defines a token with a denomination and an amount.
     *
     * NOTE: The amount field is an Int which implements the custom method
     * signatures required by gogoproto.
     */
    coin?: V1Beta1Coin;
    program?: string;
}
export interface PylonsConditionList {
    doubles?: PylonsDoubleInputParam[];
    longs?: PylonsLongInputParam[];
    strings?: PylonsStringInputParam[];
}
export interface PylonsCookbook {
    creator?: string;
    ID?: string;
    nodeVersion?: string;
    name?: string;
    description?: string;
    developer?: string;
    version?: string;
    supportEmail?: string;
    /**
     * Coin defines a token with a denomination and an amount.
     *
     * NOTE: The amount field is an Int which implements the custom method
     * signatures required by gogoproto.
     */
    costPerBlock?: V1Beta1Coin;
    enabled?: boolean;
}
export interface PylonsDoubleInputParam {
    key?: string;
    /** The minimum legal value of this parameter. */
    minValue?: string;
    /** The maximum legal value of this parameter. */
    maxValue?: string;
}
export interface PylonsDoubleKeyValue {
    Key?: string;
    Value?: string;
}
export interface PylonsDoubleParam {
    key?: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    rate?: string;
    weightRanges?: PylonsDoubleWeightRange[];
    program?: string;
}
export interface PylonsDoubleWeightRange {
    lower?: string;
    upper?: string;
    /** @format uint64 */
    weight?: string;
}
export interface PylonsEntriesList {
    coinOutputs?: PylonsCoinOutput[];
    itemOutputs?: PylonsItemOutput[];
    itemModifyOutputs?: PylonsItemModifyOutput[];
}
export interface PylonsExecution {
    creator?: string;
    ID?: string;
    recipeID?: string;
    cookbookID?: string;
    recipeVersion?: string;
    nodeVersion?: string;
    /** @format int64 */
    blockHeight?: string;
    itemInputs?: PylonsItemRecord[];
    coinInputs?: V1Beta1Coin[];
    coinOutputs?: V1Beta1Coin[];
    itemOutputIDs?: string[];
    itemModifyOutputIDs?: string[];
}
export interface PylonsGoogleInAppPurchaseOrder {
    creator?: string;
    productID?: string;
    purchaseToken?: string;
    receiptDataBase64?: string;
    signature?: string;
}
export interface PylonsIntWeightRange {
    /** @format int64 */
    lower?: string;
    /** @format int64 */
    upper?: string;
    /** @format uint64 */
    weight?: string;
}
export interface PylonsItem {
    owner?: string;
    cookbookID?: string;
    ID?: string;
    nodeVersion?: string;
    doubles?: PylonsDoubleKeyValue[];
    longs?: PylonsLongKeyValue[];
    strings?: PylonsStringKeyValue[];
    mutableStrings?: PylonsStringKeyValue[];
    tradeable?: boolean;
    /** @format int64 */
    lastUpdate?: string;
    transferFee?: V1Beta1Coin[];
    /** The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0). */
    tradePercentage?: string;
}
export interface PylonsItemInput {
    ID?: string;
    doubles?: PylonsDoubleInputParam[];
    longs?: PylonsLongInputParam[];
    strings?: PylonsStringInputParam[];
    conditions?: PylonsConditionList;
}
export interface PylonsItemModifyOutput {
    ID?: string;
    itemInputRef?: string;
    doubles?: PylonsDoubleParam[];
    longs?: PylonsLongParam[];
    strings?: PylonsStringParam[];
    mutableStrings?: PylonsStringKeyValue[];
    transferFee?: V1Beta1Coin[];
    /** The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0). */
    tradePercentage?: string;
    /** @format uint64 */
    quantity?: string;
    /** @format uint64 */
    amountMinted?: string;
    tradeable?: boolean;
}
export interface PylonsItemOutput {
    ID?: string;
    doubles?: PylonsDoubleParam[];
    longs?: PylonsLongParam[];
    strings?: PylonsStringParam[];
    mutableStrings?: PylonsStringKeyValue[];
    transferFee?: V1Beta1Coin[];
    /** The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0). */
    tradePercentage?: string;
    /** @format uint64 */
    quantity?: string;
    /** @format uint64 */
    amountMinted?: string;
    tradeable?: boolean;
}
export interface PylonsItemRecord {
    ID?: string;
    doubles?: PylonsDoubleKeyValue[];
    longs?: PylonsLongKeyValue[];
    strings?: PylonsStringKeyValue[];
}
export interface PylonsItemRef {
    cookbookID?: string;
    itemID?: string;
}
export interface PylonsLongInputParam {
    key?: string;
    /**
     * The minimum legal value of this parameter.
     * @format int64
     */
    minValue?: string;
    /**
     * The maximum legal value of this parameter.
     * @format int64
     */
    maxValue?: string;
}
export interface PylonsLongKeyValue {
    Key?: string;
    /** @format int64 */
    Value?: string;
}
export interface PylonsLongParam {
    key?: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    rate?: string;
    weightRanges?: PylonsIntWeightRange[];
    program?: string;
}
export declare type PylonsMsgCancelTradeResponse = object;
export interface PylonsMsgCompleteExecutionEarlyResponse {
    ID?: string;
}
export declare type PylonsMsgCreateAccountResponse = object;
export declare type PylonsMsgCreateCookbookResponse = object;
export declare type PylonsMsgCreateRecipeResponse = object;
export interface PylonsMsgCreateTradeResponse {
    /** @format uint64 */
    ID?: string;
}
export interface PylonsMsgExecuteRecipeResponse {
    ID?: string;
}
export declare type PylonsMsgFulfillTradeResponse = object;
export declare type PylonsMsgGoogleInAppPurchaseGetCoinsResponse = object;
export declare type PylonsMsgSendItemsResponse = object;
export declare type PylonsMsgSetCookbookDenomMetadataResponse = object;
export declare type PylonsMsgSetItemStringResponse = object;
export declare type PylonsMsgTransferCookbookResponse = object;
export declare type PylonsMsgUpdateAccountResponse = object;
export declare type PylonsMsgUpdateCookbookResponse = object;
export declare type PylonsMsgUpdateRecipeResponse = object;
export interface PylonsQueryGetAddressByUsernameResponse {
    address?: PylonsAccountAddr;
}
export interface PylonsQueryGetCookbookResponse {
    Cookbook?: PylonsCookbook;
}
export interface PylonsQueryGetExecutionResponse {
    Execution?: PylonsExecution;
    Completed?: boolean;
}
export interface PylonsQueryGetGoogleInAppPurchaseOrderResponse {
    Order?: PylonsGoogleInAppPurchaseOrder;
}
export interface PylonsQueryGetItemResponse {
    Item?: PylonsItem;
}
export interface PylonsQueryGetRecipeResponse {
    Recipe?: PylonsRecipe;
}
export interface PylonsQueryGetTradeResponse {
    Trade?: PylonsTrade;
}
export interface PylonsQueryGetUsernameByAddressResponse {
    username?: PylonsUsername;
}
export interface PylonsQueryListCookbooksByCreatorResponse {
    Cookbooks?: PylonsCookbook[];
    /** pagination defines the pagination in the response. */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsQueryListExecutionsByItemResponse {
    CompletedExecutions?: PylonsExecution[];
    PendingExecutions?: PylonsExecution[];
    /** pagination defines the pagination in the response. */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsQueryListExecutionsByRecipeResponse {
    CompletedExecutions?: PylonsExecution[];
    PendingExecutions?: PylonsExecution[];
    /** pagination defines the pagination in the response. */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsQueryListItemByOwnerResponse {
    Items?: PylonsItem[];
    /** pagination defines the pagination in the response. */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsQueryListRecipesByCookbookResponse {
    Recipes?: PylonsRecipe[];
    /** pagination defines the pagination in the response. */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsRecipe {
    cookbookID?: string;
    ID?: string;
    nodeVersion?: string;
    name?: string;
    description?: string;
    version?: string;
    coinInputs?: PylonsCoinInput[];
    itemInputs?: PylonsItemInput[];
    entries?: PylonsEntriesList;
    outputs?: PylonsWeightedOutputs[];
    /** @format int64 */
    blockInterval?: string;
    enabled?: boolean;
    extraInfo?: string;
}
export interface PylonsStringInputParam {
    key?: string;
    value?: string;
}
export interface PylonsStringKeyValue {
    Key?: string;
    Value?: string;
}
export interface PylonsStringParam {
    key?: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    rate?: string;
    value?: string;
    program?: string;
}
export interface PylonsTrade {
    creator?: string;
    /** @format uint64 */
    ID?: string;
    coinInputs?: PylonsCoinInput[];
    itemInputs?: PylonsItemInput[];
    coinOutputs?: V1Beta1Coin[];
    itemOutputs?: PylonsItemRef[];
    extraInfo?: string;
    receiver?: string;
    tradedItemInputs?: PylonsItemRef[];
}
export interface PylonsUsername {
    value?: string;
}
export interface PylonsWeightedOutputs {
    entryIDs?: string[];
    /** @format uint64 */
    weight?: string;
}
export interface RpcStatus {
    /** @format int32 */
    code?: number;
    message?: string;
    details?: ProtobufAny[];
}
/**
* Coin defines a token with a denomination and an amount.

NOTE: The amount field is an Int which implements the custom method
signatures required by gogoproto.
*/
export interface V1Beta1Coin {
    denom?: string;
    amount?: string;
}
/**
* DenomUnit represents a struct that describes a given
denomination unit of the basic token.
*/
export interface V1Beta1DenomUnit {
    /** denom represents the string name of the given denom unit (e.g uatom). */
    denom?: string;
    /**
     * exponent represents power of 10 exponent that one must
     * raise the base_denom to in order to equal the given DenomUnit's denom
     * 1 denom = 1^exponent base_denom
     * (e.g. with a base_denom of uatom, one can create a DenomUnit of 'atom' with
     * exponent = 6, thus: 1 atom = 10^6 uatom).
     * @format int64
     */
    exponent?: number;
    aliases?: string[];
}
/**
* message SomeRequest {
         Foo some_parameter = 1;
         PageRequest pagination = 2;
 }
*/
export interface V1Beta1PageRequest {
    /**
     * key is a value returned in PageResponse.next_key to begin
     * querying the next page most efficiently. Only one of offset or key
     * should be set.
     * @format byte
     */
    key?: string;
    /**
     * offset is a numeric offset that can be used when key is unavailable.
     * It is less efficient than using key. Only one of offset or key should
     * be set.
     * @format uint64
     */
    offset?: string;
    /**
     * limit is the total number of results to be returned in the result page.
     * If left empty it will default to a value to be set by each app.
     * @format uint64
     */
    limit?: string;
    /**
     * count_total is set to true  to indicate that the result set should include
     * a count of the total number of items available for pagination in UIs.
     * count_total is only respected when offset is used. It is ignored when key
     * is set.
     */
    countTotal?: boolean;
    /** reverse is set to true if results are to be returned in the descending order. */
    reverse?: boolean;
}
/**
* PageResponse is to be embedded in gRPC response messages where the
corresponding request message has used PageRequest.

 message SomeResponse {
         repeated Bar results = 1;
         PageResponse page = 2;
 }
*/
export interface V1Beta1PageResponse {
    /** @format byte */
    nextKey?: string;
    /** @format uint64 */
    total?: string;
}
export declare type QueryParamsType = Record<string | number, any>;
export declare type ResponseFormat = keyof Omit<Body, "body" | "bodyUsed">;
export interface FullRequestParams extends Omit<RequestInit, "body"> {
    /** set parameter to `true` for call `securityWorker` for this request */
    secure?: boolean;
    /** request path */
    path: string;
    /** content type of request body */
    type?: ContentType;
    /** query params */
    query?: QueryParamsType;
    /** format of response (i.e. response.json() -> format: "json") */
    format?: keyof Omit<Body, "body" | "bodyUsed">;
    /** request body */
    body?: unknown;
    /** base url */
    baseUrl?: string;
    /** request cancellation token */
    cancelToken?: CancelToken;
}
export declare type RequestParams = Omit<FullRequestParams, "body" | "method" | "query" | "path">;
export interface ApiConfig<SecurityDataType = unknown> {
    baseUrl?: string;
    baseApiParams?: Omit<RequestParams, "baseUrl" | "cancelToken" | "signal">;
    securityWorker?: (securityData: SecurityDataType) => RequestParams | void;
}
export interface HttpResponse<D extends unknown, E extends unknown = unknown> extends Response {
    data: D;
    error: E;
}
declare type CancelToken = Symbol | string | number;
export declare enum ContentType {
    Json = "application/json",
    FormData = "multipart/form-data",
    UrlEncoded = "application/x-www-form-urlencoded"
}
export declare class HttpClient<SecurityDataType = unknown> {
    baseUrl: string;
    private securityData;
    private securityWorker;
    private abortControllers;
    private baseApiParams;
    constructor(apiConfig?: ApiConfig<SecurityDataType>);
    setSecurityData: (data: SecurityDataType) => void;
    private addQueryParam;
    protected toQueryString(rawQuery?: QueryParamsType): string;
    protected addQueryParams(rawQuery?: QueryParamsType): string;
    private contentFormatters;
    private mergeRequestParams;
    private createAbortSignal;
    abortRequest: (cancelToken: CancelToken) => void;
    request: <T = any, E = any>({ body, secure, path, type, query, format, baseUrl, cancelToken, ...params }: FullRequestParams) => Promise<HttpResponse<T, E>>;
}
/**
 * @title pylons/accounts.proto
 * @version version not set
 */
export declare class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
    /**
     * No description
     *
     * @tags Query
     * @name QueryUsernameByAddress
     * @summary Queries a list of getAccountByAddress items.
     * @request GET:/pylons/account/address/{address}
     */
    queryUsernameByAddress: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetUsernameByAddressResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryAddressByUsername
     * @summary Queries a username by account.
     * @request GET:/pylons/account/username/{username}
     */
    queryAddressByUsername: (username: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetAddressByUsernameResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryCookbook
     * @summary Retrieves a cookbook by ID.
     * @request GET:/pylons/cookbook/{ID}
     */
    queryCookbook: (ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListCookbooksByCreator
     * @summary Retrieves the list of cookbooks owned by an address
     * @request GET:/pylons/cookbooks/{creator}
     */
    queryListCookbooksByCreator: (creator: string, query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
        "pagination.reverse"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListCookbooksByCreatorResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryExecution
     * @summary Queries a execution by id.
     * @request GET:/pylons/execution/{ID}
     */
    queryExecution: (ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetExecutionResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListExecutionsByItem
     * @summary Queries a list of listExecutionsByItem items.
     * @request GET:/pylons/executions/item/{CookbookID}/{ItemID}
     */
    queryListExecutionsByItem: (CookbookID: string, ItemID: string, query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
        "pagination.reverse"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListExecutionsByItemResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListExecutionsByRecipe
     * @summary Queries a list of listExecutionsByRecipe items.
     * @request GET:/pylons/executions/recipe/{CookbookID}/{RecipeID}
     */
    queryListExecutionsByRecipe: (CookbookID: string, RecipeID: string, query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
        "pagination.reverse"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListExecutionsByRecipeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGoogleInAppPurchaseOrder
     * @summary Queries a googleIAPOrder by PurchaseToken.
     * @request GET:/pylons/iap/{PurchaseToken}
     */
    queryGoogleInAppPurchaseOrder: (PurchaseToken: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetGoogleInAppPurchaseOrderResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryItem
     * @summary Queries a item by ID.
     * @request GET:/pylons/item/{CookbookID}/{ID}
     */
    queryItem: (CookbookID: string, ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetItemResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListItemByOwner
     * @summary Queries a list of listItemByOwner items.
     * @request GET:/pylons/items/{owner}
     */
    queryListItemByOwner: (owner: string, query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
        "pagination.reverse"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListItemByOwnerResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryRecipe
     * @summary Retrieves a recipe by ID.
     * @request GET:/pylons/recipe/{CookbookID}/{ID}
     */
    queryRecipe: (CookbookID: string, ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetRecipeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListRecipesByCookbook
     * @summary Queries a list of listRecipesByCookbook items.
     * @request GET:/pylons/recipes/{CookbookID}
     */
    queryListRecipesByCookbook: (CookbookID: string, query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
        "pagination.reverse"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListRecipesByCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryTrade
     * @summary Queries a trade by id.
     * @request GET:/pylons/trade/{ID}
     */
    queryTrade: (ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetTradeResponse, RpcStatus>>;
}
export {};
