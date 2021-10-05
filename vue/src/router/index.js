import { createRouter, createWebHistory } from 'vue-router'
import Index from '@/views/Index.vue'
import Cookbook from '@/components/Cookbook'

const routerHistory = createWebHistory()
const routes = [
	{
		path: '/',
		component: Index
	},
	{
		path: '/cookbook',
		component: Cookbook
	}
]

const router = createRouter({
	history: routerHistory,
	routes
})

export default router
