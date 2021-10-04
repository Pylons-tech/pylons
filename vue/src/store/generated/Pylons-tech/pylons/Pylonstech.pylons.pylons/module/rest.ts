/* eslint-disable */
/* tslint:disable */
/*
 * ---------------------------------------------------------------
 * ## THIS FILE WAS GENERATED VIA SWAGGER-TYPESCRIPT-API        ##
 * ##                                                           ##
 * ## AUTHOR: acacode                                           ##
 * ## SOURCE: https://github.com/acacode/swagger-typescript-api ##
 * ---------------------------------------------------------------
 */

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

export type PylonsMsgCancelTradeResponse = object;

export interface PylonsMsgCompleteExecutionEarlyResponse {
  ID?: string;
}

export type PylonsMsgCreateAccountResponse = object;

export type PylonsMsgCreateCookbookResponse = object;

export type PylonsMsgCreateRecipeResponse = object;

export interface PylonsMsgCreateTradeResponse {
  /** @format uint64 */
  ID?: string;
}

export interface PylonsMsgExecuteRecipeResponse {
  ID?: string;
}

export type PylonsMsgFulfillTradeResponse = object;

export type PylonsMsgGoogleInAppPurchaseGetCoinsResponse = object;

export type PylonsMsgSendItemsResponse = object;

export type PylonsMsgSetItemStringResponse = object;

export type PylonsMsgTransferCookbookResponse = object;

export type PylonsMsgUpdateAccountResponse = object;

export type PylonsMsgUpdateCookbookResponse = object;

export type PylonsMsgUpdateRecipeResponse = object;

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

  /**
   * Coin defines a token with a denomination and an amount.
   *
   * NOTE: The amount field is an Int which implements the custom method
   * signatures required by gogoproto.
   */
  coinInput?: V1Beta1Coin;
  itemInputs?: PylonsItemInput[];

  /**
   * Coin defines a token with a denomination and an amount.
   *
   * NOTE: The amount field is an Int which implements the custom method
   * signatures required by gogoproto.
   */
  coinOutput?: V1Beta1Coin;
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

export type QueryParamsType = Record<string | number, any>;
export type ResponseFormat = keyof Omit<Body, "body" | "bodyUsed">;

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

export type RequestParams = Omit<FullRequestParams, "body" | "method" | "query" | "path">;

export interface ApiConfig<SecurityDataType = unknown> {
  baseUrl?: string;
  baseApiParams?: Omit<RequestParams, "baseUrl" | "cancelToken" | "signal">;
  securityWorker?: (securityData: SecurityDataType) => RequestParams | void;
}

export interface HttpResponse<D extends unknown, E extends unknown = unknown> extends Response {
  data: D;
  error: E;
}

type CancelToken = Symbol | string | number;

export enum ContentType {
  Json = "application/json",
  FormData = "multipart/form-data",
  UrlEncoded = "application/x-www-form-urlencoded",
}

export class HttpClient<SecurityDataType = unknown> {
  public baseUrl: string = "";
  private securityData: SecurityDataType = null as any;
  private securityWorker: null | ApiConfig<SecurityDataType>["securityWorker"] = null;
  private abortControllers = new Map<CancelToken, AbortController>();

  private baseApiParams: RequestParams = {
    credentials: "same-origin",
    headers: {},
    redirect: "follow",
    referrerPolicy: "no-referrer",
  };

  constructor(apiConfig: ApiConfig<SecurityDataType> = {}) {
    Object.assign(this, apiConfig);
  }

  public setSecurityData = (data: SecurityDataType) => {
    this.securityData = data;
  };

  private addQueryParam(query: QueryParamsType, key: string) {
    const value = query[key];

    return (
      encodeURIComponent(key) +
      "=" +
      encodeURIComponent(Array.isArray(value) ? value.join(",") : typeof value === "number" ? value : `${value}`)
    );
  }

  protected toQueryString(rawQuery?: QueryParamsType): string {
    const query = rawQuery || {};
    const keys = Object.keys(query).filter((key) => "undefined" !== typeof query[key]);
    return keys
      .map((key) =>
        typeof query[key] === "object" && !Array.isArray(query[key])
          ? this.toQueryString(query[key] as QueryParamsType)
          : this.addQueryParam(query, key),
      )
      .join("&");
  }

  protected addQueryParams(rawQuery?: QueryParamsType): string {
    const queryString = this.toQueryString(rawQuery);
    return queryString ? `?${queryString}` : "";
  }

