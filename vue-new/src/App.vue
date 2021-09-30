<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <HelloWorld msg="Welcome to Your Vue.js App"/>
  <Cookbook />
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import SigningCosmosClient from '@cosmjs/stargate';
import Cookbook from "./components/forms/Cookbook";

export default {
  name: 'App',
  _chainId: 'pylons',
  components: {
    Cookbook,
    HelloWorld
  },
  created() {
    window.addEventListener("load",this.onWindowLoad)
  },
  methods:{
    async onWindowLoad(){
      if (window.keplr.experimentalSuggestChain) {
        window.keplr.experimentalSuggestChain({
          chainId: this._chainId,
          chainName: 'Pylons Testnet',
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
      }
      const chainId = "cosmoshub-3";

      // You should request Keplr to enable the wallet.
      // This method will ask the user whether or not to allow access if they haven't visited this website.
      // Also, it will request user to unlock the wallet if the wallet is locked.
      // If you don't request enabling before usage, there is no guarantee that other methods will work.
      await window.keplr.enable(chainId);

      const offlineSigner = window.getOfflineSigner(chainId);

      // You can get the address/public keys by `getAccounts` method.
      // It can return the array of address/public key.
      // But, currently, Keplr extension manages only one address/public key pair.
      // XXX: This line is needed to set the sender address for SigningCosmosClient.
      const accounts = await offlineSigner.getAccounts();

      // Initialize the gaia api with the offline signer that is injected by Keplr extension.
      new SigningCosmosClient(
          "https://node-cosmoshub-3.keplr.app/rest",
          accounts[0].address,
          offlineSigner,
      );

      document.getElementById("address").append(accounts[0].address);
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
