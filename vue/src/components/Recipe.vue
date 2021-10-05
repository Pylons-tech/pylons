<!-- Based in https://cnpmjs.org/package/monaco-editor-vue3 -->
<template>
	<div class='card'>
		<MonacoEditor
			theme="vs"
			:options="options"
			language="javascript"
			:width="1000"
			:height="800"
			:value="value"
			v-model='code'
		></MonacoEditor>
	</div>
	<div class='card'>
		<Button label='Submit JSON' />
	</div>
</template>

<script>
import MonacoEditor from 'monaco-editor-vue3'
import Button from 'primevue/button'

export default {
	components: {
		MonacoEditor,
		Button
	},

	data(){
		return {
			options: {
				colorDecorators: true,
				lineHeight: 24,
				tabSize: 2
			},
			original: 'hello',
			value: 'world',
			width: 800,
			theme: 'vs',
			code: ''
		}
	},
}
</script>


