import { createApp } from 'vue'
import App from './App.vue'
import store from './store'
import router from './router'
import vueLib from '@starport/vue'
import PrimeVue from 'primevue/config'

// PrimeVue Components

import 'primevue/resources/themes/saga-blue/theme.css' //theme
import 'primevue/resources/primevue.min.css' //core css
import 'primeicons/primeicons.css' //icons
import 'primeflex/primeflex.css' //primeflex

const app = createApp(App)
app.config.globalProperties._depsLoaded = true
app.use(store).use(router).use(vueLib).use(PrimeVue).mount('#app')

window.MonacoEnvironment = {
	getWorkerUrl: function (workerId, label) {
		return `data:text/javascript;charset=utf-8,${encodeURIComponent(`
              self.MonacoEnvironment = { baseUrl: '${window.location.origin}/' };
              importScripts('${window.location.origin}/vs/base/worker/workerMain.js');
          `)}`;
	}
};

window.keplr.experimentalSuggestChain({
	chainId: 'pylons',
	chainName: 'Pylons Testnet',
	rpc: 'http://localhost:26657',
	rest: 'http://localhost:1317',
	bip44: {
		coinType: 118
	},
	bech32Config: {
		bech32PrefixAccAddr: 'pylo',
		bech32PrefixAccPub: 'pylo' + 'pub',
		bech32PrefixValAddr: 'pylo' + 'valoper',
		bech32PrefixValPub: 'pylo' + 'valoperpub',
		bech32PrefixConsAddr: 'pylo' + 'valcons',
		bech32PrefixConsPub: 'pylo' + 'valconspub'
	},
	currencies: [
		{
			coinDenom: 'BEDROCK',
			coinMinimalDenom: 'ubedrock',
			coinDecimals: 6,
			coinGeckoId: 'cosmos'
		}
	],
	feeCurrencies: [
		{
			coinDenom: 'BEDROCK',
			coinMinimalDenom: 'ubedrock',
			coinDecimals: 6,
			coinGeckoId: 'cosmos'
		}
	],
	stakeCurrency: {
		coinDenom: 'BEDROCK',
		coinMinimalDenom: 'ubedrock',
		coinDecimals: 6,
		coinGeckoId: 'cosmos'
	},
	coinType: 118,
	gasPriceStep: {
		low: 0.01,
		average: 0.025,
		high: 0.03
	}
})


