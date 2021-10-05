<template>
	<div className='card'>
		<Fieldset legend='Create a new Recipe'>
			<div className='p-field p-grid'>
				<label htmlFor='recipeid' className='p-col-fixed' style='width: 200px'>Cookbook ID</label>
				<div className='p-col'>
					<InputText id='cookbookId' type='text' v-model='cookbookId' />
				</div>
			</div>
			<div className='p-field p-grid'>
				<label htmlFor='recipeId' className='p-col-fixed' style='width: 200px'>ID</label>
				<div className='p-col'>
					<InputText id='recipeId' type='text' v-model='recipeId' />
				</div>
			</div>
			<div className='p-field p-grid'>
				<label htmlFor='nodeVersion' className='p-col-fixed' style='width: 200px'>Node Version</label>
				<div className='p-col'>
					<InputText id='nodeVersion' type='text' v-model='nodeVersion' />
				</div>
			</div>
			<div className='p-field p-grid'>
				<label htmlFor='name' className='p-col-fixed' style='width: 200px'>Name</label>
				<div className='p-col'>
					<InputText id='name' type='text' v-model='name' />
				</div>
			</div>
			<div className='p-field p-grid'>
				<label htmlFor='description' className='p-col-fixed' style='width: 200px'>Description</label>
				<div className='p-col'>
					<InputText id='description' type='text' v-model='description' />
				</div>
			</div>
			<div className='p-field p-grid'>
				<label htmlFor='version' className='p-col-fixed' style='width: 200px'>Version</label>
				<div className='p-col'>
					<InputText id='version' type='text' v-model='version' />
				</div>
			</div>
			<br>
			<Button label='Submit' v-on:click='createCookbook()' :disabled='!address' />
		</Fieldset>
	</div>

</template>

<script>
import InputText from 'primevue/inputtext'
import Fieldset from 'primevue/fieldset'
import Button from 'primevue/button'

export default {
	name: 'Recipe',
	components: {
		InputText,
		Fieldset,
		Button
	},
	computed: {
		address: () => window.keplr.getKey('pylons')
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
