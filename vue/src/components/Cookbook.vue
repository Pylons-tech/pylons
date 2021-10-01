<template>
	<div id="cookbookForm" class="sp-form-group sp-box">
		<div class="sp-type-form__header sp-box-header">CREATE NEW COOKBOOK</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="id" :placeholder="ID" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="nodeVersion" :placeholder="NodeVersion" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="name" :placeholder="Name" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="description" :placeholder="description" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="developer" :placeholder="developer" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="version" :placeholder="version"  />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<input type="text" class="sp-input" v-model="supportEmail" :placeholder="supportEmail" />
		</div>
		<SpButton type="primary" v-on:click="createCookbook()" :busy="inFlight" />
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
