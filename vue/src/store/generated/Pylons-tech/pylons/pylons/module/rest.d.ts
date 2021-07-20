export interface ProtobufAny {
    typeUrl?: string;
    /** @format byte */
    value?: string;
}
export interface PylonsAddrFromPubKeyResponse {
    Bech32Addr?: string;
}
export interface PylonsCheckGoogleIapOrderResponse {
    purchaseToken?: string;
    exist?: boolean;
}
export interface PylonsCoinInput {
    Coin?: string;
    /** @format int64 */
    Count?: string;
}
export interface PylonsCoinOutput {
    ID?: string;
    Coin?: string;
    Count?: string;
}
export interface PylonsConditionList {
    Doubles?: PylonsDoubleInputParam[];
    Longs?: PylonsLongInputParam[];
    Strings?: PylonsStringInputParam[];
}
export interface PylonsCookbook {
    NodeVersion?: string;
    ID?: string;
    Name?: string;
    Description?: string;
    Version?: string;
    Developer?: string;
    /** @format int64 */
    Level?: string;
    SupportEmail?: string;
    /** @format int64 */
    CostPerBlock?: string;
    Sender?: string;
}
export interface PylonsDoubleInputParam {
    Key?: string;
    /** The minimum legal value of this parameter. */
    MinValue?: string;
    /** The maximum legal value of this parameter. */
    MaxValue?: string;
}
export interface PylonsDoubleKeyValue {
    Key?: string;
    Value?: string;
}
export interface PylonsDoubleParam {
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate?: string;
    Key?: string;
    WeightRanges?: PylonsDoubleWeightRange[];
    Program?: string;
}
export interface PylonsDoubleWeightRange {
    Lower?: string;
    Upper?: string;
    /** @format int64 */
    Weight?: string;
}
export interface PylonsEntriesList {
    CoinOutputs?: PylonsCoinOutput[];
    ItemOutputs?: PylonsItemOutput[];
    ItemModifyOutputs?: PylonsItemModifyOutput[];
}
export interface PylonsExecution {
    NodeVersion?: string;
    ID?: string;
    RecipeID?: string;
    CookbookID?: string;
    CoinInputs?: V1Beta1Coin[];
    ItemInputs?: PylonsItem[];
    /** @format int64 */
    BlockHeight?: string;
    Sender?: string;
    Completed?: boolean;
}
export interface PylonsFeeInputParam {
    /** @format int64 */
    MinValue?: string;
    /** @format int64 */
    MaxValue?: string;
}
export interface PylonsGetCookbookResponse {
    NodeVersion?: string;
    ID?: string;
    Name?: string;
    Description?: string;
    Version?: string;
    Developer?: string;
    /** @format int64 */
    Level?: string;
    SupportEmail?: string;
    /** @format int64 */
    CostPerBlock?: string;
    Sender?: string;
}
export interface PylonsGetExecutionResponse {
    NodeVersion?: string;
    ID?: string;
    RecipeID?: string;
    CookbookID?: string;
    CoinsInput?: V1Beta1Coin[];
    ItemInputs?: PylonsItem[];
    /** @format int64 */
    BlockHeight?: string;
    Sender?: string;
    Completed?: boolean;
}
export interface PylonsGetItemResponse {
    item?: PylonsItem;
}
export interface PylonsGetLockedCoinDetailsResponse {
    sender?: string;
    Amount?: V1Beta1Coin[];
    LockCoinTrades?: PylonsLockedCoinDescribe[];
    LockCoinExecs?: PylonsLockedCoinDescribe[];
}
export interface PylonsGetLockedCoinsResponse {
    NodeVersion?: string;
    Sender?: string;
    Amount?: V1Beta1Coin[];
}
export interface PylonsGetRecipeResponse {
    NodeVersion?: string;
    ID?: string;
    CookbookID?: string;
    Name?: string;
    CoinInputs?: PylonsCoinInput[];
    ItemInputs?: PylonsItemInput[];
    Entries?: PylonsEntriesList;
    Outputs?: PylonsWeightedOutputs[];
    Description?: string;
    /** @format int64 */
    BlockInterval?: string;
    Sender?: string;
    Disabled?: boolean;
    ExtraInfo?: string;
}
export interface PylonsGetTradeResponse {
    NodeVersion?: string;
    ID?: string;
    CoinInputs?: PylonsCoinInput[];
    ItemInputs?: PylonsTradeItemInput[];
    CoinOutputs?: V1Beta1Coin[];
    ItemOutputs?: PylonsItem[];
    ExtraInfo?: string;
    Sender?: string;
    FulFiller?: string;
    Disabled?: boolean;
    Completed?: boolean;
}
export interface PylonsIntWeightRange {
    /** @format int64 */
    Lower?: string;
    /** @format int64 */
    Upper?: string;
    /** @format int64 */
    Weight?: string;
}
export interface PylonsItem {
    NodeVersion?: string;
    ID?: string;
    Doubles?: PylonsDoubleKeyValue[];
    Longs?: PylonsLongKeyValue[];
    Strings?: PylonsStringKeyValue[];
    CookbookID?: string;
    Sender?: string;
    OwnerRecipeID?: string;
    OwnerTradeID?: string;
    Tradable?: boolean;
    /** @format int64 */
    LastUpdate?: string;
    /** @format int64 */
    TransferFee?: string;
}
export interface PylonsItemInput {
    ID?: string;
    Doubles?: PylonsDoubleInputParam[];
    Longs?: PylonsLongInputParam[];
    Strings?: PylonsStringInputParam[];
    TransferFee?: PylonsFeeInputParam;
    Conditions?: PylonsConditionList;
}
export interface PylonsItemModifyOutput {
    ID?: string;
    ItemInputRef?: string;
    Doubles?: PylonsDoubleParam[];
    Longs?: PylonsLongParam[];
    Strings?: PylonsStringParam[];
    /** @format int64 */
    TransferFee?: string;
}
export interface PylonsItemOutput {
    ID?: string;
    Doubles?: PylonsDoubleParam[];
    Longs?: PylonsLongParam[];
    Strings?: PylonsStringParam[];
    /** @format int64 */
    TransferFee?: string;
}
export interface PylonsItemsByCookbookResponse {
    Items?: PylonsItem[];
}
export interface PylonsItemsBySenderResponse {
    Items?: PylonsItem[];
}
export interface PylonsListCookbookResponse {
    Cookbooks?: PylonsCookbook[];
}
export interface PylonsListExecutionsResponse {
    Executions?: PylonsExecution[];
}
export interface PylonsListRecipeByCookbookResponse {
    recipes?: PylonsRecipe[];
}
export interface PylonsListRecipeResponse {
    recipes?: PylonsRecipe[];
}
export interface PylonsListShortenRecipeByCookbookResponse {
    recipes?: PylonsShortenRecipe[];
}
export interface PylonsListShortenRecipeResponse {
    recipes?: PylonsShortenRecipe[];
}
export interface PylonsListTradeResponse {
    trades?: PylonsTrade[];
}
export interface PylonsLockedCoinDescribe {
    ID?: string;
    Amount?: V1Beta1Coin[];
}
export interface PylonsLongInputParam {
    Key?: string;
    /** @format int64 */
    MinValue?: string;
    /** @format int64 */
    MaxValue?: string;
}
export interface PylonsLongKeyValue {
    Key?: string;
    /** @format int64 */
    Value?: string;
}
export interface PylonsLongParam {
    Key?: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate?: string;
    WeightRanges?: PylonsIntWeightRange[];
    Program?: string;
}
export interface PylonsMsgCheckExecutionResponse {
    Message?: string;
    Status?: string;
    /** @format byte */
    Output?: string;
}
export interface PylonsMsgCreateCookbookResponse {
    CookbookID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgCreateExecutionResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgCreateRecipeResponse {
    RecipeID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgCreateTradeResponse {
    TradeID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgDisableRecipeResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgDisableTradeResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgEnableRecipeResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgEnableTradeResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgExecuteRecipeResponse {
    Message?: string;
    Status?: string;
    /** @format byte */
    Output?: string;
}
export interface PylonsMsgFiatItemResponse {
    ItemID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgFulfillTradeResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgGetPylonsResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgGoogleIAPGetPylonsResponse {
    Message?: string;
    Status?: string;
}
export declare type PylonsMsgSendCoinsResponse = object;
export interface PylonsMsgSendItemsResponse {
    Message?: string;
    Status?: string;
}
export interface PylonsMsgStripeCheckoutResponse {
    SessionID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgStripeCreatePriceResponse {
    PriceID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgStripeCreateProductResponse {
    ProductID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgStripeCreateSkuResponse {
    SKUID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgUpdateCookbookResponse {
    CookbookID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsMsgUpdateItemStringResponse {
    Status?: string;
    Message?: string;
}
export interface PylonsMsgUpdateRecipeResponse {
    RecipeID?: string;
    Message?: string;
    Status?: string;
}
export interface PylonsPylonsBalanceResponse {
    /** @format int64 */
    balance?: string;
}
export interface PylonsRecipe {
    NodeVersion?: string;
    ID?: string;
    CookbookID?: string;
    Name?: string;
    CoinInputs?: PylonsCoinInput[];
    ItemInputs?: PylonsItemInput[];
    Entries?: PylonsEntriesList;
    Outputs?: PylonsWeightedOutputs[];
    Description?: string;
    /** @format int64 */
    BlockInterval?: string;
    Sender?: string;
    Disabled?: boolean;
    ExtraInfo?: string;
}
export interface PylonsShortenRecipe {
    ID?: string;
    CookbookID?: string;
    Name?: string;
    Description?: string;
    Sender?: string;
}
export interface PylonsStringInputParam {
    Key?: string;
    Value?: string;
}
export interface PylonsStringKeyValue {
    Key?: string;
    Value?: string;
}
export interface PylonsStringParam {
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate?: string;
    Key?: string;
    Value?: string;
    Program?: string;
}
export interface PylonsStripeInventory {
    /** @format int64 */
    Quantity?: string;
    Type?: string;
    Value?: string;
}
export interface PylonsStripePrice {
    /** @format int64 */
    Amount?: string;
    Currency?: string;
    Description?: string;
    Images?: string[];
    Name?: string;
    /** @format int64 */
    Quantity?: string;
}
export interface PylonsTrade {
    NodeVersion?: string;
    ID?: string;
    CoinInputs?: PylonsCoinInput[];
    ItemInputs?: PylonsTradeItemInput[];
    CoinOutputs?: V1Beta1Coin[];
    ItemOutputs?: PylonsItem[];
    ExtraInfo?: string;
    Sender?: string;
    FulFiller?: string;
    Disabled?: boolean;
    Completed?: boolean;
}
export interface PylonsTradeItemInput {
    ItemInput?: PylonsItemInput;
    CookbookID?: string;
}
export interface PylonsWeightedOutputs {
    EntryIDs?: string[];
    Weight?: string;
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
 * @title pylons/genesis.proto
 * @version version not set
 */
export declare class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
    /**
     * No description
     *
     * @tags Query
     * @name QueryAddrFromPubKey
     * @summary AddrFromPubKey returns a bech32 public address from the public key
     * @request GET:/custom/pylons/addr_from_pub_key/{hexPubKey}
     */
    queryAddrFromPubKey: (hexPubKey: string, params?: RequestParams) => Promise<HttpResponse<PylonsAddrFromPubKeyResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryPylonsBalance
     * @summary PylonsBalance provides balances in pylons
     * @request GET:/custom/pylons/balance/{address}
     */
    queryPylonsBalance: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsPylonsBalanceResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryCheckGoogleIapOrder
     * @summary CheckGoogleIapOrder check if google iap order is given to user with purchase token
     * @request GET:/custom/pylons/check_google_iap_order/{purchaseToken}
     */
    queryCheckGoogleIapOrder: (purchaseToken: string, params?: RequestParams) => Promise<HttpResponse<PylonsCheckGoogleIapOrderResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetCookbook
     * @summary GetCookbook returns a cookbook based on the cookbook id
     * @request GET:/custom/pylons/get_cookbook/{cookbookID}
     */
    queryGetCookbook: (cookbookID: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetExecution
     * @summary GetExecution returns an execution based on the execution id
     * @request GET:/custom/pylons/get_execution/{executionID}
     */
    queryGetExecution: (executionID: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetExecutionResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetItem
     * @summary GetItem returns a item based on the item id
     * @request GET:/custom/pylons/get_item/{itemID}
     */
    queryGetItem: (itemID: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetItemResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetLockedCoinDetails
     * @summary GetLockedCoinDetails returns locked coins with details based on user
     * @request GET:/custom/pylons/get_locked_coin_details/{address}
     */
    queryGetLockedCoinDetails: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetLockedCoinDetailsResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetLockedCoins
     * @summary GetLockedCoins returns locked coins based on user
     * @request GET:/custom/pylons/get_locked_coins/{address}
     */
    queryGetLockedCoins: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetLockedCoinsResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetRecipe
     * @summary GetRecipe returns a recipe based on the recipe id
     * @request GET:/custom/pylons/get_recipe/{recipeID}
     */
    queryGetRecipe: (recipeID: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetRecipeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryGetTrade
     * @summary GetTrade returns a trade based on the trade id
     * @request GET:/custom/pylons/get_trade/{tradeID}
     */
    queryGetTrade: (tradeID: string, params?: RequestParams) => Promise<HttpResponse<PylonsGetTradeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryItemsByCookbook
     * @summary ItemsByCookbook returns a cookbook based on the cookbook id
     * @request GET:/custom/pylons/items_by_cookbook/{cookbookID}
     */
    queryItemsByCookbook: (cookbookID: string, params?: RequestParams) => Promise<HttpResponse<PylonsItemsByCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryItemsBySender
     * @summary ItemsBySender returns all items based on the sender address
     * @request GET:/custom/pylons/items_by_sender/{sender}
     */
    queryItemsBySender: (sender: string, params?: RequestParams) => Promise<HttpResponse<PylonsItemsBySenderResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListCookbook
     * @summary ListCookbook returns a cookbook based on the cookbook id
     * @request GET:/custom/pylons/list_cookbook/{address}
     */
    queryListCookbook: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsListCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListExecutions
     * @summary ListExecutions lists all the executions based on the sender address
     * @request GET:/custom/pylons/list_executions/{sender}
     */
    queryListExecutions: (sender: string, params?: RequestParams) => Promise<HttpResponse<PylonsListExecutionsResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListRecipe
     * @summary ListRecipe returns a recipe based on the recipe id
     * @request GET:/custom/pylons/list_recipe/{address}
     */
    queryListRecipe: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsListRecipeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListRecipeByCookbook
     * @summary ListRecipeByCookbook returns a recipe based on the recipe id
     * @request GET:/custom/pylons/list_recipe_by_cookbook/{cookbookID}
     */
    queryListRecipeByCookbook: (cookbookID: string, params?: RequestParams) => Promise<HttpResponse<PylonsListRecipeByCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListShortenRecipe
     * @summary ListShortenRecipe returns a recipe based on the recipe id
     * @request GET:/custom/pylons/list_shorten_recipe/{address}
     */
    queryListShortenRecipe: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsListShortenRecipeResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListShortenRecipeByCookbook
     * @summary ListShortenRecipeByCookbook returns a recipe based on the recipe id
     * @request GET:/custom/pylons/list_shorten_recipe_by_cookbook/{cookbookID}
     */
    queryListShortenRecipeByCookbook: (cookbookID: string, params?: RequestParams) => Promise<HttpResponse<PylonsListShortenRecipeByCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListTrade
     * @summary ListTrade returns a trade based on the trade id
     * @request GET:/custom/pylons/list_trade/{address}
     */
    queryListTrade: (address: string, params?: RequestParams) => Promise<HttpResponse<PylonsListTradeResponse, RpcStatus>>;
}
export {};
