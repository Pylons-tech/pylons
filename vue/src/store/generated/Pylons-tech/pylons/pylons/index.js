import { txClient, queryClient, MissingWalletError } from './module';
// @ts-ignore
import { SpVuexError } from '@starport/vuex';
import { EntriesList } from "./module/types/pylons/pylons";
import { CoinInput } from "./module/types/pylons/pylons";
import { CoinOutput } from "./module/types/pylons/pylons";
import { DoubleInputParam } from "./module/types/pylons/pylons";
import { DoubleWeightRange } from "./module/types/pylons/pylons";
import { LongParam } from "./module/types/pylons/pylons";
import { IntWeightRange } from "./module/types/pylons/pylons";
import { StringInputParam } from "./module/types/pylons/pylons";
import { FeeInputParam } from "./module/types/pylons/pylons";
import { LongInputParam } from "./module/types/pylons/pylons";
import { ConditionList } from "./module/types/pylons/pylons";
import { ItemInput } from "./module/types/pylons/pylons";
import { WeightedOutputs } from "./module/types/pylons/pylons";
import { StringParam } from "./module/types/pylons/pylons";
import { DoubleParam } from "./module/types/pylons/pylons";
import { ItemOutput } from "./module/types/pylons/pylons";
import { ItemModifyOutput } from "./module/types/pylons/pylons";
import { ItemModifyParams } from "./module/types/pylons/pylons";
import { Item } from "./module/types/pylons/pylons";
import { DoubleKeyValue } from "./module/types/pylons/pylons";
import { LongKeyValue } from "./module/types/pylons/pylons";
import { StringKeyValue } from "./module/types/pylons/pylons";
import { TradeItemInput } from "./module/types/pylons/pylons";
import { LockedCoinDescribe } from "./module/types/pylons/pylons";
import { ShortenRecipe } from "./module/types/pylons/pylons";
import { Execution } from "./module/types/pylons/pylons";
import { Cookbook } from "./module/types/pylons/pylons";
import { Recipe } from "./module/types/pylons/pylons";
import { Trade } from "./module/types/pylons/pylons";
import { StripePrice } from "./module/types/pylons/pylons";
import { StripeInventory } from "./module/types/pylons/pylons";
import { MsgStripeCustomer } from "./module/types/pylons/tx";
import { MsgStripeCreatePaymentIntentResponse } from "./module/types/pylons/tx";
import { MsgStripeCreateAccountResponse } from "./module/types/pylons/tx";
import { MsgStripeInfoResponse } from "./module/types/pylons/tx";
import { MsgStripeOauthTokenResponse } from "./module/types/pylons/tx";
export { EntriesList, CoinInput, CoinOutput, DoubleInputParam, DoubleWeightRange, LongParam, IntWeightRange, StringInputParam, FeeInputParam, LongInputParam, ConditionList, ItemInput, WeightedOutputs, StringParam, DoubleParam, ItemOutput, ItemModifyOutput, ItemModifyParams, Item, DoubleKeyValue, LongKeyValue, StringKeyValue, TradeItemInput, LockedCoinDescribe, ShortenRecipe, Execution, Cookbook, Recipe, Trade, StripePrice, StripeInventory, MsgStripeCustomer, MsgStripeCreatePaymentIntentResponse, MsgStripeCreateAccountResponse, MsgStripeInfoResponse, MsgStripeOauthTokenResponse };
async function initTxClient(vuexGetters) {
    return await txClient(vuexGetters['common/wallet/signer'], {
        addr: vuexGetters['common/env/apiTendermint']
    });
}
async function initQueryClient(vuexGetters) {
    return await queryClient({
        addr: vuexGetters['common/env/apiCosmos']
    });
}
function mergeResults(value, next_values) {
    for (let prop of Object.keys(next_values)) {
        if (Array.isArray(next_values[prop])) {
            value[prop] = [...value[prop], ...next_values[prop]];
        }
        else {
            value[prop] = next_values[prop];
        }
    }
    return value;
}
function getStructure(template) {
    let structure = { fields: [] };
    for (const [key, value] of Object.entries(template)) {
        let field = {};
        field.name = key;
        field.type = typeof value;
        structure.fields.push(field);
    }
    return structure;
}
const getDefaultState = () => {
    return {
        AddrFromPubKey: {},
        CheckGoogleIapOrder: {},
        GetCookbook: {},
        GetExecution: {},
        GetItem: {},
        GetRecipe: {},
        GetTrade: {},
        ItemsByCookbook: {},
        ItemsBySender: {},
        ListCookbook: {},
        ListExecutions: {},
        GetLockedCoins: {},
        GetLockedCoinDetails: {},
        ListRecipe: {},
        ListRecipeByCookbook: {},
        ListShortenRecipe: {},
        ListShortenRecipeByCookbook: {},
        ListTrade: {},
        PylonsBalance: {},
        _Structure: {
            EntriesList: getStructure(EntriesList.fromPartial({})),
            CoinInput: getStructure(CoinInput.fromPartial({})),
            CoinOutput: getStructure(CoinOutput.fromPartial({})),
            DoubleInputParam: getStructure(DoubleInputParam.fromPartial({})),
            DoubleWeightRange: getStructure(DoubleWeightRange.fromPartial({})),
            LongParam: getStructure(LongParam.fromPartial({})),
            IntWeightRange: getStructure(IntWeightRange.fromPartial({})),
            StringInputParam: getStructure(StringInputParam.fromPartial({})),
            FeeInputParam: getStructure(FeeInputParam.fromPartial({})),
            LongInputParam: getStructure(LongInputParam.fromPartial({})),
            ConditionList: getStructure(ConditionList.fromPartial({})),
            ItemInput: getStructure(ItemInput.fromPartial({})),
            WeightedOutputs: getStructure(WeightedOutputs.fromPartial({})),
            StringParam: getStructure(StringParam.fromPartial({})),
            DoubleParam: getStructure(DoubleParam.fromPartial({})),
            ItemOutput: getStructure(ItemOutput.fromPartial({})),
            ItemModifyOutput: getStructure(ItemModifyOutput.fromPartial({})),
            ItemModifyParams: getStructure(ItemModifyParams.fromPartial({})),
            Item: getStructure(Item.fromPartial({})),
            DoubleKeyValue: getStructure(DoubleKeyValue.fromPartial({})),
            LongKeyValue: getStructure(LongKeyValue.fromPartial({})),
            StringKeyValue: getStructure(StringKeyValue.fromPartial({})),
            TradeItemInput: getStructure(TradeItemInput.fromPartial({})),
            LockedCoinDescribe: getStructure(LockedCoinDescribe.fromPartial({})),
            ShortenRecipe: getStructure(ShortenRecipe.fromPartial({})),
            Execution: getStructure(Execution.fromPartial({})),
            Cookbook: getStructure(Cookbook.fromPartial({})),
            Recipe: getStructure(Recipe.fromPartial({})),
            Trade: getStructure(Trade.fromPartial({})),
            StripePrice: getStructure(StripePrice.fromPartial({})),
            StripeInventory: getStructure(StripeInventory.fromPartial({})),
            MsgStripeCustomer: getStructure(MsgStripeCustomer.fromPartial({})),
            MsgStripeCreatePaymentIntentResponse: getStructure(MsgStripeCreatePaymentIntentResponse.fromPartial({})),
            MsgStripeCreateAccountResponse: getStructure(MsgStripeCreateAccountResponse.fromPartial({})),
            MsgStripeInfoResponse: getStructure(MsgStripeInfoResponse.fromPartial({})),
            MsgStripeOauthTokenResponse: getStructure(MsgStripeOauthTokenResponse.fromPartial({})),
        },
        _Subscriptions: new Set(),
    };
};
// initial state
const state = getDefaultState();
export default {
    namespaced: true,
    state,
    mutations: {
        RESET_STATE(state) {
            Object.assign(state, getDefaultState());
        },
        QUERY(state, { query, key, value }) {
            state[query][JSON.stringify(key)] = value;
        },
        SUBSCRIBE(state, subscription) {
            state._Subscriptions.add(subscription);
        },
        UNSUBSCRIBE(state, subscription) {
            state._Subscriptions.delete(subscription);
        }
    },
    getters: {
        getAddrFromPubKey: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.AddrFromPubKey[JSON.stringify(params)] ?? {};
        },
        getCheckGoogleIapOrder: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.CheckGoogleIapOrder[JSON.stringify(params)] ?? {};
        },
        getGetCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetCookbook[JSON.stringify(params)] ?? {};
        },
        getGetExecution: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetExecution[JSON.stringify(params)] ?? {};
        },
        getGetItem: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetItem[JSON.stringify(params)] ?? {};
        },
        getGetRecipe: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetRecipe[JSON.stringify(params)] ?? {};
        },
        getGetTrade: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetTrade[JSON.stringify(params)] ?? {};
        },
        getItemsByCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ItemsByCookbook[JSON.stringify(params)] ?? {};
        },
        getItemsBySender: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ItemsBySender[JSON.stringify(params)] ?? {};
        },
        getListCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListCookbook[JSON.stringify(params)] ?? {};
        },
        getListExecutions: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListExecutions[JSON.stringify(params)] ?? {};
        },
        getGetLockedCoins: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetLockedCoins[JSON.stringify(params)] ?? {};
        },
        getGetLockedCoinDetails: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GetLockedCoinDetails[JSON.stringify(params)] ?? {};
        },
        getListRecipe: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListRecipe[JSON.stringify(params)] ?? {};
        },
        getListRecipeByCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListRecipeByCookbook[JSON.stringify(params)] ?? {};
        },
        getListShortenRecipe: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListShortenRecipe[JSON.stringify(params)] ?? {};
        },
        getListShortenRecipeByCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListShortenRecipeByCookbook[JSON.stringify(params)] ?? {};
        },
        getListTrade: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListTrade[JSON.stringify(params)] ?? {};
        },
        getPylonsBalance: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.PylonsBalance[JSON.stringify(params)] ?? {};
        },
        getTypeStructure: (state) => (type) => {
            return state._Structure[type].fields;
        }
    },
    actions: {
        init({ dispatch, rootGetters }) {
            console.log('Vuex module: pylons initialized!');
            if (rootGetters['common/env/client']) {
                rootGetters['common/env/client'].on('newblock', () => {
                    dispatch('StoreUpdate');
                });
            }
        },
        resetState({ commit }) {
            commit('RESET_STATE');
        },
        unsubscribe({ commit }, subscription) {
            commit('UNSUBSCRIBE', subscription);
        },
        async StoreUpdate({ state, dispatch }) {
            state._Subscriptions.forEach(async (subscription) => {
                try {
                    await dispatch(subscription.action, subscription.payload);
                }
                catch (e) {
                    throw new SpVuexError('Subscriptions: ' + e.message);
                }
            });
        },
        async QueryAddrFromPubKey({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryAddrFromPubKey(key.hex_pub_key)).data;
                commit('QUERY', { query: 'AddrFromPubKey', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryAddrFromPubKey', payload: { options: { all }, params: { ...key }, query } });
                return getters['getAddrFromPubKey']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryAddrFromPubKey', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryCheckGoogleIapOrder({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryCheckGoogleIapOrder(key.purchaseToken)).data;
                commit('QUERY', { query: 'CheckGoogleIapOrder', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryCheckGoogleIapOrder', payload: { options: { all }, params: { ...key }, query } });
                return getters['getCheckGoogleIapOrder']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryCheckGoogleIapOrder', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetCookbook(key.cookbookID)).data;
                commit('QUERY', { query: 'GetCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetExecution({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetExecution(key.executionID)).data;
                commit('QUERY', { query: 'GetExecution', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetExecution', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetExecution']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetExecution', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetItem({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetItem(key.itemID)).data;
                commit('QUERY', { query: 'GetItem', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetItem', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetItem']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetItem', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetRecipe({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetRecipe(key.recipeID)).data;
                commit('QUERY', { query: 'GetRecipe', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetRecipe', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetRecipe']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetRecipe', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetTrade({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetTrade(key.tradeID)).data;
                commit('QUERY', { query: 'GetTrade', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetTrade', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetTrade']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetTrade', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryItemsByCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryItemsByCookbook(key.cookbookID)).data;
                commit('QUERY', { query: 'ItemsByCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryItemsByCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getItemsByCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryItemsByCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryItemsBySender({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryItemsBySender(key.sender)).data;
                commit('QUERY', { query: 'ItemsBySender', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryItemsBySender', payload: { options: { all }, params: { ...key }, query } });
                return getters['getItemsBySender']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryItemsBySender', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListCookbook(key.address)).data;
                commit('QUERY', { query: 'ListCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListExecutions({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListExecutions(key.sender)).data;
                commit('QUERY', { query: 'ListExecutions', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListExecutions', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListExecutions']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListExecutions', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetLockedCoins({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetLockedCoins(key.address)).data;
                commit('QUERY', { query: 'GetLockedCoins', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetLockedCoins', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetLockedCoins']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetLockedCoins', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGetLockedCoinDetails({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGetLockedCoinDetails(key.address)).data;
                commit('QUERY', { query: 'GetLockedCoinDetails', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGetLockedCoinDetails', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGetLockedCoinDetails']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGetLockedCoinDetails', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListRecipe({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListRecipe(key.address)).data;
                commit('QUERY', { query: 'ListRecipe', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListRecipe', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListRecipe']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListRecipe', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListRecipeByCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListRecipeByCookbook(key.cookbookID)).data;
                commit('QUERY', { query: 'ListRecipeByCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListRecipeByCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListRecipeByCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListRecipeByCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListShortenRecipe({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListShortenRecipe(key.address)).data;
                commit('QUERY', { query: 'ListShortenRecipe', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListShortenRecipe', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListShortenRecipe']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListShortenRecipe', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListShortenRecipeByCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListShortenRecipeByCookbook(key.cookbookID)).data;
                commit('QUERY', { query: 'ListShortenRecipeByCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListShortenRecipeByCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListShortenRecipeByCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListShortenRecipeByCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListTrade({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListTrade(key.address)).data;
                commit('QUERY', { query: 'ListTrade', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListTrade', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListTrade']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListTrade', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryPylonsBalance({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryPylonsBalance(key.address)).data;
                commit('QUERY', { query: 'PylonsBalance', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryPylonsBalance', payload: { options: { all }, params: { ...key }, query } });
                return getters['getPylonsBalance']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryPylonsBalance', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async sendMsgFiatItem({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgFiatItem(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgFiatItem:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgFiatItem:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreateAccount({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateAccount(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateAccount:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateAccount:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgFulfillTrade({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgFulfillTrade(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgFulfillTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgFulfillTrade:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgGoogleIAPGetPylons({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGoogleIAPGetPylons(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGoogleIAPGetPylons:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGoogleIAPGetPylons:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeInfo({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeInfo(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeInfo:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeInfo:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCheckout({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCheckout(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCheckout:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCheckout:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgEnableRecipe({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgEnableRecipe(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgEnableRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgEnableRecipe:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreateSku({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateSku(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateSku:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateSku:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgSendCoins({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSendCoins(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSendCoins:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSendCoins:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgExecuteRecipe({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgExecuteRecipe(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgExecuteRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgExecuteRecipe:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreatePrice({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreatePrice(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreatePrice:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreatePrice:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgDisableTrade({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgDisableTrade(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgDisableTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgDisableTrade:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCreateCookbook({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateCookbook(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateCookbook:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreateProductSku({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateProductSku(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateProductSku:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateProductSku:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgEnableTrade({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgEnableTrade(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgEnableTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgEnableTrade:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgDisableRecipe({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgDisableRecipe(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgDisableRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgDisableRecipe:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreateProduct({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateProduct(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateProduct:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateProduct:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgSendItems({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSendItems(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSendItems:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSendItems:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeOauthToken({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeOauthToken(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeOauthToken:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeOauthToken:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgUpdateItemString({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateItemString(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateItemString:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateItemString:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCreateTrade({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateTrade(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateTrade:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgUpdateRecipe({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateRecipe(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateRecipe:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgStripeCreatePaymentIntent({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreatePaymentIntent(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreatePaymentIntent:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreatePaymentIntent:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCheckExecution({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCheckExecution(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCheckExecution:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCheckExecution:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgGetPylons({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGetPylons(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGetPylons:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGetPylons:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgUpdateCookbook({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateCookbook(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateCookbook:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCreateAccount({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateAccount(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateAccount:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateAccount:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCreateRecipe({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateRecipe(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateRecipe:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async MsgFiatItem({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgFiatItem(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgFiatItem:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgFiatItem:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreateAccount({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateAccount(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateAccount:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateAccount:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgFulfillTrade({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgFulfillTrade(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgFulfillTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgFulfillTrade:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgGoogleIAPGetPylons({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGoogleIAPGetPylons(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGoogleIAPGetPylons:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGoogleIAPGetPylons:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeInfo({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeInfo(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeInfo:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeInfo:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCheckout({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCheckout(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCheckout:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCheckout:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgEnableRecipe({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgEnableRecipe(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgEnableRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgEnableRecipe:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreateSku({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateSku(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateSku:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateSku:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgSendCoins({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSendCoins(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSendCoins:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSendCoins:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgExecuteRecipe({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgExecuteRecipe(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgExecuteRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgExecuteRecipe:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreatePrice({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreatePrice(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreatePrice:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreatePrice:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgDisableTrade({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgDisableTrade(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgDisableTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgDisableTrade:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCreateCookbook({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateCookbook(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateCookbook:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreateProductSku({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateProductSku(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateProductSku:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateProductSku:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgEnableTrade({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgEnableTrade(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgEnableTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgEnableTrade:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgDisableRecipe({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgDisableRecipe(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgDisableRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgDisableRecipe:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreateProduct({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreateProduct(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreateProduct:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreateProduct:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgSendItems({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSendItems(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSendItems:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSendItems:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeOauthToken({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeOauthToken(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeOauthToken:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeOauthToken:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgUpdateItemString({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateItemString(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateItemString:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateItemString:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCreateTrade({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateTrade(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateTrade:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateTrade:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgUpdateRecipe({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateRecipe(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateRecipe:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgStripeCreatePaymentIntent({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgStripeCreatePaymentIntent(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgStripeCreatePaymentIntent:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgStripeCreatePaymentIntent:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCheckExecution({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCheckExecution(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCheckExecution:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCheckExecution:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgGetPylons({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGetPylons(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGetPylons:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGetPylons:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgUpdateCookbook({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgUpdateCookbook(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgUpdateCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgUpdateCookbook:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCreateAccount({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateAccount(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateAccount:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateAccount:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCreateRecipe({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCreateRecipe(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCreateRecipe:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCreateRecipe:Create', 'Could not create message: ' + e.message);
                }
            }
        },
    }
};