  private contentFormatters: Record<ContentType, (input: any) => any> = {
    [ContentType.Json]: (input: any) =>
      input !== null && (typeof input === "object" || typeof input === "string") ? JSON.stringify(input) : input,
    [ContentType.FormData]: (input: any) =>
      Object.keys(input || {}).reduce((data, key) => {
        data.append(key, input[key]);
        return data;
      }, new FormData()),
    [ContentType.UrlEncoded]: (input: any) => this.toQueryString(input),
  };

  private mergeRequestParams(params1: RequestParams, params2?: RequestParams): RequestParams {
    return {
      ...this.baseApiParams,
      ...params1,
      ...(params2 || {}),
      headers: {
        ...(this.baseApiParams.headers || {}),
        ...(params1.headers || {}),
        ...((params2 && params2.headers) || {}),
      },
    };
  }

  private createAbortSignal = (cancelToken: CancelToken): AbortSignal | undefined => {
    if (this.abortControllers.has(cancelToken)) {
      const abortController = this.abortControllers.get(cancelToken);
      if (abortController) {
        return abortController.signal;
      }
      return void 0;
    }

    const abortController = new AbortController();
    this.abortControllers.set(cancelToken, abortController);
    return abortController.signal;
  };

  public abortRequest = (cancelToken: CancelToken) => {
    const abortController = this.abortControllers.get(cancelToken);

    if (abortController) {
      abortController.abort();
      this.abortControllers.delete(cancelToken);
    }
  };

  public request = <T = any, E = any>({
    body,
    secure,
    path,
    type,
    query,
    format = "json",
    baseUrl,
    cancelToken,
    ...params
  }: FullRequestParams): Promise<HttpResponse<T, E>> => {
    const secureParams = (secure && this.securityWorker && this.securityWorker(this.securityData)) || {};
    const requestParams = this.mergeRequestParams(params, secureParams);
    const queryString = query && this.toQueryString(query);
    const payloadFormatter = this.contentFormatters[type || ContentType.Json];

    return fetch(`${baseUrl || this.baseUrl || ""}${path}${queryString ? `?${queryString}` : ""}`, {
      ...requestParams,
      headers: {
        ...(type && type !== ContentType.FormData ? { "Content-Type": type } : {}),
        ...(requestParams.headers || {}),
      },
      signal: cancelToken ? this.createAbortSignal(cancelToken) : void 0,
      body: typeof body === "undefined" || body === null ? null : payloadFormatter(body),
    }).then(async (response) => {
      const r = response as HttpResponse<T, E>;
      r.data = (null as unknown) as T;
      r.error = (null as unknown) as E;

      const data = await response[format]()
        .then((data) => {
          if (r.ok) {
            r.data = data;
          } else {
            r.error = data;
          }
          return r;
        })
        .catch((e) => {
          r.error = e;
          return r;
        });

      if (cancelToken) {
        this.abortControllers.delete(cancelToken);
      }

      if (!response.ok) throw data;
      return data;
    });
  };
}

/**
 * @title pylons/accounts.proto
 * @version version not set
 */
