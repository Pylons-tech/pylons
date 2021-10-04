<template>
	<div class='p-d-flex'>
		<div class="p-mr-2"><Button icon="pi pi-bars" @click="show" class="p-mr-2" /></div>
		<div class="p-mr-2">Pylons Application</div>
	</div>
	<div class="card">
		<Sidebar :visible="visibleLeft" :baseZIndex="1000">
			<h3>Pylons Menu</h3>
			<div class="card">
				<Menu id="overlay_menu" :model="items" />
			</div>
		</Sidebar>
	</div>

</template>
<script>
import Menu from 'primevue/menu/sfc'
import Sidebar from 'primevue/sidebar/sfc'
import Button from 'primevue/button'

export default {
	name: 'SideBarComponent',
	components: { Menu, Sidebar, Button},
	methods: {
		show : function() {
			this.visibleLeft = true
		}
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
	}
}
</script>
