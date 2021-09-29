import { createRouter, createWebHistory } from 'vue-router'
import Index from '@/views/Index.vue'
import Cookbook from '@/views/Cookbook.vue'
import Relayers from '@/views/Relayers.vue'

const routerHistory = createWebHistory()
const routes = [
	{
		path: '/',
		component: Index
	},
	{ path: '/cookbook', component: Cookbook },
	{ path: '/relayers', component: Relayers }
]

const router = createRouter({
	history: routerHistory,
	routes
})

export default router