export class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
  /**
   * No description
   *
   * @tags Query
   * @name QueryUsernameByAddress
   * @summary Queries a list of getAccountByAddress items.
   * @request GET:/pylons/account/address/{address}
   */
  queryUsernameByAddress = (address: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetUsernameByAddressResponse, RpcStatus>({
      path: `/pylons/account/address/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryAddressByUsername
   * @summary Queries a username by account.
   * @request GET:/pylons/account/username/{username}
   */
  queryAddressByUsername = (username: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetAddressByUsernameResponse, RpcStatus>({
      path: `/pylons/account/username/${username}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryCookbook
   * @summary Retrieves a cookbook by ID.
   * @request GET:/pylons/cookbook/{ID}
   */
  queryCookbook = (ID: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetCookbookResponse, RpcStatus>({
      path: `/pylons/cookbook/${ID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListCookbooksByCreator
   * @summary Retrieves the list of cookbooks owned by an address
   * @request GET:/pylons/cookbooks/{creator}
   */
  queryListCookbooksByCreator = (
    creator: string,
    query?: {
      "pagination.key"?: string;
      "pagination.offset"?: string;
      "pagination.limit"?: string;
      "pagination.countTotal"?: boolean;
      "pagination.reverse"?: boolean;
    },
    params: RequestParams = {},
  ) =>
    this.request<PylonsQueryListCookbooksByCreatorResponse, RpcStatus>({
      path: `/pylons/cookbooks/${creator}`,
      method: "GET",
      query: query,
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryExecution
   * @summary Queries a execution by id.
   * @request GET:/pylons/execution/{ID}
   */
  queryExecution = (ID: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetExecutionResponse, RpcStatus>({
      path: `/pylons/execution/${ID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListExecutionsByItem
   * @summary Queries a list of listExecutionsByItem items.
   * @request GET:/pylons/executions/item/{CookbookID}/{ItemID}
   */
  queryListExecutionsByItem = (
    CookbookID: string,
    ItemID: string,
    query?: {
      "pagination.key"?: string;
      "pagination.offset"?: string;
      "pagination.limit"?: string;
      "pagination.countTotal"?: boolean;
      "pagination.reverse"?: boolean;
    },
    params: RequestParams = {},
  ) =>
    this.request<PylonsQueryListExecutionsByItemResponse, RpcStatus>({
      path: `/pylons/executions/item/${CookbookID}/${ItemID}`,
      method: "GET",
      query: query,
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListExecutionsByRecipe
   * @summary Queries a list of listExecutionsByRecipe items.
   * @request GET:/pylons/executions/recipe/{CookbookID}/{RecipeID}
   */
  queryListExecutionsByRecipe = (
    CookbookID: string,
    RecipeID: string,
    query?: {
      "pagination.key"?: string;
      "pagination.offset"?: string;
      "pagination.limit"?: string;
      "pagination.countTotal"?: boolean;
      "pagination.reverse"?: boolean;
    },
    params: RequestParams = {},
  ) =>
    this.request<PylonsQueryListExecutionsByRecipeResponse, RpcStatus>({
      path: `/pylons/executions/recipe/${CookbookID}/${RecipeID}`,
      method: "GET",
      query: query,
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGoogleInAppPurchaseOrder
   * @summary Queries a googleIAPOrder by PurchaseToken.
   * @request GET:/pylons/iap/{PurchaseToken}
   */
  queryGoogleInAppPurchaseOrder = (PurchaseToken: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetGoogleInAppPurchaseOrderResponse, RpcStatus>({
      path: `/pylons/iap/${PurchaseToken}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryItem
   * @summary Queries a item by ID.
   * @request GET:/pylons/item/{CookbookID}/{ID}
   */
  queryItem = (CookbookID: string, ID: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetItemResponse, RpcStatus>({
      path: `/pylons/item/${CookbookID}/${ID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListItemByOwner
   * @summary Queries a list of listItemByOwner items.
   * @request GET:/pylons/items/{owner}
   */
  queryListItemByOwner = (
    owner: string,
    query?: {
      "pagination.key"?: string;
      "pagination.offset"?: string;
      "pagination.limit"?: string;
      "pagination.countTotal"?: boolean;
      "pagination.reverse"?: boolean;
    },
    params: RequestParams = {},
  ) =>
    this.request<PylonsQueryListItemByOwnerResponse, RpcStatus>({
      path: `/pylons/items/${owner}`,
      method: "GET",
      query: query,
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryRecipe
   * @summary Retrieves a recipe by ID.
   * @request GET:/pylons/recipe/{CookbookID}/{ID}
   */
  queryRecipe = (CookbookID: string, ID: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetRecipeResponse, RpcStatus>({
      path: `/pylons/recipe/${CookbookID}/${ID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListRecipesByCookbook
   * @summary Queries a list of listRecipesByCookbook items.
   * @request GET:/pylons/recipes/{CookbookID}
   */
  queryListRecipesByCookbook = (
    CookbookID: string,
    query?: {
      "pagination.key"?: string;
      "pagination.offset"?: string;
      "pagination.limit"?: string;
      "pagination.countTotal"?: boolean;
      "pagination.reverse"?: boolean;
    },
    params: RequestParams = {},
  ) =>
    this.request<PylonsQueryListRecipesByCookbookResponse, RpcStatus>({
      path: `/pylons/recipes/${CookbookID}`,
      method: "GET",
      query: query,
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryTrade
   * @summary Queries a trade by id.
   * @request GET:/pylons/trade/{ID}
   */
  queryTrade = (ID: string, params: RequestParams = {}) =>
    this.request<PylonsQueryGetTradeResponse, RpcStatus>({
      path: `/pylons/trade/${ID}`,
      method: "GET",
      format: "json",
      ...params,
    });
}
