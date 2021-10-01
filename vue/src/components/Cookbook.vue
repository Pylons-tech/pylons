<template>
	<div id="cookbookForm" class="sp-form-group sp-box">
		<div class="mb-3">CREATE NEW COOKBOOK</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="id" class="form-label">Email address</label>
			<input id="id" type="text" class="form-control" v-model="id" placeholder="ID" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Node Version</label>
			<input type="text" id="nodeVersion" class="form-control" v-model="nodeVersion" placeholder="NodeVersion" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Name</label>
			<input type="text" class="form-control" v-model="name" placeholder="Name" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Description</label>
			<input type="text" class="form-control" v-model="description" placeholder="description" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Developer</label>
			<input type="text" class="form-control" v-model="developer" placeholder="developer" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Version</label>
			<input type="text" class="form-control" v-model="version" placeholder="version" />
		</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="nodeVersion" class="form-label">Support Email</label>
			<input type="text" class="form-control" v-model="supportEmail" placeholder="supportEmail" />
		</div>
		<button type="button" v-on:click="createCookbook()" class="btn btn-outline-primary">Submit</button>
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
