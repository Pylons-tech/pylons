<template>
	<div class=''>

	</div>
	<div class="card">
		<div class="p-field p-grid">
			<h4>Create a new Cookbook</h4>
			<label for="firstname3" class="p-col-fixed" style="width: 100px">ID</label>
			<div class="p-col">
				<InputText id="id" type="text" v-model="id" aria-placeholder="id" />
			</div>
		</div>
		<div class="p-field p-grid">
			<label for="lastname3" class="p-col-fixed" style="width: 100px">Lastname</label>
			<div class="p-col">
				<InputText id="lastname3" type="text" />
			</div>
		</div>
	</div>

	<div id="cookbookForm" class="sp-form-group sp-box">
		<div class="mb-3">CREATE NEW COOKBOOK</div>
		<div class="sp-type-form__field sp-form-group">
			<label for="id" class="form-label">ID</label>
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
		<div class="card">
			<div class="card-header">Cost per block</div>
			<div class="card-body">
				<div class="sp-type-form__field sp-form-group">
					<label for="coinDenom" class="form-label">Coin Denomination</label>
					<input type="text" id="coinDenom" class="form-control" v-model="coinDenom" placeholder="supportEmail" />
				</div>
				<div class="sp-type-form__field sp-form-group">
					<label for="coinAmount" class="form-label">Coin Amount</label>
					<input type="text" id="coinAmount" class="form-control" v-model="coinAmount" placeholder="supportEmail" />
				</div>
			</div>
		</div>
		<button type="button" v-on:click="createCookbook()" class="btn btn-primary" :disabled="!address">Submit</button>
	</div>
</template>

<script>
import InputText from 'primevue/inputtext/sfc'

export default {
	name: 'Cookbook',
	components: {
		InputText
	},
	computed: {
		address: function () {
			return this.$store.getters['common/wallet/address']
		}
	},
	data() {
		return {
			id: '',
			nodeVersion: '',
			name: '',
			description: '',
			developer: '',
			version: '',
			supportEmail: '',
			coinDenom: '',
			coinAmount: ''
		}
	},
	methods: {
		createCookbook() {
			this.$store.dispatch('Pylonstech.pylons.pylons/sendMsgCreateCookbook', {
				value: {
					creator: this.$store.getters['common/wallet/address'],
					ID: this.id,
					version: this.version,
					name: this.name,
					nodeVersion: this.nodeVersion,
					description: this.description,
					developer: this.developer,
					supportEmail: this.supportEmail,
					costPerBlock: {
						denom: this.coinDenom,
						amount: this.coinAmount
					},
					enabled: true
				},
				fee: [],
				memo: ''
			})
		}
	}
}
</script>
