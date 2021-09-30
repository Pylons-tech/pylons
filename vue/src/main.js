import { createApp } from 'vue'
import { createVuetify } from 'vuetify'
import App from './App.vue'
import router from './router'
import store from './store'

const vuetify = createVuetify() // Replaces new Vuetify(...)
const app = createApp(App).use(store).use(router).use(vuetify)

app.config.globalProperties._depsLoaded = true

app.mount('#app')
