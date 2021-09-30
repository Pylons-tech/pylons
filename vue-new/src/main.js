import { createApp } from 'vue'
import { MdButton, MdContent, MdTabs } from 'vue-material/dist/components'
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'

import App from './App.vue'

const app = createApp(App)
    .use(MdButton)
    .use(MdTabs)
    .use(MdContent)
app.mount('#app')
