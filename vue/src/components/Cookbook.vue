<template>
	<div id="cookbookForm" class="form-group">
		<SpType modulePath="Pylonstech.pylons.pylons" moduleType="Cookbook" />
	</div>
</template>

<script>
export default {
	name: 'Cookbook',
	data() {
		return {
			id: '',
			nodeVersion: '',
			name: '',
			description: '',
			developer: '',
			version: '',
			supportEmail: ''
		}
	},
	methods: {
		createCookbook(event) {
			this.$store.dispatch('Pylonstech.pylons.pylons/sendMsgCreateCookbook', {
				value: {
					name: '',
					description: '',
					developer: '',
					version: '',
					supportEmail: '',
					costPerBlock: { amount: '', denom: '' },
					enabled: true
				},
				fee: [],
				memo: ''
			})
		}
	}
}
</script>
