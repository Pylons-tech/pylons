export interface ProtobufAny {
    typeUrl?: string;
    /** @format byte */
    value?: string;
}
export interface PylonsCoinOutput {
    ID?: string;
    coins?: V1Beta1Coin[];
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
    /** @format uint64 */
    costPerBlock?: string;
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
export interface PylonsIntWeightRange {
    /** @format int64 */
    lower?: string;
    /** @format int64 */
    upper?: string;
    /** @format uint64 */
    weight?: string;
}
export interface PylonsItem {
    creator?: string;
    ID?: string;
    cookbookID?: string;
    nodeVersion?: string;
    Doubles?: PylonsDoubleKeyValue[];
    Longs?: PylonsLongKeyValue[];
    Strings?: PylonsStringKeyValue[];
    ownerRecipeID?: string;
    ownerTradeID?: string;
    tradeable?: boolean;
    /** @format uint64 */
    lastUpdate?: string;
    /** @format uint64 */
    transferFee?: string;
}
export interface PylonsItemInput {
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
    transferFee?: string;
}
export interface PylonsItemOutput {
    ID?: string;
    doubles?: PylonsDoubleParam[];
    longs?: PylonsLongParam[];
    strings?: PylonsStringParam[];
    mutableStrings?: PylonsStringParam[];
    transferFee?: string;
    /** @format uint64 */
    quantity?: string;
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
export declare type PylonsMsgCreateCookbookResponse = object;
export declare type PylonsMsgCreateItemResponse = object;
export declare type PylonsMsgCreateRecipeResponse = object;
export declare type PylonsMsgDeleteItemResponse = object;
export declare type PylonsMsgUpdateCookbookResponse = object;
export declare type PylonsMsgUpdateItemResponse = object;
export declare type PylonsMsgUpdateRecipeResponse = object;
export interface PylonsQueryAllItemResponse {
    Item?: PylonsItem[];
    /**
     * PageResponse is to be embedded in gRPC response messages where the
     * corresponding request message has used PageRequest.
     *
     *  message SomeResponse {
     *          repeated Bar results = 1;
     *          PageResponse page = 2;
     *  }
     */
    pagination?: V1Beta1PageResponse;
}
export interface PylonsQueryGetCookbookResponse {
    Cookbook?: PylonsCookbook;
}
export interface PylonsQueryGetItemResponse {
    Item?: PylonsItem;
}
export interface PylonsQueryGetRecipeResponse {
    Recipe?: PylonsRecipe;
}
export interface PylonsQueryListCookbooksByCreatorResponse {
    Cookbooks?: PylonsCookbook[];
}
export interface PylonsRecipe {
    cookbookID?: string;
    ID?: string;
    nodeVersion?: string;
    name?: string;
    description?: string;
    version?: string;
    coinInputs?: V1Beta1Coin[];
    itemInputs?: PylonsItemInput[];
    entries?: PylonsEntriesList;
    outputs?: PylonsWeightedOutputs[];
    /** @format uint64 */
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
 * @title pylons/cookbook.proto
 * @version version not set
 */
export declare class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
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
     * @name QueryItemAll
     * @summary Queries a list of item items.
     * @request GET:/pylons/item
     */
    queryItemAll: (query?: {
        "pagination.key"?: string;
        "pagination.offset"?: string;
        "pagination.limit"?: string;
        "pagination.countTotal"?: boolean;
    }, params?: RequestParams) => Promise<HttpResponse<PylonsQueryAllItemResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryItem
     * @summary Queries a item by index.
     * @request GET:/pylons/item/{index}
     */
    queryItem: (index: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetItemResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListCookbooksByCreator
     * @summary Retrieves the list of cookbooks owned by an address
     * @request GET:/pylons/listCookbooks/{creator}
     */
    queryListCookbooksByCreator: (creator: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListCookbooksByCreatorResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryRecipe
     * @summary Retrieves a recipe by ID.
     * @request GET:/pylons/recipe/{CookbookID}/{ID}
     */
    queryRecipe: (CookbookID: string, ID: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetRecipeResponse, RpcStatus>>;
}
export {};
