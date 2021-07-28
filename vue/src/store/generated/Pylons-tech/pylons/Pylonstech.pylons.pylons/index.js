import { txClient, queryClient, MissingWalletError } from './module';
// @ts-ignore
import { SpVuexError } from '@starport/vuex';
import { Cookbook } from "./module/types/pylons/cookbook";
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
export { Cookbook, DoubleInputParam, LongInputParam, StringInputParam, ConditionList, ItemInput, DoubleWeightRange, DoubleParam, IntWeightRange, LongParam, StringParam, CoinOutput, ItemOutput, ItemModifyOutput, EntriesList, WeightedOutputs, Recipe };
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
        Recipe: {},
        ListCookbooksByCreator: {},
        Cookbook: {},
        _Structure: {
            Cookbook: getStructure(Cookbook.fromPartial({})),
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
    }
};
