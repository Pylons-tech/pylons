<template>
	<div class="card">
		<Fieldset legend="Create a new Cookbook">
			<div class="p-field p-grid">CREATE NEW COOKBOOK</div>
			<div class="p-field p-grid">
				<label for="cookbookid" class="p-col-fixed" style="width: 200px">ID</label>
				<div class="p-col"><InputText id="cookbookid" type="text" v-model="id" /></div>
			</div>
			<div class="p-field p-grid">
				<label for="nodeVersion" class="p-col-fixed" style="width: 200px">Node Version</label>
				<div class="p-col"><InputText id="nodeVersion" type="text" v-model="nodeVersion" /></div>
			</div>
			<div class="p-field p-grid">
				<label for="name" class="p-col-fixed" style="width: 200px">Name</label>
				<div class="p-col"><InputText id="name" type="text" v-model="name" /></div>
			</div>
			<div class="p-field p-grid">
				<label for="description" class="p-col-fixed" style="width: 200px">Description</label>
				<div class="p-col"><InputText id="description" type="text" v-model="description" /></div>
			</div>
			<div class="p-field p-grid">
				<label for="developer" class="p-col-fixed" style="width: 200px">Developer</label>
				<div class="p-col"><InputText id="developer" type="text" v-model="developer" /></div>
			</div>
			<div class="p-field p-grid">
				<label for="version" class="p-col-fixed" style="width: 200px">version</label>
				<div class="p-col"><InputText id="developer" type="text" v-model="version" /></div>
			</div>
			<Fieldset legend="Cost Per Block">
				<div class="p-field p-grid">
					<label for="coinDenom" class="p-col-fixed" style="width: 200px">coinDenom</label>
					<div class="p-col"><InputText id="developer" type="text" v-model="coinDenom" /></div>
				</div>
				<div class="p-field p-grid">
					<label for="coinAmount" class="p-col-fixed" style="width: 200px">coinAmount</label>
					<div class="p-col"><InputText id="developer" type="text" v-model="coinAmount" /></div>
				</div>
			</Fieldset>
			<br>
			<Button label='Submit' v-on:click="createCookbook()" :disabled="!address"/>
		</Fieldset>
	</div>

</template>

<script>
import InputText from 'primevue/inputtext/sfc'
import Fieldset from 'primevue/fieldset'
import Button from 'primevue/button'

export default {
	name: 'Cookbook',
	components: {
		InputText,
		Fieldset,
		Button
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
