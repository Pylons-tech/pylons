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
 * @title pylons/genesis.proto
 * @version version not set
 */
export class Api extends HttpClient {
    constructor() {
        super(...arguments);
        /**
         * No description
         *
         * @tags Query
         * @name QueryAddrFromPubKey
         * @summary AddrFromPubKey returns a bech32 public address from the public key
         * @request GET:/custom/pylons/addr_from_pub_key/{hexPubKey}
         */
        this.queryAddrFromPubKey = (hexPubKey, params = {}) => this.request({
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
        this.queryPylonsBalance = (address, params = {}) => this.request({
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
        this.queryCheckGoogleIapOrder = (purchaseToken, params = {}) => this.request({
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
        this.queryGetCookbook = (cookbookID, params = {}) => this.request({
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
        this.queryGetExecution = (executionID, params = {}) => this.request({
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
        this.queryGetItem = (itemID, params = {}) => this.request({
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
        this.queryGetLockedCoinDetails = (address, params = {}) => this.request({
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
        this.queryGetLockedCoins = (address, params = {}) => this.request({
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
        this.queryGetRecipe = (recipeID, params = {}) => this.request({
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
        this.queryGetTrade = (tradeID, params = {}) => this.request({
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
        this.queryItemsByCookbook = (cookbookID, params = {}) => this.request({
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
        this.queryItemsBySender = (sender, params = {}) => this.request({
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
        this.queryListCookbook = (address, params = {}) => this.request({
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
        this.queryListExecutions = (sender, params = {}) => this.request({
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
        this.queryListRecipe = (address, params = {}) => this.request({
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
        this.queryListRecipeByCookbook = (cookbookID, params = {}) => this.request({
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
        this.queryListShortenRecipe = (address, params = {}) => this.request({
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
        this.queryListShortenRecipeByCookbook = (cookbookID, params = {}) => this.request({
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
        this.queryListTrade = (address, params = {}) => this.request({
            path: `/custom/pylons/list_trade/${address}`,
            method: "GET",
            format: "json",
            ...params,
        });
    }
}
