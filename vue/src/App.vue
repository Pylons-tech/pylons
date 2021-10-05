<template>
	<div class="p-grid">
		<div class="p-col-fixed" style="width:15vw">
			<Button type="button" @click="toggle" icon="pi pi-bars" />
		</div>
		<div class="p-col-fixed" style='width:85vw'>
			<div>Pylons App</div>
		</div>
	</div>
	<div class="p-card">
		<router-view />
	</div>
	<div>
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
	computed: {
		hasWallet() {
			return this.$store.hasModule(['common', 'wallet'])
		}
	},
	methods: {
		toggle: function () {
			this.$refs.sidebar.toggle()
		}
	},
	async created() {
		await this.$store.dispatch('common/env/init')
		this.initialized = true
	},
	errorCaptured(err) {
		console.log(err)
		return false
	}
}
</script>
