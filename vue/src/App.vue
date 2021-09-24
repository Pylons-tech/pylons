<template>
	<div v-if="initialized">
		<SpWallet ref="wallet" v-on:dropdown-opened="$refs.menu.closeDropdown()" />
		<SpLayout>
			<template v-slot:sidebar>
				<Sidebar />
			</template>
			<template v-slot:content>
				<router-view />
			</template>
		</SpLayout>
	</div>
</template>

<style>
body {
	margin: 0;
}
</style>

<script>
import './scss/app.scss'
import '@starport/vue/lib/starport-vue.css'
import Sidebar from './components/Sidebar'

export default {
	components: {
		Sidebar
	},
	data() {
		return {
			initialized: false
		}
	},
	computed: {
		hasWallet() {
			return this.$store.hasModule(['common', 'wallet'])
		}
	},
	async created() {
		await this.$store.dispatch('common/env/init')
		this.initialized = true
		if (!window.keplr) {
			console.log("Keplr not installed")
		}else{
			await window.keplr.experimentalSuggestChain({
				chainId: 'pylons',
				chainName: 'Pylons',
				rpc: 'http://localhost:26657',
				rest: 'http://localhost:1317',
				bip44: {
					coinType: 118
				},
				bech32Config: {
					bech32PrefixAccAddr: 'cosmos',
					bech32PrefixAccPub: 'cosmos' + 'pub',
					bech32PrefixValAddr: 'cosmos' + 'valoper',
					bech32PrefixValPub: 'cosmos' + 'valoperpub',
					bech32PrefixConsAddr: 'cosmos' + 'valcons',
					bech32PrefixConsPub: 'cosmos' + 'valconspub'
				},
				currencies: [
					{
						coinDenom: 'ATOM',
						coinMinimalDenom: 'uatom',
						coinDecimals: 6,
						coinGeckoId: 'cosmos'
					},
					{
						coinDenom: 'BEDROCK',
						coinMinimalDenom: 'ubedrock',
						coinDecimals: 6,
						coinGeckoId: 'cosmos'
					},
				],
				feeCurrencies: [
					{
						coinDenom: 'BEDROCK',
						coinMinimalDenom: 'ubedrock',
						coinDecimals: 6,
						coinGeckoId: 'cosmos'
					},
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
		}
	},
	errorCaptured(err) {
		console.log(err)
		return false
	}
}
</script>
