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
export var ContentType;
(function (ContentType) {
    ContentType["Json"] = "application/json";
    ContentType["FormData"] = "multipart/form-data";
    ContentType["UrlEncoded"] = "application/x-www-form-urlencoded";
})(ContentType || (ContentType = {}));
export class HttpClient {
    constructor(apiConfig = {}) {
        this.baseUrl = "";
        this.securityData = null;
        this.securityWorker = null;
        this.abortControllers = new Map();
        this.baseApiParams = {
            credentials: "same-origin",
            headers: {},
            redirect: "follow",
            referrerPolicy: "no-referrer",
        };
        this.setSecurityData = (data) => {
            this.securityData = data;
        };
        this.contentFormatters = {
            [ContentType.Json]: (input) => input !== null && (typeof input === "object" || typeof input === "string") ? JSON.stringify(input) : input,
            [ContentType.FormData]: (input) => Object.keys(input || {}).reduce((data, key) => {
                data.append(key, input[key]);
                return data;
            }, new FormData()),
            [ContentType.UrlEncoded]: (input) => this.toQueryString(input),
        };
        this.createAbortSignal = (cancelToken) => {
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
        this.abortRequest = (cancelToken) => {
            const abortController = this.abortControllers.get(cancelToken);
            if (abortController) {
                abortController.abort();
                this.abortControllers.delete(cancelToken);
            }
        };
        this.request = ({ body, secure, path, type, query, format = "json", baseUrl, cancelToken, ...params }) => {
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
                const r = response;
                r.data = null;
                r.error = null;
                const data = await response[format]()
                    .then((data) => {
                    if (r.ok) {
                        r.data = data;
                    }
                    else {
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
                if (!response.ok)
                    throw data;
                return data;
            });
        };
        Object.assign(this, apiConfig);
    }
    addQueryParam(query, key) {
        const value = query[key];
        return (encodeURIComponent(key) +
            "=" +
            encodeURIComponent(Array.isArray(value) ? value.join(",") : typeof value === "number" ? value : `${value}`));
    }
    toQueryString(rawQuery) {
        const query = rawQuery || {};
        const keys = Object.keys(query).filter((key) => "undefined" !== typeof query[key]);
        return keys
            .map((key) => typeof query[key] === "object" && !Array.isArray(query[key])
            ? this.toQueryString(query[key])
            : this.addQueryParam(query, key))
            .join("&");
    }
    addQueryParams(rawQuery) {
        const queryString = this.toQueryString(rawQuery);
        return queryString ? `?${queryString}` : "";
    }
    mergeRequestParams(params1, params2) {
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
}
/**
 * @title pylons/accounts.proto
 * @version version not set
 */
export class Api extends HttpClient {
    constructor() {
        super(...arguments);
        /**
         * No description
         *
         * @tags Query
         * @name QueryFight
         * @summary Queries a list of fight items.
         * @request GET:/Pylons-tech/pylons/pylons/fight
         */
        this.queryFight = (query, params = {}) => this.request({
            path: `/Pylons-tech/pylons/pylons/fight`,
            method: "GET",
            query: query,
            format: "json",
            ...params,
        });
        /**
         * No description
         *
         * @tags Query
         * @name QueryUsernameByAddress
         * @summary Queries a list of getAccountByAddress items.
         * @request GET:/pylons/account/address/{address}
         */
        this.queryUsernameByAddress = (address, params = {}) => this.request({
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
        this.queryAddressByUsername = (username, params = {}) => this.request({
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
        this.queryCookbook = (ID, params = {}) => this.request({
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
        this.queryListCookbooksByCreator = (creator, query, params = {}) => this.request({
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
        this.queryExecution = (ID, params = {}) => this.request({
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
        this.queryListExecutionsByItem = (CookbookID, ItemID, query, params = {}) => this.request({
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
        this.queryListExecutionsByRecipe = (CookbookID, RecipeID, query, params = {}) => this.request({
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
        this.queryGoogleInAppPurchaseOrder = (PurchaseToken, params = {}) => this.request({
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
        this.queryItem = (CookbookID, ID, params = {}) => this.request({
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
        this.queryListItemByOwner = (owner, query, params = {}) => this.request({
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
         * @name QueryPaymentInfo
         * @summary Queries a paymentInfo by index.
         * @request GET:/pylons/payment/{purchaseID}
         */
        this.queryPaymentInfo = (purchaseID, params = {}) => this.request({
            path: `/pylons/payment/${purchaseID}`,
            method: "GET",
            format: "json",
            ...params,
        });
        /**
         * No description
         *
         * @tags Query
         * @name QueryPaymentInfoAll
         * @summary Queries a list of paymentInfo items.
         * @request GET:/pylons/payments
         */
        this.queryPaymentInfoAll = (query, params = {}) => this.request({
            path: `/pylons/payments`,
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
        this.queryRecipe = (CookbookID, ID, params = {}) => this.request({
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
        this.queryListRecipesByCookbook = (CookbookID, query, params = {}) => this.request({
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
         * @name QueryRedeemInfo
         * @summary Queries a redeemInfo by index.
         * @request GET:/pylons/redeem/{ID}
         */
        this.queryRedeemInfo = (ID, params = {}) => this.request({
            path: `/pylons/redeem/${ID}`,
            method: "GET",
            format: "json",
            ...params,
        });
        /**
         * No description
         *
         * @tags Query
         * @name QueryRedeemInfoAll
         * @summary Queries a list of redeemInfo items.
         * @request GET:/pylons/redeems
         */
        this.queryRedeemInfoAll = (query, params = {}) => this.request({
            path: `/pylons/redeems`,
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
        this.queryTrade = (ID, params = {}) => this.request({
            path: `/pylons/trade/${ID}`,
            method: "GET",
            format: "json",
            ...params,
        });
        /**
         * No description
         *
         * @tags Query
         * @name QueryListTradesByCreator
         * @summary Queries a list of listTradesByCreator items.
         * @request GET:/pylons/trades/{creator}
         */
        this.queryListTradesByCreator = (creator, query, params = {}) => this.request({
            path: `/pylons/trades/${creator}`,
            method: "GET",
            query: query,
            format: "json",
            ...params,
        });
    }
}
