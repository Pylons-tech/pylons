import { createApp } from 'vue'
import App from './App.vue'
import store from './store'
import router from './router'
import vueLib from '@starport/vue'

const app = createApp(App)
app.config.globalProperties._depsLoaded = true
app.use(store).use(router).use(vueLib).mount('#app')

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

const chainId = 'pylons'

// You should request Keplr to enable the wallet.
// This method will ask the user whether or not to allow access if they haven't visited this website.
// Also, it will request user to unlock the wallet if the wallet is locked.
// If you don't request enabling before usage, there is no guarantee that other methods will work.
window.keplr.enable(chainId)

const offlineSigner = window.getOfflineSigner(chainId)

// You can get the address/public keys by `getAccounts` method.
// It can return the array of address/public key.
// But, currently, Keplr extension manages only one address/public key pair.
// XXX: This line is needed to set the sender address for SigningCosmosClient.
const accounts = offlineSigner.getAccounts()

// Initialize the gaia api with the offline signer that is injected by Keplr extension.
// const cosmJS = new SigningCosmosClient('https://node-cosmoshub-3.keplr.app/rest', accounts[0].address, offlineSigner)

document.getElementById('address').append(accounts[0].address)
