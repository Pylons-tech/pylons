<template>
	<div class="p-grid">
		<div class="p-col-fixed" style="width: 15vw">
			<Button type="button" @click="toggle" icon="pi pi-bars" />
		</div>
		<div class="p-col-fixed" style="width: 85vw">
			<div>Pylons App</div>
		</div>
	</div>
	<div class="p-card">
		<router-view />
	</div>
	<div class="p-card">
		<SideBarComponent ref="sidebar" />
	</div>
</template>

<script>
import SideBarComponent from '@/views/SidebarComponent'
import Button from 'primevue/button/sfc'

export default {
	components: { SideBarComponent, Button },
	data() {
		return {
			initialized: false
		}
	},
	methods: {
		toggle: function () {
			this.$refs.sidebar.toggle()
		}
	},
	async created() {
		await this.$store.dispatch('common/env/init')

		const chainId = 'pylons'

		window.keplr.enable(chainId)
		const offlineSigner = window.getOfflineSigner(chainId)
		this.$store.dispatch('common/wallet/connectWithKeplr', offlineSigner)

		this.initialized = true
	}
}
</script>
