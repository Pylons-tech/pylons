import { txClient, queryClient, MissingWalletError } from './module';
// @ts-ignore
import { SpVuexError } from '@starport/vuex';
import { Cookbook } from "./module/types/pylons/cookbook";
import { EventCreateAccount } from "./module/types/pylons/event";
import { EventCreateCookbook } from "./module/types/pylons/event";
import { EventUpdateCookbook } from "./module/types/pylons/event";
import { EventTransferCookbook } from "./module/types/pylons/event";
import { EventCreateRecipe } from "./module/types/pylons/event";
import { EventUpdateRecipe } from "./module/types/pylons/event";
import { EventCreateExecution } from "./module/types/pylons/event";
import { EventCompleteExecution } from "./module/types/pylons/event";
import { EventCompleteExecutionEarly } from "./module/types/pylons/event";
import { EventSendItems } from "./module/types/pylons/event";
import { EventSetIemString } from "./module/types/pylons/event";
import { GooglePurchase } from "./module/types/pylons/event";
import { StripePurchase } from "./module/types/pylons/event";
import { ItemRecord } from "./module/types/pylons/execution";
import { Execution } from "./module/types/pylons/execution";
import { GoogleInAppPurchaseOrder } from "./module/types/pylons/google_iap_order";
import { DoubleKeyValue } from "./module/types/pylons/item";
import { LongKeyValue } from "./module/types/pylons/item";
import { StringKeyValue } from "./module/types/pylons/item";
import { Item } from "./module/types/pylons/item";
import { GoogleInAppPurchasePackage } from "./module/types/pylons/params";
import { CoinIssuer } from "./module/types/pylons/params";
import { Params } from "./module/types/pylons/params";
import { DoubleInputParam } from "./module/types/pylons/recipe";
import { LongInputParam } from "./module/types/pylons/recipe";
import { StringInputParam } from "./module/types/pylons/recipe";
import { ConditionList } from "./module/types/pylons/recipe";
import { ItemInput } from "./module/types/pylons/recipe";
import { DoubleWeightRange } from "./module/types/pylons/recipe";
import { DoubleParam } from "./module/types/pylons/recipe";
import { IntWeightRange } from "./module/types/pylons/recipe";
import { LongParam } from "./module/types/pylons/recipe";
import { StringParam } from "./module/types/pylons/recipe";
import { CoinOutput } from "./module/types/pylons/recipe";
import { ItemOutput } from "./module/types/pylons/recipe";
import { ItemModifyOutput } from "./module/types/pylons/recipe";
import { EntriesList } from "./module/types/pylons/recipe";
import { WeightedOutputs } from "./module/types/pylons/recipe";
import { Recipe } from "./module/types/pylons/recipe";
export { Cookbook, EventCreateAccount, EventCreateCookbook, EventUpdateCookbook, EventTransferCookbook, EventCreateRecipe, EventUpdateRecipe, EventCreateExecution, EventCompleteExecution, EventCompleteExecutionEarly, EventSendItems, EventSetIemString, GooglePurchase, StripePurchase, ItemRecord, Execution, GoogleInAppPurchaseOrder, DoubleKeyValue, LongKeyValue, StringKeyValue, Item, GoogleInAppPurchasePackage, CoinIssuer, Params, DoubleInputParam, LongInputParam, StringInputParam, ConditionList, ItemInput, DoubleWeightRange, DoubleParam, IntWeightRange, LongParam, StringParam, CoinOutput, ItemOutput, ItemModifyOutput, EntriesList, WeightedOutputs, Recipe };
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
        ListItemByOwner: {},
        GoogleInAppPurchaseOrder: {},
        ListExecutionsByItem: {},
        ListExecutionsByRecipe: {},
        Execution: {},
        ListRecipesByCookbook: {},
        Item: {},
        Recipe: {},
        ListCookbooksByCreator: {},
        Cookbook: {},
        _Structure: {
            Cookbook: getStructure(Cookbook.fromPartial({})),
            EventCreateAccount: getStructure(EventCreateAccount.fromPartial({})),
            EventCreateCookbook: getStructure(EventCreateCookbook.fromPartial({})),
            EventUpdateCookbook: getStructure(EventUpdateCookbook.fromPartial({})),
            EventTransferCookbook: getStructure(EventTransferCookbook.fromPartial({})),
            EventCreateRecipe: getStructure(EventCreateRecipe.fromPartial({})),
            EventUpdateRecipe: getStructure(EventUpdateRecipe.fromPartial({})),
            EventCreateExecution: getStructure(EventCreateExecution.fromPartial({})),
            EventCompleteExecution: getStructure(EventCompleteExecution.fromPartial({})),
            EventCompleteExecutionEarly: getStructure(EventCompleteExecutionEarly.fromPartial({})),
            EventSendItems: getStructure(EventSendItems.fromPartial({})),
            EventSetIemString: getStructure(EventSetIemString.fromPartial({})),
            GooglePurchase: getStructure(GooglePurchase.fromPartial({})),
            StripePurchase: getStructure(StripePurchase.fromPartial({})),
            ItemRecord: getStructure(ItemRecord.fromPartial({})),
            Execution: getStructure(Execution.fromPartial({})),
            GoogleInAppPurchaseOrder: getStructure(GoogleInAppPurchaseOrder.fromPartial({})),
            DoubleKeyValue: getStructure(DoubleKeyValue.fromPartial({})),
            LongKeyValue: getStructure(LongKeyValue.fromPartial({})),
            StringKeyValue: getStructure(StringKeyValue.fromPartial({})),
            Item: getStructure(Item.fromPartial({})),
            GoogleInAppPurchasePackage: getStructure(GoogleInAppPurchasePackage.fromPartial({})),
            CoinIssuer: getStructure(CoinIssuer.fromPartial({})),
            Params: getStructure(Params.fromPartial({})),
            DoubleInputParam: getStructure(DoubleInputParam.fromPartial({})),
            LongInputParam: getStructure(LongInputParam.fromPartial({})),
            StringInputParam: getStructure(StringInputParam.fromPartial({})),
            ConditionList: getStructure(ConditionList.fromPartial({})),
            ItemInput: getStructure(ItemInput.fromPartial({})),
            DoubleWeightRange: getStructure(DoubleWeightRange.fromPartial({})),
            DoubleParam: getStructure(DoubleParam.fromPartial({})),
            IntWeightRange: getStructure(IntWeightRange.fromPartial({})),
            LongParam: getStructure(LongParam.fromPartial({})),
            StringParam: getStructure(StringParam.fromPartial({})),
            CoinOutput: getStructure(CoinOutput.fromPartial({})),
            ItemOutput: getStructure(ItemOutput.fromPartial({})),
            ItemModifyOutput: getStructure(ItemModifyOutput.fromPartial({})),
            EntriesList: getStructure(EntriesList.fromPartial({})),
            WeightedOutputs: getStructure(WeightedOutputs.fromPartial({})),
            Recipe: getStructure(Recipe.fromPartial({})),
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
        getListItemByOwner: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListItemByOwner[JSON.stringify(params)] ?? {};
        },
        getGoogleInAppPurchaseOrder: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.GoogleInAppPurchaseOrder[JSON.stringify(params)] ?? {};
        },
        getListExecutionsByItem: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListExecutionsByItem[JSON.stringify(params)] ?? {};
        },
        getListExecutionsByRecipe: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListExecutionsByRecipe[JSON.stringify(params)] ?? {};
        },
        getExecution: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.Execution[JSON.stringify(params)] ?? {};
        },
        getListRecipesByCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListRecipesByCookbook[JSON.stringify(params)] ?? {};
        },
        getItem: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.Item[JSON.stringify(params)] ?? {};
        },
        getRecipe: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.Recipe[JSON.stringify(params)] ?? {};
        },
        getListCookbooksByCreator: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.ListCookbooksByCreator[JSON.stringify(params)] ?? {};
        },
        getCookbook: (state) => (params = { params: {} }) => {
            if (!params.query) {
                params.query = null;
            }
            return state.Cookbook[JSON.stringify(params)] ?? {};
        },
        getTypeStructure: (state) => (type) => {
            return state._Structure[type].fields;
        }
    },
    actions: {
        init({ dispatch, rootGetters }) {
            console.log('Vuex module: Pylonstech.pylons.pylons initialized!');
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
        async QueryListItemByOwner({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListItemByOwner(key.owner)).data;
                commit('QUERY', { query: 'ListItemByOwner', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListItemByOwner', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListItemByOwner']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListItemByOwner', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryGoogleInAppPurchaseOrder({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryGoogleInAppPurchaseOrder(key.PurchaseToken)).data;
                commit('QUERY', { query: 'GoogleInAppPurchaseOrder', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryGoogleInAppPurchaseOrder', payload: { options: { all }, params: { ...key }, query } });
                return getters['getGoogleInAppPurchaseOrder']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryGoogleInAppPurchaseOrder', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListExecutionsByItem({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListExecutionsByItem(key.CookbookID, key.ItemID)).data;
                commit('QUERY', { query: 'ListExecutionsByItem', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListExecutionsByItem', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListExecutionsByItem']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListExecutionsByItem', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListExecutionsByRecipe({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListExecutionsByRecipe(key.CookbookID, key.RecipeID)).data;
                commit('QUERY', { query: 'ListExecutionsByRecipe', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListExecutionsByRecipe', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListExecutionsByRecipe']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListExecutionsByRecipe', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryExecution({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryExecution(key.ID)).data;
                commit('QUERY', { query: 'Execution', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryExecution', payload: { options: { all }, params: { ...key }, query } });
                return getters['getExecution']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryExecution', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListRecipesByCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListRecipesByCookbook(key.CookbookID)).data;
                commit('QUERY', { query: 'ListRecipesByCookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListRecipesByCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListRecipesByCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListRecipesByCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryItem({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryItem(key.CookbookID, key.ID)).data;
                commit('QUERY', { query: 'Item', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryItem', payload: { options: { all }, params: { ...key }, query } });
                return getters['getItem']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryItem', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryRecipe({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryRecipe(key.CookbookID, key.ID)).data;
                commit('QUERY', { query: 'Recipe', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryRecipe', payload: { options: { all }, params: { ...key }, query } });
                return getters['getRecipe']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryRecipe', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryListCookbooksByCreator({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryListCookbooksByCreator(key.creator)).data;
                commit('QUERY', { query: 'ListCookbooksByCreator', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryListCookbooksByCreator', payload: { options: { all }, params: { ...key }, query } });
                return getters['getListCookbooksByCreator']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryListCookbooksByCreator', 'API Node Unavailable. Could not perform query: ' + e.message);
            }
        },
        async QueryCookbook({ commit, rootGetters, getters }, { options: { subscribe, all } = { subscribe: false, all: false }, params: { ...key }, query = null }) {
            try {
                const queryClient = await initQueryClient(rootGetters);
                let value = (await queryClient.queryCookbook(key.ID)).data;
                commit('QUERY', { query: 'Cookbook', key: { params: { ...key }, query }, value });
                if (subscribe)
                    commit('SUBSCRIBE', { action: 'QueryCookbook', payload: { options: { all }, params: { ...key }, query } });
                return getters['getCookbook']({ params: { ...key }, query }) ?? {};
            }
            catch (e) {
                throw new SpVuexError('QueryClient:QueryCookbook', 'API Node Unavailable. Could not perform query: ' + e.message);
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
        async sendMsgSetItemString({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSetItemString(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSetItemString:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSetItemString:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgCompleteExecutionEarly({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCompleteExecutionEarly(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCompleteExecutionEarly:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCompleteExecutionEarly:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgTransferCookbook({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgTransferCookbook(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgTransferCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgTransferCookbook:Send', 'Could not broadcast Tx: ' + e.message);
                }
            }
        },
        async sendMsgGoogleInAppPurchaseGetCoins({ rootGetters }, { value, fee = [], memo = '' }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGoogleInAppPurchaseGetCoins(value);
                const result = await txClient.signAndBroadcast([msg], { fee: { amount: fee,
                        gas: "200000" }, memo });
                return result;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGoogleInAppPurchaseGetCoins:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGoogleInAppPurchaseGetCoins:Send', 'Could not broadcast Tx: ' + e.message);
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
        async MsgSetItemString({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgSetItemString(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgSetItemString:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgSetItemString:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgCompleteExecutionEarly({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgCompleteExecutionEarly(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgCompleteExecutionEarly:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgCompleteExecutionEarly:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgTransferCookbook({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgTransferCookbook(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgTransferCookbook:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgTransferCookbook:Create', 'Could not create message: ' + e.message);
                }
            }
        },
        async MsgGoogleInAppPurchaseGetCoins({ rootGetters }, { value }) {
            try {
                const txClient = await initTxClient(rootGetters);
                const msg = await txClient.msgGoogleInAppPurchaseGetCoins(value);
                return msg;
            }
            catch (e) {
                if (e == MissingWalletError) {
                    throw new SpVuexError('TxClient:MsgGoogleInAppPurchaseGetCoins:Init', 'Could not initialize signing client. Wallet is required.');
                }
                else {
                    throw new SpVuexError('TxClient:MsgGoogleInAppPurchaseGetCoins:Create', 'Could not create message: ' + e.message);
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
    }
};
