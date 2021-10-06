<template>
	<Sidebar v-model:visible="visible" :baseZIndex="1000">
		<h3>Pylons Menu</h3>
		<div class="card">
			<Menu :model="items" />
		</div>
	</Sidebar>
</template>
<script>
import Menu from 'primevue/menu/sfc'
import Sidebar from 'primevue/sidebar/sfc'

export default {
	name: 'SideBarComponent',
	components: { Menu, Sidebar },
	methods: {
		toggle : function(){
			this.visible = true
		}
	},
	data() {
		return {
			visible: false,
			items: [
				{
					label: 'Create a new Cookbook',
					icon: 'pi pi-book',
					command : () => {
						this.visible = false
						this.$router.push("/cookbook")
					},
				},
				{
					label: 'Create a new Recipe',
					icon: 'pi pi-file',
					command : () => {
						this.visible = false
						this.$router.push("/recipe")
					},
				}
			]
		}
	}
}
</script>
