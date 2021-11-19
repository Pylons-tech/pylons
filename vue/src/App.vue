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
    Sidebar,
  },
  data() {
    return {
      initialized: false,
    }
  },
  computed: {
    hasWallet() {
      return this.$store.hasModule(['common', 'wallet'])
    },
  },
  async created() {
    await this.$store.dispatch('common/env/init', {
      apiNode: 'http://localhost:1317',
      rpcNode: 'http://localhost:26657',
      wsNode: 'ws://localhost:26657/websocket',
      chainId: 'pylons',
      addrPrefix: 'pylo',
      sdkVersion: 'Stargate',
    })
    this.initialized = true
  },
  errorCaptured(err) {
    console.log(err)
    return false
  },
}
</script>
