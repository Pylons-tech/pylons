<template>
	<div>
		<div>
			<SideBarComponent />
		</div>
	</div>
</template>

<script>

import SideBarComponent from '@/views/ApplicationLayout'

export default {
	components: {
		SideBarComponent,
	},
	data() {
		return {
			visibleLeft: false,
			items: [
				{
					label: 'Create a new Cookbook',
					icon: 'pi pi-book',
					to: '/cookbook'
				}
			]
		}
	},
	computed: {
		address() {
			return this.$store.getters['common/wallet/address']
		}
	}
}
</script>
