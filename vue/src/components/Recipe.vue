<!-- Based in https://cnpmjs.org/package/monaco-editor-vue3 -->
<template>
	<div class="card">
		<MonacoEditor ref='editor' theme="vs" :options="options" language="javascript" v-model="code" @editorDidMount='editorDidMount'  :width="1000" :height="800" />
	</div>
	<div class="card">
		<Button label="Submit JSON" @click="submitJSON" />
	</div>
</template>

<script>
import MonacoEditor from 'monaco-editor-vue3'
import Button from 'primevue/button'
import { Recipe } from '@/store/generated/Pylons-tech/pylons/Pylonstech.pylons.pylons'

export default {
	components: {
		MonacoEditor,
		Button
	},
	methods: {
		editorDidMount(editor){
			editor.onDidChangeModelContent( e=> {
				this.setNewValue(editor.getValue())
			})
		},
		setNewValue(value){
			this.code = value
		},
		submitJSON() {
			const recipeObj = Recipe.fromJSON(JSON.parse(this.code))
			console.log(recipeObj)
			recipeObj.creator = this.$store.getters['common/wallet/address']
			this.$store.dispatch('Pylonstech.pylons.pylons/sendMsgCreateRecipe', {
				value: recipeObj,
				fee: [],
				memo: ''
			})
		},
	},
	data() {
		return {
			options: {
				colorDecorators: true,
				lineHeight: 24,
				tabSize: 2
			},
			original: '',
			value: '',
			width: 800,
			theme: 'vs',
			code: ''
		}
	}
}
</script>
