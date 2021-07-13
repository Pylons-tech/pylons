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

export type PylonsMsgSendCoinsResponse = object;

export interface PylonsMsgSendItemsResponse {
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
 * @title pylons/genesis.proto
 * @version version not set
 */
export class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
  /**
   * No description
   *
   * @tags Query
   * @name QueryAddrFromPubKey
   * @summary AddrFromPubKey returns a bech32 public address from the public key
   * @request GET:/custom/pylons/addr_from_pub_key/{hexPubKey}
   */
  queryAddrFromPubKey = (hexPubKey: string, params: RequestParams = {}) =>
    this.request<PylonsAddrFromPubKeyResponse, RpcStatus>({
      path: `/custom/pylons/addr_from_pub_key/${hexPubKey}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryPylonsBalance
   * @summary PylonsBalance provides balances in pylons
   * @request GET:/custom/pylons/balance/{address}
   */
  queryPylonsBalance = (address: string, params: RequestParams = {}) =>
    this.request<PylonsPylonsBalanceResponse, RpcStatus>({
      path: `/custom/pylons/balance/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryCheckGoogleIapOrder
   * @summary CheckGoogleIapOrder check if google iap order is given to user with purchase token
   * @request GET:/custom/pylons/check_google_iap_order/{purchaseToken}
   */
  queryCheckGoogleIapOrder = (purchaseToken: string, params: RequestParams = {}) =>
    this.request<PylonsCheckGoogleIapOrderResponse, RpcStatus>({
      path: `/custom/pylons/check_google_iap_order/${purchaseToken}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetCookbook
   * @summary GetCookbook returns a cookbook based on the cookbook id
   * @request GET:/custom/pylons/get_cookbook/{cookbookID}
   */
  queryGetCookbook = (cookbookID: string, params: RequestParams = {}) =>
    this.request<PylonsGetCookbookResponse, RpcStatus>({
      path: `/custom/pylons/get_cookbook/${cookbookID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetExecution
   * @summary GetExecution returns an execution based on the execution id
   * @request GET:/custom/pylons/get_execution/{executionID}
   */
  queryGetExecution = (executionID: string, params: RequestParams = {}) =>
    this.request<PylonsGetExecutionResponse, RpcStatus>({
      path: `/custom/pylons/get_execution/${executionID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetItem
   * @summary GetItem returns a item based on the item id
   * @request GET:/custom/pylons/get_item/{itemID}
   */
  queryGetItem = (itemID: string, params: RequestParams = {}) =>
    this.request<PylonsGetItemResponse, RpcStatus>({
      path: `/custom/pylons/get_item/${itemID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetLockedCoinDetails
   * @summary GetLockedCoinDetails returns locked coins with details based on user
   * @request GET:/custom/pylons/get_locked_coin_details/{address}
   */
  queryGetLockedCoinDetails = (address: string, params: RequestParams = {}) =>
    this.request<PylonsGetLockedCoinDetailsResponse, RpcStatus>({
      path: `/custom/pylons/get_locked_coin_details/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetLockedCoins
   * @summary GetLockedCoins returns locked coins based on user
   * @request GET:/custom/pylons/get_locked_coins/{address}
   */
  queryGetLockedCoins = (address: string, params: RequestParams = {}) =>
    this.request<PylonsGetLockedCoinsResponse, RpcStatus>({
      path: `/custom/pylons/get_locked_coins/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetRecipe
   * @summary GetRecipe returns a recipe based on the recipe id
   * @request GET:/custom/pylons/get_recipe/{recipeID}
   */
  queryGetRecipe = (recipeID: string, params: RequestParams = {}) =>
    this.request<PylonsGetRecipeResponse, RpcStatus>({
      path: `/custom/pylons/get_recipe/${recipeID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryGetTrade
   * @summary GetTrade returns a trade based on the trade id
   * @request GET:/custom/pylons/get_trade/{tradeID}
   */
  queryGetTrade = (tradeID: string, params: RequestParams = {}) =>
    this.request<PylonsGetTradeResponse, RpcStatus>({
      path: `/custom/pylons/get_trade/${tradeID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryItemsByCookbook
   * @summary ItemsByCookbook returns a cookbook based on the cookbook id
   * @request GET:/custom/pylons/items_by_cookbook/{cookbookID}
   */
  queryItemsByCookbook = (cookbookID: string, params: RequestParams = {}) =>
    this.request<PylonsItemsByCookbookResponse, RpcStatus>({
      path: `/custom/pylons/items_by_cookbook/${cookbookID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryItemsBySender
   * @summary ItemsBySender returns all items based on the sender address
   * @request GET:/custom/pylons/items_by_sender/{sender}
   */
  queryItemsBySender = (sender: string, params: RequestParams = {}) =>
    this.request<PylonsItemsBySenderResponse, RpcStatus>({
      path: `/custom/pylons/items_by_sender/${sender}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListCookbook
   * @summary ListCookbook returns a cookbook based on the cookbook id
   * @request GET:/custom/pylons/list_cookbook/{address}
   */
  queryListCookbook = (address: string, params: RequestParams = {}) =>
    this.request<PylonsListCookbookResponse, RpcStatus>({
      path: `/custom/pylons/list_cookbook/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListExecutions
   * @summary ListExecutions lists all the executions based on the sender address
   * @request GET:/custom/pylons/list_executions/{sender}
   */
  queryListExecutions = (sender: string, params: RequestParams = {}) =>
    this.request<PylonsListExecutionsResponse, RpcStatus>({
      path: `/custom/pylons/list_executions/${sender}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListRecipe
   * @summary ListRecipe returns a recipe based on the recipe id
   * @request GET:/custom/pylons/list_recipe/{address}
   */
  queryListRecipe = (address: string, params: RequestParams = {}) =>
    this.request<PylonsListRecipeResponse, RpcStatus>({
      path: `/custom/pylons/list_recipe/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListRecipeByCookbook
   * @summary ListRecipeByCookbook returns a recipe based on the recipe id
   * @request GET:/custom/pylons/list_recipe_by_cookbook/{cookbookID}
   */
  queryListRecipeByCookbook = (cookbookID: string, params: RequestParams = {}) =>
    this.request<PylonsListRecipeByCookbookResponse, RpcStatus>({
      path: `/custom/pylons/list_recipe_by_cookbook/${cookbookID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListShortenRecipe
   * @summary ListShortenRecipe returns a recipe based on the recipe id
   * @request GET:/custom/pylons/list_shorten_recipe/{address}
   */
  queryListShortenRecipe = (address: string, params: RequestParams = {}) =>
    this.request<PylonsListShortenRecipeResponse, RpcStatus>({
      path: `/custom/pylons/list_shorten_recipe/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListShortenRecipeByCookbook
   * @summary ListShortenRecipeByCookbook returns a recipe based on the recipe id
   * @request GET:/custom/pylons/list_shorten_recipe_by_cookbook/{cookbookID}
   */
  queryListShortenRecipeByCookbook = (cookbookID: string, params: RequestParams = {}) =>
    this.request<PylonsListShortenRecipeByCookbookResponse, RpcStatus>({
      path: `/custom/pylons/list_shorten_recipe_by_cookbook/${cookbookID}`,
      method: "GET",
      format: "json",
      ...params,
    });

  /**
   * No description
   *
   * @tags Query
   * @name QueryListTrade
   * @summary ListTrade returns a trade based on the trade id
   * @request GET:/custom/pylons/list_trade/{address}
   */
  queryListTrade = (address: string, params: RequestParams = {}) =>
    this.request<PylonsListTradeResponse, RpcStatus>({
      path: `/custom/pylons/list_trade/${address}`,
      method: "GET",
      format: "json",
      ...params,
    });
}
