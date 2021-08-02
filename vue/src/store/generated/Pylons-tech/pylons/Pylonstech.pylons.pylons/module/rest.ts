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

export interface PylonsLongParam {
  key?: string;

  /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
  rate?: string;
  weightRanges?: PylonsIntWeightRange[];
  program?: string;
}

export type PylonsMsgCreateCookbookResponse = object;

export type PylonsMsgCreateRecipeResponse = object;

export type PylonsMsgUpdateCookbookResponse = object;

export type PylonsMsgUpdateRecipeResponse = object;

export interface PylonsQueryGetCookbookResponse {
  Cookbook?: PylonsCookbook;
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
 * @title pylons/cookbook.proto
 * @version version not set
 */
export class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
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
   * @request GET:/pylons/listCookbooks/{creator}
   */
  queryListCookbooksByCreator = (creator: string, params: RequestParams = {}) =>
    this.request<PylonsQueryListCookbooksByCreatorResponse, RpcStatus>({
      path: `/pylons/listCookbooks/${creator}`,
      method: "GET",
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
}
