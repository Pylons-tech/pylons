export interface ProtobufAny {
    typeUrl?: string;
    /** @format byte */
    value?: string;
}
export interface PylonsConditionList {
    doubles?: PylonsDoubleInputParam[];
    longs?: PylonsLongInputParam[];
    strings?: PylonsStringInputParam[];
}
export interface PylonsCookbook {
    creator?: string;
    index?: string;
    nodeVersion?: string;
    name?: string;
    description?: string;
    developer?: string;
    version?: string;
    supportEmail?: string;
    /** @format int64 */
    level?: string;
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
    /** @format int64 */
    weight?: string;
}
export interface PylonsEntriesList {
    coinOutputs?: V1Beta1Coin[];
    itemOutputs?: PylonsItemOutput[];
    itemModifyOutputs?: PylonsItemModifyOutput[];
}
export interface PylonsIntWeightRange {
    /** @format int64 */
    lower?: string;
    /** @format int64 */
    upper?: string;
    /** @format int64 */
    weight?: string;
}
export interface PylonsItemInput {
    doubles?: PylonsDoubleInputParam[];
    longs?: PylonsLongInputParam[];
    strings?: PylonsStringInputParam[];
    conditions?: PylonsConditionList;
}
export interface PylonsItemModifyOutput {
    itemInputRef?: string;
    doubles?: PylonsDoubleParam[];
    longs?: PylonsLongParam[];
    strings?: PylonsStringParam[];
    transferFee?: string;
}
export interface PylonsItemOutput {
    doubles?: PylonsDoubleParam[];
    longs?: PylonsLongParam[];
    strings?: PylonsStringParam[];
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
export interface PylonsLongParam {
    key?: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    rate?: string;
    weightRanges?: PylonsIntWeightRange[];
    program?: string;
}
export declare type PylonsMsgCreateCookbookResponse = object;
export declare type PylonsMsgCreateRecipeResponse = object;
export declare type PylonsMsgUpdateCookbookResponse = object;
export declare type PylonsMsgUpdateRecipeResponse = object;
export interface PylonsQueryGetCookbookResponse {
    Cookbook?: PylonsCookbook;
}
export interface PylonsQueryGetRecipeResponse {
    Recipe?: PylonsRecipe;
}
export interface PylonsQueryListCookbookByCreatorResponse {
    Cookbooks?: PylonsCookbook[];
}
export interface PylonsRecipe {
    creator?: string;
    index?: string;
    nodeVersion?: string;
    cookbookID?: string;
    name?: string;
    coinInputs?: V1Beta1Coin[];
    itemInputs?: PylonsItemInput[];
    entries?: PylonsEntriesList;
    outputs?: PylonsWeightedOutputs[];
    description?: string;
    /** @format uint64 */
    blockInterval?: string;
    enabled?: boolean;
    extraInfo?: string;
}
export interface PylonsStringInputParam {
    key?: string;
    value?: string;
}
export interface PylonsStringParam {
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    rate?: string;
    key?: string;
    value?: string;
    program?: string;
}
export interface PylonsWeightedOutputs {
    entryIDs?: string[];
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
 * @title pylons/cookbook.proto
 * @version version not set
 */
export declare class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
    /**
     * No description
     *
     * @tags Query
     * @name QueryCookbook
     * @summary Queries a cookbook by index.
     * @request GET:/pylons/cookbook/{index}
     */
    queryCookbook: (index: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetCookbookResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryListCookbookByCreator
     * @summary Queries a list of listCookbookByCreator items.
     * @request GET:/pylons/listCookbooks/{creator}
     */
    queryListCookbookByCreator: (creator: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryListCookbookByCreatorResponse, RpcStatus>>;
    /**
     * No description
     *
     * @tags Query
     * @name QueryRecipe
     * @summary Queries a recipe by index.
     * @request GET:/pylons/recipe/{index}
     */
    queryRecipe: (index: string, params?: RequestParams) => Promise<HttpResponse<PylonsQueryGetRecipeResponse, RpcStatus>>;
}
export {};
